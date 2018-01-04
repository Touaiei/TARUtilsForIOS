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
@property (nonatomic, assign)BOOL canShowCallout;///是否允许弹出callout(气泡)
@property (nonatomic, assign)CLLocationCoordinate2D centerCoordinate;//设置当前地图的中心地理坐标点。如果不设置就默认用户所在位置，如果没有显示用户位置就默认北京的坐标


/**
 添加一组大头针
 @param pointAnnotations 一组大头针对象
 */
-(void)addPointAnnotations:(NSArray<MAPointAnnotation *> *)pointAnnotations;

-(void)initInterfaceBuild;


@end
