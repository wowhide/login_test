//
//  Define.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/11.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "Define.h"

@implementation Define

//タイトルバー
/* #FFFFFF */
const float TITLE_BG_COLOR_RED   = 1.00;
const float TITLE_BG_COLOR_GREEN = 1.00;
const float TITLE_BG_COLOR_BLUE  = 1.00;

//ツールバー
/* #4C5F20 */
const float TOOLBAR_BG_COLOR_RED   = 0.12;
const float TOOLBAR_BG_COLOR_GREEN = 0.37;
const float TOOLBAR_BG_COLOR_BLUE  = 0.20;

//タブバー
/* #4C5F20 */
const float MENU_BG_COLOR_RED   = 0.12;
const float MENU_BG_COLOR_GREEN = 0.37;
const float MENU_BG_COLOR_BLUE  = 0.20;

/* #f8f4e6 */
const float TEXTVIEW_BG_COLOR_RED   = 0.973;
const float TEXTVIEW_BG_COLOR_GREEN = 0.953;
const float TEXTVIEW_BG_COLOR_BLUE  = 0.902;

const float TEXT_COLOR_RED   = 1.00;
const float TEXT_COLOR_GREEN = 1.00;
const float TEXT_COLOR_BLUE  = 1.00;

//KEY
NSString *const KEY_DEVICE_TOKEN                = @"device_token";

//KEY_(会員番号)
NSString *const KEY_MEMBER_USER_ID              = @"member_id";
NSString *const KEY_MEMBER_APPLI_ID             = @"appli_id";
NSString *const KEY_MEMBER_USER_NAME            = @"member_name";
NSString *const KEY_MEMBER_ENTRY_DAY            = @"member_entryday";
NSString *const KEY_MEMBER_HALL_NAME            = @"member_hallname";

NSString *const KEY_RYOBO_PHOTO_PATh            = @"ryobo_photo_path";
NSString *const KEY_RYOBO_PHOTO_UPDATETIME      = @"ryobo_photo_updatetime";
NSString *const KEY_MEMBER_SENDAR_NAME          = @"member_sendar_name";
NSString *const KEY_MEMBER_SENDAR_CHECKBOX      = @"member_sendar_checkbox";

//ログイン成功
NSString *const KEY_MOVE_FIRST_TOPMENU          = @"move_first_topmenu";

//故人データダウンロード（共有）
NSString *const KEY_DECEASED_UPDATE_COUNT       = @"deceased_update_count";

//おはよう掲示板「発信者名」登録
NSString *const KEY_SENDER_SELF                 = @"sender_self";

//葬儀24時間受付
NSString *const KEY_SOUGI_TEL                   = @"sougi_tel";

NSString *const KEY_SENDER_GRANDFATHER_ONE      = @"sender_grandfather_one";
NSString *const KEY_SENDER_GRANDFATHER_TWO      = @"sender_grandfather_two";
NSString *const KEY_SENDER_GRANDFATHER_THREE    = @"sender_grandfather_three";
NSString *const KEY_SENDER_GRANDFATHER_FOUR     = @"sender_grandfather_four";
NSString *const KEY_SENDER_GRANDFATHER_FIVE     = @"sender_grandfather_five";

NSString *const KEY_SENDER_GRANDMATHER_ONE      = @"sender_grandmather_one";
NSString *const KEY_SENDER_GRANDMATHER_TWO      = @"sender_grandmather_two";
NSString *const KEY_SENDER_GRANDMATHER_THREE    = @"sender_grandmather_three";
NSString *const KEY_SENDER_GRANDMATHER_FOUR     = @"sender_grandmather_four";
NSString *const KEY_SENDER_GRANDMATHER_FIVE     = @"sender_grandmather_five";


//Localizeファイル名
NSString *const LOCALIZE_FILE = @"fixedSentenceNichiryoku";

//Notification名
NSString *const NOTICE_BARCODE_DOWNLOADED = @"barcode_image_download_complete";

