//
//  DataTakeInViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/28.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "DataTakeInViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "InputValidataion.h"
#import "DatabaseHelper.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "User.h"
#import "UserDao.h"
#import "Notice.h"
#import "NoticeDao.h"
#import "Define.h"
#import "IndicatorWindow.h"
#import "HttpAccess.h"


@interface DataTakeInViewController () {
    int downloadCount;
    UITextField *_textField;
    NSUserDefaults *userDefaults;
    NSString *memberId;
    NSString *appliid;
}

@end

@implementation DataTakeInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    

    
    //キーボード閉じるボタン用ツールバーを生成
    UIToolbar *closeBar = [[UIToolbar alloc] init];
    //スタイルの設定
    closeBar.barStyle = UIBarStyleDefault;
    //ツールバーを画面サイズに合わせる
    [closeBar sizeToFit];
    //「完了」ボタンを右端に配置したいためフレキシブルなスペースを作成する。
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //完了ボタンの生成
    UIBarButtonItem *_commitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSoftKeyboard)];
    //ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn, nil];
    //表示・非表示の設定
    [closeBar setItems:toolBarItems animated:YES];
    //ToolbarをTextViewのinputAccessoryViewに設定
    
//    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
//    // キーボード表示時
//    [notification addObserver:self selector:@selector(keyboardWillShow:)
//						 name: UIKeyboardWillShowNotification object:nil];
//    // キーボード非表示時
//	[notification addObserver:self selector:@selector(keyboardWillHide:)
//						 name: UIKeyboardWillHideNotification object:nil];
}


