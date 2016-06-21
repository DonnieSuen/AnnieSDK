//
//  RecommInfo.m
//
//  Created by Jeff on 16-4-3.
//  Copyright (c) 2016年 Jeff. All rights reserved.
//

#import "RecommInfo.h"

@implementation RecommInfo

+ (RecommInfo *)inforFromDic:(NSDictionary *)dic
{
   
    RecommInfo *info = [[RecommInfo alloc] init];
    info.lang = [dic objectForKey:@"lang"];
    info.msg = [dic objectForKey:@"msg"];
    info.link = [dic objectForKey:@"link"];
    
    return info;
}

@end


