//
//  PointUser.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface PointUser : NSObject
//JSONオブジェクト フィールド名
extern NSString *const USER_ID;                 //利用者ID
extern NSString *const USER_NAME;               //利用者名
extern NSString *const BIRTHDAY;                //生年月日
extern NSString *const POSTAL_CODE;             //郵便番号
extern NSString *const ADDRESS;                 //住所
extern NSString *const TEL;                     //電話番号
extern NSString *const IS_SKIP;                 //個人情報登録スキップフラグ

//プロパティ
@property (nonatomic) NSString *userId;         //利用者ID
@property (nonatomic) NSString *userName;       //利用者名
@property (nonatomic) NSString *birthday;       //生年月日
@property (nonatomic) NSString *postalCode;     //郵便番号
@property (nonatomic) NSString *address;        //住所
@property (nonatomic) NSString *tel;            //電話番号
@property (nonatomic) BOOL isSkip;              //個人情報登録スキップフラグ

/**
 イニシャライザ
 */
- (id)init;

/**
 NSUserDefaultsからポイント機能利用者情報を読み込む
 */
-(void)loadUserDefaults;

/**
 NSUserDefaultsにポイント機能利用者情報を保存する
 */
-(void)saveUserDefaults;

/**
 プロパティの情報をNSString化する
 */
-(NSString*)dump;

/**
 プロパティの情報をWebAPIで使用するパラメータに変換する
 */
-(NSMutableDictionary*)getHttpParameter;

@end