-(void)viewDidAppear:(BOOL)animated{
    
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //接続できない場合
        [self.view makeToast:@"ネットワークに接続できる環境でダウンロードして下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    userDefaults = [NSUserDefaults standardUserDefaults];                           // 取得
    memberId  = [userDefaults stringForKey:KEY_MEMBER_USER_ID];                     // USER_IDの内容を取得
    appliid = [userDefaults stringForKey:KEY_MEMBER_APPLI_ID];                      // KEY_MEMBER_APPLI_IDの内容を取得

    //アクセスキーを取得(会員番号)
    NSString *accessKey = memberId;
//    NSString *accessKey = appliid;
    
    //アクセスキーの入力チェック
    NSString *errorMessage = [InputValidataion checkDataTakeIn:accessKey];
    if ([errorMessage length] > 0) {
        //エラーメッセージをダイアログ表示
        [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    //アクセスキーを取得されている場合、ダウンロードを実行する
    //インジケーター開始
    [IndicatorWindow openWindow];
    
    //別スレッドでダウンロードを実行する
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(downloadData:)
                                        object:accessKey];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];
    
}

//ダウンロードボタンクリック時
- (IBAction)downloadButtonPushed:(id)sender {

}


- (void)downloadData:(NSString *)accessKey
{
    //リクエスト先を指定する
    NSString *datatakein_urlAsString = READ_TRANSFER_DATA;

    NSURL *datatakein_url = [NSURL URLWithString:datatakein_urlAsString];
    
    //POSTメソッドのHTTPリクエストを生成する
    NSMutableURLRequest *datatakein_urlRequest = [NSMutableURLRequest requestWithURL:datatakein_url];
    [datatakein_urlRequest setHTTPMethod:@"POST"];
    
    //パラメータを付与
    NSString *datatakein_body = [NSString stringWithFormat:@"datakey=%@&certification=key",appliid];
    
    [datatakein_urlRequest setHTTPBody:[datatakein_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *datatakein_response;
    NSError *datatakein_error = nil;
    
    //HTTP同期通信を実行
    NSData *dataTakeInJsonData = [NSURLConnection sendSynchronousRequest:datatakein_urlRequest returningResponse:&datatakein_response error:&datatakein_error];
    
    //データを取得
    if (dataTakeInJsonData && datatakein_response.statusCode == 200) {
        
        //データが存在しない場合、エラーメッセージを表示して終了
        if ((dataTakeInJsonData.length > 0) == NO ) {
            //メインスレッドのインディケーターを閉じるを実行
            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データを正しく取得できませんでした。" waitUntilDone:NO];
            return;
        }
        
        //JSONのデータを読み込む
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:dataTakeInJsonData options:NSJSONReadingAllowFragments error:&datatakein_error];
        
        //故人情報取得
        NSDictionary *jsonDeceasedObject = [jsonObject objectForKey:@"deceased"];
//NSLog(@"jsonDeceasedObject:%@",[jsonDeceasedObject description]);

        //通知先情報取得
//        NSDictionary *jsonNoticeObject = [jsonObject objectForKey:@"notice"];
//NSLog(@"jsonNoticeObject:%@",[jsonNoticeObject description]);

        //DBに接続
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        //トランザクションを開始する
        [memorialDatabase beginTransaction];

        //故人情報を削除する
        DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
        //写真が存在する場合、削除する
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        NSMutableArray *tempDeceaseds = [deceasedDao selectDeceased];
        for (Deceased *deceased in tempDeceaseds) {
            if (deceased.deceased_photo_path.length > 0) {
                //保存先パス取得
                NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, deceased.deceased_photo_path];
                //ファイルの存在チェック
                if ([fileManager fileExistsAtPath:dataPath]) {
                    //存在する場合、削除
                    [fileManager removeItemAtPath:dataPath error:NULL];
                }
            }
        }
        if (![deceasedDao deleteDeceasedAll]) {
            //DBをロールバック
            [memorialDatabase rollback];
            //DBを閉じる
            [memorialDatabase close];
            //メインスレッドのインディケーターを閉じるを実行
            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"ダウンロードに失敗しました。\nもう一度ダウンロードして下さい。" waitUntilDone:NO];
            return;
        }
        
        //故人情報を保存
        NSMutableArray *deceaseds = [NSMutableArray array];
        for (NSDictionary *dObj in jsonDeceasedObject)
        {
            Deceased *deceased = [[Deceased alloc] init];
            deceased.deceased_no = [[dObj objectForKey:@"deceased_no"] intValue];
            deceased.deceased_id = [dObj objectForKey:@"deceased_id"];
            deceased.qr_flg = [[dObj objectForKey:@"qr_flg"] intValue];
            deceased.deceased_name = [dObj objectForKey:@"deceased_name"];
            deceased.deceased_birthday = [dObj objectForKey:@"deceased_birthday"];
            deceased.deceased_deathday = [dObj objectForKey:@"deceased_deathday"];
            deceased.kyonen_gyonen_flg = [[dObj objectForKey:@"kyonen_gyonen_flg"] intValue];
            deceased.death_age = [[dObj objectForKey:@"death_age"] intValue];
            deceased.deceased_photo_path = [dObj objectForKey:@"deceased_photo_path"];
            deceased.entry_datetime = [dObj objectForKey:@"entry_datetime"];
            deceased.timestamp = [dObj objectForKey:@"timestamp"];
            if (![deceasedDao insertDeceasedTakeIn:deceased]) {
                //DBをロールバック
                [memorialDatabase rollback];
                //DBを閉じる
                [memorialDatabase close];
                //メインスレッドのインディケーターを閉じるを実行
                [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"ダウンロードに失敗しました。\nもう一度ダウンロードして下さい。" waitUntilDone:NO];
                return;
            }
            [deceaseds addObject:deceased];
            
            //デバイストークンと故人IDをサーバーのDBに保存する
            //デバイストークンを取得
            userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *strToken = [userDefaults stringForKey:KEY_DEVICE_TOKEN];
            
            //リクエスト先を指定する
            NSString *deviceToken_urlAsString = SAVE_DEVICE_TOKEN_AND_DECEASED_ID;
            NSURL *deviceToken_url = [NSURL URLWithString:deviceToken_urlAsString];
            //POSTメソッドのHTTPリクエストを生成する
            NSMutableURLRequest *deviceToken_urlRequest = [NSMutableURLRequest requestWithURL:deviceToken_url];
            [deviceToken_urlRequest setHTTPMethod:@"POST"];
            //パラメータを付与
            NSString *deviceToken_body = [NSString stringWithFormat:@"device_token=%@&deceased_id=%@",strToken, deceased.deceased_id];
            [deviceToken_urlRequest setHTTPBody:[deviceToken_body dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSHTTPURLResponse *deviceToken_response;
            NSError *deviceToken_error = nil;
            
            //HTTP同期通信を実行
            NSData *deviceTokenResult = [NSURLConnection sendSynchronousRequest:deviceToken_urlRequest returningResponse:&deviceToken_response error:&deviceToken_error];
            
            //デバイストークンをサーバーに保存
            if (deviceTokenResult && deviceToken_response.statusCode == 200) {
                //成功
            } else {
                //失敗
            }

            
        }
        


        //DBをコミット
        [memorialDatabase commit];
        //DBを閉じる
        [memorialDatabase close];
        
        //ダウンロードカウントをリセット
//        downloadCount = 0;
//        for (Deceased *deceased in deceaseds) {
//            //画像ファイルが存在する場合、ダウンロードする
//            if (deceased.deceased_photo_path.length > 0) {
//                //ダウンロードカウントをインクリメント
//                downloadCount++;
//            }
//        }

        for (Deceased *deceased in deceaseds) {
            //画像ファイルが存在する場合、ダウンロードする
            if (deceased.deceased_photo_path.length > 0) {
                
                if(deceased.qr_flg == 1){
                    //故人写真を取得
                    //読み込むファイルの URL を作成
                    NSString *downloadphoto_urlAsString = [NSString stringWithFormat:[DOWNLOAD_QR_PHOTO stringByAppendingString:@"?appli_id=%@&deathday=%@&birthday=%@&filename=%@"], appliid, deceased.deceased_deathday,deceased.deceased_birthday,deceased.deceased_photo_path];
                    
                    NSURL *downloadphoto_url = [NSURL URLWithString:downloadphoto_urlAsString];
                    //引数の生成
                    NSArray *loadImageArgArray = [NSArray arrayWithObjects:downloadphoto_url, deceased.deceased_photo_path, nil];
                    
                    //メインスレッドのファイル読み込みを実行
                    [self performSelectorOnMainThread:@selector(loadImage:) withObject:loadImageArgArray waitUntilDone:NO];
                    
                }

            }
        }
        
  

        //ダウンロード成功の場合、トップメニューを表示
        [self.delegate hideDataTakeInView:self];
        
        
    } else {
        //メインスレッドのインディケーターを閉じるを実行
        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"ダウンロードに失敗しました。\nもう一度ダウンロードして下さい。" waitUntilDone:NO];
    }
}

//画像ファイル読み込み
- (void)loadImage:(NSArray *)loardImageArgArray
{
    //引数を取得
    NSURL *downloadphoto_url = loardImageArgArray[0];
    NSString *deceasedPhotoPath = loardImageArgArray[1];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:downloadphoto_url];
    //引数の生成
    NSArray *saveImageArgArray = [NSArray arrayWithObjects:imageData, deceasedPhotoPath, nil];
    //画像ファイルを保存
    [self saveImage:saveImageArgArray];
}

