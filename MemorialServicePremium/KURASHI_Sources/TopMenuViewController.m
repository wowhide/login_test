//
//  TopMenuViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/01/26.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "TopMenuViewController.h"
//フレームワーク
#import <QuartzCore/QuartzCore.h>

//クラス
#import "LoupeViewController.h"
#import "BeautyCharacterViewController.h"
#import "OtherFuneralViewController.h"
#import "NoticeInfoListViewController.h"
#import "MenuTabBarViewController.h"
#import "Define.h"
#import "PointUser.h"
#import "PointUserInfoViewController.h"
#import "PointCardViewController.h"
#import "DeceasedListViewController.h"
#import "FamilyTreeViewController.h"
#import "FamilyTreeTempViewController.h"
#import "TaxiViewController.h"
#import "KumotsuViewController.h"
#import "TyodenViewController.h"
#import "OtherDataTransferViewController.h"
#import "OtherHowToUseViewController.h"
#import "OtherFuneralViewController.h"



@interface TopMenuViewController (){
    NSString *_url;
}

//ボタン
//トップメニュー
@property (weak, nonatomic) IBOutlet UILabel *Menulabel;

//お知らせ
@property (weak, nonatomic) IBOutlet UIButton *btn_notice;
//故人一覧（大切な故人）
@property (weak, nonatomic) IBOutlet UIButton *btn_kojinitiran;
//Web版ベストエンディング-> 美文字として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_webendding;
//葬儀社情報　-> ルーペとして使用
@property (weak, nonatomic) IBOutlet UIButton *btn_customer;
//美文字　-> くらしホール鹿島台＿電話として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_bimoji;
//ルーペ　-> くらしホール松山＿電話として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_loupe;
//機種変更する場合　-> くらし葬祭ご案内として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_backup;
//使い方
@property (weak, nonatomic) IBOutlet UIButton *btn_howto;

//タクシー配車　-> 空ボタン＿左として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_taxi;

//ポイント　-> 空ボタン＿右として使用
@property (weak, nonatomic) IBOutlet UIButton *btn_point;


//供花・供物　->　未使用
@property (weak, nonatomic) IBOutlet UIButton *btn_kumotsu;
//弔電・喪中はがき　->　未使用
@property (weak, nonatomic) IBOutlet UIButton *btn_tyoden;








//ビュー
@property (weak, nonatomic) IBOutlet UIView *view_menu;


@end

@implementation TopMenuViewController

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
    

// 色の割合を指定して生成する場合
    //ボタン背景グラデーション終了色 (#E1DDF0)
    UIColor *btncolor_bottom = [UIColor colorWithRed:0.88 green:0.86 blue:0.94 alpha:1.0];
    
    //枠線色・メニューラベル色
    UIColor *btncolor_bottom_line = [UIColor colorWithRed:0.47 green:0.41 blue:0.68 alpha:1.0];
    
    
//メニューラベル設定
    // 枠線の色
    [[self.Menulabel layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.Menulabel layer] setBorderWidth:0.5];
        
    //背景色をグラデーションに
   CAGradientLayer *gradient_menu = [CAGradientLayer layer];
   gradient_menu.frame = _view_menu.bounds;
   gradient_menu.colors = [NSArray arrayWithObjects:(id)[btncolor_bottom_line CGColor], (id)[btncolor_bottom_line CGColor], nil];
    [_view_menu.layer insertSublayer:gradient_menu atIndex:0];

    
//お知らせボタン設定
    // 枠線の色
    [[self.btn_notice layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_notice layer] setBorderWidth:0.5];
    //背景色をグラデーションに
    CAGradientLayer *gradient_notice = [CAGradientLayer layer];
    gradient_notice.frame = self.btn_notice.bounds;
    gradient_notice.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_notice.layer insertSublayer:gradient_notice atIndex:0];

//故人一覧ボタン設定
    // 枠線の色
    [[self.btn_kojinitiran layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_kojinitiran layer] setBorderWidth:0.5];
    //背景色をグラデーションに
    CAGradientLayer *gradient_kojinitiran = [CAGradientLayer layer];
    gradient_kojinitiran.frame = self.btn_kojinitiran.bounds;
    gradient_kojinitiran.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_kojinitiran.layer insertSublayer:gradient_kojinitiran atIndex:0];

//Webエンディングノートボタン設定　-> 美文字として使用
    // 枠線の色
    [[self.btn_webendding layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_webendding layer] setBorderWidth:0.5];
    
    //背景色をグラデーションに
    CAGradientLayer *gradient_webendding = [CAGradientLayer layer];
    gradient_webendding.frame = self.btn_webendding.bounds;
    gradient_webendding.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_webendding.layer insertSublayer:gradient_webendding atIndex:0];
    
