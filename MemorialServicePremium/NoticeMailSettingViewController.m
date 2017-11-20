//
//  NoticeMailSettingViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/15.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeMailSettingViewController.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "User.h"
#import "UserDao.h"
#import "Notice.h"
#import "NoticeDao.h"
#import "NoticeMailSelectViewController.h"
#import "InputValidataion.h"
#import "Toast+UIView.h"
#import "Define.h"

@interface NoticeMailSettingViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIScrollView *settingScroll;
@property (weak, nonatomic) IBOutlet UIView *settingScrollView;

@property (weak, nonatomic) IBOutlet UILabel *nameNoticeLabel;
@property (weak, nonatomic) IBOutlet UITableView *noticeTable;

@property (weak, nonatomic) IBOutlet UITextField *yourNameText;

@end

@implementation NoticeMailSettingViewController {
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

    [self.yourNameText setDelegate:self];
    
    //UIScrollViewのコンテンツサイズを設定
    self.settingScroll.contentSize = self.settingScrollView.bounds.size;
    //スクロールバーを表示
    self.settingScroll.showsVerticalScrollIndicator = YES;

/*テーブル編集時の−アイコンが反応しなくなるためコメントアウト
    //背景をクリックしたらキーボードを隠す
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSoftKeyboard)];
    [self.settingScrollView addGestureRecognizer:gestureRecognizer];
*/

    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
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
    self.yourNameText.inputAccessoryView = closeBar;

    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    // キーボード表示時
    [notification addObserver:self selector:@selector(keyboardWillShow:)
						 name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
	[notification addObserver:self selector:@selector(keyboardWillHide:)
						 name: UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.noticeTable setDataSource:self];
    [self.noticeTable setDelegate:self];

    //DBからデータを取得
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //故人情報取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByDeceasedNo:self.deceasedNo];
    //故人様のお名前をラベルに設定
    self.nameNoticeLabel.text = [NSString stringWithFormat:@"%@様　法要通知先", deceased.deceased_name];

    //利用者情報取得
    UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userDao selectUser];
    //利用者のお名前をテキストに設定
    self.yourNameText.text = user.name;
    
    //DBを閉じる
    [memorialDatabase close];

    //テーブルの編集状態を元に戻す
    [self.noticeTable setEditing:NO animated:YES];
    
    //テーブルを読み込み直す
    [self.noticeTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;

    //故人情報の件数を取得
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    int noticeCount = [noticeDao countNoticeByDeceasedNo:self.deceasedNo];

    //DBを閉じる
    [memorialDatabase close];

    return noticeCount;
}

//セルの取得時
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NoticeCell"];
    }

    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;

    //通知先情報を取得
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    Notice *notice = [noticeDao selectNoticeByOffset:(int)indexPath.row andDeceasedNo:self.deceasedNo];

    //データーベースを閉じる
    [memorialDatabase close];
    
    //セルに故人名を設定
    cell.textLabel.text = [NSString stringWithFormat:@"%@様", notice.notice_name];
    cell.detailTextLabel.text = notice.notice_address;

    // ハイライトなし
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

//保存ボタンクリック時
- (IBAction)saveButtonPushed:(id)sender {
    //名前の入力チェックを行う
    
    //正しい場合、利用者情報の名前を上書き保存する
    
    //入力チェック
    NSString *errorMessage = [InputValidataion checkName:self.yourNameText.text];
    if ([errorMessage length] > 0) {
        //エラーメッセージをダイアログ表示
        [self.view makeToast:errorMessage duration:TOAST_DURATION_ERROR position:@"center"];
    } else {
        //DBに登録
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
        if([userDao updateUserName:self.yourNameText.text]) {
            //DBを閉じる
            [memorialDatabase close];
            
            //登録完了をトースト表示
            [self.view makeToast:@"保存が完了しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
        } else {
            //DBを閉じる
            [memorialDatabase close];
            
            //エラーメッセージを表示
            [self.view makeToast:@"保存に失敗しました。\nもう一度保存して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        }
    }

}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//削除ボタンクリック時
- (IBAction)deleteButtonPushed:(id)sender {
NSLog(@"メニューの削除ボタンをタップ");
    if (self.noticeTable.isEditing) {
        [self.noticeTable setEditing:NO animated:YES];
    } else {
        [self.noticeTable setEditing:YES animated:YES];
    }
}
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
NSLog(@"セルの−ボタンをタップ");
    return YES;
}
*/
//削除編集画面の削除ボタンクリック時
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
NSLog(@"セルの削除ボタンをタップ");
    
    //データベースから該当の通知先を削除する
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    
    //選択されたセルのnotice_noを取得する
    Notice *notice = [noticeDao selectNoticeByOffset:(int)indexPath.row andDeceasedNo:self.deceasedNo];
    
    //通知先情報削除実行
    if ([noticeDao deleteNoticeByDeceasedNo:self.deceasedNo andNoticeNo:notice.notice_no] == NO) {
        [self.view makeToast:@"削除に失敗しました。\nもう一度実行して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
        //データーベースを閉じる
        [memorialDatabase close];
        //終了
        return;
    }
    
    //DBを閉じる
    [memorialDatabase close];
    
    //テーブルから該当の通知先を削除する
    [self.noticeTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //テーブルの編集状態を元に戻す
    [self.noticeTable setEditing:NO animated:YES];
}

//通知先を選択するボタンクリック時
- (IBAction)noticeSelectButtonPushed:(id)sender {
    //法要通知先設定画面のインスタンスを生成し、プロパティに故人Noをセットする
    NoticeMailSelectViewController *noticeMailSelectViewController = [[NoticeMailSelectViewController alloc] init];
    //プロパティに故人Noをセット
    noticeMailSelectViewController.deceasedNo = self.deceasedNo;
    
    //法要通知先設定画面に遷移
    [self.navigationController pushViewController:noticeMailSelectViewController animated:NO];
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
        self.settingScroll.contentInset = contentInsets;
        self.settingScroll.scrollIndicatorInsets = contentInsets;
        
        CGPoint pt = [self.settingScroll convertPoint:_textField.frame.origin toView:self.view];
        
        if(CGRectGetMinY(keyboardRect) < pt.y)
        {
            CGPoint scrollPoint = CGPointMake(0.0, pt.y - CGRectGetMinY(keyboardRect) + _textField.frame.size.height);
            [self.settingScroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

//キーボード非表示時
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([_textField isFirstResponder])
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.settingScroll.contentInset = contentInsets;
        self.settingScroll.scrollIndicatorInsets = contentInsets;
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
