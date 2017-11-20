//
//  AppDelegate.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

//AppDelegateの宣言
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    int notice_flg;
    int notice_timing;
    int notice_count;
    int notice_count_past;
    NSString *notice_schedule;
    NSString *call_name;
    int call_timing;


    
}

//プロパティの宣言
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) int notice_flg;
@property (nonatomic) int notice_timing;
@property (nonatomic) int notice_count;
@property (nonatomic) int notice_count_past;
@property (nonatomic) NSString *notice_schedule;
@property (nonatomic) NSString *notice_no;
@property (nonatomic) NSString *call_name;
@property (nonatomic) int call_timing;
@end
