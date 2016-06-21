//
//  httpGBRequest.h
//  AnnIOSSDK
//
//  Created by jiangfeng on 15/4/13.
//  Copyright (c) 2015年 anqu. All rights reserved.
//

#ifndef AnnIOSSDK_httpGBRequest_h
#define AnnIOSSDK_httpGBRequest_h

#endif

@interface httpGBRequest : NSObject<NSURLConnectionDataDelegate>{
    
}

@property(nonatomic,retain)id dlegate;

@property(nonatomic, retain)NSMutableData *receivedData;

@property(nonatomic, assign)SEL success;

@property(nonatomic, assign)SEL error;


/**
 *  post 异步请求
 *
 *  @param url  post 异步请求地址
 *  @param data post 请求参数
 */
-(void)postGBK:(NSString*)url argData:(NSString*)data;


@end
