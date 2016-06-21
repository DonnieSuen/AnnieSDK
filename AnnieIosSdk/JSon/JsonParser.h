//
//  JsonParser.h YayawanIOS
//
//  Created by Jeff on 15-3-21.
//  Copyright (c) 2015年. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Gift.h"

@interface JsonParser : NSObject

-(NSDictionary*)jsonGet:(NSString*)resultStr;//获取支付post result

-(NSMutableArray*)jsonGetBankInfo:(NSString*)resultStr;//获取银行信息

//第二次请求，参数信息
-(NSString*)jsonCardCharge:(NSString*)resultStr;

-(NSMutableDictionary*)jsonCreditCharge:(NSString*)resultStr;

//-(UserInfo*)jsonUserInfo:(NSString*)resultStr;


//消费记录
//-(NSMutableArray*)jsonCostRecord:(NSString*)resultStr;

//充值记录
//-(NSMutableArray*)jsonChargeRecord:(NSString*)resultStr;

//-(NSMutableArray*)jsonFaq:(NSString*)resultStr;

//游戏推荐
//-(NSMutableArray*)jsonRecomGame:(NSString*)resultStr;

//新闻，攻略
//-(NSMutableArray*)jsonRaiders:(NSString*)resultStr;

//礼包
//-(NSMutableArray*)jsonGift:(NSString*)resultStr;

//礼包cdkey
//-(Gift*)jsonGetGift:(NSString*)resultStr;

@end
