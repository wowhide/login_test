//
//  AppDelegate.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "NoticeMonthDeathdayViewController.h"
#import "NoticeDeathdayViewController.h"
#import "NoticeMemorialdayViewController.h"
#import "LocalNotificationManager.h"
#import "OtherDataTransferKeyNoticeViewController.h"
#import "DataTransferKeyNoticeViewController.h"
#import "Notification.h"
#import "Define.h"
#import "Common.h"
#import "Reachability.h"
#import "NoticeInfoViewController.h"
#import "DatabaseHelper.h"
#import "NoticeInfo.h"
#import "MemorialReceiveDao.h"
#import "DeceasedDao.h"
#import "NicefacePushViewController.h"

//AppDelegateの実装
@implementation AppDelegate

@synthesize notice_flg;
@synthesize notice_timing;
@synthesize notice_count;
@synthesize notice_count_past;
@synthesize notice_schedule;
@synthesize notice_no;
@synthesize call_name;
@synthesize call_timing;

//アプリ起動時に呼ばれる
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //スプラッシュ時間設定
    sleep(2);
    //ウィンドウの生成
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //ビューの生成
    self.window.rootViewController = [[RootViewController alloc] init];

    //通知カウントをリセット
    self.notice_count = 0;
    self.notice_count_past = 0;

    //通知フラグプロパティにNOを設定
    self.notice_flg = NOTICE_FLG_NO;
    
    //アプリが起動していない場合のローカル通知の処理
    UILocalNotification *notify = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notify) {
        //通知フラグプロパティに法要通知を設定
        self.notice_flg = NOTICE_FLG_MEMORIAL;
    }
    
