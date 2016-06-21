//
//  AnalysisInfo.h
//  AnquIOSSDK
//
//  Created by Donnie Suen on 16/6/3.
//  Copyright © 2016年 anqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AnalysisInfo : NSObject

+(NSString*)getIDFA;
+(NSString*)getiOSVersion;
+(NSString*)getCurrentNet;
+(NSString*)getCarrier;
+(NSString*)getDeviceType;
+(NSString*)getBundleID;
+(NSString*)getVersion;
+(NSString*)getSysLanguage;

@end
