//
//  MemorialReceiveDao.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2014/05/20.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "MemorialReceiveDao.h"
#import "Common.h"

@implementation MemorialReceiveDao

+ (id)memorialReceiveDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase
{
    MemorialReceiveDao *memorialReceiveDao = [[MemorialReceiveDao alloc] init];
    memorialReceiveDao.memorialDatabase = memorialDatabase;
    return memorialReceiveDao;
}

- (BOOL)deleteMemorialReceiveAll
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_memorial_receive"]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

- (BOOL)deleteMemorialReceiveFuture
{
    NSDate *now = [NSDate date];
    NSString *delteMemorialReceiveSql
    =@"DELETE FROM t_memorial_receive"
    "  WHERE notice_date > ?";

    BOOL deleteResult = [self.memorialDatabase executeUpdate:delteMemorialReceiveSql, [Common getDateString:@"yyyyMMddHHmmss" convDate:now]];
    if (!deleteResult) {
        [self dbLastError];
    }
    return deleteResult;
}

- (BOOL)deleteMemorialReceive:(Notification *)notification
{
    NSString *delteMemorialReceiveSql
    =@"DELETE FROM t_memorial_receive"
    "  WHERE deceased_no = ?"
    "    AND notice_kind = ?"
    "    AND notice_date = ?"
    "    AND memorial_no = ?";
    
    BOOL deleteResult = [self.memorialDatabase executeUpdate:delteMemorialReceiveSql, [NSNumber numberWithInt:notification.deceased_no], [NSNumber numberWithInt:notification.notice_kind], [Common getDateString:@"yyyyMMddHHmmss" convDate:notification.notice_date], [NSNumber numberWithInt:notification.memorial_no]];
    if (!deleteResult) {
        [self dbLastError];
    }
    return deleteResult;
}

- (BOOL)insertMemorialReceive:(Notification *)notification
{
    NSString *insertMemorialReceiveSql
    = @"INSERT INTO t_memorial_receive ("
    "    deceased_no,"
    "    notice_kind,"
    "    notice_date,"
    "    memorial_no)"
    "    VALUES (?,?,?,?)";

    BOOL insertResult = [self.memorialDatabase executeUpdate:insertMemorialReceiveSql, [NSNumber numberWithInt:notification.deceased_no], [NSNumber numberWithInt:notification.notice_kind], [Common getDateString:@"yyyyMMddHHmmss" convDate:notification.notice_date], [NSNumber numberWithInt:notification.memorial_no]];

    if (!insertResult) {
        [self dbLastError];
    }
    return insertResult;
}

- (NSMutableArray *)selectMemorialReceive
{
    NSDate *now = [NSDate date];
    NSString *selectMemorialReceiveSql
    =@"SELECT * FROM t_memorial_receive WHERE notice_date <= ?";
    FMResultSet *results = [self.memorialDatabase executeQuery:selectMemorialReceiveSql, [Common getDateString:@"yyyyMMddHHmmss" convDate:now]];
    
    NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:0];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        while ([results next]) {
            [notifications addObject:[self notificationFromResult:results]];
        }
        return notifications;
    }
}

-(Notification *)notificationFromResult:(FMResultSet *)results
{
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        Notification *notification  = [[Notification alloc] init];
        notification.deceased_no = [results intForColumnIndex:0];
        notification.notice_kind = [results intForColumnIndex:1];
        notification.notice_date = [Common getDateLong:[results stringForColumnIndex:2]];
        notification.memorial_no = [results intForColumnIndex:3];
        return notification;
    }
}

// 最後に発生したFMDBのエラー情報をログに出力
- (void)dbLastError
{
    NSLog(@"DB error: %@", [_memorialDatabase lastError]);
}

@end
