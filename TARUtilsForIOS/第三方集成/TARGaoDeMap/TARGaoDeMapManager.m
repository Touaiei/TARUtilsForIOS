//
//  TARGaoDeMapManager.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/29.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TAR高德地图Manager
 */
#import "TARGaoDeMapManager.h"

@implementation TARGaoDeMapManager

#pragma mark --配置高德注册--
-(void)initAMapApiKey:(NSString *)key
{
    //@"f6b7ae8da0dabac83c2f305f2c953ba7"
    NSString *apiKey = [key isKindOfClass:[NSString class]]?key:@"";
    [AMapServices sharedServices].apiKey = apiKey;
}

@end
