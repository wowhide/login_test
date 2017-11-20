//
//  TopMenuViewController.h
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/01/26.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailInputViewController.h"
#import "DataTakeInViewController.h"
#import "GoodMoriningCallSendViewController.h"
#import "AisaikaclubReadMemberIdQrViewController.h"

@interface TopMenuViewController : UIViewController<DataTakeInViewDelegate,GoodMoriningCallSendViewDelegate,AisaikaclubReadMemberIdQrViewDelegate>

@end
