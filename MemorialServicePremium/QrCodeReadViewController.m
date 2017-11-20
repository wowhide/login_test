//
//  QrCodeReadViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/21.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "QrCodeReadViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "DatabaseHelper.h"
#import "Mortician.h"
#import "MorticianDao.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "User.h"
#import "UserDao.h"
#import "Define.h"
#import "Common.h"
#import "IndicatorWindow.h"
#import "PointUser.h"
#import "HttpAccess.h"

@interface QrCodeReadViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    NSString *_deceasedId;
    NSString *userid;
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet UIView *qrReadView;

@end

@implementation QrCodeReadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        defaults = [NSUserDefaults standardUserDefaults];
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
//    self.toolBar.tintColor = [UIColor whiteColor];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userid = [defaults stringForKey:USER_ID];  // USER_IDの内容をNSString型として取得
    //故人一覧をDBから削除
    HttpAccess *httpAccess = [HttpAccess new];
    NSString *parameter = userid;
    [httpAccess deletedataKey:DELETE_DECEASED_ID param:parameter];
    
    //カメラ用のViewに枠を設定
    [self.qrReadView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.qrReadView.layer setBorderWidth:1.0f];
    
    //カメラを開始する
    [self startSession];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    NSString *qrcode;
    BOOL qrReadFlg = NO;
    
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            //カメラを終了する
            [self stopSession];
            
            //複数の QR があっても1度で読み取れている
            qrcode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
//            NSLog(@"%@", qrcode);
            qrReadFlg = YES;
            
            break;
        }
    }
    
    if (qrReadFlg == YES) {
        //読み込んだQRコードを会員番号とアプリIDに分ける
        NSArray* values = [qrcode componentsSeparatedByString:@","];
        //フォーマットが合っているかチェック
        if (values.count != 2) {
            [self.view makeToast:@"このQRコードは当アプリに対応していません。" duration:TOAST_DURATION_ERROR position:@"center"];
            //トースト表示終了後、カメラを再起動する
            [NSTimer scheduledTimerWithTimeInterval:TOAST_DURATION_ERROR target:self selector:@selector(startSession) userInfo:nil repeats:NO];
            return;
        }
        
        
        [self.view makeToast:@"データの読み込みが完了しました。" duration:TOAST_DURATION_ERROR position:@"center"];
        
        
        //故人ID、故人名を取得
        _deceasedId = [values objectAtIndex:0];
//        NSString *deceasedName = [values objectAtIndex:1];
        
//        NSString *alertTitle;
//        NSString *alertMessage;
//        if (self.fromView == QR_READ_VIEW_FROM_INITIAL_SETTING) {
//            alertTitle = [NSString stringWithFormat:@"のデータを読み込みます。\nよろしいですか？"];
//            alertMessage = @"";
//        } else if (self.fromView == QR_READ_VIEW_FROM_DECEASED_LIST) {
//            alertTitle = [NSString stringWithFormat:@"データを追加します。\nよろしいですか？"];
////            alertMessage = @"※葬儀社情報に変更がある場合、葬儀社の情報も更新されます。";
//            alertMessage = @"";
//        }
//
        //デバイストークンを取得
        NSUserDefaults *userDefaults;
        userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *strToken = [userDefaults stringForKey:KEY_DEVICE_TOKEN];
        
        //リクエスト先を指定する
        NSString *deviceToken_urlAsString = SAVE_DEVICE_TOKEN_AND_DECEASED_ID;
        NSURL *deviceToken_url = [NSURL URLWithString:deviceToken_urlAsString];
        //POSTメソッドのHTTPリクエストを生成する
        NSMutableURLRequest *deviceToken_urlRequest = [NSMutableURLRequest requestWithURL:deviceToken_url];
        [deviceToken_urlRequest setHTTPMethod:@"POST"];
        //パラメータを付与
        NSString *deviceToken_body = [NSString stringWithFormat:@"device_token=%@&deceased_id=%@",strToken, _deceasedId];
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

       
        [defaults setObject:_deceasedId forKey:USER_ID];  // ユーザーデフォルト_user_id_更新
        [defaults setBool:YES forKey:@"KEY_DOWNLOAD"];
        [defaults synchronize];
        
        
        //カメラを終了する
        [self stopSession];
        
        
//        [NSTimer scheduledTimerWithTimeInterval:15.f target:self selector:@selector(hideQrRead) userInfo:nil repeats:NO];



        //データ追加確認アラートを表示する
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
        //アラート表示
//        [alert show];
    }
}



