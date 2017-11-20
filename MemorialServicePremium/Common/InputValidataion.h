//
//  InputValidataion.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/27.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputValidataion : NSObject
+ (NSString *)checkEntry:(BOOL)consent;
+ (NSString *)checkName:(NSString *)name;
+ (NSString *)checkDeceasedEntry:(NSString *)name withAge:(NSString *)age withBirthday:(NSDate *)birthday withDeathday:(NSDate *)deathday withDeathdaytoday:(NSDate *)deathday_today;
+ (NSString *)checkDataTransfer:(NSString *)mail;
+ (NSString *)checkDataTakeIn:(NSString *)accessKey;
@end