//EC機能フラグ
const bool IS_EC_ACTIVE = YES;

//ポイント機能フラグ
const bool IS_POINT_ACTIVE = NO;

/* 葬儀社情報 */
NSString *const MORTICIAN_NAME    = @"ニチリョク";
NSString *const MORTICIAN_POST    = @"〒167-0023";
NSString *const MORTICIAN_ADDRESS = @"東京都杉並区上井草1-33-5";
NSString *const MORTICIAN_TEL     = @"03-3395-3001";
NSString *const MORTICIAN_URL     = @"http://www.nichiryoku.co.jp/";
NSString *const MORTICIAN_URL2    = @"http://www.aisaika.com/";

/* ======= アプリ内メッセージ ======= */
NSString *const MORTICIAN_NAME_SOUGI    = @"株式会社ニチリョク葬祭事業部";

/*タクシー会社_メールアドレス*/
NSString * const TAXI_MAIL_ADDRESS = @"yamayamato8@gmail.com";   //テスト用


/*店舗情報_地図*/
NSString * const MAP_PIN_TITLE  = @"ニチリョク";                         //テスト用

/* 法要アプリWeb-API URL */
//HTTPS
// NSString *const LOGIN_AUTH  = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/login";
// NSString *const GET_APPLIID  = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/getappliid";
// NSString *const SAVE_DEVICE_TOKEN  = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/saveiosdevicetoken";
// NSString *const SAVE_DEVICE_TOKEN_AND_DECEASED_ID = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/saveiosdevicetokenanddeceasedid";
// NSString *const GET_NOTICE_INFO    = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/getnoticeinfo";
// NSString *const VIEW_NOTICE_INFO   = @"https://memorial-srv.com/ms-nichiryoku/mng/viewnoticeinfo";
// NSString *const GET_NOTICE_INFO_TOKEN = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/getnoticeinfoanddeceasedid";
// NSString *const READ_TRANSFER_DATA = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/readtranseferdata";
// NSString *const DOWNLOAD_PHOTO     = @"https://memorial-srv.com/ms-nichiryoku/cooperation/downloadphoto";
// NSString *const DOWNLOAD_QR_PHOTO     = @"https://memorial-srv.com/ms-nichiryoku/cooperation/qrdownloadphototest";
// NSString *const SEND_DATA_KEY_MAIL = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/senddatakeymailios";
// NSString *const GET_NOTICE_INFO_DELIVERED = @"https://memorial-srv.com/ms-nichiryoku/cooperation/getnoticeinfodelivered";
// NSString *const GET_NOTICE_INFO_DELIVERED_TOKEN = @"https://memorial-srv.com/ms-nichiryoku/cooperation/getnoticeinfodeliveredbytoken";
// NSString *const SEND_MEMORIAL_MAIL = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/sendmemorialmailios";
// NSString *const SAVE_TRANSFER_DATA = @"https://memorial-srv.com/ms-nichiryoku/cooperation/savetransferdata";
// NSString *const UP_PHOTO = @"https://memorial-srv.com/ms-nichiryoku/cooperation/upphoto";
// NSString *const SYUKATSU = @"https://memorial-srv.com/ms-nichiryoku/Cooperation/syukatsuios";
// NSString *const READ_DECEASED_DATA = @"https://memorial-srv.com/ms-nichiryoku/cooperation/readdeceaseddata";
// NSString *const INSERT_DECEASED_NO = @"https://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistinsert";
// NSString *const UPDATE_DECEASED_NO = @"https://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistupdate";
// NSString *const UPDATE_DECEASED_ID = @"https://memorial-srv.com/ms-nichiryoku/cooperation/savetransferdata";
// NSString *const UPDATE_DECEASED_PHOTO = @"https://memorial-srv.com/ms-nichiryoku/cooperation/upphoto";
// NSString *const DELETE_DECEASED_ID = @"https://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistdelete";
// NSString *const DELETE_DECEASED_ID_LIST = @"https://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistarraydelete";
// NSString *const GET_MEMBER_ID = @"https://memorial-srv.com/ms-nichiryoku/cooperation/readmemberdata";
// NSString *const QR_FLG_IMG = @"https://memorial-srv.com/ms-nichiryoku/cooperation/readdeceasedimage";
// NSString *const NOT_QR_FLG_IMG = @"https://memorial-srv.com/ms-nichiryoku/cooperation/readappdeceasedimage";
// NSString *const NICEFACE_IMG = @"https://memorial-srv.com/ms-nichiryoku/cooperation/photodisp";
// NSString *const NICEFACE_NAME_CHECK = @"https://memorial-srv.com/ms-nichiryoku/cooperation/iosnameduplicationcheck";
// NSString *const NICEFACE_SEND = @"https://memorial-srv.com/ms-nichiryoku/cooperation/callsendone";
// NSString *const USERADD_SEND = @"https://memorial-srv.com/ms-nichiryoku/cooperation/calluseradd";
// NSString *const GET_RYOBO_IMG = @"https://memorial-srv.com/ms-nichiryoku/cooperation/readryoboimage";
// NSString *const GET_RYOBO_IMG_UPLOAD = @"https://memorial-srv.com/ms-nichiryoku/cooperation/upryobophoto";
// NSString *const UPLOAD_QR_DECEASED_PHOTO = @"https://memorial-srv.com/ms-nichiryoku/cooperation/qrphotoeditupload";
// NSString *const GET_DECEASED_UPDATE_COUNT = @"https://memorial-srv.com/ms-nichiryoku/cooperation/deceasedupdatecount";
// NSString *const UPDATE_DECEASED_UPDATE_COUNT = @"https://memorial-srv.com/ms-nichiryoku/cooperation/updatedeceasedupdatecount";
// NSString *const GET_RYOBOPHOTO_DOWNLOAD = @"https://memorial-srv.com/ms-nichiryoku/cooperation/memberdownloadphoto";
// NSString *const GET_EREA_TEL = @"https://memorial-srv.com/ms-nichiryoku/cooperation/getareatel";


