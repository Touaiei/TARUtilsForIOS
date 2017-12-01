//
//  TARGaoDeMapManager.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/29.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TAR高德地图Manager
 */
#import <Foundation/Foundation.h>

#import "TARGaoDe2DMap.h"
#import "TARGaoDe3DMap.h"
#import "TARGaoDeMapView.h"
#import "TARGaoDeMapNavView.h"
#import "TARGaoDeMapSearch.h"
#import "TARGaoDeMapLocation.h"




@interface TARGaoDeMapManager : NSObject


//1)初始化 高德Key。
-(void)initAMapApiKey:(NSString *)key;


@end



