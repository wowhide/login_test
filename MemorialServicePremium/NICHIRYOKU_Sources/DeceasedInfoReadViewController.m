//
//  DeceasedInfoReadViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/09.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "DeceasedInfoReadViewController.h"
#import "Deceased.h"
#import "Common.h"
#import "Define.h"
#import "DeceasedDao.h"
#import "NoticeDao.h"
#import "DeceasedInfoEditViewController.h"
#import "NoticeMailSettingViewController.h"
#import "QrDeceasedInfoEditViewController.h"
#import "NoticeSettingViewController.h"
#import "MenuTabBarViewController.h"
#import "Toast+UIView.h"
#import "HttpAccess.h"
#import "Reachability.h"
#import "IndicatorWindow.h"

@interface DeceasedInfoReadViewController () {
    Deceased *_deceased;
    NSString *memberId;
    NSUserDefaults *defaults;
    //アプリID
    NSString *appliId;
    
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@property (weak, nonatomic) IBOutlet UIScrollView *deceasedScroll;
@property (weak, nonatomic) IBOutlet UIView *deceasedScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *deathdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *deathAgeLabel;

@property (weak, nonatomic) IBOutlet UILabel *al001;
@property (weak, nonatomic) IBOutlet UILabel *al003;
@property (weak, nonatomic) IBOutlet UILabel *al007;
@property (weak, nonatomic) IBOutlet UILabel *al013;
@property (weak, nonatomic) IBOutlet UILabel *al017;
@property (weak, nonatomic) IBOutlet UILabel *al023;
@property (weak, nonatomic) IBOutlet UILabel *al025;
@property (weak, nonatomic) IBOutlet UILabel *al027;
@property (weak, nonatomic) IBOutlet UILabel *al033;
@property (weak, nonatomic) IBOutlet UILabel *al037;
@property (weak, nonatomic) IBOutlet UILabel *al050;
@property (weak, nonatomic) IBOutlet UILabel *al100;

@property (weak, nonatomic) IBOutlet UILabel *a001;
@property (weak, nonatomic) IBOutlet UILabel *a003;
@property (weak, nonatomic) IBOutlet UILabel *a007;
@property (weak, nonatomic) IBOutlet UILabel *a013;
@property (weak, nonatomic) IBOutlet UILabel *a017;
@property (weak, nonatomic) IBOutlet UILabel *a023;
@property (weak, nonatomic) IBOutlet UILabel *a025;
@property (weak, nonatomic) IBOutlet UILabel *a027;
@property (weak, nonatomic) IBOutlet UILabel *a033;
@property (weak, nonatomic) IBOutlet UILabel *a037;
@property (weak, nonatomic) IBOutlet UILabel *a050;
@property (weak, nonatomic) IBOutlet UILabel *a100;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar_icon;

@end

//#define DocumentsFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation DeceasedInfoReadViewController

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
    
