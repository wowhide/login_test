//
//  DeceasedDao.m
//  MemorialService
//
//  Created by pc131101 on 2013/12/26.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import "DeceasedDao.h"
#import "Common.h"

@implementation DeceasedDao

+ (id)deceasedDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase
{
    DeceasedDao *deceasedDao = [[DeceasedDao alloc] init];
    deceasedDao.memorialDatabase = memorialDatabase;
    return deceasedDao;
}

- (int)countDeceased
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT count(*) FROM t_deceased"];
    if (!results) {
        [self dbLastError];
        return 0;
    } else {
        [results next];
        return [results intForColumnIndex:0];
    }
}

- (BOOL)existenceQrDeceased
{
    FMResultSet *results =
        [self.memorialDatabase executeQuery:@"SELECT count(*) FROM t_deceased WHERE qr_flg = 1"];
    if (!results) {
        [self dbLastError];
        return NO;
    } else {
        [results next];
        int qrDeceasedCount = [results intForColumnIndex:0];
        if (qrDeceasedCount > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (NSMutableArray *)selectDeceased
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_deceased ORDER BY deceased_deathday"];
    NSMutableArray *deceaseds   = [[NSMutableArray alloc] initWithCapacity:0];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        while ([results next]) {
            [deceaseds addObject:[self deceasedFromResult:results]];
        }
        return deceaseds;
    }
}

- (Deceased *)selectDeceasedByOffset:(int)offset
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_deceased ORDER BY deceased_deathday DESC LIMIT 1 OFFSET ?", [NSNumber numberWithInt:offset]];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        [results next];
        Deceased *deceased = [self deceasedFromResult:results];
        return deceased;
    }
}

- (Deceased *)selectDeceasedByDeceasedNo:(int)deceasedNo
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_deceased WHERE deceased_no = ?", [NSNumber numberWithInt:deceasedNo]];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        [results next];
        Deceased *deceased = [self deceasedFromResult:results];
        return deceased;
    }
}

//家系図向け
- (Deceased *)selectDeceasedfamilytree
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_deceased"];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        [results next];
        Deceased *deceased = [self deceasedFromResult:results];
        return deceased;
    }
}

- (Deceased *)selectDeceasedByDeceasedId:(NSString *)deceasedId
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_deceased WHERE deceased_id = ?", deceasedId];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        [results next];
        Deceased *deceased = [self deceasedFromResult:results];
        return deceased;
    }
}

-(Deceased *)deceasedFromResult:(FMResultSet *)results
{
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        Deceased *deceased  = [[Deceased alloc] init];
        deceased.deceased_no = [results intForColumnIndex:0];
        deceased.deceased_id = [results stringForColumnIndex:1];
        deceased.qr_flg = [results intForColumnIndex:2];
        deceased.deceased_name = [results stringForColumnIndex:3];
        deceased.deceased_birthday = [results stringForColumnIndex:4];
        deceased.deceased_deathday = [results stringForColumnIndex:5];
        deceased.kyonen_gyonen_flg = [results intForColumnIndex:6];
        deceased.death_age = [results intForColumnIndex:7];
        deceased.deceased_photo_path = [results stringForColumnIndex:8];
        deceased.entry_datetime = [results stringForColumnIndex:9];
        deceased.timestamp = [results stringForColumnIndex:10];
        return deceased;
    }
}

- (BOOL)insertDeceased:(Deceased *)deceased
{
    NSString *insertDeceasedSql
    = @"INSERT INTO t_deceased ("
    "    deceased_id,"
    "    qr_flg,"
    "    deceased_name,"
    "    deceased_birthday,"
    "    deceased_deathday,"
    "    kyonen_gyonen_flg,"
    "    death_age,"
    "    deceased_photo_path,"
    "    entry_datetime,"
    "    timestamp) "
    "VALUES (?,?,?,?,?,?,?,?,?,?)";

    BOOL insertResult = [self.memorialDatabase executeUpdate:insertDeceasedSql, deceased.deceased_id, [NSNumber numberWithInt:deceased.qr_flg], deceased.deceased_name, deceased.deceased_birthday, deceased.deceased_deathday, [NSNumber numberWithInt:deceased.kyonen_gyonen_flg], [NSNumber numberWithInt:deceased.death_age], deceased.deceased_photo_path, deceased.entry_datetime, deceased.timestamp];
    if (!insertResult) {
        [self dbLastError];
    }

    return insertResult;
}

