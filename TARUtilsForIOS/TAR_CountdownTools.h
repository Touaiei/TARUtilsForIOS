//
//  TAR_CountdownTools.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/27.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAR_CountdownTools : NSObject


/**
 验证码倒计时
 @param button 按钮对象
 */
+(void)countdownFormVerificationCode:(UIButton *)button;

/**
 生成6位数的随机验证码（整数型）
 @return 生成的随机验证码（整数型）
 */
+(NSString *)generateRandomVerificationCode;

@end




