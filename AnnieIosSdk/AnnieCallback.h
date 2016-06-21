//
//  AnnieCallback.h
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/1.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnComTool.h"


@protocol AnnieCallback <NSObject>

//初始化回调
-(void)initSdk:(int)resultCode;

//兑换码回调
-(void)codeExchange:(int)resultCode;

//检测更新回调
-(void)AnquCheckUpdate;

@end
