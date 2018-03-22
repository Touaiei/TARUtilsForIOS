//
//  AlipayApiManager.m
//  YouJiaApp
//
//  Created by TAR on 2017/4/25.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 支付宝API管理类
 */
#import "AlipayApiManager.h"
#import <AlipaySDK/AlipaySDK.h>//支付宝SDK
#import "WXApi.h"

@implementation AlipayApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AlipayApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AlipayApiManager alloc] init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alipayObserver:) name:Macro_AlipayCallbackNotifyName object:nil];

    }
    return self;
}
#pragma mark --支付宝回调通知观察者方法--
-(void)alipayObserver:(NSNotification *)notf
{
//    NSLog(@"alipayObserver");
    if ([notf.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = notf.object;
//        NSLog(@"dic == %@",dic);
        if ([dic[@"resultStatus"] integerValue] == 6001) {
            _payResultStatus = AlipayPayResultStatus_cancel;
        }else if ([dic[@"resultStatus"] integerValue] == 9000){
            _payResultStatus = AlipayPayResultStatus_Success;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(alipayApiManagerPayResultResponse:withStatus:)]) {
            [self.delegate alipayApiManagerPayResultResponse:dic withStatus:_payResultStatus];
        }
    }
}

#pragma mark --发起支付宝支付--
-(void)startAlipayWithPayOrder:(NSString *)payOrders andAppScheme:(NSString *)appSchemes
{
    if (payOrders != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = appSchemes;//@"alipaySchemes";
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *payOrder = payOrders;
        // NOTE: 调用支付结果开始支付     
        [[AlipaySDK defaultService] payOrder:payOrder fromScheme:appScheme callback:^(NSDictionary *resultDic) {//用于wap网页支付结果回调Block，（支付宝客户端不可用时，才会调用此回调Block）
            NSLog(@"支付结果resultDic===%@",resultDic);
            if ([resultDic[@"resultStatus"] integerValue] == 6001) {
                NSLog(@"用户取消支付！");
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:Macro_AlipayCallbackNotifyName object:resultDic];
        }];
    }
}

-(void)openAlipaysLifePayCostWithSubBizType:(NSString *)subBizType
{
    /*
     subBizType 对应值
     @"WATER"//水
     @"ELECTRICITY"//电
     @"GAS"//气
     */
    /*
     appId对应代码表（如：20000193 生活缴费）：
     27账户管理，28密码管理，30卡券，31设置头像，32余额宝，余额转出，身份信息，47详细资料，48添加服务窗，49反馈，51支付密码，54余额宝，56付款，57账户设置，68快速挂失，76账单，78国际汇款，80手机锁，85我的二维码，86口令，193生活缴费
     */
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"alipays://platformapi/startapp?appId=20000193&url=/www/setNewAccount.htm?subBizType=%@",subBizType]];
    if ([[UIApplication sharedApplication]canOpenURL:URL]) {
        [[UIApplication sharedApplication]openURL:URL];
    }
}




@end
