//
//  CalcNoticeDay.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/31.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "CalcNoticeDay.h"
#import "Common.h"

@implementation CalcNoticeDay

+ (NSDate *)getMonthDeathday:(NSString *)deathDay hour:(NSString *)noticeTime times:(int)times
{
    //月命日格納用日付に現在日時を設定
//    NSDate *dateMonthDeathday = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate *dateMonthDeathday = [NSDate date];
    NSCalendar *calendarMonthDeathday = [NSCalendar currentCalendar];
    NSUInteger flagsMonthDeathday;
    NSDateComponents *compsMonthDeathday;
    flagsMonthDeathday = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsMonthDeathday = [calendarMonthDeathday components:flagsMonthDeathday fromDate:dateMonthDeathday];

    //命日を取得
    NSDate *dateGmtDeathday = [Common getDate:deathDay];
    NSDate *dateDeathday = [dateGmtDeathday initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateGmtDeathday];
    NSCalendar *calendarDeathday = [NSCalendar currentCalendar];
    NSUInteger flagsDeathday;
    NSDateComponents *compsDeathday;
    flagsDeathday = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsDeathday = [calendarDeathday components:flagsDeathday fromDate:dateDeathday];

    //通知時間の時を数値に変換
    long hour = [self getLongHour:noticeTime];

    //現在の日にち・時間が命日の日にち・通知時間より大きい場合、来月の月命日を生成
    if ((compsMonthDeathday.day > compsDeathday.day) || (compsMonthDeathday.day == compsDeathday.day && compsMonthDeathday.hour >= hour)) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:times];
        dateMonthDeathday = [calendarMonthDeathday dateByAddingComponents:comps toDate:dateMonthDeathday options:0];
    } else {
        if (times > 1) {
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setMonth:times - 1];
            dateMonthDeathday = [calendarMonthDeathday dateByAddingComponents:comps toDate:dateMonthDeathday options:0];
        }
    }
    
    //月を指定
    [compsMonthDeathday setMonth:[Common getMonth:dateMonthDeathday]];
    //年を指定（月加算で年をまたぐ場合があるため）
    [compsMonthDeathday setYear:[Common getYear:dateMonthDeathday]];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSRange range = [calendarMonthDeathday rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateMonthDeathday];
    
    //月末日を取得
    NSInteger maxDay = range.length;
    
    //指定した月命日の月末日より命日の日にちが大きい場合、月末を月命日とする（閏年、31日命日対策）
    if (compsDeathday.day > maxDay) {
        [compsMonthDeathday setDay:maxDay];
    } else {
        [compsMonthDeathday setDay:compsDeathday.day];
    }
    
    //時間を設定する
    [compsMonthDeathday setHour:hour];
    [compsMonthDeathday setMinute:0];
    
    dateMonthDeathday = [calendarMonthDeathday dateFromComponents:compsMonthDeathday];
//    dateMonthDeathday = [dateMonthDeathday initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateMonthDeathday];
/*
    NSLog(@"月命日******************************");
    NSLog(@"maxDay：%ld", (long)maxDay);
    NSLog(@"命日：%@", dateDeathday);
    NSLog(@"月命日：%@", dateMonthDeathday);
*/
    return dateMonthDeathday;
}

