//
//  ReadMemberIdQrViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/03/27.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "ReadMemberIdQrViewController.h"
#import "Define.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "QrCodeReadViewController.h"
#import "IndicatorWindow.h"
#import "HttpAccess.h"

@interface ReadMemberIdQrViewController (){
    UITextField *_textField;
    NSUserDefaults *defaults;
    NSString *entryMemberNumber;
    NSString *entryMemberPassword;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITextView *welcomeAboutTextView;
@property (weak, nonatomic) IBOutlet UIButton *qrNowReadButton;
@property (weak, nonatomic) IBOutlet UIButton *qrLaterReadButton;
@property (weak, nonatomic) IBOutlet UITextField *memberNumber;
@property (weak, nonatomic) IBOutlet UITextField *memberPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *readMemberIdScroll;
@property (weak, nonatomic) IBOutlet UIView *readMemberIdScrollView;

@end

@implementation ReadMemberIdQrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //ようこそ愛彩花倶楽部へを表示
    NSString* sentenceUse = [[NSBundle mainBundle] localizedStringForKey:@"aisaika_welcome_about" value:nil table:LOCALIZE_FILE];
    self.welcomeAboutTextView.text = [self.welcomeAboutTextView.text stringByAppendingString:sentenceUse];
    
    //ようこそ愛彩花倶楽部への文字サイズを指定
    [self.welcomeAboutTextView setFont:[UIFont systemFontOfSize:17]];
    
    //ようこそ愛彩花倶楽部への背景色を指定
    self.welcomeAboutTextView.backgroundColor = [UIColor colorWithRed:TEXTVIEW_BG_COLOR_RED green:TEXTVIEW_BG_COLOR_GREEN blue:TEXTVIEW_BG_COLOR_BLUE alpha:1.0];
    //編集不可にする
    self.welcomeAboutTextView.editable = NO;
    
    [self.memberNumber setDelegate:self];
    [self.memberPassword setDelegate:self];
    
    //背景をクリックしたらキーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.readMemberIdScroll addGestureRecognizer:gestureRecognizer];
    
    //スクロールのため、height値をプラス
    float width = [[UIScreen mainScreen]bounds].size.width;
    float height = [[UIScreen mainScreen]bounds].size.height+1150;
    
    //UIScrollViewのコンテンツサイズを設定
    self.readMemberIdScroll.contentSize = CGSizeMake(width,height);
    
