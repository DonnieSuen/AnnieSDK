//
//  Ann_HttpEngine.h
//
//  Copyright (c) 2015年 Jeff. All rights reserved.
//
//  接口-请求url

#import "AnquReachability.h"

typedef enum {
    SortTypeLatest = 1,
    SortTypeHotest = 2,
    SortTypeScore = 3,
}SortType;


#define NETNOTWORKING @"NotReachable"
#define NETWORKVIAWIFI @"ReachableViaWiFi"
#define NETWORKVIA3G @"ReachableViaWWAN"


@interface Ann_HttpEngine : NSObject 
{
    //判断网络是否连接
	AnquReachability* internetReach;
}

+ (Ann_HttpEngine *)shared_HttpEngine;
- (NSString *)getCurrentNet;
- (BOOL)checkIsWifi;



@end

