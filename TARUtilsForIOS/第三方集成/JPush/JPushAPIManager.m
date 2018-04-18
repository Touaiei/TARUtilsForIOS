//
//  JPushAPIManager.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/10/16.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "JPushAPIManager.h"


#import "TaskListViewController.h"//任务列表
#import "TaskAssignedListViewController.h"//任务指派列表
#import "TAR_StringToolClass.h"


@implementation JPushAPIManager

/**
 单例
 @return 单例对象
 */
+ (instancetype)sharedManager
{
    static JPushAPIManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

-(void)JPushRegisterWithOptions:(NSDictionary *)launchOptions
{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        //         NSSet<UNNotificationCategory *> *categories for iOS10 or later
        //         NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    BOOL apsIsProduction;
    if ([FormalOrTest isEqualToString:@"Formal"]) {
        apsIsProduction = 1;
    }else{
        apsIsProduction = 0;
    }
    //d67594995c2194d67af6ec8c
    [JPUSHService setupWithOption:launchOptions appKey:@"a6dcfcf8279d3f535219ef84"
                          channel:@"App Store"
                 apsForProduction:apsIsProduction
            advertisingIdentifier:nil];
    
    //获取registrationID方法
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resultCode : %d,registrationID: %@",resCode,registrationID);
    }];
}

-(void)registerDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
-(void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    [JPUSHService handleRemoteNotification:remoteInfo];

}


#pragma mark --点击推送消息后在此处理--
-(void)clickPushMessageWithApplication:(UIApplication *)application andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"applicationState == %ld ，userInfo == %@",(long)application.applicationState,userInfo);
//        NSString *NotificationMsg = userInfo[@"aps"][@"alert"];
//        [[NSUserDefaults standardUserDefaults]setObject:NotificationMsg forKey:@"PropertyNewDynamic_KEY"];
    if (!self.window) {
        return;
    }
    UINavigationController *rootVC = [[self.window.rootViewController childViewControllers] firstObject];
    //    //用户点击推送通知测试VC

    TaskListViewController *webVC = [[TaskListViewController alloc]init];
    webVC.taskListType = TaskListType_Received;
    NSString *taskType = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:userInfo withKey:@"taskType"]?@"":[userInfo objectForKey:@"taskType"];;
    if ([taskType isEqualToString:@"a"]) {
        webVC.currentTypeIndex = 0;
        [rootVC pushViewController:webVC animated:YES];
        return;
    }else if ([taskType isEqualToString:@"b"]){
        webVC.currentTypeIndex = 1;
        [rootVC pushViewController:webVC animated:YES];
        return;
    }else if ([taskType isEqualToString:@"c"]){
        webVC.currentTypeIndex = 2;
        [rootVC pushViewController:webVC animated:YES];
        return;
    }else if ([taskType isEqualToString:@"d"]){
        webVC.currentTypeIndex = 3;
        [rootVC pushViewController:webVC animated:YES];
        return;
    }else if ([taskType isEqualToString:@"e"]){
        webVC.currentTypeIndex = 4;
        [rootVC pushViewController:webVC animated:YES];
        return;
    }else if ([taskType isEqualToString:@"f"]){
        webVC.currentTypeIndex = 5;
        [rootVC pushViewController:webVC animated:YES];
        return;
    }else if ([taskType isEqualToString:@"g"]){
        TaskAssignedListViewController*asdf = [[TaskAssignedListViewController alloc]init];
        [rootVC pushViewController:asdf animated:YES];
        return;
    }else{
    }
    /*
    switch (application.applicationState) {
        case UIApplicationStateActive:{
            //活跃状态
            NSLog(@"UIApplicationStateActive");
        }
            break;
        case UIApplicationStateInactive:
            //不活跃状态
            NSLog(@"UIApplicationStateInactive");
            break;
        case UIApplicationStateBackground:
            //在后台
            NSLog(@"UIApplicationStateBackground");
            break;
        default:
            //
            NSLog(@"applicationStateNotFind");
            break;
    }
    */
}


#pragma mark- JPUSHRegisterDelegate
//添加处理APNs通知回调方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"willPresentNotification");
    // Required
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"userInfo == %@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSLog(@"didReceiveNotificationResponse");
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"userInfo == %@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [self clickPushMessageWithApplication:nil andUserInfo:userInfo];
        
        NSLog(@"1111111111");
        
    }else{
        NSLog(@"2222222222");
        
    }
    completionHandler();  // 系统要求执行这个方法
}


@end
