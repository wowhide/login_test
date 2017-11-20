//
//  RootViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"
#import "MailInputViewController.h"
#import "NoticeMonthDeathdayViewController.h"
#import "NoticeDeathdayViewController.h"
#import "NoticeMemorialdayViewController.h"
#import "ReadMemberIdQrViewController.h"
#import "DataTransferKeyNoticeViewController.h"



//RootViewControllerの宣言
@interface RootViewController : UIViewController <StartViewDelegate, MailInputViewDelegate,ReadMemberIdQrViewDelegate,DataTransferKeyNoticeDelegate>

- (void)dispNextView;

@end
