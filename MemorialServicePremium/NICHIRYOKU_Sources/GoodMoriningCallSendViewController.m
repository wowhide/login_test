//
//  GoodMoriningCallSendViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/08/19.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "GoodMoriningCallSendViewController.h"
#import "Define.h"
#import "Reachability.h"
#import "IndicatorWindow.h"
#import "Toast+UIView.h"
#import "HttpAccess.h"






@interface GoodMoriningCallSendViewController (){
    NSUserDefaults *defaults;
    NSString *memberId;
    NSString *appliId;
    NSString *callName;
    NSString *result;
}

@end

@implementation GoodMoriningCallSendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        defaults = [NSUserDefaults standardUserDefaults];           // 取得
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    memberId  = [defaults stringForKey:KEY_MEMBER_USER_ID];             // 会員番号
    appliId = [defaults stringForKey:KEY_MEMBER_APPLI_ID];              // アプリID
    callName = [defaults stringForKey:KEY_MEMBER_SENDAR_NAME];          // 発信者名取得
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //インジケーター開始
    [IndicatorWindow openWindow];
    
    //別スレッドでおはようを実行する
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(goodmorningCall:)
                                        object:appliId];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];
    
}

- (void)goodmorningCall:(NSString *)_appliId{
    
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //接続できない場合
        [self.view makeToast:@"ネットワークに接続できる環境で使用して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
        
    }
    
    NSString *message = @"おはよう";
    
    HttpAccess *httpAccess = [HttpAccess new];
    
    NSMutableDictionary *parameter = [@{@"appli_id":appliId,@"call_name":callName,@"mornig_call":message} mutableCopy];
    
    NSData *returnData = [httpAccess POST:NICEFACE_SEND param:parameter];
    
    result= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"毎日おはよう送信結果：%@",result);
    
//    if ([result isEqualToString:@"1"]) {
//        [self.view makeToast:@"おはよう送信しました" duration:TOAST_DURATION_ERROR position:@"center"];
//    }else if([result isEqualToString:@"NG"]){
//        [self.view makeToast:@"本日、すでにおはようされています。" duration:TOAST_DURATION_ERROR position:@"center"];
//    }else{
//        //            [self.view makeToast:@"おはよう送信に失敗しました" duration:TOAST_DURATION_ERROR position:@"center"];
//        [self.view makeToast:@"おはよう送信しました" duration:TOAST_DURATION_ERROR position:@"center"];
//        
//    }
    //メインスレッドのインディケーターを閉じるを実行
    [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:result waitUntilDone:NO];
    return;
}

- (void)closeIndicatorAndErrorMessage:(NSString *)result
{
    //画面を非表示
    [self.delegate hideGoodMoriningCallSendView:self];
    //トースト表示
    [self.delegate dispresult:result];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
