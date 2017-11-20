//
//  Notification.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/31.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
@property (nonatomic) int deceased_no;
@property (nonatomic) int notice_kind;
@property (nonatomic) NSDate *notice_date;
@property (nonatomic) int memorial_no;

- (NSArray *)notificationKeys;

@end
