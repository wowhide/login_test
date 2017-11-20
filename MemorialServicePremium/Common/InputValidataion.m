//
//  InputValidataion.m
//  MemorialService
//
//  Created by pc131101 on 2013/12/27.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import "InputValidataion.h"

@implementation InputValidataion

//登録情報の入力チェックを行い、不正な場合、エラーメッセージを返す
+ (NSString *)checkEntry:(BOOL)consent {
    NSMutableString *errorMessage = [NSMutableString string];
    
    //同意チェック
    if (consent == NO) {
        [errorMessage appendString:@"利用規約に同意されていません。\n"];
    }
    
    return errorMessage;
}

//登録情報の入力チェックを行い、不正な場合、エラーメッセージを返す
+ (NSString *)checkName:(NSString *)name {
    NSMutableString *errorMessage = [NSMutableString string];
    
    //名前入力チェック
    if (name.length == 0) {
        [errorMessage appendString:@"お名前が入力されていません。\n"];
    }
    
    return errorMessage;
}

+ (BOOL)checkMail:(NSString *)mail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [predicate evaluateWithObject:mail];
}

//故人情報の入力チェックを行い、不正な場合、エラーメッセージを返す
+ (NSString *)checkDeceasedEntry:(NSString *)name withAge:(NSString *)age withBirthday:(NSDate *)birthday withDeathday:(NSDate *)deathday withDeathdaytoday:(NSDate *)deathday_today
{
    NSMutableString *errorMessage = [NSMutableString string];
    
    //名前入力チェック
    if (name.length == 0) {
        [errorMessage appendString:@"お名前が入力されていません。\n"];
    }
    //生年月日と命日の大小を比較
    NSComparisonResult result = [birthday compare:deathday];
    switch(result) {
        case NSOrderedSame: // 一致したとき
            break;
        case NSOrderedAscending: // 生年月日が小さいとき
            break;
        case NSOrderedDescending: // 生年月日が大きいとき
            [errorMessage appendString:@"命日に誕生日より過去の日付が設定されています。\n"];
            break;
    }
    
    //年齢入力チェック
    if (age.length == 0) {
        [errorMessage appendString:@"没年齢が入力されていません。\n"];
    //年齢数値型チェック
    } else if ([self checkDigit:age] == NO) {
        [errorMessage appendString:@"没年齢の入力形式が不正です。\n"];
    }
    
    //命日が本日後になっていないかチェック
    //本日の日付を取得
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *data_today = [formatter stringFromDate:nowdate];
    NSString *data_today_datepicker = [formatter stringFromDate:deathday_today];

    NSLog(@"本日:%@",data_today);
    NSLog(@"命日:%@",data_today_datepicker);

    NSComparisonResult result_today = [data_today compare:data_today_datepicker];
    
    if (result_today == NSOrderedAscending ) {
        
        [errorMessage appendString:@"命日が本日より過去の日付が設定されています。\n"];
    }
    
    return errorMessage;
}


//データ引き継ぎのアクセスキー送信の入力チェックを行い、不正な場合、エラーメッセージを返す
+ (NSString *)checkDataTransfer:(NSString *)mail
{
    NSMutableString *errorMessage = [NSMutableString string];
    
    //メールアドレス入力チェック
    if (mail.length == 0) {
        [errorMessage appendString:@"メールアドレスが入力されていません。\n"];
    } else if (![mail canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        [errorMessage appendString:@"メールアドレスは、半角で入力して下さい。\n"];
    //メールアドレス形式チェック
    } else if ([self checkMail:mail] == NO) {
        [errorMessage appendString:@"メールアドレスの入力形式が不正です。\n"];
    }

    return errorMessage;
}

+ (NSString *)checkDataTakeIn:(NSString *)accessKey
{
    NSMutableString *errorMessage = [NSMutableString string];
    
    //アクセスキー入力チェック
    if (accessKey.length == 0) {
        [errorMessage appendString:@"アクセスキーが入力されていません。\n"];
    }
    
    return errorMessage;
}


//数値入力として妥当か判断する
+ (BOOL)checkDigit:(NSString *)inString
{
    if ([inString length] == 0) {
        return NO;
    }
    
    NSCharacterSet *digitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    NSScanner *aScanner = [NSScanner localizedScannerWithString:inString];
    [aScanner setCharactersToBeSkipped:nil];
    
    [aScanner scanCharactersFromSet:digitCharSet intoString:NULL];
    return [aScanner isAtEnd];
}

@end
