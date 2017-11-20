//
//  FamilyTreeTempViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/03/25.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "FamilyTreeTempViewController.h"
#import "Define.h"


@interface FamilyTreeTempViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation FamilyTreeTempViewController

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
- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}



@end
