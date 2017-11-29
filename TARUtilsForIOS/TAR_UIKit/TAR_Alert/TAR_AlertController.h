//
//  TAR_AlertController.h
//  YouJiaApp
//
//  Created by TAR on 2017/7/13.
//  Copyright © 2017年 TAR. All rights reserved.
//
/**
 自定义封装UIAlertController
 */
#import <Foundation/Foundation.h>

@interface TAR_AlertController : NSObject

/**
 没有按钮(显示后自动消失)
 */
+(UIAlertController *)alertControllerStyleWithTitle:(NSString *)title mesasge:(NSString *)message viewController:(UIViewController *)vc afterDelay:(NSTimeInterval)afterDelay confirmHandler:(void(^)(UIAlertAction *action))confirmActionHandler;

/**
 只有确定按钮的(确认后有跳转)
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle viewController:(UIViewController *)vc confirmHandler:(void(^)(UIAlertAction *action))confirmActionHandler;

/**
 有确定和取消按钮的(点击后有跳转)
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle )preferredStyle viewController:(UIViewController *)vc  confirmHandler:(void(^)(UIAlertAction *confirmAction))confirmHandler cancleHandler:(void(^)(UIAlertAction *cancleAction))cancleHandler;

/**
 自定义多个UIAlertAction
 @param actionArray 请以数组形式传入对象@[@{@"title":@"确定",@"style":@"0"},@{@"title":@"取消",@"style":@"1"},@{@"title":@"警告",@"style":@"3"}]
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle )preferredStyle actionArray:(NSArray *)actionArray viewController:(UIViewController *)vc  confirmHandler:(void(^)(UIAlertAction *action1))confirmHandler;

@end


