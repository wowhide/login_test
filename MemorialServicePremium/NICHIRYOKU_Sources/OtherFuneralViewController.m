//
//  OtherFuneralViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/21.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "OtherFuneralViewController.h"
#import "Define.h"

@interface OtherFuneralViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *funeralScroll;
@property (weak, nonatomic) IBOutlet UIView *funeralScrollView;

@property (weak, nonatomic) IBOutlet UILabel *morticianNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *morticianTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *morticianPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *morticianAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *morticianTelButton;
@property (weak, nonatomic) IBOutlet UIButton *morticianTakadaBabaTelButton;
@property (weak, nonatomic) IBOutlet UIButton *aisaikaSougiAboutTelButton;
@property (weak, nonatomic) IBOutlet UIButton *aisaikaDocumentRequestTelButton;

@property (weak, nonatomic) IBOutlet UIButton *ryoboDocumentRequestTelButton;

@property (weak, nonatomic) IBOutlet UIButton *morticianUrlButton;
@property (weak, nonatomic) IBOutlet UIImageView *funeral_top;

@end

@implementation OtherFuneralViewController

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
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //スクロールのため、height値をプラス
    float width = [[UIScreen mainScreen]bounds].size.width;
    float height = [[UIScreen mainScreen]bounds].size.height+1050;
    
    //UIScrollViewのコンテンツサイズを設定
    self.funeralScroll.contentSize = CGSizeMake(width,height);
    //スクロールバーを表示
    self.funeralScroll.showsVerticalScrollIndicator = YES;
    
    self.funeral_top.contentMode = UIViewContentModeScaleAspectFit;
    
    //「ニチリョクホームページへ」背景色設定
    _morticianUrlButton.backgroundColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //ラベルに葬儀社情報とプロパティを設定する
    //葬儀社名
    self.morticianNameLabel.text = MORTICIAN_NAME;
    //郵便番号
    self.morticianPostLabel.text = MORTICIAN_POST;
    //住所
    self.morticianAddressLabel.text = MORTICIAN_ADDRESS;
    [self.morticianAddressLabel setNumberOfLines:0];
    [self.morticianAddressLabel sizeToFit];
    //電話番号
    [self.morticianTelButton setTitle:MORTICIAN_TEL forState:UIControlStateNormal];
}


//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)pushUrl:(id)sender {
    NSString *urlString = MORTICIAN_URL;
    NSURL *url2 = [NSURL URLWithString:urlString];
    // URLをタップした場合
    [[UIApplication sharedApplication] openURL:url2];
}


//愛彩花ホームページタップ時
- (IBAction)pushAisaikaUrl:(id)sender {
    NSString *urlString = MORTICIAN_URL2;
    NSURL *url2 = [NSURL URLWithString:urlString];
    // URLをタップした場合
    [[UIApplication sharedApplication] openURL:url2];
}



//電話番号クリック時(本社)
- (IBAction)telButtonPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.morticianTelButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}


//電話番号クリック時（高田馬場オフィス）
- (IBAction)telButtonTakadaBabaPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.morticianTakadaBabaTelButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
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


//電話番号クリック時（霊園・堂内陵墓について））
- (IBAction)telButtonRyoboDocumentRequestPushed:(id)sender {
    //電話番号をタッチした場合
    NSString *tel = [self.ryoboDocumentRequestTelButton.titleLabel.text stringByReplacingOccurrencesOfString: @"-" withString: @""];
    NSString *telUrl= [NSString stringWithFormat:@"tel:%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
