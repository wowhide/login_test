//
//  Define.h
//  MemorialService
//
//  Created by pc131101 on 2014/01/11.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]



#define TOAST_DURATION_NOTICE 1.5
#define TOAST_DURATION_ERROR 2.0

#define CAMERA_RESTART_DURATION 0.4

#define QR_READ_VIEW_FROM_INITIAL_SETTING 1
#define QR_READ_VIEW_FROM_DECEASED_LIST 2

#define QR_FLG_YES 1
#define QR_FLG_NO -1

#define NOTICE_YES 1
#define NOTICE_NO -1

#define NOTICE_TIMING_ACTIVE 1
#define NOTICE_TIMING_PASSIVE 2

#define KG_FLG_NOTHING 0
#define KG_FLG_KYONEN 1
#define KG_FLG_GYONEN 2
#define KG_FLG_MAN 3

#define IMAGE_REDUCTION_SIZE 800

//通知種別
#define NOTICE_MONTH_DEATHDAY_BEFORE 1
#define NOTICE_MONTH_DEATHDAY 2
#define NOTICE_DEATHDAY_1WEEK_BEFORE 3
#define NOTICE_DEATHDAY_BEFORE 4
#define NOTICE_DEATHDAY 5
#define NOTICE_MEMORIAL_3MONTH_BEFORE 6
#define NOTICE_MEMORIAL_1MONTH_BEFORE 7
#define NOTICE_MEMORIAL_1WEEK_BEFORE 8

//通知フラグ
#define NOTICE_FLG_MEMORIAL 1
#define NOTICE_FLG_NOTICE 2
#define NOTICE_FLG_CALL 3
#define NOTICE_FLG_USERADD 4

#define NOTICE_FLG_NO -1

//葬儀社情報
#define MORTICIAN_NO 3

//通知情報登録方法
#define ENTRY_METHOD_INPUT 1
#define ENTRY_METHOD_URL 2

//画面部品の色
extern const float TITLE_BG_COLOR_RED;
extern const float TITLE_BG_COLOR_GREEN;
extern const float TITLE_BG_COLOR_BLUE;

extern const float TOOLBAR_BG_COLOR_RED;
extern const float TOOLBAR_BG_COLOR_GREEN;
extern const float TOOLBAR_BG_COLOR_BLUE;

extern const float MENU_BG_COLOR_RED;
extern const float MENU_BG_COLOR_GREEN;
extern const float MENU_BG_COLOR_BLUE;

extern const float TEXTVIEW_BG_COLOR_RED;
extern const float TEXTVIEW_BG_COLOR_GREEN;
extern const float TEXTVIEW_BG_COLOR_BLUE;

extern const float TEXT_COLOR_RED;
extern const float TEXT_COLOR_GREEN;
extern const float TEXT_COLOR_BLUE;

@interface Define : NSObject

//KEY
extern NSString * const KEY_DEVICE_TOKEN;


//KEY_会員番号
extern NSString * const KEY_MEMBER_USER_ID;
extern NSString * const KEY_MEMBER_APPLI_ID;
extern NSString * const KEY_MEMBER_USER_NAME;
extern NSString * const KEY_MEMBER_ENTRY_DAY;
extern NSString * const KEY_MEMBER_HALL_NAME;
extern NSString * const KEY_RYOBO_PHOTO_PATh;
extern NSString * const KEY_RYOBO_PHOTO_UPDATETIME;
extern NSString * const KEY_MEMBER_SENDAR_NAME;
extern NSString * const KEY_MEMBER_SENDAR_CHECKBOX;

//ログイン成功
extern NSString * const KEY_MOVE_FIRST_TOPMENU;

//故人データダウンロード（共有）
extern NSString * const KEY_DECEASED_UPDATE_COUNT;


//おはよう掲示板「発信者名」登録
extern NSString * const KEY_SENDER_SELF;

//葬儀24時間受付
extern NSString * const KEY_SOUGI_TEL;

extern NSString * const KEY_SENDER_GRANDFATHER_ONE;
extern NSString * const KEY_SENDER_GRANDFATHER_TWO;
extern NSString * const KEY_SENDER_GRANDFATHER_THREE;
extern NSString * const KEY_SENDER_GRANDFATHER_FOUR;
extern NSString * const KEY_SENDER_GRANDFATHER_FIVE;

extern NSString * const KEY_SENDER_GRANDMATHER_ONE;
extern NSString * const KEY_SENDER_GRANDMATHER_TWO;
extern NSString * const KEY_SENDER_GRANDMATHER_THREE;
extern NSString * const KEY_SENDER_GRANDMATHER_FOUR;
extern NSString * const KEY_SENDER_GRANDMATHER_FIVE;


//Localizeファイル名
extern NSString * const LOCALIZE_FILE;

