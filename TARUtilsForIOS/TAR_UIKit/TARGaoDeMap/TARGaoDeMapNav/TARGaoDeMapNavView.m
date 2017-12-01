//
//  TARGaoDeMapNavView.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/12/1.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TARGaoDe导航基本View
 */
#import "TARGaoDeMapNavView.h"


@interface TARGaoDeMapNavView()
<
AMapNaviDriveManagerDelegate,
AMapNaviDriveViewDelegate

>
{
    AMapNaviDriveManager *_driveManager;
    AMapNaviDriveView *_driveView;
}
@end
@implementation TARGaoDeMapNavView

#pragma mark --配置高德导航Manager--
-(void)initNavigationManager
{
    
    NSLog(@"//1) 创建 AMapNaviDriveManager。");

    if (_driveManager == nil)
    {
        _driveManager = [[AMapNaviDriveManager alloc] init];
        [_driveManager setDelegate:self];
    }
}

- (void)initDriveView
{
    NSLog(@"//2) 创建 AMapNaviDriveView。");

    if (_driveView == nil)
    {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:self.bounds];
        [_driveView setDelegate:self];
    }
}
- (void)configDriveNavi
{
    NSLog(@"//3) 将 AMapNaviDriveView 与 AMapNaviManager 关联起来，并将 AManNaviDriveView 显示出来。");

    

    [_driveManager addDataRepresentative:_driveView];
    [self addSubview:_driveView];
}
- (void)calculateRoute:(NSArray<AMapNaviPoint *> *)startPoints endPoints:(NSArray<AMapNaviPoint *> *)endPoints
{
    NSLog(@"//4) 进行路线规划。");

    BOOL isSuccess = [_driveManager calculateDriveRouteWithStartPoints:startPoints
                                            endPoints:endPoints
                                            wayPoints:nil
                                      drivingStrategy:AMapNaviDrivingStrategySingleDefault];
    if (isSuccess == YES) {
        [self driveManagerOnCalculateRouteSuccess:nil];
    }
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"//5) 当路线规划成功时，开启导航。");
    [_driveManager startEmulatorNavi];
}

@end
