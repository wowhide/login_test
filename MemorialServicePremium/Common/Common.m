//
//  Common.m
//  MemorialService
//
//  Created by pc131101 on 2013/12/29.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import "Common.h"

@implementation Common

//現在日付を指定したフォーマットで返す
+ (NSString *)getDateString:(NSString *)formatString
{
    //NsDate => NSString変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:formatString];

    //日付(NSDate) => 文字列(NSString)に変換
    NSDate *now = [NSDate date];
    NSString *strNow = [df stringFromDate:now];

    return strNow;
}

//指定された日付を指定されたフォーマットに変換して返す
+ (NSString *)getDateString:(NSString *)formatString convDate:(NSDate *)convDate
{
    //NsDate => NSString変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:formatString];

    //日付(NSDate) => 文字列(NSString)に変換
    NSString *strNow = [df stringFromDate:convDate];

    return strNow;
}

//「yyyyMMdd」形式の文字列日付を「yyyy年mm月dd日」形式の文字列日付で返す
+ (NSString *)getDateStringJ:(NSString *)dateString format:(NSString *)format
{
    NSString *year = [dateString substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateString substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [dateString substringWithRange:NSMakeRange(6, 2)];
//    return [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
    return [NSString stringWithFormat:format, year, month, day];
}

//[yyyyMMdd]形式の文字列日付を日付型で返す
+ (NSDate *)getDate:(NSString *)dateString
{
    //NSString => NsDate変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyyMMdd"];
    
    //文字列(NSString) => 日付(NSDate)に変換
    NSDate *date = [df dateFromString:dateString];
    
    return date;
}

//[yyyyMMdd]形式の文字列日付を日付型で返す
+ (NSDate *)getDateLong:(NSString *)dateString
{
    //NSString => NsDate変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyyMMddHHmmss"];
    
    //文字列(NSString) => 日付(NSDate)に変換
    NSDate *date = [df dateFromString:dateString];
    
    return date;
}

//「HHmm」形式の文字列時間を「HH時mm分」形式の文字列時間で返す
+ (NSString *)getTimeStringJ:(NSString *)timeString
{
    NSString *hour = [timeString substringWithRange:NSMakeRange(0, 2)];
    NSString *minute = [timeString substringWithRange:NSMakeRange(2, 2)];
    return [NSString stringWithFormat:@"%@時%@分", hour, minute];
}

//int型の時間を「HHmm」形式の文字列で返す
+ (NSString *)getTimeString:(int)hour
{
    hour *= 100;
    return [NSString stringWithFormat: @"%04d", hour];
}

//没年齢に享年、行年、満を付けて返す
+ (NSString *)getDeathAgeString:(int)deathAge kyonenGyonenFlg:(int)kyonenGyonenFlg
{
    NSMutableString *returnDeathAge = [NSMutableString string];
    
    switch (kyonenGyonenFlg) {
        case 0:
            break;
        case 1:
            [returnDeathAge appendString:@"享年"];
            break;
        case 2:
            [returnDeathAge appendString:@"行年"];
            break;
        case 3:
            [returnDeathAge appendString:@"満"];
            break;
        default:
            break;
    }
    
    [returnDeathAge appendString:[NSString stringWithFormat:@"%d", deathAge]];
    
    [returnDeathAge appendString:@"歳"];
    
    return returnDeathAge;
}

//法要日を文字列で返す
+ (NSString *)getAnniversaryString:(int)anniversary deathday:(NSString *)deathday
{
    NSDate *anniversaryDay = [self getAnniversaryDate:anniversary deathday:deathday];
    
    //NsDate => NSString変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyy年MM月dd日(EEE)"];
    
    //日付(NSDate) => 文字列(NSString)に変換
    NSString *anniversaryString = [df stringFromDate:anniversaryDay];
    
    return anniversaryString;
}

//法要日を日時データーで返す
+ (NSDate *)getAnniversaryDate:(int)anniversary deathday:(NSString *)deathday
{
    //NSString => NsDate変換用のフォーマッタを作成
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyyMMdd"];
    
    //文字列(NSString) => 日付(NSDate)に変換
    NSDate *deathdayDate = [df dateFromString:deathday];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:anniversary];
    NSDate *anniversaryDate = [cal dateByAddingComponents:comps toDate:deathdayDate options:0];
    
    return anniversaryDate;
}

