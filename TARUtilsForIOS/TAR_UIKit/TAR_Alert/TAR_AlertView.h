//
//  TAR_AlertView.h
//  YouJiaApp
//
//  Created by TAR on 2017/6/20.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,TAR_AlertViewBoxMode) {
    TAR_AlertViewBoxMode_Prompt = 0, //Alert无需选择
    TAR_AlertViewBoxMode_Alert = 1   //Alert需要选择
    
};

@interface TAR_AlertView : UIAlertView
<UIAlertViewDelegate>
{
    UIAlertView *alertView;
}
@property(nonatomic,assign)TAR_AlertViewBoxMode alertViewBoxMode;


-(UIAlertView *)initAlertView;


@end
