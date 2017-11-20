//
//  NicefaceViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/04/04.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "NicefaceViewController.h"
#import "MenuTabBarViewController.h"
#import "CallNameSettingViewController.h"
#import "Define.h"
#import "IndicatorWindow.h"
#import "Reachability.h"

@interface NicefaceViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIWebView *NiceFaceWebView;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar_icon;


@end

@implementation NicefaceViewController{
    //会員番号
    NSString *memberId;
    //アプリID
    NSString *appliId;
    //発信者名
    NSString *callName;

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
    self.tabBar_icon.image = [[UIImage imageNamed:@"tab_deceased_list"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    self.tabbar.delegate = self;
    
    self.tabBar_icon.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    
    
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
    
    //ユーザーデフォルト
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];   // 取得
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];              // 会員番号取得
    appliId = [defaults stringForKey:KEY_MEMBER_APPLI_ID];              // アプリID取得
    callName = [defaults stringForKey:KEY_MEMBER_SENDAR_NAME];          // 発信者名取得
    
    //Webビューを表示
    //インジケーター開始
    [IndicatorWindow openWindow];
    
    // URL指定
    NSURL *url = [NSURL URLWithString:NICEFACE_IMG];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    // POST指定
    req.HTTPMethod = @"POST";
    // BODYに登録、設定
    NSString *body = [NSString stringWithFormat:@"appli_id=%@&callname=%@",appliId,callName];
    
    req.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    // リクエスト送信
    [self.NiceFaceWebView loadRequest:req];
    
    // 画面に表示
    [self.view addSubview:self.NiceFaceWebView];
    
    //Webの拡大縮小有効化
    [self.NiceFaceWebView setScalesPageToFit:YES];
    [self.NiceFaceWebView setDelegate:self];

}


-(void)viewWillAppear:(BOOL)animated{


}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //キャッシュを全て消去
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    return true;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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

- (IBAction)move_CallNameSetting:(id)sender {
    
    //設定画面に遷移
    //設定画面のインスタンスを生成
    CallNameSettingViewController *callNameSettingViewController = [CallNameSettingViewController new];
    
    // Tab bar を非表示
    callNameSettingViewController.hidesBottomBarWhenPushed = YES;
    
    callNameSettingViewController.fromViewController = @"niceface";

    //設定画面に遷移
    [self.navigationController pushViewController:callNameSettingViewController animated:NO];
    
}




@end
