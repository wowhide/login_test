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
@property (weak, nonatomic) IBOutlet UILabel *morticianLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@property (weak, nonatomic) IBOutlet UIButton *ryoboDocumentRequestTelButton;
@property (weak, nonatomic) IBOutlet UIButton *aisaikaSougiAboutTelButton;
@property (weak, nonatomic) IBOutlet UIButton *aisaikaDocumentRequestTelButton;

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
    //スクロールのため、height値をプラス
    float width = [[UIScreen mainScreen]bounds].size.width;
    float height = [[UIScreen mainScreen]bounds].size.height+1050;
    
    //UIScrollViewのコンテンツサイズを設定
    self.noticeScroll.contentSize = CGSizeMake(width,height);
    //スクロールバーを表示
    self.noticeScroll.showsVerticalScrollIndicator = YES;

    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];

    //DBから故人情報、葬儀社情報を取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //故人情報を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByDeceasedNo:self.notification.deceased_no];
    
    //QRコードから読み込んだ故人様情報が存在するかチェック
//    BOOL boolQrDeceased = deceasedDao.existenceQrDeceased;
    
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
    self.noticeLabel.text = [NSString stringWithFormat:@"%@は、%@様の月命日でございます。", [Common getDateString:@"MM月dd日(EEE)" convDate:monthDeathday], deceased.deceased_name];
    
    //株式会社ニチリョク葬祭事業部
    self.morticianLabel.text = MORTICIAN_NAME_SOUGI;
//    //郵便番号
//    self.postLabel.text = [NSString stringWithFormat:@"〒%@", MORTICIAN_POST];
//    //住所
//    self.addressLabel.text = MORTICIAN_ADDRESS;
//    [self.addressLabel setNumberOfLines:0];
//    [self.addressLabel sizeToFit];
    //電話番号
//    [self.telButton setTitle:MORTICIAN_TEL forState:UIControlStateNormal];
    //URL
//    [self.urlButton setTitle:MORTICIAN_URL forState:UIControlStateNormal];

}

//閉じるボタンクリック時
- (IBAction)appliOpenButtonPushed:(id)sender {
    if (self.noticeTiming == NOTICE_TIMING_ACTIVE) {
        //自画面を閉じる
        [self.view removeFromSuperview];
    } else if (self.noticeTiming == NOTICE_TIMING_PASSIVE) {
//        //親画面のデリゲート処理を実行
//        [self.delegate hideNoticeMonthDeathdayView:self];
        //自画面を閉じる
        [self.view removeFromSuperview];
    }
}

//電話番号クリック時（株式会社ニチリョク葬祭事業部）
- (IBAction)telButtonPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.telButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}


//電話番号クリック時（霊園・堂内陵墓について））
- (IBAction)telButtonRyoboDocumentRequestPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.ryoboDocumentRequestTelButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

//電話番号クリック時(愛彩花（葬儀について）)
- (IBAction)telButtonAisaikaSougiAboutPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.aisaikaSougiAboutTelButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}


//電話番号クリック時（愛彩花（資料請求））
- (IBAction)telButtonAisaikaDocumentRequestPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.aisaikaDocumentRequestTelButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}


//URLクリック時(愛彩花ホームページへ)
- (IBAction)urlButtonPushed:(id)sender {
    NSString *urlString = MORTICIAN_URL2;
    NSURL *url2 = [NSURL URLWithString:urlString];
    // URLをタップした場合
    [[UIApplication sharedApplication] openURL:url2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
