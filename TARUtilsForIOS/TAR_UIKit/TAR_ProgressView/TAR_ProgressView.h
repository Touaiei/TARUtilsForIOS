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
//#import "TAR_ProgressItemModel.h"
//#import "TARProcessViewItem.h"
#import "ComplaintProgressViewCell.h"
#import "ComplaintProgressViewCellModel.h"

@interface TAR_ProgressView : UIView

@property(nonatomic,strong)NSArray <ComplaintProgressViewCellModel *> *progressDataArray;

-(void)initProgressViewWithDatas:(NSArray <ComplaintProgressViewCellModel *> *)datas;

-(CGFloat)getProgressViewTotalH;


/**
 千万记得布局完成以后，要调用该方法重置高度哦
 */
-(void)resetHeight;


@end
