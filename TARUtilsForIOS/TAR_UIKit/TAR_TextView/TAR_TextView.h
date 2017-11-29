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

@property(nonatomic,strong)UILabel *placeholderLabel;//
@property(nonatomic,copy)NSString *placeholderText;//
@property(nonatomic,assign)CGFloat fontSize;//
@property (nonatomic,strong) CAShapeLayer *alertLayer;


/**
 显示文本框警告动画
 */
-(void)showAlert;

@end
