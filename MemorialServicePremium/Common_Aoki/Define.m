//
//  Define.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/11.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "../Common/Define.h"

@implementation Define

/* #bce2e8 */
const float TITLE_BG_COLOR_RED   = 0.737;
const float TITLE_BG_COLOR_GREEN = 0.886;
const float TITLE_BG_COLOR_BLUE  = 0.910;

/* #9ea1a3 */
const float TOOLBAR_BG_COLOR_RED   = 0.000;
const float TOOLBAR_BG_COLOR_GREEN = 0.451;
const float TOOLBAR_BG_COLOR_BLUE  = 0.659;

/* #0073a8 */
const float MENU_BG_COLOR_RED   = 0.620;
const float MENU_BG_COLOR_GREEN = 0.631;
const float MENU_BG_COLOR_BLUE  = 0.639;

/* #f8f4e6 */
const float TEXTVIEW_BG_COLOR_RED   = 0.973;
const float TEXTVIEW_BG_COLOR_GREEN = 0.957;
const float TEXTVIEW_BG_COLOR_BLUE  = 0.902;

const float TEXT_COLOR_RED   = 0.984;
const float TEXT_COLOR_GREEN = 0.980;
const float TEXT_COLOR_BLUE  = 0.961;

NSString *const KEY_DEVICE_TOKEN   = @"device_token";

NSString *const LOCALIZE_FILE      = @"fixedSentenceAoki";

NSString *const MORTICIAN_NAME     = @"株式会社あおき";
NSString *const MORTICIAN_POST     = @"961-0936";
NSString *const MORTICIAN_ADDRESS  = @"福島県白河市大工町33";
NSString *const MORTICIAN_TEL      = @"0248-22-5231";
NSString *const MORTICIAN_POST2    = @"963-0201";
NSString *const MORTICIAN_ADDRESS2 = @"福島県郡山市大槻町字仙海東6-5";
NSString *const MORTICIAN_TEL2     = @"024-962-0311";
NSString *const MORTICIAN_URL      = @"http://aokisaien.com";

NSString *const SAVE_DEVICE_TOKEN  = @"http://ms-aoki.memorial-site.net/Cooperation/saveiosdevicetoken";
NSString *const SAVE_DEVICE_TOKEN_AND_DECEASED_ID = @"http://ms-aoki.memorial-site.net/Cooperation/saveiosdevicetokenanddeceasedid";
NSString *const GET_NOTICE_INFO    = @"http://ms-aoki.memorial-site.net/Cooperation/getnoticeinfo";
NSString *const VIEW_NOTICE_INFO   = @"http://ms-aoki.memorial-site.net/mng/viewnoticeinfo";
NSString *const GET_NOTICE_INFO_TOKEN = @"http://ms-aoki.memorial-site.net/Cooperation/getnoticeinfoanddeceasedid";
NSString *const READ_TRANSFER_DATA = @"http://ms-aoki.memorial-site.net/Cooperation/readtranseferdata";
NSString *const DOWNLOAD_PHOTO     = @"http://ms-aoki.memorial-site.net/cooperation/downloadphoto";
NSString *const SEND_DATA_KEY_MAIL = @"http://ms-aoki.memorial-site.net/Cooperation/senddatakeymailios";
NSString *const GET_NOTICE_INFO_DELIVERED = @"http://ms-aoki.memorial-site.net/cooperation/getnoticeinfodelivered";
NSString *const GET_NOTICE_INFO_DELIVERED_TOKEN = @"http://ms-aoki.memorial-site.net/cooperation/getnoticeinfodeliveredbytoken";
NSString *const SEND_MEMORIAL_MAIL = @"http://ms-aoki.memorial-site.net/Cooperation/sendmemorialmailios";
NSString *const SAVE_TRANSFER_DATA = @"http://ms-aoki.memorial-site.net/cooperation/savetransferdata";
NSString *const UP_PHOTO = @"http://ms-aoki.memorial-site.net/cooperation/upphoto";
NSString *const SYUKATSU = @"http://ms-aoki.memorial-site.net/Cooperation/syukatsuios";
NSString *const READ_DECEASED_DATA = @"http://ms-aoki.memorial-site.net/cooperation/readdeceaseddata";

//NSString *const SAVE_DEVICE_TOKEN  = @"http://ms-dev.memorial-site.net/Cooperation/saveiosdevicetoken";
//NSString *const SAVE_DEVICE_TOKEN_AND_DECEASED_ID = @"http://ms-dev.memorial-site.net/Cooperation/saveiosdevicetokenanddeceasedid";
//NSString *const GET_NOTICE_INFO    = @"http://ms-dev.memorial-site.net/Cooperation/getnoticeinfo";
//NSString *const VIEW_NOTICE_INFO   = @"http://ms-dev.memorial-site.net/mng/viewnoticeinfo";
//NSString *const GET_NOTICE_INFO_TOKEN = @"http://ms-dev.memorial-site.net/Cooperation/getnoticeinfoanddeceasedid";
//NSString *const READ_TRANSFER_DATA = @"http://ms-dev.memorial-site.net/Cooperation/readtranseferdata";
//NSString *const DOWNLOAD_PHOTO     = @"http://ms-dev.memorial-site.net/cooperation/downloadphoto";
//NSString *const SEND_DATA_KEY_MAIL = @"http://ms-dev.memorial-site.net/Cooperation/senddatakeymailios";
//NSString *const GET_NOTICE_INFO_DELIVERED = @"http://ms-dev.memorial-site.net/cooperation/getnoticeinfodelivered";
//NSString *const GET_NOTICE_INFO_DELIVERED_TOKEN = @"http://ms-dev.memorial-site.net/cooperation/getnoticeinfodeliveredbytoken";
//NSString *const SEND_MEMORIAL_MAIL = @"http://ms-dev.memorial-site.net/Cooperation/sendmemorialmailios";
//NSString *const SAVE_TRANSFER_DATA = @"http://ms-dev.memorial-site.net/cooperation/savetransferdata";
//NSString *const UP_PHOTO = @"http://ms-dev.memorial-site.net/cooperation/upphoto";
//NSString *const SYUKATSU = @"http://ms-dev.memorial-site.net/Cooperation/syukatsuios";
//NSString *const READ_DECEASED_DATA = @"http://ms-dev.memorial-site.net/cooperation/readdeceaseddata";

@end
