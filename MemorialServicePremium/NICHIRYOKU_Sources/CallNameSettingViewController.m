//
//  CallNameSettingViewController.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2017/05/12.
//  Copyright © 2017年 DIGITALSPACE WOW. All rights reserved.
//

#import "CallNameSettingViewController.h"
#import "NicefaceViewController.h"
#import "Toast+UIView.h"
#import "HttpAccess.h"
#import "Define.h"
#import "Common.h"

@interface CallNameSettingViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
//　:::: 祖父 ::::: //
//　スイッチ
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandfatherOne;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandfatherTwo;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandfatherThree;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandfatherFour;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandfatherFive;

// ラベル
@property (weak, nonatomic) IBOutlet UILabel *labelGrandfatherOne;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandfatherTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandfatherThree;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandfatherFour;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandfatherFive;

//　:::: 祖母 ::::: //
//　スイッチ
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandmatherOne;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandmatherTwo;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandmatherThree;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandmatherFour;
@property (weak, nonatomic) IBOutlet UISwitch *switchGrandmatherFive;

// ラベル
@property (weak, nonatomic) IBOutlet UILabel *labelGrandmatherOne;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandmatherTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandmatherThree;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandmatherFour;
@property (weak, nonatomic) IBOutlet UILabel *labelGrandmatherFive;

//　:::: 手入力 ::::: //
//　スイッチ
@property (weak, nonatomic) IBOutlet UISwitch *switchSelf;

//　スクロールビュー
@property (weak, nonatomic) IBOutlet UIScrollView *entryScrollView;
//　ビュー
@property (weak, nonatomic) IBOutlet UIView *entryView;


@end

@implementation CallNameSettingViewController{
    //アプリID
    NSString *appliId;
    //発信者名
    NSString *nowCallName;
    NSString *callName;
    //発信者チェックボックス
    NSString  *decideCheckBox;
    //デバイストークン
    NSString *deviceToken;
    //ユーザーデフォルト
    NSUserDefaults *defaults;
    //アラートビュー
    UIAlertView *alert;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        alert = [[UIAlertView alloc] init];
        alert.delegate = self;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height+2500)];
    
    //ツールバーの背景色と文字色を設定
    self.toolBar.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];


    
    //UIScrollViewのコンテンツサイズを設定
