//
//  RecommInfo.h

//  Created by Jeff on 16-4-3.
//  Copyright (c) 2016年 Jeff. All rights reserved.
//
//  基本信息

@interface RecommInfo : NSObject


@property (nonatomic,strong) NSString *lang;
@property (nonatomic,strong) NSString *msg,*link;


+ (RecommInfo *)inforFromDic:(NSDictionary *)dic;

@end


