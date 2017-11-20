//
//  NoticeMonthDeathdayViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/02/04.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

@class NoticeMonthDeathdayViewController;

@protocol NoticeMonthDeathdayViewDelegate <NSObject>
-(void) hideNoticeMonthDeathdayView:(UIViewController *)noticeMonthDeathdayViewController;
@end

@interface NoticeMonthDeathdayViewController : UIViewController
@property (nonatomic) int noticeTiming;
@property (strong, nonatomic) Notification *notification;
@end
