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
#import "PointUser.h"
#import "DataTakeInViewController.h"

@interface DataTransferKeyNoticeViewController (){
    NSString *userid;
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
    
    //ポイントIDを取得
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  // 取得
    userid = [defaults stringForKey:USER_ID];  // USER_IDの内容をNSString型として取得
    
    


 
}


-(void)viewDidAppear:(BOOL)animated{
    
    //アラートメッセージ作成
    NSString *alertMessage1 = @"\n機種変更キー:";
    NSString *alertMessage2 = userid;
    NSString *alertMessage3 = @"\n \n上記機種変更キーは、機種変更時必要になります。";
    NSString *alertMessage4 = @"\n メモを取り、大切に保管してください。\n";
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@ %@",alertMessage1,alertMessage2,alertMessage3,alertMessage4];
    
    //アラートビュー表示
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"機種変更のご案内";
    alert.message = str;
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
}

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //「OK」ボタン押下時
            //機種変更キーページを非表示にする
            [self removedisp];
            
    }
    
}


-(void)removedisp{
     [self.delegate hideDataTransferKeyNoticeView:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
