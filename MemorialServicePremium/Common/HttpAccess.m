//
//  HttpAccess.m
//  MemorialServicePremium
//
//  Created by pc131101 on 2015/11/05.
//  Copyright © 2015年 DIGITALSPACE WOW. All rights reserved.
//

#import "HttpAccess.h"

@interface HttpAccess()
@end

@implementation HttpAccess

//POST送信
- (NSData *)POST:(NSString *)requestURL param:(NSMutableDictionary *)parameter
{
    NSURL *url = [NSURL URLWithString:requestURL];
    
    //POSTオブジェクト作成
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    //パラメータを生成
    if (0 < [parameter count]) {
        NSArray *keys = [parameter allKeys];
        NSString *strParam = [NSString string];
        
        for (int count = 0; count < [keys count]; count++) {
            NSString *key   = [keys objectAtIndex:count];
            NSString *value = [parameter objectForKey:key];
            
            strParam = [strParam stringByAppendingString:key];
            strParam = [strParam stringByAppendingString:@"="];
            strParam = [strParam stringByAppendingString:value];
            
            if (count < [keys count] - 1) {
                strParam = [strParam stringByAppendingString:@"&"];
            }
        }
        
        //パラメータを設定
        [request setHTTPBody:[strParam dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //HTTP通信を実行
    NSHTTPURLResponse *response;
    NSError *response_error = nil;
    NSData *requestResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&response_error];
    
    //レスポンスから結果を取得
    if (!requestResult || response.statusCode != 200) {
        return nil;
    }
    
    return requestResult;
}

//GET送信
- (void)get:(NSString *)requestURL param:(NSString *)parameter{
    
    // URL指定、パラメーターを付与
    NSString *urlAsString = requestURL;
    urlAsString = [urlAsString stringByAppendingString:@"?userId="];
    urlAsString = [urlAsString stringByAppendingString:parameter];
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    // GETメソッドのHTTPリクエストを生成
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    // NSOperationQueueオブジェクトを生成
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // リクエスト実行
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
     }];    
}

//個人情報取得
- (NSDictionary *)getpersonaldata:(NSString *)requestURL param:(NSString *)parameter{
    
    // URL指定、パラメーターを付与
    NSString *urlAsString = requestURL;
    urlAsString = [urlAsString stringByAppendingString:@"?userId="];
    urlAsString = [urlAsString stringByAppendingString:parameter];
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    // GETメソッドのHTTPリクエストを生成
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    // HTTPリクエストオブジェクトを生成
    NSURLRequest* request = [NSURLRequest
                             requestWithURL:url];
    
    // HTTP同期通信を実行
    NSHTTPURLResponse *response;
    NSError *response_error = nil;
    NSData *requestResult = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&response_error];
    
    //レスポンスから結果を取得
    if (!requestResult || response.statusCode != 200) {
        return nil;
    }
    
    //JSONのデータを読み込む
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:requestResult options:NSJSONReadingAllowFragments error:&response_error];
    
    return jsonObject;
}


//お知らせ
- (void)getnotice:(NSString *)requestURL param:(NSString *)parameter params:(int)parameter2{
    
    // URL指定、パラメーターを付与
    NSString *urlAsString = requestURL;
    urlAsString = [urlAsString stringByAppendingString:@"?userId="];
    urlAsString = [urlAsString stringByAppendingString:parameter];
    urlAsString = [urlAsString stringByAppendingString:@"&noticeNo="];
    //int → NSString
    NSString *str = [NSString stringWithFormat:@"%d", parameter2];
    urlAsString = [urlAsString stringByAppendingString:str];
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    // GETメソッドのHTTPリクエストを生成
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    // NSOperationQueueオブジェクトを生成
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // リクエスト実行
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
     }];
}

//家系図：故人一覧データインサート
- (void)getdeceasename:(NSString *)requestURL param:(NSString *)parameter params:(NSString *)parameter2 params:(NSString *)parameter3 params:(NSString *)parameter4 params:(NSString *)parameter5{
    
    NSURL *url = [NSURL URLWithString:requestURL];
    
    // POSTメソッドのHTTPリクエストを生成
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    // パラメーターを付与
    NSString *body = @"userid=";
    body = [body stringByAppendingString:parameter];
    body = [body stringByAppendingString:@"&username="];
    body = [body stringByAppendingString:parameter2];
    body = [body stringByAppendingString:@"&userbirthday="];
    body = [body stringByAppendingString:parameter3];
    body = [body stringByAppendingString:@"&userdeathday="];
    body = [body stringByAppendingString:parameter4];
    body = [body stringByAppendingString:@"&userphotopath="];
    body = [body stringByAppendingString:parameter5];
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSOperationQueueオブジェクトを生成
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // リクエスト実行
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
     }];
}

//(家系図）削除
- (void)deletedeceasename:(NSString *)requestURL param:(NSString *)parameter {
    
    NSURL *url = [NSURL URLWithString:requestURL];
    
    // POSTメソッドのHTTPリクエストを生成
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    // パラメーターを付与
    NSString *body = @"userid=";
    body = [body stringByAppendingString:parameter];
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSOperationQueueオブジェクトを生成
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // リクエスト実行
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
     }];
}

//機種変更キ）削除
- (void)deletedataKey:(NSString *)requestURL param:(NSString *)parameter {
    
    NSURL *url = [NSURL URLWithString:requestURL];
    
    // POSTメソッドのHTTPリクエストを生成
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    // パラメーターを付与
    NSString *body = @"datakey=";
    body = [body stringByAppendingString:parameter];
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSOperationQueueオブジェクトを生成
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // リクエスト実行
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
     }];
}

//故人情報アップデートカウントを更新
- (void)updatedeceasedupdatecount:(NSString *)requestURL param:(NSString *)parameter{
    
    NSURL *url = [NSURL URLWithString:requestURL];
    
    // POSTメソッドのHTTPリクエストを生成
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    // パラメーターを付与
    NSString *body = @"appli_id=";
    body = [body stringByAppendingString:parameter];
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSOperationQueueオブジェクトを生成
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    // リクエスト実行
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
     }];
}


@end
