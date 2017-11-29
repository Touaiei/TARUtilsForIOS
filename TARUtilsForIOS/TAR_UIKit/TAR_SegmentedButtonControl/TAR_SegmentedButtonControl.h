//
//  TAR_SegmentedButtonControl.h
//  YouJiaApp
//
//  Created by TAR on 2017/8/14.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 自定义分段按钮
 */

#import <UIKit/UIKit.h>
#import "TARSegmentedButtonItemModel.h"

typedef void (^didSelectItemBlock)(NSInteger index,NSArray <TARSegmentedButtonItemModel *> *sourceDatas);

@interface TAR_SegmentedButtonControl : UIView
{
    
}
@property (nonatomic, strong)NSArray<TARSegmentedButtonItemModel *> *menuItemDatas;
@property (nonatomic, copy)didSelectItemBlock clickItemBlock;

@property (nonatomic, strong)UIColor *bottomLineColor_Selected;
@property (nonatomic, strong)UIColor *titleColor_Selected;
@property (nonatomic, strong)UIColor *titleColor_NotSelected;
@property (nonatomic, strong)UIColor *levelSpaceLineColor;





-(void)initMenuItemsWith:(NSArray <TARSegmentedButtonItemModel *>*)items;


@end
