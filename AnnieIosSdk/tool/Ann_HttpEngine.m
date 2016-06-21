//
//  Ann_HttpEngine.m
//  Copyright (c) 2016年 Jeff. All rights reserved.
//

#import "Ann_HttpEngine.h"

@implementation Ann_HttpEngine
static Ann_HttpEngine* _Ann_HttpEngine;


+ (Ann_HttpEngine*) shared_HttpEngine{
    if ( ! _Ann_HttpEngine )
        _Ann_HttpEngine = [[Ann_HttpEngine alloc] init];
    return _Ann_HttpEngine;
}

#pragma mark Reachability
//监视网络状态,状态变化调用该方法.
- (void) reachabilityChanged: (NSNotification* )note
{
	if ([internetReach currentReachabilityStatus] != NotReachable) {
		//网络可用  在这将记录的收藏等操作完成.
		NSLog(@"网络可用");
	}
	else {
		//网络不可用
		NSLog(@"网络不可用");
	}
}

- (BOOL)checkIsWifi
{
    if ([internetReach currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    }
    return NO;
}


- (NSString *)getCurrentNet
{
    NSString *resultStr;
    AnquReachability *reachablility = [AnquReachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachablility currentReachabilityStatus]) {
        case NotReachable:
            resultStr = NETNOTWORKING;
            break;
        case ReachableViaWiFi:
            resultStr = NETWORKVIAWIFI;
            break;
        case ReachableViaWWAN:
            resultStr = NETWORKVIA3G;
            break;
        default:
            break;
    }
    return resultStr;
}

@end


