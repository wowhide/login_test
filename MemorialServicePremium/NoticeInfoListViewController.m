//
//  NoticeInfoListViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2014/05/02.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "NoticeInfoListViewController.h"
#import "Reachability.h"
#import "Common.h"
#import "Define.h"
#import "IndicatorWindow.h"
#import "NoticeInfo.h"
#import "NoticeInfoViewController.h"
#import "Toast+UIView.h"

@interface NoticeInfoListViewController () {
    NSMutableArray *_noticeInfos;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *noticeTable;

@end

@implementation NoticeInfoListViewController

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
    
    //インジケーター開始
    [IndicatorWindow openWindow];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];

    _noticeInfos = [NSMutableArray array];
    
    [self.noticeTable setDataSource:self];
    [self.noticeTable setDelegate:self];
    
    [self readNoticeInfo];
    
    //「通知設定」が不許可になっているか確認
    NSUInteger types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    
    // 不許可の場合
    if (types == UIUserNotificationTypeNone) {
        
        //アラートメッセージ作成
        NSString *alertMessage = @"\n最新の情報を受け取っていただく為に、通知設定を許可にしてください。よろしいですか。";
        NSString *str = [NSString stringWithFormat:@"%@",alertMessage];
        
        //アラートビュー表示
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.delegate = self;
        alert.title = @"通知許可のお願い";
        alert.message = str;
        [alert addButtonWithTitle:@"はい"];
        [alert addButtonWithTitle:@"いいえ"];
        [alert show];
        
    }

}


// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSURL *url;
    switch (buttonIndex) {
        case 0:
            //「はい」ボタン押下時
            //設定画面に遷移
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        case 1:
            //「いいえ」ボタン押下時
            //アラートを消す
            ;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//お知らせ読み込み
- (void)readNoticeInfo {
    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //インジケーターを閉じる
        [self closeIndicator];
        //接続できない場合、エラーメッセージをダイアログ表示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"インターネットに接続できる環境でご利用ください。" preferredStyle:UIAlertControllerStyleAlert];
        
        // addActionした順に左から右にボタンが配置されます
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // OKボタンが押された時の処理
            [self okButtonPushed];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    [_noticeInfos removeAllObjects];
    
    //別スレッドでお知らせ情報取得を実行する
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(getNoticeInfo)
                                        object:nil];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];
}

-(void)okButtonPushed{
    
}

- (void)getNoticeInfo
{
    //デバイストークンを取得
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefault stringForKey:KEY_DEVICE_TOKEN];
    
    //サーバーからお知らせ情報を取得
    //リクエスト先を指定する
    NSString *noticeInfoList_urlAsString = GET_NOTICE_INFO_DELIVERED_TOKEN;
    NSURL *noticeInfoList_url = [NSURL URLWithString:noticeInfoList_urlAsString];
    
    //POSTメソッドのHTTPリクエストを生成する
    NSMutableURLRequest *noticeInfoList_urlRequest = [NSMutableURLRequest requestWithURL:noticeInfoList_url];
    [noticeInfoList_urlRequest setHTTPMethod:@"POST"];
    
    //パラメータを付与
    NSString *noticeInfo_body = [NSString stringWithFormat:@"deviceToken=%@", deviceToken];
    [noticeInfoList_urlRequest setHTTPBody:[noticeInfo_body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *noticeInfoList_response;
    NSError *noticeInfoList_error = nil;
    
    //HTTP同期通信を実行
    NSData *noticeInfoListJsonData = [NSURLConnection sendSynchronousRequest:noticeInfoList_urlRequest returningResponse:&noticeInfoList_response error:&noticeInfoList_error];
    
    //データを取得
    if (noticeInfoListJsonData && noticeInfoList_response.statusCode == 200) {
        
        //データが存在しない場合、エラーメッセージを表示して終了
        if ((noticeInfoListJsonData.length > 0) == NO ) {
            //メインスレッドでインジケーターを閉じてデータが存在しない旨、表示する
            [self performSelectorOnMainThread:@selector(closeIndicator) withObject:nil waitUntilDone:NO];
            [self.view makeToast:@"お知らせ情報がありません。" duration:TOAST_DURATION_ERROR position:@"center"];
            return;
        }

        //JSONのデータを読み込む
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:noticeInfoListJsonData options:NSJSONReadingAllowFragments error:&noticeInfoList_error];
        NSDictionary *jsonNoticeInfoObject = [jsonObject objectForKey:@"noticeInfo"];

        
        //取得したお知らせ情報を配列に設定
        for (NSDictionary *dObj in jsonNoticeInfoObject) {
            NoticeInfo *noticeInfo = [[NoticeInfo alloc] init];
            noticeInfo.notice_info_no = [[dObj objectForKey:@"notice_info_no"] intValue];
            noticeInfo.notice_schedule = [dObj objectForKey:@"notice_schedule"];
            noticeInfo.entry_method = [[dObj objectForKey:@"entry_method"] intValue];
            noticeInfo.notice_title = [dObj objectForKey:@"notice_title"];
            noticeInfo.url = [dObj objectForKey:@"url"];
            
            int search_category = [[dObj objectForKey:@"search_category"] intValue];
            if(search_category == 4 || search_category == 5) {
                noticeInfo.deceased_id = [dObj objectForKey:@"deceased_id"];
            } else {
                noticeInfo.deceased_id = @"";
            }
            
            [_noticeInfos addObject:noticeInfo];
        }
    }

    //メインスレッドでテーブルの更新
    [self performSelectorOnMainThread:@selector(reloadNoticeTable) withObject:nil waitUntilDone:NO];
    
    //メインスレッドでインディケーターを閉じる
    [self performSelectorOnMainThread:@selector(closeIndicator) withObject:nil waitUntilDone:NO];
}

- (void)reloadNoticeTable {
    //テーブルビューの更新
    [self.noticeTable reloadData];
}

//セルの数取得時
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noticeInfos.count;
}

//セルの取得時
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //テーブルのセルの生成
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NoticeCell"];
    }

    //お知らせ情報を取得
    NoticeInfo *noticeInfo = [_noticeInfos objectAtIndex:(int)indexPath.row];

    //セルにお知らせ情報を設定
    cell.textLabel.text = [Common getDateStringJ:noticeInfo.notice_schedule format:@"%@/%@/%@"];
    cell.detailTextLabel.text = noticeInfo.notice_title;

    return cell;
}

//セルの選択時
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //テーブルの選択状態を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //お知らせ情報画面を生成
    NoticeInfoViewController *noticeInfoViewController = [[NoticeInfoViewController alloc] init];

    //お知らせ情報を取得してお知らせ情報画面のプロパティにURLを設定
    NoticeInfo *noticeInfo = [_noticeInfos objectAtIndex:(int)indexPath.row];
    if (noticeInfo.entry_method == ENTRY_METHOD_INPUT) {
        noticeInfoViewController.url =
            [VIEW_NOTICE_INFO stringByAppendingFormat:@"?nino=%d&deceased_id=%@", noticeInfo.notice_info_no, noticeInfo.deceased_id];
        
    } else if (noticeInfo.entry_method == ENTRY_METHOD_URL) {
        noticeInfoViewController.url = noticeInfo.url;
    }

    //お知らせ情報画面をモーダルで開く
    noticeInfoViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    noticeInfoViewController.noticeNo = noticeInfo.notice_info_no;
    [self presentViewController:noticeInfoViewController animated:NO completion:nil];
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender
{
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:NO];
}

//インジケーターを閉じる
- (void)closeIndicator
{
    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
