//
//  AisaikaclubReadMemberIdQrViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/03/29.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "AisaikaclubReadMemberIdQrViewController.h"
#import "Define.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "QrCodeReadViewController.h"
#import "TopMenuViewController.h"
#import "IndicatorWindow.h"

@interface AisaikaclubReadMemberIdQrViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITextView *welcomeAboutTextView;
@property (weak, nonatomic) IBOutlet UIButton *qrNowReadButton;
@property (weak, nonatomic) IBOutlet UIButton *qrLaterReadButton;

@end

@implementation AisaikaclubReadMemberIdQrViewController{
    UIAlertView *alert;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        alert = [[UIAlertView alloc] init];
//        alert.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //アラートビュー表示

    //    alert.title = @"会員番号_QR読込のご案内";
//    alert.message = @"会員番号QRを読み込んで下さい";
//    [alert addButtonWithTitle:@"OK"];
//    [alert show];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];

    //ようこそ愛彩花倶楽部へを表示
    NSString* sentenceUse = [[NSBundle mainBundle] localizedStringForKey:@"aisaika_welcome_about" value:nil table:LOCALIZE_FILE];
    self.welcomeAboutTextView.text = [self.welcomeAboutTextView.text stringByAppendingString:sentenceUse];
    
    //ようこそ愛彩花倶楽部への文字サイズを指定
    [self.welcomeAboutTextView setFont:[UIFont systemFontOfSize:17]];
    
    //ようこそ愛彩花倶楽部への背景色を指定
    self.welcomeAboutTextView.backgroundColor = [UIColor colorWithRed:TEXTVIEW_BG_COLOR_RED green:TEXTVIEW_BG_COLOR_GREEN blue:TEXTVIEW_BG_COLOR_BLUE alpha:1.0];
    //編集不可にする
    self.welcomeAboutTextView.editable = NO;
    //ボタンの背景色設定
    _qrNowReadButton.backgroundColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    _qrLaterReadButton.backgroundColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];

}

//初期表示　先頭行表示処理
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.welcomeAboutTextView setContentOffset:CGPointZero animated:NO];
    
}


// アラートのボタンが押された時に呼ばれる
//-(void)alertView:(UIAlertView*)alertView
//clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    switch (buttonIndex) {
//        case 0:
//            //「OK」ボタン押下時、何もしない
//            break;
//    }
//
//}

- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//QR読込ボタンクリック時
- (IBAction)qrReadButtonPushed:(id)sender {
    
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
    [self presentViewController:qrCodeReadViewController animated:NO completion:nil];

}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//QR読込画面が閉じた後に呼ばれるデリゲート
- (void)hideQrCodeReadView:(BOOL)readBool
{
    //インジケーター開始
    [IndicatorWindow openWindow];
    //デリゲード処理
    [self.delegate hideaisaikaclubReadQrView:YES];
}

//QR読込画面で「戻る」ボタンをタップ時に呼ばれるデリゲート
-(void)returnQrCodeReadView:(BOOL)readBool{
    //QR読み込み画面を閉じる
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

//読み込まないボタンクリック時
- (IBAction)returnNoQrButtonPushed:(id)sender {
    
    //デリゲード処理
    [self.delegate returnAisaikaclubReadQrView:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}



@end
