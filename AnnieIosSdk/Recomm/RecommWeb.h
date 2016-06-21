//
//  AcountWeb.h
//
//  Created by Jeff on 16-4-4.
//  Copyright (c) 2016年. All rights reserved.
//

#import "NSDictionary+QueryBuilder.h"
#import "httpRequest.h"
#import "SBJsonParser.h"
#import "JSON.h"


@interface RecommWeb : UIViewController<UIWebViewDelegate>

@property(nonatomic, strong)UIButton *back;

@property(nonatomic, strong)UILabel *annText;

@property(nonatomic, strong)UIWebView *webView;

//分割线
@property(nonatomic, strong)UIView *lineView;

@property(nonatomic, strong)NSString *webUrl;

@property(nonatomic, strong)NSString *languange;

@end
