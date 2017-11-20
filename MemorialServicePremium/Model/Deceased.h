//
//  Deceased.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/24.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deceased : NSObject
@property (nonatomic) int deceased_no;
@property (nonatomic) NSString *deceased_id;
@property (nonatomic) int qr_flg;
@property (nonatomic) NSString *deceased_name;
@property (nonatomic) NSString *deceased_birthday;
@property (nonatomic) NSString *deceased_deathday;
@property (nonatomic) int kyonen_gyonen_flg;
@property (nonatomic) int death_age;
@property (nonatomic) NSString *deceased_photo_path;
@property (nonatomic) NSString *entry_datetime;
@property (nonatomic) NSString *timestamp;
@end
