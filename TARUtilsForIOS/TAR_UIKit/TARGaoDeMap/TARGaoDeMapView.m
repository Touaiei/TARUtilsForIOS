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
{
    MAMapView *_mapView;//地图View
    MAPointAnnotation *_pointAnnotation;//大头针

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
    _isShowPoint = YES;
    _isLockedPointToScreen = YES;
    _isLockedPointToScreenCenter = YES;
}

-(void)initInterfaceBuild
{
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
    _mapView.delegate = _mapViewDelegate;
    _mapView.showsCompass = NO;//是否显示罗盘，默认为YES
    _mapView.showsScale = NO;//是否显示比例尺，默认为YES
    ///把地图添加至view
    [self addSubview:_mapView];
    
    
    [self addUserLocationMark];
    
    if (_isShowPoint) {
        [self initMAPointAnnotation];
    }
}
-(void)addUserLocationMark
{
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
}
-(void)initMAPointAnnotation
{
    /*如果您需要显示大头针需添加PointAnnotation*/
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
    
    CGFloat pointAnnotation_Center_X = self.width/2.0;
    CGFloat pointAnnotation_Center_Y = self.height/2.0;
    _pointAnnotation = [[MAPointAnnotation alloc] init];
    _pointAnnotation.title = @"方恒国际";
    _pointAnnotation.subtitle = @"阜通东大街6号";
//    _pointAnnotation.coordinate = CLLocationCoordinate2DMake(_mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude);

    [_mapView addAnnotation:_pointAnnotation];
    
    
    NSLog(@"pointAnnotation.coordinate1==%f   %f",_pointAnnotation.coordinate.latitude,_pointAnnotation.coordinate.longitude);
    NSLog(@"mapView.userLocation.location1==%f   %f",_mapView.userLocation.location.coordinate.latitude,_mapView.userLocation.location.coordinate.longitude);
    NSLog(@"mapView.centerCoordinate1==%f   %f",_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
    
    
    
    
    //        [self setddMapViewCenterCoordinates:_pointAnnotation.coordinate];
}



#pragma mark --MAMapViewDelegate--
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}








-(void)setPointLocationCoordinate:(CLLocationCoordinate2D)pointLocationCoordinate
{
    _pointLocationCoordinate = pointLocationCoordinate;
    _pointAnnotation.coordinate = _pointLocationCoordinate;
}






-(void)setIsLockedPointToScreenCenter:(BOOL)isLockedPointToScreenCenter
{
    _isLockedPointToScreenCenter = isLockedPointToScreenCenter;
    if (_isLockedPointToScreenCenter == YES) {
        if (_isLockedPointToScreen == YES) {
            [self setIsLockedPointToScreen:_isLockedPointToScreenCenter];
            [self setPointScreenCoordinate:self.center];
        }
    }
}

-(void)setIsLockedPointToScreen:(BOOL)isLockedPointToScreen
{
    _isLockedPointToScreen = isLockedPointToScreen;
    _pointAnnotation.lockedToScreen = _isLockedPointToScreen;//大头针是否固定到屏幕上
}
-(void)setPointScreenCoordinate:(CGPoint)pointScreenCoordinate
{
    _pointScreenCoordinate = pointScreenCoordinate;
    if (_isLockedPointToScreen == YES) {
        _pointAnnotation.lockedScreenPoint = _pointScreenCoordinate;//大头针固定到屏幕上的坐标点
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
