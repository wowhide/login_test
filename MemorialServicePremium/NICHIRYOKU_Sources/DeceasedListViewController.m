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
#import "User.h"
#import "UserDao.h"
#import "Notice.h"
#import "NoticeDao.h"
#import "IndicatorWindow.h"


@interface DeceasedListViewController () {
    NSString *_morticianUrl;
    int deceasedCount;
    int downloadCount;
    NSString *memberId;
    NSString *appliId;
    NSInteger deceasedUpdateCount;
    NSInteger devicedeceasedUpdateCount;
    BOOL transfer_download;
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
    self.tabBar_icon.image = [[UIImage imageNamed:@"tab_notice_setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //タブビュータイトル
    //self.tabBar_icon.title = @"通知設定";
    self.tabBar_icon.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    //デリゲード
    self.tabbar.delegate = self;
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //背景色を設定
    self.view.backgroundColor = [UIColor colorWithRed:TITLE_BG_COLOR_RED green:TITLE_BG_COLOR_GREEN blue:TITLE_BG_COLOR_BLUE alpha:1.0];
    
    
    //QRコード読み込んでいるか
    transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
    if (transfer_download) {
            //ユーザーデフォルト
            memberId                    = [defaults stringForKey:KEY_MEMBER_USER_ID];           // 会員番号
            appliId                     = [defaults stringForKey:KEY_MEMBER_APPLI_ID];          // アプリID
            devicedeceasedUpdateCount   = [defaults integerForKey:KEY_DECEASED_UPDATE_COUNT];   // 故人情報更新カウント
        
            //サーバーから故人アップデートカウント数を取得
            HttpAccess *httpAccess = [HttpAccess new];
        
            NSMutableDictionary *parameter = [@{@"appli_id":appliId} mutableCopy];
        
            NSData *returnData = [httpAccess POST:GET_DECEASED_UPDATE_COUNT param:parameter];
        
            NSString *deceasedUpdateCountString= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            //NSInteger型に変換
            deceasedUpdateCount = [deceasedUpdateCountString intValue];
        
            //    NSLog(@"update%ld",devicedeceasedUpdateCount);
        
            //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
            Reachability *curReach = [Reachability reachabilityForInternetConnection];
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if (netStatus == NotReachable) {
                //圏外のときの処理
                //接続できない場合、エラーメッセージをダイアログ表示
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"インターネットに未接続のため、更新された情報は反映されません" preferredStyle:UIAlertControllerStyleAlert];
                
                // addActionした順に左から右にボタンが配置されます
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // OKボタンが押された時の処理
                    [self okButtonPushed];
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                //終了
                return;
            }
        
            //サーバ上に更新情報がある場合、当該データをダウンロード
            NSLog(@"サーバー更新カウント:%@",[NSString stringWithFormat:@"%ld", (long)deceasedUpdateCount]);
            NSLog(@"デバイス更新カウント:%@",[NSString stringWithFormat:@"%ld", (long)devicedeceasedUpdateCount]);
        
            if (devicedeceasedUpdateCount < deceasedUpdateCount
                ||(deceasedUpdateCount == 1 && devicedeceasedUpdateCount >1)
                ) {
                
                [defaults setInteger:deceasedUpdateCount forKey:KEY_DECEASED_UPDATE_COUNT];         // ユーザーデフォルトdeceased_update_count_更新
                [defaults synchronize];
                
                //インジケーター開始
                [IndicatorWindow openWindow];
                
                //別のスレッドでファイル読み込みをキューに加える
                NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                    initWithTarget:self
                                                    selector:@selector(downloadData:)
                                                    object:nil];
                NSOperationQueue *queue = [NSOperationQueue new];
                [queue addOperation:operation];
                
            }
    }
    
 
    //インジケーターを閉じる
//    [IndicatorWindow closeWindow];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 選択時のカラー（アイコン＋テキスト）
    self.tabbar.tintColor = [UIColor colorWithRed:0.706 green:0.706 blue:0.706 alpha:1.0];
    
