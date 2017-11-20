//
//  NoticeInfo.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2014/05/02.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeInfo : NSObject
@property (nonatomic) int notice_info_no;
@property (nonatomic) NSString *notice_schedule;
@property (nonatomic) int entry_method;
@property (nonatomic) NSString *notice_title;
@property (nonatomic) NSString *notice_text;
@property (nonatomic) int image_existence_flg;
@property (nonatomic) NSString *url;
@property (nonatomic) int notice_flg;
@property (nonatomic) NSString *deceased_id;
@end
