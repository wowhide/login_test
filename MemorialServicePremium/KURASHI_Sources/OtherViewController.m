//
//  OtherViewController.m
//  MemorialService
//
//  Created by pc131101 on 2014/01/09.
//  Copyright (c) 2014年 DIGITALSPACE WOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherViewController.h"
#import "DatabaseHelper.h"
#import "DeceasedDao.h"
#import "NoticeInfoListViewController.h"
#import "OtherHowToUseViewController.h"
#import "OtherDataTransferViewController.h"
#import "OtherFuneralViewController.h"
#import "OtherRuleViewController.h"
#import "Define.h"
#import "EcSiteViewController.h"
#import "PointUserInfoViewController.h"
#import "PointCardViewController.h"
#import "PointUser.h"
#import "BeautyCharacterViewController.h"
#import "LoupeViewController.h"
#import "TopMenuViewController.h"
#import "MenuTabBarViewController.h"


@interface OtherViewController () {
    NSString *_morticianName;
    NSString *_url;
    
    NSString *_menuItemNotice;
    NSString *_menuItemHowto;
    NSString *_menuItemBackup;
    NSString *_menuItemAboutUs;
    NSString *_menuItemSyukatu;
    NSString *_menuItemEcFlower;
    NSString *_menuItemEcLetter;
    NSString *_menuItemPoint;
    NSString *_menuItemTerms;
    NSString *_menuItemBeautycharacter;
    NSString *_menuItemLoupe;
    NSString *_menuItemTopMenu;


    NSMutableArray *_menuItemArray;
    NSMutableArray *_menuKeyArray;
    
    //選択されたデータを格納する配列（ポイント利用）
    NSMutableArray *selectedArray;
    
    //選択列No
    NSInteger pointNo;
}

@property (weak, nonatomic) IBOutlet UITableView *otherTable;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar_icon;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar_icon_two;
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end


/* メニュー項目キー */
static NSString *const MENU_KEY_NOTICE              = @"key_notice";
static NSString *const MENU_KEY_HOWTO               = @"key_howto";
static NSString *const MENU_KEY_BACKUP              = @"key_backup";
static NSString *const MENU_KEY_ABOUTUS             = @"key_aboutus";
static NSString *const MENU_KEY_SYUKATU             = @"key_syukatu";
static NSString *const MENU_KEY_EC_FLOWER           = @"key_ec_flower";
static NSString *const MENU_KEY_EC_LETTER           = @"key_ec_letter";
static NSString *const MENU_KEY_POINT               = @"key_point";
static NSString *const MENU_KEY_TERMS               = @"key_terms";
static NSString *const MENU_KEY_BEATY_CHARACTER     = @"key_beaty_character";
static NSString *const MENU_KEY_LOUPE               = @"key_loupe";
static NSString *const MENU_KEY_TOP_MENU            = @"key_top_menu";




