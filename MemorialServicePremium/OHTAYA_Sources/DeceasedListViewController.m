//
//  DeceasedListViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/09.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//


#import "DeceasedListViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "DatabaseHelper.h"
#import "DeceasedDao.h"
#import "Deceased.h"
#import "DeceasedInfoReadViewController.h"
#import "DeceasedInfoEntryViewController.h"
#import "QrCodeReadViewController.h"
#import "NoticeSettingViewController.h"
#import "Define.h"
#import "TopMenuViewController.h"
#import "HttpAccess.h"

@interface DeceasedListViewController () {
    NSString *_morticianUrl;
    int deceasedCount;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UILabel *morticianLabel;
@property (weak, nonatomic) IBOutlet UITableView *deceasedTable;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar_icon;

@end

//DeceasedListViewControllerの実装
@implementation DeceasedListViewController

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

    //背景色を設定
    self.view.backgroundColor = [UIColor colorWithRed:TITLE_BG_COLOR_RED green:TITLE_BG_COLOR_GREEN blue:TITLE_BG_COLOR_BLUE alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 選択時のカラー（アイコン＋テキスト）
    self.tabbar.tintColor = [UIColor colorWithRed:0.529 green:0.529 blue:0.529 alpha:1.0];

    [self.deceasedTable setDataSource:self];
    [self.deceasedTable setDelegate:self];

    //葬儀社情報が存在する場合、葬儀社名のラベルに葬儀社名を設定
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //QRコードから読み込んだ故人様情報が存在するかチェック
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    BOOL boolQrDeceased = deceasedDao.existenceQrDeceased;

    //DBを閉じる
    [memorialDatabase close];
    
    if (boolQrDeceased) {
        //葬儀社情報が存在する場合、葬儀社名のラベルに葬儀社名を設定
        self.morticianLabel.text = MORTICIAN_NAME;
        self.morticianLabel.tag = 1;
        self.morticianLabel.userInteractionEnabled = YES;
        
        CGSize maxSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        CGSize fitSize = [self.morticianLabel sizeThatFits:maxSize];
        
        int diff = fitSize.width - self.morticianLabel.frame.size.width;
        self.morticianLabel.frame = CGRectMake(self.morticianLabel.frame.origin.x - diff,
                                               self.morticianLabel.frame.origin.y,
                                               fitSize.width,
                                               self.morticianLabel.frame.size.height);
        
        //URLをインスタンス変数に設定
        _morticianUrl = MORTICIAN_URL;
        
        //表示する
        self.morticianLabel.hidden = NO;
    } else {
        //葬儀社情報が存在しない場合、葬儀社名ラベルを非表示にする
        self.morticianLabel.hidden = YES;
    }

    //テーブルを読み込み直す
    [self.deceasedTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //故人情報の件数を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    deceasedCount = [deceasedDao countDeceased];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    return deceasedCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeceasedCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeceasedCell"];
    }
    
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //故人情報を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByOffset:(int)indexPath.row];
    
    //セルに故人名を設定
    cell.textLabel.text = [NSString stringWithFormat:@"%@　様", deceased.deceased_name];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    //矢印を表示
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //故人情報画面のインスタンスを生成し、プロパティに故人情報をセットする
    DeceasedInfoReadViewController *deceasedInfoReadViewController = [[DeceasedInfoReadViewController alloc] init];
    
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //故人情報を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByOffset:(int)indexPath.row];
    //プロパティに故人情報をセット
    deceasedInfoReadViewController.deceasedNo = deceased.deceased_no;
    //データーベースを閉じる
    [memorialDatabase close];
    
    //テーブルの選択状態を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //pushViewControllerしたとき、tabBarも一緒に隠す
    deceasedInfoReadViewController.hidesBottomBarWhenPushed = YES;
    
    //故人情報画面に遷移
    [self.navigationController pushViewController:deceasedInfoReadViewController animated:YES];
}

//画面のタッチイベント
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view.tag == self.morticianLabel.tag) {
        //URLをタッチした場合
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_morticianUrl]];
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

//QR読込ボタンクリック時
- (IBAction)qrButtonPushed:(id)sender {
    //故人様が10件以上の場合、トーストで警告を表示する
    if (deceasedCount >= 10) {
        [self.view makeToast:@"登録できる故人様は10名までです。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

    //インターネットの接続状態を取得
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //接続できない場合
        [self.view makeToast:@"ネットワークに接続できる環境で読み込んで下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    //インターネットに接続可能な場合、QR読込画面を表示
    QrCodeReadViewController *qrCodeReadViewController = [[QrCodeReadViewController alloc] init];
    qrCodeReadViewController.delegate = self;
    qrCodeReadViewController.fromView = QR_READ_VIEW_FROM_DECEASED_LIST;
    [self presentViewController:qrCodeReadViewController animated:YES completion:nil];

}

//QR読込画面が閉じた後に呼ばれるデリゲート
- (void)hideQrCodeReadView:(BOOL)readBool
{
//    NSLog(@"DeceasedListViewController hideQrCodeReadView");
    
    if (readBool) {
        //テーブルを読み込み直す
        [self.deceasedTable reloadData];
    }

    //QR読み込み画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

//故人様追加ボタンクリック時
- (IBAction)deceasedAddPushed:(id)sender {
    //故人様が10件以上の場合、トーストで警告を表示する
    if (deceasedCount >= 10) {
        [self.view makeToast:@"登録できる故人様は10名までです。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

    DeceasedInfoEntryViewController *deceasedInfoEntryViewController = [[DeceasedInfoEntryViewController alloc] init];
        
    [self.navigationController pushViewController:deceasedInfoEntryViewController animated:YES];
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{    
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
