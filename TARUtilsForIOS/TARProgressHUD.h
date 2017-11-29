//
//  TARProgressHUD.h
//  YouJiaApp
//
//  Created by TAR on 2017/4/11.
//  Copyright © 2017年 TAR. All rights reserved.
//
/**
 依赖第三方库：MBProgressHUD
 */
#import <Foundation/Foundation.h>
//#import <MBProgressHUD/MBProgressHUD.h>
#import <MBProgressHUD.h>

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, TARProgressHUDPopupBoxType) {
    TARProgressHUDPopupBoxType_Prompt = 0,              //弹出提示类型
    TARProgressHUDPopupBoxType_PromptForAutoHidden = 1, //弹出提示（并且自动隐藏）类型
    TARProgressHUDPopupBoxType_Alert = 2                //警报类型
};

@interface TARProgressHUD : NSObject

@property(nonatomic,strong)MBProgressHUD *HUD;
@property(nonatomic,assign)BOOL userInteractionOpen;  // default is NO
@property(nonatomic,copy)NSString *promptText;
@property(assign, nonatomic) MBProgressHUDMode modes;
@property(nonatomic,assign)TARProgressHUDPopupBoxType hudPopupBoxType;
@property (nonatomic, assign)BOOL removeFromSuperViewOnHide;
@property(nonatomic,assign)NSTimeInterval afterDelayTime;
@property(nonatomic,assign)BOOL userInteractionEnabled;  // default is YES. if set to NO, user events (touch, keys) are ignored and removed from the event queue.
/**
 * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
 */
@property (nonatomic, assign) float progress;

-(void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated;
-(void)hiddenWithAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
-(void)hiddenWithAnimated:(BOOL)animated;



+(void)showPromptText:(NSString *)text addToView:(UIView *)view afterDelay:(NSTimeInterval)delay;

@end
