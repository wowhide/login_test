//
//  CalcNoticeDay.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/31.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcNoticeDay : NSObject
+ (NSDate *)getMonthDeathday:(NSString *)deathDay hour:(NSString *)noticeTime times:(int)times;
+ (NSDate *)getMonthDeathdayBefore:(NSString *)deathDay hour:(NSString *)noticeTime times:(int)times;
+ (NSDate *)getDeathday:(NSString *)deathDay hour:(NSString *)noticeTime;
+ (NSDate *)getDeathdayBefore:(NSString *)deathDay hour:(NSString *)noticeTime;
+ (NSDate *)getDeathday1WeekBefore:(NSString *)deathDay hour:(NSString *)noticeTime;
+ (NSArray *)getMemorialArray:(NSString *)deathday time:(NSString *)noteiceTime;
+ (NSDate *)getMemorialdayMonthBefore:(NSDate *)memorialDay pastMonth:(int)pastMonth;

@end
