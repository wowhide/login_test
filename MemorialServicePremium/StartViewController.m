//
//  StartViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController () {

}

@end

//StartViewControllerの実装
@implementation StartViewController

//ロード前に呼ばれる
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//ロード時に呼ばれる
- (void)viewDidLoad
{
    [super viewDidLoad];

    //スプラッシュ画像を背景に設定
    if  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (([UIScreen mainScreen].bounds.size.height > 480.0f)) {
            // iPhone5以降
            [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SplashImage"]]];
        } else {
            // iPhone4s以前
            [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SplashImage4s"]]];
        }
    }
//    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SplashImage"]]];

    //1秒後次画面クローズ処理を実行
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(closeView) userInfo:nil repeats:NO];
}

- (void)closeView
{
    //親画面のデリゲート処理を実行
    [self.delegate hideStartView:self];
}

//メモリ不足時に呼ばれる
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
