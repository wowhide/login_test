//
//  OtherHowToUseViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/21.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "OtherHowToUseViewController.h"
#import "Define.h"

@interface OtherHowToUseViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITextView *howToUseTextView;
@property (weak, nonatomic) IBOutlet UITextView *useTextView;

@end

@implementation OtherHowToUseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //使い方を表示
    NSString* sentenceUse = [[NSBundle mainBundle] localizedStringForKey:@"sentence_use" value:nil table:LOCALIZE_FILE];
    self.useTextView.text = [self.useTextView.text stringByAppendingString:sentenceUse];
    
    //使い方の文字サイズを指定
    [self.useTextView setFont:[UIFont systemFontOfSize:17]];
    
    //使い方の背景色を指定
    self.useTextView.backgroundColor = [UIColor colorWithRed:TEXTVIEW_BG_COLOR_RED green:TEXTVIEW_BG_COLOR_GREEN blue:TEXTVIEW_BG_COLOR_BLUE alpha:1.0];
    
    
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
