//
//  LocalNotificationManager.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/31.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import "LocalNotificationManager.h"
#import "DatabaseHelper.h"
#import "DeceasedDao.h"
#import "Deceased.h"
#import "UserDao.h"
#import "User.h"
#import "Define.h"
#import "CalcNoticeDay.h"
#import "Notification.h"
#import "Common.h"
#import "Notification.h"
#import "MemorialReceiveDao.h"

@implementation LocalNotificationManager

- (void)scheduleLocalNotifications {

    UIApplication* app = [UIApplication sharedApplication];

    // 通知されていないnotificationを取る
    NSArray* notificationsNow = [[NSArray alloc] initWithArray:app.scheduledLocalNotifications copyItems:YES];
    //通知バーの通知を削除したくないので、未来のLocalNotificationを一旦キャンセルする
    for (UILocalNotification* notifyNow in notificationsNow) {
        //userInfoを取得
        Notification *notification = [[Notification alloc] init];
        [notification setValuesForKeysWithDictionary:notifyNow.userInfo];

//NSLog(@"date:%@", notification.notice_date);
        //日付が今より未来のものを削除する
        if (![Common pastDay:notification.notice_date]) {
            [app cancelLocalNotification:notifyNow];
        }
    }
    
    //通知を設定していく...
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //故人様の命日を取得する
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    NSArray *deceaseds = [deceasedDao selectDeceased];
    
    //通知設定を取得する
    UserDao *userDAO = [UserDao userDaoWithMemorialDatabase:memorialDatabase];
    User *user = [userDAO selectUser];
    
    //データーベースを閉じる
    [memorialDatabase close];
    
    NSMutableArray *notifications = [NSMutableArray array];
    
    for (Deceased *deceased in deceaseds) {
        //命日１週間前通知を設定している場合
        if (user.notice_deathday_1week_before == NOTICE_YES) {
            //近々の命日１週間前を取得
            Notification *notificationDeathday1WeekBefore = [Notification alloc];
            notificationDeathday1WeekBefore.deceased_no = deceased.deceased_no;
            notificationDeathday1WeekBefore.notice_kind = NOTICE_DEATHDAY_1WEEK_BEFORE;
            notificationDeathday1WeekBefore.notice_date = [CalcNoticeDay getDeathday1WeekBefore:deceased.deceased_deathday hour:user.notice_time];
            [notifications addObject:notificationDeathday1WeekBefore];
        }
        //命日前日通知を設定している場合
        NSDate *dateDeathdayBefore = [[NSDate alloc] init];
        if (user.notice_deathday_before == NOTICE_YES) {
            //近々の命日前日を取得
            Notification *notificationDeathdayBefore = [Notification alloc];
            notificationDeathdayBefore.deceased_no = deceased.deceased_no;
            notificationDeathdayBefore.notice_kind = NOTICE_DEATHDAY_BEFORE;
            notificationDeathdayBefore.notice_date = [CalcNoticeDay getDeathdayBefore:deceased.deceased_deathday hour:user.notice_time];
            [notifications addObject:notificationDeathdayBefore];
            dateDeathdayBefore = [CalcNoticeDay getDeathdayBefore:deceased.deceased_deathday hour:user.notice_time];
        }
        //命日当日通知を設定している場合
        NSDate *dateDeathday = [[NSDate alloc] init];
        if (user.notice_deathday == NOTICE_YES) {
            //近々の命日当日を取得
            Notification *notificationDeathday = [Notification alloc];
            notificationDeathday.deceased_no = deceased.deceased_no;
            notificationDeathday.notice_kind = NOTICE_DEATHDAY;
            notificationDeathday.notice_date = [CalcNoticeDay getDeathday:deceased.deceased_deathday hour:user.notice_time];
            [notifications addObject:notificationDeathday];
            dateDeathday = [CalcNoticeDay getDeathday:deceased.deceased_deathday hour:user.notice_time];
        }
/*
        //月命日前日通知を設定している場合
        if (user.notice_month_deathday_before == NOTICE_YES) {
            //次から３回先までの月命日前日を取得
            for (int i = 1; i <= 3; i++) {
                Notification *notificationMonthDeathdayBefore = [Notification alloc];
                notificationMonthDeathdayBefore.deceased_no = deceased.deceased_no;
                notificationMonthDeathdayBefore.notice_kind = NOTICE_MONTH_DEATHDAY_BEFORE;
                notificationMonthDeathdayBefore.notice_date = [CalcNoticeDay getMonthDeathdayBefore:deceased.deceased_deathday hour:user.notice_time times:i];

                //命日前日通知を設定している場合、命日前日の月命日前日は通知しない
                NSDate *dateMonthDeathdayBefore = [CalcNoticeDay getMonthDeathdayBefore:deceased.deceased_deathday hour:user.notice_time times:i];
                if (!(user.notice_deathday_before == NOTICE_YES && [dateDeathdayBefore isEqualToDate:dateMonthDeathdayBefore])) {
                    [notifications addObject:notificationMonthDeathdayBefore];
                }
            }
        }
*/
        //月命日当日通知を設定している場合
        if (user.notice_month_deathday == NOTICE_YES) {
            //次から6回先までの月命日を取得
            for (int i = 1; i <= 6; i++) {
                Notification *notificationMonthDeathday = [Notification alloc];
                notificationMonthDeathday.deceased_no = deceased.deceased_no;
                notificationMonthDeathday.notice_kind = NOTICE_MONTH_DEATHDAY;
                notificationMonthDeathday.notice_date = [CalcNoticeDay getMonthDeathday:deceased.deceased_deathday hour:user.notice_time times:i];
                //命日当日通知を設定している場合、命日当日の月命日当日は通知しない
                NSDate *dateMonthDeathday = [CalcNoticeDay getMonthDeathday:deceased.deceased_deathday hour:user.notice_time times:i];
                if (user.notice_deathday == NOTICE_YES && [dateDeathday isEqualToDate:dateMonthDeathday]) {
                } else {
                    [notifications addObject:notificationMonthDeathday];
                }
            }
        }
        
        //法要予定日を100回忌まで取得
        NSArray *memorialdays = [CalcNoticeDay getMemorialArray:deceased.deceased_deathday time:user.notice_time];
        int countMemorialNo = 0;
        for (NSDate *memorialday in memorialdays) {
            countMemorialNo++;
            //法要３ヶ月前通知を設定している場合
            if (user.notice_memorial_3month_before == NOTICE_YES) {
                //法要３ヶ月前を取得
                NSDate *memorialday3MonthBefore = [CalcNoticeDay getMemorialdayMonthBefore:memorialday pastMonth:-3];
                if ([Common pastDay:memorialday3MonthBefore] == NO) {
                    Notification *notificationMemorialday3MonthBefore = [Notification alloc];
                    notificationMemorialday3MonthBefore.deceased_no = deceased.deceased_no;
                    notificationMemorialday3MonthBefore.notice_kind = NOTICE_MEMORIAL_3MONTH_BEFORE;
                    notificationMemorialday3MonthBefore.notice_date = memorialday3MonthBefore;
                    notificationMemorialday3MonthBefore.memorial_no = countMemorialNo;
                    [notifications addObject:notificationMemorialday3MonthBefore];
//                    NSLog(@"法要3ヶ月前：%@", memorialDay3MonthBefore);
                }
            }
            //法要1ヶ月前通知を設定している場合
            if (user.notice_memorial_1month_before == NOTICE_YES) {
                //法要１ヶ月前を取得
                NSDate *memorialday1MonthBefore = [CalcNoticeDay getMemorialdayMonthBefore:memorialday pastMonth:-1];
                if ([Common pastDay:memorialday1MonthBefore] == NO) {
                    Notification *notificationMemorialday1MonthBefore = [Notification alloc];
                    notificationMemorialday1MonthBefore.deceased_no = deceased.deceased_no;
                    notificationMemorialday1MonthBefore.notice_kind = NOTICE_MEMORIAL_1MONTH_BEFORE;
                    notificationMemorialday1MonthBefore.notice_date = memorialday1MonthBefore;
                    notificationMemorialday1MonthBefore.memorial_no = countMemorialNo;
                    [notifications addObject:notificationMemorialday1MonthBefore];
//                    NSLog(@"法要1ヶ月前：%@", memorialday1MonthBefore);
                }
            }
            //法要１週間前通知を設定している場合
            if (user.notice_memorial_1week_before == NOTICE_YES) {
                //法要１週間前を取得
                NSDate *memorialday1WeekBefore = [Common getAddDateDay:-7 withDate:memorialday];
                if ([Common pastDay:memorialday1WeekBefore] == NO) {
                    Notification *notificationMemorialday1WeekBefore = [Notification alloc];
                    notificationMemorialday1WeekBefore.deceased_no = deceased.deceased_no;
                    notificationMemorialday1WeekBefore.notice_kind = NOTICE_MEMORIAL_1WEEK_BEFORE;
                    notificationMemorialday1WeekBefore.notice_date = memorialday1WeekBefore;
                    notificationMemorialday1WeekBefore.memorial_no = countMemorialNo;
                    [notifications addObject:notificationMemorialday1WeekBefore];
//                    NSLog(@"法要1週間前：%@", memorialday1WeekBefore);
                }
            }
        }
    }

    //テストコード
//    Notification *notificationTest = [Notification alloc];
//    notificationTest.deceased_no = 99;
//    notificationTest.notice_kind = NOTICE_DEATHDAY;
//    notificationTest.notice_date = [[NSDate date] dateByAddingTimeInterval:60];
//    [notifications addObject:notificationTest];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"notice_date" ascending:YES];
    NSArray *sortedNotifications = [notifications sortedArrayUsingDescriptors:@[sortDescriptor]];
/*
    //デバック用ログ
    for (Notification *notification in sortedNotifications) {
        NSLog(@"故人No：%d　通知種別：%d　通知予定：%@　回忌：%d", notification.deceased_no, notification.notice_kind, [notification.notice_date initWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:notification.notice_date], notification.memorial_no);
    }
*/
    [self scheduleWork:sortedNotifications];
}

