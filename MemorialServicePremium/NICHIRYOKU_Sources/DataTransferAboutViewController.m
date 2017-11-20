//
//  DataTransferAboutViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/09/02.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "DataTransferAboutViewController.h"
#import "Define.h"

@interface DataTransferAboutViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITextView *dataTransferTextView;

@end



@implementation DataTransferAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
  

    //機種変更についてを表示
    NSString* sentenceUse = [[NSBundle mainBundle] localizedStringForKey:@"sentence_transfer_about" value:nil table:LOCALIZE_FILE];
    self.dataTransferTextView.text = [self.dataTransferTextView.text stringByAppendingString:sentenceUse];
    
    //機種変更についての文字サイズを指定
    [self.dataTransferTextView setFont:[UIFont systemFontOfSize:17]];
    
    //機種変更についての背景色を指定
    self.dataTransferTextView.backgroundColor = [UIColor colorWithRed:TEXTVIEW_BG_COLOR_RED green:TEXTVIEW_BG_COLOR_GREEN blue:TEXTVIEW_BG_COLOR_BLUE alpha:1.0];
    //編集不可にする
    self.dataTransferTextView.editable = NO;
    

}

//初期表示　先頭行表示処理
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.dataTransferTextView setContentOffset:CGPointZero animated:NO];
    
}
//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
