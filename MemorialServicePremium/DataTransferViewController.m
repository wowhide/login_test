//
//  DataTransferViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/27.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "DataTransferViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "DatabaseHelper.h"
#import "UserDao.h"
#import "User.h"
#import "InputValidataion.h"
#import "Define.h"

@interface DataTransferViewController () {
    NSString *_userName;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *transferScroll;
@property (weak, nonatomic) IBOutlet UIView *transferScrollView;

@property (weak, nonatomic) IBOutlet UILabel *accessViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation DataTransferViewController {
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
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    [self.emailText setDelegate:self];
    
    //背景をクリックしたらキーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.transferScrollView addGestureRecognizer:gestureRecognizer];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //UIScrollViewのコンテンツサイズを設定
    self.transferScroll.contentSize = self.transferScrollView.bounds.size;
    //スクロールバーを表示
    self.transferScroll.showsVerticalScrollIndicator = YES;
    
    //年齢のキーボードタイプを指定
    self.emailText.keyboardType = UIKeyboardTypeEmailAddress;
    
    //データーキーを画面に設定
    self.accessViewLabel.text = self.dataKey;
    
    //有効期限を計算して画面に設定する
    //現在日付
    NSDate *now = [NSDate date];
    //7日後の経過秒数
    NSTimeInterval ti = 60 * 60 * 24 * 7;
    NSDate *expirationDate = [now dateByAddingTimeInterval:ti];
    //日付のフォーマットを準備
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]]; // Localeの指定
    [df setDateFormat:@"yyyy年M月d日(EEE)"];
    //日付(NSDate) => 文字列(NSString)に変換
    NSString *expirationDateString = [df stringFromDate:expirationDate];
    //画面に設定
    self.expirationDateLabel.text = expirationDateString;
    self.expirationDateLabel.adjustsFontSizeToFitWidth = YES;
    
    //メールアドレスを取得して画面に設定する
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //利用者情報を取得
    UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userDao selectUser];
    //DBを閉じる
    [memorialDatabase close];
    //インスタンス変数に名前を設定
    _userName = user.name;
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
    //ToolbarをTextViewのinputAccessoryViewに設定
    self.emailText.inputAccessoryView = closeBar;

    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    // キーボード表示時
    [notification addObserver:self selector:@selector(keyboardWillShow:)
						 name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
	[notification addObserver:self selector:@selector(keyboardWillHide:)
						 name: UIKeyboardWillHideNotification object:nil];
}

//送信ボタンクリック時
- (IBAction)sendButtonPushed:(id)sender {
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //圏外のときの処理
        [self.view makeToast:@"ネットワークに接続できる環境でアップロードして下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    //メールアドレスの入力チェック
    NSString *errorMessage = [InputValidataion checkDataTransfer:self.emailText.text];
    if ([errorMessage length] > 0) {
        //エラーメッセージをダイアログ表示
        [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
    } else {
        //リクエスト先を指定する
        NSString *sendmail_urlAsString = SEND_DATA_KEY_MAIL;
        NSURL *sendmail_url = [NSURL URLWithString:sendmail_urlAsString];
        
        //POSTメソッドのHTTPリクエストを生成する
        NSMutableURLRequest *sendmail_urlRequest = [NSMutableURLRequest requestWithURL:sendmail_url];
        [sendmail_urlRequest setHTTPMethod:@"POST"];
        //パラメータを付与
        NSString *sendmail_body = [NSString stringWithFormat:@"datakey=%@&toMail=%@&toName=%@",self.dataKey, self.emailText.text, _userName];
        [sendmail_urlRequest setHTTPBody:[sendmail_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSHTTPURLResponse *sendmail_response;
        NSError *sendmail_error = nil;
        
        //HTTP同期通信を実行
        NSData *sendMailResult = [NSURLConnection sendSynchronousRequest:sendmail_urlRequest returningResponse:&sendmail_response error:&sendmail_error];
        
        //故人情報保存結果(データーキー)を取得
        if (sendMailResult && sendmail_response.statusCode == 200) {
            //トースト表示
            [self.view makeToast:@"メールを送信しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
        } else {
            //エラートースト表示
            [self.view makeToast:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        }
    }
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:YES];
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
        self.transferScroll.contentInset = contentInsets;
        self.transferScroll.scrollIndicatorInsets = contentInsets;
        
        CGPoint pt = [self.transferScroll convertPoint:_textField.frame.origin toView:self.view];
        
        if(CGRectGetMinY(keyboardRect) < pt.y)
        {
            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height);
            [self.transferScroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

//キーボード非表示時
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.transferScroll.contentInset = contentInsets;
        self.transferScroll.scrollIndicatorInsets = contentInsets;
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
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
