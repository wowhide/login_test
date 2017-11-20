//
//  PointUserInfoViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/11.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import "Define.h"
#import "HttpAccess.h"
#import "OtherViewController.h"
#import "PointUserInfoViewController.h"
#import "PointCardViewController.h"
#import "PointUser.h"
#import "PointSystemManager.h"
#import "TopMenuViewController.h"

@implementation PointUserInfoViewController

//イニシャライザ
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        name       = [NSString string];
        birthday   = [NSString string];
        postalcode = [NSString string];
        address    = [NSString string];
        tel        = [NSString string];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    //ツールバーの色を変更
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor    = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    //テーブル設定
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
    initialTableHeight = self.tableView.frame.size.height;
    
    //通知を受信するように設定
    if (!observing_) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        //キーボードの表示・非表示を監視
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //郵便番号の入力状態を監視
        [center addObserver:self selector:@selector(postalcodeTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        observing_ = YES;
    }
    
    //呼び出し元画面を判定
    unsigned long stackCount = [[self.navigationController viewControllers] count];
    UIViewController *viewController = [[self.navigationController viewControllers] objectAtIndex:stackCount - 2];
    
    NSLog(@"%@", NSStringFromClass([viewController class]));
    
    if ([viewController isKindOfClass:[TopMenuViewController class]]) {
        //その他画面から遷移の場合はチュートリアルを表示
        NSString *alertTitle = [[NSBundle mainBundle] localizedStringForKey:@"alert_title_notice"
                                                                      value:nil
                                                                      table:LOCALIZE_FILE];
        NSString *alertMessage = [[NSBundle mainBundle] localizedStringForKey:@"alert_message_point_introduce"
                                                                        value:nil
                                                                        table:LOCALIZE_FILE];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                 message:alertMessage
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"登録"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"スキップ"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 PointUser *user = [PointUser new];
                                                                 [user loadUserDefaults];
                                                                 user.isSkip = YES;
                                                                 [user saveUserDefaults];
                                                                 
                                                                 [self.navigationController
                                                                  pushViewController:[PointCardViewController new]
                                                                  animated:YES];
                                                             }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        //それ以外の場合は登録情報を画面に表示
        PointUser *userInfo = [PointUser new];
        [userInfo loadUserDefaults];
        //名前
        name = userInfo.userName;
        //生年月日
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *birthdayDate = [formatter dateFromString:userInfo.birthday];
        formatter.dateFormat = @"yyyy年MM月dd日";
        birthday = [formatter stringFromDate:birthdayDate];
        //郵便番号
        postalcode = userInfo.postalCode;
        //住所
        address = userInfo.address;
        //電話番号
        tel = userInfo.tel;
        //ボタンのラベルを変更
//        [self.executeButton setTitle:@"編集"];
    }
}

