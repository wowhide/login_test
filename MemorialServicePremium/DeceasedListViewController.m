//
//  DeceasedListViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/09.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//


#import "DeceasedListViewController.h"
#import "Reachability.h"
#import "Toast+UIView.h"
#import "DatabaseHelper.h"
#import "DeceasedDao.h"
#import "Deceased.h"
#import "DeceasedInfoReadViewController.h"
#import "DeceasedInfoEntryViewController.h"
#import "QrCodeReadViewController.h"
#import "NoticeSettingViewController.h"
#import "Define.h"
#import "TopMenuViewController.h"
#import "HttpAccess.h"
#import "PointUser.h"
#import "User.h"
#import "UserDao.h"
#import "Notice.h"
#import "NoticeDao.h"
#import "IndicatorWindow.h"


@interface DeceasedListViewController () {
    NSString *_morticianUrl;
    int deceasedCount;
    NSString *userid;
    
    
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UILabel *morticianLabel;
@property (weak, nonatomic) IBOutlet UITableView *deceasedTable;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar_icon;

@end

//DeceasedListViewControllerの実装
@implementation DeceasedListViewController

NSUserDefaults *defaults;

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
    
    //タブビューのアイコン
    self.tabBar_icon.image = [UIImage imageNamed:@"tab_notice_setting"];
    //タブビュータイトル
    self.tabBar_icon.title = @"通知設定";
    //デリゲード
    self.tabbar.delegate = self;

    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];

    //背景色を設定
    self.view.backgroundColor = [UIColor colorWithRed:TITLE_BG_COLOR_RED green:TITLE_BG_COLOR_GREEN blue:TITLE_BG_COLOR_BLUE alpha:1.0];
    
    userid = [defaults stringForKey:USER_ID];  // USER_IDの内容をNSString型として取得
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 選択時のカラー（アイコン＋テキスト）
    self.tabbar.tintColor = [UIColor colorWithRed:0.706 green:0.706 blue:0.706 alpha:1.0];

    [self.deceasedTable setDataSource:self];
    [self.deceasedTable setDelegate:self];

    //葬儀社情報が存在する場合、葬儀社名のラベルに葬儀社名を設定
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //QRコードから読み込んだ故人様情報が存在するかチェック
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    BOOL boolQrDeceased = deceasedDao.existenceQrDeceased;

    //DBを閉じる
    [memorialDatabase close];
    
    if (boolQrDeceased) {
        //葬儀社情報が存在する場合、葬儀社名のラベルに葬儀社名を設定
        self.morticianLabel.text = MORTICIAN_NAME;
        self.morticianLabel.tag = 1;
        self.morticianLabel.userInteractionEnabled = YES;
        
        CGSize maxSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        CGSize fitSize = [self.morticianLabel sizeThatFits:maxSize];
        
        int diff = fitSize.width - self.morticianLabel.frame.size.width;
        self.morticianLabel.frame = CGRectMake(self.morticianLabel.frame.origin.x - diff,
                                               self.morticianLabel.frame.origin.y,
                                               fitSize.width,
                                               self.morticianLabel.frame.size.height);
        
        //URLをインスタンス変数に設定
        _morticianUrl = MORTICIAN_URL;
        
        //表示する
        self.morticianLabel.hidden = NO;
    } else {
        //葬儀社情報が存在しない場合、葬儀社名ラベルを非表示にする
        self.morticianLabel.hidden = YES;
    }

    //テーブルを読み込み直す
    [self.deceasedTable reloadData];
    
    
    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //圏外のときの処理
        
        
        
        //終了
        return;
        
    }
    
    
    //インジケーター開始
//    [IndicatorWindow openWindow];
    
    //別のスレッドでファイル読み込みをキューに加える
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(uploadData)
                                        object:nil];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];

}


- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)uploadData
{
    //DBのデータを取得
    //データベースに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //利用者
    UserDao *userDao = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userDao selectUser];
    //故人
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    NSMutableArray *deceaseds = [deceasedDao selectDeceased];
    //通知先
    NoticeDao *noticeDao = [NoticeDao noticeDaoWithMemorialDatabase:memorialDatabase];
    NSMutableArray *notices = [noticeDao selectNotice];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    //取得したデータをJSON形式に変換
    NSError *error;
    

    
    //利用者
    NSMutableDictionary *userNsmd = [NSMutableDictionary dictionary];
    [userNsmd setValue:user.mail_address forKey:@"mail_address"];
    [userNsmd setValue:user.name forKey:@"name"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_month_deathday_before] forKey:@"notice_month_deathday_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_month_deathday] forKey:@"notice_month_deathday"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_deathday_1week_before] forKey:@"notice_deathday_1week_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_deathday_before] forKey:@"notice_deathday_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_deathday] forKey:@"notice_deathday"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_memorial_3month_before] forKey:@"notice_memorial_3month_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_memorial_1month_before] forKey:@"notice_memorial_1month_before"];
    [userNsmd setValue:[NSString stringWithFormat:@"%d", user.notice_memorial_1week_before] forKey:@"notice_memorial_1week_before"];
    [userNsmd setValue:userid forKey:@"point_user_id"];
    [userNsmd setValue:user.notice_time forKey:@"notice_time"];
    [userNsmd setValue:user.install_datetime forKey:@"install_datetime"];
    [userNsmd setValue:user.entry_datetime forKey:@"entry_datetime"];
    NSData *userJson =
    [NSJSONSerialization dataWithJSONObject:userNsmd
                                    options:kNilOptions error:&error];
    
    //故人
    NSMutableArray *deceasedsNsma = [[NSMutableArray alloc] init];
    for (Deceased *deceased in deceaseds) {
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
    }
    NSData *deceasedJson =
    [NSJSONSerialization dataWithJSONObject:deceasedsNsma
                                    options:kNilOptions error:&error];
    
    //通知先
    NSMutableArray *noticesNsma = [[NSMutableArray alloc] init];
    for (Notice *notice in notices) {
        NSMutableDictionary *noticeNsmd = [NSMutableDictionary dictionary];
        [noticeNsmd setValue:[NSString stringWithFormat:@"%d", notice.deceased_no] forKey:@"deceased_no"];
        [noticeNsmd setValue:[NSString stringWithFormat:@"%d", notice.notice_no] forKey:@"notice_no"];
        [noticeNsmd setValue:notice.notice_name forKey:@"notice_name"];
        [noticeNsmd setValue:notice.notice_address forKey:@"notice_address"];
        [noticeNsmd setValue:notice.entry_datetime forKey:@"entry_datetime"];
        [noticesNsma addObject:noticeNsmd];
    }
    NSData *noticeJson =
    [NSJSONSerialization dataWithJSONObject:noticesNsma
                                    options:kNilOptions error:&error];
    
    //DBデーターアップロード
    //リクエスト先を指定する
