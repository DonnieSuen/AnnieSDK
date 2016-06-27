

//  Created by Jeff on 15-3-21.
//  Copyright (c) 2015年. All rights reserved.
//

#import "AnnieIosSdk.h"
#import "NSString+SBJSON.h"
#import "NSDictionary+QueryBuilder.h" 
#import "Ann_HttpEngine.h"
#import "httpRequest.h"
#import "SBJsonParser.h"
#import "CommonUtils.h"
#import "RecommWeb.h"
#import "RecommInfo.h"
#import "AnnComTool.h"
#import "AdmobBannerViewController.h"
#import "AdmobInterstitialViewController.h"
#import "AnalysisInfo.h"
#import "AESCrypt.h"

#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>

#import "UMMobClick/MobClick.h"



@implementation AnnieIosSdk{
    NSMutableArray *data_recomm;
    int timetodelay;
    NSString *gotext;
    NSString *canceltxt;
    AdmobInterstitialViewController *intersview;
}

__strong static AnnieIosSdk *singleton = nil;
__strong static DDTTYLogger *logger;

static UIInterfaceOrientation appOrientation;

static  int ddLogLevel = LOG_FLAG_ERROR | LOG_FLAG_INFO;




/**
 *  API单例
 *
 *  @return 返回单例
 */
+(AnnieIosSdk*)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        //singleton = [[self alloc] init];
        singleton = [[super allocWithZone:NULL] init];
    });
    
    [self setLogger]; //移到框架外调用代码处  设置开关
    
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+(void)setLogger{
    //创建一个终端显示日志
   logger = [DDTTYLogger sharedInstance]; //只需要初始化一次
    //1.1将日志往终端上输出
    [DDLog addLogger:logger];
 
}

+(void)setDebugLogOn:(BOOL)debug{
    if (debug == TRUE) {
        ddLogLevel = LOG_FLAG_DEBUG;
    }
}


+(int)getLoggerLevel{
    // int ddLogLevel = LOG_FLAG_ERROR | LOG_FLAG_INFO;
    return ddLogLevel;
}
/**
 *  设置委托
 *
 *  @param argDelegate 委托
 */
-(void)setDelegate:(id<AnnieCallback>)argDelegate
{
    _delegate = argDelegate;
}

+(void)setOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    appOrientation = toInterfaceOrientation;
}

+(UIInterfaceOrientation)getOrientation
{
    return appOrientation;
}

/**
 *  初始化接口
 */
-(void)initsdk:(int)seconds
{
    NSString * Bistring = currentBIString;
    NSString * version = currentVersionShortString;
    NSLog(@"初始化Bistring：%@,version is %@",Bistring,version);
    [self initsdk:Bistring Version:version Time:seconds];
    
}


/**
 *  参数化初始化接口
 */
-(void)initsdk:(NSString*)bundleId Version:(NSString*)shortversion Time:(int)seconds
{
    [self getAnalysisInfo];
    [self umengTrack];
    
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    NSString *isOpenRecommend = [defaults objectForKey:isExchang];
    
    timetodelay= seconds;

    //TODO
    NSLog(@"isOpenRecommend:%@",isOpenRecommend);
    if ([isOpenRecommend isEqualToString:ExchOpen]) { //已经初始化了
        DDLogDebug(@"开评论了");
        [self topRecommend];
        
        if (timetodelay>0) {
            sleep(timetodelay);
           [self showEstimation];
        }
        //激活成功，callback
        [_delegate initSdk:AnnInitSuccess];
        [self preloadIntersView];
       return;
    }else if([isOpenRecommend isEqualToString:ExchClose]){ //已经初始化了
        //激活成功，callback
        [_delegate initSdk:AnnInitSuccess];
        [self preloadIntersView];
        return;
    }else{
        //第一次进游戏
    }


    
    //网络未连接
    NSString *netConnection = [[Ann_HttpEngine shared_HttpEngine] getCurrentNet];
    if ([netConnection isEqualToString:NETNOTWORKING]){
        [CommonUtils showMessage:@"您的网络不给力，请检查网络设置哦～"];
        return;
    }
    
    [defaults setObject:shortversion forKey:appversion];
    [defaults setObject:bundleId forKey:appbid];
   
    
    //判断系统语言
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *preferredLang = [languages objectAtIndex:0];
     NSLog(@"初始化preferredLang：%@",preferredLang);

    if([self myContainsString:preferredLang withContainStr:@"zh-Hans"]){
        [defaults setObject:@"cn" forKey:language];
    }else{
        [defaults setObject:@"en" forKey:language];
    }
    
    //设置loading
    
   // NSDictionary *dictionaryBundle = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                bundleId, @"bId",
                                shortversion,@"ver"
                                ,nil];
    
    NSString *postData = [dictionary buildQueryString];
    NSLog(@"初始化render数据：%@,url is %@",postData,API_URL_Init);
    httpRequest *_request = [[httpRequest alloc] init];
    _request.dlegate = self;
    _request.success = @selector(init_callback:);
    _request.error = @selector(error_callback);
    [_request post:API_URL_Init argData:postData];
}

