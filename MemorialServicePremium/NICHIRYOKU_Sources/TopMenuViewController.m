//
//  TopMenuViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/01/26.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "TopMenuViewController.h"
//フレームワーク
#import <QuartzCore/QuartzCore.h>

//クラス
#import "LoupeViewController.h"
#import "BeautyCharacterViewController.h"
#import "OtherFuneralViewController.h"
#import "NoticeInfoListViewController.h"
#import "MenuTabBarViewController.h"
#import "Define.h"
#import "PointUserInfoViewController.h"
#import "PointCardViewController.h"
#import "DeceasedListViewController.h"
#import "FamilyTreeViewController.h"
#import "FamilyTreeTempViewController.h"
#import "TaxiViewController.h"
#import "KumotsuViewController.h"
#import "TyodenViewController.h"
#import "OtherDataTransferViewController.h"
#import "OtherHowToUseViewController.h"
#import "OtherFuneralViewController.h"
#import "AisaikaClubViewController.h"
#import "AisaikaclubReadMemberIdQrViewController.h"
#import "CallNameSettingViewController.h"
#import "Reachability.h"
#import "IndicatorWindow.h"
#import "Toast+UIView.h"
#import "DataTakeInViewController.h"
#import "GoodMoriningCallSendViewController.h"
#import "NicefaceViewController.h"
#import "RyoboViewController.h"
#import "HttpAccess.h"
#import "AisaikaclubReadMemberIdQrViewController.h"
#import "QrCodeReadViewController.h"



@interface TopMenuViewController (){
    NSString *_url;
    NSUserDefaults *defaults;
    NSString *memberId;
    NSInteger deceasedUpdateCount;
    NSInteger devicedeceasedUpdateCount;
    NSString *appliId;
    NSString *area;
    NSString *areaTel;
    NSString *nowTime;
    NSString *appUpDateTime;
    NSString *srvUpdateTime;
    int downloadCount;
    NSString *callName;
    NSString *telNumber;
    

    
    DataTakeInViewController *dataTakeInViewController;
    
    GoodMoriningCallSendViewController *goodMoriningCallSendViewController;
    
    AisaikaclubReadMemberIdQrViewController *aisaikaclubReadMemberIdQrViewController;
}

//ボタン
//トップメニュー
@property (weak, nonatomic) IBOutlet UILabel *Menulabel;
@property (weak, nonatomic) IBOutlet UIButton *top_menu;

//お知らせ
@property (weak, nonatomic) IBOutlet UIButton *btn_notice;
//故人一覧（大切な故人）
@property (weak, nonatomic) IBOutlet UIButton *btn_kojinitiran;
//Web版ベストエンディング-> 美文字として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_webendding;
//葬儀社情報　-> ルーペとして使用
@property (weak, nonatomic) IBOutlet UIButton *btn_customer;
//美文字　-> くらしホール鹿島台＿電話として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_bimoji;
//ルーペ　-> くらしホール松山＿電話として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_loupe;
//機種変更する場合　-> くらし葬祭ご案内として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_backup;
//使い方
@property (weak, nonatomic) IBOutlet UIButton *btn_howto;

//タクシー配車　-> 空ボタン＿左として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_taxi;

//ポイント　-> 空ボタン＿右として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_point;


//供花・供物　->　未使用
@property (weak, nonatomic) IBOutlet UIButton *btn_kumotsu;
//弔電・喪中はがき　->　未使用
@property (weak, nonatomic) IBOutlet UIButton *btn_tyoden;

//ビュー
@property (weak, nonatomic) IBOutlet UIView *view_menu;

@property (weak, nonatomic) IBOutlet UIImageView *funeral_img;

@end

