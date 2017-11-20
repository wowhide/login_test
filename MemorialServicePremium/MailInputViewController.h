//
//  MailInputViewController.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MailInputViewController;

@protocol MailInputViewDelegate <NSObject>
-(void) hideMailInputView:(UIViewController *)mailInputViewController;
@end

//MailInputViewControllerの宣言
@interface MailInputViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) id <MailInputViewDelegate> delegate;
@end