//ローカルにデータを保存
- (void)saveImage:(NSArray *)saveImageArgArray
{
    //引数を取得
    NSData *imageData = saveImageArgArray[0];
    NSString *saveFileName = saveImageArgArray[1];
    
    //保存先パス生成
    NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, saveFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    if (success) {
        imageData = [NSData dataWithContentsOfFile:dataPath];
    } else {
        [imageData writeToFile:dataPath atomically:YES];
    }

    //ダウンロードカウンタから-1
    downloadCount--;
    //ダウンロードカウンタが0になったらインディケーターを閉じて画面遷移
    if (downloadCount == 0) {
        
        //上の階層に戻る
        self.navigationController.tabBarController.selectedIndex = 0;
    }
}

- (void)closeIndicatorAndErrorMessage:(NSString *)errorMessage
{
    [self closeIndicator];
    
    //エラートースト表示
    [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
}

//インディケーターを閉じる
- (void)closeIndicator
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];

    //画面操作を許可する
//    self.view.userInteractionEnabled=YES;
//    self.toolBar.userInteractionEnabled = YES;
//    self.takeinScroll.userInteractionEnabled = YES;
//    self.takeinScrollView.userInteractionEnabled = YES;
    
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    
    [self.delegate hideDataTakeInView:self];

}

//編集中のTextFieldを保持
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return YES;
}

////キーボード表示時
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    NSDictionary *userInfo = [notification userInfo];
//    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//    
//    if([_textField isFirstResponder])
//    {
//        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(keyboardRect), 0.0);
//        self.takeinScroll.contentInset = contentInsets;
//        self.takeinScroll.scrollIndicatorInsets = contentInsets;
//        
//        CGPoint pt = [self.takeinScroll convertPoint:_textField.frame.origin toView:self.view];
//        
//        if(CGRectGetMinY(keyboardRect) < pt.y)
//        {
//            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height);
//            [self.takeinScroll setContentOffset:scrollPoint animated:YES];
//        }
//    }
//}

////キーボード非表示時
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    if([_textField isFirstResponder])
//    {
//        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
//        self.takeinScroll.contentInset = contentInsets;
//        self.takeinScroll.scrollIndicatorInsets = contentInsets;
//    }
//}

//テキストフィールドでエンターキーがクリックされた場合にキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// キーボードを隠す処理
- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
