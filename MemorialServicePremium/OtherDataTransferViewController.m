//
//  OtherDataTransferViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/21.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "OtherDataTransferViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "User.h"
#import "UserDao.h"
#import "Mortician.h"
#import "MorticianDao.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "Notice.h"
#import "NoticeDao.h"
#import "Define.h"
#import "DataTransferViewController.h"
#import "IndicatorWindow.h"
#import "DataTakeInViewController.h"
#import "HttpAccess.h"

@interface OtherDataTransferViewController () {
    NSString *_dataKey;
    NSString *memberId;
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *transferScroll;
@property (weak, nonatomic) IBOutlet UIView *transferScrollView;

@property (weak, nonatomic) IBOutlet UITextView *transferTextView;

@end

@implementation OtherDataTransferViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        defaults = [NSUserDefaults standardUserDefaults];  // ユーザーデフォルト
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];  // 会員番号取得
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];

    //UIScrollViewのコンテンツサイズを設定
    self.transferScroll.contentSize = self.transferScrollView.bounds.size;
    //スクロールバーを表示
    self.transferScroll.showsVerticalScrollIndicator = YES;
    
    //データ引き継ぎ方法を表示
    NSString* sentenceTransfer = [[NSBundle mainBundle] localizedStringForKey:@"sentence_transfer" value:nil table:LOCALIZE_FILE];
    
    self.transferTextView.text = [self.transferTextView.text stringByAppendingString:sentenceTransfer];
    
    //データ引き継ぎ方法の文字サイズを指定
    [self.transferTextView setFont:[UIFont systemFontOfSize:17]];
    
    //データ引き継ぎ方法の背景色を指定
    self.transferTextView.backgroundColor = [UIColor colorWithRed:TEXTVIEW_BG_COLOR_RED green:TEXTVIEW_BG_COLOR_GREEN blue:TEXTVIEW_BG_COLOR_BLUE alpha:1.0];
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//データ引き継ぎボタンクリック時
- (IBAction)transferButtonPushed:(id)sender {
    //メッセージを作成
    NSString *appName = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleDisplayName"];
    NSString *message = [NSString stringWithFormat:@"データ引き継ぎのため%@アプリのデータをサーバーにアップロードします。\nよろしいですか？", appName];
    //データ引き継ぎ確認アラートを表示する
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    //アラート表示
    [alert show];
}

//データ取り込みボタンクリック時
- (IBAction)takeinButtonPushed:(id)sender {
    //データ引き継ぎ画面のインスタンスを生成
    DataTakeInViewController *dataTakeInViewController = [[DataTakeInViewController alloc] init];
    //データ引き継ぎ画面に遷移
    [self.navigationController pushViewController:dataTakeInViewController animated:YES];
}

//アラートボタンクリック時の処理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //「はい」ボタンがクリックされた場合
    if (1 == buttonIndex) {

        //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
        Reachability *curReach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            //圏外のときの処理
            [self.view makeToast:@"ネットワークに接続できる環境でアップロードして下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
            return;
        }

        //画面操作を禁止する
        self.view.userInteractionEnabled = NO;
        self.toolBar.userInteractionEnabled = NO;
        self.transferScroll.userInteractionEnabled = NO;
        self.transferScrollView.userInteractionEnabled = NO;

        //インジケーター開始
        [IndicatorWindow openWindow];
        
        
//        //起動時ポイント自動付与
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];   // 取得
//        memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];      // 会員番号
//        
//        //利用者IDを取得している場合、ポイント付与
//        if ([memberId length]) {
//            HttpAccess *httpAccess = [HttpAccess new];
//            NSString *parameter = userid;
//            [httpAccess get:POINT_ADD_USER4 param:parameter];
//        }
    
        
        //別のスレッドでファイル読み込みをキューに加える
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(uploadData)
                                            object:nil];
        NSOperationQueue *queue = [NSOperationQueue new];
        [queue addOperation:operation];
        

    } else {
        //「いいえ」が選択された場合、何もしない
    }
}

