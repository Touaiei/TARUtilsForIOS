//
//  WJScrollerMenuView.h
//  testTest
//
//  Created by wujunyang on 16/1/22.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPopupMenuView.h"
#import "MenuItemModel.h"


@protocol WJScrollerMenuDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index withSourceDatas:(NSArray <MenuItemModel *> *)sourceDatas;



@end


@interface WJScrollerMenuView : UIView
@property (nonatomic, weak) id  <WJScrollerMenuDelegate>delegate;

//初始化菜单项数组
@property(nonatomic,copy)NSArray <MenuItemModel *> *menuItemArray;
//菜单名称数组
@property(nonatomic,copy)NSArray *myTitleArray;
//选中菜单时的文字颜色
@property(nonatomic,strong)UIColor *selectedColor;
//未选中菜单的文字颜色
@property(nonatomic,strong)UIColor *noSlectedColor;
//文字的字体
@property(nonatomic,strong)UIFont *titleFont;
//下划线的颜色
@property(nonatomic,strong)UIColor *LineColor;
//当前选中的索引值
@property (nonatomic, assign) NSInteger currentIndex;

/**
 设置每个按钮上的小红点是否显示
 @param showArray 设置每个小红点是否显示的标记数组，数组内是BOOL值（YES：显示 NO：不显示）
 @param yesOrNo 控制是否显示小红点（YES：显示 NO：不显示）
 */
- (void)setSmallRedDotShowArray:(NSArray <NSNumber *> *)showArray isShow:(BOOL)yesOrNo;

/**
 初始化对象
 @param frame CGRect
 @param yesOrNo 是否显示+号按钮
 @return 返回实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame showArrayButton:(BOOL)yesOrNo;

@end
