//
//  KumotsuViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/03/02.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "KumotsuViewController.h"
#import "KumotsuDetailViewController.h"
#import "Define.h"


@interface KumotsuViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation KumotsuViewController

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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)move_Detail:(id)sender {
    
    //供花・供物のインスタンスを生成
    KumotsuDetailViewController *kumotsudetailViewController = [KumotsuDetailViewController new];
   
    //pushViewControllerしたとき、tabBarも一緒に隠す
    
    kumotsudetailViewController.hidesBottomBarWhenPushed = YES;
    
    //供花・供物画面に遷移
    [self.navigationController pushViewController:kumotsudetailViewController animated:YES];
    
}

- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

@end
