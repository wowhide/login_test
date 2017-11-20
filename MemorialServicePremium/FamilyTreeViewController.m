//
//  FamilyTreeViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/02/02.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "FamilyTreeViewController.h"
#import "Define.h"
#import "IndicatorWindow.h"
#import "Reachability.h"
#import "Define.h"
#import "HttpAccess.h"
#import "PointUser.h"
#import "PointUserInfoViewController.h"
#import "DatabaseHelper.h"
#import "DeceasedDao.h"
#import "Deceased.h"
#import "MenuTabBarViewController.h"

@interface FamilyTreeViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIWebView *FamilyTreeWebView;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar_icon;

@end

@implementation FamilyTreeViewController{
    //UserDefault
    PointUser *user;
    int deceasedCount;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    
    //ルートタブビューを隠す
    self.tabBarController.tabBar.hidden = YES;
    //タブビューのアイコン
    self.tabBar_icon.image = [UIImage imageNamed:@"tab_deceased_list"];
    //タブビュータイトル
    self.tabBar_icon.title = @"メニュー";

    self.tabbar.delegate = self;
    
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
  
    //ユーザーデフォルトにアクセス
    user = [PointUser new];
    
    //名前
    [user loadUserDefaults];
    
    //ユーザーIDがなければ、個人情報ページに遷移
    if (user.userId.length == 0) {
        
    [self.navigationController pushViewController:[PointUserInfoViewController new] animated:YES];

    }
    
    //Webビューを表示
    //インジケーター開始
    [IndicatorWindow openWindow];
    
    //ここから下テスト
    
    // URL指定
    NSURL *url = [NSURL URLWithString:@"http://wow-d.net/Family_Tree/orderpage/entry"];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    // POST指定
    req.HTTPMethod = @"POST";
    // BODYに登録、設定
    NSString *body = [NSString stringWithFormat:@"userid=%@&username=%@&userbirthday=%@",user.userId,user.userName,user.birthday];
    req.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];

    // リクエスト送信
    [self.FamilyTreeWebView loadRequest:req];
    
    // 画面に表示
    [self.view addSubview:self.FamilyTreeWebView];
    
    //Webの拡大縮小有効化
    [self.FamilyTreeWebView setScalesPageToFit:YES];
    [self.FamilyTreeWebView setDelegate:self];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
//    //DBに接続する
//    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
//    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
//    
//    //故人情報を取得
//    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
//    Deceased *deceased = [deceasedDao selectDeceasedfamilytree];
//    
//    //故人情報の件数を取得
//    DeceasedDao *deceasedDaocount = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
//    
//    deceasedCount = [deceasedDaocount countDeceased];
//    
//    
//    
//    
//    NSLog(@"故人件数は%d", deceasedCount);
//    
//    
//    
//    NSArray *newArr = @[deceased.deceased_name];
//    
//    NSString *newItem = newArr[0];
//    
//    
//    NSLog(@"家系図使用名前テーブルnewItem家系図は%@", newItem);
//    
//    HttpAccess *httpAccess = [HttpAccess new];
//    NSString *parameter = newItem;
//    [httpAccess getdeceasename:TEST_DESEASE_LIST param:parameter];
//    
//    
//    //セルに故人名を設定
//    
//    //データーベースを閉じる
//    [memorialDatabase close];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //キャッシュを全て消去
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    return true;
}

- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item{
    
    //切り替えに応じた処理
    if (item.tag == 1) {
        
        
    }else if (item.tag == 0) {
        //トップメニュー画面のインスタンスを生成
        MenuTabBarViewController *menutabBarViewController = [MenuTabBarViewController new];
        
        // Tab bar を非表示
        //トップメニュー画面に遷移
        [self.navigationController pushViewController:menutabBarViewController animated:NO];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//WebView読み込み開始時
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //インジケーター開始
    [IndicatorWindow openWindow];
}

//WebView読み込み完了時
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    // 長押し禁止
    //    [self.helpSubWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout = 'none';"];
}

//WebView読み込み失敗時
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //エラーメッセージを表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"ページを読み込めませんでした。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}

@end
