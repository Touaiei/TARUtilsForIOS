//
//  TARGaoDeMapNavView.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/12/1.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TARGaoDe导航基本View
 */
#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>//高德定位、地图、导航等基础包
#import <AMapLocationKit/AMapLocationKit.h>//高德定位包
#import <AMapNaviKit/AMapNaviKit.h>//高德导航包

@interface TARGaoDeMapNavView : UIView

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
