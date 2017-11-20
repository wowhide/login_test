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
#import "HttpAccess.h"

@interface QrCodeReadViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    //故人ID
    NSString *_deceasedId;
    //アプリID
    NSString *_appliId;
    //会員番号
    NSString *memberId;
    //ユーザーデフォルト
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
    
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];     // 会員番号取得
    
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
        //読み込んだQRコードを故人IDと故人名に分ける
        NSArray* values = [qrcode componentsSeparatedByString:@","];
        //フォーマットが合っているかチェック
        if (values.count != 2) {
            [self.view makeToast:@"このQRコードは当アプリに対応していません。" duration:TOAST_DURATION_ERROR position:@"center"];
            //トースト表示終了後、カメラを再起動する
            [NSTimer scheduledTimerWithTimeInterval:TOAST_DURATION_ERROR target:self selector:@selector(startSession) userInfo:nil repeats:NO];
            return;
        }
        
        [self.view makeToast:@"成功しました。" duration:TOAST_DURATION_ERROR position:@"center"];
        
        //故人ID、アプリIDを取得
        _deceasedId = [values objectAtIndex:0];
        _appliId = [values objectAtIndex:1];
        
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
            [defaults setBool:YES forKey:@"DEVICETOKEN_SAVE"];
        } else {
            //失敗
        }
        
        //ユーザーデフォルト
        [defaults setObject:_deceasedId forKey:KEY_MEMBER_USER_ID];         // 会員番号_更新
        [defaults setObject:_appliId forKey:KEY_MEMBER_APPLI_ID];           // appli_id_更新
        [defaults setObject:@"0" forKey:KEY_DECEASED_UPDATE_COUNT];         // deceased_update_count_更新
        [defaults setObject:@"" forKey:KEY_RYOBO_PHOTO_PATh];               // ryobo_photo_path_更新
        [defaults setObject:@"" forKey:KEY_MEMBER_SENDAR_NAME];             // member_sendar_name更新
        [defaults setBool:YES forKey:@"KEY_DOWNLOAD"];
        [defaults synchronize];
        
        //カメラを終了する
        [self stopSession];
        
        //別スレッドで「利用者追加」プッシュを実行する
//        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
//                                            initWithTarget:self
//                                            selector:@selector(addUser:)
//                                            object:_appliId];
//        NSOperationQueue *queue = [NSOperationQueue new];
//        [queue addOperation:operation];
//
        
    
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        
        //故人
        DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
        int deceasedCount = [deceasedDao countDeceased];
        NSLog(@"故人int:%d", deceasedCount);
        //登録故人がある場合
        if (deceasedCount != 0) {
            //別のスレッドでファイル読み込みをキューに加える
            NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                initWithTarget:self
                                                selector:@selector(uploadData:)
                                                object:_appliId];
            NSOperationQueue *queue = [NSOperationQueue new];
            [queue addOperation:operation];
        }
        
        //お墓画像削除
        //保存先パス取得
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ryobo2.jpg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:dataPath]) {
            //存在する場合、削除
            [fileManager removeItemAtPath:dataPath error:NULL];
        }

        
        [self.delegate hideQrCodeReadView:YES];
        
        //トースト表示終了後、カメラを再起動する
        //[NSTimer scheduledTimerWithTimeInterval:TOAST_DURATION_ERROR target:self selector:@selector(hideQr) userInfo:nil repeats:NO];
    }
}

-(void)hideQr{
    //親画面のデリゲート処理を実行
    [self.delegate hideQrCodeReadView:YES];
}


//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //カメラを終了する
    [self stopSession];
    //親画面のデリゲート処理を実行
    [self.delegate returnQrCodeReadView:YES];
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

//利用者追加プッシュ＿メソッド
- (void)addUser:(NSString *)_appliid{
    //
    //    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    //    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    //    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    //    if (netStatus == NotReachable) {
    //        //接続できない場合
    //        [self.view makeToast:@"ネットワークに接続できる環境でダウンロードして下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
    //        return;
    //
    //    }
    
    NSString *message = @"おはよう";
    NSString *callName = @"reinstall";
    
    HttpAccess *httpAccess = [HttpAccess new];
    
    NSMutableDictionary *parameter = [@{@"appli_id":_appliid,@"call_name":callName,@"mornig_call":message} mutableCopy];
    
    NSData *returnData = [httpAccess POST:USERADD_SEND param:parameter];
    
    NSString *result= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"毎日おはよう送信結果：%@",result);
    
    //    if ([result isEqualToString:@"1"]) {
    //        [self.view makeToast:@"おはよう送信しました" duration:TOAST_DURATION_ERROR position:@"center"];
    //    }else if([result isEqualToString:@"NG"]){
    //        [self.view makeToast:@"本日、すでにおはようされています。" duration:TOAST_DURATION_ERROR position:@"center"];
    //    }else{
    //        //            [self.view makeToast:@"おはよう送信に失敗しました" duration:TOAST_DURATION_ERROR position:@"center"];
    //        [self.view makeToast:@"おはよう送信しました" duration:TOAST_DURATION_ERROR position:@"center"];
    //
    //    }
    
    return;
    
}


- (void)uploadData:(NSString *)_appliid
{
    //DBのデータを取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //故人
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    NSMutableArray *deceaseds = [deceasedDao selectDeceased];

    //データーベースを閉じる
    [memorialDatabase close];
    
    //取得したデータをJSON形式に変換
    NSError *error;
    
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
    
    //DBデーターアップロード
    //リクエスト先を指定する
    //    NSString *saveuserdata_urlAsString = SAVE_TRANSFER_DATA;
    //    NSString *saveuserdata_urlAsString = @"http://ms-dev.wow-d.net/cooperation/testsavetransferdata";
    
//    NSString *saveuserdata_urlAsString = UPDATE_DECEASED_ID;
    NSString *saveuserdata_urlAsString = INSERT_DECEASED_NO;

    NSURL *saveuserdata_url = [NSURL URLWithString:saveuserdata_urlAsString];
    
    //POSTメソッドのHTTPリクエストを生成する
    NSMutableURLRequest *saveuserdata_urlRequest = [NSMutableURLRequest requestWithURL:saveuserdata_url];
    [saveuserdata_urlRequest setHTTPMethod:@"POST"];
    //パラメータを付与
    NSString *saveuserdata_body = [NSString stringWithFormat:@"deceased=%@&appli_id=%@",
                                   [[NSString alloc] initWithData:deceasedJson encoding:NSUTF8StringEncoding],
                                   _appliid
                                   ];
    [saveuserdata_urlRequest setHTTPBody:[saveuserdata_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *saveuserdata_response;
    NSError *saveuserdata_error = nil;
    
    //HTTP同期通信を実行
    NSData *saveUserDataResult = [NSURLConnection sendSynchronousRequest:saveuserdata_urlRequest returningResponse:&saveuserdata_response error:&saveuserdata_error];
    
    //    //故人情報保存結果(データーキー)を取得
    //    if (saveUserDataResult && saveuserdata_response.statusCode == 200) {
    //        _dataKey = [[NSString alloc] initWithData:saveUserDataResult encoding:NSUTF8StringEncoding];
    //        //        NSLog(@"dataKey=%@", _dataKey);
    //        if (_dataKey.length == 0) {
    //            //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
    //            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
    //            return;
    //        }
    //    } else {
    //        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
    //        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
    //        return;
    //    }
    
    NSLog(@"saveUserDataResult=%@", saveUserDataResult);
    
    //インジケーターを閉じる
    //    [IndicatorWindow closeWindow];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
