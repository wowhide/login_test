//
//  NoticeMailSelectViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/15.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeMailSelectViewController.h"
#import <AddressBook/AddressBook.h>
#import "Notice.h"
#import "NoticeDao.h"
#import "Toast+UIView.h"
#import "Define.h"

@interface NoticeMailSelectViewController () {
    NSMutableArray *_names;
    NSMutableArray *_mails;
    NSMutableArray *_selects;
    NSMutableArray *_notices;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITableView *noticeTable;

@end

@implementation NoticeMailSelectViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _names = [NSMutableArray array];
    _mails = [NSMutableArray array];
    _selects = [NSMutableArray array];
    
    [self.noticeTable setDataSource:self];
    [self.noticeTable setDelegate:self];
    
    [self readAddress];
}

//アドレス読み込み
- (void)readAddress {
    [_names removeAllObjects];
    [_mails removeAllObjects];
    [_selects removeAllObjects];
    
    //登録済みの通知先を取得
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    //通知先を取得
    _notices = [noticeDao selectNoticeByDeceasedNo:self.deceasedNo];
    
    BOOL exists = NO;
    
    //アドレス帳のオブジェクトの取得
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //プライバシー設定
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *message = [NSString stringWithFormat:@"「設定→プライバシー→連絡先→%@」をオンにしてください", appName];
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(book,
            ^(bool granted, CFErrorRef error) {
            if (granted) {
                //メインスレッドのテーブルビューの更新を実行
                [self performSelectorOnMainThread:@selector(tableReload) withObject:nil waitUntilDone:NO];
            } else {
                [self showAlert:@"" text:message];
            }
        });
        return;
    } else if (ABAddressBookGetAuthorizationStatus() !=
               kABAuthorizationStatusAuthorized) {
        [self showAlert:@"" text:message];
        return;
    }
    
    //アドレスのレコードを取得
    CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(book);
    for (int i=0; i<CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);

        //レコードからの名前の取得
        NSString *firstName = (__bridge NSString*)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString*)ABRecordCopyValue(record, kABPersonLastNameProperty);
        if (firstName == nil) firstName = @"";
        if (lastName == nil) lastName = @"";
        NSString *name = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
        
        //レコードからのメールアドレスの取得
        ABMultiValueRef mails = (ABMultiValueRef)ABRecordCopyValue(record,kABPersonEmailProperty);
        if (ABMultiValueGetCount(mails) > 0) {
            for (int j=0; j<ABMultiValueGetCount(mails); j++) {
                
                //メールアドレスの取得
                NSString *mail = (__bridge NSString*)ABMultiValueCopyValueAtIndex(mails, j);
                
                //既に登録済みのメールアドレスの場合、表示しない
                exists = NO;
                for(Notice *notice in _notices) {
                    if ([notice.notice_address isEqualToString:mail]) {
                        exists = YES;
                        break;
                    }
                }
                
                if (exists == NO) {
                    //名前を配列に追加
                    [_names addObject:name];
                    
                    //メールアドレスを配列に追加
                    [_mails addObject:mail];
                    CFRelease((__bridge CFTypeRef)mail);
                    
                    //switchのOFFを配列に追加
                    [_selects addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }
        CFRelease(mails);
        if (firstName != nil) CFRelease((__bridge CFTypeRef)firstName);
        if (firstName != nil) CFRelease((__bridge CFTypeRef)lastName);
    }
    CFRelease(book);
    CFRelease(records);
    
    //テーブルビューの更新
    [self.noticeTable reloadData];
}



//テーブルをリロード
- (void)tableReload{
    [self.noticeTable reloadData];
    [self readAddress];
}

//アラートの表示
- (void)showAlert:(NSString*)title text:(NSString*)text {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:text delegate:nil cancelButtonTitle:@"はい" otherButtonTitles:nil];
    [alert show];
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//法要通知先追加ボタンクリック時
- (IBAction)noticeAddPushed:(id)sender {
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    [memorialDatabase beginTransaction];
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    
    //onFlg
    BOOL onFlg = NO;
    //スイッチがONになっている名前・メールアドレスをDBに保存する
    for (int i=0; i<_selects.count; i++) {
        if ([[_selects objectAtIndex:i] boolValue] == YES) {
            onFlg = YES;
//            NSLog(@"ON index:%d", i);
            if ([noticeDao insertNotice:self.deceasedNo andName:[_names objectAtIndex:i] andMail:[_mails objectAtIndex:i]] == NO) {
                [self.view makeToast:@"削除に失敗しました。\nもう一度実行して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
                //データーベースをロールバック
                [memorialDatabase rollback];
                //データーベースを閉じる
                [memorialDatabase close];
                //終了
                return;
            }
        }
    }
    
    //1件も選択されていない場合は、エラーメッセージを表示
    if (onFlg == NO) {
        [self.view makeToast:@"通知先が選択されていません。" duration:TOAST_DURATION_ERROR position:@"center"];
        //DBを閉じる
        [memorialDatabase close];
        //終了
        return;
    }
    
    //コミット
    [memorialDatabase commit];
    //DBを閉じる
    [memorialDatabase close];
    
    //追加完了をトースト表示
    [self.view makeToast:@"通知先を追加しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
    
    //1秒後前の上の階層に戻る
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popView) userInfo:nil repeats:NO];
}

- (void)popView
{
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//セルの数取得時
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _names.count;
}

//セルの取得時
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //テーブルのセルの生成
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NoticeCell"];
    }
 
    //セルに故人名を設定
    cell.textLabel.text = [_names objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_mails objectAtIndex:indexPath.row];

    //スイッチを作成する
    UISwitch *selectSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    selectSwitch.tag = indexPath.row;
    
    //スイッチタップ時のイベントを設定
    [selectSwitch addTarget:self action:@selector(tapSwich:) forControlEvents:UIControlEventTouchUpInside];
    
    //セルのaccessoryViewにスイッチを設定
    cell.accessoryView = selectSwitch;
    
    // ハイライトなし
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//スイッチタップ時
-(void)tapSwich:(id)sender {
    UISwitch *selectSwitch = (UISwitch *)sender;
    if (selectSwitch.on == YES) {
        [_selects replaceObjectAtIndex:selectSwitch.tag withObject:[NSNumber numberWithBool:YES]];
    } else {
        [_selects replaceObjectAtIndex:selectSwitch.tag withObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
