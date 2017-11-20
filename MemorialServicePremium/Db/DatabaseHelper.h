//
//  DatabaseHelper.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

//DatabaseHelperの宣言
@interface DatabaseHelper : NSObject

//インスタンス変数にFMDBのハンドラーを保持する
@property (strong, nonatomic) FMDatabase *memorialDatabase;

@end