- (BOOL)insertDeceasedTakeIn:(Deceased *)deceased
{
    NSString *insertDeceasedSql
    = @"INSERT INTO t_deceased ("
    "    deceased_no,"
    "    deceased_id,"
    "    qr_flg,"
    "    deceased_name,"
    "    deceased_birthday,"
    "    deceased_deathday,"
    "    kyonen_gyonen_flg,"
    "    death_age,"
    "    deceased_photo_path,"
    "    entry_datetime,"
    "    timestamp) "
    "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL insertResult = [self.memorialDatabase executeUpdate:insertDeceasedSql, [NSNumber numberWithInt:deceased.deceased_no], deceased.deceased_id, [NSNumber numberWithInt:deceased.qr_flg], deceased.deceased_name, deceased.deceased_birthday, deceased.deceased_deathday, [NSNumber numberWithInt:deceased.kyonen_gyonen_flg], [NSNumber numberWithInt:deceased.death_age], deceased.deceased_photo_path, deceased.entry_datetime, deceased.timestamp];
    if (!insertResult) {
        [self dbLastError];
    }
    
    return insertResult;
}

- (void)updatePhotopath:(NSString *)fileName byDeceasedId:(NSString *)deceasedId
{
    //現在日時を文字列で取得
    NSString *now = [Common getDateString:@"yyyyMMddHHmmss"];
    
    NSString *updatePhotopathSql
    = @"UPDATE t_deceased SET"
        "    deceased_photo_path = ?,"
        "    timestamp = ?"
        "WHERE deceased_id = ?";
    
    BOOL updateResult = [self.memorialDatabase executeUpdate:updatePhotopathSql, fileName, now, deceasedId];
    if (!updateResult) {
        [self dbLastError];
    }
}

//次に割り当てられるAUTO INCREMENTの値を取得する
- (NSString *)getNextDeceasedId
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT seq FROM sqlite_sequence WHERE name = 't_deceased'"];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        [results next];
        int nextDeceasedNo = [results intForColumnIndex:0];
        nextDeceasedNo += 1;
        return [NSString stringWithFormat:@"%d", nextDeceasedNo];
    }
}

//指定されたNoの故人様を削除する
- (BOOL)deleteDeceased:(int)deceasedNo
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_deceased WHERE deceased_no = ?", [NSNumber numberWithInt:deceasedNo]]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

//指定されたIDの故人様を削除する
- (BOOL)deleteDeceasedByDeceasedId:(NSString *)deceasedId
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_deceased WHERE deceased_id = ?", deceasedId]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

//故人情報を上書きする
- (void)updateDeceased:(Deceased *)deceased
{
    //現在日時を文字列で取得
    NSString *now = [Common getDateString:@"yyyyMMddHHmmss"];
    
    NSString *updateDeceasedSql
    = @"UPDATE t_deceased SET"
       "    deceased_name = ?,"
       "    deceased_birthday = ?,"
       "    deceased_deathday = ?,"
       "    kyonen_gyonen_flg = ?,"
       "    death_age = ?,"
       "    deceased_photo_path = ?,"
       "    timestamp = ?"
       "WHERE deceased_no = ?";
    
    BOOL updateResult = [self.memorialDatabase executeUpdate:updateDeceasedSql, deceased.deceased_name, deceased.deceased_birthday, deceased.deceased_deathday, [NSNumber numberWithInt:deceased.kyonen_gyonen_flg], [NSNumber numberWithInt:deceased.death_age], deceased.deceased_photo_path, now, [NSNumber numberWithInt:deceased.deceased_no]];
    if (!updateResult) {
        [self dbLastError];
    }
}

//すべての故人情報を削除する
- (BOOL)deleteDeceasedAll
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_deceased"]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

//最後に発生したFMDBのエラー情報をログに出力
- (void)dbLastError
{
    NSLog(@"DB error: %@", [_memorialDatabase lastError]);
}

@end
