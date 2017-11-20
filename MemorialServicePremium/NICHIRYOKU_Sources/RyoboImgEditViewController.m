//
//  RyoboImgEditViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/04/05.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "RyoboImgEditViewController.h"
#import "RyoboViewController.h"
#import "IndicatorWindow.h"
#import "Reachability.h"
#import "Define.h"
#import "Toast+UIView.h"
#import "Common.h"

@interface RyoboImgEditViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *photoSelectLabel;


@end

@implementation RyoboImgEditViewController{
    NSString *memberId;
    NSString *appliId;
    NSString *memberRyoboImg;
    NSUserDefaults *defaults;
    UIImage *_photoImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //会員番号を取得
    defaults        = [NSUserDefaults standardUserDefaults];            // 取得
    memberId        = [defaults stringForKey:KEY_MEMBER_USER_ID];       // 会員番号
    appliId         = [defaults stringForKey:KEY_MEMBER_APPLI_ID];      // アプリID
    memberRyoboImg  = [defaults stringForKey:KEY_RYOBO_PHOTO_PATh];     // 墓写真

//
//    //リクエスト先を指定する
//    NSString *Ryobo_urlAsString = GET_MEMBER_ID;
//    
//    NSURL *Ryoboimg_url = [NSURL URLWithString:Ryobo_urlAsString];
//    
//    //POSTメソッドのHTTPリクエストを生成する
//    NSMutableURLRequest *ryoboimg_urlRequest = [NSMutableURLRequest requestWithURL:Ryoboimg_url];
//    [ryoboimg_urlRequest setHTTPMethod:@"POST"];
//    
//    //パラメータを付与
//    NSString *Ryoboimg_body = [NSString stringWithFormat:@"deceasedId=%@",userid];
//    
//    [ryoboimg_urlRequest setHTTPBody:[Ryoboimg_body dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSHTTPURLResponse *ryoboimg_response;
//    NSError *ryoboimg_error = nil;
//    
//    //HTTP同期通信を実行
//    NSData *ryoboimgJsonData = [NSURLConnection sendSynchronousRequest:ryoboimg_urlRequest returningResponse:&ryoboimg_response error:&ryoboimg_error];
//    
//    //データを取得
//    if (ryoboimgJsonData && ryoboimg_response.statusCode == 200) {
//        
//        //JSONのデータを読み込む
//        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:ryoboimgJsonData options:NSJSONReadingAllowFragments error:&ryoboimg_error];
//        
//        NSString *memberRyoboImgPath = [jsonObject objectForKey:@"grave_photo_path"];
//        
//        NSLog(@"jsonObject_%@", memberRyoboImgPath);
//        
//        defaults = [NSUserDefaults standardUserDefaults];  // 取得
//        NSMutableDictionary *ryoboimg_defaults = [NSMutableDictionary dictionary];
//        [ryoboimg_defaults setObject:memberRyoboImgPath forKey:@"MEMBER_USER_GRAVE_PHOTO"];  // をKEY_Sというキーの初期値はhoge
//        [defaults registerDefaults:ryoboimg_defaults];
//
//    }
    
    
}


//-(void)viewDidAppear:(BOOL)animated{
//    
//    defaults = [NSUserDefaults standardUserDefaults];  // 取得
//    NSString *memberRyoboImg = [defaults stringForKey:@"MEMBER_USER_GRAVE_PHOTO"];
//    
//
//        if (memberRyoboImg.length > 0) {
//        self.photoSelectLabel.text = @"選択済";
//        }
//    
//        if (memberRyoboImg.length == 0) {
//        self.photoSelectLabel.text = @"選択未";
//        }
//}

//写真選択時、イメージピッカーを表示する
- (IBAction)photoSelectButtonPushed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//イメージピッカーのイメージ取得時
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //イメージを取得する
    _photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //ラベルに選択済を設定
    self.photoSelectLabel.text = @"選択済";
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

//イメージピッカーのキャンセル時
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //イメージピッカーを閉じる
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)return_Back:(id)sender {

    //お墓に戻る
    [self.navigationController popViewControllerAnimated:NO];

}

