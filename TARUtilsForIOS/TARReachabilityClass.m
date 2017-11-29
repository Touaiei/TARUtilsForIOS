//
//  TARReachabilityClass.m
//  LLG
//
//  Created by GL on 16/11/2.
//  Copyright © 2016年 beijiguang. All rights reserved.
//

#import "TARReachabilityClass.h"

@interface TARReachabilityClass()
{
    
}
@property (nonatomic,strong)UIAlertView *alertView;
@end

@implementation TARReachabilityClass


//- (void)applicationDidFinishLaunching:(UIApplication *)application {
//    // ...
//    
//    // 监测网络情况
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name: kReachabilityChangedNotification
//                                               object: nil];
//    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
//    [hostReach startNotifier];
//    // ...
//}

-(void)realTimeNetworkStatus
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];//时时网络状态,网络状态有变化时将发出通知
//    [[self alloc]aaaa];
     [self aaaa];
    [_reachability startNotifier];//开始网络监测

}
-(NSString *)checkNetworkState
{
    [self aaaa];
    [self currentNetworkState];//检测当前的网络状态
    return returnState;
}
-(void)aaaa
{
    //    _reachability = [Reachability reachabilityWithHostName:@"www.google.com"];//监测具体站点的网络状态
    _reachability = [Reachability reachabilityForInternetConnection];
    
}
//网络状态发生变化时执行
- (void)networkStateChange
{
    if ([_reachability currentReachabilityStatus] == ReachableViaWiFi) {
        // 有wifi
        NSLog(@"有wifi");
        returnState = @"ReachableViaWiFi";
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示:"
                                                message:@"现在是WiFi环境,请放心使用!"
                                               delegate:nil
                                      cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertView:) userInfo:nil repeats:NO];
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"TARReachability" object:self userInfo:nil];
    } else if ([_reachability currentReachabilityStatus] == ReachableViaWWAN) {
        // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        returnState = @"ReachableViaWWAN";
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示:"
                                                message:@"现在使用的是手机流量!"
                                               delegate:nil
                                      cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertView:) userInfo:nil repeats:NO];
        
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"TARReachability" object:self userInfo:nil];
    } else { // 没有网络
        NSLog(@"没有网络!");
        returnState = @"NotReachable";
        
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"TARReachability" object:self userInfo:nil];
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示:"
                                                message:@"检查是否连接互联网!"
                                               delegate:nil
                                      cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertView:) userInfo:nil repeats:NO];
    }
}
-(void)currentNetworkState
{
    if ([_reachability currentReachabilityStatus] == ReachableViaWiFi) {
        // 有wifi
        NSLog(@"有wifi");
        returnState = @"ReachableViaWiFi";
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"TARReachability" object:self userInfo:nil];
    } else if ([_reachability currentReachabilityStatus] == ReachableViaWWAN) {
        // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        returnState = @"ReachableViaWWAN";
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"TARReachability" object:self userInfo:nil];
    } else { // 没有网络
        NSLog(@"没有网络!");
        returnState = @"NotReachable";

//        [[NSNotificationCenter defaultCenter]postNotificationName:@"TARReachability" object:self userInfo:nil];
        _alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示:"
                                                        message:@"检查是否连接互联网!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [_alertView show];
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertView:) userInfo:nil repeats:NO];
    }
}

-(void)dismissAlertView:(NSTimer *)timer
{
    NSLog(@"Dismiss alert view");
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"取消alertView");
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex==%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        NSLog(@"alertView");
    }
}




@end