- (void)uploadData
{
    //DBのデータを取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //利用者
    UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userDao selectUser];
    //故人
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    NSMutableArray *deceaseds = [deceasedDao selectDeceased];
    //通知先
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    NSMutableArray *notices = [noticeDao selectNotice];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    //取得したデータをJSON形式に変換
    NSError *error;
    

    
    //利用者
    NSMutableDictionary *userNsmd = [NSMutableDictionary dictionary];
    [userNsmd setValue:user.mail_address forKey:@"mail_address"];
    [userNsmd setValue:user.name forKey:@"name"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_month_deathday_before] forKey:@"notice_month_deathday_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_month_deathday] forKey:@"notice_month_deathday"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_deathday_1week_before] forKey:@"notice_deathday_1week_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_deathday_before] forKey:@"notice_deathday_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_deathday] forKey:@"notice_deathday"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_memorial_3month_before] forKey:@"notice_memorial_3month_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_memorial_1month_before] forKey:@"notice_memorial_1month_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_memorial_1week_before] forKey:@"notice_memorial_1week_before"];
    [userNsmd setValue:memberId forKey:@"point_user_id"];
    [userNsmd setValue:user.notice_time forKey:@"notice_time"];
    [userNsmd setValue:user.install_datetime forKey:@"install_datetime"];
    [userNsmd setValue:user.entry_datetime forKey:@"entry_datetime"];
    NSData *userJson =
    [NSJSONSerialization dataWithJSONObject:userNsmd
                                    options:kNilOptions error:&error];
    
    //故人
    NSMutableArray *deceasedsNsma = [[NSMutableArray alloc] init];
    for (Deceased *deceased in deceaseds) {
        NSMutableDictionary *deceasedNsmd = [NSMutableDictionary dictionary];
        [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.deceased_no] forKey:@"deceased_no"];
        [deceasedNsmd setValue:deceased.deceased_id forKey:@"deceased_id"];
        [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.qr_flg] forKey:@"qr_flg"];
        [deceasedNsmd setValue:deceased.deceased_name forKey:@"deceased_name"];
        [deceasedNsmd setValue:deceased.deceased_birthday forKey:@"deceased_birthday"];
        [deceasedNsmd setValue:deceased.deceased_deathday forKey:@"deceased_deathday"];
        [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.kyonen_gyonen_flg] forKey:@"kyonen_gyonen_flg"];
        [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.death_age] forKey:@"death_age"];
        [deceasedNsmd setValue:deceased.deceased_photo_path forKey:@"deceased_photo_path"];
        [deceasedNsmd setValue:deceased.entry_datetime forKey:@"entry_datetime"];
        [deceasedNsmd setValue:deceased.timestamp forKey:@"timestamp"];
        [deceasedsNsma addObject:deceasedNsmd];
    }
    NSData *deceasedJson =
    [NSJSONSerialization dataWithJSONObject:deceasedsNsma
                                    options:kNilOptions error:&error];
    
    //通知先
    NSMutableArray *noticesNsma = [[NSMutableArray alloc] init];
    for (Notice *notice in notices) {
        NSMutableDictionary *noticeNsmd = [NSMutableDictionary dictionary];
        [noticeNsmd setValue:[NSString stringWithFormat:@"%d", notice.deceased_no] forKey:@"deceased_no"];
        [noticeNsmd setValue:[NSString stringWithFormat:@"%d", notice.notice_no] forKey:@"notice_no"];
        [noticeNsmd setValue:notice.notice_name forKey:@"notice_name"];
        [noticeNsmd setValue:notice.notice_address forKey:@"notice_address"];
        [noticeNsmd setValue:notice.entry_datetime forKey:@"entry_datetime"];
        [noticesNsma addObject:noticeNsmd];
    }
    NSData *noticeJson =
    [NSJSONSerialization dataWithJSONObject:noticesNsma
                                    options:kNilOptions error:&error];
    
    //DBデーターアップロード
    //リクエスト先を指定する
    NSString *saveuserdata_urlAsString = SAVE_TRANSFER_DATA;
    NSURL *saveuserdata_url = [NSURL URLWithString:saveuserdata_urlAsString];
    
    //POSTメソッドのHTTPリクエストを生成する
    NSMutableURLRequest *saveuserdata_urlRequest = [NSMutableURLRequest requestWithURL:saveuserdata_url];
    [saveuserdata_urlRequest setHTTPMethod:@"POST"];
    //パラメータを付与
    NSString *saveuserdata_body = [NSString stringWithFormat:@"user=%@&deceased=%@&notice=%@&certification=key",
                                   [[NSString alloc] initWithData:userJson encoding:NSUTF8StringEncoding],
                                   [[NSString alloc] initWithData:deceasedJson encoding:NSUTF8StringEncoding],
                                   [[NSString alloc] initWithData:noticeJson encoding:NSUTF8StringEncoding]
                                   ];
    [saveuserdata_urlRequest setHTTPBody:[saveuserdata_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *saveuserdata_response;
    NSError *saveuserdata_error = nil;
    
    //HTTP同期通信を実行
    NSData *saveUserDataResult = [NSURLConnection sendSynchronousRequest:saveuserdata_urlRequest returningResponse:&saveuserdata_response error:&saveuserdata_error];
    
    //故人情報保存結果(データーキー)を取得
    if (saveUserDataResult && saveuserdata_response.statusCode == 200) {
        _dataKey = [[NSString alloc] initWithData:saveUserDataResult encoding:NSUTF8StringEncoding];
//        NSLog(@"dataKey=%@", _dataKey);
        if (_dataKey.length == 0) {
            //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
            return;
        }
    } else {
        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
        return;
    }
    
    //写真アップロード
    for (Deceased *deceased in deceaseds) {
        //画像ファイル名が設定されているか
        
        if (deceased.deceased_photo_path.length > 0) {
            //設定されている場合、ファイルが存在するか
            //ファイルパス取得
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, deceased.deceased_photo_path];
            // ファイルマネージャを作成
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:filePath]) {
                //ファイルが存在する場合、ファイルをアップロードする
                NSString *savephoto_urlAsString = UP_PHOTO;
                NSURL *savephoto_url = [NSURL URLWithString:savephoto_urlAsString];
                
                //POSTメソッドのHTTPリクエストを生成する
                NSMutableURLRequest *savephoto_urlRequest = [NSMutableURLRequest requestWithURL:savephoto_url];
                
                //リクエストヘッダの作成
                NSString *stringBoundary = @"Ns794C3Hi4DLrPuR";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
                [savephoto_urlRequest setHTTPMethod:@"POST"];
                [savephoto_urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                //POSTするデータ
                NSMutableData *postBody = [NSMutableData data];
                
                //データーキーを設定
                [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"datakey\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postBody appendData:[_dataKey dataUsingEncoding:NSUTF8StringEncoding]];
                
                //写真を設定
                NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, deceased.deceased_photo_path];
                UIImage *image= [[UIImage alloc] initWithContentsOfFile:dataPath];
                NSData* imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)];
                [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@\"\r\n", deceased.deceased_photo_path] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:imageData];
                [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [savephoto_urlRequest setHTTPBody:postBody];
                
                NSHTTPURLResponse *savephoto_response;
                NSError *savephoto_error = nil;
                
                //HTTP同期通信を実行
                NSData *savePhotoResult = [NSURLConnection sendSynchronousRequest:savephoto_urlRequest returningResponse:&savephoto_response error:&savephoto_error];
                
                //写真アップロード結果を取得
                NSString *photoUpResult;
                if (savePhotoResult && savephoto_response.statusCode == 200) {
                    photoUpResult = [[NSString alloc] initWithData:savePhotoResult encoding:NSUTF8StringEncoding];
                    if ([photoUpResult isEqualToString:@"NO"]) {
                        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
                        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
                        return;
                    }
                } else {
                    //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
                    [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
                    return;
                }
            }
        }
    }
    [self closeIndicator];
    //データ引き継ぎ完了画面のインスタンスを生成
    DataTransferViewController *dataTransferViewController = [[DataTransferViewController alloc] init];
    dataTransferViewController.dataKey = _dataKey;
    //データ引き継ぎ完了画面に遷移
    [self.navigationController pushViewController:dataTransferViewController animated:YES];

}

//エラーメッセージを表示してインジケーターを閉じる
- (void)closeIndicatorAndErrorMessage:(NSString *)errorMessage
{
    [self closeIndicator];

    //エラートースト表示
    [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
}

//インジケーターを閉じる
- (void)closeIndicator
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    
    //画面操作を許可する
    self.view.userInteractionEnabled=YES;
    self.toolBar.userInteractionEnabled = YES;
    self.transferScroll.userInteractionEnabled = YES;
    self.transferScrollView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
