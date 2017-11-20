//
//  DatabaseHelper.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "DatabaseHelper.h"

//DatabaseHelperの実装
@implementation DatabaseHelper

- (FMDatabase *)memorialDatabase
{
    //sqlite3のDBを置くドキュメントディレクトリのパスを取得
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

/*
    //デバッグ用ログ
    NSLog(@"--- %@", [documentDir stringByAppendingPathComponent:@"memorial.db"]);
*/

    //FMDatabaseのインスタンスを作成
    _memorialDatabase = [[FMDatabase alloc] initWithPath:[documentDir stringByAppendingPathComponent:@"memorial.db"]];
    
    //DBをオープンする。DBが存在しない場合、作成する
    if (![_memorialDatabase open]) {
//        NSLog(@"Could not open database");
    }
    
    //利用者テーブルが存在しない場合、作成する
    NSString *createTableUserSql
    = @"CREATE TABLE IF NOT EXISTS t_user ("
    "    mail_address TEXT PRIMARY KEY,"
    "    name TEXT NOT NULL,"
    "    notice_month_deathday_before INTEGER NOT NULL DEFAULT -1,"
    "    notice_month_deathday INTEGER NOT NULL DEFAULT 1,"
    "    notice_deathday_1week_before INTEGER NOT NULL DEFAULT 1,"
    "    notice_deathday_before INTEGER NOT NULL DEFAULT -1,"
    "    notice_deathday INTEGER NOT NULL DEFAULT -1,"
    "    notice_memorial_3month_before INTEGER NOT NULL DEFAULT -1,"
    "    notice_memorial_1month_before INTEGER NOT NULL DEFAULT 1,"
    "    notice_memorial_1week_before INTEGER NOT NULL DEFAULT -1,"
    "    notice_time	TEXT NOT NULL DEFAULT '0800',"
    "    install_datetime TEXT NOT NULL,"
    "    entry_datetime TEXT NOT NULL)";
    if (![_memorialDatabase executeUpdate:createTableUserSql]) {
        [self dbLastError];
    }
/*
    //葬儀社テーブルが存在しない場合、作成する
    NSString *createTableMorticianSql
    =@"CREATE TABLE IF NOT EXISTS t_mortician ("
    "    mortician_no INTEGER PRIMARY KEY,"
    "    mortician_name TEXT NOT NULL,"
    "    mortician_post TEXT NOT NULL,"
    "    mortician_address TEXT NOT NULL,"
    "    mortician_tel TEXT NOT NULL,"
    "    mortician_mail TEXT NOT NULL,"
    "    mortician_url TEXT NOT NULL,"
    "    mortician_memorial_url TEXT NOT NULL,"
    "    entry_datetime TEXT NOT NULL)";
    if (![_memorialDatabase executeUpdate:createTableMorticianSql]) {
        [self dbLastError];
    }
*/
    //故人テーブルが存在しない場合、作成する
    NSString *createTableDeceasedSql
    =@"CREATE TABLE IF NOT EXISTS t_deceased ("
    "    deceased_no INTEGER PRIMARY KEY AUTOINCREMENT,"
    "    deceased_id TEXT NOT NULL UNIQUE,"
    "    qr_flg INTEGER NOT NULL,"
    "    deceased_name TEXT NOT NULL,"
    "    deceased_birthday TEXT NOT NULL,"
    "    deceased_deathday TEXT NOT NULL,"
    "    kyonen_gyonen_flg INTEGER NOT NULL,"
    "    death_age INTEGER NOT NULL,"
    "    deceased_photo_path TEXT NOT NULL,"
    "    entry_datetime TEXT NOT NULL,"
    "    timestamp TEXT NOT NULL)";
    if (![_memorialDatabase executeUpdate:createTableDeceasedSql]) {
        [self dbLastError];
    }
    
    //通知先テーブルが存在しない場合、作成する
    NSString *createTableNoticeSql
    =@"CREATE TABLE IF NOT EXISTS t_notice ("
    "    deceased_no INTEGER,"
    "    notice_no INTEGER,"
    "    notice_name TEXT NOT NULL,"
    "    notice_address TEXT NOT NULL,"
    "    entry_datetime TEXT NOT NULL,"
    "    primary key (deceased_no, notice_no))";
    if (![_memorialDatabase executeUpdate:createTableNoticeSql]) {
        [self dbLastError];
    }

    //法要受信テーブルが存在しない場合、作成する
    NSString *createTableMemorialReceiveSql
    =@"CREATE TABLE IF NOT EXISTS t_memorial_receive ("
    "    deceased_no INTEGER NOT NULL,"
    "    notice_kind INTEGER NOT NULL,"
    "    notice_date TEXT NOT NULL,"
    "    memorial_no INTEGER NOT NULL)";
    if (![_memorialDatabase executeUpdate:createTableMemorialReceiveSql]) {
        [self dbLastError];
    }

    //FMDBのハンドラーを返す
    return _memorialDatabase;
}

// 最後に発生したFMDBのエラー情報をログに出力
- (void)dbLastError
{
    NSLog(@"DB error: %@", [_memorialDatabase lastError]);
}

@end
