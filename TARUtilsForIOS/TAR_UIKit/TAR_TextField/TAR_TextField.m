//
//  TAR_TextField.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/22.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_TextField.h"
#import "TARProgressHUD.h"

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
    self.delegate = self;
    _isEnabledEmoji = NO;
    
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
        case TAR_TextFieldStyle_Mony:{
            self.keyboardType = UIKeyboardTypeDecimalPad;
            
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


/**
 显示文本框警告动画
 */
- (void)showAlert{
    
    [self createAlertLayer];
    
    // 透明度变化
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.repeatCount = 5;
    opacityAnimation.repeatDuration = 2;
    opacityAnimation.autoreverses = YES;
    [self.alertLayer addAnimation:opacityAnimation forKey:@"opacity"];
    
    // 2秒后移除动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2秒后异步执行这里的代码...
        // 移除动画
        [self.alertLayer removeFromSuperlayer];
    });
    
}
/**
 创建文本框警告Layer
 */
- (void)createAlertLayer{
    // 设置layer相关属性
    self.alertLayer = [CAShapeLayer layer];
    // 大小和文本框一致
    self.alertLayer.frame = self.bounds;
    // 画线 非圆角
    self.alertLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.alertLayer.bounds cornerRadius:0].CGPath;
    // 线宽
    self.alertLayer.lineWidth = 6. / [[UIScreen mainScreen] scale];
    // 设置为实线
    self.alertLayer.lineDashPattern = nil;
    // 填充颜色透明色
    self.alertLayer.fillColor = [UIColor clearColor].CGColor;
    // 边框颜色为红色
    self.alertLayer.strokeColor = [UIColor redColor].CGColor;
    
    [self.layer addSublayer:self.alertLayer];
}


/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *  @return 是否允许改变
 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isContinue = YES;
    
    isContinue = [self emojiTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    
    switch (_textFieldStyle) {
        case TAR_TextFieldStyle_Default:
            return isContinue;
            break;
        case TAR_TextFieldStyle_Email:
            return isContinue;
            break;
        case TAR_TextFieldStyle_PhoneNumber:
            return isContinue;
            break;
        case TAR_TextFieldStyle_IdentityNumber:
            return isContinue;
            break;
        case TAR_TextFieldStyle_Mony:
            isContinue = [self monyTextField:textField shouldChangeCharactersInRange:range replacementString:string];
            break;
        default:
            return isContinue;
            break;
    }
    
    return isContinue;
}





/**
 表情输入限制
 */
-(BOOL)emojiTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_isEnabledEmoji == NO) {
        //返回NO即可，如上就实现了禁用emoji表情
        if ([self stringContainsEmoji:string] == YES) {
            return NO;
        }
    }
    return YES;
}


/**
 金额输入限制
 */
-(BOOL)monyTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    BOOL _isHaveDian;
    if ([textField.text containsString:@"."]) {
        _isHaveDian = YES;
    }else{
        _isHaveDian = NO;
    }
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        NSLog(@"single = %c",single);
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            [[TARProgressHUD sharedManager]showPromptAddToView:[UIApplication sharedApplication].keyWindow promptText:@"您的输入格式不正确" afterDelay:0];
            return NO;
        }
        
        // 只能有一个小数点
        if (_isHaveDian && single == '.') {
            [[TARProgressHUD sharedManager]showPromptAddToView:[UIApplication sharedApplication].keyWindow promptText:@"最多只能输入一个小数点" afterDelay:0];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    [[TARProgressHUD sharedManager]showPromptAddToView:[UIApplication sharedApplication].keyWindow promptText:@"第二个字符需要是小数点" afterDelay:0];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    [[TARProgressHUD sharedManager]showPromptAddToView:[UIApplication sharedApplication].keyWindow promptText:@"第二个字符需要是小数点" afterDelay:0];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (_isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [[TARProgressHUD sharedManager]showPromptAddToView:[UIApplication sharedApplication].keyWindow promptText:@"小数点后最多有两位小数" afterDelay:0];
                    return NO;
                }
            }
        }
        
    }
    return YES;
}






//判断NSString字符串是否包含emoji表情
- (BOOL)stringContainsEmoji:(NSString *)string
{
    /*
     方案一:
     //返回yes就是代表当前就是emoji（表情）模式
     
     if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
     return YES ;
     }else{
     return NO;
     }
     */
    /*
     方案二:
     //如果返回nil就是代表当前就是emoji（表情）模式
     */
    if ([[[UIApplication sharedApplication] textInputMode] primaryLanguage] == nil) {
        return YES;
    }else{
        return NO;
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
