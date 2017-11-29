//
//  TAR_TextField.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/22.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_TextField.h"

@implementation TAR_TextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];

    }
    return self;
}

- (void)initialize
{
    _textFieldStyle = TAR_TextFieldStyle_Default;
//    self.clearButtonMode = UITextFieldViewModeAlways;//清空小叉叉

}

#pragma mark --初始化主UI布局--
-(void)initMainUI
{
    switch (_textFieldStyle) {
        case TAR_TextFieldStyle_Default:{
            
        }
            break;
        case TAR_TextFieldStyle_Email:{
            
        }
            break;
        case TAR_TextFieldStyle_PhoneNumber:{
            self.keyboardType = UIKeyboardTypeNumberPad;

        }
            break;
        case TAR_TextFieldStyle_IdentityNumber:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark --setter--

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];//设置占位符文字颜色
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];//设置占位符文字大小
}
-(void)setPlaceholderTextAlignment:(NSTextAlignment)textAlignment
{
    NSNumber * value = [NSNumber numberWithInteger:textAlignment];
    [self setValue:value forKeyPath:@"_placeholderLabel.textAlignment"];//设置占位符文字水平对齐方式
}
-(void)setTextFieldStyle:(TAR_TextFieldStyle)textFieldStyle
{
    _textFieldStyle = textFieldStyle;
    [self initMainUI];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
