//
//  ComplaintProgressViewCell.m
//  YouJiaApp
//
//  Created by TAR on 2017/12/7.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 进程View Item
 */
#import "ComplaintProgressViewCell.h"
#import "TAR_StringToolClass.h"

@interface ComplaintProgressViewCell()
{
    NSMutableArray *mainSubViews;
}

@end

@implementation ComplaintProgressViewCell

-(void)initWithItemModel:(ComplaintProgressViewCellModel *)itemModel
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
    CGFloat cellLeftView_W = 0;
    CGFloat cellLeftView_H = processCellView_H;
    ComplaintProgressViewCellLeftView *cellLeftView = [[ComplaintProgressViewCellLeftView alloc]initWithFrame:CGRectMake(0, 0, cellLeftView_W, cellLeftView_H)];
    [processCellView addSubview:cellLeftView];
    [cellLeftView interfaceBuilder];
    
    //进程线视图
    CGFloat lineBGView_W = 15;
    CGFloat lineBGView_H = 0;
    ComplaintProgressViewCellLineView *lineBGView = [[ComplaintProgressViewCellLineView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cellLeftView.frame), 0, lineBGView_W, lineBGView_H)];
    lineBGView.index = _row;
    lineBGView.isFirst = _isFirst;
    lineBGView.isLast = _isLast;
//    lineBGView.layer.borderColor = [UIColor greenColor].CGColor;
//    lineBGView.layer.borderWidth = 1;
    [processCellView addSubview:lineBGView];
    [lineBGView interfaceBuilder];
    
    //右边进度视图
    CGFloat cellRightView_W = processCellView_W-(cellLeftView.width + 10+10);
    CGFloat cellRightView_H = processCellView_H;
    ComplaintProgressViewCellRightView *cellRightView = [[ComplaintProgressViewCellRightView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineBGView.frame)+10, 0, cellRightView_W, cellRightView_H)];
    cellRightView.titleName = _itemModel.title;
    cellRightView.timeName = _itemModel.time;
//    cellRightView.layer.borderColor = [UIColor blueColor].CGColor;
//    cellRightView.layer.borderWidth = 1;
    [processCellView addSubview:cellRightView];
    [cellRightView interfaceBuilder];
    
    //设置progressCellView 右边内容View 高度
    cellRightView_H = [cellRightView getViewTotal_H];

    //设置processCellView 左边内容View 高度
    cellLeftView_H = [cellLeftView getViewTotal_H];
    
    //重置cellRightView高度和Y坐标
    [cellRightView setHeight:cellRightView_H];
    
    //重置cellLeftView高度和Y坐标
    [cellLeftView setHeight:cellLeftView_H];

    [mainSubViews addObject:cellLeftView];
    [mainSubViews addObject:cellRightView];
    
    //设置 processCellView 高度
    processCellView_H = [self getMainSubViewsMaxH];
    
    //重置lineBGView_H
    lineBGView_H = processCellView_H;
    //重置lineBGView高度
    [lineBGView setHeight:lineBGView_H];
    [lineBGView resetLayout];
    
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

-(void)setItemModel:(ComplaintProgressViewCellModel *)itemModel
{
    _itemModel = itemModel;
}

-(void)setSelfView_TotalH:(double)selfView_TotalH
{
    _selfView_TotalH = selfView_TotalH;
}

@end



#pragma mark ------------------------我是分割线------------------------
@interface ComplaintProgressViewCellLeftView()
{
    CGFloat topPadding;
    CGFloat bottomPadding;
    CGFloat timeLabelTopMargin;
}
@end
@implementation ComplaintProgressViewCellLeftView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    topPadding = 10;
    bottomPadding = 15;
}

-(void)interfaceBuilder
{

}

-(void)initTitleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
    }
}

-(void)initTimeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [self addSubview:_timeLabel];
    }
}

-(CGFloat)getViewTotal_H
{
    return [self calculationViewTotal_H];
}