//HTTP
//NSString *const LOGIN_AUTH    = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/login";
//NSString *const GET_APPLIID  = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/getappliid";
//NSString *const SAVE_DEVICE_TOKEN  = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/saveiosdevicetoken";
//NSString *const SAVE_DEVICE_TOKEN_AND_DECEASED_ID = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/saveiosdevicetokenanddeceasedid";
//NSString *const GET_NOTICE_INFO    = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/getnoticeinfo";
//NSString *const VIEW_NOTICE_INFO   = @"http://memorial-srv.com/ms-nichiryoku/mng/viewnoticeinfo";
//NSString *const GET_NOTICE_INFO_TOKEN = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/getnoticeinfoanddeceasedid";
//NSString *const READ_TRANSFER_DATA = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/readtranseferdata";
//NSString *const DOWNLOAD_PHOTO     = @"http://memorial-srv.com/ms-nichiryoku/cooperation/downloadphoto";
//NSString *const DOWNLOAD_QR_PHOTO     = @"http://memorial-srv.com/ms-nichiryoku/cooperation/qrdownloadphototest";
//NSString *const SEND_DATA_KEY_MAIL = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/senddatakeymailios";
//NSString *const GET_NOTICE_INFO_DELIVERED = @"http://memorial-srv.com/ms-nichiryoku/cooperation/getnoticeinfodelivered";
//NSString *const GET_NOTICE_INFO_DELIVERED_TOKEN = @"http://memorial-srv.com/ms-nichiryoku/cooperation/getnoticeinfodeliveredbytoken";
//NSString *const SEND_MEMORIAL_MAIL = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/sendmemorialmailios";
//NSString *const SAVE_TRANSFER_DATA = @"http://memorial-srv.com/ms-nichiryoku/cooperation/savetransferdata";
//NSString *const UP_PHOTO = @"http://memorial-srv.com/ms-nichiryoku/cooperation/upphoto";
//NSString *const SYUKATSU = @"http://memorial-srv.com/ms-nichiryoku/Cooperation/syukatsuios";
//NSString *const READ_DECEASED_DATA = @"http://memorial-srv.com/ms-nichiryoku/cooperation/readdeceaseddata";
//NSString *const INSERT_DECEASED_NO = @"http://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistinsert";
//NSString *const UPDATE_DECEASED_NO = @"http://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistupdate";
//NSString *const UPDATE_DECEASED_ID = @"http://memorial-srv.com/ms-nichiryoku/cooperation/savetransferdata";
//NSString *const UPDATE_DECEASED_PHOTO = @"http://memorial-srv.com/ms-nichiryoku/cooperation/upphoto";
//NSString *const DELETE_DECEASED_ID = @"http://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistdelete";
//NSString *const DELETE_DECEASED_ID_LIST = @"http://memorial-srv.com/ms-nichiryoku/cooperation/deceasedlistarraydelete";
//NSString *const GET_MEMBER_ID = @"http://memorial-srv.com/ms-nichiryoku/cooperation/readmemberdata";
//NSString *const QR_FLG_IMG = @"http://memorial-srv.com/ms-nichiryoku/cooperation/readdeceasedimage";
//NSString *const NOT_QR_FLG_IMG = @"http://memorial-srv.com/ms-nichiryoku/cooperation/readappdeceasedimage";
//NSString *const NICEFACE_IMG = @"http://memorial-srv.com/ms-nichiryoku/cooperation/photodisp";
//NSString *const NICEFACE_NAME_CHECK = @"http://memorial-srv.com/ms-nichiryoku/cooperation/iosnameduplicationcheck";
//NSString *const NICEFACE_SEND = @"http://memorial-srv.com/ms-nichiryoku/cooperation/callsendone";
//NSString *const USERADD_SEND = @"http://memorial-srv.com/ms-nichiryoku/cooperation/calluseradd";
//NSString *const GET_RYOBO_IMG = @"http://memorial-srv.com/ms-nichiryoku/cooperation/readryoboimage";
//NSString *const GET_RYOBO_IMG_UPLOAD = @"http://memorial-srv.com/ms-nichiryoku/cooperation/upryobophoto";
//NSString *const UPLOAD_QR_DECEASED_PHOTO = @"http://memorial-srv.com/ms-nichiryoku/cooperation/qrphotoeditupload";
//NSString *const GET_DECEASED_UPDATE_COUNT = @"http://memorial-srv.com/ms-nichiryoku/cooperation/deceasedupdatecount";
//NSString *const UPDATE_DECEASED_UPDATE_COUNT = @"http://memorial-srv.com/ms-nichiryoku/cooperation/updatedeceasedupdatecount";
//NSString *const GET_RYOBOPHOTO_DOWNLOAD = @"http://memorial-srv.com/ms-nichiryoku/cooperation/memberdownloadphoto";
//NSString *const GET_EREA_TEL = @"http://memorial-srv.com/ms-nichiryoku/cooperation/getareatel";