@implementation TopMenuViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        dataTakeInViewController = [DataTakeInViewController new];
        
        dataTakeInViewController.delegate = self;
        
        
        goodMoriningCallSendViewController = [GoodMoriningCallSendViewController new];
        
        goodMoriningCallSendViewController.delegate = self;

        
        aisaikaclubReadMemberIdQrViewController = [AisaikaclubReadMemberIdQrViewController new];
        
        aisaikaclubReadMemberIdQrViewController.delegate = self;
    
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ユーザーデフォルト
    memberId    = [defaults stringForKey:KEY_MEMBER_USER_ID];                           // 会員番号取得
    appliId     = [defaults stringForKey:KEY_MEMBER_APPLI_ID];                          // アプリID取得
    NSString *move_topmenu     = [defaults stringForKey:KEY_MOVE_FIRST_TOPMENU];              // アプリID取得

    //最初に遷移した時のみ
    if ([move_topmenu isEqual:@"0"]) {
        [self.view makeToast:@"成功しました。" duration:TOAST_DURATION_ERROR position:@"center"];
        
        [defaults setObject:@"1" forKey:KEY_MOVE_FIRST_TOPMENU];
        [defaults synchronize];
    
    }
    
    //========= ボタンレイアウト ===========//
    //トップメニューボタン設定
    self.top_menu.imageView.contentMode = UIViewContentModeScaleAspectFit;

    //故人一覧ボタン設定
    self.btn_kojinitiran.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //お知らせボタン設定
    self.btn_notice.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //お知らせボタン設定
    self.btn_webendding.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //美文字ボタン設定
    self.btn_bimoji.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //葬儀社名ボタン設定
    self.btn_customer.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //ルーペボタン設定
    self.btn_loupe.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //ルーペボタン設定
    self.btn_backup.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //ルーペボタン設定
    self.btn_taxi.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //ルーペボタン設定
    self.btn_point.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //ルーペボタン設定
    self.btn_kumotsu.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //ルーペボタン設定
    self.btn_tyoden.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.btn_howto.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.funeral_img.contentMode = UIViewContentModeScaleAspectFit;
    
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        return;
    }

    BOOL devicetoken_save = [defaults boolForKey:@"DEVICETOKEN_SAVE"];
    
    if(!devicetoken_save){
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
        NSString *deviceToken_body = [NSString stringWithFormat:@"device_token=%@&deceased_id=%@",strToken, memberId];
        [deviceToken_urlRequest setHTTPBody:[deviceToken_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSHTTPURLResponse *deviceToken_response;
        NSError *deviceToken_error = nil;
        
        //HTTP同期通信を実行
        NSData *deviceTokenResult = [NSURLConnection sendSynchronousRequest:deviceToken_urlRequest returningResponse:&deviceToken_response error:&deviceToken_error];
        
        //デバイストークンをサーバーに保存
        if (deviceTokenResult && deviceToken_response.statusCode == 200) {
            //成功
            [defaults setBool:YES forKey:@"DEVICETOKEN_SAVE"];
            [defaults synchronize];
        } else {
            //失敗
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    //終活のすすめのURLを生成してインスタンス変数に設定
    _url = [SYUKATSU stringByAppendingFormat:@"?mno=%d", 3];
    
    //会員番号を取得
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];                              // 会員番号
    devicedeceasedUpdateCount = [defaults integerForKey:KEY_DECEASED_UPDATE_COUNT];     // 故人データ更新カウント
    callName = [defaults stringForKey:KEY_MEMBER_SENDAR_NAME];                          // 発信者名
    appliId = [defaults stringForKey:KEY_MEMBER_APPLI_ID];                              // アプリID
    appUpDateTime = [defaults stringForKey:KEY_RYOBO_PHOTO_UPDATETIME];                 // 墓写真更新時間
    areaTel     = [defaults stringForKey:KEY_SOUGI_TEL];                                // 葬儀24時間受付

    
    //====墓写真更新処理=======//
    // 現在時刻
    // NSDateFormatter を用意
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    // カレンダーを西暦（グレゴリオ暦）で用意
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // カレンダーをセット
    [df setCalendar:cal];
    // タイムロケールをシステムロケールでセット（24時間表示のため）
    [df setLocale:[NSLocale systemLocale]];
    // タイムスタンプ書式をセット
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 現在日時から文字列を生成
    nowTime = [df stringFromDate:[NSDate date]];
    // ログに出力
    NSLog(@"%@", nowTime);
    
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        
    }else{
        //QR読込済の場合
        if (appliId != NULL|| [appliId length] != 0) {
            
            //サーバーから会員情報取得
            HttpAccess *httpAccess = [HttpAccess new];
        
            NSMutableDictionary *parameter = [@{@"appli_id":appliId} mutableCopy];
        
            NSData *returnData = [httpAccess POST:GET_MEMBER_ID param:parameter];
        
            NSError *errorObject = nil;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&errorObject];
        
            //JSONオブジェクトのパース失敗時はログを出して終了
            if ([jsonObject isEqual:@"false"]) {
                NSLog(@"JSONObjectパース失敗");
                return;
            }
        
            //サーバーからタイムスタンプを取得
            srvUpdateTime = [jsonObject objectForKey:@"timestamp"];
        
            //アプリにデータがなければ、現在時刻を保存
            if (appUpDateTime == NULL|| [appUpDateTime length] == 0) {
                [defaults setObject:nowTime forKey:KEY_RYOBO_PHOTO_UPDATETIME];
                [defaults synchronize];
            }else{
                //アプリ内データ
                NSDateFormatter *appDateFormatter = [[NSDateFormatter alloc] init];
                appDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *appDate = [appDateFormatter dateFromString:appUpDateTime];
                
                //サーバーデータ
                NSDateFormatter *srvDateFormatter = [[NSDateFormatter alloc] init];
                srvDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *srvDate = [appDateFormatter dateFromString:srvUpdateTime];
            
                //保存先パス取得
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ryobo2.jpg"];
                NSFileManager *fileManager = [NSFileManager defaultManager];

                //日付比較
                NSComparisonResult result = [appDate compare:srvDate];
                switch(result) {
                    case NSOrderedSame:
                        // 同じ日時
                        NSLog(@"同じ日時");
                    break;
                    case NSOrderedAscending:
                        // -1
                        // appDateが前
                        //ファイルの存在チェック
                        if ([fileManager fileExistsAtPath:dataPath]) {
                            //存在する場合、削除
                            [fileManager removeItemAtPath:dataPath error:NULL];
                    }
                    
                    [defaults setObject:srvUpdateTime forKey:KEY_RYOBO_PHOTO_UPDATETIME];
                    [defaults synchronize];
                    NSLog(@"NSOrderedAscending");
                    break;
                case NSOrderedDescending:
                    // 1
                    // appDateが後
                    NSLog(@"NSOrderedDescending");
                    break;
                }
            
            }

            //サーバーから故人アップデートカウント数を取得
            NSMutableDictionary *parameter_update = [@{@"appli_id":appliId} mutableCopy];
        
            NSData *returnDataUpdata = [httpAccess POST:GET_DECEASED_UPDATE_COUNT param:parameter_update];
        
            NSString *deceasedUpdateCountString= [[NSString alloc] initWithData:returnDataUpdata encoding:NSUTF8StringEncoding];
            //NSInteger型に変換
            deceasedUpdateCount = [deceasedUpdateCountString intValue];
        
//            NSLog(@"update%ld",devicedeceasedUpdateCount);
            
        }
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//アクション

//「ニチリョク」へ遷移
- (IBAction)move_customer_info:(id)sender {
    
        //会社情報のインスタンスを生成
        OtherFuneralViewController *otherFuneralViewController = [OtherFuneralViewController new];
    
        // Tab bar を非表示
        otherFuneralViewController.hidesBottomBarWhenPushed = YES;
    
        //会社情報画面に遷移
        [self.navigationController pushViewController:otherFuneralViewController animated:NO];
    
}
//お知らせへ遷移
- (IBAction)move_notice:(id)sender {
    
    
//    BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
//    //QR読み込みの有無によって遷移先を変更する
//    if(transfer_download){
//        //読込済_お知らせ画面を表示
//        //お知らせ画面のインスタンスを生成
//        NoticeInfoListViewController *noticeInfoListViewController = [NoticeInfoListViewController new];
//
//        // Tab bar を非表示
//        noticeInfoListViewController.hidesBottomBarWhenPushed = YES;
//
//        //お知らせ画面に遷移
//        [self.navigationController pushViewController:noticeInfoListViewController animated:NO];
//    }else{
//        //会員番号QRを読み込んでいない場合、エラーメッセージをダイアログ表示
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"会員番号QRを読み込んで下さい" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//        //読込未_QR読み込み提示画面表示
//        [self presentViewController:aisaikaclubReadMemberIdQrViewController animated:NO completion:nil];
//    }
    
            //お知らせ画面のインスタンスを生成
            NoticeInfoListViewController *noticeInfoListViewController = [NoticeInfoListViewController new];
    
            // Tab bar を非表示
            noticeInfoListViewController.hidesBottomBarWhenPushed = YES;
    
            //お知らせ画面に遷移
            [self.navigationController pushViewController:noticeInfoListViewController animated:NO];
    
}


//故人一覧へ遷移
- (IBAction)move_kojinitiran:(id)sender {
    
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //インジケーターを閉じる
        [IndicatorWindow closeWindow];
        //接続できない場合、エラーメッセージをダイアログ表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"ネットワークに接続できる環境で使用して下さい。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
//    BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
    //QR読み込みの有無によって遷移先を変更する
//    if(transfer_download){
//        //読込済
////        if (devicedeceasedUpdateCount < deceasedUpdateCount) {
////
////            [defaults setInteger:deceasedUpdateCount forKey:KEY_DECEASED_UPDATE_COUNT];         // ユーザーデフォルトdeceased_update_count_更新
////            [defaults synchronize];
////
////            [self displayContentController:dataTakeInViewController];
////
////        }else{
//            //故人様一覧のインスタンスを生成
//            DeceasedListViewController *deceasedlistViewController = [DeceasedListViewController new];
//
//            // Tab bar を非表示
//            deceasedlistViewController.hidesBottomBarWhenPushed = YES;
//
//            //故人様一覧画面に遷移
//            [self.navigationController pushViewController:deceasedlistViewController animated:NO];
////        }
//    }else{
//        //会員番号QRを読み込んでいない場合、エラーメッセージをダイアログ表示
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"会員番号QRを読み込んで下さい" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//        //読込未_QR読み込み提示画面表示
//        [self presentViewController:aisaikaclubReadMemberIdQrViewController animated:NO completion:nil];
//    }

            //故人様一覧のインスタンスを生成
            DeceasedListViewController *deceasedlistViewController = [DeceasedListViewController new];
    
            // Tab bar を非表示
            deceasedlistViewController.hidesBottomBarWhenPushed = YES;
    
            //故人様一覧画面に遷移
            [self.navigationController pushViewController:deceasedlistViewController animated:NO];
    
}

//「ご相談」-> 「美文字」のメソッド記入
- (IBAction)move_kumotu:(id)sender {

    // 電話かける
//    NSURL *url = [[NSURL alloc] initWithString:@"tel:0120-860-030"];
//    [[UIApplication sharedApplication] openURL:url];
    
    //美文字のインスタンスを生成
    BeautyCharacterViewController *beautycharacterViewController = [BeautyCharacterViewController new];
    
    // Tab bar を非表示
    beautycharacterViewController.hidesBottomBarWhenPushed = YES;
    
    //美文字画面に遷移
    [self.navigationController pushViewController:beautycharacterViewController animated:NO];
    
}

//会社情報へ遷移-> 葬儀24時間受付
- (IBAction)move_customer:(id)sender {
//    //会社情報のインスタンスを生成
//    OtherFuneralViewController *otherFuneralViewController = [OtherFuneralViewController new];
//
//    // Tab bar を非表示
//    otherFuneralViewController.hidesBottomBarWhenPushed = YES;
//
//    //会社情報画面に遷移
//    [self.navigationController pushViewController:otherFuneralViewController animated:NO];
        //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
        Reachability *curReach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            //接続できない場合
    //        [self.view makeToast:@"ネットワークに接続できる環境でご利用ください" duration:TOAST_DURATION_ERROR position:@"center"];
    
            if ([areaTel length] == 0) {
                areaTel = @"0120-678-000";
            }
    
            NSString *telchara = @"tel:";
    
            telNumber = [NSString stringWithFormat:@"%@%@",telchara,areaTel];
    
            // 電話かける
            NSURL *url = [[NSURL alloc] initWithString:telNumber];
            [[UIApplication sharedApplication] openURL:url];
    
            return;
        }
    
    
        if ([area length] == 0) {
            area = @"関東";
        }
    
        //サーバーからエリアの電話番号を取得後、電話をかける
        HttpAccess *httpAccess = [HttpAccess new];
    
        NSMutableDictionary *parameter = [@{@"area":area} mutableCopy];
    
        NSData *returnData = [httpAccess POST:GET_EREA_TEL param:parameter];
    
        areaTel = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
        NSLog(@"エリア電話番号%@",areaTel);
    
        [defaults setObject:areaTel forKey:KEY_SOUGI_TEL];
        [defaults synchronize];
    
        NSString *telchara = @"tel:";
    
        telNumber = [NSString stringWithFormat:@"%@%@",telchara,areaTel];
    
        NSLog(@"エリア電話番号%@",telNumber);
    
        // 電話かける
        NSURL *url = [[NSURL alloc] initWithString:telNumber];
        [[UIApplication sharedApplication] openURL:url];

}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //アプリ設定ページに遷移
            [self moveUrl];
            break;
        case 1:
            break;
    }
    
}