    //タブビューのアイコン
    self.tabBar_icon.image = [UIImage imageNamed:@"tab_notice_setting"];
    //タブビュータイトル
    self.tabBar_icon.title = @"通知設定";
    //デリゲード
    self.tabbar.delegate = self;
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];              // 会員番号取得
    appliId = [defaults stringForKey:KEY_MEMBER_APPLI_ID];              // アプリID取得
    
    // 選択時のカラー（アイコン＋テキスト）
    self.tabbar.tintColor = [UIColor colorWithRed:0.706 green:0.706 blue:0.706 alpha:1.0];
    
    //DBからデータを取得
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    //取得
    _deceased = [deceasedDao selectDeceasedByDeceasedNo:self.deceasedNo];
    //DBを閉じる
    [memorialDatabase close];
    
    //QRから読込んだ故人様の場合、削除ボタンを無効
    if (_deceased.qr_flg == QR_FLG_YES) {
        self.deleteButton.enabled = NO;
    }
    
    //UIScrollViewのコンテンツサイズを設定
    self.deceasedScroll.contentSize = self.deceasedScrollView.bounds.size;
    //スクロールバーを表示
    self.deceasedScroll.showsVerticalScrollIndicator = YES;
    
    //プロパティにセットされた故人情報を画面に設定
    //1.写真
    //UIImageView内に収まる最大サイズで表示する
    self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
    //写真ファイルを読み込む
    NSString *readpath_Image = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, _deceased.deceased_id];
    NSFileHandle *file_Image = [NSFileHandle fileHandleForReadingAtPath:readpath_Image];
    
    NSLog(@"This deceased_photo:%@",_deceased.deceased_photo_path);

    //写真ファイルが存在するか
    UIImage *image;
    if (file_Image) {
        NSData *data = [file_Image readDataToEndOfFile];
        image = [UIImage imageWithData:data];
        [file_Image closeFile];
    } else {
        // なければ代替え画像を設定
        image = [UIImage imageNamed:@"nothing"];
    }
    self.photoImage.image = image;
    
    //2.お名前
    self.nameLabel.text = [NSString stringWithFormat:@"%@　様", _deceased.deceased_name];
    
    //3.生年月日
    self.birthdayLabel.text = [Common getDateStringJ:_deceased.deceased_birthday format:@"%@年%@月%@日"];
    
    //4.没年月日
    self.deathdayLabel.text = [Common getDateStringJ:_deceased.deceased_deathday format:@"%@年%@月%@日"];
    
    //5.没年齢
    self.deathAgeLabel.text = [Common getDeathAgeString:_deceased.death_age kyonenGyonenFlg:_deceased.kyonen_gyonen_flg];
    
    //6.法要予定
    self.a001.text = [Common getAnniversaryString:1 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:1 deathday:_deceased.deceased_deathday]]) {
        self.al001.textColor = [UIColor grayColor];
        self.a001.textColor = [UIColor grayColor];
    } else {
        self.al001.textColor = [UIColor blackColor];
        self.a001.textColor = [UIColor blackColor];
    }
    self.a003.text = [Common getAnniversaryString:2 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:2 deathday:_deceased.deceased_deathday]]) {
        self.al003.textColor = [UIColor grayColor];
        self.a003.textColor = [UIColor grayColor];
    } else {
        self.al003.textColor = [UIColor blackColor];
        self.a003.textColor = [UIColor blackColor];
    }
    self.a007.text = [Common getAnniversaryString:6 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:6 deathday:_deceased.deceased_deathday]]) {
        self.al007.textColor = [UIColor grayColor];
        self.a007.textColor = [UIColor grayColor];
    } else {
        self.al007.textColor = [UIColor blackColor];
        self.a007.textColor = [UIColor blackColor];
    }
    self.a013.text = [Common getAnniversaryString:12 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:12 deathday:_deceased.deceased_deathday]]) {
        self.al013.textColor = [UIColor grayColor];
        self.a013.textColor = [UIColor grayColor];
    } else {
        self.al013.textColor = [UIColor blackColor];
        self.a013.textColor = [UIColor blackColor];
    }
    self.a017.text = [Common getAnniversaryString:16 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:16 deathday:_deceased.deceased_deathday]]) {
        self.al017.textColor = [UIColor grayColor];
        self.a017.textColor = [UIColor grayColor];
    } else {
        self.al017.textColor = [UIColor blackColor];
        self.a017.textColor = [UIColor blackColor];
    }
    self.a023.text = [Common getAnniversaryString:22 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:22 deathday:_deceased.deceased_deathday]]) {
        self.al023.textColor = [UIColor grayColor];
        self.a023.textColor = [UIColor grayColor];
    } else {
        self.al023.textColor = [UIColor blackColor];
        self.a023.textColor = [UIColor blackColor];
    }
    self.a025.text = [Common getAnniversaryString:24 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:24 deathday:_deceased.deceased_deathday]]) {
        self.al025.textColor = [UIColor grayColor];
        self.a025.textColor = [UIColor grayColor];
    } else {
        self.al025.textColor = [UIColor blackColor];
        self.a025.textColor = [UIColor blackColor];
    }
    self.a027.text = [Common getAnniversaryString:26 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:26 deathday:_deceased.deceased_deathday]]) {
        self.al027.textColor = [UIColor grayColor];
        self.a027.textColor = [UIColor grayColor];
    } else {
        self.al027.textColor = [UIColor blackColor];
        self.a027.textColor = [UIColor blackColor];
    }
    self.a033.text = [Common getAnniversaryString:32 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:32 deathday:_deceased.deceased_deathday]]) {
        self.al033.textColor = [UIColor grayColor];
        self.a033.textColor = [UIColor grayColor];
    } else {
        self.al033.textColor = [UIColor blackColor];
        self.a033.textColor = [UIColor blackColor];
    }
    self.a037.text = [Common getAnniversaryString:36 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:36 deathday:_deceased.deceased_deathday]]) {
        self.al037.textColor = [UIColor grayColor];
        self.a037.textColor = [UIColor grayColor];
    } else {
        self.al037.textColor = [UIColor blackColor];
        self.a037.textColor = [UIColor blackColor];
    }
    self.a050.text = [Common getAnniversaryString:49 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:49 deathday:_deceased.deceased_deathday]]) {
        self.al050.textColor = [UIColor grayColor];
        self.a050.textColor = [UIColor grayColor];
    } else {
        self.al050.textColor = [UIColor blackColor];
        self.a050.textColor = [UIColor blackColor];
    }
    self.a100.text = [Common getAnniversaryString:99 deathday:_deceased.deceased_deathday];
    if ([Common pastDay:[Common getAnniversaryDate:99 deathday:_deceased.deceased_deathday]]) {
        self.al100.textColor = [UIColor grayColor];
        self.a100.textColor = [UIColor grayColor];
    } else {
        self.al100.textColor = [UIColor blackColor];
        self.a100.textColor = [UIColor blackColor];
    }
}