//引数の日付が過去かどうかチェックする
+ (BOOL)pastDay:(NSDate *)comparisonDate
{
    //現在日付
//    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate *now = [NSDate date];

//NSLog(@"now:%@", now);
//NSLog(@"comparisonDate:%@", comparisonDate);
    
    //日付を比較
    NSComparisonResult result = [comparisonDate compare:now];
    switch(result) {
        case NSOrderedSame: //一致したとき
            return NO;
            break;
        case NSOrderedAscending: //引数の日付が過去の場合
            return YES;
            break;
        case NSOrderedDescending: //引数の日付が未来の場合
            return NO;
            break;
    }
}

//引数に指定された年分過去の日付をNSDate形式で返す
+ (NSDate *)getPastDateYear:(int)pastYear;
{
    //現在日付
    NSDate *now = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:pastYear];
    NSDate *pastDate= [cal dateByAddingComponents:comps toDate:now options:0];

    return  pastDate;
}

//引数に指定された日時から引数に指定した日数を足した日付を返す
+ (NSDate *)getAddDateDay:(int)addDay withDate:(NSDate *)date;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:addDay];
    NSDate *pastDate= [cal dateByAddingComponents:comps toDate:date options:0];

    return  pastDate;
}

//日付型から月を返す
+ (int)getMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear |
                                   NSCalendarUnitMonth  |
                                   NSCalendarUnitDay    |
                                   NSCalendarUnitHour   |
                                   NSCalendarUnitMinute |
                                   NSCalendarUnitSecond
                                   fromDate:date];
    return (int)dateComps.month;
}

//日付型から年を返す
+ (int)getYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear |
                                   NSCalendarUnitMonth  |
                                   NSCalendarUnitDay    |
                                   NSCalendarUnitHour   |
                                   NSCalendarUnitMinute |
                                   NSCalendarUnitSecond
                                   fromDate:date];
    return (int)dateComps.year;
}

//誕生日と命日を受け取り年齢を計算して返す
+ (int)calcAge:(NSDate *)birthday deathday:(NSDate *)deathday
{
    NSString *birthdayString = [Common getDateString:@"yyyyMMdd" convDate:birthday];
    NSString *deathdayString = [Common getDateString:@"yyyyMMdd" convDate:deathday];
    
    int birthdayInt = [birthdayString intValue];
    int deathdayInt = [deathdayString intValue];
    
    return (deathdayInt - birthdayInt)/10000;
}

//画像のサイズを縦横のアスペクト比を固定のまま，幅，高さのうち長い方を指定されたサイズに縮小する
+ (UIImage *)resizeImage:(UIImage *)sourceImage toSize:(CGFloat)newSize
{
    UIImage *destinationImage = [[UIImage alloc] init];
    CGFloat currentWidth = sourceImage.size.width;
    CGFloat currentHeight = sourceImage.size.height;
    CGFloat newWidth, newHeight;
    
    if (newSize == 0) {
        newWidth = newHeight = 0;
    } else if (currentHeight < currentWidth) {
        newHeight = floorf(currentHeight * newSize / currentWidth);
        newWidth = newSize;
    } else {
        newWidth = floorf(currentWidth * newSize / currentHeight);
        newHeight = newSize;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    destinationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destinationImage;
}

//回忌を文字列で返す
+ (NSString *)getAnniversary:(int)times
{
    NSMutableString *anniversary = [NSMutableString string];

    switch (times) {
        case 1:
            [anniversary setString:@"一周忌"];
            break;
        case 2:
            [anniversary setString:@"三回忌"];
            break;
        case 3:
            [anniversary setString:@"七回忌"];
            break;
        case 4:
            [anniversary setString:@"十三回忌"];
            break;
        case 5:
            [anniversary setString:@"十七回忌"];
            break;
        case 6:
            [anniversary setString:@"二十三回忌"];
            break;
        case 7:
            [anniversary setString:@"二十五回忌"];
            break;
        case 8:
            [anniversary setString:@"二十七回忌"];
            break;
        case 9:
            [anniversary setString:@"三十三回忌"];
            break;
        case 10:
            [anniversary setString:@"三十七回忌"];
            break;
        case 11:
            [anniversary setString:@"五十回忌"];
            break;
        case 12:
            [anniversary setString:@"百回忌"];
            break;
        default:
            break;
    }
    
    
    return anniversary;
}

@end