//アプリ設定ページに遷移
-(void)moveUrl{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

//美文字へ遷移　->　「葬儀　24時間受付」
- (IBAction)move_bimoji:(id)sender {
    //カメラの設定が有効になっているか確認
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusAuthorized) { // プライバシー設定でカメラ使用が許可されている
        
        //ルーペのインスタンスを生成
        LoupeViewController *loupeViewController = [LoupeViewController new];
        
        // Tab bar を非表示
        loupeViewController.hidesBottomBarWhenPushed = YES;
        
        //ルーペ画面に遷移
        [self.navigationController pushViewController:loupeViewController animated:YES];
        
    } else if (status == AVAuthorizationStatusDenied) { // 　不許可になっている
        //アラートメッセージ作成
        NSString *alertMessage1 = @"\n ルーペ機能使用のため、カメラへのアクセスを許可してください。";
        NSString *str = [NSString stringWithFormat:@"%@",alertMessage1];
        
        //アラートビュー表示
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"カメラへのアクセス許可のお願い";
        alert.message = str;
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"許可しない"];
        [alert show];
        
    } else if (status == AVAuthorizationStatusRestricted) { // 制限されている
        
    } else if (status == AVAuthorizationStatusNotDetermined) { // アプリで初めてカメラ機能を使用する場合
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted) { // 使用が許可された場合
                NSLog(@"使用が許可された場合");
            } else {       // 使用が不許可になった場合
                NSLog(@"使用が不許可になった場合");
            }
            
        }];
        
    }
}

