//
//  AMapAPIManager.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/10/16.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 高德相关API管理（地图，导航，定位）等
 */
#import <Foundation/Foundation.h>

#import <AMapFoundationKit/AMapFoundationKit.h>//高德定位、地图、导航等基础包
#import <AMapLocationKit/AMapLocationKit.h>//高德定位包
#import <AMapNaviKit/AMapNaviKit.h>//高德导航包

@interface AMapAPIManager : NSObject

@property(nonatomic, strong)UIView *targetView;

//获取单例
+ (instancetype)sharedManager;

//1)初始化 高德Key。
-(void)initAMapKey:(NSString *)key;


#pragma mark --配置高德定位Manager--
//1) 配置 高德Key。
-(void)initLocationManager;





//1) 创建 AMapNaviDriveManager。
-(void)initNavigationManager;
//2) 创建 AMapNaviDriveView。
- (void)initDriveView;
//3) 将 AMapNaviDriveView 与 AMapNaviManager 关联起来，并将 AManNaviDriveView 显示出来。
- (void)configDriveNavi;
//4) 进行路线规划。
- (void)calculateRoute:(NSArray<AMapNaviPoint *> *)startPoints endPoints:(NSArray<AMapNaviPoint *> *)endPoints;
//5) 当路线规划成功时，开启导航。
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager;


@end