@implementation OtherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //メニュー文字列の初期化
    _menuItemNotice   = @"お知らせ";
    _menuItemHowto    = @"使い方";
    _menuItemBackup   = @"機種変更する場合";
    _menuItemAboutUs  = [NSString stringWithFormat:@"%@について", MORTICIAN_NAME];
    _menuItemSyukatu  = @"終活のすすめ";
    _menuItemEcFlower = @"供花や供物をご注文";
    _menuItemEcLetter = @"弔電及び喪中はがき印刷のご注文";
    _menuItemPoint    = @"ポイント利用";
    _menuItemTerms    = @"利用規約";
    _menuItemBeautycharacter = @"美文字";
    _menuItemLoupe    = @"ルーペ";
    _menuItemTopMenu    = @"トップメニュー";



    
    //解像度に合わせてViewサイズを変更
    [self.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.otherTable setDataSource:self];
    [self.otherTable setDelegate:self];
    
    //ルートタブビューを隠す
    self.tabBarController.tabBar.hidden = YES;
    //タブビューのアイコン
    self.tabBar_icon.image = [UIImage imageNamed:@"tab_deceased_list"];
    //タブビュータイトル
    self.tabBar_icon.title = @"メニュー";
    
    //タブビューのアイコン
    self.tabBar_icon_two.image = [UIImage imageNamed:@"tab_other"];
    //タブビュータイトル
    self.tabBar_icon_two.title = @"その他";
    //
    self.tabbar.delegate = self;


    //DBに接続する
    DatabaseHelper *databaseHelper = [[DatabaseHelper alloc]init];
    FMDatabase *memorialDatabase = databaseHelper.memorialDatabase;
    
    //QRコードから読み込んだ故人様情報が存在するかチェック
    DeceasedDao *deceasedDao = [DeceasedDao deceasedDaoWithMemorialDatabase:memorialDatabase];
    BOOL boolQrDeceased = deceasedDao.existenceQrDeceased;
    
    //DBを閉じる
    [memorialDatabase close];
    
    if (boolQrDeceased) {
        //葬儀社情報が登録されている場合
        //葬儀社名をインスタンス変数に設定
        _morticianName = MORTICIAN_NAME;
        //終活のすすめのURLを生成してインスタンス変数に設定
        _url = [SYUKATSU stringByAppendingFormat:@"?mno=%d", MORTICIAN_NO];
    } else {
        //葬儀社情報が登録されていない場合
        //葬儀社名をインスタンス変数に設定
        _morticianName = @"";
        //終活のすすめのURLを生成してインスタンス変数に設定
        _url = [SYUKATSU stringByAppendingFormat:@"?mno=%d", 3];
    }
    
    //テーブルに表示するメニューをArrayに指定
    _menuItemArray = [NSMutableArray array];
    _menuKeyArray  = [NSMutableArray array];
    
//    [_menuItemArray addObject:_menuItemNotice];
//    [_menuKeyArray  addObject:MENU_KEY_NOTICE];
    
//    [_menuItemArray addObject:_menuItemHowto];
//    [_menuKeyArray  addObject:MENU_KEY_HOWTO];
    
    [_menuItemArray addObject:_menuItemBackup];
    [_menuKeyArray  addObject:MENU_KEY_BACKUP];
    
//    if (boolQrDeceased) {
//        [_menuItemArray addObject:_menuItemAboutUs];
//        [_menuKeyArray  addObject:MENU_KEY_ABOUTUS];
//    }
//    
    [_menuItemArray addObject:_menuItemSyukatu];
    [_menuKeyArray  addObject:MENU_KEY_SYUKATU];
    
    [_menuItemArray addObject:_menuItemTerms];
    [_menuKeyArray  addObject:MENU_KEY_TERMS];

    //テーブルを読み込み直す
    [self.otherTable reloadData];
}