- (BOOL)myContainsString:(NSString*)myStr withContainStr:(NSString*)conStr {
    NSRange range = [conStr rangeOfString:conStr];
    return range.length != 0;
}

-(void)init_callback:(NSString*)result
{
    DDLogDebug(@"初始化 result = %@",result);
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    NSString *status = [[rootDic objectForKey:isExchang] stringValue];
    NSLog(@"status:%@",status);
//  NSLog(@"初始化isExchang = %@,ummengid=%@",status,[rootDic objectForKey:UmengID]);
    
    NSArray *arr = [rootDic objectForKey:@"info"];
    // NSLog(@"Init推荐 = %@",arr[0][@"link"]);
    // [data_recomm removeAllObjects];
    
    //获取NSUserDefaults对象
    NSUserDefaults *defaults=[CommonUtils getNSUserContext] ;
    //保存数据
    [defaults setObject:[[rootDic objectForKey:isExchang]stringValue] forKey:isExchang];
    [defaults setObject:[rootDic objectForKey:UmengID] forKey:UmengID];
    [defaults setObject:[rootDic objectForKey:admobBannerId] forKey:admobBannerId];
    [defaults setObject:[rootDic objectForKey:admobIntereId] forKey:admobIntereId];
    [defaults setObject:[rootDic objectForKey:appId] forKey:appId];
    [defaults setObject:[rootDic objectForKey:moreLink] forKey:moreLink];
    // 强制让数据立刻保存
    [defaults synchronize];
    
    
    if([status isEqualToString:ExchOpen]){ //开启弹窗
        sleep(2);
        [self setRecommParser:rootDic];
        if (timetodelay>0) {
            sleep(timetodelay);
            [self showEstimation];
        }
        //激活成功，callback
        [_delegate initSdk:AnnInitSuccess];
        [self preloadIntersView];
    }else if([status isEqualToString:ExchClose]){
        NSLog(@"initcallback预加载");
        //激活成功，callback
        [_delegate initSdk:AnnInitSuccess];
            NSUserDefaults *defaults=[CommonUtils getNSUserContext];
        NSLog(@"!!!!!!%@",defaults);
        [self preloadIntersView];
    }

}

-(void)error_callback
{
    [CommonUtils showMessage:@"网络连接超时"];
    [_delegate initSdk:AnnNoInit];
    
//    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)topRecommend{
    //获取NSUserDefaults对象
     NSUserDefaults *defaults=[CommonUtils getNSUserContext] ;
      //读取保存的数据
     //NSString *status=[defaults objectForKey:isExchang];
     NSString *version=[defaults objectForKey:appversion];
     NSString *bid=[defaults objectForKey:appbid];

    //请求服务端
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    bid, @"bId",
                                    version,@"ver"
                                    ,nil];
        
    NSString *postData = [dictionary buildQueryString];
    NSLog(@"推荐render数据：%@,url is %@",postData,API_URL_Recomm);
       
    httpRequest *_request = [[httpRequest alloc] init];
    _request.dlegate = self;
    _request.success = @selector(recomm_callback:);
    _request.error = @selector(error_callback);
    [_request post:API_URL_Recomm argData:postData];
    
}

