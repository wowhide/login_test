//
//  NoticeInfoViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2014/05/03.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeInfoViewController.h"
#import "Reachability.h"
#import "IndicatorWindow.h"
#import "Define.h"
#import "Toast+UIView.h"
#import "NoticeInfo.h"
#import "PointUser.h"
#import "HttpAccess.h"

@interface NoticeInfoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *noticeWebView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *titleLabel;


@end

@implementation NoticeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
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
        [self.view makeToast:@"ネットワークに接続できる環境で表示して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

    //インジケーター開始
    [IndicatorWindow openWindow];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    
    [self.noticeWebView setScalesPageToFit:NO];
    [self.noticeWebView setDelegate:self];
    [self.noticeWebView loadRequest:request];
    
    
    if (self.noticeTiming == NOTICE_TIMING_ACTIVE) {
    } else if (self.noticeTiming == NOTICE_TIMING_PASSIVE) {
    } else {
        [self.titleLabel setTitle:@"戻る" forState:UIControlStateNormal];

    }
    
    //お知らせ表示時ポイント付与
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  // 取得
//    NSString *userid = [defaults stringForKey:USER_ID];  // USER_IDの内容をNSString型として取得
    
    //利用者IDを取得している場合、ポイント付与
//    if ([userid length]) {
//        HttpAccess *httpAccess = [HttpAccess new];
//        NSString *parameter = userid;
//        [httpAccess getnotice:POINT_ADD_USER3 param:parameter params:self.noticeNo];
//    }
//
    // お知らせ番号を取得
//    NSLog(@"%d", self.noticeNo);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//WebView読み込み開始時
- (void)webViewDidStartLoad:(UIWebView *)webView{

}

//WebView読み込み完了時
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}

//WebView内リンクをタップ時
- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
        navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

//WebView読み込み失敗時
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //エラーメッセージを表示
    [self.view makeToast:@"お知らせ情報を読み込めませんでした。" duration:TOAST_DURATION_ERROR position:@"center"];
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    
    //これでもO.K.
    NSLog(@"Error %@", [error description]);
}

//閉じるボタンクリック時
- (IBAction)closeButtonPushed:(id)sender {
    if (self.noticeTiming == NOTICE_TIMING_ACTIVE) {
        //自画面を閉じる
        [self.view removeFromSuperview];
    } else if (self.noticeTiming == NOTICE_TIMING_PASSIVE) {
        //自画面を閉じる
        [self.view removeFromSuperview];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)dealloc {
    self.noticeWebView.delegate = nil;
//    noticeWebView.delegate = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
