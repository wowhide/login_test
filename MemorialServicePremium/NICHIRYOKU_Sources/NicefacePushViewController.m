//
//  NicefacePushViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/08/12.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "NicefacePushViewController.h"
#import "MenuTabBarViewController.h"
#import "CallNameSettingViewController.h"
#import "DataTransferKeyNoticeViewController.h"
#import "Define.h"
#import "IndicatorWindow.h"
#import "Reachability.h"

@interface NicefacePushViewController (){
    DataTransferKeyNoticeViewController *dataTransferKeyNoticeViewController;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIWebView *NiceFaceWebView;
@end

@implementation NicefacePushViewController{
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
    
    //ユーザーデフォルト
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];   // 取得
    callName = [defaults stringForKey:KEY_MEMBER_SENDAR_NAME];          // 発信者名取得
    
    //アプリ起動中で遷移してきた場合
    if (self.call_timing == 1) {
        
        //アラートメッセージ作成
        NSString *alertMessage1 = @"\nおはよう！（";
        NSString *alertMessage2 = self.call_name;
        NSString *alertMessage3 = @"より）";
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",alertMessage1,alertMessage2,alertMessage3];
        
        //アラートビュー表示
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"メッセージ";
        alert.message = str;
        [alert addButtonWithTitle:@"確認"];
        [alert addButtonWithTitle:@"閉じる"];
        [alert show];
        
    }
    
        [self viewWeb];
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //「OK」ボタン押下時
            //機種変更キーページを非表示にする
            [self viewWeb];
            break;
            
        case 1:
            //「閉じる」ボタン押下時
            [self removedisp];
            break;
        
    }
    
}

-(void)removedisp{
    //自画面を閉じる
    [self.view removeFromSuperview];
}

-(void)viewWeb{
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
    
    // URL指定
    NSURL *url = [NSURL URLWithString:NICEFACE_IMG];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    // POST指定
    req.HTTPMethod = @"POST";
    // BODYに登録、設定
    NSString *body = [NSString stringWithFormat:@"appli_id=%@&callname=%@",self.appli_id,callName];
    
    req.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    // リクエスト送信
    [self.NiceFaceWebView loadRequest:req];
    
    // 画面に表示
    [self.view addSubview:self.NiceFaceWebView];
    
    //Webの拡大縮小有効化
    [self.NiceFaceWebView setScalesPageToFit:YES];
    [self.NiceFaceWebView setDelegate:self];
}

//WebView読み込み完了時
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}

- (IBAction)close_Back:(id)sender {
    //閉じる
    
    //自画面を閉じる
    [self.view removeFromSuperview];
    
    DataTransferKeyNoticeViewController *otherDataTransferKeyNoticeViewController = [[DataTransferKeyNoticeViewController alloc] init];
    
    [otherDataTransferKeyNoticeViewController.view removeFromSuperview];
}



//「機種変更キー」画面非表示関数
-(void) hideDataTransferKeyNoticeView:(UIViewController *)_dataTransferKeyNoticeViewController
{
    //画面を閉じる
    [_dataTransferKeyNoticeViewController willMoveToParentViewController:nil];
    [_dataTransferKeyNoticeViewController.view removeFromSuperview];
    [_dataTransferKeyNoticeViewController removeFromParentViewController];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
