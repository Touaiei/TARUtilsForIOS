//
//  JPushAPIManager.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/10/16.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>//iOS10中推送新添加
#endif

#import "JPUSHService.h"//JPush激光推送头文件

@interface JPushAPIManager : NSObject
<
JPUSHRegisterDelegate//激光JPush推送代理
>
@property(nonatomic, weak)UIWindow *window;

/**
 单例
 @return 单例对象
 */
+ (instancetype)sharedManager;

//激光推送注册
-(void)JPushRegisterWithOptions:(NSDictionary *)launchOptions;


-(void)registerDeviceToken:(NSData *)deviceToken;
-(void)handleRemoteNotification:(NSDictionary *)remoteInfo;


#pragma mark --点击推送消息后在此处理--
-(void)clickPushMessageWithApplication:(UIApplication *)application andUserInfo:(NSDictionary *)userInfo;

@end