//Notification名
extern NSString * const NOTICE_BARCODE_DOWNLOADED;

//EC機能フラグ
extern const bool IS_EC_ACTIVE;

//ポイント機能フラグ
extern const bool IS_POINT_ACTIVE;

//葬儀社情報
extern NSString * const MORTICIAN_NAME;
extern NSString * const MORTICIAN_POST;
extern NSString * const MORTICIAN_ADDRESS;
extern NSString * const MORTICIAN_TEL;
extern NSString * const MORTICIAN_POST2;
extern NSString * const MORTICIAN_ADDRESS2;
extern NSString * const MORTICIAN_TEL2;
extern NSString * const MORTICIAN_URL;
extern NSString * const MORTICIAN_HOLL_NAME;
extern NSString * const MORTICIAN_ONE_ADDRESS;
extern NSString * const MORTICIAN_FAX;
extern NSString * const MORTICIAN_TWO_HOLL_NAME;
extern NSString * const MORTICIAN_TWO_TEL;
extern NSString * const MORTICIAN_TWO_FAX;
extern NSString * const MORTICIAN_TWO_ADDRESS;
extern NSString * const MORTICIAN_URL2;


/* ======= アプリ内メッセージ ======= */
extern NSString * const MORTICIAN_NAME_SOUGI;
//タクシー会社_メールアドレス
extern NSString * const TAXI_MAIL_ADDRESS;

//店舗情報-地図
#define MAP_CENTER_LAT  35.671462       // 地図中心位置緯度
#define MAP_CENTER_LON 139.723891       // 地図中心位置軽度
#define MAP_PIN_LAT     35.671462       // 地図ピン位置緯度
#define MAP_PIN_LON    139.723891       // 地図ピン位置軽度
extern NSString * const MAP_PIN_TITLE;

//法要アプリWeb-API URL
extern NSString * const LOGIN_AUTH;
extern NSString * const GET_APPLIID;
extern NSString * const SAVE_DEVICE_TOKEN;
extern NSString * const SAVE_DEVICE_TOKEN_AND_DECEASED_ID;
extern NSString * const GET_NOTICE_INFO;
extern NSString * const GET_NOTICE_INFO_TOKEN;
extern NSString * const VIEW_NOTICE_INFO;
extern NSString * const READ_TRANSFER_DATA;
extern NSString * const DOWNLOAD_PHOTO;
extern NSString * const DOWNLOAD_QR_PHOTO;
extern NSString * const SEND_DATA_KEY_MAIL;
extern NSString * const GET_NOTICE_INFO_DELIVERED;
extern NSString * const GET_NOTICE_INFO_DELIVERED_TOKEN;
extern NSString * const SEND_MEMORIAL_MAIL;
extern NSString * const SAVE_TRANSFER_DATA;
extern NSString * const UP_PHOTO;
extern NSString * const SYUKATSU;
extern NSString * const READ_DECEASED_DATA;
extern NSString * const STORE_WEBSITE;
extern NSString * const INSERT_DECEASED_NO;
extern NSString * const UPDATE_DECEASED_NO;
extern NSString * const UPDATE_DECEASED_ID;
extern NSString * const UPDATE_DECEASED_PHOTO;
extern NSString * const DELETE_DECEASED_ID;
extern NSString * const DELETE_DECEASED_ID_LIST;
extern NSString * const GET_MEMBER_ID;
extern NSString * const QR_FLG_IMG;
extern NSString * const NICEFACE_NAME_CHECK;
extern NSString * const NOT_QR_FLG_IMG;
extern NSString * const NICEFACE_IMG;
extern NSString * const NICEFACE_SEND;
extern NSString * const USERADD_SEND;
extern NSString * const GET_RYOBO_IMG;
extern NSString * const GET_RYOBO_IMG_UPLOAD;
extern NSString * const UPLOAD_QR_DECEASED_PHOTO;
extern NSString * const GET_DECEASED_UPDATE_COUNT;
extern NSString * const UPDATE_DECEASED_UPDATE_COUNT;
extern NSString * const GET_RYOBOPHOTO_DOWNLOAD;
extern NSString * const GET_EREA_TEL;

//ポイント機能Web-API URL
extern NSString * const POINT_ADD_USER;
extern NSString * const POINT_ADD_USER1;
extern NSString * const POINT_ADD_USER2;
extern NSString * const POINT_ADD_USER3;
extern NSString * const POINT_ADD_USER4;
extern NSString * const POINT_UPDATE_USER;
extern NSString * const POINT_GET_USER;
extern NSString * const SEARCH_ADDRESS;
extern NSString * const GET_BARCODE;

//家系図機能Web-API URL
extern NSString * const DESEASE_LIST_INSERT;
extern NSString * const DESEASE_LIST_DELETE;




@end