//アラートボタンクリック時の処理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //圏外のときの処理
        [self.view makeToast:@"ネットワークに接続できる環境で読み込んで下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

    //「はい」ボタンがクリックされた場合
    if (1 == buttonIndex) {
        //「はい」が選択された場合、データをダウンロードして保存する
        //画面操作を禁止する
        self.view.userInteractionEnabled = NO;
        self.toolBar.userInteractionEnabled = NO;
        
        //インジケーター開始
        [IndicatorWindow openWindow];
        
        //別のスレッドで故人データダウンロードを実行する
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self
                                            selector:@selector(downloadDeceasedData:)
                                            object:_deceasedId];
        NSOperationQueue *queue = [NSOperationQueue new];
        [queue addOperation:operation];
    } else {
        //「いいえ」が選択された場合、0.4秒後カメラを再開する
        [NSTimer scheduledTimerWithTimeInterval:CAMERA_RESTART_DURATION target:self selector:@selector(startSession) userInfo:nil repeats:NO];
    }
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //カメラを終了する
    [self stopSession];
    //親画面のデリゲート処理を実行
    [self.delegate hideQrCodeReadView:NO];
}

//カメラの準備
- (void)startSession {
    self.session = [[AVCaptureSession alloc] init];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *device = nil;
    AVCaptureDevicePosition camera = AVCaptureDevicePositionBack; // Back or Front
    for (AVCaptureDevice *d in devices) {
        device = d;
        if (d.position == camera) {
            break;
        }
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    [self.session addInput:input];
    
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    
    // QR コードのみ
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    [self.session startRunning];
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.frame = self.qrReadView.bounds;
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.qrReadView.layer addSublayer:preview];
}

//カメラを終了する
- (void)stopSession {
    [self.session stopRunning];
    for (AVCaptureOutput *output in self.session.outputs) {
        [self.session removeOutput:output];
    }
    for (AVCaptureInput *input in self.session.inputs) {
        [self.session removeInput:input];
    }
    self.session = nil;
}