// テストサーバー用
NSString *const LOGIN_AUTH  = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/login";
NSString *const GET_APPLIID  = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/getappliid";
NSString *const SAVE_DEVICE_TOKEN  = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/saveiosdevicetoken";
NSString *const SAVE_DEVICE_TOKEN_AND_DECEASED_ID = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/saveiosdevicetokenanddeceasedid";
NSString *const GET_NOTICE_INFO    = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/getnoticeinfo";
NSString *const VIEW_NOTICE_INFO   = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/mng/viewnoticeinfo";
NSString *const GET_NOTICE_INFO_TOKEN = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/getnoticeinfoanddeceasedid";
NSString *const READ_TRANSFER_DATA = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/readtranseferdata";
NSString *const DOWNLOAD_PHOTO     = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/downloadphoto";
NSString *const DOWNLOAD_QR_PHOTO     = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/qrdownloadphototest";
NSString *const SEND_DATA_KEY_MAIL = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/senddatakeymailios";
NSString *const GET_NOTICE_INFO_DELIVERED = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/getnoticeinfodelivered";
NSString *const GET_NOTICE_INFO_DELIVERED_TOKEN = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/getnoticeinfodeliveredbytoken";
NSString *const SEND_MEMORIAL_MAIL = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/sendmemorialmailios";
NSString *const SAVE_TRANSFER_DATA = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/savetransferdata";
NSString *const UP_PHOTO = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/upphoto";
NSString *const SYUKATSU = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/Cooperation/syukatsuios";
NSString *const READ_DECEASED_DATA = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/readdeceaseddata";
NSString *const INSERT_DECEASED_NO = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/deceasedlistinsert";
NSString *const UPDATE_DECEASED_NO = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/deceasedlistupdate";
NSString *const UPDATE_DECEASED_ID = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/savetransferdata";
NSString *const UPDATE_DECEASED_PHOTO = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/upphoto";
NSString *const DELETE_DECEASED_ID = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/deceasedlistdelete";
NSString *const DELETE_DECEASED_ID_LIST = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/deceasedlistarraydelete";
NSString *const GET_MEMBER_ID = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/readmemberdata";
NSString *const QR_FLG_IMG = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/readdeceasedimage";
NSString *const NOT_QR_FLG_IMG = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/readappdeceasedimage";
NSString *const NICEFACE_IMG = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/photodisp";
NSString *const NICEFACE_NAME_CHECK = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/iosnameduplicationcheck";
NSString *const NICEFACE_SEND = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/callsendone";
NSString *const USERADD_SEND = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/calluseradd";
NSString *const GET_RYOBO_IMG = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/readryoboimage";
NSString *const GET_RYOBO_IMG_UPLOAD = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/upryobophoto";
NSString *const UPLOAD_QR_DECEASED_PHOTO = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/qrphotoeditupload";
NSString *const GET_DECEASED_UPDATE_COUNT = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/deceasedupdatecount";
NSString *const UPDATE_DECEASED_UPDATE_COUNT = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/updatedeceasedupdatecount";
NSString *const GET_RYOBOPHOTO_DOWNLOAD = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/memberdownloadphoto";
NSString *const GET_EREA_TEL = @"https://orange-camel-ed99a045e379757d.znlc.jp/ms-nichiryoku/cooperation/getareatel";

