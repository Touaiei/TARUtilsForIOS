//
//  TARGaoDeMapView.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/30.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TAR高德地图MapView
 */
#import "TARGaoDeMapView.h"

@interface TARGaoDeMapView()
<MAMapViewDelegate>
{
    MAMapView *_mapView;//地图View
    
    NSArray<MAPointAnnotation *> *_pointAnnotations;//一组大头针
}


@end

@implementation TARGaoDeMapView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
        
    }
    return self;
}

-(void)initialize
{
    _isShowLockPoint = YES;
    _isShowUserLocationMark = YES;
    _canShowCallout = YES;
    
}

-(void)initInterfaceBuild
{
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
    
    [self initMAMapView];
}

#pragma mark --初始化地图View--
-(void)initMAMapView
{
    
    //设置地图屏幕中心的经纬度坐标点
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = NO;
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    _mapView.delegate = self;
    _mapView.showsCompass = NO;//是否显示罗盘，默认为YES
    _mapView.showsScale = NO;//是否显示比例尺，默认为YES
    ///把地图添加至view
    [self addSubview:_mapView];
    
    
    if (_isShowUserLocationMark) {
        [self addUserLocationMark];
    }
    if (_isShowLockPoint) {
        [self initLockPointPointAnnotation];
    }
}
-(void)addUserLocationMark
{
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
}
-(void)initLockPointPointAnnotation
{
    /*如果您需要显示大头针需添加PointAnnotation*/
    
    MAPointAnnotation *lockPoint = [[MAPointAnnotation alloc] init];
    lockPoint.lockedToScreen = YES;
    lockPoint.lockedScreenPoint = self.center;
    [_mapView addAnnotation:lockPoint];
}



#pragma mark --MAMapViewDelegate--
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= _canShowCallout;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        if ([annotation.title isEqualToString:@"垃圾箱(已满)"]) {
            annotationView.image = [UIImage imageNamed:@"box_hong_ic"];
        }else if ([annotation.title isEqualToString:@"垃圾箱(未满)"]) {
            annotationView.image = [UIImage imageNamed:@"box_km_ic"];
        }else if ([annotation.title isEqualToString:@"垃圾箱(空箱)"]) {
            annotationView.image = [UIImage imageNamed:@"box_lv_ic"];
        }else if ([annotation.title isEqualToString:@"清运车(有货)"]){
            annotationView.image = [UIImage imageNamed:@"che_ym_ic"];
        }else if ([annotation.title isEqualToString:@"清运车(空车)"]){
            annotationView.image = [UIImage imageNamed:@"che_wl_ic"];
        }
        return annotationView;
    }
    return nil;
}



-(void)addPointAnnotations:(NSArray<MAPointAnnotation *> *)pointAnnotations
{
    _pointAnnotations = pointAnnotations;
    [_mapView addAnnotations:_pointAnnotations];
}







/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
