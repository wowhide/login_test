//
//  MorticianDao.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/24.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DatabaseHelper.h"
#import "Mortician.h"

@interface MorticianDao : NSObject
@property (nonatomic) FMDatabase *memorialDatabase;
+ (MorticianDao *)morticianDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase;
- (Mortician *)selectMortician;
- (BOOL)insertMortician:(Mortician *)mortician;
- (BOOL)deleteMortician;
@end