//ルーペへ遷移　->　お墓へ遷移
- (IBAction)move_loupe:(id)sender {
    
//    BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
//    //QR読み込みの有無によって遷移先を変更する
//    if(transfer_download){
//        //読込済_お墓画面画面を表示
//        //お墓のインスタンスを生成
//        RyoboViewController *ryoboViewController = [RyoboViewController new];
//
//        // Tab bar を非表示
//        ryoboViewController.hidesBottomBarWhenPushed = YES;
//
//        //お墓画面に遷移
//        [self.navigationController pushViewController:ryoboViewController animated:NO];
//    }else{
//        //会員番号QRを読み込んでいない場合、エラーメッセージをダイアログ表示
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"会員番号QRを読み込んで下さい" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//        //読込未_QR読み込み提示画面表示
//        [self presentViewController:aisaikaclubReadMemberIdQrViewController animated:NO completion:nil];
//
//
//    }
    
            //読込済_お墓画面画面を表示
            //お墓のインスタンスを生成
            RyoboViewController *ryoboViewController = [RyoboViewController new];
    
            // Tab bar を非表示
            ryoboViewController.hidesBottomBarWhenPushed = YES;
    
            //お墓画面に遷移
            [self.navigationController pushViewController:ryoboViewController animated:NO];
    
    
}

