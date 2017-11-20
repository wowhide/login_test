//
//  StartViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartViewController;

@protocol StartViewDelegate <NSObject>
-(void) hideStartView:(UIViewController *)startViewController;
@end

//StartViewControllerの宣言
@interface StartViewController : UIViewController
@property (weak, nonatomic) id <StartViewDelegate> delegate;
@end
