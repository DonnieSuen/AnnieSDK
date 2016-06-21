//
//  AnnComTool.h
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/7.
//  Copyright © 2016年 Anqu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnComTool : NSObject

+ (AnnComTool *)sharedSingleton;

@property(nonatomic,strong)NSString *codeinfo;


-(void)initWithType:(NSString*)codeinfo;


@end