//葬儀社名ボタン設定　-> ルーペとして使用
    // 枠線の色
    [[self.btn_customer layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_customer layer] setBorderWidth:0.5];
    
    //背景色をグラデーションに
    CAGradientLayer *gradient_customer = [CAGradientLayer layer];
    gradient_customer.frame = self.btn_customer.bounds;
    gradient_customer.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_customer.layer insertSublayer:gradient_customer atIndex:0];

//美文字ボタン設定　-> くらしホール鹿島台＿電話として使用
    // 枠線の色
    [[self.btn_bimoji layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_bimoji layer] setBorderWidth:0.5];
    //背景色をグラデーションに
    CAGradientLayer *gradient_bimoji = [CAGradientLayer layer];
    gradient_bimoji.frame = self.btn_bimoji.bounds;
    gradient_bimoji.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_bimoji.layer insertSublayer:gradient_bimoji atIndex:0];

//ルーペボタン設定　-> くらしホール松山＿電話として使用
    // 枠線の色
    [[self.btn_loupe layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_loupe layer] setBorderWidth:0.5];
    //背景色をグラデーションに
    CAGradientLayer *gradient_loupe = [CAGradientLayer layer];
    gradient_loupe.frame = self.btn_loupe.bounds;
    gradient_loupe.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_loupe.layer insertSublayer:gradient_loupe atIndex:0];

//機種変更する場合ボタン設定　-> くらし葬祭ご案内＿電話として使用
    // 枠線の色
    [[self.btn_backup layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_backup layer] setBorderWidth:0.5];
    
    //背景色をグラデーションに
    CAGradientLayer *gradient_backup = [CAGradientLayer layer];
    gradient_backup.frame = self.btn_backup.bounds;
    gradient_backup.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_backup.layer insertSublayer:gradient_backup atIndex:0];

//使い方ボタン設定
    // 枠線の色
    [[self.btn_howto layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_howto layer] setBorderWidth:0.5];
    
    //背景色をグラデーションに
    CAGradientLayer *gradient_howto = [CAGradientLayer layer];
    gradient_howto.frame = self.btn_howto.bounds;
    gradient_howto.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_howto.layer insertSublayer:gradient_howto atIndex:0];

//タクシー配車ボタン設定
    // 枠線の色
    [[self.btn_taxi layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_taxi layer] setBorderWidth:0.5];
    
    //背景色をグラデーションに
    CAGradientLayer *gradient_taxi = [CAGradientLayer layer];
    gradient_taxi.frame = self.btn_taxi.bounds;
    gradient_taxi.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_taxi.layer insertSublayer:gradient_taxi atIndex:0];
    
//ポイントボタン設定
    // 枠線の色
    [[self.btn_point layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_point layer] setBorderWidth:0.5];
    
    //背景色をグラデーションに
    CAGradientLayer *gradient_point = [CAGradientLayer layer];
    gradient_point.frame = self.btn_point.bounds;
    gradient_point.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_point.layer insertSublayer:gradient_point atIndex:0];
    

//供花・供物ボタン設定
    // 枠線の色
    [[self.btn_kumotsu layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_kumotsu layer] setBorderWidth:0.5];
    //背景色をグラデーションに
    CAGradientLayer *gradient_kumotsu = [CAGradientLayer layer];
//    gradient_kumotsu.frame = [[self.btn_kumotsu.bounds].size.width -20];
    gradient_kumotsu.frame = CGRectMake(0, 0, self.btn_kumotsu.bounds.size.width, self.btn_kumotsu.bounds.size.height);
    
    gradient_kumotsu.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_kumotsu.layer insertSublayer:gradient_kumotsu atIndex:0];

