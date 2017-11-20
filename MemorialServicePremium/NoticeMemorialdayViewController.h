//
//  NoticeMemorialdayViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/02/04.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

@class NoticeMemorialdayViewController;

@protocol NoticeMemorialdayViewDelegate <NSObject>
-(void) hideNoticeMemorialdayView:(UIViewController *)noticeMemorialdayViewController;
@end

@interface NoticeMemorialdayViewController : UIViewController
@property (nonatomic) int noticeTiming;
@property (strong, nonatomic) Notification *notification;
@end
