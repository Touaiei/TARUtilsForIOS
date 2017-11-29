//
//  TAR_AlertController.m
//  YouJiaApp
//
//  Created by TAR on 2017/7/13.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_AlertController.h"
@implementation TAR_AlertController

/**
 没有按钮(显示后自动消失)
 */
+(UIAlertController *)alertControllerStyleWithTitle:(NSString *)title mesasge:(NSString *)message viewController:(UIViewController *)vc afterDelay:(NSTimeInterval)afterDelay confirmHandler:(void(^)(UIAlertAction *action))confirmActionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alertController animated:YES completion:nil];
    
    [[self alloc] addDelayTime:alertController];
    return alertController;
}
-(void)addDelayTime:(UIAlertController *)alertC
{
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismissAlertBox:) userInfo:alertC repeats:NO];
}
-(void)dismissAlertBox:(NSTimer *)timer
{
    if ([timer.userInfo isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertController = timer.userInfo;
        [alertController dismissViewControllerAnimated:YES completion:^{}];
    }
}


/**
 只有确定按钮的(确认后有跳转)
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle viewController:(UIViewController *)vc confirmHandler:(void(^)(UIAlertAction *action))confirmActionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirmActionHandler];
    
    [alertController addAction:confirmAction];
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
    
}


/**
 有确定和取消按钮的(点击后有跳转)
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle )preferredStyle viewController:(UIViewController *)vc  confirmHandler:(void(^)(UIAlertAction *confirmAction))confirmHandler cancleHandler:(void(^)(UIAlertAction *cancleAction))cancleHandler
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
 
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:confirmHandler];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancleHandler];

    [alertController addAction:confirmAction];
    [alertController addAction:cancleAction];
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}

/**
 自定义多个UIAlertAction
 @param actionArray 请以数组形式传入对象@[@{@"title":@"取消",@"style":@"1"},@{@"title":@"确定",@"style":@"2"},@{@"title":@"警告",@"style":@"3"}]
 */
+(UIAlertController *)alertTitle:(NSString *)title mesasge:(NSString *)message preferredStyle:(UIAlertControllerStyle )preferredStyle actionArray:(NSArray *)actionArray viewController:(UIViewController *)vc  confirmHandler:(void(^)(UIAlertAction *action1))confirmHandler
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    for (int i = 0; i<actionArray.count; i++) {
        NSDictionary *actionDic = [actionArray objectAtIndex:i];
        UIAlertActionStyle actionStyle;
        if ([[actionDic objectForKey:@"style"] integerValue] == 1) {
            actionStyle = UIAlertActionStyleCancel;
        }else if ([[actionDic objectForKey:@"style"] integerValue] == 2){
            actionStyle = UIAlertActionStyleDefault;
        }else{
            actionStyle = UIAlertActionStyleDestructive;
        }
        UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:[actionDic objectForKey:@"title"] style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
            confirmHandler(action);
        }];
        [alertController addAction:confirmAction];
    }
    [vc presentViewController:alertController animated:YES completion:nil];
    return alertController;
    
}

@end
