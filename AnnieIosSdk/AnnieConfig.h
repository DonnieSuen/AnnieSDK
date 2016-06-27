//
//  AnnieConfig.h
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/1.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#pragma mark - Public


#define SCREENHEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define SCREENWIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])

#define UMConfigInstance [UMAnalyticsConfig sharedInstance]
//当前软件版本号
#define currentVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define currentBIString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
#define currentVersionShortString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

static  NSString *language = @"language";
static  NSString *appversion = @"version";
static  NSString *appbid = @"bundleidentifier";
static  NSString *UmengID = @"umengId";
static  NSString *admobBannerId = @"admobId_b";
static  NSString *admobIntereId = @"admobId-i";
static  NSString *appId = @"appId";
static  NSString *moreLink = @"moreLink";
static  NSString *isExchang = @"isExchang";

static  NSString *recommendmsg = @"recommendmsg";
static  NSString *recommendlink = @"recommendlink";
static  NSString *delaytime = @"delaytime";

static  NSString  *ExchOpen = @"1";
static  NSString  *ExchClose = @"0";

//初始化URL
static const NSString *API_URL_Init = @"http://sdk.api-ag.com/init/?";
//首屏推荐
static const NSString *API_URL_Recomm = @"http://sdk.api-ag.com/ad/";
//兑换码
static const NSString *API_URL_Remmcode = @"http://sdk.api-ag.com/exchange/";
//统计
static const NSString *API_URL_ANALYSIS = @"http://a-sdk.api-ag.com/analysis.php";

static const NSString *gourl_prefix = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8&id=";

static const NSString *Text_Recomm = @"亲，现在五星好评，将有机会获得惊喜大礼包～";