+ (NSDate *)getMonthDeathdayBefore:(NSString *)deathDay hour:(NSString *)noticeTime times:(int)times
{
    //月命日前日格納用日付に現在日時を設定
//    NSDate *dateMonthDeathdayBefore = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate *dateMonthDeathdayBefore = [NSDate date];
    NSCalendar *calendarMonthDeathdayBefore = [NSCalendar currentCalendar];
    NSUInteger flagsMonthDeathdayBefore;
    NSDateComponents *compsMonthDeathdayBefore;
    flagsMonthDeathdayBefore = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsMonthDeathdayBefore = [calendarMonthDeathdayBefore components:flagsMonthDeathdayBefore fromDate:dateMonthDeathdayBefore];

    //命日の前日を取得
    NSDate *dateGmtDeathdayBefore = [Common getAddDateDay:-1 withDate:[Common getDate:deathDay]];
    NSDate *dateDeathdayBefore = [dateGmtDeathdayBefore initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateGmtDeathdayBefore];
    NSCalendar *calendarDeathdayBefore = [NSCalendar currentCalendar];
    NSUInteger flagsDeathdayBefore;
    NSDateComponents *compsDeathdayBefore;
    flagsDeathdayBefore = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsDeathdayBefore = [calendarDeathdayBefore components:flagsDeathdayBefore fromDate:dateDeathdayBefore];

    //通知時間の時を数値に変換
    long hour = [self getLongHour:noticeTime];
/*
NSLog(@"現在の日：%d", compsMonthDeathdayBefore.day);
NSLog(@"現在の時：%d", compsMonthDeathdayBefore.hour);
NSLog(@"命日前日の日：%d", compsDeathdayBefore.day);
NSLog(@"比較の時：%ld", hour);
*/
    //現在の日にち・時間が命日前日の日にち・時間より大きい場合、来月の月命日前日を生成
    if ((compsMonthDeathdayBefore.day > compsDeathdayBefore.day) || (compsMonthDeathdayBefore.day == compsDeathdayBefore.day && compsMonthDeathdayBefore.hour >= hour)) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:times];
        dateMonthDeathdayBefore = [calendarMonthDeathdayBefore dateByAddingComponents:comps toDate:dateMonthDeathdayBefore options:0];
    } else {
        if (times > 1) {
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setMonth:times - 1];
            dateMonthDeathdayBefore = [calendarMonthDeathdayBefore dateByAddingComponents:comps toDate:dateMonthDeathdayBefore options:0];
        }
    }
    
    //月を指定
    [compsMonthDeathdayBefore setMonth:[Common getMonth:dateMonthDeathdayBefore]];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSRange range = [calendarMonthDeathdayBefore rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateMonthDeathdayBefore];
    //月末日を取得
    NSInteger maxDay = range.length;
    
    //次の月命日の月末日より命日の日にちが大きい場合、月末を月命日とする（閏年対策）
    if (compsDeathdayBefore.day > maxDay) {
        [compsMonthDeathdayBefore setDay:maxDay];
    } else {
        [compsMonthDeathdayBefore setDay:compsDeathdayBefore.day];
    }
    
    //日時を設定する
    [compsMonthDeathdayBefore setHour:hour];
    [compsMonthDeathdayBefore setMinute:0];
    
    dateMonthDeathdayBefore = [calendarMonthDeathdayBefore dateFromComponents:compsMonthDeathdayBefore];
//    dateMonthDeathdayBefore = [dateMonthDeathdayBefore initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateMonthDeathdayBefore];
/*
    NSLog(@"月命日前日******************************");
    NSLog(@"maxDay：%ld", (long)maxDay);
    NSLog(@"命日前日：%@", dateDeathdayBefore);
    NSLog(@"月命日前日：%@", dateMonthDeathdayBefore);
*/
    return dateMonthDeathdayBefore;
}

