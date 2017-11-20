//
//  UserDao.m
//  MemorialService
//
//  Created by pc131101 on 2013/12/26.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import "UserDao.h"
#import "Common.h"
#import "Define.h"

@implementation UserDao

+ (id)userDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase
{
    UserDao *userDao = [[UserDao alloc] init];
    userDao.memorialDatabase = memorialDatabase;
    return userDao;
}

- (User *)selectUser
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_user"];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        if ([results next]) {
            User *user  = [[User alloc] init];
            user.mail_address = [results stringForColumnIndex:0];
            user.name = [results stringForColumnIndex:1];
            user.notice_month_deathday_before = [results intForColumnIndex:2];
            user.notice_month_deathday = [results intForColumnIndex:3];
            user.notice_deathday_1week_before = [results intForColumnIndex:4];
            user.notice_deathday_before = [results intForColumnIndex:5];
            user.notice_deathday = [results intForColumnIndex:6];
            user.notice_memorial_3month_before = [results intForColumnIndex:7];
            user.notice_memorial_1month_before = [results intForColumnIndex:8];
            user.notice_memorial_1week_before = [results intForColumnIndex:9];
            user.notice_time = [results stringForColumnIndex:10];
            user.install_datetime = [results stringForColumnIndex:11];
            user.entry_datetime = [results stringForColumnIndex:12];
            return user;
        } else {
            return nil;
        }
    }
}

- (BOOL)insertUser
{
    //現在日時を文字列で取得
    NSString *now = [Common getDateString:@"yyyyMMddHHmmss"];

    NSString *insertUserSql
    = @"INSERT INTO t_user ("
    "    mail_address,"
    "    name,"
    "    notice_month_deathday_before,"
    "    notice_month_deathday,"
    "    notice_deathday_1week_before,"
    "    notice_deathday_before,"
    "    notice_deathday,"
    "    notice_memorial_3month_before,"
    "    notice_memorial_1month_before,"
    "    notice_memorial_1week_before,"
    "    notice_time,"
    "    install_datetime,"
    "    entry_datetime) "
    "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    BOOL insertResult = [self.memorialDatabase executeUpdate:insertUserSql, @"dummy", @"", [NSNumber numberWithInt:NOTICE_NO], [NSNumber numberWithInt:NOTICE_NO], [NSNumber numberWithInt:NOTICE_NO], [NSNumber numberWithInt:NOTICE_NO], [NSNumber numberWithInt:NOTICE_NO], [NSNumber numberWithInt:NOTICE_NO], [NSNumber numberWithInt:NOTICE_NO], [NSNumber numberWithInt:NOTICE_NO], @"0800", now, now];
    if (!insertResult) {
        [self dbLastError];
    }
    
    return insertResult;
}

- (BOOL)updateUserName:(NSString *)name
{
    NSString *updateUserNameSql = @"UPDATE t_user SET name = ?";
    BOOL updateResult = [self.memorialDatabase executeUpdate:updateUserNameSql, name];
    if (!updateResult) {
        [self dbLastError];
    }
    
    return updateResult;
}

- (BOOL)updateUser:(User *)user
{
    NSString *updateUserSql
    = @"UPDATE t_user SET"
    "    name = ?,"
    "    notice_month_deathday_before = ?,"
    "    notice_month_deathday = ?,"
    "    notice_deathday_1week_before = ?,"
    "    notice_deathday_before = ?,"
    "    notice_deathday = ?,"
    "    notice_memorial_3month_before = ?,"
    "    notice_memorial_1month_before = ?,"
    "    notice_memorial_1week_before = ?,"
    "    notice_time = ?";
    BOOL updateResult = [self.memorialDatabase executeUpdate:updateUserSql, user.name, [NSNumber numberWithInt:user.notice_month_deathday_before], [NSNumber numberWithInt:user.notice_month_deathday], [NSNumber numberWithInt:user.notice_deathday_1week_before], [NSNumber numberWithInt:user.notice_deathday_before], [NSNumber numberWithInt:user.notice_deathday], [NSNumber numberWithInt:user.notice_memorial_3month_before], [NSNumber numberWithInt:user.notice_memorial_1month_before], [NSNumber numberWithInt:user.notice_memorial_1week_before], user.notice_time];
    if (!updateResult) {
        [self dbLastError];
    }
    
    return updateResult;
}

- (BOOL)updateNotice:(User *)user
{
    NSString *updateNoticeSql
    = @"UPDATE t_user SET"
    "    notice_month_deathday_before = ?,"
    "    notice_month_deathday = ?,"
    "    notice_deathday_1week_before = ?,"
    "    notice_deathday_before = ?,"
    "    notice_deathday = ?,"
    "    notice_memorial_3month_before = ?,"
    "    notice_memorial_1month_before = ?,"
    "    notice_memorial_1week_before = ?,"
    "    notice_time = ?";
    BOOL updateResult = [self.memorialDatabase executeUpdate:updateNoticeSql, [NSNumber numberWithInt:user.notice_month_deathday_before], [NSNumber numberWithInt:user.notice_month_deathday], [NSNumber numberWithInt:user.notice_deathday_1week_before], [NSNumber numberWithInt:user.notice_deathday_before], [NSNumber numberWithInt:user.notice_deathday], [NSNumber numberWithInt:user.notice_memorial_3month_before], [NSNumber numberWithInt:user.notice_memorial_1month_before], [NSNumber numberWithInt:user.notice_memorial_1week_before], user.notice_time];
    if (!updateResult) {
        [self dbLastError];
    }
    
    return updateResult;
}

// 最後に発生したFMDBのエラー情報をログに出力
- (void)dbLastError
{
    NSLog(@"DB error: %@", [_memorialDatabase lastError]);
}

@end
