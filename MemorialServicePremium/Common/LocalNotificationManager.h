//
//  LocalNotificationManager.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/31.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject
// ローカル通知を登録する
- (void)scheduleLocalNotifications;
@end
