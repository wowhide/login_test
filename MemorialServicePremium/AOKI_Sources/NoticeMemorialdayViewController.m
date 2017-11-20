//
//  NoticeMemorialdayViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/02/04.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeMemorialdayViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "DatabaseHelper.h"
#import "UserDao.h"
#import "User.h"
#import "DeceasedDao.h"
#import "Deceased.h"
#import "NoticeDao.h"
#import "Notice.h"
#import "Common.h"
#import "CalcNoticeDay.h"
#import "Reachability.h"

@interface NoticeMemorialdayViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *noticeScroll;
@property (weak, nonatomic) IBOutlet UIView *noticeScrollView;

@property (weak, nonatomic) IBOutlet UILabel *goyomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *morticianLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *telButton;
@property (weak, nonatomic) IBOutlet UIButton *telButton2;
@property (weak, nonatomic) IBOutlet UIButton *telButton3;
@property (weak, nonatomic) IBOutlet UIButton *telButton4;

@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;
@property (weak, nonatomic) IBOutlet UILabel *mailResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailAttentionLabel;

@end

@implementation NoticeMemorialdayViewController

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

    //DBから故人情報、葬儀社情報を取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //故人情報を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByDeceasedNo:self.notification.deceased_no];
    
    //近々の未来の法要予定日を取得
    NSDate *memorialday;
    NSArray *memorialdays = [CalcNoticeDay getMemorialArray:deceased.deceased_deathday time:@"0000"];
    for (NSDate *scheduleday in memorialdays) {
        //予定日が未来の場合、memorialdaysに設定してループを抜ける
        if (![Common pastDay:scheduleday]) {
            memorialday = scheduleday;
            break;
        }
    }

    //画面に設定する
    //通知メッセージ
    NSString *memorialdayString = [Common getDateString:@"yyyy年MM月dd日(EEE)" convDate:memorialday];
    NSString *anniversaryString = [Common getAnniversary:self.notification.memorial_no];
    self.noticeLabel.text = [NSString stringWithFormat:@"%@は、%@様の%@のご法要予定です。", memorialdayString, deceased.deceased_name, anniversaryString];
    
    //法要をメール通知
    //利用者情報を取得
    UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userDao selectUser];
    
    //通知先を取得
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    NSArray *notices = [noticeDao selectNoticeByDeceasedNo:self.notification.deceased_no];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    //通知先が設定されているか？
    if ([notices count] > 0) {
        //インターネットに接続できるかチェック、接続できない場合、送信できない旨、ラベルに設定
        Reachability *curReach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            //圏外のときの処理
            self.mailResultLabel.text = @"インターネットに接続できなかった為、法要予定のご案内メールを送信できませんでした。";
            [self.mailResultLabel setNumberOfLines:0];
            [self.mailResultLabel sizeToFit];
            self.mailAttentionLabel.text = @"お手数ですが、通知先の方には個別にご案内願います。";
            [self.mailAttentionLabel setNumberOfLines:0];
            [self.mailAttentionLabel sizeToFit];
            
            return;
        } else {
            //メール送信
            //リクエスト先を指定する
            NSString *sendmail_urlAsString = @"http://ms-aoki.memorial-site.net/Cooperation/sendmemorialmailios";
            for (Notice *notice in notices) {
                NSURL *sendmail_url = [NSURL URLWithString:sendmail_urlAsString];
                
                //POSTメソッドのHTTPリクエストを生成する
                NSMutableURLRequest *sendmail_urlRequest = [NSMutableURLRequest requestWithURL:sendmail_url];
                [sendmail_urlRequest setHTTPMethod:@"POST"];
                //パラメータを付与
                NSString *sendmail_body = [NSString stringWithFormat:@"fromName=%@&deceasedName=%@&memorialday=%@&anniversary=%@&toMail=%@&toName=%@&certification=key", user.name, deceased.deceased_name, memorialdayString, anniversaryString, notice.notice_address, notice.notice_name];
                [sendmail_urlRequest setHTTPBody:[sendmail_body dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSHTTPURLResponse *sendmail_response;
                NSError *sendmail_error = nil;
                
                //HTTP同期通信を実行
                NSData *sendMailResult = [NSURLConnection sendSynchronousRequest:sendmail_urlRequest returningResponse:&sendmail_response error:&sendmail_error];
                
                //送信処理アクセス結果を取得
                if (sendMailResult && sendmail_response.statusCode == 200) {
                    //正常にアクセスできた場合、何もしない
                } else {
                    //画面にエラーメッセージを表示して終了
                    self.mailResultLabel.text = @"法要予定のご案内メールを送信できませんでした。";
                    [self.mailResultLabel setNumberOfLines:0];
                    [self.mailResultLabel sizeToFit];
                    self.mailAttentionLabel.text = @"お手数ですが、通知先の方には個別にご案内願います。";
                    [self.mailAttentionLabel setNumberOfLines:0];
                    [self.mailAttentionLabel sizeToFit];
                    
                    return;
                }
                
            }
            self.mailResultLabel.text = [NSString stringWithFormat:@"%@様の法要予定のご案内メールを通知先に送信しました。", deceased.deceased_name];
            [self.mailResultLabel setNumberOfLines:0];
            [self.mailResultLabel sizeToFit];
            [self.mailAttentionLabel setNumberOfLines:0];
            [self.mailAttentionLabel sizeToFit];
        }
    } else {
        self.mailResultLabel.text = @"";
        self.mailAttentionLabel.text = @"";
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

//mailクリック時
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