+ (NSDate *)getDeathday:(NSString *)deathDay hour:(NSString *)noticeTime
{
    //命日格納用日付に現在日時を設定
//    NSDate *dateNextDeathday = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate *dateNextDeathday = [NSDate date];
    NSCalendar *calendarNextDeathday = [NSCalendar currentCalendar];
    NSUInteger flagsNextDeathday;
    NSDateComponents *compsNextDeathday;
    flagsNextDeathday = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsNextDeathday = [calendarNextDeathday components:flagsNextDeathday fromDate:dateNextDeathday];
    
    //命日を取得
/*
    NSDate *dateGmtDeathday = [Common getDate:deathDay];
    NSDate *dateDeathday = [dateGmtDeathday initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateGmtDeathday];
    NSCalendar *calendarDeathday = [NSCalendar currentCalendar];
    NSUInteger flagsDeathday;
    NSDateComponents *compsDeathday;
    flagsDeathday = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsDeathday = [calendarDeathday components:flagsDeathday fromDate:dateDeathday];
*/
    NSDate *dateGmtDeathday = [Common getDate:deathDay];
//    NSDate *dateDeathday = [dateGmtDeathday initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateGmtDeathday];
    NSCalendar *calendarDeathday = [NSCalendar currentCalendar];
    NSUInteger flagsDeathday;
    NSDateComponents *compsDeathday;
    flagsDeathday = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsDeathday = [calendarDeathday components:flagsDeathday fromDate:dateGmtDeathday];
    
    //通知時間の時を数値に変換
    long hour = [self getLongHour:noticeTime];
    
    //現在の月・日にち・時間が命日の月・日にち・時間より過去の場合、来年の命日を生成
    if ((compsNextDeathday.month > compsDeathday.month) ||
        (compsNextDeathday.month == compsDeathday.month &&
         compsNextDeathday.day > compsDeathday.day) ||
        (compsNextDeathday.month == compsDeathday.month &&
         compsNextDeathday.day == compsDeathday.day &&
         compsNextDeathday.hour >= hour)) {
/*        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:1];
        dateNextDeathday = [calendarNextDeathday dateByAddingComponents:comps toDate:dateNextDeathday options:0];*/
        compsNextDeathday.year = compsNextDeathday.year + 1;
    }
   
    //命日の月を設定
    [compsNextDeathday setMonth:compsDeathday.month];
    dateNextDeathday = [calendarNextDeathday dateFromComponents:compsNextDeathday];
//    dateNextDeathday = [dateNextDeathday initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateNextDeathday];

    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSRange range = [calendarNextDeathday rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateNextDeathday];
    //月末日を取得
    NSInteger maxDay = range.length;
    
    //次の命日の月末日より命日の日にちが大きい場合、月末を月命日とする（閏年対策）
    if (compsDeathday.day > maxDay) {
        [compsNextDeathday setDay:maxDay];
    } else {
        [compsNextDeathday setDay:compsDeathday.day];
    }
    
    //日時を設定する
    [compsNextDeathday setHour:hour];
    [compsNextDeathday setMinute:0];
    
    dateNextDeathday = [calendarNextDeathday dateFromComponents:compsNextDeathday];
//    dateNextDeathday = [dateNextDeathday initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateNextDeathday];
/*
    NSLog(@"命日******************************");
    NSLog(@"maxDay：%ld", (long)maxDay);
    NSLog(@"命日：%@", dateDeathday);
    NSLog(@"次の命日：%@", dateNextDeathday);
*/
   
    return dateNextDeathday;
}

+ (NSDate *)getDeathdayBefore:(NSString *)deathDay hour:(NSString *)noticeTime
{
    //命日前日格納用日付に現在日時を設定
//    NSDate *dateNextDeathdayBefore = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate *dateNextDeathdayBefore = [NSDate date];
    NSCalendar *calendarNextDeathdayBefore = [NSCalendar currentCalendar];
    NSUInteger flagsNextDeathdayBefore;
    NSDateComponents *compsNextDeathdayBefore;
    flagsNextDeathdayBefore = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsNextDeathdayBefore = [calendarNextDeathdayBefore components:flagsNextDeathdayBefore fromDate:dateNextDeathdayBefore];
    
    //命日前日を取得
    NSDate *dateGmtDeathdayBefore = [Common getAddDateDay:-1 withDate:[Common getDate:deathDay]];
//    NSDate *dateDeathdayBefore = [dateGmtDeathdayBefore initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateGmtDeathdayBefore];
    NSCalendar *calendarDeathdayBefore = [NSCalendar currentCalendar];
    NSUInteger flagsDeathdayBefore;
    NSDateComponents *compsDeathdayBefore;
    flagsDeathdayBefore = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsDeathdayBefore = [calendarDeathdayBefore components:flagsDeathdayBefore fromDate:dateGmtDeathdayBefore];
    
    //通知時間の時を数値に変換
    long hour = [self getLongHour:noticeTime];
    
    //現在の月・日にち・時間が命日前日の月・日にち・時間より過去の場合、来年の命日前日を生成
    if ((compsNextDeathdayBefore.month > compsDeathdayBefore.month) || (compsNextDeathdayBefore.month == compsDeathdayBefore.month && compsNextDeathdayBefore.day > compsDeathdayBefore.day) || (compsNextDeathdayBefore.month == compsDeathdayBefore.month && compsNextDeathdayBefore.day == compsDeathdayBefore.day && compsNextDeathdayBefore.hour >= hour)) {
/*        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:1];
        dateNextDeathdayBefore = [calendarNextDeathdayBefore dateByAddingComponents:comps toDate:dateNextDeathdayBefore options:0];*/
        compsNextDeathdayBefore.year = compsNextDeathdayBefore.year + 1;
    }
    
    //命日前日格納用日付に命日の月を設定
    [compsNextDeathdayBefore setMonth:compsDeathdayBefore.month];
    dateNextDeathdayBefore = [calendarNextDeathdayBefore dateFromComponents:compsNextDeathdayBefore];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSRange range = [calendarNextDeathdayBefore rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateNextDeathdayBefore];
    //月末日を取得
    NSInteger maxDay = range.length;
    
    //次の命日の月末日より命日の日にちが大きい場合、月末を月命日とする（閏年対策）
    if (compsDeathdayBefore.day > maxDay) {
        [compsNextDeathdayBefore setDay:maxDay];
    } else {
        [compsNextDeathdayBefore setDay:compsDeathdayBefore.day];
    }
    
    //日時を設定する
    [compsNextDeathdayBefore setHour:hour];
    [compsNextDeathdayBefore setMinute:0];
    
    dateNextDeathdayBefore = [calendarNextDeathdayBefore dateFromComponents:compsNextDeathdayBefore];
//    dateNextDeathdayBefore = [dateNextDeathdayBefore initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateNextDeathdayBefore];
/*
    NSLog(@"命日前日******************************");
    NSLog(@"maxDay：%ld", (long)maxDay);
    NSLog(@"命日前日：%@", dateDeathdayBefore);
    NSLog(@"次の命日前日：%@", dateNextDeathdayBefore);
*/
    return dateNextDeathdayBefore;
}

