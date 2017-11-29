//
//  TARProcessViewItem.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/21.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
进程View Item
*/
#import <UIKit/UIKit.h>
#import "TAR_ProgressItemModel.h"

@interface TARProcessViewItem : UIView
@property(nonatomic, strong)TAR_ProgressItemModel *itemModel;
@property(nonatomic, assign)double selfView_TotalH;
@property(nonatomic, assign)int row;
@property(nonatomic, assign)BOOL isShowCellLeftViewImageView;
@property(nonatomic, assign)BOOL isFirst;//是第一个
@property(nonatomic, assign)BOOL isLast;//是最后一个



-(void)initWithItemModel:(TAR_ProgressItemModel *)itemModel;





@end



