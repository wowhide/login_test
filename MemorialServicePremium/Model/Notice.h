//
//  Notice.h
//  MemorialService
//
//  Created by pc131101 on 2013/12/24.
//  Copyright (c) 2013年 DIGITALSPACEWOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject
@property (nonatomic) int deceased_no;
@property (nonatomic) int notice_no;
@property (nonatomic) NSString *notice_name;
@property (nonatomic) NSString *notice_address;
@property (nonatomic) NSString *entry_datetime;
@end
