//
//  BeautyCharacterViewController.h
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/01/17.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BeautyCharacterViewController;

@protocol BeautyCharacterViewDelegate <NSObject>

@end

@interface BeautyCharacterViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) id <BeautyCharacterViewDelegate> delegate;

@end
