//
//  LoupeViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/01/30.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "LoupeViewController.h"
#import "Define.h"
#import <AVFoundation/AVFoundation.h>



@interface LoupeViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *Loupe;
@property (strong, nonatomic) AVCaptureSession *session;


@end

@implementation LoupeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //カメラ用のViewに枠を設定
    [self.Loupe.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.Loupe.layer setBorderWidth:1.0f];
    
    //カメラを開始する
    [self startSession];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *qrcode;
    BOOL qrReadFlg = NO;
    
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            //カメラを終了する
            [self stopSession];
            
            //複数の QR があっても1度で読み取れている
            qrcode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            //            NSLog(@"%@", qrcode);
            qrReadFlg = YES;
            
            break;
        }
    }
    
}

//カメラの準備
- (void)startSession {
    self.session = [[AVCaptureSession alloc] init];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *device = nil;
    AVCaptureDevicePosition camera = AVCaptureDevicePositionBack; // Back or Front
    for (AVCaptureDevice *d in devices) {
        device = d;
        if (d.position == camera) {
            break;
        }
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    [self.session addInput:input];
    
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    
    [self.session startRunning];
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.frame = self.Loupe.bounds;
    
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.Loupe.layer addSublayer:preview];

    
    
}

//カメラを終了する
- (void)stopSession {
    [self.session stopRunning];
    for (AVCaptureOutput *output in self.session.outputs) {
        [self.session removeOutput:output];
    }
    for (AVCaptureInput *input in self.session.inputs) {
        [self.session removeInput:input];
    }
    self.session = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//戻るボタンタップ時の処理
- (IBAction)returnBtnClick:(id)sender
{
    //その他画面に戻る
    [self.navigationController popViewControllerAnimated:NO];
}


@end
