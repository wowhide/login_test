//
//  Common.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/29.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+ (NSString *)getDateString:(NSString *)formatString;
+ (NSString *)getDateString:(NSString *)formatString convDate:(NSDate *)convDate;
+ (NSString *)getDateStringJ:(NSString *)dateString format:(NSString *)format;
+ (NSDate *)getDate:(NSString *)dateString;
+ (NSDate *)getDateLong:(NSString *)dateString;
+ (NSString *)getTimeStringJ:(NSString *)timeString;
+ (NSString *)getTimeString:(int)hour;
+ (NSString *)getDeathAgeString:(int)deathAge kyonenGyonenFlg:(int)kyonenGyonenFlg;
+ (NSString *)getAnniversaryString:(int)anniversary deathday:(NSString *)deathday;
+ (NSDate *)getAnniversaryDate:(int)anniversary deathday:(NSString *)deathday;
+ (BOOL)pastDay:(NSDate *)comparisonDate;
+ (NSDate *)getPastDateYear:(int)pastYear;
+ (NSDate *)getAddDateDay:(int)addDay withDate:(NSDate *)date;
+ (int)getMonth:(NSDate *)date;
+ (int)getYear:(NSDate *)date;
+ (int)calcAge:(NSDate *)birthday deathday:(NSDate *)deathday;
+ (UIImage *)resizeImage:(UIImage *)sourceImage toSize:(CGFloat)newSize;
+ (NSString *)getAnniversary:(int)times;
@end
