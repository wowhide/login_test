//
//  NoticeDao.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/15.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DatabaseHelper.h"
#import "Notice.h"

@interface NoticeDao : NSObject
@property (nonatomic) FMDatabase *memorialDatabase;
+ (NoticeDao *)noticeDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase;
- (Notice *)selectNoticeByOffset:(int)offset andDeceasedNo:(int)deceasedNo;
- (NSMutableArray *)selectNotice;
- (NSMutableArray *)selectNoticeByDeceasedNo:(int)deceasedNo;
- (int)countNoticeByDeceasedNo:(int)deceasedNo;
- (BOOL)deleteNoticeByDeceasedNo:(int)deceasedNo;
- (BOOL)deleteNoticeByDeceasedNo:(int)deceasedNo andNoticeNo:(int)noticeNo;
- (BOOL)deleteNoticeAll;
- (BOOL)insertNotice:(int)deceasedNo andName:(NSString *)name andMail:(NSString *)mail;
- (BOOL)insertNotice:(Notice *)notice;
@end
