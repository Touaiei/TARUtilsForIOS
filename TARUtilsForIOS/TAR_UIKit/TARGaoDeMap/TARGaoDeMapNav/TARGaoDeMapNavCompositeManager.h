//
//  TARGaoDeMapNavCompositeManager.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/12/1.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TARGaoDe导航组合Manager（组合View涵盖 起、终点选择页面，多路线规划选择页面，导航页面）
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>//高德定位、地图、导航等基础包
#import <AMapLocationKit/AMapLocationKit.h>//高德定位包
#import <AMapNaviKit/AMapNaviKit.h>//高德导航包

@protocol TARGaoDeMapNavCompositeManagerDelegate;

@interface TARGaoDeMapNavCompositeManager : NSObject
@property (nonatomic, weak, nullable) id<TARGaoDeMapNavCompositeManagerDelegate>delegate;

/**
 // 初始化导航组合视图Manager
 */
-(void)initCompositeManager;


-(void)presentRoutePlanViewController;


@end


@protocol TARGaoDeMapNavCompositeManagerDelegate <NSObject>
@optional
/**
 * @brief 发生错误时,会调用此方法
 * @param compositeManager 导航SDK综合管理类
 * @param error 错误信息
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager error:(NSError *_Nonnull)error;

/**
 * @brief 算路成功后的回调函数,路径规划页面的算路、导航页面的重算等成功后均会调用此方法
 * @param compositeManager 导航SDK综合管理类
 */
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *_Nonnull)compositeManager;

/**
 * @brief 算路失败后的回调函数,路径规划页面的算路、导航页面的重算等失败后均会调用此方法
 * @param compositeManager 导航SDK综合管理类
 * @param error 错误信息,error.code参照 AMapNaviCalcRouteState .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager onCalculateRouteFailure:(NSError *_Nonnull)error;

/**
 * @brief 开始导航的回调函数
 * @param compositeManager 导航SDK综合管理类
 * @param naviMode 导航类型，参考 AMapNaviMode .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager didStartNavi:(AMapNaviMode)naviMode;

/**
 * @brief SDK需要实时的获取是否正在进行导航信息播报，以便SDK内部控制 "导航播报信息回调函数" 的触发时机，避免出现下一句话打断前一句话的情况. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 * @return 返回当前是否正在进行导航信息播报,如一直返回YES，"导航播报信息回调函数"就一直不会触发，如一直返回NO，就会出现语句打断情况，所以请根据实际情况返回。
 */
- (BOOL)compositeManagerIsNaviSoundPlaying:(AMapNaviCompositeManager *_Nonnull)compositeManager;

/**
 * @brief 导航播报信息回调函数,此回调函数需要和compositeManagerIsNaviSoundPlaying:配合使用. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 * @param soundString 播报文字
 * @param soundStringType 播报类型,参考 AMapNaviSoundType .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager playNaviSoundString:(NSString *_Nullable)soundString soundStringType:(AMapNaviSoundType)soundStringType;

/**
 * @brief 停止导航语音播报的回调函数，当导航SDK需要停止外部语音播报时，会调用此方法. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 */
- (void)compositeManagerStopPlayNaviSound:(AMapNaviCompositeManager *_Nonnull)compositeManager;

/**
 * @brief 当前位置更新回调
 * @param compositeManager 导航SDK综合管理类
 * @param naviLocation 当前位置信息,参考 AMapNaviLocation 类
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager updateNaviLocation:(AMapNaviLocation *_Nullable)naviLocation;

/**
 * @brief 导航到达目的地后的回调函数
 * @param compositeManager 导航SDK综合管理类
 * @param naviMode 导航类型，参考 AMapNaviMode .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager didArrivedDestination:(AMapNaviMode)naviMode;

@end




