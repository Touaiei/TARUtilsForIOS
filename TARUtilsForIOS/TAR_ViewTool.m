//
//  TAR_ViewTool.m
//  YouJiaApp
//
//  Created by TAR on 2017/4/7.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_ViewTool.h"

@implementation TAR_ViewTool

+(void)initPopupBox:(id)targetView
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W_Screen, H_Screen)];
    [BGView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [mainWindow addSubview:BGView];
    [BGView addSubview:targetView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenViewGesture:)];
    
    [BGView addGestureRecognizer:tap];
    
    
}

+(void)hiddenViewGesture:(UITapGestureRecognizer *)tap
{
    tap.view.hidden = YES;
}


@end
