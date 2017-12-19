//
//  TAR_TextField.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/22.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TAR_TextFieldStyle) {
    TAR_TextFieldStyle_Default = 0,
    TAR_TextFieldStyle_Email = 1,
    TAR_TextFieldStyle_PhoneNumber = 2,
    TAR_TextFieldStyle_IdentityNumber = 3,
    TAR_TextFieldStyle_Mony = 4,
};

@interface TAR_TextField : UITextField
<UITextFieldDelegate>

@property(nonatomic, assign)TAR_TextFieldStyle textFieldStyle;

@property(nonatomic, strong)UIColor *placeholderColor;

@property(nonatomic, strong)UIFont *placeholderFont;

@property(nonatomic, assign)NSTextAlignment placeholderTextAlignment;

@property(nonatomic,assign)BOOL isEnabledEmoji;//是否启用表情输入  (默认为NO)

@property (nonatomic,strong) CAShapeLayer *alertLayer;

/**
 显示文本框警告动画
 */
-(void)showAlert;



@end
