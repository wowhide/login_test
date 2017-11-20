//
//  AisaikaclubReadMemberIdQrViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/03/29.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QrCodeReadViewController.h"

@class AisaikaclubReadMemberIdQrViewController;

@protocol AisaikaclubReadMemberIdQrViewDelegate <NSObject>

-(void) hideaisaikaclubReadQrView:(BOOL)readBool;
-(void) returnAisaikaclubReadQrView:(BOOL)readBool;


@end

@interface AisaikaclubReadMemberIdQrViewController : UIViewController<QrCodeReadViewDelegate>

@property (weak, nonatomic) id <AisaikaclubReadMemberIdQrViewDelegate> delegate;

- (IBAction)returnButtonPushed:(id)sender;

@end