-(void)recomm_callback:(id)result
{
  
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    [self setRecommParser:rootDic];
    
}

//解析推荐内容
-(void) setRecommParser:(NSDictionary *)dicresult
{
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    NSString *lang=[defaults objectForKey:language];
    
    NSArray *arr = [dicresult objectForKey:@"info"];
    //NSLog(@"推荐 = %@",arr[0][@"link"]);
   // [data_recomm removeAllObjects];
    
        for (int i = 0; i<arr.count; i++)
        {
            RecommInfo * info = [RecommInfo inforFromDic:arr[i]];
            NSLog(@"进入 = %@",lang);
            if ([info.lang isEqualToString:lang] && [lang isEqualToString:@"cn"]) {
                NSLog(@"中文推荐 = %@",info.link);
                gotext = @"前往";
                canceltxt = @"取消";
                
                [defaults setObject:info.msg forKey:recommendmsg];
                [defaults setObject:info.link forKey:recommendlink];
                break;
            }else if ([info.lang isEqualToString:lang] && [lang isEqualToString:@"en"]){
                NSLog(@"English文推荐 = %@",info.msg);
                gotext = @"Go";
                canceltxt = @"Cancel";
                
                [defaults setObject:info.msg forKey:recommendmsg];
                [defaults setObject:info.link forKey:recommendlink];
                break;
            }
            //  [data_recomm addObject:[RecommInfo inforFromDic:arr[i]]];
            
        }
        
   
    
    //确定后导航到下载地址。。。
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[defaults objectForKey:recommendmsg] delegate:self cancelButtonTitle:nil otherButtonTitles:canceltxt,gotext,nil];
    alert.tag = 1;
    [alert show];

}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@" alert.tag =%d",alertView.tag);
    if (buttonIndex == 1 && alertView.tag ==1) {
        
        [self goToRecommend];
    }else if (buttonIndex == 1 && alertView.tag ==2){
        [self  goToEstimate];
    }
}

-(void)goToRecommend
{
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    NSString *str = [defaults objectForKey:recommendlink];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)goToEstimate
{
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    NSString *str = [NSString stringWithFormat:@"%@%@",gourl_prefix,[defaults objectForKey:appId]];
    NSLog(@"前往地址＝%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//导航到评价地址。。
-(void)showEstimation
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:Text_Recomm delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"前往",nil];
    alert.tag =2;
    [alert show];
}


-(void)tomore
{
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    
    RecommWeb * more= [[RecommWeb alloc] init];
    more.webUrl = [defaults objectForKey:moreLink];
    
    UIView* view = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
//    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [rootViewController presentModalViewController:more animated:YES ];
    
  // [MTPopupWindow showWindowWithHTMLFile:[defaults objectForKey:moreLink] insideView:self.view];
}

//不调用自主弹出  init后立即调用此方法
-(void)setshowEsttime:(int)seconds
{
    if (seconds == 0) {
        return; //cp自主调用评价
    }else if (seconds > 0){
        NSUserDefaults *defaults=[CommonUtils getNSUserContext];
        [defaults setObject:[NSString stringWithFormat:@"%d",seconds] forKey:delaytime];
        NSLog(@"delaytime init=%@",delaytime);
    }
    
}
//给予评价API
-(void)showandgoAssessment
{
      [self showEstimation];
}

-(void)getReemcode
{
       UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
       NSString * remStr = pasteboard.string;
      NSLog(@"兑换码＝＝%@,前位＝%@,长度＝%d",remStr,[remStr substringToIndex:3],[remStr length]);
    
    if ([remStr length]>=3 && [[remStr substringToIndex:3] isEqualToString:@"ag-"]) {
        //请求服务器
        NSUserDefaults *defaults=[CommonUtils getNSUserContext] ;
        NSString *bid=[defaults objectForKey:appbid];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    bid, @"bId",
                                    remStr,@"code"
                                    ,nil];
        
        NSString *postData = [dictionary buildQueryString];
        NSLog(@"兑换码请求数据：%@,url is %@",postData,API_URL_Remmcode);
        
        httpRequest *_request = [[httpRequest alloc] init];
        _request.dlegate = self;
        _request.success = @selector(exchange_callback:);
        _request.error = @selector(error_callback);
        [_request post:API_URL_Remmcode argData:postData];
        
    }else{
        return;
    }

    
}