//    self.entryScrollView.contentSize = self.entryView.bounds.size;
    
    
    //スクロールのため、height値をプラス
    float width = [[UIScreen mainScreen]bounds].size.width;
    float height = [[UIScreen mainScreen]bounds].size.height+1150;
    
    //UIScrollViewのコンテンツサイズを設定
    self.entryScrollView.contentSize = CGSizeMake(width,height);

    //スクロールバーを表示
    self.entryScrollView.showsVerticalScrollIndicator = YES;
    
    //UISWitchのサイズ変更
    self.switchSelf.transform               = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandfatherOne.transform     = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandfatherTwo.transform     = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandfatherThree.transform   = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandfatherFour.transform    = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandfatherFive.transform    = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandmatherOne.transform     = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandmatherTwo.transform     = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandmatherThree.transform   = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandmatherFour.transform    = CGAffineTransformMakeScale(0.7, 0.7);
    self.switchGrandmatherFive.transform    = CGAffineTransformMakeScale(0.7, 0.7);

    //ユーザーデフォルト
    defaults        = [NSUserDefaults standardUserDefaults];                // 取得
    appliId         = [defaults stringForKey:KEY_MEMBER_APPLI_ID];          // アプリID
    nowCallName     = [defaults stringForKey:KEY_MEMBER_SENDAR_NAME];       // 発信者名取得
    deviceToken     = [defaults stringForKey:KEY_DEVICE_TOKEN];             // デバイストークン
    decideCheckBox  = [defaults stringForKey:KEY_MEMBER_SENDAR_CHECKBOX];   // 発信者チェックボックス
    
    //アラートビュー表示
    if ([nowCallName length] == 0) {
        alert.message = @"発信者名を登録してください";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
    }

    //ツールバーを生成
    UIToolbar *toolBar =[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    //スタイルの設定
    toolBar.barStyle = UIBarStyleDefault;
    
    //ツールバーを画面サイズに合わせる
    [toolBar sizeToFit];
    
    //「完了」ボタンを右端に配置したいためフレキスブルなスペースを作成する
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //完了ボタンの生成
    UIBarButtonItem *_commitBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeKeyboard:)];
    
    //ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn,nil];
    
    //表示・非表示の設定
    [toolBar setItems:toolBarItems animated:YES];
    
    //ToolbarをTextViewのinputAccessoryViewに設定
    self.nameText.inputAccessoryView = toolBar;
    
    //============手入力===================//
    //手入力処理
    //送信者未入力の場合の処理
    if ([nowCallName length] == 0) {
        self.switchSelf.on = true;
        _nameText.enabled = YES;
        decideCheckBox = KEY_SENDER_SELF;
    }
    
    [_switchSelf addTarget:self action:@selector(switchSelfChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_SELF]) {
        self.switchSelf.on = true;
        _nameText.enabled = YES;
    }
    
    
    //=============祖父１===================//
    //祖父１スイッチ処理
    [_switchGrandfatherOne addTarget:self action:@selector(switchGrandfatherOneChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDFATHER_ONE]) {
        self.switchGrandfatherOne.on = true;
    }
    
    //=============祖父２===================//
    //祖父２スイッチ処理
    [_switchGrandfatherTwo addTarget:self action:@selector(switchGrandfatherTwoChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDFATHER_TWO]) {
        self.switchGrandfatherTwo.on = true;
    }
    
    //=============祖父３===================//
    //祖父３スイッチ処理
    [_switchGrandfatherThree addTarget:self action:@selector(switchGrandfatherThreeChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDFATHER_THREE]) {
        self.switchGrandfatherThree.on = true;
    }
    
    //=============祖父４===================//
    //祖父４スイッチ処理
    [_switchGrandfatherFour addTarget:self action:@selector(switchGrandfatherFourChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDFATHER_FOUR]) {
        self.switchGrandfatherFour.on = true;
    }
    
    //=============祖父５===================//
    //祖父５スイッチ処理
    [_switchGrandfatherFive addTarget:self action:@selector(switchGrandfatherFiveChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDFATHER_FIVE]) {
        self.switchGrandfatherFive.on = true;
    }
    
    //=============祖母１===================//
    //祖母１スイッチ処理
    [_switchGrandmatherOne addTarget:self action:@selector(switchGrandmatherOneChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDMATHER_ONE]) {
        self.switchGrandmatherOne.on = true;
    }
    
    //=============祖母２===================//
    //祖母２スイッチ処理
    [_switchGrandmatherTwo addTarget:self action:@selector(switchGrandmatherTwoChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDMATHER_TWO]) {
        self.switchGrandmatherTwo.on = true;
    }
    
    //=============祖母３===================//
    //祖母３スイッチ処理
    [_switchGrandmatherThree addTarget:self action:@selector(switchGrandmatherThreeChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDMATHER_THREE]) {
        self.switchGrandmatherThree.on = true;
    }
    
    //=============祖母４===================//
    //祖母４スイッチ処理
    [_switchGrandmatherFour addTarget:self action:@selector(switchGrandmatherFourChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDMATHER_FOUR]) {
        self.switchGrandmatherFour.on = true;
    }

    //=============祖母５===================//
    //祖母５スイッチ処理
    [_switchGrandmatherFive addTarget:self action:@selector(switchGrandmatherFiveChanged:) forControlEvents:UIControlEventValueChanged];
    
    //保存データ取得
    if ([decideCheckBox isEqualToString:KEY_SENDER_GRANDMATHER_FIVE]) {
        self.switchGrandmatherFive.on = true;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // onの時の処理
    if ([nowCallName isEqualToString:_labelGrandfatherOne.text]
        ||[nowCallName isEqualToString:_labelGrandfatherTwo.text]
        ||[nowCallName isEqualToString:_labelGrandfatherThree.text]
        ||[nowCallName isEqualToString:_labelGrandfatherFour.text]
        ||[nowCallName isEqualToString:_labelGrandfatherFive.text]
        ||[nowCallName isEqualToString:_labelGrandmatherOne.text]
        ||[nowCallName isEqualToString:_labelGrandmatherTwo.text]
        ||[nowCallName isEqualToString:_labelGrandmatherThree.text]
        ||[nowCallName isEqualToString:_labelGrandmatherFour.text]
        ||[nowCallName isEqualToString:_labelGrandmatherFive.text]
        ){
        self.nameText.text =@"";
        _nameText.enabled = NO;

    }else{
        self.nameText.text =nowCallName;
        _nameText.enabled = YES;
    }
}