// weeklyWorkSchedule の時間を通知登録する
- (void)scheduleWork:(NSArray *) notifications {
    int noticeCount = 0;
    for (Notification *notification in notifications) {
        NSString *alertBody = [[NSString alloc] init];
        BOOL boolNoticeDeathday = NO;
        switch (notification.notice_kind) {
            case NOTICE_MONTH_DEATHDAY_BEFORE:
            case NOTICE_MONTH_DEATHDAY:
                alertBody = @"月命日のお知らせです";
                break;
            case NOTICE_DEATHDAY_1WEEK_BEFORE:
            case NOTICE_DEATHDAY_BEFORE:
            case NOTICE_DEATHDAY:
                boolNoticeDeathday = YES;
                alertBody = @"命日のお知らせです";
                break;
            case NOTICE_MEMORIAL_3MONTH_BEFORE:
            case NOTICE_MEMORIAL_1MONTH_BEFORE:
            case NOTICE_MEMORIAL_1WEEK_BEFORE:
                alertBody = @"法要のお知らせです";
                break;
            default:
                break;
        }
        
        NSDictionary *userInfo = [notification dictionaryWithValuesForKeys:[notification notificationKeys]];
        
        //makeNotification: を呼び出して通知を登録する
        [self makeNotification:notification.notice_date alertBody:alertBody userInfo:userInfo noticeDeathday:boolNoticeDeathday];
        
        noticeCount++;
        if (noticeCount > 64) {
            break;
        }
    }
    
    //法要受信テーブルに保存する
    [self insertMemorialReceive:notifications];
    
/*
//ログ出力
UIApplication* app = [UIApplication sharedApplication];
//通知されていないnotificationを取得
NSArray* notificationsNow = [[NSArray alloc] initWithArray:app.scheduledLocalNotifications copyItems:YES];
for (UILocalNotification* notifyNow in notificationsNow) {
    Notification *tempNotification = [[Notification alloc] init];
    [tempNotification setValuesForKeysWithDictionary:notifyNow.userInfo];
    NSLog(@"予約時間:%@", tempNotification.notice_date);
}
*/

}

