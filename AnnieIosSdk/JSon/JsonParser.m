//
//  JsonParser.m
//  YayawanIOS
//
//  Created by Jeff on 15-3-21.
//  Copyright (c) 2015年. All rights reserved.
//

#import "JsonParser.h"
#import "JSON.h"
//#import "BindInfo.h"
//#import "costClass.h"
//#import "ChargeInfo.h"
//#import "Faq.h"
//#import "DownInfo.h"
//#import "StrageInfo.h"
//#import "GiftInfo.h"
//#import "UserData.h"

@implementation JsonParser

//获取json
-(NSDictionary*)jsonGet:(NSString*)resultStr{
    //json解析
    NSError *error = nil;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDic = [parser objectWithString:resultStr error:&error];
    return rootDic;
}

//获取银行卡信息
-(NSMutableArray*)jsonGetBankInfo:(NSString*)resultStr{
    //解析bank
    NSMutableArray *userBankInfo = [NSMutableArray arrayWithCapacity:6];//动态数组，存储银行信息
    NSArray *bankArray = [[self jsonGet:resultStr] objectForKey:@"bindbank"];
    for (int i = 0 ; i < [bankArray count]; i++) {
        NSDictionary *bankDict = [bankArray objectAtIndex:i];
        //遍历数据字典
        NSString *idnum = [bankDict objectForKey:@"id"];
        NSString *uid = [bankDict objectForKey:@"uid"];
        NSString *bank_id = [bankDict objectForKey:@"bank_id"];
        NSString *lastno = [bankDict objectForKey:@"lastno"];
        NSString *bindvalid = [bankDict objectForKey:@"bindvalid"];
        NSString *bank_type = [bankDict objectForKey:@"bank_type"];
        NSString *bankname = [bankDict objectForKey:@"bankname"];
//        BindInfo *userBind = [[BindInfo alloc] initWithType:idnum tempUid:uid tempBankID:bank_id
//                                                tempLastNum:lastno tempbindValid:bindvalid tempBankType:bank_type tempBankName:bankname];
//        [userBankInfo addObject:userBind];
    }
    return userBankInfo;
}

//连字符串,一卡通
-(NSString*)jsonCardCharge:(NSString*)resultStr{
    NSString *connectStr = @"";
    NSArray *secCardCharge = [[self jsonGet:resultStr] objectForKey:@"post"];
    for (int i = 0 ; i < [secCardCharge count]; i++){
        NSDictionary *cardDict = [secCardCharge objectAtIndex:i];
        NSString *key = [cardDict objectForKey:@"name"];
        NSString *equal = @"=";
        NSString *keyValue = [cardDict objectForKey:@"value"];
        NSString *connect = @"&";
        connectStr = [connectStr stringByAppendingFormat:@"%@%@%@%@",key,equal,keyValue,connect];
    }
    return connectStr;
}

//bank
-(NSMutableDictionary*)jsonCreditCharge:(NSString*)resultStr{
    NSArray *secCardCharge = [[self jsonGet:resultStr] objectForKey:@"post"];
    NSMutableDictionary *creditResult = [NSMutableDictionary dictionaryWithCapacity:5];
    for (int i = 0 ; i < [secCardCharge count]; i++){
        NSDictionary *cardDict = [secCardCharge objectAtIndex:i];
        [creditResult setValue:[cardDict objectForKey:@"value"] forKey:[cardDict objectForKey:@"name"]];
    }
    return creditResult;
}

//消费记录
//-(NSMutableArray*)jsonCostRecord:(NSString*)resultStr{
//    //解析bank
//    NSMutableArray *costDataInfo = [NSMutableArray arrayWithCapacity:6];//动态数组，存储银行信息
//    NSArray *costData = [[self jsonGet:resultStr] objectForKey:@"data"];
//    for (int i = 0 ; i < [costData count]; i++) {
//        NSDictionary *bankDict = [costData objectAtIndex:i];
//        //遍历数据字典
//        NSString *idnum = [bankDict objectForKey:@"id"];
//        NSString *amount = [bankDict objectForKey:@"amount"];
//        NSString *goods = [bankDict objectForKey:@"goods"];
//        NSString *datetime = [bankDict objectForKey:@"date_time"];
//        NSString *status = [bankDict objectForKey:@"status"];
//                costClass *costRecord = [[costClass alloc] initWithType:idnum Goods:goods Amount:amount Time:datetime Status:status];
//                [costDataInfo addObject:costRecord];
//    }
//    return costDataInfo;
//}