-(void)closeKeyboard:(id)sender{
    [self.nameText resignFirstResponder];
}

// UITextFieldのキーボード上の「Return」ボタンが押された時に呼ばれる処理
- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    
    // 受け取った入力をラベルに代入
    self.nameText.text = sender.text;
    
    // キーボードを閉じる
    [sender resignFirstResponder];
    
    return TRUE;
}





//手入力
-(void)switchSelfChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        if ([nowCallName isEqualToString:_labelGrandfatherOne.text]
            ||[nowCallName isEqualToString:_labelGrandfatherTwo.text]
            ||[nowCallName isEqualToString:_labelGrandfatherThree.text]
            ||[nowCallName isEqualToString:_labelGrandfatherFour.text]
            ||[nowCallName isEqualToString:_labelGrandfatherFive.text]
            ||[nowCallName isEqualToString:_labelGrandmatherOne.text]
            ||[nowCallName isEqualToString:_labelGrandmatherTwo.text]
            ||[nowCallName isEqualToString:_labelGrandmatherThree.text]
            ||[nowCallName isEqualToString:_labelGrandmatherFour.text]
            ||[nowCallName isEqualToString:_labelGrandmatherFive.text]
            ){
                    self.nameText.text =@"";
        }else{
                    self.nameText.text =nowCallName;
        }

        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;

        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;

        decideCheckBox = KEY_SENDER_SELF;
        _nameText.enabled = YES;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
        _nameText.enabled = NO;

    }
}

//祖父１
-(void)switchGrandfatherOneChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;
        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;

        decideCheckBox = KEY_SENDER_GRANDFATHER_ONE;
        callName = _labelGrandfatherOne.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖父２
-(void)switchGrandfatherTwoChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;
        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDFATHER_TWO;
        callName = _labelGrandfatherTwo.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖父３
-(void)switchGrandfatherThreeChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;
        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDFATHER_THREE;
        callName = _labelGrandfatherThree.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖父４
-(void)switchGrandfatherFourChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFive.on = false;
        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDFATHER_FOUR;
        callName = _labelGrandfatherFour.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖父５
-(void)switchGrandfatherFiveChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDFATHER_FIVE;
        callName = _labelGrandfatherFive.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖母１
-(void)switchGrandmatherOneChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;
        
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDMATHER_ONE;
        callName = _labelGrandmatherOne.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖母２
-(void)switchGrandmatherTwoChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;

        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDMATHER_TWO;
        callName = _labelGrandmatherTwo.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖母３
-(void)switchGrandmatherThreeChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;

        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherFour.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDMATHER_THREE;
        callName = _labelGrandmatherThree.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖母４
-(void)switchGrandmatherFourChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
        self.nameText.text = @"";
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;
        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFive.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDMATHER_FOUR;
        callName = _labelGrandmatherFour.text;
        _nameText.enabled = NO;
    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}

//祖母５
-(void)switchGrandmatherFiveChanged:(UISwitch*)switchParts{
    if( switchParts.on )
    {
        // onの時の処理
//        self.nameText.text =_labelGrandmatherFive.text;
        self.switchSelf.on = false;
        self.switchGrandfatherOne.on = false;
        self.switchGrandfatherTwo.on = false;
        self.switchGrandfatherThree.on = false;
        self.switchGrandfatherFour.on = false;
        self.switchGrandfatherFive.on = false;
        
        self.switchGrandmatherOne.on = false;
        self.switchGrandmatherTwo.on = false;
        self.switchGrandmatherThree.on = false;
        self.switchGrandmatherFour.on = false;
        
        decideCheckBox = KEY_SENDER_GRANDMATHER_FIVE;
        callName = _labelGrandmatherFive.text;
        _nameText.enabled = NO;

    }
    else
    {
        // offの時の処理
        self.nameText.text =nowCallName;
    }
}


