//
//  AdmobInterstitialViewController.h
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/8.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import <GoogleMobileAds/GADInterstitialDelegate.h>

@class GADBannerView, GADRequest;

@interface AdmobInterstitialViewController : UIViewController <GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, retain) UIViewController *parentViewcontroller;

- (void)showInterstitial;
- (void)preloadRequest;

@end