    [self.deceasedTable setDataSource:self];
    [self.deceasedTable setDelegate:self];
    
    
    //テーブルを読み込み直す
    [self.deceasedTable reloadData];
    
}

-(void)okButtonPushed{
    
}

- (void)viewDidAppear:(BOOL)animated{
    
}


- (void)downloadData:(NSString *)accessKey
{
    //リクエスト先を指定する
    NSString *datatakein_urlAsString = READ_TRANSFER_DATA;
    
    NSURL *datatakein_url = [NSURL URLWithString:datatakein_urlAsString];
    
    //POSTメソッドのHTTPリクエストを生成する
    NSMutableURLRequest *datatakein_urlRequest = [NSMutableURLRequest requestWithURL:datatakein_url];
    [datatakein_urlRequest setHTTPMethod:@"POST"];
    
    //パラメータを付与
    NSString *datatakein_body = [NSString stringWithFormat:@"datakey=%@&certification=key",appliId];
    
    [datatakein_urlRequest setHTTPBody:[datatakein_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *datatakein_response;
    NSError *datatakein_error = nil;
    
    //HTTP同期通信を実行
    NSData *dataTakeInJsonData = [NSURLConnection sendSynchronousRequest:datatakein_urlRequest returningResponse:&datatakein_response error:&datatakein_error];
    
    //データを取得
    if (dataTakeInJsonData && datatakein_response.statusCode == 200) {
        
        //データが存在しない場合、エラーメッセージを表示して終了
        if ((dataTakeInJsonData.length > 0) == NO ) {
            //メインスレッドのインディケーターを閉じるを実行
//            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データを正しく取得できませんでした。" waitUntilDone:NO];
            return;
        }
        
        //JSONのデータを読み込む
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:dataTakeInJsonData options:NSJSONReadingAllowFragments error:&datatakein_error];
        
        //故人情報取得
        NSDictionary *jsonDeceasedObject = [jsonObject objectForKey:@"deceased"];
        //NSLog(@"jsonDeceasedObject:%@",[jsonDeceasedObject description]);
        
        //通知先情報取得
        //        NSDictionary *jsonNoticeObject = [jsonObject objectForKey:@"notice"];
        //NSLog(@"jsonNoticeObject:%@",[jsonNoticeObject description]);
        
        //DBに接続
        DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
        FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
        //トランザクションを開始する
        [memorialDatabase beginTransaction];
        
        //故人情報を削除する
        DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
        //写真が存在する場合、削除する
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        NSMutableArray *tempDeceaseds = [deceasedDao selectDeceased];
        for (Deceased *deceased in tempDeceaseds) {
            if (deceased.deceased_photo_path.length > 0) {
                //保存先パス取得
                NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, deceased.deceased_photo_path];
                //ファイルの存在チェック
                if ([fileManager fileExistsAtPath:dataPath]) {
                    //存在する場合、削除
                    [fileManager removeItemAtPath:dataPath error:NULL];
                }
            }
        }
        if (![deceasedDao deleteDeceasedAll]) {
            //DBをロールバック
            [memorialDatabase rollback];
            //DBを閉じる
            [memorialDatabase close];
            //メインスレッドのインディケーターを閉じるを実行
            [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"ダウンロードに失敗しました。\nもう一度ダウンロードして下さい。" waitUntilDone:NO];
            return;
        }
        
        //故人情報を保存
        NSMutableArray *deceaseds = [NSMutableArray array];
        for (NSDictionary *dObj in jsonDeceasedObject)
        {
            Deceased *deceased = [[Deceased alloc] init];
            deceased.deceased_no = [[dObj objectForKey:@"deceased_no"] intValue];
            deceased.deceased_id = [dObj objectForKey:@"deceased_id"];
            deceased.qr_flg = [[dObj objectForKey:@"qr_flg"] intValue];
            deceased.deceased_name = [dObj objectForKey:@"deceased_name"];
            deceased.deceased_birthday = [dObj objectForKey:@"deceased_birthday"];
            deceased.deceased_deathday = [dObj objectForKey:@"deceased_deathday"];
            deceased.kyonen_gyonen_flg = [[dObj objectForKey:@"kyonen_gyonen_flg"] intValue];
            deceased.death_age = [[dObj objectForKey:@"death_age"] intValue];
            deceased.deceased_photo_path = [dObj objectForKey:@"deceased_photo_path"];
            deceased.entry_datetime = [dObj objectForKey:@"entry_datetime"];
            deceased.timestamp = [dObj objectForKey:@"timestamp"];
            if (![deceasedDao insertDeceasedTakeIn:deceased]) {
                //DBをロールバック
                [memorialDatabase rollback];
                //DBを閉じる
                [memorialDatabase close];
                //メインスレッドのインディケーターを閉じるを実行
                [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"ダウンロードに失敗しました。\nもう一度ダウンロードして下さい。" waitUntilDone:NO];
                return;
            }
            [deceaseds addObject:deceased];
            
            //デバイストークンと故人IDをサーバーのDBに保存する
            //デバイストークンを取得
            NSString *strToken = [defaults stringForKey:KEY_DEVICE_TOKEN];
            
            //リクエスト先を指定する
            NSString *deviceToken_urlAsString = SAVE_DEVICE_TOKEN_AND_DECEASED_ID;
            NSURL *deviceToken_url = [NSURL URLWithString:deviceToken_urlAsString];
            //POSTメソッドのHTTPリクエストを生成する
            NSMutableURLRequest *deviceToken_urlRequest = [NSMutableURLRequest requestWithURL:deviceToken_url];
            [deviceToken_urlRequest setHTTPMethod:@"POST"];
            //パラメータを付与
            NSString *deviceToken_body = [NSString stringWithFormat:@"device_token=%@&deceased_id=%@",strToken, deceased.deceased_id];
            [deviceToken_urlRequest setHTTPBody:[deviceToken_body dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSHTTPURLResponse *deviceToken_response;
            NSError *deviceToken_error = nil;
            
            //HTTP同期通信を実行
            NSData *deviceTokenResult = [NSURLConnection sendSynchronousRequest:deviceToken_urlRequest returningResponse:&deviceToken_response error:&deviceToken_error];
            
            //デバイストークンをサーバーに保存
            if (deviceTokenResult && deviceToken_response.statusCode == 200) {
                //成功
            } else {
                //失敗
            }
            
            
        }
        
        //DBをコミット
        [memorialDatabase commit];
        //DBを閉じる
        [memorialDatabase close];
        
        //ダウンロードカウントをリセット
                downloadCount = 0;
                for (Deceased *deceased in deceaseds) {
                    //画像ファイルが存在する場合、ダウンロードする
                    if (deceased.deceased_photo_path.length > 0) {
                        //ダウンロードカウントをインクリメント
                        downloadCount++;
                        NSLog(@"downloadCount:%d",downloadCount);
                    }
                }
        
        for (Deceased *deceased in deceaseds) {
            //画像ファイルが存在する場合、ダウンロードする
            if (deceased.deceased_photo_path.length > 0) {
                
                if(deceased.qr_flg == 1){
                    //故人写真を取得
                    //読み込むファイルの URL を作成
                    NSString *downloadphoto_urlAsString = [NSString stringWithFormat:[DOWNLOAD_QR_PHOTO stringByAppendingString:@"?appli_id=%@&deceased_identification=%@&filename=%@"], appliId, deceased.deceased_id,deceased.deceased_photo_path];
                    
                    NSURL *downloadphoto_url = [NSURL URLWithString:downloadphoto_urlAsString];
                    //引数の生成
                    NSArray *loadImageArgArray = [NSArray arrayWithObjects:downloadphoto_url, deceased.deceased_id, nil];
                    
                    
                    NSLog(@"This deceased.deceased_id:%@",deceased.deceased_id);

                    //メインスレッドのファイル読み込みを実行
                    [self performSelectorOnMainThread:@selector(loadImage:) withObject:loadImageArgArray waitUntilDone:NO];
                    
                }
                
            }
        }
        
        //テーブルを読み直し
        [self performSelectorOnMainThread:@selector(reloadTable:) withObject:@"" waitUntilDone:NO];
        
        [defaults setInteger:deceasedUpdateCount forKey:KEY_DECEASED_UPDATE_COUNT];         // ユーザーデフォルトdeceased_update_count_更新
        [defaults synchronize];
        

        
    } else {
        //メインスレッドのインディケーターを閉じるを実行
        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データ更新に失敗しました。" waitUntilDone:NO];
    }
}

//画像ファイル読み込み
- (void)loadImage:(NSArray *)loardImageArgArray
{
    //引数を取得
    NSURL *downloadphoto_url = loardImageArgArray[0];
    NSString *deceasedPhotoPath = loardImageArgArray[1];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:downloadphoto_url];
    //引数の生成
    NSArray *saveImageArgArray = [NSArray arrayWithObjects:imageData, deceasedPhotoPath, nil];
    //画像ファイルを保存
    [self saveImage:saveImageArgArray];
}

//ローカルにデータを保存
- (void)saveImage:(NSArray *)saveImageArgArray
{
    //引数を取得
    NSData *imageData = saveImageArgArray[0];
    NSString *saveFileName = saveImageArgArray[1];
    
    //保存先パス生成
    NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, saveFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    if (success) {
        imageData = [NSData dataWithContentsOfFile:dataPath];
    } else {
        [imageData writeToFile:dataPath atomically:YES];
    }
    
    //ダウンロードカウンタから-1
    downloadCount--;
    //ダウンロードカウンタが0になったらインディケーターを閉じて画面遷移
    if (downloadCount == 0) {
        
        //上の階層に戻る
//        self.navigationController.tabBarController.selectedIndex = 0;
    }
}

//テーブルの読み直し
- (void)reloadTable:(NSString *)message
{
    //テーブルを読み込み直す
    [self.deceasedTable reloadData];
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}


//エラーメッセージを表示してインジケーターを閉じる
- (void)closeIndicatorAndErrorMessage:(NSString *)errorMessage
{
    [IndicatorWindow closeWindow];
}

//インディケーターを閉じる
- (void)closeIndicator
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
    
    //画面操作を許可する
    //    self.view.userInteractionEnabled=YES;
    //    self.toolBar.userInteractionEnabled = YES;
    //    self.takeinScroll.userInteractionEnabled = YES;
    //    self.takeinScrollView.userInteractionEnabled = YES;
    
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
    
//    NSLog(@"This deceased.deceased_id:%@",deceased.deceased_id);

    
    //データーベースを閉じる
    [memorialDatabase close];
    
    //矢印を表示
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //インジケーターを閉じる
        [IndicatorWindow closeWindow];
        //接続できない場合、エラーメッセージをダイアログ表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"ネットワークに接続できる環境で使用して下さい。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
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
    [self.navigationController pushViewController:deceasedInfoReadViewController animated:NO];
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
//- (IBAction)qrButtonPushed:(id)sender {
//    //故人様が10件以上の場合、トーストで警告を表示する
//    if (deceasedCount >= 10) {
//        [self.view makeToast:@"登録できる故人様は10名までです。" duration:TOAST_DURATION_ERROR position:@"center"];
//        return;
//    }
//    
//    //インターネットの接続状態を取得
//    //インターネットに接続できるかチェック、接続できない場合、エラーダイアログ表示
//    Reachability *curReach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus netStatus = [curReach currentReachabilityStatus];
//    if (netStatus == NotReachable) {
//        //接続できない場合
//        [self.view makeToast:@"ネットワークに接続できる環境で読み込んで下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
//        return;
//    }
//    
//    //インターネットに接続可能な場合、QR読込画面を表示
//    QrCodeReadViewController *qrCodeReadViewController = [[QrCodeReadViewController alloc] init];
//    qrCodeReadViewController.delegate = self;
//    qrCodeReadViewController.fromView = QR_READ_VIEW_FROM_DECEASED_LIST;
//    [self presentViewController:qrCodeReadViewController animated:YES completion:nil];
//    
//}

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
    
    [self.navigationController pushViewController:deceasedInfoEntryViewController animated:NO];
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
