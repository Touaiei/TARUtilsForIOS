//
//  AMapAPIManager.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/10/16.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 高德相关API管理（地图，导航，定位）等
 */
#import "AMapAPIManager.h"


@interface AMapAPIManager()
<
AMapNaviDriveManagerDelegate,
AMapNaviDriveViewDelegate

>
{
    AMapNaviDriveManager *_driveManager;
    AMapNaviDriveView *_driveView;
}
@end

@implementation AMapAPIManager
+ (instancetype)sharedManager
{
    static AMapAPIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AMapAPIManager alloc] init];
    });
    return instance;
}

#pragma mark --配置高德注册--
-(void)initAMapKey:(NSString *)key
{
    //@"f6b7ae8da0dabac83c2f305f2c953ba7"
    NSString *apiKey = [key isKindOfClass:[NSString class]]?key:@"";
    [AMapServices sharedServices].apiKey = apiKey;
}

#pragma mark --配置高德定位Manager--
-(void)initLocationManager
{
    
}





#pragma mark --配置高德导航Manager--
-(void)initNavigationManager
{
    if (_driveManager == nil)
    {
        _driveManager = [[AMapNaviDriveManager alloc] init];
        [_driveManager setDelegate:self];
    }
}

- (void)initDriveView
{
    if (_driveView == nil)
    {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:_targetView.bounds];
        [_driveView setDelegate:self];
    }
}
- (void)configDriveNavi
{
    [_driveManager addDataRepresentative:_driveView];
    [_targetView addSubview:_driveView];
}
- (void)calculateRoute:(NSArray<AMapNaviPoint *> *)startPoints endPoints:(NSArray<AMapNaviPoint *> *)endPoints
{
    [_driveManager calculateDriveRouteWithStartPoints:startPoints
                                                endPoints:endPoints
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    
    [_driveManager startEmulatorNavi];
}
@end




