//
//  TAR_CountdownTools.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/27.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_CountdownTools.h"

@implementation TAR_CountdownTools

#pragma mark --验证码倒计时--
+(void)countdownFormVerificationCode:(UIButton *)button;
{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //倒计时结束后 显示的文字
                [button setTitle:@"从新获取" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
                
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [UIView commitAnimations];
                //计时过程中要做的事及显示的文字
                
                [button setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


/**
 生成6位数的随机验证码（整数型）
 @return 生成的随机验证码（整数型）
 */
+(NSString *)generateRandomVerificationCode;
{
    NSInteger arc = arc4random()%999999;
    NSString *randomCodeVerificationCode = [NSString stringWithFormat:@"%0.6ld", (long)arc];
    [[NSUserDefaults standardUserDefaults]setObject:randomCodeVerificationCode forKey:Macro_VerificationCode_Key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"随机验证码是：%@",randomCodeVerificationCode);
    return randomCodeVerificationCode;
}


@end
