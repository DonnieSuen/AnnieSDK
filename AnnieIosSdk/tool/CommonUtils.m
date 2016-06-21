//
//  CommonUtils.m
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/4.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import "CommonUtils.h"


@implementation CommonUtils

+ (CommonUtils *)sharedSingleton{
    static CommonUtils *sharedSingleton = nil;
    @synchronized(self){
        if (!sharedSingleton) {
            sharedSingleton = [[CommonUtils alloc] init];
            return sharedSingleton;
        }
    }
    return sharedSingleton;
}


+(void)showMessage:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+(NSUserDefaults*) getNSUserContext{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return defaults;
}


@end