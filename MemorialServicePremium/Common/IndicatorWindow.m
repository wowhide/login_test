//
//  IndicatorWindow.m
//  MemorialService
//
//  Created by pc131101 on 2014/02/17.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "IndicatorWindow.h"
#import <QuartzCore/QuartzCore.h>

@interface IndicatorWindow ()
@property (nonatomic, strong) UIView *rootView;

@end

@implementation IndicatorWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

static IndicatorWindow *_baseWindow;

+ (void)openWindow {
    if(_baseWindow == nil) {
        // Window作成
        CGRect rect = [[UIScreen mainScreen] bounds];
        _baseWindow = [[IndicatorWindow alloc] initWithFrame:rect];
        _baseWindow.hidden = YES;
        _baseWindow.windowLevel = UIWindowLevelNormal + 1;
        _baseWindow.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.4f];
        
        // View作成
        UIScreen* screen = [UIScreen mainScreen];
        UIView *informationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.bounds.size.width,screen.bounds.size.height)];
        informationView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//        informationView.layer.cornerRadius = 10.0f;
        informationView.layer.masksToBounds = YES;
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        [informationView addSubview:indicatorView];
        indicatorView.center = informationView.center;
        
        // プロパティに保持
        _baseWindow.rootView = informationView;
        [_baseWindow addSubview:informationView];
        
        // センタリング
        informationView.center = _baseWindow.center;
    }else{
        return;
    }
    _baseWindow.alpha = 0.0f;
    _baseWindow.hidden = NO;
    // フェードイン
    [UIView animateWithDuration:0.3f animations:^{
        _baseWindow.alpha = 1.0f;
    } completion:nil];
}

+ (void)closeWindow {
    // フェードアウト
    [UIView animateWithDuration:0.3f animations:^{
        _baseWindow.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _baseWindow.hidden = YES;
        [_baseWindow.rootView removeFromSuperview];
        _baseWindow.rootView = nil;
        _baseWindow = nil;
    }];
}

@end
