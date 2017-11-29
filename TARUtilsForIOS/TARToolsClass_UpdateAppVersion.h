//
//  TARToolsClass_UpdateAppVersion.h
//  LLG
//
//  Created by GL on 16/11/1.
//  Copyright © 2016年 beijiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,TARAlertBoxMode) {
    TARAlertBoxMode_Prompt = 0, //无需选择
    TARAlertBoxMode_Alert = 1   //需要选择
    
};

@interface TARToolsClass_UpdateAppVersion : NSObject<UIAlertViewDelegate>
{
    UIAlertView *alertView;
}
@property(nonatomic,assign)TARAlertBoxMode alertBoxMode;

-(void)alertBoxWithTitle:(NSString *)title andMessage:(NSString *)message;

-(UIAlertView *)nitAlertView111;
@end
