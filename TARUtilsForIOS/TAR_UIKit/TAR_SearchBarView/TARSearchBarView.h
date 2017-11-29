//
//  TARSearchBarView.h
//  SinaWeibo
//
//  Created by user on 15/10/15.
//  Copyright © 2015年 ZT. All rights reserved.
//
/*
 自定义搜索框视图
 */

#import <UIKit/UIKit.h>

@protocol TARSearchBarViewDelegate <NSObject>

/**
 搜索按钮点击事件代理方法
 @param searchContent 搜索内容
 */
-(void)searchButtonClickProtocol:(NSString *)searchContent;

@end

@interface TARSearchBarView : UITextField
@property(nonatomic,weak)id<TARSearchBarViewDelegate>searchBarDelegate;
@property(nonatomic,strong)UIColor *placeholderColor;
@property(nonatomic,strong)UIFont *placeholderFont;

@property(nonatomic,assign)BOOL isCanEditing;//默认为YES


/**
 设置占位符颜色
 @param color UIColor对象
 */

//-(void)setPlaceholderColor:(UIColor *)color;
/**
 设置占位符字体大小
 @param font UIFont对象
 */
//-(void)setPlaceholderFont:(UIFont *)font;


+ (instancetype)searchBar;


@end