//    NSString *saveuserdata_urlAsString = SAVE_TRANSFER_DATA;
//    NSString *saveuserdata_urlAsString = @"http://ms-dev.wow-d.net/cooperation/testsavetransferdata";
    
    NSString *saveuserdata_urlAsString = UPDATE_DECEASED_ID;

    NSURL *saveuserdata_url = [NSURL URLWithString:saveuserdata_urlAsString];
    
    //POSTメソッドのHTTPリクエストを生成する
    NSMutableURLRequest *saveuserdata_urlRequest = [NSMutableURLRequest requestWithURL:saveuserdata_url];
    [saveuserdata_urlRequest setHTTPMethod:@"POST"];
    //パラメータを付与
    NSString *saveuserdata_body = [NSString stringWithFormat:@"user=%@&deceased=%@&notice=%@&certification=key&datakey=%@",
                                   [[NSString alloc] initWithData:userJson encoding:NSUTF8StringEncoding],
                                   [[NSString alloc] initWithData:deceasedJson encoding:NSUTF8StringEncoding],
                                   [[NSString alloc] initWithData:noticeJson encoding:NSUTF8StringEncoding],
                                   userid
                                   ];
    [saveuserdata_urlRequest setHTTPBody:[saveuserdata_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *saveuserdata_response;
    NSError *saveuserdata_error = nil;
    
    //HTTP同期通信を実行
    NSData *saveUserDataResult = [NSURLConnection sendSynchronousRequest:saveuserdata_urlRequest returningResponse:&saveuserdata_response error:&saveuserdata_error];
    
//    //故人情報保存結果(データーキー)を取得
//    if (saveUserDataResult && saveuserdata_response.statusCode == 200) {
//        _dataKey = [[NSString alloc] initWithData:saveUserDataResult encoding:NSUTF8StringEncoding];
//        //        NSLog(@"dataKey=%@", _dataKey);
//        if (_dataKey.length == 0) {
//            //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
//            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
//            return;
//        }
//    } else {
//        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
//        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
//        return;
//    }
    
    NSLog(@"saveUserDataResult=%@", saveUserDataResult);
    
    
    //写真アップロード
    for (Deceased *deceased in deceaseds) {
        //画像ファイル名が設定されているか
        
        if (deceased.deceased_photo_path.length > 0) {
            //設定されている場合、ファイルが存在するか
            //ファイルパス取得
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, deceased.deceased_photo_path];
            // ファイルマネージャを作成
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if ([fileManager fileExistsAtPath:filePath]) {
                //ファイルが存在する場合、ファイルをアップロードする
//                NSString *savephoto_urlAsString = UP_PHOTO;
//                NSString *savephoto_urlAsString = @"http://ms-dev.wow-d.net/cooperation/upphoto";
                NSString *savephoto_urlAsString = UPDATE_DECEASED_PHOTO;
                
                NSURL *savephoto_url = [NSURL URLWithString:savephoto_urlAsString];
                
                //POSTメソッドのHTTPリクエストを生成する
                NSMutableURLRequest *savephoto_urlRequest = [NSMutableURLRequest requestWithURL:savephoto_url];
                
                //リクエストヘッダの作成
                NSString *stringBoundary = @"Ns794C3Hi4DLrPuR";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
                [savephoto_urlRequest setHTTPMethod:@"POST"];
                [savephoto_urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
                
                //POSTするデータ
                NSMutableData *postBody = [NSMutableData data];
                
                //データーキーを設定
                [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"datakey\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postBody appendData:[userid dataUsingEncoding:NSUTF8StringEncoding]];
                
                //写真を設定
                NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, deceased.deceased_photo_path];
                UIImage *image= [[UIImage alloc] initWithContentsOfFile:dataPath];
                NSData* imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)];
                [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@\"\r\n", deceased.deceased_photo_path] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:imageData];
                [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [savephoto_urlRequest setHTTPBody:postBody];
                
                NSHTTPURLResponse *savephoto_response;
                NSError *savephoto_error = nil;
                
                //HTTP同期通信を実行
                NSData *savePhotoResult = [NSURLConnection sendSynchronousRequest:savephoto_urlRequest returningResponse:&savephoto_response error:&savephoto_error];
                
                //写真アップロード結果を取得
                NSString *photoUpResult;
                if (savePhotoResult && savephoto_response.statusCode == 200) {
                    photoUpResult = [[NSString alloc] initWithData:savePhotoResult encoding:NSUTF8StringEncoding];
                    if ([photoUpResult isEqualToString:@"NO"]) {
                        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
//                        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
                        return;
                    }
                } else {
                    //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
//                    [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
                    return;
                }
            }
        }
    }
    
    //インジケーターを閉じる
//    [IndicatorWindow closeWindow];

}


