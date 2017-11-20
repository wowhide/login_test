//
//  QrDeceasedInfoEditViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/15.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "QrDeceasedInfoEditViewController.h"
#import "DeceasedListViewController.h"
#import "Deceased.h"
#import "DeceasedDao.h"
#import "Common.h"
#import "Define.h"
#import "Toast+UIView.h"
#import "HttpAccess.h"

@interface QrDeceasedInfoEditViewController () {
    Deceased *_deceased;
    UIImage *_photoImage;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoSelectLabel;

@end

@implementation QrDeceasedInfoEditViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //DBからデータを取得
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    //取得
    _deceased = [deceasedDao selectDeceasedByDeceasedNo:self.deceasedNo];
    //DBを閉じる
    [memorialDatabase close];
    
    //取得した故人情報を画面に設定する
    //お名前
    self.nameLabel.text = [NSString stringWithFormat:@"%@　様", _deceased.deceased_name];
    //写真選択
    if (_deceased.deceased_photo_path.length > 0) {
        self.photoSelectLabel.text = @"選択済";
    }
    
    
}

//戻るボタンクリック時
- (IBAction)returnButtonPushed:(id)sender {
    //上の階層に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//保存ボタンクリック時
- (IBAction)saveButtonPushed:(id)sender {
    //画像を選択している場合、画像をドキュメントフォルダに保存し、ファイル名をDeceasedに設定する
    if (_photoImage != nil) {
        //ファイル名生成
        NSString *saveFileName = [NSString stringWithFormat:@"%@.jpg",_deceased.deceased_id];
        //保存先パス生成
        NSString *dataPath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, saveFileName];
        
        //サイズを調整する
        CGFloat newSize = IMAGE_REDUCTION_SIZE;
        UIImage *resizeImage = [Common resizeImage:_photoImage toSize:newSize];
        
        //保存する（ファイルが存在する場合は上書きされる）
        NSData *data = UIImageJPEGRepresentation(resizeImage, 0.8);
        if ([data writeToFile:dataPath atomically:YES]) {
//            NSLog(@"hozon:OK");
        } else {
//            NSLog(@"hozon:NG");
            //エラーメッセージをダイアログ表示
            [self.view makeToast:@"保存に失敗しました。\nもう一度保存して下さい。" duration:TOAST_DURATION_ERROR position:@"center"];
            return;
        }
        
        _deceased.deceased_photo_path = saveFileName;
    }
    
    //DBに接続
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    
    //DBに登録
    [deceasedDao updateDeceased:_deceased];
    
    //DBを閉じる
    [memorialDatabase close];
    
    //保存完了をトースト表示
    [self.view makeToast:@"保存が完了しました。" duration:TOAST_DURATION_NOTICE position:@"center"];
    
    //1秒後前の上の階層に戻る
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(popView) userInfo:nil repeats:NO];
}

-(void)popView
{
//    //上の階層に戻る
//    [self.navigationController popViewControllerAnimated:YES];
    //大切な故人一覧のインスタンスを生成
    DeceasedListViewController *deceasedListViewController = [DeceasedListViewController new];
    
    //大切な故人一覧画面に遷移
    [self.navigationController pushViewController:deceasedListViewController animated:YES];
}

//写真を変更するボタンクリック時、イメージピッカーを表示する
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
