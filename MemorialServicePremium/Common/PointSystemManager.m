//
//  PointSystemManager.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import "PointSystemManager.h"
#import "Define.h"
#import "PointUser.h"

@interface PointSystemManager()
@end

@implementation PointSystemManager

- (BOOL)registerPointUser
{
    //空のパラメータを作成する
    NSMutableDictionary *parameters = [@{} mutableCopy];
    //HTTPアクセス
    HttpAccess *access = [HttpAccess alloc];
    NSData *returnData = [access POST:POINT_ADD_USER param:parameters];
    
    //debugログ
    NSString *strResult = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strResult);
    
    //JSONObjectから利用者IDを取り出す
    NSError *errorObject = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&errorObject];
    
    if ([jsonObject isEqual:@"false"]) {
        return NO;
    }
    
    NSString *userId = [NSString new];
    userId = [jsonObject objectForKey:USER_ID];
    
    NSLog(@"user_id:%@", userId);
    
    //NSUserDefaultsに保存
    PointUser *pointUser = [PointUser alloc];
    pointUser.userId = userId;
    [pointUser saveUserDefaults];
    
    NSLog(@"%@", [pointUser dump]);
    
    return YES;
}

- (BOOL)updatePointUser:(PointUser *)userInfo
{
    HttpAccess *access = [HttpAccess new];
    NSData *returnData = [access POST:POINT_UPDATE_USER param:[userInfo getHttpParameter]];
    
    NSString *strResult = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", strResult);
    
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    
    if ([jsonObject isEqual:@"false"]) {
        return NO;
    }
    
    return [[jsonObject objectForKey:@"result"] boolValue];
}

- (NSInteger)getPointFromServer
{
    PointUser *userInfo = [PointUser new];
    [userInfo loadUserDefaults];
    
    HttpAccess *access = [HttpAccess new];
    NSData *returnData = [access POST:POINT_GET_USER param:[userInfo getHttpParameter]];
    
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    
    if ([jsonObject isEqual:@"false"]) {
        return -1;
    }
    
    NSDictionary *resultUserInfo = [jsonObject objectForKey:@"personalInfo"];

    if ([resultUserInfo isEqual:[NSNull null]]) {
        return -1;
    }
    
    return [[resultUserInfo objectForKey:@"point"] integerValue];
}

- (void)downloadBarcodeImage
{
    //利用者情報を取得
    PointUser *userInfo = [PointUser new];
    [userInfo loadUserDefaults];
    
    //画像データを取得
    HttpAccess *access = [HttpAccess new];
    NSMutableDictionary *parameter = [@{@"pointUserId":userInfo.userId} mutableCopy];
    NSData *imageSrc = [access POST:GET_BARCODE param:parameter];
    
    //画像データを保存
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [path objectAtIndex:0];
    NSString *dataPath = [documentDir stringByAppendingPathComponent:[userInfo.userId stringByAppendingString:@".jpg"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL fileExist = [fileManager fileExistsAtPath:dataPath];
    if (fileExist) {
        imageSrc = [NSData dataWithContentsOfFile:dataPath];
    } else {
        [imageSrc writeToFile:dataPath atomically:YES];
    }
    
    //NOTICEを発行
    NSDictionary *dic = @{@"path":dataPath};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_BARCODE_DOWNLOADED object:self userInfo:dic];
}

@end