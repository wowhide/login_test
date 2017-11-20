//
//  TaxiViewController.m
//  MemorialServicePremium
//
//  Created by yamatohideyoshi on 2016/02/02.
//  Copyright © 2016年 DIGITALSPACE WOW. All rights reserved.
//

#import "TaxiViewController.h"
#import "Define.h"
#import "PointUser.h"
#import "PointUserInfoViewController.h"


@interface TaxiViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *UserInfo;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar_Bottom;

@end

@implementation TaxiViewController{
    CLLocationManager *_manager;
    //UserDefault
    PointUser *user;
   
@private
     double latitude;          //緯度
     double longitude;         //経度
    NSString *address;         //住所
}

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
    
    //ツールバーの背景色と文字色を設定(下）
    self.toolBar_Bottom.barTintColor = [UIColor colorWithRed:TOOLBAR_BG_COLOR_RED green:TOOLBAR_BG_COLOR_GREEN blue:TOOLBAR_BG_COLOR_BLUE alpha:1.0];
    
    self.toolBar_Bottom.tintColor = [UIColor colorWithRed:TEXT_COLOR_RED green:TEXT_COLOR_GREEN blue:TEXT_COLOR_BLUE alpha:1.0];
    
    //現在地に青色マーク
    self.mapView.showsUserLocation      = YES;
    //建物の境界線を表示
    self.mapView.showsBuildings         = YES;
    //飲食店などの情報アイコンを表示
    self.mapView.showsPointsOfInterest  = YES;
    
    //緯度・経度取得
    _manager = [CLLocationManager new];
    [_manager setDelegate:self];
    
    
    
    // iOS8対応
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending) {
        // iOS7 以前の緯度・経度取得
        
        //NSLog(@"iOS7");
    } else {
        // iOS8 以前の緯度・経度取得
        [_manager requestWhenInUseAuthorization];
        
    }
    
    //位置情報更新
    [_manager startUpdatingLocation];
    
    
    // 位置情報更新間隔
    _manager.distanceFilter = 500;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    user = [PointUser new];
    
    //名前
    [user loadUserDefaults];
    
    if (user.userName.length > 0) {
        [self.UserInfo setTitle:@"情報編集" forState:UIControlStateNormal];
        
    }
    
    
}

//位置情報取得メソッド
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //位置情報を取り出す
    CLLocation *newLocation = [locations lastObject];
    CLLocationCoordinate2D lating = newLocation.coordinate;
    
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(lating, 500, 500);
    _mapView.region = reg;

    // アノテーションを生成し、表示
    MKPointAnnotation* ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = lating;
    ann.title = @"現在地";
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:ann];
    
    
    //緯度
    latitude = newLocation.coordinate.latitude;
    
    //経度
    longitude = newLocation.coordinate.longitude;
    
    // 逆ジオコーディング
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray* placemarks, NSError* error) {
                       
                       if(error){
                           // エラーが発生している
                           NSLog(@"エラー %@", error);
                       } else {
                           if ([placemarks count] > 0) {
                               //最終的な文字列
                               line =@"";
                               // 住所取得成功
                               CLPlacemark *placemark = (CLPlacemark *)[placemarks lastObject];
                               //                              NSLog(@"%@,%@,%@,%@", placemark.administrativeArea,placemark.thoroughfare,placemark.subThoroughfare,placemark.thoroughfare );
                               
                               //より詳細な住所はaddressDictionaryに隠されている
                               NSDictionary *dict = placemark.addressDictionary;
                               //NSDictionaryより値を取得
                               //都道府県
                               NSString *state = [dict objectForKey:@"State"];
                               //市町村
                               //NSString *city = [dict objectForKey:@"City"];
                               //NSString *name = [dict objectForKey:@"Name"];
                               
                               //住所生成
                               address = [state stringByAppendingFormat:@"%@",[dict objectForKey:@"City"]];
                               address = [address stringByAppendingFormat:@"%@",[dict objectForKey:@"Name"]];
                               
                               NSLog(@"%@",address);
                               
                               //for (id key in dict) {
                               //                                  NSLog(@"key=%@ value=%@",key,[dict objectForKey:key]);
                               //FormattedAddressLineを１行の文字列に連結
                               //ドキュメントには明記されているところが見当たらないがFormattedAddressLinesは配列で返って来るらしい
                               //                                   NSArray *lines = [dict valueForKey:@"FormattedAddressLines"];
                               //                                   for (int i = 0; i <lines.count; i++) {
                               //                                       line = [line stringByAppendingFormat:@"%@",[lines objectAtIndex:i]];
                               //
                               //                                   }
                               
                               
                               //}
                           }
                       }
                   }];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"statusは%D", status);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)return_Back:(id)sender {
    //メニュー画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
}

//現在地を表示する
- (IBAction)showUserLocation:(id)sender {
    MKUserLocation *userlocation = self.mapView.userLocation;
    
    MKCoordinateRegion region;
    region.center = userlocation.coordinate;
    region.span.latitudeDelta = 0.00126;
    region.span.longitudeDelta = 0.00098;
    
    [self.mapView setRegion:region animated:YES];
    
}
//タクシーを呼ぶ
- (IBAction)taxicall:(id)sender {
    
    //メールタイトル設定
    NSString*subject =
    [@"タクシー依頼" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

   
    //メール本文設定
    //個人情報を取得
    [user loadUserDefaults];
    NSString *inputName = user.userName;
    NSString *inputTel  = user.tel;
    
    
    //個人情報が入力されていれば、メール本文に表示
    //名前
    NSString *username;
    if (inputName.length > 0) {
        username =[NSString stringWithFormat:@"名前:%@",inputName];
    }else if(inputName.length == 0){
        NSString *usernametext = @"";
        username =[NSString stringWithFormat:@"名前:%@",usernametext];
    }
    
    //電話番号
    NSString *usertel;
    if (inputTel.length > 0) {
        usertel =[NSString stringWithFormat:@"電話番号:%@",inputTel];
    }else if(inputTel.length == 0){
        NSString *userteltext = @"";
        usertel =[NSString stringWithFormat:@"電話番号:%@",userteltext];
    }
    
    //現在地
    NSString *here = [NSString stringWithFormat:@"現在地:%@",address];

    //文字統合
    NSString *str = [NSString stringWithFormat:@"%@\n %@\n%@",username,usertel,here];

    NSString*text =
    [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //メール送信
    NSString*scheme = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",TAXI_MAIL_ADDRESS,subject,text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
    
}

//個人情報登録
- (IBAction)ClickUserInfo:(id)sender {
       [self.navigationController pushViewController:[PointUserInfoViewController new] animated:YES];
}

@end
