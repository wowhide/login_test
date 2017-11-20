//
//  QrDeceasedInfoEditViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/15.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "QrDeceasedInfoEditViewController.h"
#import "DeceasedListViewController.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "Common.h"
#import "Define.h"
#import "Toast+UIView.h"
#import "HttpAccess.h"
#import "IndicatorWindow.h"
#import "Reachability.h"

@interface QrDeceasedInfoEditViewController () {
    Deceased *_deceased;
    UIImage *_photoImage;
    
    //ユーザーデフォルト
    NSUserDefaults *defaults;
    
    //会員番号
    NSString *memberId;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoSelectLabel;

@end

@implementation QrDeceasedInfoEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        defaults = [NSUserDefaults standardUserDefaults];  // 取得
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //会員番号を取得
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //DBからデータを取得
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    //取得
    _deceased = [deceasedDao selectDeceasedByDeceasedNo:self.deceasedNo];
    //DBを閉じる
    [memorialDatabase close];
    
    //取得した故人情報を画面に設定する
    //お名前
    self.nameLabel.text = [NSString stringWithFormat:@"%@　様", _deceased.deceased_name];
//    //写真選択
//    if (_deceased.deceased_photo_path.length > 0) {
//        self.photoSelectLabel.text = @"選択済";
//    }
    
    NSString *readpath_Image = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, _deceased.deceased_id];
    NSFileHandle *file_Image = [NSFileHandle fileHandleForReadingAtPath:readpath_Image];
    
    //写真ファイルが存在するか
    if (file_Image) {
        self.photoSelectLabel.text = @"選択済";
    }
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//保存ボタンクリック時
- (IBAction)saveButtonPushed:(id)sender {
    //画像を選択している場合、画像をドキュメントフォルダに保存し、ファイル名をDeceasedに設定する
    if (_photoImage != nil) {
        //ファイル名生成
//        NSString *saveFileName = [NSString stringWithFormat:@"%@.jpg",_deceased.deceased_id];
        //保存先パス生成
        NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, _deceased.deceased_id];
        
        //サイズを調整する
        CGFloat newSize = IMAGE_REDUCTION_SIZE;
        UIImage *resizeImage = [Common resizeImage:_photoImage toSize:newSize];
        
        //保存する（ファイルが存在する場合は上書きされる）
        NSData *data = UIImageJPEGRepresentation(resizeImage, 0.8);
        if ([data writeToFile:dataPath atomically:YES]) {
            //            NSLog(@"hozon:OK");
        } else {
            //            NSLog(@"hozon:NG");
            //エラーメッセージをダイアログ表示
            [self.view makeToast:@"保存に失敗しました。\nもう一度保存して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
            return;
        }
        
//        _deceased.deceased_photo_path = saveFileName;
    }
    
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    
    //DBに登録
    [deceasedDao updateDeceased:_deceased];
    
    //DBを閉じる
    [memorialDatabase close];
    
    //保存完了をトースト表示
    [self.view makeToast:@"保存が完了しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
    
    //1.5秒後前の上の階層に戻る
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(popView) userInfo:nil repeats:NO];
    
    
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    //    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    //    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    //    if (netStatus == NotReachable) {
    //        //圏外のときの処理
    //        //終了
    //        return;
    //
    //    }
    //
    //
    //    //インジケーター開始
    //    [IndicatorWindow openWindow];
    //
    //    //別のスレッドでファイル読み込みをキューに加える
    //    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
    //                                        initWithTarget:self
    //                                        selector:@selector(uploadData)
    //                                        object:nil];
    //    NSOperationQueue *queue = [NSOperationQueue new];
    //    [queue addOperation:operation];
    //
    
}


-(void)popView
{
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//写真を変更するボタンクリック時、イメージピッカーを表示する
- (IBAction)photoSelectButtonPushed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//イメージピッカーのイメージ取得時
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //イメージを取得する
    _photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //ラベルに選択済を設定
    self.photoSelectLabel.text = @"選択済";
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//イメージピッカーのキャンセル時
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadData
{
    //DBからデータを取得
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    //取得
    _deceased = [deceasedDao selectDeceasedByDeceasedNo:self.deceasedNo];
    //DBを閉じる
    [memorialDatabase close];
    
    //ファイルが存在する場合、ファイルをアップロードする
    NSString *savephoto_urlAsString = UPLOAD_QR_DECEASED_PHOTO;
    
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
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"deceased_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[memberId dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"deceased_birthday\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[_deceased.deceased_birthday dataUsingEncoding:NSUTF8StringEncoding]];
    
    //写真を設定
    NSData* imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(_photoImage, 1.0)];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@\"\r\n", memberId] dataUsingEncoding:NSUTF8StringEncoding]];
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
        
        //ダイアログ表示
        [self.view makeToast:@"保存が完了しました" duration:TOAST_DURATION_ERROR position:@"center"];
        
        
        if ([photoUpResult isEqualToString:@"NO"]) {
            //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
            //                                                [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
            return;
        }
    } else {
        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
        //                                        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
        return;
    }
    
    
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
