//
//  TAR_PopupView.h popover
//  YouJiaApp
//
//  Created by TAR on 2017/8/25.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 自定义弹出窗口视图
 */
#import <UIKit/UIKit.h>
#include "PopupItemModel.h"
typedef void(^navBarDropDownListClickBlock)(NSUInteger index , PopupItemModel *itemModel);

typedef NS_ENUM(NSInteger,NavBarPopupViewStyle) {
    NavBarPopupViewStyle_DropDown
};

@interface TAR_PopupView : UIView
@property(nonatomic,strong)NSArray <PopupItemModel *> *navBarDropDownListViewDatas;
@property(nonatomic,assign)CGFloat BGViewAlpha;

@property(nonatomic,assign)CGFloat listCellHeight;
@property(nonatomic,assign)CGFloat navBarDropDownListViewWidth;

@property(nonatomic,assign)NavBarPopupViewStyle popupViewStyle;

@property(nonatomic,copy)navBarDropDownListClickBlock dropDownListClickCallback;



-(void)initNavBarDropDownListViewWithDatas:(NSArray <PopupItemModel *> *)datas;



-(void)showSelf;

@end



