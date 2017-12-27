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
//@property (nonatomic, assign)CLLocationCoordinate2D pointLocationCoordinate;//大头针在地图上的地理坐标
@property (nonatomic, assign)BOOL isShowLockPoint;//是否显示固定在地图中心的大头针(默认 YES)
@property (nonatomic, assign)BOOL isShowUserLocationMark;//是否显示用户当前位置标记(默认 YES)


/**
 添加一组注释点
 @param coordinates 一组坐标点
 */
-(void)addAnnotationsPointLocationCoordinates:(NSArray *)coordinates annotationTypeNmae:(NSString *)annotationTypeNmae;


-(void)initInterfaceBuild;


@end