////礼包
//-(NSMutableArray*)jsonGift:(NSString*)resultStr{
//    //解析攻略
//    NSMutableArray *giftInfo = [NSMutableArray arrayWithCapacity:6];//动态数组，存储银行信息
//    NSArray *giftData = [[self jsonGet:resultStr] objectForKey:@"gifts"];
//    if ([giftData count] > 0) {//如果有礼包
//        for (int i = 0 ; i < [giftData count]; i++) {
//            NSDictionary *giftDict = [giftData objectAtIndex:i];
//            //遍历数据字典
//            NSString *giftId = [giftDict objectForKey:@"id"];
//            NSString *giftName = [giftDict objectForKey:@"name"];
//            NSString *giftDescri = [giftDict objectForKey:@"description"];
//            NSString *giftCreate = [giftDict objectForKey:@"create_time"];
//            NSString *giftEnd = [giftDict objectForKey:@"end_time"];
//            NSString *giftStatus = [giftDict objectForKey:@"status"];
//            GiftInfo *giftClass = [[GiftInfo alloc] initWithType:giftId Name:giftName Description:giftDescri Create:giftCreate End:giftEnd Status:giftStatus];
//            [giftInfo addObject:giftClass];
//        }
//    }
//    return giftInfo;
//}

//礼包cdkey
/*
-(Gift*)jsonGetGift:(NSString*)resultStr{
    NSString *idnum = [[self jsonGet:resultStr] objectForKey:@"id"];
    NSString *cdkey = [[self jsonGet:resultStr] objectForKey:@"cdkey"];
    
    NSString *release_time = [[self jsonGet:resultStr] objectForKey:@"release_time"];
    NSString *get_time = [[self jsonGet:resultStr] objectForKey:@"get_time"];
    
    NSString *status = [[self jsonGet:resultStr] objectForKey:@"status"];
    NSString *is_success = [[self jsonGet:resultStr] objectForKey:@"is_success"];
    
    [[Gift sharedSingleton] initWithType:idnum CDkey:cdkey Success:is_success Status:status Release:release_time GetTime:get_time];
    return [Gift sharedSingleton];
}
*/

//游戏礼包
/*
-(NSMutableArray*)jsonRaiders:(NSString*)resultStr{
    //解析攻略
    NSMutableArray *raidersInfo = [NSMutableArray arrayWithCapacity:6];//动态数组，存储银行信息
    NSArray *raidersData = [[self jsonGet:resultStr] objectForKey:@"news"];
    for (int i = 0 ; i < [raidersData count]; i++) {
        NSDictionary *raisderDict = [raidersData objectAtIndex:i];
        //遍历数据字典
        NSString *idnum = [raisderDict objectForKey:@"id"];
        NSString *name = [raisderDict objectForKey:@"name"];
        NSString *clicknum = [raisderDict objectForKey:@"clicknum"];
        NSString *describ = [raisderDict objectForKey:@"description"];
        NSString *time = [raisderDict objectForKey:@"create_time"];
        NSString *icon = [raisderDict objectForKey:@"upfile"];
        StrageInfo *radiderClass = [[StrageInfo alloc] initWithType:idnum Title:name Content:describ Time:time ClickNum:clicknum Icon:icon];
        [raidersInfo addObject:radiderClass];
    }
    return raidersInfo;
}
 */

//充值记录
/*
-(NSMutableArray*)jsonChargeRecord:(NSString*)resultStr{
    NSMutableArray *costDataInfo = [NSMutableArray arrayWithCapacity:6];//动态数组，存储银行信息
    NSArray *costData = [[self jsonGet:resultStr] objectForKey:@"data"];
    for (int i = 0 ; i < [costData count]; i++) {
        NSDictionary *bankDict = [costData objectAtIndex:i];
        //遍历数据字典
        NSString *idnum = [bankDict objectForKey:@"id"];
        NSString *amount = [bankDict objectForKey:@"amount"];
        NSString *bank_id = [bankDict objectForKey:@"bank_id"];
        NSString *bank_name = [bankDict objectForKey:@"bank_name"];
        NSString *datetime = [bankDict objectForKey:@"date_time"];
        NSString *status = [bankDict objectForKey:@"status"];
        ChargeInfo *chargeRecord = [[ChargeInfo alloc] initWithType:idnum Bank_id:bank_id Name:bank_name Amount:amount Time:datetime Status:status];
        [costDataInfo addObject:chargeRecord];
    }
    return costDataInfo;
}
 */

