//
//  UserDao.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/26.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DatabaseHelper.h"
#import "User.h"

@interface UserDao : NSObject
@property (nonatomic) FMDatabase *memorialDatabase;
+ (UserDao *)userDaoWithMemorialDatabase:(FMDatabase *)memorialDatabase;
- (User *)selectUser;
- (BOOL)insertUser;
- (BOOL)updateUser:(User *)user;
- (BOOL)updateUserName:(NSString *)name;
- (BOOL)updateNotice:(User *)user;
@end
