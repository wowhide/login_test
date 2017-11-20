//
//  NicefacePushViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/08/12.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTransferKeyNoticeViewController.h"


@interface NicefacePushViewController : UIViewController<UIWebViewDelegate,DataTransferKeyNoticeDelegate>

@property (nonatomic, copy) NSString *appli_id;
@property (nonatomic, copy) NSString *call_name;
@property (nonatomic) int call_timing;

@end
