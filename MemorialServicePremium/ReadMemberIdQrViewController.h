//
//  ReadMemberIdQrViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/03/27.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QrCodeReadViewController.h"

@class ReadMemberIdQrViewController;

@protocol ReadMemberIdQrViewDelegate <NSObject>

-(void) hideReadMemberIdQrView:(UIViewController *) readMemberIdQrViewController;

@end

@interface ReadMemberIdQrViewController : UIViewController<QrCodeReadViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) id <ReadMemberIdQrViewDelegate> delegate;

- (IBAction)returnButtonPushed:(id)sender;

@end
