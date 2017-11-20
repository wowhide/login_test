//
//  BeautyCharacterDisplayViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/01/20.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "BeautyCharacterDisplayViewController.h"
#import "Define.h"


@interface BeautyCharacterDisplayViewController (){
        NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *beautyWord;
@property (weak, nonatomic) IBOutlet UIView *zoomView;

@end

@implementation BeautyCharacterDisplayViewController
@synthesize userParam;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
         defaults = [NSUserDefaults standardUserDefaults];
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
    
    
    // 値が渡っているかログに出力
    //NSLog(@"%@", userParam);
    
    [self.beautyWord setText:userParam];
    
    //ユーザーデフォルト
    [defaults setObject:userParam forKey:@"BEAUTYCHARACTER_SAVE"];
    [defaults synchronize];
    
    // ピンチ
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.zoomView addGestureRecognizer:pinchGesture];
    
    // drag
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//    [self.view addGestureRecognizer:pan];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{
    NSString *saveeeName = [defaults stringForKey:@"BEAUTYCHARACTER_SAVE"];
    // ログに出力
    NSLog(@"%@rgrgrgrgr", saveeeName);
    
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

// セレクター（ピンチ）
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    self.beautyWord.transform = CGAffineTransformMakeScale(factor, factor);
    
    NSLog(@"factor %f",factor);
    
}

// セレクター（ドラッグ）
//- (void)panAction : (UIPanGestureRecognizer *)sender {
//    
//    // ドラッグで移動した距離を取得する
//    CGPoint p = [sender translationInView:self.view];
//    
//    // 移動した距離だけ、美文字のcenterポジションを移動させる
//    CGPoint movedPoint = CGPointMake(self.beautyWord.center.x + p.x, self.beautyWord.center.y + p.y);
//    self.beautyWord.center = movedPoint;
//    
//    // ドラッグで移動した距離を初期化する
////    [sender setTranslation:CGPointZero inView:self.view];
//}


@end
