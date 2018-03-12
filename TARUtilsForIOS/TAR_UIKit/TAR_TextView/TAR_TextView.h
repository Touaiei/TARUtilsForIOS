//
//  TAR_TextView.h
//  YouJiaApp
//
//  Created by TAR on 2017/3/1.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAR_TextView : UITextView
<
UITextViewDelegate
>
@property(nonatomic,copy)NSString *contentText;//内容文本
@property(nonatomic,strong)UILabel *placeholderLabel;//
@property(nonatomic,copy)NSString *placeholderText;//占位符文本
@property(nonatomic,assign)CGFloat fontSize;//字体大小
@property (nonatomic,strong) CAShapeLayer *alertLayer;


/**
 显示文本框警告动画
 */
-(void)showAlert;

@end

