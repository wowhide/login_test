//
//  DeceasedDao.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/26.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DatabaseHelper.h"
#import "Deceased.h"

@interface DeceasedDao : NSObject
@property (nonatomic) FMDatabase *memorialDatabase;
+ (DeceasedDao *)deceasedDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase;
- (NSMutableArray *)selectDeceased;
- (int)countDeceased;
- (BOOL)existenceQrDeceased;
- (BOOL)insertDeceased:(Deceased *)deceased;
- (BOOL)insertDeceasedTakeIn:(Deceased *)deceased;
- (void)updatePhotopath:(NSString *)fileName byDeceasedId:(NSString *)deceasedId;
- (Deceased *)selectDeceasedByOffset:(int)offset;
- (Deceased *)selectDeceasedfamilytree;
- (Deceased *)selectDeceasedByDeceasedNo:(int)deceasedNo;
- (NSString *)getNextDeceasedId;
- (BOOL)deleteDeceased:(int)deceasedNo;
- (BOOL)deleteDeceasedByDeceasedId:(NSString *)deceasedId;
- (BOOL)deleteDeceasedAll;
- (void)updateDeceased:(Deceased *)deceased;
- (Deceased *)selectDeceasedByDeceasedId:(NSString *)deceasedId;
@end
