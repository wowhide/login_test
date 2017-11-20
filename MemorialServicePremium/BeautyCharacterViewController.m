//
//  BeautyCharacterViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/01/17.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "BeautyCharacterViewController.h"
#import "BeautyCharacterDisplayViewController.h"
#import "Define.h"
#import "InputValidataion.h"
#import "Toast+UIView.h"
#import "PointUser.h"
#import "PointUserInfoViewController.h"


@interface BeautyCharacterViewController (){
    
    //美文字遷移名前
    NSString *name;
    NSString *saveName;
    //会員番号
    NSString *memberId;
    //アプリID
    NSString *appliid;
    //ユーザーデフォルト
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIButton *UserInfo;

@end

@implementation BeautyCharacterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    // Custom initialization
         defaults = [NSUserDefaults standardUserDefaults];
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
    
    self.nameText.delegate = self;
    
    //ツールバーを生成
    UIToolbar *toolBar =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    

    //スタイルの設定
    toolBar.barStyle = UIBarStyleDefault;
    
    //ツールバーを画面サイズに合わせる
    [toolBar sizeToFit];
    
    //「完了」ボタンを右端に配置したいためフレキスブルなスペースを作成する
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //完了ボタンの生成
    UIBarButtonItem *_commitBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard:)];
    
    //ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn,nil];
    
    //表示・非表示の設定
    [toolBar setItems:toolBarItems animated:YES];
    
    //ToolbarをTextViewのinputAccessoryViewに設定
    self.nameText.inputAccessoryView = toolBar;

    saveName = [defaults stringForKey:@"BEAUTYCHARACTER_SAVE"];
    if (saveName.length > 0) {
        [self.nameText setText:saveName];
    }
    // ログに出力
    NSLog(@"%@kikikiki", saveName);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    saveName = [defaults stringForKey:@"BEAUTYCHARACTER_SAVE"];
    if (saveName.length > 0) {
        [self.nameText setText:saveName];
    }

}

-(void)closeKeyboard:(id)sender{
    [self.nameText resignFirstResponder];
}

// UITextFieldのキーボード上の「Return」ボタンが押された時に呼ばれる処理
- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    
    // 受け取った入力をラベルに代入
    self.nameText.text = sender.text;
    
    // キーボードを閉じる
    [sender resignFirstResponder];
    
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 最大入力文字数
    int maxInputLength = 7;
    
    // 入力済みのテキストを取得
    NSMutableString *str = [textField.text mutableCopy];
    
    // 入力済みのテキストと入力が行われたテキストを結合
    [str replaceCharactersInRange:range withString:string];
    
    if ([str length] > maxInputLength) {
        
        //入力文字数が７文字を超えた場合、エラーメッセージをダイアログ表示
        [self.view makeToast:@"7文字以内で入力してください" duration:TOAST_DURATION_ERROR position:[NSValue valueWithCGPoint:CGPointMake(170, 150)]];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//決定ボタンタップ時の処理
- (IBAction)decisionBtnClick:(id)sender
{
    //入力値を美文字表示に渡す
    name = self.nameText.text;
    
    //入力チェック
    NSString *errorMessage = [InputValidataion checkName:self.nameText.text];
    
    if ([errorMessage length] > 0) {
        //エラーメッセージをダイアログ表示
        [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
    }else{
        //美文字表示のインスタンスを生成
        BeautyCharacterDisplayViewController *beautycharacterdisplayViewController = [BeautyCharacterDisplayViewController new];
        
        //pushViewControllerしたとき、tabBarも一緒に隠す
        beautycharacterdisplayViewController.hidesBottomBarWhenPushed = YES;

        //入力値を美文字表示画面に表示
        beautycharacterdisplayViewController.userParam = name;
        
        //美文字表示画面に遷移
        [self.navigationController pushViewController:beautycharacterdisplayViewController animated:NO];

    }
}

//情報登録ページに遷移
- (IBAction)ClickUserInfo:(id)sender {
    
        [self.navigationController pushViewController:[PointUserInfoViewController new] animated:YES];
}
@end
