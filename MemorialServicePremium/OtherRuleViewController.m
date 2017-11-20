//
//  OtherRuleViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/21.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "OtherRuleViewController.h"
#import "Define.h"

@interface OtherRuleViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITextView *ruleTextView;

@end

@implementation OtherRuleViewController

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
    
    //利用規約を表示
    NSString *sentenceRule  = [[NSBundle mainBundle] localizedStringForKey:@"sentence_rule" value:nil table:LOCALIZE_FILE];
    if (IS_POINT_ACTIVE) {      //ポイント機能が有効な場合
        NSString *sentenceRule2 = [[NSBundle mainBundle] localizedStringForKey:@"sentence_point" value:nil table:LOCALIZE_FILE];
        sentenceRule = [sentenceRule stringByAppendingString:[@"\n" stringByAppendingString:sentenceRule2]];
    }
    self.ruleTextView.text = sentenceRule;
    
    //利用規約の文字サイズを指定
    [self.ruleTextView setFont:[UIFont systemFontOfSize:17]];
    
    //利用規約の背景色を指定
    self.ruleTextView.backgroundColor = [UIColor colorWithRed:TEXTVIEW_BG_COLOR_RED green:TEXTVIEW_BG_COLOR_GREEN blue:TEXTVIEW_BG_COLOR_BLUE alpha:1.0];
    
    //スクロールバーのカクつき対策
    self.ruleTextView.layoutManager.allowsNonContiguousLayout = NO;
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
