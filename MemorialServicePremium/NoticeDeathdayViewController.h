//
//  NoticeDeathdayViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/02/04.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

@class NoticeDeathdayViewController;

@protocol NoticeDeathdayViewDelegate <NSObject>
-(void) hideNoticeDeathdayView:(UIViewController *)noticeDeathdayViewController;
@end

@interface NoticeDeathdayViewController : UIViewController
@property (nonatomic) int noticeTiming;
@property (strong, nonatomic) Notification *notification;
@end
