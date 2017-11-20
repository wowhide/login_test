//
//  DataTransferKeyNoticeViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2016/11/15.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "DataTransferKeyNoticeViewController.h"
#import "TopMenuViewController.h"
#import "OtherViewController.h"
#import "Define.h"
#import "DataTakeInViewController.h"
#import "NicefacePushViewController.h"


@interface DataTransferKeyNoticeViewController (){
    NSString *memberId;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation DataTransferKeyNoticeViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //ユーザーデフォルト
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  // 取得
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID]; //会員番号
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    //アラートメッセージ作成
    NSString *alertMessage1 = @"\nおはよう！（";
    NSString *alertMessage2 = self.callName;
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

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //「確認」ボタン押下時
            //機種変更キーページを非表示にする
            [self removedisp];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