//エラーメッセージを表示してインジケーターを閉じる
- (void)closeIndicatorAndErrorMessage:(NSString *)errorMessage
{
    [IndicatorWindow closeWindow];
    

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //故人情報の件数を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    deceasedCount = [deceasedDao countDeceased];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    return deceasedCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeceasedCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeceasedCell"];
    }
    
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //故人情報を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByOffset:(int)indexPath.row];
    
    //セルに故人名を設定
    cell.textLabel.text = [NSString stringWithFormat:@"%@　様", deceased.deceased_name];

    //故人一覧をDBに格納
    HttpAccess *httpAccess = [HttpAccess new];
    NSString *parameter = deceased.deceased_name;
    NSString *parameter2 = deceased.deceased_birthday;
    NSString *parameter3 = deceased.deceased_deathday;
    NSString *parameter4 = deceased.deceased_photo_path;
    
    [httpAccess getdeceasename:DESEASE_LIST_INSERT param:userid params:parameter params:parameter2 params:parameter3 params:parameter4];

    NSLog(@"家系図使用名前テーブルnewItemは%@", parameter);
    NSLog(@"家系図ID%@",userid);

    //データーベースを閉じる
    [memorialDatabase close];
    
    //矢印を表示
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //故人情報画面のインスタンスを生成し、プロパティに故人情報をセットする
    DeceasedInfoReadViewController *deceasedInfoReadViewController = [[DeceasedInfoReadViewController alloc] init];
    
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //故人情報を取得
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    Deceased *deceased = [deceasedDao selectDeceasedByOffset:(int)indexPath.row];
    //プロパティに故人情報をセット
    deceasedInfoReadViewController.deceasedNo = deceased.deceased_no;
    //データーベースを閉じる
    [memorialDatabase close];
    
    //テーブルの選択状態を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //pushViewControllerしたとき、tabBarも一緒に隠す
    deceasedInfoReadViewController.hidesBottomBarWhenPushed = YES;
    
    //故人情報画面に遷移
    [self.navigationController pushViewController:deceasedInfoReadViewController animated:YES];
}

//画面のタッチイベント
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    if (touch.view.tag == self.morticianLabel.tag) {
//        //URLをタッチした場合
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_morticianUrl]];
//    }
}

//タブバーアイコンクリック時
- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item{
    
    //切り替えに応じた処理
    if (item.tag == 0) {
        
    }else if (item.tag == 1) {
        //通知設定画面のインスタンスを生成
        NoticeSettingViewController *noticesettingViewController = [NoticeSettingViewController new];
        
        //通知設定画面に遷移
        [self.navigationController pushViewController:noticesettingViewController animated:NO];
    }
}

//QR読込ボタンクリック時
- (IBAction)qrButtonPushed:(id)sender {
    //故人様が10件以上の場合、トーストで警告を表示する
    if (deceasedCount >= 10) {
        [self.view makeToast:@"登録できる故人様は10名までです。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

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
    [self presentViewController:qrCodeReadViewController animated:YES completion:nil];

}

//QR読込画面が閉じた後に呼ばれるデリゲート
- (void)hideQrCodeReadView:(BOOL)readBool
{
//    NSLog(@"DeceasedListViewController hideQrCodeReadView");
    
    if (readBool) {
        //テーブルを読み込み直す
        [self.deceasedTable reloadData];
    }

    //QR読み込み画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

//故人様追加ボタンクリック時
- (IBAction)deceasedAddPushed:(id)sender {
    //故人様が10件以上の場合、トーストで警告を表示する
    if (deceasedCount >= 10) {
        [self.view makeToast:@"登録できる故人様は10名までです。" duration:TOAST_DURATION_ERROR position:@"center"];
        return;
    }

    DeceasedInfoEntryViewController *deceasedInfoEntryViewController = [[DeceasedInfoEntryViewController alloc] init];
        
    [self.navigationController pushViewController:deceasedInfoEntryViewController animated:YES];
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{    
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
