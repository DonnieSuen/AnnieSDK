//
//  AdmobBannerViewController.m
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/8.
//  Copyright © 2016年 Anqu. All rights reserved.
//


#import "AdmobBannerViewController.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>
#import "CommonUtils.h"

@interface AdmobBannerViewController ()

@end

@implementation AdmobBannerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:self.adsize];//kGADAdSizeSmartBannerLandscape
    self.adBanner.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    NSString *unitid = [defaults objectForKey:admobBannerId];
    
    NSLog(@"banner id==%@",unitid);
    self.adBanner.adUnitID = unitid; //@"a153466fdba92fc";
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    CGSize CGAdSize = CGSizeFromGADAdSize(self.adsize);
    NSLog(@"CGAdSize = %f,%f",CGAdSize.width,CGAdSize.height);
    self.view.frame = CGRectMake(self.adPoint.x, self.adPoint.y, CGAdSize.width, CGAdSize.height);
    
    [self.adBanner loadRequest:[GADRequest request]];
    
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@" Ann Received ad successfully");
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@" Ann Failed to receive ad with error: %@", [error localizedFailureReason]);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInt
                               duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInt)) {
        self.adBanner.adSize = kGADAdSizeSmartBannerLandscape;
    } else {
        self.adBanner.adSize = kGADAdSizeSmartBannerPortrait;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
