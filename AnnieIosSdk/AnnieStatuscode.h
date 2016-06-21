//
//  AnnieStatuscode.h
//  AnnieIosSdk
//
//  Created by jeffson on 16/4/5.
//  Copyright © 2016年 Anqu. All rights reserved.
//
/**
 *  SDK发送通知
 */

/**
 * @brief 初始化返回码。
 */
typedef enum{
    /**
     * 初始化成功
     */
    AnnInitSuccess	= 0,
    /**
     * 未初始化
     */
    AnnNoInit = 1,
    
}AnnInitCode;


/**
 * @brief 兑换码返回码。
 */
typedef enum{
    /**
     * 成功
     */
    AnncodeSuccess	= 0,
    /**
     * 失败
     */
    AnncodeFail = 1,
    
}AnnCodeInfoCode;