-(void)exchange_callback:(NSString*)result
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:result];
    NSString *status = [[rootDic objectForKey:@"isTrue"] stringValue];
    NSLog(@"兑换status=%@",status);
    
    if ([status isEqualToString:@"1"]) {
         NSString *exchangecode = [rootDic objectForKey:@"info"];
         NSLog(@"兑换码 = %@",exchangecode);
        
        [AnnComTool sharedSingleton].codeinfo = exchangecode;
        
        //兑换成功，callback
        [_delegate codeExchange:AnncodeSuccess];
    }else{
        [AnnComTool sharedSingleton].codeinfo = @"";
        //兑换失败callback
        [_delegate codeExchange:AnncodeFail];
    }
    
}

-(AdmobBannerViewController *) getBannerAdsView:(int) adsize withAdsPosition:(CGPoint)adPoint
{
    AdmobBannerViewController * bannerview = [[AdmobBannerViewController alloc] init];
    GADAdSize adviewSize;
    switch (adsize) {
        case kMyGADAdSizeBannerNormal:
            adviewSize = kGADAdSizeBanner;
            break;
        case kMyGADAdSizeBanner:
            adviewSize = kGADAdSizeBanner;
            break;
        case kMyGADAdSizeLargeBanner:
            adviewSize = kGADAdSizeLargeBanner;
            break;
        case kMyGADAdSizeMediumRectangle:
            adviewSize = kGADAdSizeMediumRectangle;
            break;
        case kMyGADAdSizeFullBanner:
            adviewSize = kGADAdSizeFullBanner;
            break;
        case kMyGADAdSizeLeaderboard:
            adviewSize = kGADAdSizeLeaderboard;
            break;
        case kMyGADAdSizeSmartBannerPortrait:
            adviewSize = kGADAdSizeSmartBannerPortrait;
            break;
        case kMyGADAdSizeSmartBannerLandscape:
            adviewSize = kGADAdSizeSmartBannerLandscape;
            break;
        default:
            adviewSize = kGADAdSizeSmartBannerLandscape;
            break;
    }
    
    bannerview.adsize = adviewSize;
    
    bannerview.adPoint = adPoint;
    return bannerview;
}

-(UIViewController *)getBannerAdsView: (int) adsize withAdsPositionEnum:(int)adPoint{
    AdmobBannerViewController * bannerview = [[AdmobBannerViewController alloc] init];
    GADAdSize adviewSize = kGADAdSizeSmartBannerLandscape;
    CGPoint adPointXY = CGPointMake(0, 0);
    switch (adsize) {
        case kMyGADAdSizeBannerNormal:
            adviewSize = kGADAdSizeBanner;
            break;
        case kMyGADAdSizeBanner:
            adviewSize = kGADAdSizeBanner;
            break;
        case kMyGADAdSizeLargeBanner:
            adviewSize = kGADAdSizeLargeBanner;
            break;
        case kMyGADAdSizeMediumRectangle:
            adviewSize = kGADAdSizeMediumRectangle;
            break;
        case kMyGADAdSizeFullBanner:
            adviewSize = kGADAdSizeFullBanner;
            break;
        case kMyGADAdSizeLeaderboard:
            adviewSize = kGADAdSizeLeaderboard;
            break;
        case kMyGADAdSizeSmartBannerPortrait:
            adviewSize = kGADAdSizeSmartBannerPortrait;
            break;
        case kMyGADAdSizeSmartBannerLandscape:
            adviewSize = kGADAdSizeSmartBannerLandscape;
            break;
        default:
            adviewSize = kGADAdSizeSmartBannerLandscape;
            break;
    }
    
    CGSize adSizeWH = CGSizeFromGADAdSize(adviewSize);
    
    switch (adPoint) {
        case kMyAdPosTopLeft:
            adPointXY.x = 0;
            adPointXY.y = 0;
            break;
        case kMyAdPosTopCenter:
            adPointXY.x = (SCREENWIDTH - adSizeWH.width) / 2;
            adPointXY.y = 0;
            break;
        case kMyAdPosTopRight:
            adPointXY.x = SCREENWIDTH - adSizeWH.width;
            adPointXY.y = 0;
            break;
        case kMyAdPosMidLeft:
            adPointXY.x = 0;
            adPointXY.y = (SCREENHEIGHT - adSizeWH.height)/2;
            break;
        case kMyAdPosMidCenter:
            adPointXY.x = (SCREENWIDTH - adSizeWH.width) / 2;
            adPointXY.y = (SCREENHEIGHT - adSizeWH.height)/2;
            break;
        case kMyAdPosMidRight:
            adPointXY.x = SCREENWIDTH - adSizeWH.width;
            adPointXY.y = (SCREENHEIGHT - adSizeWH.height)/2;
            break;
        case kMyAdPosBotLeft:
            adPointXY.x = 0;
            adPointXY.y = SCREENHEIGHT - adSizeWH.height;
            break;
        case kMyAdPosBotCenter:
            adPointXY.x = (SCREENWIDTH - adSizeWH.width) / 2;
            adPointXY.y = SCREENHEIGHT - adSizeWH.height;
            break;
        case kMyAdPosBotRight:
            adPointXY.x = SCREENWIDTH - adSizeWH.width;
            adPointXY.y = SCREENHEIGHT - adSizeWH.height;
            break;
        default:
            adPointXY.x = 0;
            adPointXY.y = 0;
            break;
    }
    
    bannerview.adsize = adviewSize;
    bannerview.adPoint = adPointXY;
    return bannerview;
}

