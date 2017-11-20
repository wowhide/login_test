//
//  DataTransferKeyNoticeViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2016/11/15.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataTransferKeyNoticeDelegate <NSObject>

-(void) hideDataTransferKeyNoticeView:(UIViewController *)dataTransferKeyNoticeViewController;

@end

@interface DataTransferKeyNoticeViewController : UIViewController

@property(weak,nonatomic)id<DataTransferKeyNoticeDelegate> delegate;

@property (nonatomic, copy) NSString *callName;

-(void)removedisp;


@end