- (void)makeNotification:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo noticeDeathday:(BOOL) boolNoticeDeathday {
//NSLog(@"fireDate:%@", fireDate);
    //現在より前の通知は設定しない
    if (fireDate == nil || [fireDate timeIntervalSinceNow] <= 0) {
        return;
    }
    [self schedule:fireDate alertBody:alertBody userInfo:userInfo noticeDeathday:boolNoticeDeathday];
}

- (void)schedule:(NSDate *) fireDate alertBody:(NSString *) alertBody userInfo:(NSDictionary *) userInfo noticeDeathday:(BOOL) boolNoticeDeathday {
    //ローカル通知を作成する
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:fireDate];
    [notification setTimeZone:[NSTimeZone systemTimeZone]];
    [notification setAlertBody:alertBody];
    [notification setUserInfo:userInfo];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setAlertAction:@"確認する"];
    
    //命日の通知の場合は毎年通知するように設定する
    if (boolNoticeDeathday) {
        [notification setTimeZone:[NSTimeZone localTimeZone]];
        [notification setRepeatInterval:NSCalendarUnitYear];
    }

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)insertMemorialReceive:(NSArray *)notifications {
    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    //セッションを開始する
    [memorialDatabase beginTransaction];
    
    MemorialReceiveDao *memorialReceiveDao = [MemorialReceiveDao memorialReceiveDaoWithMemorialDatabase:memorialDatabase];
/*
    //法要通知テーブルのレコードを全件削除
    if (![memorialReceiveDao deleteMemorialReceiveAll]) {
        //DBをロールバック
        [memorialDatabase rollback];
        //DBを閉じる
        [memorialDatabase close];
        return;
    }
*/
    //法要通知テーブルの未来のレコードを削除
    if (![memorialReceiveDao deleteMemorialReceiveFuture]) {
        //DBをロールバック
        [memorialDatabase rollback];
        //DBを閉じる
        [memorialDatabase close];
        return;
    }

    int noticeCount = 0;
    for (Notification *notification in notifications) {
        //法要通知テーブルに保存
        if (![memorialReceiveDao insertMemorialReceive:notification]) {
            //DBをロールバック
            [memorialDatabase rollback];
            //DBを閉じる
            [memorialDatabase close];
            return;
        }
        noticeCount++;
        if (noticeCount > 64) {
            break;
        }
    }
    //DBをコミット
    [memorialDatabase commit];
    //データーベースを閉じる
    [memorialDatabase close];
}

@end
