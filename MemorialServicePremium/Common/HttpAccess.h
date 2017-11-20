//
//  HttpAccess.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpAccess : NSObject

- (NSData *)POST:(NSString *)requestURL param:(NSMutableDictionary *)parameter;
- (void)get:(NSString *)requestURL param:(NSString *)parameter;
- (NSDictionary *)getpersonaldata:(NSString *)requestURL param:(NSString *)parameter;
- (void)getnotice:(NSString *)requestURL param:(NSString *)parameter params:(int)parameter2;
- (void)getdeceasename:(NSString *)requestURL param:(NSString *)parameter params:(NSString *)parameter2 params:(NSString *)parameter3 params:(NSString *)parameter4 params:(NSString *)parameter5;
- (void)deletedeceasename:(NSString *)requestURL param:(NSString *)parameter;
- (void)deletedataKey:(NSString *)requestURL param:(NSString *)parameter;
- (void)updatedeceasedupdatecount:(NSString *)requestURL param:(NSString *)parameter;

@end