//UITableViewDataSourceのメソッド実装
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell設定
    NSString *CELL_IDENTIFIER = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //サブビューを削除
    for (UIView *subView in [cell.contentView subviews]) {
        [subView removeFromSuperview];
    }
    
    //テキストフィールド作成
    UITextField *textField;
    textField = [[UITextField alloc]
                 initWithFrame:CGRectMake(20, 0,
                                          cell.contentView.bounds.size.width - 20,
                                          cell.contentView.bounds.size.height)];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (indexPath.row == 4) {
        textField.returnKeyType = UIReturnKeyDone;
    } else {
        textField.returnKeyType   = UIReturnKeyNext;
    }
    textField.secureTextEntry = NO;
    textField.delegate = self;
    textField.tag = indexPath.row;
    
    //次へボタンツールバー
    UIToolbar *keyboardDoneButtonView = [UIToolbar new];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *doneButton;
    if (indexPath.row == 4) {
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" style:UIBarButtonItemStylePlain target:nil action:@selector(pickerNextClicked)];
    } else {
        doneButton = [[UIBarButtonItem alloc] initWithTitle:@"次へ" style:UIBarButtonItemStylePlain target:nil action:@selector(pickerNextClicked)];
    }
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:spacer, spacer1, doneButton, nil]];
    textField.inputAccessoryView = keyboardDoneButtonView;
    
    //DatePicker作成
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerSelectionChanged:) forControlEvents:UIControlEventValueChanged];
    if (birthday.length > 0) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        [datePicker setDate:[formatter dateFromString:birthday]];
    }
    
    //セルの設定
    switch (indexPath.row) {
        case 0:
            //氏名入力テキストフィールド設定
            self.nameField = textField;
            self.nameField.placeholder = @"お名前";
            [self.nameField setText:name];
            [cell.contentView addSubview:self.nameField];
            break;
        case 1:
            //生年月日入力テキストフィールド設定
            self.birthdayField = textField;
            self.birthdayField.placeholder = @"生年月日";
            [self.birthdayField setText:birthday];
            //DatePickerの設定
            self.birthdayField.inputView = datePicker;
            self.birthdayField.delegate = self;
            [cell.contentView addSubview:self.birthdayField];
            break;
        case 2:
            //郵便番号入力テキストフィールド設定
            self.postalcodeField = textField;
            self.postalcodeField.placeholder = @"〒";
            [self.postalcodeField setText:postalcode];
            self.postalcodeField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:self.postalcodeField];
            break;
        case 3:
            //住所入力テキストフィールド設定
            self.addressField = textField;
            self.addressField.placeholder = @"住所";
            self.addressField.text = address;
            [cell.contentView addSubview:self.addressField];
            break;
        case 4:
            //電話番号入力テキストフィールド設定
            self.telField = textField;
            self.telField.placeholder = @"電話番号";
            [self.telField setText:tel];
            self.telField.keyboardType = UIKeyboardTypePhonePad;
            [cell.contentView addSubview:self.telField];
            break;
        default:
            break;
    }
    
    return cell;
}

//UITableViewDataSourceのメソッド実装
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

//キーボード表示時のイベント処理
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo  = [notification userInfo];
    CGRect keyboardFrameEnd = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UITextField *activeTextField;
    if(self.nameField.isFirstResponder) {
        activeTextField = self.nameField;
    } else if(self.birthdayField.isFirstResponder) {
        activeTextField = self.birthdayField;
    } else if(self.postalcodeField.isFirstResponder) {
        activeTextField = self.postalcodeField;
    } else if(self.addressField.isFirstResponder) {
        activeTextField = self.addressField;
    } else {
        activeTextField = self.telField;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:activeTextField.tag inSection:0];
    
    float tableUnderY = self.tableView.frame.origin.y + self.tableView.frame.size.height;
    float keyboardStartY  = keyboardFrameEnd.origin.y;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, tableUnderY - keyboardStartY, 0.0);
    [self.tableView setContentInset:contentInsets];
    [self.tableView setScrollIndicatorInsets:contentInsets];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//キーボード非表示時のイベント処理
- (void)keyboardWillHide:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [self.tableView setContentInset:contentInsets];
    [self.tableView setScrollIndicatorInsets:contentInsets];
}

//キーボードの「次へ」をタップした時の処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self pickerNextClicked];
    return YES;
}

//キーボードツールバーの「次へ」or「閉じる」をタップした時の処理
- (void)pickerNextClicked
{
    if (self.nameField.isFirstResponder) {
        //氏名 -> 生年月日へ
        [self.birthdayField becomeFirstResponder];
        return;
    }
    if (self.birthdayField.isFirstResponder) {
        //生年月日 -> 郵便番号へ
        [self.postalcodeField becomeFirstResponder];
        return;
    }
    if (self.postalcodeField.isFirstResponder) {
        //郵便番号 -> 住所へ
        [self.addressField becomeFirstResponder];
        return;
    }
    if (self.addressField.isFirstResponder) {
        //住所 -> 電話番号へ
        [self.telField becomeFirstResponder];
        return;
    }
    if (self.telField.isFirstResponder) {
        //電話番号 -> キーボードを閉じる
        [self.telField resignFirstResponder];
    }
}

//DatePickerの値が変わった時の処理
- (void)datePickerSelectionChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.birthdayField.text = [formatter stringFromDate:datePicker.date];
}

