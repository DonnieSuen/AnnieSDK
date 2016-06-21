//
//  httpRequest.m
//
//  Created by Jeff on 15-3-21.
//  Copyright (c) 2015年. All rights reserved.
//

#import "httpRequest.h"

@implementation httpRequest

int ddLogLevel;

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        ddLogLevel = [AnnieIosSdk getLoggerLevel];
    }
    return self;
}

/**
 *  post 异步请求
 *
 *  @param url  post 异步请求地址
 *  @param data post 请求参数
 */
-(void)post:(NSString*)url argData:(NSString*)data {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"Content-Type" forHTTPHeaderField:@"application/json; charset=UTF-8"];
    [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];//NSUTF8StringEncoding

    NSURLConnection *con= [NSURLConnection connectionWithRequest:request delegate:self];
    if (con) {
        DDLogDebug(@"connection true");
    } else {
        DDLogInfo(@"net conntcetion");
    }
}

/**
 *  get 异步请求
 *
 *  @param tempUrl 请求地址
 */
-(void)getRSAGetResult:(NSString*)tempUrl{
    //创建url
    NSURL *url = [NSURL URLWithString:tempUrl];
    //创建请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //连接服务器
    [NSURLConnection connectionWithRequest:request delegate:self];
}

/**
 *  post 同步请求
 *
 *  @param tempUrl    同步请求地址
 *  @param resultData 请求参数
 *
 *  @return post请求返回数据
 */
-(NSString*)postSyncGetResult:(NSString*)tempUrl tempData:(NSString*)resultData{
    NSData *endResult = [resultData dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:tempUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:endResult];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    DDLogDebug(@"data=%@",data);
    NSString *strRet = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return strRet;
}


#pragma mark-接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DDLogDebug(@"接收到服务器回应的时候调用此方法");
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    DDLogDebug(@"%@",[res allHeaderFields]);
    
    //payResultPost = [[NSMutableData alloc]init];
    //[_receiveData setLength: 0];
    _receivedData = [[NSMutableData alloc] init];
}

#pragma mark-接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [_receivedData appendData:data];
    DDLogDebug(@"接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次");
    
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

#pragma mark-数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSString *receiveStr = [[NSString alloc]initWithData:_receivedData encoding:NSUTF8StringEncoding];
    DDLogDebug(@"%@",receiveStr);
    if (_success == nil) {
       return;
    }
    [_dlegate performSelector:_success withObject:receiveStr];
}

/**
 *  http 请求失败callback处理
 *
 *  @param connection 连接对象
 *  @param error     error
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_error == nil) {
        return;
    }
    [_dlegate performSelector:_error withObject:nil];

}

@end
