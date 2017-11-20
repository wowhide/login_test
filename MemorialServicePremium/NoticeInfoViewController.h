//
//  NoticeInfoViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2014/05/03.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeInfoViewDelegate <NSObject>
-(void) hideNoticeInfoView:(UIViewController *)noticeInfoViewController;
@end

@interface NoticeInfoViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic) int noticeTiming;
@property (nonatomic, copy) NSString *url;
@property (nonatomic) int noticeNo;

@end
