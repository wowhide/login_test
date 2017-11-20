//
//  OtherDataTransferKeyNoticeViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2016/11/20.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "OtherDataTransferKeyNoticeViewController.h"
#import "OtherViewController.h"
#import "Define.h"

@interface OtherDataTransferKeyNoticeViewController (){
    NSString *memberId;
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation OtherDataTransferKeyNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //ポイントIDを取得
    defaults = [NSUserDefaults standardUserDefaults];  // 取得
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];  // USER_IDの内容をNSString型として取得
}

//画面が表示される直前にアラートを出す
-(void)viewWillAppear:(BOOL)animated{
    
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
    [alert show];
    
}

// アラートのボタンが押された時に呼ばれる
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //「OK」ボタン押下時
            //その他画面に遷移
            [self removedisp];
            
    }
    
}


-(void)removedisp{
    
    //その他のインスタンスを生成
    OtherViewController *otherViewController = [OtherViewController new];
    
    //その他画面に遷移
    [self.navigationController pushViewController:otherViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
