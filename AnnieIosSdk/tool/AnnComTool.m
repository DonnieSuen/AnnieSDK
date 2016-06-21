//
//  AnnComTool.m
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/7.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import "AnnComTool.h"
#import "CommonUtils.h"

@implementation AnnComTool

+ (AnnComTool *)sharedSingleton{
    static AnnComTool *sharedSingleton = nil;
    @synchronized(self){
        if (!sharedSingleton) {
            sharedSingleton = [[AnnComTool alloc] init];
            return sharedSingleton;
        }
    }
    return sharedSingleton;
}

-(void)initWithType:(NSString*)codeinfo
{
    _codeinfo = codeinfo;
}

@end