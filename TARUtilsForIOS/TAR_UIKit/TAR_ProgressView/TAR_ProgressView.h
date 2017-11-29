//
//  TAR_ProgressView.h
//  EmployeesAPP
//
//  Created by TAR on 2017/8/16.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 流程进度View
 */
#import <UIKit/UIKit.h>
#import "TAR_ProgressItemModel.h"
#import "TARProcessViewItem.h"

@interface TAR_ProgressView : UIView

@property(nonatomic,strong)NSArray <TAR_ProgressItemModel *> *progressDataArray;

-(void)initProgressViewWithDatas:(NSArray <TAR_ProgressItemModel *> *)datas;

-(CGFloat)getProgressViewTotalH;
-(void)resetHeight;


@end