/*
//推荐游戏
-(NSMutableArray*)jsonRecomGame:(NSString*)resultStr{
    NSMutableArray *recomGameArray = [NSMutableArray arrayWithCapacity:6];//动态数组，存储银行信息
    NSArray *gameArray = [[self jsonGet:resultStr] objectForKey:@"data"];
    for (int i = 0 ; i < [gameArray count]; i++) {
        NSDictionary *gameDict = [gameArray objectAtIndex:i];
        NSString *nameId = [gameDict objectForKey:@"id"];
        NSString *gameSize = [gameDict objectForKey:@"size"];
        NSString *gameName = [gameDict objectForKey:@"name"];
        NSString *gameStyle = [gameDict objectForKey:@"category_name"];
        NSString *gameDescrib = [gameDict objectForKey:@"description"];
        NSString *imageUrl = [gameDict objectForKey:@"upfile"];//游戏图像
        NSString *gameUrl = [gameDict objectForKey:@"url_id"];
        DownInfo *downInfo = [[DownInfo alloc] initWithType:[nameId intValue] ImageUrl:imageUrl Name:gameName Size:gameSize Style:gameStyle Url:gameUrl Describ:gameDescrib];
        [recomGameArray addObject:downInfo];
    }
    return recomGameArray;
}
*/

//FAQ
/*
-(NSMutableArray*)jsonFaq:(NSString*)resultStr{
    NSMutableArray *faqDataInfo = [NSMutableArray arrayWithCapacity:6];//动态数组，存储银行信息
    
    NSArray *faqData = [[self jsonGet:resultStr] objectForKey:@"helps"];
    if ([faqData count] > 0) {
        for (int i = 0 ; i < [faqData count]; i++) {
            NSDictionary *faqDict = [faqData objectAtIndex:i];
            //遍历数据字典
            NSString *name = [faqDict objectForKey:@"name"];
            NSString *content = [faqDict objectForKey:@"content"];
            name = [name stringByAppendingFormat:@"%@",content];
            Faq *faqInfo = [[Faq alloc] initWithType:name Content:1];
            [faqDataInfo addObject:faqInfo];
        }
    }
    
    NSArray *faqQuestion = [[self jsonGet:resultStr] objectForKey:@"questions"];
    int length = [faqQuestion count];
    for (int i = 0 ; i < length; i++) {
        NSDictionary *faqQueDict = [faqQuestion objectAtIndex:i];
        Faq *faqInfo = [[Faq alloc] initWithType:[faqQueDict objectForKey:@"content"] Content:2];
        [faqDataInfo addObject:faqInfo];
        
        NSArray *array =  [faqQueDict objectForKey:@"replay"];
        int length2 = [array count];
        if (length2 > 0) {
            for (int j = 0; j < length2; j++) {
                NSDictionary *quesReplayDict = [array objectAtIndex:j];
                Faq *faqInfo = [[Faq alloc] initWithType:[quesReplayDict objectForKey:@"content"] Content:1];
                [faqDataInfo addObject:faqInfo];
            }
        }
    }
    return faqDataInfo;
}
*/

/*
 -(UserInfo*)jsonUserInfo:(NSString*)resultStr{
    NSDictionary *resultDict = [self jsonGet:resultStr];
    
    [[UserInfo sharedSingleton] initWithType:[resultDict objectForKey:@"id"]
                                        Name:[resultDict objectForKey:@"username"]
                                        Icon:[resultDict objectForKey:@"icon"]
                                      Amount:[resultDict objectForKey:@"amount"]
                                         Reg:[resultDict objectForKey:@"reg_time"]
                                  Last_Login:[resultDict objectForKey:@"last_login"]
                                       Email:[resultDict objectForKey:@"email"]
                                       Phone:[resultDict objectForKey:@"phone"]
                                 PhoneActive:[resultDict objectForKey:@"phone_active"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"bindphone" object:nil];
    return [UserInfo sharedSingleton];
}
 */

@end
