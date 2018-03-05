//
//  TARDeviceManager.h
//  EmployeesAPP
//
//  Created by TAR on 2018/2/27.
//  Copyright © 2018年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ScreenSizeType){
    /**
     获取屏幕大小类型
     */
    ScreenSizeType_Unknown = 0,
    ScreenSizeType_Iphone4 = 1,
    ScreenSizeType_Iphone5 = 2,
    ScreenSizeType_Iphone6 = 3,
    ScreenSizeType_Iphone6Plus = 4,
    ScreenSizeType_IphoneX = 5
};

@interface TARDeviceManager : NSObject


/**
 获取APP包版本号
 @return APP包版本号
 */
+(NSString *)getAppBundleVersion;

/**
 获取APP版本号
 @return APP版本号
 */
+(NSString *)getAppVersion;

/**
 获取系统版本号
 @return 返回系统版本号
 */
+(NSString *)getSystemVersion;

/**
 获取系统名称
 @return 返回系统名称
 */
+(NSString *)getSystemName;

/**
 获取剩余电池电量
 @return 返回剩余电池电量
 */
+(CGFloat)getBatteryLevel;

/**
 获取设备型号
 @return 设备型号
 */
+(NSString*)getDeviceType;

/**
 获取设备名称（例如：糖糖的iPhone）
 @return 设备名称
 */
+(NSString *)getDeviceName;

/**
 获取设备类型（例如：@"iPhone", @"iPod touch"，@"iPad"）
 @return 设备类型
 */
+(NSString *)getDeviceModel;

+(NSString *)getLocalizedModel;

/**
 获取设备朝向（0：方向不明、 1：竖直、2：倒立、3：向左横屏、4：向右横屏、5：屏幕朝上、6：屏幕朝下）
 @return 设备朝向
 */
+(UIDeviceOrientation)getDeviceOrientation;


/**
 获取UUID(某应用+某设备 产生的唯一标识符)
 I(identifierForVendor) = X(某应用) + Y(某设备)
 @return 设备型号
 */
+(NSString*)getUUID;



+(NSUUID *)getIdentifierForVendor;

+(UIDeviceBatteryState)getBatteryState;

+(BOOL)getProximityState;

+(BOOL)getIsMultitaskingSupported;

+(UIUserInterfaceIdiom)getUserInterfaceIdiom;


/**
 获取屏幕宽度
 @return 屏幕宽度
 */
+(CGFloat)getWidthScreen;
/**
 获取屏幕高度
 @return 屏幕高度
 */
+(CGFloat)getHeightScreen;

/**
 获取屏幕大小类型
 @return 屏幕大小类型
 */
+(ScreenSizeType)getScreenSizeType;

@end






