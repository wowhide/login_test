//
//  DeceasedInfoEntryActivity.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/13.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "DeceasedInfoEntryViewController.h"
#import "Common.h"
#import "Define.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "InputValidataion.h"
#import "Toast+UIView.h"
#import "HttpAccess.h"
#import "Reachability.h"

@interface DeceasedInfoEntryViewController () {
    UIImage *_photoImage;
    UITextField *_textField;
    NSString *memberId;
    NSUserDefaults *defaults;
    //アプリID
    NSString *appliId;
    
    
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *deceasedScroll;
@property (weak, nonatomic) IBOutlet UIView *deceasedScrollView;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *photoSelectLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *deathdayPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *deathAgeSeg;
@property (weak, nonatomic) IBOutlet UITextField *deathAgeText;

@end

@implementation DeceasedInfoEntryViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    [self.nameText setDelegate:self];
    [self.deathAgeText setDelegate:self];
    
    //背景をクリックしたらキーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.deceasedScrollView addGestureRecognizer:gestureRecognizer];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //生年月日の年を70年前に設定する
    NSDate *past60yearsAgo = [Common getPastDateYear:-70];
    [self.birthdayPicker setDate:past60yearsAgo animated:NO];
    
    //命日の年を当年に設定する
    NSDate *past10yearsAgo = [Common getPastDateYear:0];
    [self.deathdayPicker setDate:past10yearsAgo animated:NO];
    
//    //命日の年を10年前に設定する
//    NSDate *past10yearsAgo = [Common getPastDateYear:-10];
//    [self.deathdayPicker setDate:past10yearsAgo animated:NO];
    
    //年齢を計算して設定
    int age = [Common calcAge:self.birthdayPicker.date deathday:self.deathdayPicker.date];
    
    self.deathAgeText.text = [NSString stringWithFormat:@"%d", age];
    
    //年齢のキーボードタイプを指定
    self.deathAgeText.keyboardType = UIKeyboardTypeNumberPad;
    
