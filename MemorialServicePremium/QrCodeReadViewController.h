//
//  QrCodeReadViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/21.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QrCodeReadViewController;

@protocol QrCodeReadViewDelegate <NSObject>
-(void) hideQrCodeReadView:(BOOL)readBool;
-(void) returnQrCodeReadView:(BOOL)readBool;

@end

@interface QrCodeReadViewController : UIViewController
@property (weak, nonatomic) id <QrCodeReadViewDelegate> delegate;
@property int fromView;
@end
