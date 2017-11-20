//
//  PointUserInfoViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/11.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ポイント機能個人情報入力画面
 */
@interface PointUserInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    BOOL observing_;            //キーボード表示イベント監視中フラグ
    float initialTableHeight;   //UITableViewの初期高さ
    NSString *name;             //氏名一時保存
    NSString *birthday;         //生年月日一時保存
    NSString *postalcode;       //郵便番号一時保存
    NSString *address;          //住所一時保存
    NSString *tel;              //電話番号一時保存
}

/* InterfaceBuilderで定義したオブジェクト */
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;                //上部ツールバー
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;     //戻るボタン
@property (weak, nonatomic) IBOutlet UIBarButtonItem *executeButton;    //実行ボタン
@property (weak, nonatomic) IBOutlet UITableView *tableView;            //UITextFieldを埋め込んだUITableView
/* ソースコードから生成したオブジェクト */
@property (weak, nonatomic) IBOutlet UITextField *nameField;            //氏名用UITextField
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;        //生年月日用UITextField
@property (weak, nonatomic) IBOutlet UITextField *postalcodeField;      //郵便番号用UITextField
@property (weak, nonatomic) IBOutlet UITextField *addressField;         //住所用UITextField
@property (weak, nonatomic) IBOutlet UITextField *telField;             //電話番号用UITextField

@end