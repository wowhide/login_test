//
//  PointCardViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/17.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Define.h"
#import "PointUser.h"
#import "PointSystemManager.h"
#import "OtherViewController.h"
#import "PointUserInfoViewController.h"
#import "PointCardViewController.h"
#import "Reachability.h"
#import "IndicatorWindow.h"
#import "Toast+UIView.h"


@implementation PointCardViewController

- (id)init
{
    if (self = [super init]) {
        observing = NO;
        userInfo = [PointUser new];
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //利用者情報を取得
    [userInfo loadUserDefaults];

    
    //解像度に合わせてViewサイズを設定
    [self.view setFrame:CGRectMake(0,
                                   0,
                                   [[UIScreen mainScreen]bounds].size.width,
                                   [[UIScreen mainScreen]bounds].size.height)];
    //ツールバーの色を変更
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED
                                                green:TOOLBAR_BG_COLOR_GREEN
                                                 blue:TOOLBAR_BG_COLOR_BLUE
                                                alpha:1.0];
    self.toolBar.tintColor    = [UIColor colorWithRed:TEXT_COLOR_RED
                                                green:TEXT_COLOR_GREEN
                                                 blue:TEXT_COLOR_BLUE
                                                alpha:1.0];
    
    //UIScrollViewのサイズを設定
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x,
                                       self.scrollView.frame.origin.y,
                                       [[UIScreen mainScreen]bounds].size.width,
                                       self.scrollView.frame.size.height);    
    //利用者情報Viewの設定
    self.userInfoView.layer.borderWidth  = 1.0f;
    self.userInfoView.layer.borderColor  = [[UIColor grayColor] CGColor];
    self.userInfoView.layer.cornerRadius = 10.0f;
    
    //ポイントViewの設定
    self.pointView.layer.borderWidth  = 1.0f;
    self.pointView.layer.borderColor  = [[UIColor grayColor] CGColor];
    self.pointView.layer.cornerRadius = 10.0f;
    
    //バーコード画像設定
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [path objectAtIndex:0];
    NSString *filePath = [documentDir stringByAppendingPathComponent:[userInfo.userId stringByAppendingString:@".jpg"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        //ファイルが存在する場合は表示
        [self.barcodeView setImage:[UIImage imageWithContentsOfFile:filePath]];
    } else {
        //ファイルが存在しない場合は仮画像を表示
        [self.barcodeView setImage:[UIImage imageNamed:@"point_barcode"]];
        
        //notification受信設定
        if (!observing) {
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter addObserver:self selector:@selector(setBarcodeImage:) name:NOTICE_BARCODE_DOWNLOADED object:nil];
            observing = YES;
        }
        
        //画像を別スレッドでダウンロード
        PointSystemManager *pointManager = [PointSystemManager new];
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:pointManager selector:@selector(downloadBarcodeImage) object:nil];
        [queue addOperation:operation];
    }
}

//情報読み込み
- (void)readNetInfo {
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {

        //接続できない場合、エラーメッセージをダイアログ表示
        [self.view makeToast:@"ネットワークに接続できる環境で表示して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    //ポイントID
    [self.userIdLabel setText:userInfo.userId];
    
    //名前
    if (userInfo.userName.length > 0) {
        [self.nameLabel setText:userInfo.userName];
        [self.editUserInfoButton setTitle:@"情報編集" forState:UIControlStateNormal];
    }
    
    //生年月日
    if (userInfo.birthday.length > 0) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *birthday = [formatter dateFromString:userInfo.birthday];
        formatter.dateFormat = @"yyyy年MM月dd日";
        [self.birthdayLabel setText:[formatter stringFromDate:birthday]];
    }
    
    //ポイント数
    [self updatePoint];
    

}
//インジケーターを閉じる
- (void)closeIndicator
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}


- (void)viewWillAppear:(BOOL)animated
{
 [super viewWillAppear:animated];
    
    [userInfo loadUserDefaults];
    
    //情報取得
    [self readNetInfo];

}

//戻るボタンタップ時の処理
- (IBAction)closeButtonClick:(id)sender {
    //その他画面に戻る
//    NSArray *viewControllers = [self.navigationController viewControllers];
//    UIViewController *targetController;
//    
//    for (int counter = 0; counter < [viewControllers count]; counter++) {
//        //画面のスタックからその他画面を探す
//        UIViewController *viewController = [viewControllers objectAtIndex:counter];
//        if ([viewController isKindOfClass:[OtherViewController class]]) {
//            targetController = viewController;
//            break;
//        }
//    }
//    
//    [self.navigationController popToViewController:targetController animated:YES];
    
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//情報登録ボタンタップ時の処理
- (IBAction)editUserInfo:(id)sender {
    [self.navigationController pushViewController:[PointUserInfoViewController new] animated:YES];
}

//表示更新ボタンタップ時の処理
- (IBAction)reloadPointButtonClick:(id)sender {
    [self updatePoint];
}

//ポイント数表示更新処理
- (void)updatePoint
{
    PointSystemManager *pointManager = [PointSystemManager new];
    NSInteger pointValue = [pointManager getPointFromServer];
    
    [self.pointLabel setText:[NSString stringWithFormat:@"%@", @(pointValue)]];
}

//バーコード画像ダウンロード後に呼ばれる
- (void)setBarcodeImage:(NSNotification *)notification
{
    NSDictionary *parameter = [notification userInfo];
    [self.barcodeView setImage:[UIImage imageWithContentsOfFile:parameter[@"path"]]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    observing = NO;
}

@end