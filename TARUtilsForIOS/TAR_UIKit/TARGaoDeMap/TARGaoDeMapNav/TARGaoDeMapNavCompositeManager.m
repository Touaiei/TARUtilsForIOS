//
//  TARGaoDeMapNavCompositeManager.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/12/1.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TARGaoDe导航组合Manager（组合View涵盖 起、终点选择页面，多路线规划选择页面，导航页面）
 */
#import "TARGaoDeMapNavCompositeManager.h"

@interface TARGaoDeMapNavCompositeManager()
<AMapNaviCompositeManagerDelegate>
{
}
@property (nonatomic, strong) AMapNaviCompositeManager *compositeManager;

@end
@implementation TARGaoDeMapNavCompositeManager

/**
 // 初始化导航组合视图Manager
 */
-(void)initCompositeManager
{
    // 初始化
    _compositeManager = [[AMapNaviCompositeManager alloc] init];
    // 如果需要使用AMapNaviCompositeManagerDelegate的相关回调（如自定义语音、获取实时位置等），需要设置delegate
    _compositeManager.delegate = self;
}

-(void)addNaviCompositeUserConfig
{
    
}

/**
 启动导航组件 不传入起点、终点、途径点
 */
-(void)presentRoutePlanViewController
{
    // 通过present的方式显示路线规划页面, 在不传入起终点启动导航组件的模式下，options需传入nil
    [_compositeManager presentRoutePlanViewControllerWithOptions:nil];
}
/**
 启动导航组件 传入终点坐标和名称，不传高德POIId示例：
 */
-(void)presentRoutePlanViewControllerWithEndCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *_Nullable)name
{
    NSLog(@"latitude==%f  longitude==%f",coordinate.latitude,coordinate.longitude);
    //导航组件配置类 since 5.2.0
    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    //传入终点坐标
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude] name:name POIId:nil];
    //启动
    [self.compositeManager presentRoutePlanViewControllerWithOptions:config];
}
/**
 启动导航组件 传入起、终点，途径点，且传入高德POIId示例：
 */
-(void)presentRoutePlanViewControllerWithCompositeUserConfig:(AMapNaviCompositeUserConfig *_Nullable)userConfig
{
    //例如：
    /*
     //导航组件配置类 since 5.2.0
     AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
     //传入起点，并且带高德POIId
     [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeStart location:[AMapNaviPoint locationWithLatitude:40.080525 longitude:116.603039] name:@"北京首都机场" POIId:@"B000A28DAE"];
     //传入途径点，并且带高德POIId
     [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeWay location:[AMapNaviPoint locationWithLatitude:39.941823 longitude:116.426319] name:@"北京大学" POIId:@"B000A816R6"];
     //传入终点，并且带高德POIId
     [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:39.918058 longitude:116.397026] name:@"故宫" POIId:@"B000A8UIN8"];
     */
    //启动
    [self.compositeManager presentRoutePlanViewControllerWithOptions:userConfig];
}
/**
 启动导航组件 不经过路径规划页面直接发起导航示例：
 */
-(void)presentRoutePlanViewControllerDirectlyNavWithEndCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString *_Nullable)name;
{
    AMapNaviCompositeUserConfig *config = [[AMapNaviCompositeUserConfig alloc] init];
    //传入终点
    [config setRoutePlanPOIType:AMapNaviRoutePlanPOITypeEnd location:[AMapNaviPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude] name:name POIId:nil];
    //直接进入导航界面
    [config setStartNaviDirectly:YES];
    [self.compositeManager presentRoutePlanViewControllerWithOptions:config];
}


#pragma mark --AMapNaviCompositeManagerDelegate--
/**
 * @brief 发生错误时,会调用此方法
 * @param compositeManager 导航SDK综合管理类
 * @param error 错误信息
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager error:(NSError *_Nonnull)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
    [self.delegate compositeManager:compositeManager error:error];
}

/**
 * @brief 算路成功后的回调函数,路径规划页面的算路、导航页面的重算等成功后均会调用此方法
 * @param compositeManager 导航SDK综合管理类
 */
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *_Nonnull)compositeManager
{
    NSLog(@"onCalculateRouteSuccess,%ld",(long)compositeManager.naviRouteID);
    [self.delegate compositeManagerOnCalculateRouteSuccess:compositeManager];
}

/**
 * @brief 算路失败后的回调函数,路径规划页面的算路、导航页面的重算等失败后均会调用此方法
 * @param compositeManager 导航SDK综合管理类
 * @param error 错误信息,error.code参照 AMapNaviCalcRouteState .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager onCalculateRouteFailure:(NSError *_Nonnull)error
{
    NSLog(@"onCalculateRouteFailure error:{%ld - %@}", (long)error.code, error.localizedDescription);
    [self.delegate compositeManager:compositeManager onCalculateRouteFailure:error];
}

/**
 * @brief 开始导航的回调函数
 * @param compositeManager 导航SDK综合管理类
 * @param naviMode 导航类型，参考 AMapNaviMode .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi,%ld",(long)naviMode);
    [self.delegate compositeManager:compositeManager didStartNavi:naviMode];
}


/**
 * @brief 当前位置更新回调
 * @param compositeManager 导航SDK综合管理类
 * @param naviLocation 当前位置信息,参考 AMapNaviLocation 类
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager updateNaviLocation:(AMapNaviLocation *_Nullable)naviLocation
{
    NSLog(@"updateNaviLocation,%@",naviLocation);
    [self.delegate compositeManager:compositeManager updateNaviLocation:naviLocation];
}

/**
 * @brief 导航到达目的地后的回调函数
 * @param compositeManager 导航SDK综合管理类
 * @param naviMode 导航类型，参考 AMapNaviMode .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager didArrivedDestination:(AMapNaviMode)naviMode
{
    NSLog(@"didArrivedDestination,%ld",(long)naviMode);
    [self.delegate compositeManager:compositeManager didArrivedDestination:naviMode];
}


/**
 * @brief SDK需要实时的获取是否正在进行导航信息播报，以便SDK内部控制 "导航播报信息回调函数" 的触发时机，避免出现下一句话打断前一句话的情况. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 * @return 返回当前是否正在进行导航信息播报,如一直返回YES，"导航播报信息回调函数"就一直不会触发，如一直返回NO，就会出现语句打断情况，所以请根据实际情况返回。
 */
//- (BOOL)compositeManagerIsNaviSoundPlaying:(AMapNaviCompositeManager *_Nonnull)compositeManager
//{
//    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
//}

/**
 * @brief 导航播报信息回调函数,此回调函数需要和compositeManagerIsNaviSoundPlaying:配合使用. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 * @param soundString 播报文字
 * @param soundStringType 播报类型,参考 AMapNaviSoundType .
 */
//- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager playNaviSoundString:(NSString *_Nullable)soundString soundStringType:(AMapNaviSoundType)soundStringType
//{
//    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
//    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
//}

/**
 * @brief 停止导航语音播报的回调函数，当导航SDK需要停止外部语音播报时，会调用此方法. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 */
//- (void)compositeManagerStopPlayNaviSound:(AMapNaviCompositeManager *_Nonnull)compositeManager
//{
//    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
//}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
