//
//  KaisouViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/02/14.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "KaisouViewController.h"
#import "Define.h"

@interface KaisouViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation KaisouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
