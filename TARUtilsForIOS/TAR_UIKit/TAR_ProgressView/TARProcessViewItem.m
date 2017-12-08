//
//  TARProcessViewItem.m
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/21.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 进程View Item
 */
#import "TARProcessViewItem.h"
#import "TAR_StringToolClass.h"

@interface TARProcessViewItem()
{
    NSMutableArray *mainSubViews;
}

@end

@implementation TARProcessViewItem


-(void)initWithItemModel:(TAR_ProgressItemModel *)itemModel
{
    [self setItemModel:itemModel];
    
    if (!mainSubViews) {
        mainSubViews = [[NSMutableArray alloc]init];
    }
    
    CGFloat processCellView_W = self.bounds.size.width;
    CGFloat processCellView_H = 0.0;
    UIView *processCellView = [[UIView alloc]initWithFrame:self.bounds];
    //        processCellView.backgroundColor = Color_Random;
    [self addSubview:processCellView];
    
    //左边进度图片视图
    CGFloat cellLeftViewTopPadding = 10;
    CGFloat cellLeftViewBottomPadding = 10;
    double cellLeftView_W = 70;
    CGFloat cellLeftView_H = processCellView_H;
    UIView *cellLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellLeftView_W, cellLeftView_H)];
//    cellLeftView.layer.borderWidth = 1;
//    cellLeftView.layer.borderColor = [UIColor redColor].CGColor;
    [processCellView addSubview:cellLeftView];
    
    NSString *timeName = _itemModel.title;
    UILabel *progressTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cellLeftViewTopPadding, 39, 20)];
    progressTimeLabel.text = timeName;
    progressTimeLabel.textColor = Color_MoreBlueColor;
    progressTimeLabel.font = [UIFont systemFontOfSize:14.0];
    [cellLeftView addSubview:progressTimeLabel];
    
    NSString *workName = _itemModel.subTitle;
    CGSize attendanceTimeSize = [TAR_StringToolClass calculateTextHeightWithText:workName andFont:14.0 andWidth:cellLeftView.width];
    CGFloat attendanceTimeTopMargin = 5;
    UILabel *progressStepsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(progressTimeLabel.frame)+attendanceTimeTopMargin, attendanceTimeSize.width, attendanceTimeSize.height)];
    progressStepsLabel.text = workName;
    progressStepsLabel.textColor = [UIColor lightGrayColor];
    progressStepsLabel.textAlignment = NSTextAlignmentCenter;
    progressStepsLabel.font = [UIFont systemFontOfSize:14.0];
    progressStepsLabel.numberOfLines = 2;
    [cellLeftView addSubview:progressStepsLabel];
    
    double cellLeftView_ImageView_W_H = 12;
    UIImageView *cellLeftViewImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cellLeftView.frame)-cellLeftView_ImageView_W_H, 15, cellLeftView_ImageView_W_H, cellLeftView_ImageView_W_H)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(cellLeftView.frame)-10, 0, 1, cellLeftView.height )];
    lineView.centerX = cellLeftViewImageView.centerX;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [cellLeftView addSubview:lineView];
    [cellLeftView addSubview:cellLeftViewImageView];

    //右边进度视图
    CGFloat cellRightViewTopPadding = 10;
    CGFloat cellRightViewBottomPadding = 10;
    CGFloat cellRightView_W = processCellView_W-(cellLeftView.width + 10+10+10);
    CGFloat cellRightView_H = processCellView_H;
    UIView *cellRightView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cellLeftView.frame)+10, 0, cellRightView_W, cellRightView_H)];
    //        cellRightView.layer.borderColor = [UIColor redColor].CGColor;
    //        cellRightView.layer.borderWidth = 1;
    [processCellView addSubview:cellRightView];
    
    /*
    NSString *progressCellTieleName = _itemModel.date;
    CGSize progressCellTieleSize = [TAR_StringToolClass calculateTextHeightWithText:progressCellTieleName andFont:16.0 andWidth:cellRightView.width];
    UIButton *_titleLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, cellRightViewTopPadding, 60, progressCellTieleSize.height)];
    [_titleLabel setBackgroundImage:[UIImage imageNamed:@"vehiche_state_maintenance"] forState:UIControlStateNormal];
    [_titleLabel setTitleColor:Color_YellowText forState:UIControlStateNormal];
    _titleLabel.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_titleLabel setTitle:progressCellTieleName forState:UIControlStateNormal];
    //        _titleLabel.backgroundColor = [UIColor redColor];
    [cellRightView addSubview:_titleLabel];
    //        CGFloat progressCellDateLabel_H = cellRightView.height*(1/3.0);
    */
    
    NSString *progressCellPositionName = _itemModel.status;
    CGSize progressCellPositionSize = [TAR_StringToolClass calculateTextHeightWithText:progressCellPositionName andFont:14.0 andWidth:cellRightView.width/2.0];
    CGFloat progressCellPositionLabel_W = progressCellPositionSize.width;
    CGFloat progressCellPositionLabel_H = 25;
    UILabel *_positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cellRightViewTopPadding, progressCellPositionLabel_W, progressCellPositionLabel_H)];
    _positionLabel.font = FontSize_14;
    _positionLabel.text = progressCellPositionName;
    _positionLabel.textColor = [UIColor yellowColor];
    [cellRightView addSubview:_positionLabel];
    if (_isShowCellLeftViewImageView == NO) {
        lineView.hidden = YES;
    }else{
        lineView.hidden = NO;
    }
    if (_row == 0) {
        cellLeftViewImageView.image = [UIImage imageNamed:@"time_late_spot"];
    }else{
//        CGFloat new_W_H = cellLeftView_ImageView_W_H/1.0;
        cellLeftViewImageView.image = [UIImage imageNamed:@"home_repairs_process_point"];
//        cellLeftViewImageView.size = CGSizeMake(new_W_H, new_W_H);
//        cellLeftViewImageView.origin = CGPointMake((cellLeftView.width - new_W_H)/2.0, 20);
    }
    if (_isFirst == YES) {
        [lineView setHeight:cellLeftView.height - cellLeftViewImageView.centerY];
        [lineView setOriginY:cellLeftViewImageView.centerY];
    }
    if (_isLast == YES) {
        [lineView setHeight:10];
        [lineView setOriginY:0];
    }
    //设置progressCellView 右边内容View 高度
    cellRightView_H = cellRightViewTopPadding + _positionLabel.height + cellRightViewBottomPadding;
    
    //设置processCellView 左边内容View 高度
    cellLeftView_H = cellLeftViewTopPadding+progressTimeLabel.height+(attendanceTimeTopMargin+ progressStepsLabel.height)+cellLeftViewBottomPadding;
    
    //重置cellRightView高度和Y坐标
    [cellRightView setHeight:cellRightView_H];
    
    //重置cellLeftView高度和Y坐标
    [cellLeftView setHeight:cellLeftView_H];
    [lineView setHeight:cellLeftView.height];
    
    [mainSubViews addObject:cellLeftView];
    [mainSubViews addObject:cellRightView];
    
    //设置 processCellView 高度
    processCellView_H = [self getMainSubViewsMaxH];

    [self setSelfView_TotalH:processCellView_H];
}

-(CGFloat)getMainSubViewsMaxH
{
    CGFloat maxH = 0.0;
    for (int i=0; i<mainSubViews.count; i++) {
        UIView *subView = (UIView *)[mainSubViews objectAtIndex:i];
        if (maxH < subView.height) {
            maxH = subView.height;
        }
    }
    return maxH;
}

-(void)setItemModel:(TAR_ProgressItemModel *)itemModel
{
    _itemModel = itemModel;
}

-(void)setSelfView_TotalH:(double)selfView_TotalH
{
    _selfView_TotalH = selfView_TotalH;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
