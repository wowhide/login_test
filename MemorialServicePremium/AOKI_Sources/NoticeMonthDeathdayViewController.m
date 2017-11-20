//
//  NoticeMonthDeathdayViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/02/04.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeMonthDeathdayViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "DatabaseHelper.h"
#import "UserDao.h"
#import "User.h"
#import "DeceasedDao.h"
#import "Deceased.h"
#import "Common.h"

@interface NoticeMonthDeathdayViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *noticeScroll;
@property (weak, nonatomic) IBOutlet UIView *noticeScrollView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UILabel *goyomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (weak, nonatomic) IBOutlet UIButton *telButton2;
@property (weak, nonatomic) IBOutlet UIButton *telButton3;
@property (weak, nonatomic) IBOutlet UIButton *telButton4;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;

@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@end

@implementation NoticeMonthDeathdayViewController

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
    
    //UIScrollViewのコンテンツサイズを設定
    self.noticeScroll.contentSize = self.noticeScrollView.bounds.size;
    //スクロールバーを表示
    self.noticeScroll.showsVerticalScrollIndicator = YES;

    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];

    //DBから故人情報を取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //故人情報を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByDeceasedNo:self.notification.deceased_no];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    //前日通知の場合、月命日表示用に１日足した日時を取得
    NSDate *monthDeathday;
    if (self.notification.notice_kind == NOTICE_MONTH_DEATHDAY_BEFORE) {
        monthDeathday = [Common getAddDateDay:1 withDate:self.notification.notice_date];
    } else if (self.notification.notice_kind == NOTICE_MONTH_DEATHDAY) {
        monthDeathday = self.notification.notice_date;
    }

    //画面に設定する
    //通知メッセージ
    self.noticeLabel.text = [NSString stringWithFormat:@"%@は、%@様の月命日です。", [Common getDateString:@"MM月dd日(EEE)" convDate:monthDeathday], deceased.deceased_name];
}

//閉じるボタンクリック時
- (IBAction)appliOpenButtonPushed:(id)sender {
    if (self.noticeTiming == NOTICE_TIMING_ACTIVE) {
        //自画面を閉じる
        [self.view removeFromSuperview];
    } else if (self.noticeTiming == NOTICE_TIMING_PASSIVE) {
        //自画面を閉じる
        [self.view removeFromSuperview];
    }
}

//電話番号クリック時
- (IBAction)telButtonPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.telButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

//電話番号2クリック時
- (IBAction)telButton2Pushed:(id)sender {
    //電話番号2をタッチした場合
    NSString *tel = [self.telButton2.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

//電話番号3クリック時
- (IBAction)telButton3Pushed:(id)sender {
    //電話番号3をタッチした場合
    NSString *tel = [self.telButton3.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];

}

//電話番号4クリック時
- (IBAction)telButton4Pushed:(id)sender {
    //電話番号4をタッチした場合
    NSString *tel = [self.telButton4.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

//Mailクリック時
- (IBAction)mailButtonPushed:(id)sender {
    NSString *mail = self.mailButton.titleLabel.text;
    NSString *mailUrl= [NSString stringWithFormat:@"mailto:%@", mail];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailUrl]];
}

//URLクリック時
- (IBAction)urlButtonPushed:(id)sender {
    //URLをタッチした場合
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlButton.titleLabel.text]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
