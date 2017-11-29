//
//  TAR_BlankContentView.h
//  YouJiaApp
//
//  Created by TAR on 2017/4/20.
//  Copyright © 2017年 TAR. All rights reserved.
//
/**
 无更多内容视图
 */
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,blankContentViewType) {
    blankContentViewType_NoContent = 0,     //无内容
    blankContentViewType_LoadFailure = 1    //加载失败
};


@protocol TAR_BlankContentViewDelegate <NSObject>
@optional

/**
 重新加载按钮代理
 */
-(void)reloadOrBackButton:(UIButton *)button;
@end
@interface TAR_BlankContentView : UIView

@property(nonatomic,weak)id<TAR_BlankContentViewDelegate>delegate;
@property(nonatomic,assign)blankContentViewType blankContentViewType;
@property (assign, nonatomic) CGSize imageViewSize;//图片View大小
@property (nonatomic, copy) NSString *imagePath;//图片路径
@property (nonatomic, copy) NSString *promptText;//提示文字
@property (nonatomic, strong)UIColor *promptTextColor;//提示文字颜色
@property (nonatomic, strong)UIFont *promptTextSize;//提示文字大小

@property (strong, nonatomic) UIButton *reloadButton;//重新加载按钮
@property (copy, nonatomic) void(^reloadCallback)(id sender);//重新加载按钮回调

/**
 需在设置完属性后调用，提前调用无效
 */
-(void)initInterfaceBuilder;

@end