/* ポイント機能Web-API URL */
NSString *const POINT_ADD_USER    = @"http://ms-dev.memorial-site.net/cooperation/addpointuser";
NSString *const POINT_ADD_USER1   = @"http://ms-dev.memorial-site.net/cooperation/addautoaddpoint1";
NSString *const POINT_ADD_USER2   = @"http://ms-dev.memorial-site.net/cooperation/addautoaddpoint2";
NSString *const POINT_ADD_USER3   = @"http://ms-dev.memorial-site.net/cooperation/addautoaddpoint3";
NSString *const POINT_ADD_USER4   = @"http://ms-dev.memorial-site.net/cooperation/addautoaddpoint4";
NSString *const POINT_UPDATE_USER = @"http://ms-dev.memorial-site.net/cooperation/updatepersonalinfo";
NSString *const POINT_GET_USER    = @"http://ms-dev.memorial-site.net/cooperation/getpersonalinfo";
NSString *const SEARCH_ADDRESS    = @"http://point.memorial-site.net/point/getaddressfrompostalcode";
NSString *const GET_BARCODE       = @"http://point.memorial-site.net/point/generatebarcode";

/* 家系図機能Web-API URL */
NSString *const DESEASE_LIST_INSERT = @"http://wow-d.net/Family_Tree/orderpage/deceasedlistarrayinsert";
NSString *const DESEASE_LIST_DELETE = @"http://wow-d.net/Family_Tree/orderpage/deceasedlistarraydelete";




@end