//タブバーアイコンクリック時
- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item{
    
    //切り替えに応じた処理
    if (item.tag == 0) {
        
    }else if (item.tag == 1) {
        //通知設定画面のインスタンスを生成
        NoticeSettingViewController *noticesettingViewController = [NoticeSettingViewController new];
        
        //通知設定画面に遷移
        [self.navigationController pushViewController:noticesettingViewController animated:NO];
    }
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender
{
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//削除ボタンクリック時
- (IBAction)deleteButtonPushed:(id)sender
{
    
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
    
    //削除確認アラートを表示する
    NSString *title = [NSString stringWithFormat:@"%@様のデータを削除します。", _deceased.deceased_name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"よろしいですか？" delegate:self cancelButtonTitle:@"いいえ" otherButtonTitles:@"はい", nil];
    //アラート表示
    [alert show];
}

//アラートボタンクリック時の処理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //「はい」ボタンがクリックされた場合
    if (1 == buttonIndex) {
        
        //会員番号QRを読み込んでいる場合
        BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
        
        if (transfer_download) {
            //対象故人をDBから削除、故人データアップデートカウント＿１プラスする処理
            HttpAccess *httpAccess = [HttpAccess new];
            NSMutableDictionary *parameter = [@{@"appli_id":appliId,@"deceased_no":[NSString stringWithFormat:@"%d", self.deceasedNo]} mutableCopy];
            [httpAccess POST:DELETE_DECEASED_ID param:parameter];
        }

        //DBからレコードを削除
        //DBに接続
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        [memorialDatabase beginTransaction];
        
        DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
        
        //故人情報削除実行
        if ([deceasedDao deleteDeceased:_deceased.deceased_no] == NO) {
            [self.view makeToast:@"削除に失敗しました。\nもう一度実行して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
            //データーベースをロールバック
            [memorialDatabase rollback];
            //データーベースを閉じる
            [memorialDatabase close];
            //終了
            return;
        }
        
        NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
        
        //通知先情報削除実行
        if ([noticeDao deleteNoticeByDeceasedNo:_deceased.deceased_no] == NO) {
            [self.view makeToast:@"削除に失敗しました。\nもう一度実行して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
            //データーベースをロールバック
            [memorialDatabase rollback];
            //データーベースを閉じる
            [memorialDatabase close];
            //終了
            return;
        }
        
        //写真を登録している故人データの場合、写真ファイルを削除
        if (_deceased.deceased_photo_path.length > 0) {
            //写真ファイルを読み込む
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, _deceased.deceased_photo_path];
            // ファイルマネージャを作成
            NSFileManager *fileManager = [NSFileManager defaultManager];
            // ファイルが存在する場合、削除
            if ([fileManager fileExistsAtPath:filePath]) {
                NSError *error;
                // ファイルを削除
                BOOL result = [fileManager removeItemAtPath:filePath error:&error];
                if (!result) {
                    [self.view makeToast:@"削除に失敗しました。\nもう一度実行して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
                    //データーベースをロールバック
                    [memorialDatabase rollback];
                    //データーベースを閉じる
                    [memorialDatabase close];
                    //終了
                    return;
                }
            }
        }
        
        //コミット
        [memorialDatabase commit];
        //DBを閉じる
        [memorialDatabase close];
        
        
        
        //上の階層に戻る
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//編集ボタンクリック時
- (IBAction)editButtonPushed:(id)sender
{    
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
    
    //QRから読込んだ故人様と手入力で追加した故人様で、編集画面を変える
    if (_deceased.qr_flg == QR_FLG_YES) {
        //故人情報編集画面(QR版)のインスタンスを生成し、プロパティに故人Noをセットする
        QrDeceasedInfoEditViewController *qrDeceasedInfoEditViewController = [[QrDeceasedInfoEditViewController alloc] init];
        //プロパティに故人Noをセット
        qrDeceasedInfoEditViewController.deceasedNo = self.deceasedNo;
        
        //故人情報編集画面(QR版)に遷移
        [self.navigationController pushViewController:qrDeceasedInfoEditViewController animated:NO];
    } else if (_deceased.qr_flg == QR_FLG_NO) {
        //故人情報編集画面(手入力版)のインスタンスを生成し、プロパティに故人Noをセットする
        DeceasedInfoEditViewController *deceasedInfoEditViewController = [[DeceasedInfoEditViewController alloc] init];
        //プロパティに故人Noをセット
        deceasedInfoEditViewController.deceasedNo = self.deceasedNo;
        
        //故人情報編集画面(手入力版)に遷移
        [self.navigationController pushViewController:deceasedInfoEditViewController animated:NO];
    }
}

//法要通知先ボタンクリック時
- (IBAction)noticeButtonPushed:(id)sender
{
    //法要通知先設定画面のインスタンスを生成し、プロパティに故人Noをセットする
    NoticeMailSettingViewController *noticeMailSettingViewController = [[NoticeMailSettingViewController alloc] init];
    //プロパティに故人Noをセット
    noticeMailSettingViewController.deceasedNo = self.deceasedNo;
    
    //法要通知先設定画面に遷移
    [self.navigationController pushViewController:noticeMailSettingViewController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
