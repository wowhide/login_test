//
//  MailInputViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/08.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "MailInputViewController.h"
#import "DatabaseHelper.h"
#import "UserDao.h"
#import "InputValidataion.h"
#import "Toast+UIView.h"
#import "Common.h"
#import "Define.h"
#import "PointSystemManager.h"
#import "Reachability.h"
#import "IndicatorWindow.h"

@interface MailInputViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *entryScroll;
@property (weak, nonatomic) IBOutlet UIView *entryScrollView;

@property (weak, nonatomic) IBOutlet UITextView *sentenceRuleTextView;
@property (weak, nonatomic) IBOutlet UISwitch *ruleSwitch;

@end

//MailInputViewControllerの実装
@implementation MailInputViewController {
    UITextField *_textField;
}

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
    
    //情報取得
    [self readNetInfo];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];

    //UIScrollViewのコンテンツサイズを設定
    self.entryScroll.contentSize = self.entryScrollView.bounds.size;
    //スクロールバーを表示
    self.entryScroll.showsVerticalScrollIndicator = YES;
    
    //背景をクリックしたらキーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.entryScrollView addGestureRecognizer:gestureRecognizer];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    
    //利用規約を表示
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* sentenceRule = [bundle localizedStringForKey:@"sentence_rule" value:nil table:LOCALIZE_FILE];
    if (IS_POINT_ACTIVE) {
        //ポイント機能の利用規約を表示
        NSString* sentencePointRule = [bundle localizedStringForKey:@"sentence_point" value:nil table:LOCALIZE_FILE];
        sentenceRule = [sentenceRule stringByAppendingString:@"\n"];
        sentenceRule = [sentenceRule stringByAppendingString:sentencePointRule];
    }
    self.sentenceRuleTextView.text = sentenceRule;

    //利用規約の背景色を指定
    self.sentenceRuleTextView.backgroundColor = [UIColor colorWithRed:TEXTVIEW_BG_COLOR_RED green:TEXTVIEW_BG_COLOR_GREEN blue:TEXTVIEW_BG_COLOR_BLUE alpha:1.0];
    
    self.sentenceRuleTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    //キーボード閉じるボタン用ツールバーを生成
    UIToolbar *closeBar = [[UIToolbar alloc] init];
    //スタイルの設定
    closeBar.barStyle = UIBarStyleDefault;
    //ツールバーを画面サイズに合わせる
    [closeBar sizeToFit];
    //「完了」ボタンを右端に配置したいためフレキシブルなスペースを作成する。
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //完了ボタンの生成
    UIBarButtonItem *_commitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSoftKeyboard)];
    //ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn, nil];
    //表示・非表示の設定
    [closeBar setItems:toolBarItems animated:YES];

    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    // キーボード表示時
    [notification addObserver:self selector:@selector(keyboardWillShow:)
						 name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
	[notification addObserver:self selector:@selector(keyboardWillHide:)
						 name: UIKeyboardWillHideNotification object:nil];
}


//情報読み込み
- (void)readNetInfo {
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        
        //接続できない場合、エラーメッセージをダイアログ表示
        [self.view makeToast:@"ネットワークに接続できる環境で表示して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

}

//登録ボタンクリック時の処理
- (IBAction)entryButtonPushed:(id)sender
{
    //入力チェック
    NSString *errorMessage = [InputValidataion checkEntry:_ruleSwitch.on];
    if ([errorMessage length] > 0) {
        //エラーメッセージをダイアログ表示
        [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
    } else {
        //DBに登録
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
        
        User *currentUser = [userDao selectUser];
        BOOL insertResult = NO;
        
        //登録状況によってInsert or Update
        if (currentUser == nil) {
            insertResult = [userDao insertUser];
        } else {
            currentUser.entry_datetime = [Common getDateString:@"yyyyMMddHHmmss"];
            insertResult = [userDao updateUser:currentUser];
        }
        
        if(insertResult) {
            //DBを閉じる
            [memorialDatabase close];
            if (IS_POINT_ACTIVE) {
                //ポイント機能に利用者登録
                PointSystemManager *pointManager = [PointSystemManager new];
                [pointManager registerPointUser];
            }
            //登録完了をトースト表示
            [self.view makeToast:@"利用規約に同意しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
            
            //1.5秒後、親画面のデリゲート処理を実行
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popView) userInfo:nil repeats:NO];
        } else {
            //DBを閉じる
            [memorialDatabase close];
            
            //エラーメッセージを表示
            [self.view makeToast:@"エラーが発生しました。\nもう一度利用規約に同意して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        }
    }
}

//親画面のデリゲート処理を実行
- (void)popView
{
    [self.delegate hideMailInputView:self];
}

//編集中のTextFieldを保持
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _textField = textField;
    return YES;
}

//キーボード表示時
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(keyboardRect), 0.0);
        self.entryScroll.contentInset = contentInsets;
        self.entryScroll.scrollIndicatorInsets = contentInsets;
        
        CGPoint pt = [self.entryScroll convertPoint:_textField.frame.origin toView:self.view];
        
        if(CGRectGetMinY(keyboardRect) < pt.y)
        {
            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height);
            [self.entryScroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

//キーボード非表示時
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.entryScroll.contentInset = contentInsets;
        self.entryScroll.scrollIndicatorInsets = contentInsets;
    }
}

//テキストフィールドでエンターキーがクリックされた場合にキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// キーボードを隠す処理
- (void)closeSoftKeyboard {
    [self.view endEditing: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
