//
//  EcSiteViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2014/05/03.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EcSiteViewController <NSObject>
-(void) hideEcSiteViewController:(UIViewController *)EcSiteViewController;
@end

@interface EcSiteViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic) int noticeTiming;
@property (nonatomic, copy) NSString *url;

@end
