//
//  PointSystemManager.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "HttpAccess.h"
#import "PointUser.h"

@interface PointSystemManager : NSObject

/**
 サーバに利用者IDを登録する
 */
- (BOOL)registerPointUser;

/**
 サーバの利用者情報を更新する
 */
- (BOOL)updatePointUser:(PointUser *)userInfo;

/**
 サーバからポイント数を取得する
 */
- (NSInteger)getPointFromServer;

/**
 サーバからバーコード画像をダウンロードする
 */
- (void)downloadBarcodeImage;
@end