+ (NSDate *)getDeathday1WeekBefore:(NSString *)deathDay hour:(NSString *)noticeTime
{
    //命日1週間前格納用日付に現在日時を設定
//    NSDate *dateNextDeathday1WeekBefore = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate *dateNextDeathday1WeekBefore = [NSDate date];
    NSCalendar *calendarNextDeathday1WeekBefore = [NSCalendar currentCalendar];
    NSUInteger flagsNextDeathday1WeekBefore;
    NSDateComponents *compsNextDeathday1WeekBefore;
    flagsNextDeathday1WeekBefore = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsNextDeathday1WeekBefore = [calendarNextDeathday1WeekBefore components:flagsNextDeathday1WeekBefore fromDate:dateNextDeathday1WeekBefore];
    
    //命日1週間前を取得
    NSDate *dateGmtDeathday1WeekBefore = [Common getAddDateDay:-7 withDate:[Common getDate:deathDay]];
//    NSDate *dateDeathday1WeekBefore = [dateGmtDeathday1WeekBefore initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateGmtDeathday1WeekBefore];
    NSCalendar *calendarDeathday1WeekBefore = [NSCalendar currentCalendar];
    NSUInteger flagsDeathday1WeekBefore;
    NSDateComponents *compsDeathday1WeekBefore;
    flagsDeathday1WeekBefore = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitWeekday;
    compsDeathday1WeekBefore = [calendarDeathday1WeekBefore components:flagsDeathday1WeekBefore fromDate:dateGmtDeathday1WeekBefore];

    //通知時間の時を数値に変換
    long hour = [self getLongHour:noticeTime];
    
    //現在の月・日にち・時間が命日1週間前の月・日にち・時間より過去の場合、来年の命日1週間前を生成
    if ((compsNextDeathday1WeekBefore.month > compsDeathday1WeekBefore.month) || (compsNextDeathday1WeekBefore.month == compsDeathday1WeekBefore.month && compsNextDeathday1WeekBefore.day > compsDeathday1WeekBefore.day) || (compsNextDeathday1WeekBefore.month == compsDeathday1WeekBefore.month && compsNextDeathday1WeekBefore.day == compsDeathday1WeekBefore.day && compsNextDeathday1WeekBefore.hour >= hour)) {
/*        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:1];
        dateNextDeathday1WeekBefore = [calendarNextDeathday1WeekBefore dateByAddingComponents:comps toDate:dateNextDeathday1WeekBefore options:0];*/
        compsNextDeathday1WeekBefore.year = compsNextDeathday1WeekBefore.year + 1;
    }
    
    //命日1週間前格納用日付に命日の月を設定
    [compsNextDeathday1WeekBefore setMonth:compsDeathday1WeekBefore.month];
    dateNextDeathday1WeekBefore = [calendarNextDeathday1WeekBefore dateFromComponents:compsNextDeathday1WeekBefore];
    
    //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
    NSRange range = [calendarNextDeathday1WeekBefore rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateNextDeathday1WeekBefore];
    //月末日を取得
    NSInteger maxDay = range.length;
    
    //次の命日1週間前の月末日より命日の日にちが大きい場合、月末を月命日とする（閏年対策）
    if (compsDeathday1WeekBefore.day > maxDay) {
        [compsNextDeathday1WeekBefore setDay:maxDay];
    } else {
        [compsNextDeathday1WeekBefore setDay:compsDeathday1WeekBefore.day];
    }
    
    //日時を設定する
    [compsNextDeathday1WeekBefore setHour:hour];
    [compsNextDeathday1WeekBefore setMinute:0];
    
    dateNextDeathday1WeekBefore = [calendarNextDeathday1WeekBefore dateFromComponents:compsNextDeathday1WeekBefore];
//    dateNextDeathday1WeekBefore = [dateNextDeathday1WeekBefore initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:dateNextDeathday1WeekBefore];
/*
    NSLog(@"命日1週間前******************************");
    NSLog(@"maxDay：%ld", (long)maxDay);
    NSLog(@"命日1週間前：%@", dateDeathday1WeekBefore);
    NSLog(@"次の命日1週間前：%@", dateNextDeathday1WeekBefore);
*/
    return dateNextDeathday1WeekBefore;
}