- (void)downloadDeceasedData:(NSString *)deceasedId
{

    @try {
        //故人情報を取得する
        //リクエスト先を指定する
        NSString *readdeceaseddata_urlAsString = READ_DECEASED_DATA;
        NSURL *readdeceaseddata_url = [NSURL URLWithString:readdeceaseddata_urlAsString];
    
        //POSTメソッドのHTTPリクエストを生成する
        NSMutableURLRequest *readdeceaseddata_urlRequest = [NSMutableURLRequest requestWithURL:readdeceaseddata_url];
        [readdeceaseddata_urlRequest setHTTPMethod:@"POST"];
        //パラメータを付与
        NSString *readdeceaseddata_body = [@"deceasedId=" stringByAppendingString:deceasedId];

        [readdeceaseddata_urlRequest setHTTPBody:[readdeceaseddata_body dataUsingEncoding:NSUTF8StringEncoding]];
    
        NSHTTPURLResponse *readdeceaseddata_response;
        NSError *readdeceaseddata_error = nil;
    
        //HTTP同期通信を実行
        NSData *deceasedJsonData = [NSURLConnection sendSynchronousRequest:readdeceaseddata_urlRequest returningResponse:&readdeceaseddata_response error:&readdeceaseddata_error];

        //データを取得
        if (deceasedJsonData && readdeceaseddata_response.statusCode == 200) {

            NSString *deceasedJsonDataString = [[NSString alloc] initWithData:deceasedJsonData encoding:NSUTF8StringEncoding];

            //データが存在しない場合、エラーメッセージを表示して終了
            if ([deceasedJsonDataString isEqualToString:@"false"]) {
                [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"QRコードが無効です。" waitUntilDone:NO];
                return;
            }

            //JSONのデータを読み込む
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:deceasedJsonData options:NSJSONReadingAllowFragments error:&readdeceaseddata_error];

            //現在日時を文字列で取得
            NSString *now = [Common getDateString:@"yyyyMMddHHmmss"];

            //DBに接続
            DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
            FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
            [memorialDatabase beginTransaction];

            //JSONデータから故人情報を取得
            Deceased *deceased = [[Deceased alloc] init];
            deceased.deceased_id = [jsonObject objectForKey:@"deceased_id"];
            deceased.qr_flg = 1;
            deceased.deceased_name = [jsonObject objectForKey:@"deceased_name"];
            deceased.deceased_birthday = [jsonObject objectForKey:@"deceased_birthday"];
            deceased.deceased_deathday = [jsonObject objectForKey:@"deceased_deathday"];
            deceased.kyonen_gyonen_flg = [[jsonObject objectForKey:@"kyonen_gyonen_flg"] intValue];
            deceased.death_age = [[jsonObject objectForKey:@"death_age"] intValue];
            deceased.deceased_photo_path = [jsonObject objectForKey:@"deceased_photo_path"];
            deceased.entry_datetime = now;
            deceased.timestamp = now;
            
            //デバイストークンと故人IDをサーバーのDBに保存する
//            //デバイストークンを取得
//            NSUserDefaults *userDefaults;
//            userDefaults = [NSUserDefaults standardUserDefaults];
//            NSString *strToken = [userDefaults stringForKey:KEY_DEVICE_TOKEN];
//
//            //リクエスト先を指定する
//            NSString *deviceToken_urlAsString = SAVE_DEVICE_TOKEN_AND_DECEASED_ID;
//            NSURL *deviceToken_url = [NSURL URLWithString:deviceToken_urlAsString];
//            //POSTメソッドのHTTPリクエストを生成する
//            NSMutableURLRequest *deviceToken_urlRequest = [NSMutableURLRequest requestWithURL:deviceToken_url];
//            [deviceToken_urlRequest setHTTPMethod:@"POST"];
//            //パラメータを付与
//            NSString *deviceToken_body = [NSString stringWithFormat:@"device_token=%@&deceased_id=%@",strToken, deceasedId];
//            [deviceToken_urlRequest setHTTPBody:[deviceToken_body dataUsingEncoding:NSUTF8StringEncoding]];
//            
//            NSHTTPURLResponse *deviceToken_response;
//            NSError *deviceToken_error = nil;
//            
//            //HTTP同期通信を実行
//            NSData *deviceTokenResult = [NSURLConnection sendSynchronousRequest:deviceToken_urlRequest returningResponse:&deviceToken_response error:&deviceToken_error];
//            
//            //デバイストークンをサーバーに保存
//            if (deviceTokenResult && deviceToken_response.statusCode == 200) {
//                //成功
//            } else {
//                //失敗
//            }
        
            //故人テーブルへのDBアクセスオブジェクト生成
            DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
        
            //故人情報一覧から表示されている場合、既に登録されていないかチェックする
            if (self.fromView == QR_READ_VIEW_FROM_DECEASED_LIST) {
                Deceased *dupliDeceased = [deceasedDao selectDeceasedByDeceasedId:deceased.deceased_id];
                if (dupliDeceased != nil) {
                    //登録されている場合、データと写真を削除する
                    if ([deceasedDao deleteDeceasedByDeceasedId:dupliDeceased.deceased_id]) {
                        //写真を登録している故人データの場合、写真ファイルを削除
                        if (dupliDeceased.deceased_photo_path.length > 0) {
                            //写真ファイルを読み込む
                            NSString *filePath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, dupliDeceased.deceased_photo_path];
                            //ファイルマネージャを作成
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            //ファイルが存在する場合、削除
                            if ([fileManager fileExistsAtPath:filePath]) {
                                NSError *error;
                                //ファイルを削除
                                BOOL result = [fileManager removeItemAtPath:filePath error:&error];
                                if (!result) {
                                    //DBをロールバック
                                    [memorialDatabase rollback];
                                    //DBを閉じる
                                    [memorialDatabase close];
                                    //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
                                    [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"故人様情報のダウンロードに失敗しました。\nもう一度QRコードを読み込んで下さい。" waitUntilDone:NO];
                                    //終了
                                    return;
                                }
                            }
                        }
                    } else {
                        //DBをロールバック
                        [memorialDatabase rollback];
                        //DBを閉じる
                        [memorialDatabase close];
                        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
                        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"故人様情報のダウンロードに失敗しました。\nもう一度QRコードを読み込んで下さい。" waitUntilDone:NO];
                        //終了
                        return;
                    }
                }
            }
        
            //故人情報を保存
            if (![deceasedDao insertDeceased:deceased]) {
                //DBをロールバック
                [memorialDatabase rollback];
                //DBを閉じる
                [memorialDatabase close];
                //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
                [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"故人様情報のダウンロードに失敗しました。\nもう一度QRコードを読み込んで下さい。" waitUntilDone:NO];
                //終了
                return;
            }

            //DBをコミット
            [memorialDatabase commit];
            //DBを閉じる
            [memorialDatabase close];
            
            
            //起動時ポイント自動付与
            userid = [defaults stringForKey:USER_ID];  // USER_IDの内容をNSString型として取得
            
            //利用者IDを取得している場合、ポイント付与
            if ([userid length]) {
                HttpAccess *httpAccess = [HttpAccess new];
                NSString *parameter = userid;
                [httpAccess get:POINT_ADD_USER1 param:parameter];
            }
      
            //故人写真の設定されているデータの場合、故人写真を取得
            if (deceased.deceased_photo_path.length > 0) {
                //読み込むファイルの URL を作成
                NSString *downloadphoto_urlAsString = [[DOWNLOAD_PHOTO stringByAppendingString:@"?deceasedId="] stringByAppendingString:deceasedId];
                NSURL *downloadphoto_url = [NSURL URLWithString:downloadphoto_urlAsString];
                
                //引数の生成
                NSArray *loardImageArgArray = [NSArray arrayWithObjects:downloadphoto_url, deceasedId, nil];
                
                //メインスレッドのファイル読み込みを実行
                [self performSelectorOnMainThread:@selector(loadImage:) withObject:loardImageArgArray waitUntilDone:NO];
            } else {
                //メインスレッドでインディケーターを閉じる
                [self performSelectorOnMainThread:@selector(closeIndicator) withObject:nil waitUntilDone:NO];
                //親画面のデリゲート処理を実行
                [self.delegate hideQrCodeReadView:YES];
            }
        } else {
            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"故人様情報のダウンロードに失敗しました。\nもう一度QRコードを読み込んで下さい。" waitUntilDone:NO];
            //終了
            return;
        }
    }

    @catch (NSException *exception) {
        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"故人様情報のダウンロードに失敗しました。\nもう一度QRコードを読み込んで下さい。" waitUntilDone:NO];
        //終了
        return;
    }
}

