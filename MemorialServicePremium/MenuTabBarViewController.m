//
//  MenuTabBarViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/09.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "MenuTabBarViewController.h"
#import "DeceasedListViewController.h"
#import "NoticeSettingViewController.h"
#import "OtherViewController.h"
#import "Define.h"
#import "MailInputViewController.h"
#import "TopMenuViewController.h"


@interface MenuTabBarViewController () {
    UITabBarController *_topmenuTabBarViewController;
    TopMenuViewController *_topmenuViewController;
    UINavigationController *_topMenuNavViewController;
    
    UITabBarController *_menuTabBarViewController;
    DeceasedListViewController *_deceasedListViewController;
    UINavigationController *_deceasedListNavViewController;
    
    NoticeSettingViewController *_noticeSettingViewController;
    OtherViewController *_otherViewController;
    UINavigationController *_otherNavViewController;
}

@end

//MenuTabBarViewControllerの実装
@implementation MenuTabBarViewController


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
	
    //タブで管理するビューコントローラーを生成
    //メニュー
    _topmenuViewController = [[TopMenuViewController alloc] init];
    _topMenuNavViewController = [[UINavigationController alloc] initWithRootViewController:_topmenuViewController];
    [_topMenuNavViewController setNavigationBarHidden:YES animated:NO];
//    _topMenuNavViewController.tabBarItem.title = @"メニュー";
//    _topMenuNavViewController.tabBarItem.image = [UIImage imageNamed:@"tab_deceased_list"];
    
    //故人様一覧
//    _deceasedListViewController = [[DeceasedListViewController alloc] init];
//    _deceasedListNavViewController = [[UINavigationController alloc] initWithRootViewController:_deceasedListViewController];
//    [_deceasedListNavViewController setNavigationBarHidden:YES animated:NO];
//    _deceasedListNavViewController.tabBarItem.title = @"故人様一覧";
//    _deceasedListNavViewController.tabBarItem.image = [UIImage imageNamed:@"tab_deceased_list"];
    
    //通知設定
//    _noticeSettingViewController = [[NoticeSettingViewController alloc] init];
//    _noticeSettingViewController.tabBarItem.title = @"通知設定";
//    _noticeSettingViewController.tabBarItem.image = [UIImage imageNamed:@"tab_notice_setting"];

    //その他
    _otherViewController = [[OtherViewController alloc] init];
    _otherNavViewController = [[UINavigationController alloc] initWithRootViewController:_otherViewController];
    [_otherNavViewController setNavigationBarHidden:YES animated:NO];
    _otherNavViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_other"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //タブビューアイコンの位置調整（画像のみに変更するため）
    _otherNavViewController.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);

    NSArray *views = [NSArray arrayWithObjects:_topMenuNavViewController, _otherNavViewController, nil];
    
//        NSArray *views = [NSArray arrayWithObjects:_topMenuNavViewController,_deceasedListNavViewController, _noticeSettingViewController, _otherNavViewController, nil];

    //UITabBarControllerを生成し、ビューコントローラーを指定
    _menuTabBarViewController = [[UITabBarController alloc] init];
    _menuTabBarViewController.viewControllers = views;
    
    //タブの背景色を設定（#a59aca　藤紫）
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:MENU_BG_COLOR_RED green:MENU_BG_COLOR_GREEN blue:MENU_BG_COLOR_BLUE alpha:1.0];
    //タブの文字色を設定
    [UITabBar appearance].tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //ビューのサイズを指定し画面へ追加
    _menuTabBarViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _menuTabBarViewController.delegate = self;
    [self.view addSubview:_menuTabBarViewController.view];
}

- (void)viewDidAppear:(BOOL)animated
{
//    if (IS_POINT_ACTIVE) {
//        //ポイント機能利用者IDが無い場合は、利用規約画面に遷移
//        PointUser *pointUser = [PointUser new];
//        [pointUser loadUserDefaults];
//    
//        if ([pointUser.userId length] == 0) {
//            //アラートを表示して、利用規約画面に遷移
//            NSBundle *bundle       = [NSBundle mainBundle];
//            NSString *alertTitle   = [bundle localizedStringForKey:@"alert_title_notice"
//                                                             value:nil
//                                                             table:LOCALIZE_FILE];
//            NSString *alertMessage = [bundle localizedStringForKey:@"alert_message_rule_reagree"
//                                                             value:nil
//                                                             table:LOCALIZE_FILE];
//    
//            UIAlertView *alert = [UIAlertView new];
//            alert.title = alertTitle;
//            alert.message = alertMessage;
//            [alert addButtonWithTitle:@"OK"];
//            [alert setDelegate:self];
//            [alert show];
//        }
//    }
    

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//MailInputViewDelegate
- (void) hideMailInputView:(UIViewController *)mailInputViewController
{
    //画面を閉じる
    [mailInputViewController willMoveToParentViewController:nil];
    [mailInputViewController.view removeFromSuperview];
    [mailInputViewController removeFromParentViewController];
}

@end