+ (NSArray *)getMemorialArray:(NSString *)deathday time:(NSString *)noticeTime
{
    NSMutableArray *memorialDays = [NSMutableArray array];
    //1周忌
    [memorialDays addObject:[self getAnniversaryDate:1 deathday:deathday time:noticeTime]];
    //3回忌
    [memorialDays addObject:[self getAnniversaryDate:2 deathday:deathday time:noticeTime]];
    //7回忌
    [memorialDays addObject:[self getAnniversaryDate:6 deathday:deathday time:noticeTime]];
    //13回忌
    [memorialDays addObject:[self getAnniversaryDate:12 deathday:deathday time:noticeTime]];
    //17回忌
    [memorialDays addObject:[self getAnniversaryDate:16 deathday:deathday time:noticeTime]];
    //23回忌
    [memorialDays addObject:[self getAnniversaryDate:22 deathday:deathday time:noticeTime]];
    //25回忌
    [memorialDays addObject:[self getAnniversaryDate:24 deathday:deathday time:noticeTime]];
    //27回忌
    [memorialDays addObject:[self getAnniversaryDate:26 deathday:deathday time:noticeTime]];
    //33回忌
    [memorialDays addObject:[self getAnniversaryDate:32 deathday:deathday time:noticeTime]];
    //37回忌
    [memorialDays addObject:[self getAnniversaryDate:36 deathday:deathday time:noticeTime]];
    //50回忌
    [memorialDays addObject:[self getAnniversaryDate:49 deathday:deathday time:noticeTime]];
    //100回忌
    [memorialDays addObject:[self getAnniversaryDate:99 deathday:deathday time:noticeTime]];

//    NSLog(@"法要:%@", memorialDays);
    return memorialDays;
}

//法要日をNSDate型で返す
+ (NSDate *)getAnniversaryDate:(int)anniversary deathday:(NSString *)deathday time:(NSString *)time
{
    //NSString => NsDate変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyyMMddHHmm"];
    
    //命日と通知時刻を連結する
    NSString *deathdaytime = [deathday stringByAppendingString:time];
    
    //文字列(NSString) => 日付(NSDate)に変換
    NSDate *deathdayDate = [df dateFromString:deathdaytime];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:anniversary];
    NSDate *anniversaryDate = [cal dateByAddingComponents:comps toDate:deathdayDate options:0];
//    anniversaryDate = [anniversaryDate initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:anniversaryDate];

    return anniversaryDate;
}

//法要日の引数分月前の日付を取得する
+ (NSDate *)getMemorialdayMonthBefore:(NSDate *)memorialDay pastMonth:(int)pastMonth
{
    //法要予定日3ヶ月前を取得
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:pastMonth];
    NSDate *pastDate= [cal dateByAddingComponents:comps toDate:memorialDay options:0];

    return  pastDate;
}

/*
//月命日かどうかチェックする
+ (BOOL)checkMonthDeathday:(NSString *)deathDay
{
    //引数の命日をNSDate型に変換
    
    //今日を含めた過去の
    
    return YES;
}
*/

+ (long)getLongHour:(NSString *)time
{
    NSString *hour = [time substringToIndex:2];
    return [hour integerValue];
}

@end
