//
//  TARToolsClass_UpdateAppVersion.m
//  LLG
//
//  Created by GL on 16/11/1.
//  Copyright © 2016年 beijiguang. All rights reserved.
//

#import "TARToolsClass_UpdateAppVersion.h"

@implementation TARToolsClass_UpdateAppVersion

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        
//        
//        
//        
//    }
//    return self;
//}

-(void)alertBoxWithTitle:(NSString *)title andMessage:(NSString *)message
{
    if (alertView == nil) {
        alertView = [[UIAlertView alloc]initWithTitle:message message:title delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAlertBox:) userInfo:nil repeats:NO];
}






-(void)promptBoxWithTitle:(NSString *)title andMessage:(NSString *)message andTimer:(float)timer
{
    
}
-(void)dismissAlertBox:(NSTimer *)timer
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    alertView = nil;
}

#pragma mark --initAlertView--
-(UIAlertView *)nitAlertView111
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"为了获取精准天气信息" message:@"请打开 设置->家端->位置->允许访问位置，" delegate:self cancelButtonTitle:@"不去了" otherButtonTitles:@"现在就去", nil];
    alert.delegate = self;
    [alert show];
    
    return alert;
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex==%ld",(long)buttonIndex);

    if (buttonIndex == 0) {

    }else if (buttonIndex == 1) {
        
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");

}
@end