//    // アプリケーションが起動するたびに、デバイストークンを要求してそれをプロバイダに渡すことで、プロバイダが最新のデバイストークンを持つことを保証
//        // iOS8 移行のプッシュ通知の登録
//        UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        [application registerUserNotificationSettings:mySettings];
//        NSLog(@"iOS8");
    
    // アプリケーションが起動するたびに、デバイストークンを要求してそれをプロバイダに渡すことで、プロバイダが最新のデバイストークンを持つことを保証
    // iOS8対応
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        // iOS7 以前のプッシュ通知の登録
        } else {
        // iOS8 移行のプッシュ通知の登録
        UIUserNotificationType types = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:mySettings];
        NSLog(@"iOS8");
            
        
    }
    
    
    //アプリが起動していない場合のPush通知の処理
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo != nil) {
        //一度バッジを１にしないと通知センターの通知が消えない為１を設定した後０にする
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        //お知らせ関連
        NSString *noticeSchedule = [userInfo objectForKey:@"notice_schedule"];
        
        if ([noticeSchedule length] != 0) {
            self.notice_schedule = noticeSchedule;
            
            //通知フラグプロパティにお知らせ通知を設定
            self.notice_flg = NOTICE_FLG_NOTICE;
            //プロパティに通知日を設定
            //プロパティにお知らせ番号を設定
            NSString *noticeNo = [userInfo objectForKey:@"notice_info_no"];
            self.notice_no = noticeNo;
        }
        
        //「毎日おはよう」関連
        NSString *callName = [userInfo objectForKey:@"call_name"];
        
        if ([callName length] != 0
            && ![callName isEqualToString:@"reinstall"]) {
            self.call_name = callName;
            //通知フラグプロパティにおはよう送信を設定
            self.notice_flg = NOTICE_FLG_CALL;
        }
        
        //「利用者追加」関連
        if ([callName isEqualToString:@"reinstall"]) {
//            self.call_name = callName;
//            //通知フラグプロパティに利用者追加通知を設定
//            self.notice_flg = NOTICE_FLG_USERADD;
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //通知設定
    LocalNotificationManager *notificationManager = [[LocalNotificationManager alloc] init];
    [notificationManager scheduleLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//アプリがすでに動作中の場合のローカル通知の処理
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notify
{
    //法要通知テーブルから通知済みのレコードを取得して表示
    NSArray* notifications = [self selectMemorialReceive];
    for (Notification* notification in notifications) {
        [self dispMemorial:notification];
    }
    //法要通知テーブル全レコードを削除する
    [self deleteMemorialReceiveAll];
    //ローカル通知を一度すべて削除する
    [app cancelAllLocalNotifications];
/*
    if (app.applicationState == UIApplicationStateActive) {             //フォアグラウンドの場合
NSLog(@"アプリ起動中　フォアグラウンド　法要通知");
    } else if (app.applicationState == UIApplicationStateInactive) {    //バックグラウンドの場合
NSLog(@"アプリ起動中　バックグラウンド　法要通知");
    }
*/
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
//NSLog(@"didRegisterUserNotificationSettings");
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
NSLog(@"deviceToken:%@", deviceToken);
    //デバイストークンをサーバーに送る
    [self sendProviderDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//NSLog(@"Errorinregistration.Error:%@", error);
}

//デバイストークンをサーバーに送る
- (void)sendProviderDeviceToken:(NSData *)token
{
    //デバイストークンから<>とスペースを取り除く
    NSString *strTokenTemp01 = [NSString stringWithFormat:@"%@",token];
    NSString *strTokenTemp02 = [strTokenTemp01 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *strTokenTemp03 = [strTokenTemp02 stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *strToken = [strTokenTemp03 stringByReplacingOccurrencesOfString:@" " withString:@""];

    //デバイストークンをアプリ内に保存する
    NSUserDefaults *userDefaults;
    userDefaults = [NSUserDefaults standardUserDefaults];
    //デバイストークンを保存
    [userDefaults setObject:strToken forKey:KEY_DEVICE_TOKEN];
    //更新
    [userDefaults synchronize];
    
    //DBから故人情報を取得
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    //取得
    NSMutableArray *deceasedList = [deceasedDao selectDeceased];
    [memorialDatabase close];

    for (Deceased *deceasedInfo in deceasedList){
        if (deceasedInfo.qr_flg != 1) {
            continue;
        }
        NSURL *deviceTokenUrl = [NSURL URLWithString:SAVE_DEVICE_TOKEN_AND_DECEASED_ID];
        NSMutableURLRequest *deviceToken_urlRequest = [NSMutableURLRequest requestWithURL:deviceTokenUrl];
        [deviceToken_urlRequest setHTTPMethod:@"POST"];
        NSString *http_body = [NSString stringWithFormat:@"device_token=%@&deceased_id=%@", strToken, deceasedInfo.deceased_id];
        [deviceToken_urlRequest setHTTPBody:[http_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSHTTPURLResponse *response;
        NSError *error = nil;
        
        NSData *result = [NSURLConnection sendSynchronousRequest:deviceToken_urlRequest returningResponse:&response error:&error];
        
        if (result && response.statusCode == 200) {
            //成功
        } else {
            //失敗
        }
    }
}

//アプリがすでに動作中の場合のPUSH通知の処理
- (void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //デバイストークンを取得
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults stringForKey:KEY_DEVICE_TOKEN];
    
    
    //通知日を取得
    NSString *noticeSchedule = [userInfo objectForKey:@"notice_schedule"];
    //おはよう送信者を取得
    NSString *callName = [userInfo objectForKey:@"call_name"];
    
    //お知らせ通知の場合
    if ([noticeSchedule length] != 0) {
        //通知日を元に通知情報を取得してURLを生成する
        //サーバーからお知らせ情報を取得
        NSString *noticeInfo_urlAsString = GET_NOTICE_INFO_TOKEN;
        NSURL *noticeInfo_url = [NSURL URLWithString:noticeInfo_urlAsString];
        
        //POSTメソッドのHTTPリクエストを生成する
        NSMutableURLRequest *noticeInfo_urlRequest = [NSMutableURLRequest requestWithURL:noticeInfo_url];
        [noticeInfo_urlRequest setHTTPMethod:@"POST"];
        
        //パラメータを付与
        NSString *noticeInfo_body = [NSString stringWithFormat:@"noticeSchedule=%@&deviceToken=%@",noticeSchedule, deviceToken];
        [noticeInfo_urlRequest setHTTPBody:[noticeInfo_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSHTTPURLResponse *noticeInfo_response;
        NSError *noticeInfo_error = nil;
        
        //HTTP同期通信を実行
        NSData *noticeInfoJsonData = [NSURLConnection sendSynchronousRequest:noticeInfo_urlRequest returningResponse:&noticeInfo_response error:&noticeInfo_error];
        
        //データを取得してURLを生成
        NSString *noticeInfoUrl;
        if (noticeInfoJsonData && noticeInfo_response.statusCode == 200) {
            //データが存在する場合表示する
            if ((noticeInfoJsonData.length > 0) == YES ) {
                //JSONのデータを読み込む
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:noticeInfoJsonData options:NSJSONReadingAllowFragments error:&noticeInfo_error];
                NSDictionary *jsonNoticeInfoObject = [jsonObject objectForKey:@"noticeInfo"];
                
                //取得したお知らせ情報からURLを生成し、お知らせ画面に設定
                for (NSDictionary *dObj in jsonNoticeInfoObject) {
                    int noticeInfoNo = [[dObj objectForKey:@"notice_info_no"] intValue];
                    int entryMethod = [[dObj objectForKey:@"entry_method"] intValue];
                    NSString *url = [dObj objectForKey:@"url"];
                    NSString *deceasedID = [dObj objectForKey:@"deceased_id"];
                    
                    if (entryMethod == ENTRY_METHOD_INPUT) {
                        noticeInfoUrl = [VIEW_NOTICE_INFO stringByAppendingFormat:@"?nino=%d&deceased_id=%@", noticeInfoNo, deceasedID];
                    } else if (entryMethod == ENTRY_METHOD_URL) {
                        noticeInfoUrl = url;
                    }
                    
                    //お知らせ画面を表示する
                    NoticeInfoViewController *noticeInfoViewController = [[NoticeInfoViewController alloc] init];
                    noticeInfoViewController.noticeTiming = NOTICE_TIMING_ACTIVE;
                    noticeInfoViewController.url = noticeInfoUrl;
                    noticeInfoViewController.noticeNo = noticeInfoNo;
                    [[self.window rootViewController] addChildViewController:noticeInfoViewController];
                    [[self.window rootViewController].view addSubview:noticeInfoViewController.view];
                    [noticeInfoViewController didMoveToParentViewController:[self.window rootViewController]];
                }
            }
        }
    }
    
    //おはよう送信の場合（アプリがアクティブの場合、アラートを表示する）
    if ([callName length] != 0 && ![callName isEqualToString:@"reinstall"]) {
        //画面を表示する
        //        DataTransferKeyNoticeViewController *otherDataTransferKeyNoticeViewController = [[DataTransferKeyNoticeViewController alloc] init];
        //        otherDataTransferKeyNoticeViewController.callName = callName;
        
        NSUserDefaults *defaults;
        defaults = [NSUserDefaults standardUserDefaults];
        
        //「毎日おはよう掲示板」に遷移
        NicefacePushViewController *nicefacePushViewController = [[NicefacePushViewController alloc] init];
        
        NSString *appliId = [defaults stringForKey:KEY_MEMBER_APPLI_ID];              // アプリID取得
//        NSString *callName = [defaults stringForKey:KEY_MEMBER_SENDAR_NAME];          // 発信者名取得
        
        nicefacePushViewController.appli_id = appliId;
        nicefacePushViewController.call_name = callName;
        nicefacePushViewController.call_timing = 1;
        
        [[self.window rootViewController] addChildViewController:nicefacePushViewController];
        [[self.window rootViewController].view addSubview:nicefacePushViewController.view];
        [nicefacePushViewController didMoveToParentViewController:[self.window rootViewController]];
        
    }
    
    //利用者追加の場合
    if ([callName isEqualToString:@"reinstall"]) {
    }
    
    if (app.applicationState == UIApplicationStateActive) {             //フォアグラウンドの場合
        //        NSLog(@"アプリ起動中　フォアグラウンド　notice_schedule:%@", noticeSchedule);
    } else if (app.applicationState == UIApplicationStateInactive) {    //バックグラウンドの場合
        //        NSLog(@"アプリ起動中　バックグラウンド　notice_schedule:%@", noticeSchedule);
        //一度バッジを１にしないと通知センターの通知が消えない為１を設定した後０にする
        [app setApplicationIconBadgeNumber: 1];
        [app setApplicationIconBadgeNumber: 0];
        [app cancelAllLocalNotifications];
    }
}

-(void)dispMemorial:(Notification *)notification
{
    if (notification.notice_kind == NOTICE_MONTH_DEATHDAY_BEFORE ||
        notification.notice_kind == NOTICE_MONTH_DEATHDAY) {
        
        //月命日通知画面を開く
        NoticeMonthDeathdayViewController *noticeMonthDeathdayViewController = [[NoticeMonthDeathdayViewController alloc] init];
        noticeMonthDeathdayViewController.notification = notification;
        noticeMonthDeathdayViewController.noticeTiming = NOTICE_TIMING_ACTIVE;
        [[self.window rootViewController] addChildViewController:noticeMonthDeathdayViewController];
        [[self.window rootViewController].view addSubview:noticeMonthDeathdayViewController.view];
        [noticeMonthDeathdayViewController didMoveToParentViewController:[self.window rootViewController]];

    } else if (notification.notice_kind == NOTICE_DEATHDAY_1WEEK_BEFORE ||
               notification.notice_kind == NOTICE_DEATHDAY_BEFORE ||
               notification.notice_kind == NOTICE_DEATHDAY) {
        
        //命日通知画面を開く
        NoticeDeathdayViewController *noticeDeathdayViewController = [[NoticeDeathdayViewController alloc] init];
        noticeDeathdayViewController.notification = notification;
        noticeDeathdayViewController.noticeTiming = NOTICE_TIMING_ACTIVE;
        [[self.window rootViewController] addChildViewController:noticeDeathdayViewController];
        [[self.window rootViewController].view addSubview:noticeDeathdayViewController.view];
        [noticeDeathdayViewController didMoveToParentViewController:[self.window rootViewController]];

    } else if (notification.notice_kind == NOTICE_MEMORIAL_3MONTH_BEFORE ||
               notification.notice_kind == NOTICE_MEMORIAL_1MONTH_BEFORE ||
               notification.notice_kind == NOTICE_MEMORIAL_1WEEK_BEFORE) {

        //法要通知画面を開く
        NoticeMemorialdayViewController *noticeMemorialdayViewController = [[NoticeMemorialdayViewController alloc] init];
        noticeMemorialdayViewController.notification = notification;
        noticeMemorialdayViewController.noticeTiming = NOTICE_TIMING_ACTIVE;
        [[self.window rootViewController] addChildViewController:noticeMemorialdayViewController];
        [[self.window rootViewController].view addSubview:noticeMemorialdayViewController.view];
        [noticeMemorialdayViewController didMoveToParentViewController:[self.window rootViewController]];

    }
}

- (NSArray *)selectMemorialReceive
{
	//DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //トランザクションを開始する
    [memorialDatabase beginTransaction];
    
    //法要通知テーブルのレコードを全件取得
    MemorialReceiveDao *memorialReceiveDao = [MemorialReceiveDao memorialReceiveDaoWithMemorialDatabase:memorialDatabase];
    
    NSArray *notifications = [memorialReceiveDao selectMemorialReceive];

    //DBをコミット
    [memorialDatabase commit];
    //DBを閉じる
    [memorialDatabase close];
    
    return notifications;
}

- (void)deleteMemorialReceiveAll
{
	//DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //トランザクションを開始する
    [memorialDatabase beginTransaction];
    
    //法要通知テーブルのレコードを全件削除
    MemorialReceiveDao *memorialReceiveDao = [MemorialReceiveDao memorialReceiveDaoWithMemorialDatabase:memorialDatabase];
    if (![memorialReceiveDao deleteMemorialReceiveAll]) {
        //DBをロールバック
        [memorialDatabase rollback];
        //DBを閉じる
        [memorialDatabase close];
    }

    //DBをコミット
    [memorialDatabase commit];
    //DBを閉じる
    [memorialDatabase close];
}

@end