    //UIScrollViewのコンテンツサイズを設定
    self.deceasedScroll.contentSize = self.deceasedScrollView.bounds.size;
    //スクロールバーを表示
    self.deceasedScroll.showsVerticalScrollIndicator = YES;
    
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
    self.nameText.inputAccessoryView = closeBar;
    self.deathAgeText.inputAccessoryView = closeBar;
    //満を選択
    self.deathAgeSeg.selectedSegmentIndex = 2;
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    // キーボード表示時
    [notification addObserver:self selector:@selector(keyboardWillShow:)
                         name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
    [notification addObserver:self selector:@selector(keyboardWillHide:)
                         name: UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];  // 会員番号取得
    appliId = [defaults stringForKey:KEY_MEMBER_APPLI_ID];  // アプリID取得
    
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//登録ボタンクリック時
- (IBAction)entryButtonPushed:(id)sender {
    
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {

        //接続できない場合、エラーメッセージをダイアログ表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"ネットワークに接続できる環境で使用して下さい。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        return;
    }
    

    //　入力チェック
    NSString *errorMessage = [InputValidataion checkDeceasedEntry:self.nameText.text withAge:self.deathAgeText.text withBirthday:self.birthdayPicker.date withDeathday:self.deathdayPicker.date withDeathdaytoday:self.deathdayPicker.date];
    
    if ([errorMessage length] > 0) {
        //エラーメッセージをダイアログ表示
        [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
    } else {
        //画面上の入力値を取得
        Deceased *deceased  = [[Deceased alloc] init];
        deceased.qr_flg = QR_FLG_NO;
        //故人名は半角を全角に変換して保存
        NSString *name = self.nameText.text;
        NSMutableString *convertedName = [name mutableCopy];
        CFStringTransform((CFMutableStringRef)convertedName, NULL, kCFStringTransformFullwidthHalfwidth, true);
        deceased.deceased_name = convertedName;
        deceased.deceased_birthday = [Common getDateString:@"yyyyMMdd" convDate:self.birthdayPicker.date];
        deceased.deceased_deathday = [Common getDateString:@"yyyyMMdd" convDate:self.deathdayPicker.date];
        //享年行年は、選択されたセグメントにより保存内容を分岐
        switch (self.deathAgeSeg.selectedSegmentIndex) {
            case 0: //享年
                deceased.kyonen_gyonen_flg = KG_FLG_KYONEN;
                break;
            case 1: //行年
                deceased.kyonen_gyonen_flg = KG_FLG_GYONEN;
                break;
            case 2: //満
                deceased.kyonen_gyonen_flg = KG_FLG_MAN;
                break;
            case 3: //なし
                deceased.kyonen_gyonen_flg = KG_FLG_NOTHING;
                break;
            default:
                break;
        }
        deceased.death_age = [self.deathAgeText.text intValue];
        
        //現在日時を文字列で取得
        NSString *now = [Common getDateString:@"yyyyMMddHHmmss"];
        deceased.entry_datetime = now;
        deceased.timestamp = now;
        
        //DBに接続
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
        
        //次に割り当てられるdeceased_no(AUTO INCREMENT)の値を取得
//        NSString *deceasedId = [deceasedDao getNextDeceasedId];
       
        //乱数発行＿deceased_idの値にする
        int randId = (int)arc4random_uniform(100000000);
        NSLog(@"乱数:%d",randId);
        NSString *deceasedId = [NSString stringWithFormat:@"%d", randId];
    
        NSLog(@"新規登録故人写真No%@",deceasedId);
        
        //IDとして設定
        deceased.deceased_id = deceasedId;
        
        //画像を選択している場合、画像をドキュメントフォルダに保存し、ファイル名をDeceasedに設定する
        if (_photoImage != nil) {
            //ファイル名生成
            NSString *saveFileName = [NSString stringWithFormat:@"%@.jpg",deceasedId];
            //保存先パス生成
            NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, deceased.deceased_id];
            
            //サイズを調整する
            CGFloat newSize = IMAGE_REDUCTION_SIZE;
            UIImage *resizeImage = [Common resizeImage:_photoImage toSize:newSize];
            
            //保存する
            NSData *data = UIImageJPEGRepresentation(resizeImage, 0.8);
            if ([data writeToFile:dataPath atomically:YES]) {
                //                NSLog(@"hozon:OK");
            } else {
                //                NSLog(@"hozon:NG");
                //DBを閉じる
                [memorialDatabase close];
                //エラーメッセージをダイアログ表示
                [self.view makeToast:@"登録に失敗しました。\nもう一度登録して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
                return;
            }
            
            //ファイル名設定
            deceased.deceased_photo_path = saveFileName;
        } else {
            //ファイル名設定
            deceased.deceased_photo_path = @"";
        }
        
        //DBに登録
        if([deceasedDao insertDeceased:deceased]) {
            
            //DBを閉じる
            [memorialDatabase close];
            
            
            //登録した故人をDBにインサート、故人データアップデートカウント＿１プラスする処理
            //取得したデータをJSON形式に変換
            NSError *error;
            //故人
            NSMutableArray *deceasedsNsma = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *deceasedNsmd = [NSMutableDictionary dictionary];
            [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.deceased_no] forKey:@"deceased_no"];
            [deceasedNsmd setValue:deceased.deceased_id forKey:@"deceased_id"];
            [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.qr_flg] forKey:@"qr_flg"];
            [deceasedNsmd setValue:deceased.deceased_name forKey:@"deceased_name"];
            [deceasedNsmd setValue:deceased.deceased_birthday forKey:@"deceased_birthday"];
            [deceasedNsmd setValue:deceased.deceased_deathday forKey:@"deceased_deathday"];
            [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.kyonen_gyonen_flg] forKey:@"kyonen_gyonen_flg"];
            [deceasedNsmd setValue:[NSString stringWithFormat:@"%d", deceased.death_age] forKey:@"death_age"];
            [deceasedNsmd setValue:deceased.deceased_photo_path forKey:@"deceased_photo_path"];
            [deceasedNsmd setValue:deceased.entry_datetime forKey:@"entry_datetime"];
            [deceasedNsmd setValue:deceased.timestamp forKey:@"timestamp"];
            [deceasedsNsma addObject:deceasedNsmd];
            
            
            NSData *deceasedJson =
            [NSJSONSerialization dataWithJSONObject:deceasedsNsma
                                            options:kNilOptions error:&error];
            
            //会員番号QRを読み込んでいる場合
            BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
            
            if (transfer_download) {
                //DBデーターアップロード
                //リクエスト先を指定する
                
                NSString *saveuserdata_urlAsString = INSERT_DECEASED_NO;
                
                NSURL *saveuserdata_url = [NSURL URLWithString:saveuserdata_urlAsString];
                
                //POSTメソッドのHTTPリクエストを生成する
                NSMutableURLRequest *saveuserdata_urlRequest = [NSMutableURLRequest requestWithURL:saveuserdata_url];
                [saveuserdata_urlRequest setHTTPMethod:@"POST"];
                //パラメータを付与
                NSString *saveuserdata_body = [NSString stringWithFormat:@"deceased=%@&appli_id=%@",
                                               [[NSString alloc] initWithData:deceasedJson encoding:NSUTF8StringEncoding],
                                               appliId
                                               ];
                [saveuserdata_urlRequest setHTTPBody:[saveuserdata_body dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSHTTPURLResponse *saveuserdata_response;
                NSError *saveuserdata_error = nil;
                
                //HTTP同期通信を実行
                NSData *saveUserDataResult = [NSURLConnection sendSynchronousRequest:saveuserdata_urlRequest returningResponse:&saveuserdata_response error:&saveuserdata_error];
                
                NSLog(@"saveUserDataResult=%@", saveUserDataResult);
            }
            
            //登録完了をトースト表示
            [self.view makeToast:@"登録が完了しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
            
            //1.5秒後、上の階層に戻る
            [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popView) userInfo:nil repeats:NO];
        } else {
            //DBを閉じる
            [memorialDatabase close];
            
            //エラーメッセージをダイアログ表示
            [self.view makeToast:@"登録に失敗しました。\nもう一度登録して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        }
    }
}

//上の階層に戻る
- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

//写真選択時、イメージピッカーを表示する
- (IBAction)photoSelectButtonPushed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//イメージピッカーのイメージ取得時に呼ばれる
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //イメージを取得する
    _photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //ラベルに選択済を設定
    self.photoSelectLabel.text = @"選択済";
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//イメージピッカーのキャンセル時に呼ばれる
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//誕生日ピッカー変更時に呼ばれる
- (IBAction)birthdayPickerChanged:(id)sender {
    //年齢を計算して設定
    int age = [Common calcAge:self.birthdayPicker.date deathday:self.deathdayPicker.date];
    self.deathAgeText.text = [NSString stringWithFormat:@"%d", age];
}

//命日ピッカー変更時に呼ばれる
- (IBAction)deathdayPickerChanged:(id)sender {
    //年齢を計算して設定
    int age = [Common calcAge:self.birthdayPicker.date deathday:self.deathdayPicker.date];
    self.deathAgeText.text = [NSString stringWithFormat:@"%d", age];
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
        self.deceasedScroll.contentInset = contentInsets;
        self.deceasedScroll.scrollIndicatorInsets = contentInsets;
        
        CGPoint pt = [self.deceasedScroll convertPoint:_textField.frame.origin toView:self.view];
        
        if(CGRectGetMinY(keyboardRect) < pt.y)
        {
            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height);
            [self.deceasedScroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

//キーボード非表示時
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.deceasedScroll.contentInset = contentInsets;
        self.deceasedScroll.scrollIndicatorInsets = contentInsets;
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