// アラートのボタンが押された時に呼ばれる
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //「OK」ボタン押下時、何もしない
            break;
    }
    
}
//保存ボタンタップ時の処理
- (IBAction)decisionBtnClick:(id)sender
{
    //入力値を美文字表示に渡す
//    callName = self.nameText.text;
    
    //自由入力欄入力時
    if ([decideCheckBox isEqualToString:KEY_SENDER_SELF]) {
        callName = self.nameText.text;
    }
    
    //空文字チェック
    if ([callName length] == 0) {
        [self.view makeToast:@"名前を入力してください。" duration:2.0 position:@"center"];
        return;
    }
    
    //文字数チェック
    if ([callName length] > 10) {
        [self.view makeToast:@"名前は10文字までです。" duration:2.0 position:@"center"];
        return;
    }
    
    //例外命名の場合
    if ([callName isEqualToString:@"reinstall"]) {
        [self.view makeToast:@"当該名前で登録することはできません。" duration:2.0 position:@"center"];
        return;
    }
    
    //スイッチチェック
    if (self.switchSelf.on == false &&
        self.switchGrandfatherOne.on == false &&
        self.switchGrandfatherTwo.on == false &&
        self.switchGrandfatherThree.on == false &&
        self.switchGrandfatherFour.on == false &&
        self.switchGrandfatherFive.on == false &&
        self.switchGrandmatherOne.on == false &&
        self.switchGrandmatherTwo.on == false &&
        self.switchGrandmatherThree.on == false &&
        self.switchGrandmatherFour.on == false &&
        self.switchGrandmatherFive.on == false)
    {
        [self.view makeToast:@"お名前が選択されていません。" duration:2.0 position:@"center"];
        return;
    }
    
    HttpAccess *httpAccess = [HttpAccess new];
    
    NSMutableDictionary *parameter = [@{@"appli_id":appliId,@"call_name":callName,@"device_token":deviceToken} mutableCopy];
    
    NSData *returnData = [httpAccess POST:NICEFACE_NAME_CHECK param:parameter];
    
    NSString *result= [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"毎日おはよう名前設定結果：%@",result);
    
    if ([result isEqualToString:@"1"]) {
        
        defaults = [NSUserDefaults standardUserDefaults];                       // 取得
        [defaults setObject:callName forKey:KEY_MEMBER_SENDAR_NAME];            // 保存
        [defaults setObject:decideCheckBox forKey:KEY_MEMBER_SENDAR_CHECKBOX];
        [defaults synchronize];                                                 // 反映
        
        [self.view makeToast:@"保存が完了しました" duration:TOAST_DURATION_ERROR position:@"center"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(moveView) userInfo:nil repeats:NO];

    }else{
        [self.view makeToast:@"設定した名前は、すでに登録されています" duration:TOAST_DURATION_ERROR position:@"center"];
    }
}


-(void)moveView{
    
    //インスタンスを生成
    NicefaceViewController *nicefaceViewController = [NicefaceViewController new];
    
    //遷移
    [self.navigationController pushViewController:nicefaceViewController animated:NO];
}


- (IBAction)return_Back:(id)sender {
    
//遷移元により遷移先を変更する
//    if ([_fromViewController isEqualToString:@"topmenu"]) {
//        //インスタンスを生成
//        NicefaceViewController *nicefaceViewController = [NicefaceViewController new];
//        
//        // Tab bar を非表示
//        nicefaceViewController.hidesBottomBarWhenPushed = YES;
//        
//        //遷移
//        [self.navigationController pushViewController:nicefaceViewController animated:YES];
//        
//        return;
//    }
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
