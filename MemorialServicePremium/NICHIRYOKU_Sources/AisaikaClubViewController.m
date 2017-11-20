//
//  AisaikaClubViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/03/29.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "AisaikaClubViewController.h"
#import "Reachability.h"
#import "IndicatorWindow.h"
#import "Toast+UIView.h"
#import "Define.h"
#import "HttpAccess.h"


@interface AisaikaClubViewController (){
    //入会日
    NSString *memberEntryday;
    
}

@property (weak, nonatomic) IBOutlet UIToolbar      *toolBar;
@property (weak, nonatomic) IBOutlet UIView         *userOuterFrameView;            //利用者情報の外枠用
@property (weak, nonatomic) IBOutlet UIView         *userInnerFrameView;            //利用者情報の内枠用
@property (weak, nonatomic) IBOutlet UILabel        *userMemberNumberLabel;         //利用者情報ラベル 会員番号
@property (weak, nonatomic) IBOutlet UILabel        *userMemberNameLabel;           //利用者情報ラベル 会員氏名
@property (weak, nonatomic) IBOutlet UILabel        *userMemberEntrydayLabel;       //利用者情報ラベル 入会日
@property (weak, nonatomic) IBOutlet UIImageView    *aisaikaTopImg;
@property (weak, nonatomic) IBOutlet UITextView *userMemberCemeterynameTextView;    //利用者情報テキスト 霊園名
@end

@implementation AisaikaClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //利用者情報Viewの設定
    //外枠用
    self.userOuterFrameView.layer.borderWidth  = 0.2f;
    self.userOuterFrameView.layer.borderColor  = [[UIColor grayColor] CGColor];
    self.userOuterFrameView.layer.cornerRadius = 10.0f;
    
    //iPhone/iPadの画面サイズに合わせて画像を拡大・縮小する
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"aisaika_background.png"] drawInRect:self.view.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.userOuterFrameView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    //内枠用
    self.userInnerFrameView.layer.borderWidth  = 0.4f;
    self.userInnerFrameView.layer.borderColor  = [[UIColor grayColor] CGColor];
    self.userInnerFrameView.layer.cornerRadius = 10.0f;
    self.userInnerFrameView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.7];

    //霊園のテキストビューを編集不可にする
    self.userMemberCemeterynameTextView.editable = NO;
    //愛彩花ロゴ画像＿縦横比率維持
    _aisaikaTopImg.contentMode = UIViewContentModeScaleAspectFit;
    
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    //インターネット接続されている
    if (netStatus != NotReachable) {
        //インジケーター開始
        [IndicatorWindow openWindow];
    }else{
    //インターネット未接続
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"現在インターネットに未接続のため、最新の情報が表示されない場合があります。" preferredStyle:UIAlertControllerStyleAlert];
        
        // addActionした順に左から右にボタンが配置されます
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // OKボタンが押された時の処理
            [self okButtonPushed];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}

//画面が表示された直前
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //霊園のテキストビューを編集不可にする
    self.userMemberCemeterynameTextView.editable = NO;
}

//画面が表示された直後
-(void)viewDidAppear:(BOOL)animated{
    
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        
    }else{

        defaults = [NSUserDefaults standardUserDefaults];                   // 取得
        memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];              // 会員番号
        appliid = [defaults stringForKey:KEY_MEMBER_APPLI_ID];              // アプリID

        
        //サーバーから会員情報取得
        HttpAccess *httpAccess = [HttpAccess new];
        
        NSMutableDictionary *parameter = [@{@"appli_id":appliid} mutableCopy];
        
        NSData *returnData = [httpAccess POST:GET_MEMBER_ID param:parameter];
        
        NSError *errorObject = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&errorObject];
        
        //JSONオブジェクトのパース失敗時はログを出して終了
        if ([jsonObject isEqual:@"false"]) {
            NSLog(@"JSONObjectパース失敗");
            return;
        }
        
        //取得した入会日を分割
        NSString *memberEntrydayYear = [[jsonObject objectForKey:@"member_entryday"] substringWithRange:NSMakeRange(0, 4)];
        NSString *memberEntrydayMonth = [[jsonObject objectForKey:@"member_entryday"] substringWithRange:NSMakeRange(4, 2)];
        NSString *memberEntrydayDay = [[jsonObject objectForKey:@"member_entryday"] substringWithRange:NSMakeRange(6, 2)];
        
        NSString *year =@"年";
        NSString *month =@"月";
        NSString *day =@"日";
        //入会日を結合
        memberEntryday = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",memberEntrydayYear,year,memberEntrydayMonth,month,memberEntrydayDay,day];
      
        [self.userMemberNumberLabel setText:[jsonObject objectForKey:@"deceased_id"]];
        [self.userMemberNameLabel setText:[jsonObject objectForKey:@"member_name"]];
        [self.userMemberEntrydayLabel setText:memberEntryday];
        [self.userMemberCemeterynameTextView setText:[jsonObject objectForKey:@"hall_name"]];
        
        // NSUserDefaultsに初期値を登録する
        memberud = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *memberdefaults = [NSMutableDictionary dictionary];
        [memberdefaults setObject:@"" forKey:KEY_MEMBER_USER_ID];
        [memberdefaults setObject:@"" forKey:KEY_MEMBER_USER_NAME];
        [memberdefaults setObject:@"" forKey:KEY_MEMBER_ENTRY_DAY];
        [memberdefaults setObject:@"" forKey:KEY_MEMBER_HALL_NAME];
        [memberud registerDefaults:memberdefaults];
        
        // NSUserDefaultsに保存・更新する
        memberud = [NSUserDefaults standardUserDefaults];
        [memberud setObject:[jsonObject objectForKey:@"deceased_id"] forKey:KEY_MEMBER_USER_ID];
        [memberud setObject:[jsonObject objectForKey:@"member_name"] forKey:KEY_MEMBER_USER_NAME];
        [memberud setObject:memberEntryday forKey:KEY_MEMBER_ENTRY_DAY];
        [memberud setObject:[jsonObject objectForKey:@"hall_name"] forKey:KEY_MEMBER_HALL_NAME];
        [memberud synchronize];
        
        
        //インジケーターを閉じる
        [IndicatorWindow closeWindow];
        
    }
    
}

//アラートの「OK」ボタンタップ時
- (void)okButtonPushed {
    
    //NSUserDefaultsからデータを読み込む
    memberud = [NSUserDefaults standardUserDefaults];
    //テキストにセット
    [self.userMemberNumberLabel setText:[memberud stringForKey:KEY_MEMBER_USER_ID]];
    [self.userMemberNameLabel setText:[memberud stringForKey:KEY_MEMBER_USER_NAME]];
    [self.userMemberEntrydayLabel setText:[memberud stringForKey:KEY_MEMBER_ENTRY_DAY]];
    [self.userMemberCemeterynameTextView setText:[memberud stringForKey:KEY_MEMBER_HALL_NAME]];

}

- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