//弔電・喪中はがきボタン設定
    // 枠線の色
    [[self.btn_tyoden layer] setBorderColor:[btncolor_bottom_line CGColor]];
    // 枠線の太さ
    [[self.btn_tyoden layer] setBorderWidth:0.5];
    
    //背景色をグラデーションに
    CAGradientLayer *gradient_tyoden = [CAGradientLayer layer];
    gradient_tyoden.frame = self.btn_tyoden.bounds;
    gradient_tyoden.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[btncolor_bottom CGColor], nil];
    [self.btn_tyoden.layer insertSublayer:gradient_tyoden atIndex:0];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //終活のすすめのURLを生成してインスタンス変数に設定
    _url = [SYUKATSU stringByAppendingFormat:@"?mno=%d", 3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//アクション
//お知らせへ遷移
- (IBAction)move_notice:(id)sender {
    //お知らせ画面のインスタンスを生成
    NoticeInfoListViewController *noticeInfoListViewController = [NoticeInfoListViewController new];
    
    // Tab bar を非表示
    noticeInfoListViewController.hidesBottomBarWhenPushed = YES;
    
    //お知らせ画面に遷移
    [self.navigationController pushViewController:noticeInfoListViewController animated:YES];
}


//故人一覧へ遷移
- (IBAction)move_kojinitiran:(id)sender {
    
    //故人様一覧のインスタンスを生成
    DeceasedListViewController *deceasedlistViewController = [DeceasedListViewController new];
    
    // Tab bar を非表示
    deceasedlistViewController.hidesBottomBarWhenPushed = YES;

    //故人様一覧画面に遷移
    [self.navigationController pushViewController:deceasedlistViewController animated:YES];
}

//供花・供物へ遷移 ->　注文メニュー内容によりここに「美文字」のメソッド記入
- (IBAction)move_kumotu:(id)sender {
    //美文字のインスタンスを生成
    BeautyCharacterViewController *beautycharacterViewController = [BeautyCharacterViewController new];
    
    // Tab bar を非表示
    beautycharacterViewController.hidesBottomBarWhenPushed = YES;
    
    //美文字画面に遷移
    [self.navigationController pushViewController:beautycharacterViewController animated:YES];
    
}

//会社情報へ遷移　->　注文メニュー内容によりここに「ルーペ」のメソッド記入
- (IBAction)move_customer:(id)sender {
    //ルーペのインスタンスを生成
    LoupeViewController *loupeViewController = [LoupeViewController new];
    
    // Tab bar を非表示
    loupeViewController.hidesBottomBarWhenPushed = YES;
    
    //ルーペ画面に遷移
    [self.navigationController pushViewController:loupeViewController animated:YES];
}

//美文字へ遷移　->　注文メニュー内容によりここに「くらしホール鹿島台＿電話」のメソッド記入
- (IBAction)move_bimoji:(id)sender {
    // 電話かける
    NSURL *url = [[NSURL alloc] initWithString:@"tel:0229-56-6620"];
    [[UIApplication sharedApplication] openURL:url];
    
}

//ルーペへ遷移　->　注文メニュー内容によりここに「くらしホール松山＿電話」のメソッド記入
- (IBAction)move_loupe:(id)sender {
    // 電話かける
    NSURL *url = [[NSURL alloc] initWithString:@"tel:0229-25-6630"];
    [[UIApplication sharedApplication] openURL:url];
}

//弔電・喪中はがきへ遷移 ->　注文メニュー内容によりここに「くらし葬祭ご案内」のメソッド記入
- (IBAction)move_tyoden:(id)sender {

    //くらし葬祭ご案内のインスタンスを生成
    OtherFuneralViewController *otherfuneralViewController = [OtherFuneralViewController new];
    
    // Tab bar を非表示
    otherfuneralViewController.hidesBottomBarWhenPushed = YES;
    
    //くらし葬祭ご案内画面に遷移
    [self.navigationController pushViewController:otherfuneralViewController animated:YES];
    
}

//タクシー配車へ遷移 ->　注文メニュー内容によりここに「使い方」のメソッド記入
- (IBAction)move_taxi:(id)sender {
    
    //使い方画面のインスタンスを生成
    OtherHowToUseViewController *otherHowToUseViewController = [OtherHowToUseViewController new];
    
    // Tab bar を非表示
    otherHowToUseViewController.hidesBottomBarWhenPushed = YES;
    
    
    //使い方画面に遷移
    [self.navigationController pushViewController:otherHowToUseViewController animated:YES];
}



//ポイントへ遷移
- (IBAction)move_point:(id)sender {

    // Tab bar を非表示
    UIViewController *pointviewController;
    
    pointviewController = [self getPointViewController];
    
    pointviewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pointviewController animated:YES];
}

//ポイント機能画面のインスタンスを取得する
- (UIViewController*)getPointViewController
{
    UIViewController *viewController;
    PointUser *userInfo = [PointUser new];
    [userInfo loadUserDefaults];
    
    if (userInfo.userName.length > 0 || userInfo.isSkip) {
        viewController = [PointCardViewController new];
    } else {
        viewController = [PointUserInfoViewController new];
    }
    
    return viewController;
}

@end
