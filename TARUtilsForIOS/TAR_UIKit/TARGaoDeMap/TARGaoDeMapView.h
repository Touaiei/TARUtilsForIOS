//
//  TARGaoDeMapView.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/30.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TAR高德地图MapView
 */
#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>//高德定位、地图、导航等基础包
#import <MAMapKit/MAMapKit.h>

@interface TARGaoDeMapView : UIView
@property (nonatomic, weak) id<MAMapViewDelegate> mapViewDelegate;//地图View的代理

@property (nonatomic, assign)CLLocationCoordinate2D pointLocationCoordinate;//大头针在地图上的地理坐标
@property (nonatomic, assign)BOOL isShowPoint;//是否显示大头针(默认 YES)
@property (nonatomic, assign)BOOL isLockedPointToScreen;//是否固定大头针到地图View上(默认 YES)
@property (nonatomic, assign)BOOL isLockedPointToScreenCenter;//是否固定大头针到地图View中心(默认 YES)
@property (nonatomic, assign)CGPoint pointScreenCoordinate;//大头针固定在地图View上的位置


-(void)initInterfaceBuild;


@end
