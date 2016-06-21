//
//  AdmobBannerViewController.h
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/8.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import <GoogleMobileAds/GADBannerViewDelegate.h>

@class GADBannerView, GADRequest;

@interface AdmobBannerViewController : UIViewController <GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *adBanner;
@property (nonatomic, assign) GADAdSize adsize;
@property (nonatomic, assign) CGPoint adPoint;

@end