//ファイルを読み込む
- (void)loadImage:(NSArray *)loardImageArgArray
{
    //引数を取得
    NSURL *downloadphoto_url = loardImageArgArray[0];
    NSString *deceasedId = loardImageArgArray[1];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:downloadphoto_url];
    //引数の生成
    NSArray *saveImageArgArray = [NSArray arrayWithObjects:imageData, deceasedId, nil];
    //ファイル保存を実行
    [self saveImage:saveImageArgArray];
}

//ローカルにデータを保存
- (void)saveImage:(NSArray *)saveImageArgArray
{
    //引数を取得
    NSData *imageData = saveImageArgArray[0];
    NSString *deceasedId = saveImageArgArray[1];
    
    //ファイル名生成
    NSString *saveFileName = [NSString stringWithFormat:@"%@.jpg",deceasedId];
    
    //保存先パス生成
    NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, saveFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    if (success) {
        imageData = [NSData dataWithContentsOfFile:dataPath];
    } else {
        [imageData writeToFile:dataPath atomically:YES];
    }
    
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //写真パスを上書きを保存
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    [deceasedDao updatePhotopath:saveFileName byDeceasedId:deceasedId];
    
    //データーベースを閉じる
    [memorialDatabase close];

    //インジケーターを閉じる
    [self closeIndicator];
    
    //保存が完了したら親画面のデリゲート処理を実行
    [self.delegate hideQrCodeReadView:YES];
}

- (void)closeIndicatorAndErrorMessage:(NSString *)errorMessage
{
    [self closeIndicator];
    
    //エラートースト表示
    [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
    
    //カメラを再起動する
    //トースト表示終了後、カメラを再起動する
    [NSTimer scheduledTimerWithTimeInterval:TOAST_DURATION_ERROR + CAMERA_RESTART_DURATION target:self selector:@selector(startSession) userInfo:nil repeats:NO];
}

- (void)closeIndicator
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    
    //画面操作を許可する
    self.view.userInteractionEnabled = YES;
    self.toolBar.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