-(void)showInterstitialWithParentVC:(UIViewController*)parentViewController{
    intersview.parentViewcontroller = parentViewController;
    [intersview showInterstitial];
}

-(void)getAnalysisInfo{
    NSString *IDFA = [AnalysisInfo getIDFA];
    NSString *iOSVersion = [AnalysisInfo getiOSVersion];
    NSString *currentNet = [AnalysisInfo getCurrentNet];
    NSString *carrier = [AnalysisInfo getCarrier];
    NSString *deviceType = [AnalysisInfo getDeviceType];
    NSString *bundleID = [AnalysisInfo getBundleID];
    NSString *version = [AnalysisInfo getVersion];
    NSString *sysLanguage = [AnalysisInfo getSysLanguage];
    
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                IDFA, @"IDFA",
                                iOSVersion,@"iOSVersion",
                                currentNet,@"CurrentNet",
                                carrier,@"Carrier",
                                deviceType,@"DeviceType",
                                bundleID,@"BundleID",
                                version,@"Version",
                                sysLanguage,@"SysLanguage",
                                nil];
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *jsonValue = [writer stringWithObject:dictionary];
    
    NSString *password = @"p4ssw0rd";
    NSString *encryptedData = [AESCrypt encrypt:jsonValue password:password];
    
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    encryptedData, @"data",
                                    nil];
    
    
    NSString *postData = [postDictionary buildQueryString];
    httpRequest *_request = [[httpRequest alloc] init];
    _request.dlegate = self;
    _request.success = @selector(success_callback:);
    _request.error = @selector(error_callback);
    NSLog(@"urlis:%@",API_URL_ANALYSIS);
    [_request post:API_URL_ANALYSIS argData:postData];
}

-(void)success_callback:(NSString*)result
{
    NSLog(@"result%@",result);
}

-(void)umengTrack{
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:YES];
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    NSLog(@"umengID=====%@",[defaults objectForKey:UmengID]);
    UMConfigInstance.appKey = [defaults objectForKey:UmengID];
    
//    UMConfigInstance.secret = @"secretstringaldfkals";
    //    UMConfigInstance.eSType = E_UM_GAME;
    [MobClick startWithConfigure:UMConfigInstance];
}

//    初始化预加载广告插屏
-(void)preloadIntersView{
    NSLog(@"preloadIntersView{");
    intersview = [[AdmobInterstitialViewController alloc] init];
    [intersview preloadRequest];
}

@end