-(CGFloat)calculationViewTotal_H
{
    CGFloat total_H = topPadding + _titleLabel.height + (_timeLabel.height+timeLabelTopMargin) + bottomPadding;
    return total_H;
}

@end



#pragma mark ------------------------我是分割线------------------------
@implementation ComplaintProgressViewCellLineView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    
}

-(void)interfaceBuilder
{
    [self initLineImageView];
    [self initLineView];
}

-(void)initLineImageView
{
    double lineImageView_W_H = 12;
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc]init];
        [self addSubview:_lineImageView];
    }
    _lineImageView.frame = CGRectMake((self.width-lineImageView_W_H)/2.0, 15, lineImageView_W_H, lineImageView_W_H);
}

-(void)initLineView
{
    CGFloat line_W = 1;
    CGFloat line_H = self.height;
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
    }
    _lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView.frame = CGRectMake((self.width-line_W)/2.0 , 0, line_W, line_H);
}

-(void)resetLayout
{
    if (_index == 0) {
        _lineImageView.image = [UIImage imageNamed:@"home_repairs_process_point_per"];
    }else{
        _lineImageView.image = [UIImage imageNamed:@"home_repairs_process_point"];
    }
    if (_isFirst == YES) {
        [_lineView setOriginY:_lineImageView.bottomY];
        [_lineView setHeight:self.height - _lineImageView.bottomY];
    }else if (_isLast == YES) {
        [_lineView setOriginY:0];
        [_lineView setHeight:_lineImageView.originY];
    }else{
        [_lineView setOriginY:0];
        [_lineView setHeight:self.height];
    }
}
@end



#pragma mark ------------------------我是分割线------------------------
@interface ComplaintProgressViewCellRightView()
{
    CGFloat topPadding;
    CGFloat bottomPadding;
    CGFloat timeLabelTopMargin;

}
@end
@implementation ComplaintProgressViewCellRightView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    topPadding = 10;
    bottomPadding = 15;
}

-(void)interfaceBuilder
{
    [self initTitleLabel];
    [self initTimeLabel];
}

-(void)initTitleLabel
{
    NSString *progressCellPositionName = _titleName;
    CGSize progressCellPositionSize = [TAR_StringToolClass calculateTextHeightWithText:_titleName andFont:14.0 andWidth:self.width/2.0];
    CGFloat progressCellPositionLabel_W = progressCellPositionSize.width;
    CGFloat progressCellPositionLabel_H = 25;
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
    }
    _titleLabel.frame = CGRectMake(0, topPadding, progressCellPositionLabel_W, progressCellPositionLabel_H);
    _titleLabel.font = FontSize_14;
    _titleLabel.text = progressCellPositionName;
    _titleLabel.textColor = [UIColor blueColor];
}

-(void)initTimeLabel
{
    timeLabelTopMargin = 5;
    NSString *rTimeName = _timeName;
    CGSize rTimeSize = [TAR_StringToolClass calculateTextHeightWithText:rTimeName andFont:14.0 andWidth:self.width];
    CGFloat rTimeLabel_W = rTimeSize.width;
    CGFloat rTimeLabel_H = rTimeSize.height;
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [self addSubview:_timeLabel];
    }
    _timeLabel.frame = CGRectMake(0, (CGRectGetMaxY(_titleLabel.frame))+timeLabelTopMargin, rTimeLabel_W, rTimeLabel_H);
    _timeLabel.font = FontSize_14;
    _timeLabel.text = rTimeName;
    _timeLabel.textColor = [UIColor lightGrayColor];
}

-(CGFloat)getViewTotal_H
{
    return [self calculationViewTotal_H];
}

-(CGFloat)calculationViewTotal_H
{
    CGFloat total_H = topPadding + _titleLabel.height + (_timeLabel.height+timeLabelTopMargin) + bottomPadding;
    return total_H;
}

@end