- (void)tabBar:(UITabBar*)tabBar didSelectItem:(UITabBarItem*)item{
    
    //切り替えに応じた処理
    if (item.tag == 0) {
        
        
    }else if (item.tag == 1) {
        //トップメニュー画面のインスタンスを生成
        MenuTabBarViewController *menutabBarViewController = [MenuTabBarViewController new];
        
        // Tab bar を非表示
        //トップメニュー画面に遷移
        [self.navigationController pushViewController:menutabBarViewController animated:NO];

    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuKeyArray.count;
}

//セルの取得時
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //テーブルのセルの生成
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OtherCell"];
    }
    
    //セルに項目を表示
    NSString *menuIndex = [NSString stringWithFormat:@"%ld．", (long)indexPath.row + 1];
    cell.textLabel.text = [menuIndex stringByAppendingString:[_menuItemArray objectAtIndex:indexPath.row]];

    
    //矢印を表示
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//ヘッダータイトルの背景色変更
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [view setTintColor:[UIColor colorWithRed:MENU_BG_COLOR_RED green:MENU_BG_COLOR_GREEN blue:MENU_BG_COLOR_BLUE alpha:1.0]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle;
    
    switch(section) {
        case 0: // 1個目のセクションの場合
            headerTitle = @"その他";
            break;
            
        default:
            headerTitle = nil;
    }
    
    return headerTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //テーブルの選択状態を解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //画面遷移を分岐
    NSString *selectedKey = [_menuKeyArray objectAtIndex:indexPath.row];
    
    //お知らせ
    if ([selectedKey compare:MENU_KEY_NOTICE] == NSOrderedSame) {
        //お知らせ画面のインスタンスを生成
        NoticeInfoListViewController *noticeInfoListViewController = [NoticeInfoListViewController new];
        //お知らせ画面に遷移
        [self.navigationController pushViewController:noticeInfoListViewController animated:YES];
        
        return;
    }
    
    //使い方
    if ([selectedKey compare:MENU_KEY_HOWTO] == NSOrderedSame) {
        //使い方画面のインスタンスを生成
        OtherHowToUseViewController *otherHowToUseViewController = [OtherHowToUseViewController new];
        
        // Tab bar を非表示
        otherHowToUseViewController.hidesBottomBarWhenPushed = YES;
        
        
        //使い方画面に遷移
        [self.navigationController pushViewController:otherHowToUseViewController animated:YES];
        
        return;
    }
    
    //機種変更する場合
    if ([selectedKey compare:MENU_KEY_BACKUP] == NSOrderedSame) {
        //データ引き継ぎ画面のインスタンスを生成
        OtherDataTransferViewController *otherDataTransferViewController = [OtherDataTransferViewController new];
        
        // Tab bar を非表示
        otherDataTransferViewController.hidesBottomBarWhenPushed = YES;
        
        //データ引き継ぎ画面に遷移
        [self.navigationController pushViewController:otherDataTransferViewController animated:YES];
        
        return;
    }
    
    //葬儀社について
    if ([selectedKey compare:MENU_KEY_ABOUTUS] == NSOrderedSame) {
        //葬儀社情報画面のインスタンスを生成
        OtherFuneralViewController *otherFuneralViewController = [OtherFuneralViewController new];
        //葬儀社情報画面に遷移
        [self.navigationController pushViewController:otherFuneralViewController animated:YES];
        
        return;
    }
    
    //終活のすすめ
    if ([selectedKey compare:MENU_KEY_SYUKATU] == NSOrderedSame) {
        //終活のすすめページをブラウザで表示
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
        
        return;
    }
    
    //供花や供物をご注文
    if ([selectedKey compare:MENU_KEY_EC_FLOWER] == NSOrderedSame) {
        //供花・供物のご注文ページをwebviewで表示
        EcSiteViewController *ecSiteViewController = [[EcSiteViewController alloc] init];
        ecSiteViewController.url = @"http://www.google.co.jp/";
        //モーダルで開く
        ecSiteViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.view.window.rootViewController presentViewController:ecSiteViewController animated:YES completion:nil];
        
        return;
    }
    
    //弔電及び喪中はがき印刷のご注文
    if ([selectedKey compare:MENU_KEY_EC_LETTER] == NSOrderedSame) {
        return;
    }
    
    //ポイント利用
    if ([selectedKey compare:MENU_KEY_POINT] == NSOrderedSame) {
        
        NSString *cellString =@"ポイント利用";
        
        //「ポイント利用」列を取得し、pointNoに格納
        if ([_menuItemArray indexOfObject:cellString]) {
            pointNo = [_menuItemArray indexOfObject:cellString];
        }
        
        NSString *cellStr =[_menuItemArray objectAtIndex:pointNo];
        
         NSLog(@"ポイント選択:%@",cellStr);
        if (![selectedArray containsObject:cellStr]) {
            selectedArray = [@[cellStr] mutableCopy];
            
            //NSString *test = selectedArray[0];
            //NSLog(@"配列ポイント:%@",test);
        }
        
        [tableView reloadData];
        
        [self.navigationController pushViewController:[self getPointViewController] animated:YES];
        
        return;
    }
    
    //利用規約
    if ([selectedKey compare:MENU_KEY_TERMS] == NSOrderedSame) {
        //利用規約画面のインスタンスを生成
        OtherRuleViewController *otherRuleViewController = [OtherRuleViewController new];
        
        // Tab bar を非表示
        otherRuleViewController.hidesBottomBarWhenPushed = YES;
        //利用規約画面に遷移
        [self.navigationController pushViewController:otherRuleViewController animated:YES];
        
        return;
    }

}

//ポイント機能画面のインスタンスを取得する
- (UIViewController*)getPointViewController
{
    UIViewController *viewController;
    PointUser *userInfo = [PointUser new];
    [userInfo loadUserDefaults];
    
    if (userInfo.userName.length > 0 || userInfo.isSkip) {
        viewController = [PointCardViewController new];
    } else {
        viewController = [PointUserInfoViewController new];
    }
    
    return viewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
