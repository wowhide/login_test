//
//  PointUser.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import "PointUser.h"

@implementation PointUser

NSString *const USER_ID     = @"user_id";
NSString *const USER_NAME   = @"user_name";
NSString *const BIRTHDAY    = @"user_birthday";
NSString *const POSTAL_CODE = @"user_postalcode";
NSString *const ADDRESS     = @"user_address";
NSString *const TEL         = @"user_tel";
NSString *const IS_SKIP     = @"is_skip";

- (id)init
{
    if (self = [super init]) {
        _userId     = @"";
        _userName   = @"";
        _birthday   = @"";
        _postalCode = @"";
        _address    = @"";
        _tel        = @"";
        _isSkip     = NO;
    }
    
    return self;
}

- (void)loadUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _userId     = [defaults stringForKey:USER_ID];
    _userName   = [defaults stringForKey:USER_NAME];
    _birthday   = [defaults stringForKey:BIRTHDAY];
    _postalCode = [defaults stringForKey:POSTAL_CODE];
    _address    = [defaults stringForKey:ADDRESS];
    _tel        = [defaults stringForKey:TEL];
    _isSkip     = [[defaults stringForKey:IS_SKIP] boolValue];
}

- (void)saveUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:(_userId)? _userId : @"" forKey:USER_ID];
    [defaults setObject:(_userName)? _userName : @"" forKey:USER_NAME];
    [defaults setObject:(_birthday)? _birthday : @"" forKey:BIRTHDAY];
    [defaults setObject:(_postalCode)? _postalCode : @"" forKey:POSTAL_CODE];
    [defaults setObject:(_address)? _address : @"" forKey:ADDRESS];
    [defaults setObject:(_tel)? _tel : @"" forKey:TEL];
    [defaults setObject:[NSString stringWithFormat:@"%@", (_isSkip)? @"YES" : @"NO"] forKey:IS_SKIP];
    
    [defaults synchronize];
}

- (NSString *)dump
{
    NSString *strDump = @"ポイント機能利用者情報\n";
    //USER_ID
    strDump = [strDump stringByAppendingString:USER_ID];
    strDump = [strDump stringByAppendingString:@":"];
    strDump = [strDump stringByAppendingString:[_userId length] ? _userId:@""];
    strDump = [strDump stringByAppendingString:@"\n"];
    //USER_NAME
    strDump = [strDump stringByAppendingString:USER_NAME];
    strDump = [strDump stringByAppendingString:@":"];
    strDump = [strDump stringByAppendingString:[_userName length] ? _userName:@""];
    strDump = [strDump stringByAppendingString:@"\n"];
    //BIRTHDAY
    strDump = [strDump stringByAppendingString:BIRTHDAY];
    strDump = [strDump stringByAppendingString:@":"];
    strDump = [strDump stringByAppendingString:[_birthday length] ? _birthday:@""];
    strDump = [strDump stringByAppendingString:@"\n"];
    //POSTAL_CODE
    strDump = [strDump stringByAppendingString:POSTAL_CODE];
    strDump = [strDump stringByAppendingString:@":"];
    strDump = [strDump stringByAppendingString:[_postalCode length] ? _postalCode:@""];
    strDump = [strDump stringByAppendingString:@"\n"];
    //ADDRESS
    strDump = [strDump stringByAppendingString:ADDRESS];
    strDump = [strDump stringByAppendingString:@":"];
    strDump = [strDump stringByAppendingString:[_address length] ? _address:@""];
    strDump = [strDump stringByAppendingString:@"\n"];
    //TEL
    strDump = [strDump stringByAppendingString:TEL];
    strDump = [strDump stringByAppendingString:@":"];
    strDump = [strDump stringByAppendingString:[_tel length] ? _tel:@""];
    strDump = [strDump stringByAppendingString:@"\n"];
    //IS_SKIP
    strDump = [strDump stringByAppendingString:IS_SKIP];
    strDump = [strDump stringByAppendingString:@":"];
    strDump = [strDump stringByAppendingString:(_isSkip) ? @"YES" : @"NO"];
    
    return strDump;
}

- (NSMutableDictionary*)getHttpParameter
{
    NSMutableDictionary *parameter = [@{@"userId":_userId,         @"userName":_userName,
                                        @"userBirthday":_birthday, @"userPostalcode":_postalCode,
                                        @"userAddress":_address,   @"userTel":_tel}
                                      mutableCopy];
    
    return parameter;
}

@end