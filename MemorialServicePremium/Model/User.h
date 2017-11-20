//
//  User.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/24.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic) NSString *mail_address;
@property (nonatomic) NSString *name;
@property (nonatomic) int notice_month_deathday_before;
@property (nonatomic) int notice_month_deathday;
@property (nonatomic) int notice_deathday_1week_before;
@property (nonatomic) int notice_deathday_before;
@property (nonatomic) int notice_deathday;
@property (nonatomic) int notice_memorial_3month_before;
@property (nonatomic) int notice_memorial_1month_before;
@property (nonatomic) int notice_memorial_1week_before;
@property (nonatomic) NSString *notice_time;
@property (nonatomic) NSString *point_user_id;
@property (nonatomic) NSString *install_datetime;
@property (nonatomic) NSString *entry_datetime;
@end