//弔電・喪中はがきへ遷移 ->　注文メニュー内容によりここに「くらし葬祭ご案内」のメソッド記入
- (IBAction)move_tyoden:(id)sender {

    //くらし葬祭ご案内のインスタンスを生成
    OtherFuneralViewController *otherfuneralViewController = [OtherFuneralViewController new];
    
    // Tab bar を非表示
    otherfuneralViewController.hidesBottomBarWhenPushed = YES;
    
    //くらし葬祭ご案内画面に遷移
    [self.navigationController pushViewController:otherfuneralViewController animated:NO];
    
}

//タクシー配車へ遷移 ->　注文メニュー内容によりここに「使い方」のメソッド記入
- (IBAction)move_taxi:(id)sender {

    
    BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
    //QR読み込みの有無によって遷移先を変更する
    if(transfer_download){
        //読込済
        //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
        Reachability *curReach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            //インジケーターを閉じる
            [IndicatorWindow closeWindow];
            //接続できない場合、エラーメッセージをダイアログ表示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"ネットワークに接続できる環境で使用して下さい。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        
        //発信者名が空の場合
        if ([callName length] == 0) {
            //「毎日おはよう」名前設定画面のインスタンスを生成
            CallNameSettingViewController *callNameSettingViewController = [CallNameSettingViewController new];
            
            // Tab bar を非表示
            callNameSettingViewController.hidesBottomBarWhenPushed = YES;
            
            callNameSettingViewController.fromViewController = @"topmenu";
            
            //「毎日おはよう」名前設定画面に遷移
            [self.navigationController pushViewController:callNameSettingViewController animated:NO];
            
            return;
        }
        
         //おはよう送信インジケータ処理実行
         [self displayContentController:goodMoriningCallSendViewController];
        
        
//        NSString *message = @"おはよう";
//        
//        HttpAccess *httpAccess = [HttpAccess new];
//        
//        NSMutableDictionary *parameter = [@{@"appli_id":appliId,@"call_name":callName,@"mornig_call":message} mutableCopy];
//        
//        NSData *returnData = [httpAccess POST:NICEFACE_SEND param:parameter];
//        
//        NSString *result= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"毎日おはよう送信結果：%@",result);
//        
//        if ([result isEqualToString:@"1"]) {
//            [self.view makeToast:@"おはよう送信しました" duration:TOAST_DURATION_ERROR position:@"center"];
//        }else if([result isEqualToString:@"NG"]){
//            [self.view makeToast:@"本日、すでにおはようされています。" duration:TOAST_DURATION_ERROR position:@"center"];
//        }else{
////            [self.view makeToast:@"おはよう送信に失敗しました" duration:TOAST_DURATION_ERROR position:@"center"];
//            [self.view makeToast:@"おはよう送信しました" duration:TOAST_DURATION_ERROR position:@"center"];

//        }
    }else{
        //会員番号QRを読み込んでいない場合、エラーメッセージをダイアログ表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"会員番号QRを読み込んで下さい" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        //読込未_QR読み込み提示画面表示
        [self presentViewController:aisaikaclubReadMemberIdQrViewController animated:NO completion:nil];

        
    }
    
}



