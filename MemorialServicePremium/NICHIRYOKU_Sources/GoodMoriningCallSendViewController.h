//
//  GoodMoriningCallSendViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/08/19.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//


#import <UIKit/UIKit.h>

@class GoodMoriningCallSendViewController;

@protocol GoodMoriningCallSendViewDelegate <NSObject>

-(void) hideGoodMoriningCallSendView:(UIViewController *) goodMoriningCallSendViewController;
-(void) dispresult:(NSString *) result;


@end


@interface GoodMoriningCallSendViewController : UIViewController

@property (weak, nonatomic) id <GoodMoriningCallSendViewDelegate> delegate;


@end