    //スクロールバーを表示
    self.readMemberIdScroll.showsVerticalScrollIndicator = YES;
    //ボタンの背景色設定
    _qrNowReadButton.backgroundColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    _qrLaterReadButton.backgroundColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    _loginButton.backgroundColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    //キーボードタイプを指定
//    self.memberNumber.keyboardType = UIKeyboardTypeASCIICapable;
//    self.memberPassword.keyboardType = UIKeyboardTypeASCIICapable;
//
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
    self.memberNumber.inputAccessoryView = closeBar;
    self.memberPassword.inputAccessoryView = closeBar;

    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    // キーボード表示時
    [notification addObserver:self selector:@selector(keyboardWillShow:)
                         name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
    [notification addObserver:self selector:@selector(keyboardWillHide:)
                         name: UIKeyboardWillHideNotification object:nil];
    

}

-(void)viewWillAppear:(BOOL)animated{
    //キーボードタイプを指定
    self.memberNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.memberPassword.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    //パスワード形式にする
    [self.memberPassword setSecureTextEntry:YES];
    
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
    self.memberNumber.inputAccessoryView = closeBar;
    self.memberPassword.inputAccessoryView = closeBar;
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    // キーボード表示時
    [notification addObserver:self selector:@selector(keyboardWillShow:)
                         name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
    [notification addObserver:self selector:@selector(keyboardWillHide:)
                         name: UIKeyboardWillHideNotification object:nil];
}


//初期表示　先頭行表示処理
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.welcomeAboutTextView setContentOffset:CGPointZero animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//QR読込ボタンクリック時
- (IBAction)qrReadButtonPushed:(id)sender {
    
    //インターネットの接続状態を取得
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //接続できない場合
        [self.view makeToast:@"ネットワークに接続できる環境で読み込んで下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    //インターネットに接続可能な場合、QR読込画面を表示
    QrCodeReadViewController *qrCodeReadViewController = [[QrCodeReadViewController alloc] init];
    qrCodeReadViewController.delegate = self;
    qrCodeReadViewController.fromView = QR_READ_VIEW_FROM_DECEASED_LIST;
    [self presentViewController:qrCodeReadViewController animated:NO completion:nil];
    
}

//QR読込後に呼ばれるデリゲート
- (void)hideQrCodeReadView:(BOOL)readBool
{
    //QR読み込み画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //当画面も閉じ、トップメニューへ遷移
    [self.delegate hideReadMemberIdQrView:self];
}

//QR読込画面で「戻る」ボタンをタップ時に呼ばれるデリゲート
-(void)returnQrCodeReadView:(BOOL)readBool{
    //QR読み込み画面を閉じる
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

//ログインボタン押下時
- (IBAction)pushLoginButton:(id)sender {
        

    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //接続できない場合
        [self.view makeToast:@"ネットワークに接続できる環境でダウンロードして下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

    //インジケーター開始
    [IndicatorWindow openWindow];
    
    //入力後の会員番号を取得
    entryMemberNumber       = self.memberNumber.text;
    //入力後のパスワードを取得
    entryMemberPassword     = self.memberPassword.text;
    
    //入力チェック
    if (entryMemberNumber.length == 0 && entryMemberPassword.length == 0) {
        //インジケータを閉じる
        [IndicatorWindow closeWindow];
        //エラーメッセージをダイアログ表示
        [self.view makeToast:@"会員番号・パスワードが未入力です。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    if (entryMemberNumber.length == 0) {
        //インジケータを閉じる
        [IndicatorWindow closeWindow];
        //エラーメッセージをダイアログ表示
        [self.view makeToast:@"会員番号が未入力です。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    if (entryMemberPassword.length == 0) {
        //インジケータを閉じる
        [IndicatorWindow closeWindow];
        //エラーメッセージをダイアログ表示
        [self.view makeToast:@"パスワードが未入力です。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }
    
    //入力されている場合、ログイン認証を行う
    //画面操作を禁止する
    self.view.userInteractionEnabled = NO;
    self.toolBar.userInteractionEnabled = NO;
    self.readMemberIdScroll.userInteractionEnabled = NO;
    self.readMemberIdScrollView.userInteractionEnabled = NO;
    
    // 別スレッドでログイン認証を行う
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loginAuth)
                                        object:nil];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];
    
}

-(void)loginAuth{
    
    HttpAccess *httpAccess = [HttpAccess new];
    
    NSMutableDictionary *parameter = [@{@"member_id":entryMemberNumber,@"member_password":entryMemberPassword} mutableCopy];
    
    NSData *returnData = [httpAccess POST:LOGIN_AUTH param:parameter];
    
    NSString *result= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"ログイン認証：%@",result);
    
    if ([result isEqualToString:@"1"]) {
        
        [self.view makeToast:@"成功しました。" duration:TOAST_DURATION_ERROR position:@"center"];
        
        //        defaults = [NSUserDefaults standardUserDefaults];                       // 取得
        //        [defaults setBool:YES forKey:@"KEY_DOWNLOAD"];
        //        [defaults synchronize];                                                 // 反映
        
        //デバイストークンを取得
        defaults = [NSUserDefaults standardUserDefaults];
        NSString *strToken = [defaults stringForKey:KEY_DEVICE_TOKEN];
        
        //リクエスト先を指定する
        NSString *deviceToken_urlAsString = SAVE_DEVICE_TOKEN_AND_DECEASED_ID;
        NSURL *deviceToken_url = [NSURL URLWithString:deviceToken_urlAsString];
        //POSTメソッドのHTTPリクエストを生成する
        NSMutableURLRequest *deviceToken_urlRequest = [NSMutableURLRequest requestWithURL:deviceToken_url];
        [deviceToken_urlRequest setHTTPMethod:@"POST"];
        //パラメータを付与
        NSString *deviceToken_body = [NSString stringWithFormat:@"device_token=%@&deceased_id=%@",strToken, entryMemberNumber];
        [deviceToken_urlRequest setHTTPBody:[deviceToken_body dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSHTTPURLResponse *deviceToken_response;
        NSError *deviceToken_error = nil;
        
        //HTTP同期通信を実行
        NSData *deviceTokenResult = [NSURLConnection sendSynchronousRequest:deviceToken_urlRequest returningResponse:&deviceToken_response error:&deviceToken_error];
        
        //デバイストークンをサーバーに保存
        if (deviceTokenResult && deviceToken_response.statusCode == 200) {
            //成功
            [defaults setBool:YES forKey:@"DEVICETOKEN_SAVE"];
            [defaults synchronize];
        } else {
            //失敗
        }
        
        //アプリIDを取得
        NSMutableDictionary *parameter = [@{@"member_id":entryMemberNumber} mutableCopy];
        
        NSData *returnData = [httpAccess POST:GET_APPLIID param:parameter];
        
        NSString *appliId= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"アプリID：%@",appliId);
        
        //ユーザーデフォルト
        [defaults setObject:entryMemberNumber forKey:KEY_MEMBER_USER_ID];   // 会員番号_更新
        [defaults setObject:appliId forKey:KEY_MEMBER_APPLI_ID];           // appli_id_更新
        [defaults setObject:@"0" forKey:KEY_DECEASED_UPDATE_COUNT];         // deceased_update_count_更新
        [defaults setObject:@"" forKey:KEY_RYOBO_PHOTO_PATh];               // ryobo_photo_path_更新
        [defaults setObject:@"" forKey:KEY_MEMBER_SENDAR_NAME];             // member_sendar_name更新
        [defaults setObject:@"0" forKey:KEY_MOVE_FIRST_TOPMENU];            // move_first_topmenu
        [defaults setBool:YES forKey:@"KEY_DOWNLOAD"];
        [defaults synchronize];
        
        // メインスレッドでインディケーターを閉じる
        [self performSelectorOnMainThread:@selector(closeIndicator) withObject:nil waitUntilDone:NO];
    }else{
        // メインスレッドでインディケーターを閉じる
        [self performSelectorOnMainThread:@selector(falselogin) withObject:nil waitUntilDone:NO];
    }
    
}


-(void)closeIndicator{
    //インジケータを閉じる
    [IndicatorWindow closeWindow];
    //当画面も閉じ、トップメニューへ遷移
    [self.delegate hideReadMemberIdQrView:self];
}

-(void)falselogin{
    //インジケータを閉じる
    [IndicatorWindow closeWindow];
    
    self.view.userInteractionEnabled = YES;
    self.toolBar.userInteractionEnabled = YES;
    self.readMemberIdScroll.userInteractionEnabled = YES;
    self.readMemberIdScrollView.userInteractionEnabled = YES;
    [self.view makeToast:@"会員番号、またはパスワードが正しくありません。" duration:TOAST_DURATION_ERROR position:@"center"];
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    
    [self.delegate hideReadMemberIdQrView:self];
    
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
        self.readMemberIdScroll.contentInset = contentInsets;
        self.readMemberIdScroll.scrollIndicatorInsets = contentInsets;
        
        CGPoint pt = [self.readMemberIdScroll convertPoint:_textField.frame.origin toView:self.view];
        
        if(CGRectGetMinY(keyboardRect) < pt.y)
        {
            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height+200);
            [self.readMemberIdScroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

//キーボード非表示時
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.readMemberIdScroll.contentInset = contentInsets;
        self.readMemberIdScroll.scrollIndicatorInsets = contentInsets;
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
@end
