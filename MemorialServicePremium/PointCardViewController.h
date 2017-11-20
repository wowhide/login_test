//
//  PointCardViewController.h
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/17.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointUser.h"


@interface PointCardViewController : UIViewController
{
    BOOL observing;         //バーコードダウンロードイベント監視フラグ
    PointUser *userInfo;    //ポイント機能利用者情報
}
@property (weak, nonatomic) IBOutlet UIToolbar    *toolBar;             //上部ツールバー
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;          //コンテンツ部分のスクロールビュー
@property (weak, nonatomic) IBOutlet UIImageView  *barcodeView;         //バーコード表示
@property (weak, nonatomic) IBOutlet UIView       *userInfoView;        //利用者情報の枠線用
@property (weak, nonatomic) IBOutlet UILabel      *userIdLabel;         //利用者情報ラベル ID
@property (weak, nonatomic) IBOutlet UILabel      *nameLabel;           //利用者情報ラベル 氏名
@property (weak, nonatomic) IBOutlet UILabel      *birthdayLabel;       //利用者情報ラベル 生年月日
@property (weak, nonatomic) IBOutlet UIView       *pointView;           //ポイント情報の枠線用
@property (weak, nonatomic) IBOutlet UILabel      *pointLabel;          //ポイント表示ラベル
@property (weak, nonatomic) IBOutlet UIButton     *editUserInfoButton;  //利用者情報編集ボタン
@end