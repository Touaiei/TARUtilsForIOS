//
//  TAR_AlertView.m
//  YouJiaApp
//
//  Created by TAR on 2017/6/20.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_AlertView.h"

@implementation TAR_AlertView

#pragma mark --initAlertView--

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"为了获取精准天气信息" message:@"请打开 设置->家端->位置->允许访问位置，" delegate:self cancelButtonTitle:@"不去了" otherButtonTitles:@"现在就去", nil];
        alert.delegate = self;
        [alert show];
        alertView = alert;
    }
    return self;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
