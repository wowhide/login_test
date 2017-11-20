//
//  MemorialReceiveDao.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2014/05/20.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DatabaseHelper.h"
#import "Notification.h"

@interface MemorialReceiveDao : NSObject
@property (nonatomic) FMDatabase *memorialDatabase;
+ (MemorialReceiveDao *)memorialReceiveDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase;
- (BOOL)deleteMemorialReceiveAll;
- (BOOL)deleteMemorialReceiveFuture;
- (BOOL)deleteMemorialReceive:(Notification *)notification;
- (BOOL)insertMemorialReceive:(Notification *)notification;
- (NSMutableArray *)selectMemorialReceive;
@end