//愛彩花倶楽部へ遷移
- (IBAction)move_aisaikaclub:(id)sender {
    
    
    BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
    //QR読み込みの有無によって遷移先を変更する
    if(transfer_download){
        //読込済_愛彩花倶楽部画面画面を表示
        //愛彩花倶楽部画面のインスタンスを生成
        AisaikaClubViewController *aisaikaClubViewController = [AisaikaClubViewController new];
        
        // Tab bar を非表示
        aisaikaClubViewController.hidesBottomBarWhenPushed = YES;
        
        //愛彩花倶楽部画面に遷移
        [self.navigationController pushViewController:aisaikaClubViewController animated:NO];
    }else{
        //会員番号QRを読み込んでいない場合、エラーメッセージをダイアログ表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"会員番号QRを読み込んで下さい" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        //読込未_QR読み込み提示画面表示
        [self presentViewController:aisaikaclubReadMemberIdQrViewController animated:NO completion:nil];

    }
}

//ポイントへ遷移
- (IBAction)move_point:(id)sender {
    
    // Tab bar を非表示
    UIViewController *pointviewController;
    
    pointviewController = [self getPointViewController];
    
    pointviewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pointviewController animated:YES];
}




//いい顔へ遷移
- (IBAction)move_niceface:(id)sender {
    
    
    BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
    //QR読み込みの有無によって遷移先を変更する
    if(transfer_download){
        //読込済_いい顔画面を表示
        
        //発信者名が空の場合
        if ([callName length] == 0) {
            //「毎日おはよう」名前設定画面のインスタンスを生成
            CallNameSettingViewController *callNameSettingViewController = [CallNameSettingViewController new];
            
            // Tab bar を非表示
            callNameSettingViewController.hidesBottomBarWhenPushed = YES;
            
            callNameSettingViewController.fromViewController = @"topmenu";
            
            //「毎日おはよう」名前設定画面に遷移
            [self.navigationController pushViewController:callNameSettingViewController animated:NO];
            
            return;
        }
        
        //いい顔画面のインスタンスを生成
        NicefaceViewController *nicefaceViewController = [NicefaceViewController new];
        
        // Tab bar を非表示
        nicefaceViewController.hidesBottomBarWhenPushed = YES;
        
        //いい顔画面に遷移
        [self.navigationController pushViewController:nicefaceViewController animated:NO];
    }else{
        //会員番号QRを読み込んでいない場合、エラーメッセージをダイアログ表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"会員番号QRを読み込んで下さい" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        //読込未_QR読み込み提示画面表示
        [self presentViewController:aisaikaclubReadMemberIdQrViewController animated:NO completion:nil];

        
    }

}

