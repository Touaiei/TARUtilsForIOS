//
//  AlipayApiManager.h
//  YouJiaApp
//
//  Created by TAR on 2017/4/25.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 支付宝API管理类
 */
#import <Foundation/Foundation.h>

/**
 支付宝支付结果状态枚举
 */
typedef NS_ENUM(NSInteger,AlipayPayResultStatus){
    AlipayPayResultStatus_Success = 9000,  //支付成功
    AlipayPayResultStatus_cancel = 6001    //用户取消支付
};


@protocol AlipayApiManagerDelegate <NSObject>

/**
 支付宝发起支付后，回调相应代理方法
 */
-(void)alipayApiManagerPayResultResponse:(NSDictionary *)resultDic withStatus:(AlipayPayResultStatus)resultStatus;

@end

@interface AlipayApiManager : NSObject
@property(nonatomic,weak)id<AlipayApiManagerDelegate>delegate;
@property(nonatomic,assign)AlipayPayResultStatus payResultStatus;//支付宝支付结果状态


/**
 发起支付宝支付

 @param payOrders 支付订单
 @param appSchemes 支付宝appSchemes
 */
-(void)startAlipayWithPayOrder:(NSString *)payOrders andAppScheme:(NSString *)appSchemes;

/**
 调起支付宝生活缴费
 @param subBizType 类型
 */
-(void)openAlipaysLifePayCostWithSubBizType:(NSString *)subBizType;

+ (instancetype)sharedManager;


@end
