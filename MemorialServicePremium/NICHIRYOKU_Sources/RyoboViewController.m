//
//  RyoboViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/04/05.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "RyoboViewController.h"
#import "MenuTabBarViewController.h"
#import "RyoboImgEditViewController.h"
#import "Define.h"
#import "IndicatorWindow.h"
#import "Reachability.h"
#import "HttpAccess.h"

@interface RyoboViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *ryoboImg;
    
@end

@implementation RyoboViewController{
    NSString *memberId;
    NSString *appliid;
    NSUserDefaults *defaults;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        defaults = [NSUserDefaults standardUserDefaults];               // 取得
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];

//    //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
//    Reachability *curReach = [Reachability reachabilityForInternetConnection];
//    NetworkStatus netStatus = [curReach currentReachabilityStatus];
//    if (netStatus == NotReachable) {
//        //インジケーターを閉じる
//        [IndicatorWindow closeWindow];
//        //接続できない場合、エラーメッセージをダイアログ表示
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"ネットワークに接続できる環境で使用して下さい。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//        return;
//    }
//    
//    //会員番号を取得
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  // 取得
//    userid = [defaults stringForKey:USER_ID];  // USER_IDの内容をNSString型として取得
//    appliid = [defaults stringForKey:KEY_MEMBER_APPLI_ID];      // KEY_MEMBER_APPLI_IDの内容を取得
//
//
    // HTTP からファイルをダウンロードして、ローカルに保存、ローカルにファイルが存在すれば、ローカルのファイルをロード
    //実行処理
//    self.ryoboImg.contentMode = UIViewContentModeScaleAspectFit;
//
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ryobo2.jpg"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL success = [fileManager fileExistsAtPath:dataPath];
//    
//    UIImage *image;
//    if (success) {
//        NSLog(@"load from local");
//        NSData *data = [NSData dataWithContentsOfFile:dataPath];
//        
//        image =  [[UIImage alloc] initWithData:data];
////        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
////        [self.view addSubview:imageView];
//        self.ryoboImg.image = image;
//    } else {
////        NSLog(@"load from remote");
////        [self loadImageFromRemote];
//        image = [UIImage imageNamed:@"nothing"];
//        self.ryoboImg.image = image;
//    }
    
    self.ryoboImg.contentMode = UIViewContentModeScaleAspectFit;
    
    //会員番号QRを読み込んでいる場合
    BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
    
    if (transfer_download) {
        
        //インターネットに接続できるかチェック、接続できない場合、エラーメッセージ表示
        Reachability *curReach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        //インターネット接続されている
        if (netStatus != NotReachable) {
            
            memberId = [defaults stringForKey:KEY_MEMBER_USER_ID];           // 会員番号
            appliid = [defaults stringForKey:KEY_MEMBER_APPLI_ID];           // アプリID
            
            //サーバーから会員情報取得
            HttpAccess *httpAccess = [HttpAccess new];
            
            NSMutableDictionary *parameter = [@{@"appli_id":appliid} mutableCopy];
            
            NSData *returnData = [httpAccess POST:GET_MEMBER_ID param:parameter];
            
            NSError *errorObject = nil;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingAllowFragments error:&errorObject];
            
            //JSONオブジェクトのパース失敗時はログを出して終了
            if ([jsonObject isEqual:@"false"]) {
                NSLog(@"JSONObjectパース失敗");
                return;
            }
            
            // NSUserDefaultsに保存・更新する
            [defaults setObject:[jsonObject objectForKey:@"deceased_id"] forKey:KEY_MEMBER_USER_ID];
            [defaults setObject:[jsonObject objectForKey:@"appli_id"] forKey:KEY_MEMBER_APPLI_ID];
            [defaults setObject:[jsonObject objectForKey:@"grave_photo_path"] forKey:KEY_RYOBO_PHOTO_PATh];
            [defaults synchronize];
            
            if ([[jsonObject objectForKey:@"grave_photo_path"] isEqual:@"1"]) {
                
                //保存先パス取得
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ryobo2.jpg"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                //ファイルの存在チェック
                if ([fileManager fileExistsAtPath:dataPath]) {
                    //存在する場合、何もしない
                    NSData *data = [NSData dataWithContentsOfFile:dataPath];
                    UIImage *image =  [[UIImage alloc] initWithData:data];
                    //        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    //        [self.view addSubview:imageView];
                    self.ryoboImg.image = image;
                    
                    return;
                }else{
                    //存在しない場合、ダウンロード
                    [self loadImageFromRemote];
                    
                    return;
                }
                
            }else{
                
                UIImage *image = [UIImage imageNamed:@"noryobo"];
                self.ryoboImg.image = image;
                
            }
        }else{
            //インターネット未接続
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"現在インターネット未接続のため、更新された情報は反映されません。" preferredStyle:UIAlertControllerStyleAlert];
            
            // addActionした順に左から右にボタンが配置されます
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // OKボタンが押された時の処理
                [self okButtonPushed];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }else{
        //保存先パス取得
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ryobo2.jpg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //ファイルの存在チェック
        if ([fileManager fileExistsAtPath:dataPath]) {
            //存在する場合、何もしない
            NSData *data = [NSData dataWithContentsOfFile:dataPath];
            UIImage *image =  [[UIImage alloc] initWithData:data];
            //        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            //        [self.view addSubview:imageView];
            self.ryoboImg.image = image;
            
            return;
        }else{
            
            //会員番号QRを読み込んでいない場合かつ写真登録していない場合、エラーメッセージをダイアログ表示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"お墓写真は登録できますが、会員番号QRを読んだ場合、家族間で共有されている写真に差し替わります。" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            
            UIImage *image = [UIImage imageNamed:@"noryobo"];
            self.ryoboImg.image = image;
            
        }
    }

}