//ポイント機能画面のインスタンスを取得する
- (UIViewController*)getPointViewController
{
    UIViewController *viewController;
    PointUser *userInfo = [PointUser new];
    [userInfo loadUserDefaults];
    
    if (userInfo.userName.length > 0 || userInfo.isSkip) {
        viewController = [PointCardViewController new];
    } else {
        viewController = [PointUserInfoViewController new];
    }
    
    return viewController;
}



- (void)displayContentController: (UIViewController *) content
{
    [self addChildViewController:content];
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}


//Qr読込提示画面を非表示にするデリゲード
-(void) hideDataTakeInView:(UIViewController *) _dataTakeInViewController{

    [_dataTakeInViewController willMoveToParentViewController:nil];
    [_dataTakeInViewController.view removeFromSuperview];
    [_dataTakeInViewController removeFromParentViewController];
    
        //故人様一覧のインスタンスを生成
        DeceasedListViewController *deceasedlistViewController = [DeceasedListViewController new];
    
        // Tab bar を非表示
        deceasedlistViewController.hidesBottomBarWhenPushed = YES;
    
        //故人様一覧画面に遷移
        [self.navigationController pushViewController:deceasedlistViewController animated:NO];
    //インディケーターを閉じる
    [self closeIndicator];
    
}

//おはよう送信インジケータ画面閉じる
-(void)hideGoodMoriningCallSendView:(UIViewController *)_goodMoriningCallSendViewController{
    [_goodMoriningCallSendViewController willMoveToParentViewController:nil];
    [_goodMoriningCallSendViewController.view removeFromSuperview];
    [_goodMoriningCallSendViewController removeFromParentViewController];
    //インディケーターを閉じる
    [self closeIndicator];
    
}

//おはよう送信完了後、結果のトースト表示
-(void)dispresult:(NSString *)result{
    
    if ([result isEqualToString:@"1"]) {
        [self.view makeToast:@"「おはよう」送信しました。" duration:TOAST_DURATION_ERROR position:@"center"];
    }else if([result isEqualToString:@"NG"]){
        [self.view makeToast:@"本日はすでに「おはよう」されています。" duration:TOAST_DURATION_ERROR position:@"center"];
    }else{
        //            [self.view makeToast:@"おはよう送信に失敗しました" duration:TOAST_DURATION_ERROR position:@"center"];
        [self.view makeToast:@"「おはよう」送信しました。" duration:TOAST_DURATION_ERROR position:@"center"];
        
    }
    
}


//「愛彩花倶楽部」＿会員QR読込案内ページ閉じる
-(void) hideaisaikaclubReadQrView:(BOOL)readBool
{
    //画面を閉じる
    
    //QR読み込み画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    //1.0秒後、親画面のデリゲート処理を実行
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popView) userInfo:nil repeats:NO];

}

-(void)popView{
    
    QrCodeReadViewController *qrCodeReadViewController = [QrCodeReadViewController new];
    
    [qrCodeReadViewController dismissViewControllerAnimated:YES completion:nil];
    
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    
    [self.view makeToast:@"成功しました。" duration:TOAST_DURATION_ERROR position:@"center"];

}

//「愛彩花倶楽部」＿会員QR読込案内ページ閉じる
-(void) returnAisaikaclubReadQrView:(BOOL)readBool
{
    //画面を閉じる
    
    //QR読み込み画面を閉じる
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


//インディケーターを閉じる
- (void)closeIndicator
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    
}

@end
