//
//  MorticianDao.m
//  MemorialService
//
//  Created by pc131101 on 2013/12/24.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import "MorticianDao.h"
#import "Common.h"

@implementation MorticianDao

+ (id)morticianDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase
{
    MorticianDao *morticianDao = [[MorticianDao alloc] init];
    morticianDao.memorialDatabase = memorialDatabase;
    return morticianDao;
}

- (Mortician *)selectMortician
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_mortician"];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        if ([results next]) {
            Mortician *mortician  = [[Mortician alloc] init];
            mortician.mortician_no = [results intForColumnIndex:0];
            mortician.mortician_name = [results stringForColumnIndex:1];
            mortician.mortician_post = [results stringForColumnIndex:2];
            mortician.mortician_address = [results stringForColumnIndex:3];
            mortician.mortician_tel = [results stringForColumnIndex:4];
            mortician.mortician_mail = [results stringForColumnIndex:5];
            mortician.mortician_url = [results stringForColumnIndex:6];
            mortician.mortician_memorial_url = [results stringForColumnIndex:7];
            mortician.entry_datetime = [results stringForColumnIndex:8];
            return mortician;
        } else {
            return nil;
        }
    }
}

- (BOOL)insertMortician:(Mortician *)mortician
{
    NSString *insertMorticianSql
    = @"INSERT INTO t_mortician ("
    "    mortician_no,"
    "    mortician_name,"
    "    mortician_post,"
    "    mortician_address,"
    "    mortician_tel,"
    "    mortician_mail,"
    "    mortician_url,"
    "    mortician_memorial_url,"
    "    entry_datetime) "
    "VALUES (?,?,?,?,?,?,?,?,?)";

    BOOL insertResult = [self.memorialDatabase executeUpdate:insertMorticianSql, [NSNumber numberWithInt:mortician.mortician_no], mortician.mortician_name, mortician.mortician_post, mortician.mortician_address, mortician.mortician_tel, mortician.mortician_mail, mortician.mortician_url, mortician.mortician_memorial_url, mortician.entry_datetime];
    if (!insertResult) {
        [self dbLastError];
    }

    return insertResult;
}

- (BOOL)deleteMortician
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_mortician"]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

// 最後に発生したFMDBのエラー情報をログに出力
- (void)dbLastError
{
    NSLog(@"DB error: %@", [_memorialDatabase lastError]);
}

@end