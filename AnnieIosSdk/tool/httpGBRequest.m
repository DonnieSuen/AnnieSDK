//
//  httpGBRequest.m
//  AnnIOSSDK
//
//  Created by jiangfeng on 15/4/13.
//  Copyright (c) 2015年 anqu. All rights reserved.
//

#import "httpGBRequest.h"

@implementation httpGBRequest


-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}

/**
 *  post 异步请求
 *
 *  @param url  post 异步请求地址
 *  @param data post 请求参数
 */
-(void)postGBK:(NSString*)url argData:(NSString*)data {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [request setHTTPMethod:@"POST"];
     NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [request setHTTPBody:[data dataUsingEncoding:encoding]];
    
    NSURLConnection *con= [NSURLConnection connectionWithRequest:request delegate:self];
    if (con) {
       // NSLog(@"GBK connection true");
    } else {
        NSLog(@"net conntcetion");
    }
}


#pragma mark-接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   // NSLog(@"接收到GBK服务器回应的时候调用此方法");
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
  //  NSLog(@"%@",[res allHeaderFields]);
    //payResultPost = [[NSMutableData alloc]init];
    //[_receiveData setLength: 0];
    _receivedData = [[NSMutableData alloc] init];
}

#pragma mark-接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [_receivedData appendData:data];
   // NSLog(@"接收到服务器传输GBK数据的时候调用，此方法根据数据大小执行若干次");
    
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

#pragma mark-数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *receiveStr = [[NSString alloc]initWithData:_receivedData encoding:encoding];
   // NSLog(@"%@",receiveStr);
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
