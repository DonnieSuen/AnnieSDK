//
//  AnnieIosSdk.h
//  AnnieIosSdk
//
//  Created by jeffson on 16/3/30.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnnieStatuscode.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDLegacyMacros.h"
#import "AnnieCallback.h"

typedef enum {
    kMyGADAdSizeBannerNormal = 0,
    /// iPhone and iPod Touch ad size. Typically 320x50.
    
    kMyGADAdSizeBanner,
    /// iPhone and iPod Touch ad size. Typically 320x50.
    
    kMyGADAdSizeLargeBanner,
    /// Taller version of kGADAdSizeBanner. Typically 320x100.
    
    kMyGADAdSizeMediumRectangle,
    /// Medium Rectangle size for the iPad (especially in a UISplitView's left pane). Typically 300x250.
    
    kMyGADAdSizeFullBanner,
    /// Full Banner size for the iPad (especially in a UIPopoverController or in
    /// UIModalPresentationFormSheet). Typically 468x60.
    
    kMyGADAdSizeLeaderboard,
    /// Leaderboard size for the iPad. Typically 728x90.
    
    kMyGADAdSizeSmartBannerPortrait,
    /// An ad size that spans the full width of the application in portrait orientation. The height is
    /// typically 50 pixels on an iPhone/iPod UI, and 90 pixels tall on an iPad UI.
    
    kMyGADAdSizeSmartBannerLandscape,
    /// An ad size that spans the full width of the application in landscape orientation. The height is
    /// typically 32 pixels on an iPhone/iPod UI, and 90 pixels tall on an iPad UI.
    
} MyGADAdSizeType;

typedef enum {
    kMyAdPosTopLeft = 0,
    kMyAdPosTopCenter,
    kMyAdPosTopRight,
    kMyAdPosMidLeft,
    kMyAdPosMidCenter,
    kMyAdPosMidRight,
    kMyAdPosBotLeft,
    kMyAdPosBotCenter,
    kMyAdPosBotRight,
}MyGADAdPositionType;


@interface AnnieIosSdk : NSObject

@property(nonatomic,retain)id<AnnieCallback> delegate;//设置callback委托


/**
 *  API单例 @return 返回单例
 */
+(AnnieIosSdk*)sharedInstance;

+(void)setDebugLogOn:(BOOL) debug;

+(int)getLoggerLevel;

/**
 *  设置委托
 *  @param argDelegate 委托
 */
-(void)setDelegate:(id<AnnieCallback>)argDelegate;

+(void)setOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
+(UIInterfaceOrientation)getOrientation;

/**  初始化接口 */
-(void)initsdk:(NSString*)bundleId Version:(NSString*)shortversion Time:(int)seconds;
-(void)initsdk:(int)seconds;

/**  更多链接 */
-(void)tomore;

//给予评论的调用
-(void)showandgoAssessment;

/** 获取兑换码*/
-(void)getReemcode;



/** 获取banner view*/
-(UIViewController *)getBannerAdsView: (int) adsize withAdsPosition:(CGPoint)adPoint;
-(UIViewController *)getBannerAdsView: (int) adsize withAdsPositionEnum:(int)adPoint;

/**弹出插屏*/
-(void)showInterstitialWithParentVC:(UIViewController*)parentViewController;

//设置评论调用时间   0:CP自主调用   30s    60s
//-(void)setshowEsttime:(int)seconds;

@end
