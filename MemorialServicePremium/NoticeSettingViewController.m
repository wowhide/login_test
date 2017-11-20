//
//  NoticeSettingViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/09.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeSettingViewController.h"
#import "Define.h"
#import "Common.h"
#import "Toast+UIView.h"
#import "DatabaseHelper.h"
#import "UserDao.h"
#import "User.h"

@interface NoticeSettingViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *noticeScroll;
@property (weak, nonatomic) IBOutlet UIView *noticeScrollView;

@property (weak, nonatomic) IBOutlet UISwitch *monthDeathdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deathday1weekBeforeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deathdayBeforeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *deathdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *memorial3monthBeforeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *memorial1monthBeforeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *memorial1weekBeforeSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *timeStepper;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation NoticeSettingViewController

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
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //UIScrollViewのコンテンツサイズを設定
    self.noticeScroll.contentSize = self.noticeScrollView.bounds.size;
    //スクロールバーを表示
    self.noticeScroll.showsVerticalScrollIndicator = YES;
    

}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSURL *url;
    switch (buttonIndex) {
        case 0:
            //「はい」ボタン押下時
            //設定画面に遷移
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
            break;
        case 1:
            //「いいえ」ボタン押下時
            //メニュー画面に戻る
            [self.navigationController popViewControllerAnimated:NO];
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //DBから通知設定情報（利用者情報）を取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //利用者情報を取得
    UserDao *userdDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userdDao selectUser];
    //データーベースを閉じる
    [memorialDatabase close];
    
    //取得した値を元に画面にセット
    //月命日
/*
    //前日
    if (NOTICE_YES == user.notice_month_deathday_before) {
        self.monthDeathdayBeforeSwitch.on = YES;    //スイッチをONにする
    } else {
        self.monthDeathdayBeforeSwitch.on = NO;     //スイッチをOFFにする
    }
*/
    //当日
    if (NOTICE_YES == user.notice_month_deathday) {
        self.monthDeathdaySwitch.on = YES;    //スイッチをONにする
    } else {
        self.monthDeathdaySwitch.on = NO;     //スイッチをOFFにする
    }
    
    //命日
    //１週間前
    if (NOTICE_YES == user.notice_deathday_1week_before) {
        self.deathday1weekBeforeSwitch.on = YES;    //スイッチをONにする
    } else {
        self.deathday1weekBeforeSwitch.on = NO;     //スイッチをOFFにする
    }
    //前日
    if (NOTICE_YES == user.notice_deathday_before) {
        self.deathdayBeforeSwitch.on = YES;    //スイッチをONにする
    } else {
        self.deathdayBeforeSwitch.on = NO;     //スイッチをOFFにする
    }
    //当日
    if (NOTICE_YES == user.notice_deathday) {
        self.deathdaySwitch.on = YES;    //スイッチをONにする
    } else {
        self.deathdaySwitch.on = NO;     //スイッチをOFFにする
    }
    
    //法要
    //3ヶ月前
    if (NOTICE_YES == user.notice_memorial_3month_before) {
        self.memorial3monthBeforeSwitch.on = YES;    //スイッチをONにする
    } else {
        self.memorial3monthBeforeSwitch.on = NO;     //スイッチをOFFにする
    }
    //1ヶ月前
    if (NOTICE_YES == user.notice_memorial_1month_before) {
        self.memorial1monthBeforeSwitch.on = YES;    //スイッチをONにする
    } else {
        self.memorial1monthBeforeSwitch.on = NO;     //スイッチをOFFにする
    }
    //1週間前
    if (NOTICE_YES == user.notice_memorial_1week_before) {
        self.memorial1weekBeforeSwitch.on = YES;    //スイッチをONにする
    } else {
        self.memorial1weekBeforeSwitch.on = NO;     //スイッチをOFFにする
    }
    
    //通知時間
    //画面に設定
    self.timeLabel.text = [Common getTimeStringJ:user.notice_time];
    //ステッパーのプロパティの設定
    //文字列を数値に変換
    int hour = [[user.notice_time substringWithRange:NSMakeRange(0, 2)] intValue];
    self.timeStepper.value = hour;
    self.timeStepper.minimumValue = 0;
    self.timeStepper.maximumValue = 23;
    self.timeStepper.stepValue = 1;
}

//通知時間ステッパー変更時
- (IBAction)timeStepperChanged:(id)sender
{
    NSString *noticeTime = [Common getTimeString:(int)self.timeStepper.value];
    self.timeLabel.text = [Common getTimeStringJ:noticeTime];
}

//保存ボタンクリック時
- (IBAction)saveButtonPushed:(id)sender {
    
    //「通知設定」が不許可になっているか確認
    NSUInteger types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    
    // 不許可の場合
    if (types == UIUserNotificationTypeNone) {
        
        //アラートメッセージ作成
        NSString *alertMessage = @"\n法要・命日等の通知の為、通知を許可してください。よろしいですか。";
        NSString *str = [NSString stringWithFormat:@"%@",alertMessage];
        
        //アラートビュー表示
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"通知許可のお願い";
        alert.message = str;
        [alert addButtonWithTitle:@"はい"];
        [alert addButtonWithTitle:@"いいえ"];
        [alert show];
       
        return;
    }

    //DBから通知設定情報（利用者情報）を取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //利用者情報を取得
    UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userDao selectUser];
    
    //通知設定userにセット
    //月命日
/*
    //前日
    if (self.monthDeathdayBeforeSwitch.on) {
        user.notice_month_deathday_before = NOTICE_YES;
    } else {
        user.notice_month_deathday_before = NOTICE_NO;
    }
*/
    //当日
    if (self.monthDeathdaySwitch.on) {
        user.notice_month_deathday = NOTICE_YES;
    } else {
        user.notice_month_deathday = NOTICE_NO;
    }
    
    //命日
    //１週間前
    if (self.deathday1weekBeforeSwitch.on) {
        user.notice_deathday_1week_before = NOTICE_YES;
    } else {
        user.notice_deathday_1week_before = NOTICE_NO;
    }
    //前日
    if (self.deathdayBeforeSwitch.on) {
        user.notice_deathday_before = NOTICE_YES;
    } else {
        user.notice_deathday_before = NOTICE_NO;
    }
    //当日
    if (self.deathdaySwitch.on) {
        user.notice_deathday = NOTICE_YES;
    } else {
        user.notice_deathday = NOTICE_NO;
    }
    //法要
    //3ヶ月前
    if (self.memorial3monthBeforeSwitch.on) {
        user.notice_memorial_3month_before = NOTICE_YES;
    } else {
        user.notice_memorial_3month_before = NOTICE_NO;
    }
    //1ヶ月前
    if (self.memorial1monthBeforeSwitch.on) {
        user.notice_memorial_1month_before = NOTICE_YES;
    } else {
        user.notice_memorial_1month_before = NOTICE_NO;
    }
    //1週間前
    if (self.memorial1weekBeforeSwitch.on) {
        user.notice_memorial_1week_before = NOTICE_YES;
    } else {
        user.notice_memorial_1week_before = NOTICE_NO;
    }

    //通知時間
    user.notice_time = [Common getTimeString:(int)self.timeStepper.value];
    
    //DBを上書き
    if (![userDao updateNotice:user]) {
        //DBを閉じる
        [memorialDatabase close];
        //エラートースト表示
        [self.view makeToast:@"保存に失敗しました。\nもう一度保存して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

    //DBを閉じる
    [memorialDatabase close];
    //アラート表示
    [self.view makeToast:@"保存が完了しました" duration:TOAST_DURATION_NOTICE position:@"center"];
}

- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
