//
//  AdmobInterstitialViewController.m
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/8.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import "AdmobInterstitialViewController.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "CommonUtils.h"

@interface AdmobInterstitialViewController ()

@end

@implementation AdmobInterstitialViewController


#pragma Interstitial Delegate
- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    NSLog(@"DidReceiveAd");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [self preloadRequest];
}

- (void)showInterstitial{
    if (self.interstitial.isReady) {
        NSLog(@"ready");
        [self.interstitial presentFromRootViewController:_parentViewcontroller];
    }
    else
    {
        NSLog(@"not ready");
        [self preloadRequest];
    }
}

#pragma mark GADRequest generation
-(void)initInterstitial
{
    // Create a new GADInterstitial each time.  A GADInterstitial
    // will only show one request in its lifetime. The property will release the
    // old one and set the new one.
    
   // self.interstitial = [[[GADInterstitial alloc] init] autorelease];
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    NSString *unitid = [defaults objectForKey:admobIntereId];
    NSLog(@"插屏 id==%@",unitid);
    
    self.interstitial.adUnitID = unitid;
}
-(void)preloadRequest
{
    NSLog(@"pre load");
    [self initInterstitial];
    [self.interstitial loadRequest: [self createRequest]];
}
// Here we're creating a simple GADRequest and whitelisting the application
// for test ads. You should request test ads during development to avoid
// generating invalid impressions and clicks.

- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices =
    [NSArray arrayWithObjects:
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
     nil];
    return request;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInt
//                               duration:(NSTimeInterval)duration {
//    if (UIInterfaceOrientationIsLandscape(toInt)) {
//        self.adBanner.adSize = kGADAdSizeSmartBannerLandscape;
//    } else {
//        self.adBanner.adSize = kGADAdSizeSmartBannerPortrait;
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
