//
//  TARCategoryViewItemModel.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/15.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 类别View每项 Model
 */
#import <Foundation/Foundation.h>

@interface TARCategoryViewItemModel : NSObject

@property(nonatomic, copy)NSString *name;//类别名称

@property(nonatomic, copy)NSString *imagePath;//类别图标地址

@property(nonatomic, assign)BOOL isShowMark;//是否显示提醒标记



@end