- (IBAction)onClick_Save:(id)sender {
    
    //画像を選択している場合、画像をドキュメントフォルダに保存し、ファイル名をDeceasedに設定する
    if (_photoImage != nil) {
        //ファイル名生成
        NSString *saveFileName = [NSString stringWithFormat:@"ryobo2.jpg"];
        //保存先パス生成
        NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, saveFileName];
        
        //サイズを調整する
        CGFloat newSize = IMAGE_REDUCTION_SIZE;
        UIImage *resizeImage = [Common resizeImage:_photoImage toSize:newSize];
        
        NSData *data = UIImageJPEGRepresentation(resizeImage, 0.8);
        
        //墓写真フラグが０の場合
        if ([memberRyoboImg isEqualToString:@""]||[memberRyoboImg isEqualToString:@"0"] ) {
             [self saveImage:data];
        }
        
        //保存する（ファイルが存在する場合は上書きされる）
        if ([data writeToFile:dataPath atomically:YES]) {
                        NSLog(@"hozon:OK");
            
            //ユーザーデフォルトに保存
            [defaults setObject:@"1" forKey:KEY_RYOBO_PHOTO_PATh];
            [defaults synchronize];
            
        [self.view makeToast:@"保存が完了しました。" duration:TOAST_DURATION_NOTICE position:@"center"];

        [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(moveView) userInfo:nil repeats:NO];

            //アクセスキーを取得されている場合、ダウンロードを実行する
            //インジケーター開始
//            [IndicatorWindow openWindow];
            
            //会員番号QRを読み込んでいる場合
            BOOL transfer_download = [defaults boolForKey:@"KEY_DOWNLOAD"];
            
            if (transfer_download) {
                //別スレッドでアップロードを実行する
                NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                    initWithTarget:self
                                                    selector:@selector(uploadData)
                                                    object:nil];
                NSOperationQueue *queue = [NSOperationQueue new];
                [queue addOperation:operation];

            }
        
                //保存完了をトースト表示
                // [self.view makeToast:@"保存が完了しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
            return;
        } else {
            //            NSLog(@"hozon:NG");
            //エラーメッセージをダイアログ表示
            [self.view makeToast:@"保存に失敗しました。\nもう一度保存して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
            return;
        }
        
    }

}

- (void)uploadData
{

                //ファイルが存在する場合、ファイルをアップロードする
                NSString *savephoto_urlAsString = GET_RYOBO_IMG_UPLOAD;
                
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
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"appli_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postBody appendData:[appliId dataUsingEncoding:NSUTF8StringEncoding]];
                
                //写真を設定
                NSData* imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(_photoImage, 1.0)];
                [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upfile\"; filename=\"%@\"\r\n", memberId] dataUsingEncoding:NSUTF8StringEncoding]];
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
                    
                    
                    
                    
                    //ダイアログ表示
                    [self.view makeToast:@"保存が完了しました" duration:TOAST_DURATION_ERROR position:@"center"];
                    
                    
                    if ([photoUpResult isEqualToString:@"NO"]) {
                        //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
//                                                [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
                        return;
                    }
                } else {
                    //メインスレッドでインディケーターを閉じてエラーメッセージを表示する
//                                        [self performSelectorOnMainThread:@selector(closeIndicatorAndErrorMessage:) withObject:@"データのアップロードに失敗しました。\nお手数ですがもう一度最初から操作して下さい。" waitUntilDone:NO];
                    return;
                }
            

    //インジケーターを閉じる
//    [IndicatorWindow closeWindow];
    
    
    
}


-(void)moveView{
    
//    [self.navigationController popViewControllerAnimated:NO];
    
    RyoboViewController *ryoboViewController = [RyoboViewController new];
    
    // Tab bar を非表示
    ryoboViewController.hidesBottomBarWhenPushed = YES;
    
    //墓画像編集画面に遷移
    [self.navigationController pushViewController:ryoboViewController animated:NO];
}



// ローカルにデータを保存
- (void)saveImage:(NSData *)data
{
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
