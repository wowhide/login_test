//
//  NoticeDao.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/15.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeDao.h"
#import "Common.h"

@implementation NoticeDao

+ (id)noticeDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase
{
    NoticeDao *noticeDao = [[NoticeDao alloc] init];
    noticeDao.memorialDatabase = memorialDatabase;
    return noticeDao;
}

- (NSMutableArray *)selectNotice
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_notice"];
    NSMutableArray *notices   = [[NSMutableArray alloc] initWithCapacity:0];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        while ([results next]) {
            [notices addObject:[self noticeFromResult:results]];
        }
        return notices;
    }
}

- (NSMutableArray *)selectNoticeByDeceasedNo:(int)deceasedNo
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_notice WHERE deceased_no = ?", [NSNumber numberWithInt:deceasedNo]];
    NSMutableArray *notices   = [[NSMutableArray alloc] initWithCapacity:0];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        while ([results next]) {
            [notices addObject:[self noticeFromResult:results]];
        }
        return notices;
    }
}

-(Notice *)noticeFromResult:(FMResultSet *)results
{
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        Notice *notice  = [[Notice alloc] init];
        notice.deceased_no = [results intForColumnIndex:0];
        notice.notice_no = [results intForColumnIndex:1];
        notice.notice_name = [results stringForColumnIndex:2];
        notice.notice_address = [results stringForColumnIndex:3];
        notice.entry_datetime = [results stringForColumnIndex:4];
        return notice;
    }
}

- (int)countNoticeByDeceasedNo:(int)deceasedNo
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT count(*) FROM t_notice WHERE deceased_no = ?", [NSNumber numberWithInt:deceasedNo]];
    if (!results) {
        [self dbLastError];
        return 0;
    } else {
        [results next];
        return [results intForColumnIndex:0];
    }
}

- (Notice *)selectNoticeByOffset:(int)offset andDeceasedNo:(int)deceasedNo
{
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT * FROM t_notice WHERE deceased_no = ? ORDER BY notice_no LIMIT 1 OFFSET ?", [NSNumber numberWithInt:deceasedNo], [NSNumber numberWithInt:offset]];
    if (!results) {
        [self dbLastError];
        return nil;
    } else {
        [results next];
        Notice *notice = [self noticeFromResult:results];
        return notice;
    }
}

- (BOOL)deleteNoticeByDeceasedNo:(int)deceasedNo
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_notice WHERE deceased_no = ?", [NSNumber numberWithInt:deceasedNo]]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

- (BOOL)deleteNoticeByDeceasedNo:(int)deceasedNo andNoticeNo:(int)noticeNo
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_notice WHERE deceased_no = ? AND notice_no = ?", [NSNumber numberWithInt:deceasedNo], [NSNumber numberWithInt:noticeNo]]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

- (BOOL)deleteNoticeAll
{
    if ([self.memorialDatabase executeUpdate:@"DELETE FROM t_notice"]) {
        return YES;
    } else {
        [self dbLastError];
        return NO;
    }
}

//次の通知先No（引数の故人Noの中で最大の通知先No+1）を取得
- (int)getNextNoticeNo:(int)deceasedNo
{
    int nextNoticeNo = 0;
    
    FMResultSet *results = [self.memorialDatabase executeQuery:@"SELECT max(notice_no) FROM t_notice WHERE deceased_no = ?", [NSNumber numberWithInt:deceasedNo]];
    if (!results) {
        [self dbLastError];
        nextNoticeNo = -1;
    } else {
        [results next];
        nextNoticeNo = [results intForColumnIndex:0] + 1;
    }
    return nextNoticeNo;
}

- (BOOL)insertNotice:(int)deceasedNo andName:(NSString *)name andMail:(NSString *)mail
{
    //現在日時を文字列で取得
    NSString *now = [Common getDateString:@"yyyyMMddHHmmss"];

    //次の通知Noを取得
    int nextNoticeNo = [self getNextNoticeNo:deceasedNo];
    if (nextNoticeNo == -1) {
        return NO;
    }

    NSString *insertNoticeSql
    = @"INSERT INTO t_notice ("
       "    deceased_no,"
       "    notice_no,"
       "    notice_name,"
       "    notice_address,"
       "    entry_datetime) "
       "VALUES (?,?,?,?,?)";

    BOOL insertResult = [self.memorialDatabase executeUpdate:insertNoticeSql, [NSNumber numberWithInt:deceasedNo], [NSNumber numberWithInt:nextNoticeNo], name, mail, now];

    if (!insertResult) {
        [self dbLastError];
    }

    return insertResult;
}

- (BOOL)insertNotice:(Notice *)notice {
    NSString *insertNoticeSql
    = @"INSERT INTO t_notice ("
       "    deceased_no,"
       "    notice_no,"
       "    notice_name,"
       "    notice_address,"
       "    entry_datetime) "
       "VALUES (?,?,?,?,?)";
    
    BOOL insertResult = [self.memorialDatabase executeUpdate:insertNoticeSql, [NSNumber numberWithInt:notice.deceased_no], [NSNumber numberWithInt:notice.notice_no], notice.notice_name, notice.notice_address, notice.entry_datetime];
    
    if (!insertResult) {
        [self dbLastError];
    }

    return insertResult;
}

// 最後に発生したFMDBのエラー情報をログに出力
- (void)dbLastError
{
    NSLog(@"DB error: %@", [_memorialDatabase lastError]);
}

@end