-(void)viewDidAppear:(BOOL)animated{
    
    
 
}


//アラートの「OK」ボタンタップ時(インターネット未接続時)
- (void)okButtonPushed {
    
    self.ryoboImg.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ryobo2.jpg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    
    UIImage *image;
    if (success) {
        //存在する場合
        NSLog(@"load from local");
        NSData *data = [NSData dataWithContentsOfFile:dataPath];
        
        image =  [[UIImage alloc] initWithData:data];
        //        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //        [self.view addSubview:imageView];
        self.ryoboImg.image = image;
    } else {
        //存在しない場合
        //        NSLog(@"load from remote");
        //        [self loadImageFromRemote];
        image = [UIImage imageNamed:@"noryobo"];
        self.ryoboImg.image = image;
    }
    
}

- (void)loadImageFromRemote
{
    // 読み込むファイルの URL を作成
    // URL指定、パラメーターを付与
    NSString *urlAsString = GET_RYOBOPHOTO_DOWNLOAD;
    urlAsString = [urlAsString stringByAppendingString:@"?appli_id="];
    urlAsString = [urlAsString stringByAppendingString:appliid];
    NSURL *url = [NSURL URLWithString:urlAsString];
    
        //インジケーター開始
        [IndicatorWindow openWindow];
    
    // 別のスレッドでファイル読み込みをキューに加える
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadImage:)
                                        object:url];
    [queue addOperation:operation];
}

// 別スレッドでファイルを読み込む
- (void)loadImage:(NSURL *)url
{
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:url];
    
    // 読み込んだらメインスレッドのメソッドを実行
    [self performSelectorOnMainThread:@selector(saveImage:) withObject:imageData waitUntilDone:NO];
}


// ローカルにデータを保存
- (void)saveImage:(NSData *)data
{
    self.ryoboImg.contentMode = UIViewContentModeScaleAspectFit;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"ryobo2.jpg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    if (success) {
        data = [NSData dataWithContentsOfFile:dataPath];
    } else {
        [data writeToFile:dataPath atomically:YES];
    }
    
    UIImage *image =  [[UIImage alloc] initWithData:data];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    [self.view addSubview:imageView];
    self.ryoboImg.image = image;

    //インジケーターを閉じる
    [IndicatorWindow closeWindow];
}

- (IBAction)return_Back:(id)sender {
    //トップメニュー画面に戻る
//    [self.navigationController popViewControllerAnimated:NO];
    //インスタンスを生成
    MenuTabBarViewController *menuTabBarViewController = [MenuTabBarViewController new];
    
    //遷移
    [self.navigationController pushViewController:menuTabBarViewController animated:NO];
    
}


- (IBAction)onClick_RyoboImgEdit:(id)sender {
    //墓画像編集画面に遷移
    //墓画像編集画面のインスタンスを生成
    RyoboImgEditViewController *ryoboImgEditViewController = [RyoboImgEditViewController new];
    
    // Tab bar を非表示
    ryoboImgEditViewController.hidesBottomBarWhenPushed = YES;
    
    //墓画像編集画面に遷移
    [self.navigationController pushViewController:ryoboImgEditViewController animated:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
