//
//  TyodenViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/03/04.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "TyodenViewController.h"
#import "TyodenDetailViewController.h"
#import "Define.h"

@interface TyodenViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation TyodenViewController

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

- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)move_Detail:(id)sender {
    
    //弔電・喪中はがきのインスタンスを生成
    TyodenDetailViewController *tyodendetailViewController = [TyodenDetailViewController new];
    
    //pushViewControllerしたとき、tabBarも一緒に隠す
    
    tyodendetailViewController.hidesBottomBarWhenPushed = YES;
    
    //弔電・喪中はがきに遷移
    [self.navigationController pushViewController:tyodendetailViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
