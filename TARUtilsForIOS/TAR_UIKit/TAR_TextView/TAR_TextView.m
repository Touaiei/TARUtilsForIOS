//
//  TAR_TextView.m
//  YouJiaApp
//
//  Created by TAR on 2017/3/1.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_TextView.h"
#import "TAR_StringToolClass.h"
@implementation TAR_TextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _fontSize = 16;
        
        
    }
    return self;
}

-(void)setContentText:(NSString *)contentText
{
    _contentText = contentText;
    self.text = _contentText;
    if (_contentText.length > 0) {
        _placeholderLabel.hidden = YES;
    }
}
-(void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    [self initPlaceholderLabel];
}
-(void)initPlaceholderLabel
{
    _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, self.bounds.size.width, 25)];
    _placeholderLabel.font = [UIFont systemFontOfSize:16.0];
    _placeholderLabel.numberOfLines = 2;
    if ([_placeholderText length]>1) {
        _placeholderLabel.text = _placeholderText;
    }
    _placeholderLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_placeholderLabel];
    CGSize placeholderSize =  [TAR_StringToolClass calculateTextHeightWithText:_placeholderText andFont:_fontSize andWidth:_placeholderLabel.width];
    [_placeholderLabel setHeight:placeholderSize.height];
    
}
-(void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    self.font = [UIFont systemFontOfSize:fontSize];
    _placeholderLabel.font = [UIFont systemFontOfSize:fontSize];
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


-(void)textViewDidChange:(UITextView *)textView
{
    for (UILabel *tempLabel in textView.subviews) {
        if ([tempLabel isKindOfClass:[UILabel class]]) {
            if (textView.text.length>0) {
                tempLabel.hidden = YES;
            }else{
                tempLabel.hidden = NO;
            }
        }
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

