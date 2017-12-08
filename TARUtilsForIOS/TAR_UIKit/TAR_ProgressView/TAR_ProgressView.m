//
//  TAR_ProgressView.m
//  EmployeesAPP
//
//  Created by TAR on 2017/8/16.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 流程进度View
 */
#import "TAR_ProgressView.h"
#import "TAR_StringToolClass.h"


@interface TAR_ProgressView()
{
    UIScrollView *_repairProgressBGView;

    CGFloat progressCellView_TotalH;
}


@end

@implementation TAR_ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initialize];
        
    }
    return self;
}

-(void)initialize
{


}

-(void)initRepairProgressView
{
    /*进度背景视图区域*/
    _repairProgressBGView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    //    _repairProgressBGView.backgroundColor = [UIColor greenColor];
    [self addSubview:_repairProgressBGView];

    /*循环创建CellView*/
    CGFloat progressCellView_Y=0.0;//processCellView 的Y坐标
    CGFloat progressCellView_BeforeHeight = 0.0;//上一个 processCellView 的高度
    for (int i = 0; i<_progressDataArray.count; i++) {
        ComplaintProgressViewCellModel *model = [_progressDataArray objectAtIndex:i];
        CGFloat repairProgressCellView_W = _repairProgressBGView.width;
        CGFloat processCellView_H = 0.0;
        ComplaintProgressViewCell *processCellView = [[ComplaintProgressViewCell alloc]initWithFrame:CGRectMake(0, 0, repairProgressCellView_W, processCellView_H)];
        processCellView.row = i;
        processCellView.isShowCellLeftViewImageView = YES;
        [_repairProgressBGView addSubview:processCellView];
        if (i==0) {
            processCellView.isFirst = YES;
        }
        if (i==_progressDataArray.count-1) {
            processCellView.isLast = YES;
        }
        [processCellView initWithItemModel:model];
        
        //重置 processCellView_H 值
        processCellView_H = processCellView.selfView_TotalH;
        //设置 processCellView_Y 值
        progressCellView_Y = progressCellView_Y+progressCellView_BeforeHeight;
        //设置 processCellView 前一次的高度
        progressCellView_BeforeHeight = processCellView_H;
        //重置 processCellView 当前高度
        [processCellView setHeight:processCellView_H];
        //设置 processCellView 当前Y坐标
        [processCellView setOriginY:progressCellView_Y];
        
        //设置所有 processCellView 总高度
        progressCellView_TotalH += processCellView_H;
    }
    CGFloat cContent_H = progressCellView_TotalH;
    [_repairProgressBGView setContentSize:CGSizeMake(_repairProgressBGView.width, cContent_H)];
}

-(void)initProgressViewWithDatas:(NSArray<ComplaintProgressViewCellModel *> *)datas
{
    _progressDataArray = datas;
    [self initRepairProgressView];
}

-(CGFloat)getProgressViewTotalH
{
    return progressCellView_TotalH;
}


-(void)resetHeight
{
    [_repairProgressBGView setHeight:progressCellView_TotalH];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
