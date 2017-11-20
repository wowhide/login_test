//
//  StoreViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2016/04/30.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "StoreViewController.h"
#import "Define.h"
#import "IndicatorWindow.h"
#import "Reachability.h"

@interface StoreViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIWebView *StoreWebView;

@end

@implementation StoreViewController

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
    
    //Webビューを表示
    //インジケーター開始
    [IndicatorWindow openWindow];
    
    //リクエスト先のURLを指定してNSURLRequestオブジェクトを生成
    NSURL *url = [NSURL URLWithString:STORE_WEBSITE];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //webviewを拡大縮小を可能に
    [self.StoreWebView setScalesPageToFit:NO];
    
    //デリゲードを指定
    [self.StoreWebView setDelegate:self];
    
    //HTTPリクエストの送信
    [self.StoreWebView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//戻るボタンをクリック
- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
   [self.navigationController popViewControllerAnimated:YES];
}




//WebView読み込み開始時
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}



//WebView読み込み完了時
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    // 長押し禁止
    //    [self.helpSubWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout = 'none';"];
}

//WebView内リンクをタップ時
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    //キャッシュを全て消去
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

//WebView読み込み失敗時
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //エラーメッセージを表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"ページを読み込めませんでした。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}


- (void)dealloc {
    self.StoreWebView.delegate = nil;
}


@end
