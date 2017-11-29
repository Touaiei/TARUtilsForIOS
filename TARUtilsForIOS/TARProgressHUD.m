//
//  TARProgressHUD.m
//  YouJiaApp
//
//  Created by TAR on 2017/4/11.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TARProgressHUD.h"

@implementation TARProgressHUD

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modes = MBProgressHUDModeIndeterminate;
        _userInteractionEnabled = YES;
        _afterDelayTime = 3.0;
    }
    return self;
}

-(void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    if (self.HUD) {
        [self hiddenWithAnimated:YES];
    }
    if (!self.HUD) {
        self.HUD = [MBProgressHUD showHUDAddedTo:view animated:animated];
        _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _HUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
        _HUD.contentColor = [UIColor whiteColor];
        _HUD.label.numberOfLines = 2;
        _HUD.animationType = MBProgressHUDAnimationZoomOut;
    }
}
-(void)hiddenWithAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
//    _afterDelayTime = delay;
    [self.HUD hideAnimated:animated afterDelay:delay];
}

-(void)hiddenWithAnimated:(BOOL)animated
{
    [self.HUD hideAnimated:animated];;
}

#pragma mark --setter--
-(void)setModes:(MBProgressHUDMode)modes
{
    _modes = modes;
    self.HUD.mode = _modes;
}
-(void)setPromptText:(NSString *)promptText
{
    if (promptText == nil) {
        return;
    }
    _promptText = promptText;
    self.HUD.label.text = _promptText;
}
-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    _userInteractionEnabled = userInteractionEnabled;
    [self.HUD setUserInteractionEnabled:userInteractionEnabled];
}

-(void)setAfterDelayTime:(NSTimeInterval)afterDelayTime
{
    _afterDelayTime = afterDelayTime;
    
}
-(void)setHudPopupBoxType:(TARProgressHUDPopupBoxType)hudPopupBoxType
{
    _hudPopupBoxType = hudPopupBoxType;
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    _HUD.progress = progress;
}


/**
 未完成
 */
+(void)showPromptText:(NSString *)text addToView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    [[[self alloc]init] showHUDAddedTo:view animated:YES];
 //    [[self class] modes];
//    
//    self.modes;
//    self.HUD.mode = MBProgressHUDModeText;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    HUD.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.7f];
    HUD.contentColor = [UIColor whiteColor];
    HUD.label.numberOfLines = 2;
    HUD.animationType = MBProgressHUDAnimationZoomOut;
    
    
//    self.HUD.mode = _modes;
//    self.HUD.label.text = _promptText;
//    
//    [self.HUD setUserInteractionEnabled:userInteractionEnabled];


    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
