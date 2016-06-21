//
//  AcountWeb.m
//
//  Created by Jeff on 16-4-4.
//  Copyright (c) 2016年. All rights reserved.
//

#import "RecommWeb.h"
#import "CommonUtils.h"

@interface RecommWeb ()

@end

@implementation RecommWeb

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(SCREENWIDTH/12, 15, SCREENWIDTH*0.8, SCREENHEIGHT*0.8);
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults=[CommonUtils getNSUserContext];
    _languange=[defaults objectForKey:language];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/12, 15, SCREENWIDTH*0.8, SCREENHEIGHT*0.8)];
    bg.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bg];
     
//    _annText = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/4, 20, 80, 50)];
//    _annText.font = [UIFont systemFontOfSize:14.0];
//    _annText.textColor = [UIColor redColor];
//    [self.view addSubview:_annText];
    
    _back = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/12+SCREENWIDTH*0.8-55, 15, 50, 50)];
    if ([_languange isEqualToString:@"en"]) {
        NSLog(@"英文关闭");
        [_back setTitle:@"Cancel" forState:UIControlStateNormal];
    }else{
        [_back setTitle:@"关闭" forState:UIControlStateNormal];
    }
    _back.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_back addTarget:self action:@selector(annBackClick:) forControlEvents: UIControlEventTouchUpInside];//处理点击
    [self.view addSubview:_back];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/12, 55, SCREENWIDTH*0.8, 1)];
    _lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_lineView];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(SCREENWIDTH/12, 55, SCREENWIDTH*0.8, SCREENHEIGHT*0.8-15)];
    _webView.scalesPageToFit =YES;
    _webView.delegate =self;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    [_webView loadRequest:request];
    
}

//监听webView的事件，可以获得webview加载页面的url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //    //获取当前调转页面的URL
    //    NSString *requestUrl = [[request URL] absoluteString];
    //
    //    if ([requestUrl hasPrefix:@"yayapayment://success"] == 1) {
    //
    //        NSDictionary *url_info = [NSDictionary dictionaryWithQueryString:requestUrl];
    //
    //        int status = [[url_info objectForKey:@"status"] intValue];
    //
    //        if (status == 0) {
    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"finish" object:@"0"];
    //        }else{
    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"finish" object:@"1"];
    //        }
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //        return NO;
    //
    //    }
    
    return  YES;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载完成");
    //    [activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] == NSURLErrorCancelled) {
        //show error alert, etc.
        return;
    }
}

-(void)annBackClick:(id)sender{
    if (_webView.canGoBack)
    {
        [_webView goBack];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//iOS 6.0旋屏支持方向
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


//iOS 6.0以下旋屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