//UITextFieldの入力値が変わった時の処理
- (void)postalcodeTextFieldChanged:(NSNotification*)notification
{
    UITextField *textField = (UITextField *)notification.object;
    
    //郵便番号のみ監視する
    if (textField != self.postalcodeField) {
        return;
    }
    
    //郵便番号が７桁入力された時に住所を検索
    if (textField.text.length == 7) {
        HttpAccess *httpAccess = [HttpAccess new];
        NSMutableDictionary *parameter = [@{@"postalcode":textField.text} mutableCopy];
        NSData *returnData = [httpAccess POST:SEARCH_ADDRESS param:parameter];
        
        NSError *errorObject = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&errorObject];
        
        //JSONオブジェクトのパース失敗時はログを出して終了
        if ([jsonObject isEqual:@"false"]) {
            NSLog(@"JSONObjectパース失敗");
            return;
        }
        
        [self.addressField setText:[jsonObject objectForKey:@"address"]];
        [self pickerNextClicked];
    }
}

//UITextFieldの編集が終わった時の処理
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //入力値保存
    [self saveCurrentInput];
}

//画面の入力値をメンバ変数に保存する
- (void)saveCurrentInput
{
    name       = (self.nameField.text != NULL)? self.nameField.text : name;
    birthday   = (self.birthdayField.text != NULL)? self.birthdayField.text : birthday;
    postalcode = (self.postalcodeField.text != NULL)? self.postalcodeField.text : postalcode;
    address    = (self.addressField.text != NULL)? self.addressField.text : address;
    tel        = (self.telField.text != NULL)? self.telField.text : tel;
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//登録ボタンタップ時の処理
- (IBAction)executeButtonClick:(id)sender
{
    //UITextFieldにフォーカスしたまま登録ボタンを押した場合に備えて
    [self saveCurrentInput];
    
    //入力チェック 空欄があったらエラー
    NSString *errorMessage = [NSString string];
    
    if (name.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:@"お名前を入力してください。\n"];
    }
    if (birthday.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:@"生年月日を選択してください。\n"];
    }
    if (postalcode.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:@"郵便番号を入力してください。\n"];
    }
    if (address.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:@"住所を入力してください。\n"];
    }
    if (tel.length == 0) {
        errorMessage = [errorMessage stringByAppendingString:@"電話番号を入力してください。"];
    }
    
    if (errorMessage.length > 0) {
        //エラーメッセージがあればアラートを表示
        UIAlertView *alertView = [UIAlertView new];
        alertView.title = @"入力エラー";
        alertView.message = errorMessage;
        [alertView addButtonWithTitle:@"OK"];
        [alertView show];
        return;
    } else {
        //エラーメッセージがなければサーバに登録
        PointUser *user = [PointUser new];
        [user loadUserDefaults];
        
        //生年月日をサーバに登録する形式に変換
        NSDate *objBirthday;
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"YYYY年MM月dd日"];
        objBirthday = [formatter dateFromString:birthday];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        //入力値をセット
        user.userName   = name;
        user.birthday   = [formatter stringFromDate:objBirthday];
        user.postalCode = postalcode;
        user.address    = address;
        user.tel        = tel;
        
        //サーバに送信
        PointSystemManager *pointManager = [PointSystemManager new];
        BOOL result = [pointManager updatePointUser:user];
        
        if (result) {
            //登録処理成功時はUserDefaultに保存
            [user saveUserDefaults];
            //ポイントカード画面に遷移
//            [self.navigationController pushViewController:[PointCardViewController new] animated:YES];
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            //登録処理失敗時はアラートを出して終了
            UIAlertView *alertView = [UIAlertView new];
            NSBundle *bundle = [NSBundle mainBundle];
            alertView.title = [bundle localizedStringForKey:@"alert_title_server_error"
                                                      value:nil table:LOCALIZE_FILE];
            alertView.message = [bundle localizedStringForKey:@"alert_message_userinfo_register_error"
                                                        value:nil table:LOCALIZE_FILE];
            [alertView addButtonWithTitle:@"OK"];
            [alertView show];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    observing_ = NO;
}

@end
