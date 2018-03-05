//
//  TARDeviceManager.m
//  EmployeesAPP
//
//  Created by TAR on 2018/2/27.
//  Copyright © 2018年 TAR. All rights reserved.
//
#define KIsiPhoneX

#import "TARDeviceManager.h"
//需要导入头文件：
#import <sys/utsname.h>





@implementation TARDeviceManager

/**
 获取APP版本号
 @return APP版本号
 */
+(NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 获取APP包版本号
 @return APP包版本号
 */
+(NSString *)getAppBundleVersion
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
}



/**
 获取系统版本号
 @return 返回系统版本号
 */
+(NSString *)getSystemVersion
{
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}


/**
 获取系统名称
 @return 返回系统名称
 */
+(NSString *)getSystemName
{
    NSString * iponeM = [[UIDevice currentDevice] systemName];
    return iponeM;
}

/**
 获取剩余电池电量
 @return 返回剩余电池电量
 */
+(CGFloat)getBatteryLevel
{
    CGFloat batteryLevel=[[UIDevice currentDevice] batteryLevel];
    return batteryLevel;
}


/**
 获取设备名称（例如：糖糖的iPhone）
 @return 设备名称
 */
+(NSString *)getDeviceName
{
    NSString * iponeM = [[UIDevice currentDevice] name];
    return iponeM;
}

/**
 获取设备类型（例如：@"iPhone", @"iPod touch"，@"iPad"）
 @return 设备类型
 */
+(NSString *)getDeviceModel
{
    NSString * iponeM = [[UIDevice currentDevice] model];
    return iponeM;
}

+(NSString *)getLocalizedModel
{
    NSString * iponeM = [[UIDevice currentDevice] localizedModel];
    return iponeM;
}


/**
 获取设备朝向（0：方向不明、 1：竖直、2：倒立、3：向左横屏、4：向右横屏、5：屏幕朝上、6：屏幕朝下）
 @return 设备朝向
 */
+(UIDeviceOrientation)getDeviceOrientation
{
    UIDeviceOrientation iponeM = [[UIDevice currentDevice] orientation];
    return iponeM;
}

+(NSUUID *)getIdentifierForVendor
{
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    return identifierForVendor;
}

+(UIDeviceBatteryState)getBatteryState
{
    UIDeviceBatteryState batteryState = [[UIDevice currentDevice] batteryState];
    return batteryState;
}
+(BOOL)getProximityState
{
    BOOL proximityState = [[UIDevice currentDevice] proximityState];
    return proximityState;
}
+(BOOL)getIsMultitaskingSupported
{
    BOOL isMultitaskingSupported = [[UIDevice currentDevice] isMultitaskingSupported];
    return isMultitaskingSupported;
}

+(UIUserInterfaceIdiom)getUserInterfaceIdiom
{
    UIUserInterfaceIdiom userInterfaceIdiom = [[UIDevice currentDevice] userInterfaceIdiom];
    return userInterfaceIdiom;
}




/**
 获取设备型号
 @return 设备型号
 */
+(NSString*)getDeviceType
{
    //需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4s";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
}

/**
 获取UUID(某应用+某设备 产生的唯一标识符)
 I(identifierForVendor) = X(某应用) + Y(某设备)
 @return 设备型号
 */
+(NSString*)getUUID
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

/**
 获取屏幕宽度
 @return 屏幕宽度
 */
+(CGFloat)getWidthScreen
{
    return [UIScreen mainScreen].bounds.size.width;
}
/**
 获取屏幕高度
 @return 屏幕高度
 */
+(CGFloat)getHeightScreen
{
    return [UIScreen mainScreen].bounds.size.height;
}



/**
 获取屏幕大小类型
 @return 屏幕大小类型
 */
+(ScreenSizeType)getScreenSizeType
{
    if ((int)[[UIScreen mainScreen] bounds].size.width==320&&[[UIScreen mainScreen] bounds].size.height==480 ?1:0) {
        return ScreenSizeType_Iphone4;
    }else if ((int)[[UIScreen mainScreen] bounds].size.width == 320?1:0) {
        return ScreenSizeType_Iphone5;
    }else if ((int)[[UIScreen mainScreen] bounds].size.width == 375?1:0) {
        return ScreenSizeType_Iphone6;
    }else if ((int)[[UIScreen mainScreen] bounds].size.width == 414?1:0) {
        return ScreenSizeType_Iphone6Plus;
    }else if ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO) {
        return ScreenSizeType_IphoneX;
    }else{
        return ScreenSizeType_Unknown;
    }
}

@end




