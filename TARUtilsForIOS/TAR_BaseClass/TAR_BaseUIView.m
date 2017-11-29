//
//  TAR_BaseUIView.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/6.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 基础UIView
 */
#import "TAR_BaseUIView.h"

@interface TAR_BaseUIView()
{    
    UIColor *mainHeaderViewBackgroundColor;
    UIColor *mainFooterViewBackgroundColor;
    
    
    UITableView *mainTableView;
    CGFloat mainTableHeaderView_W;
    
    CGFloat tableHeaderView_H_Total;
    
    UIColor *selfViewBackgroundColor;
    UIColor *mainTableViewBackgroundColor;
    UIColor *mainTableHeaderViewBackgroundColor;

}
@property(nonatomic,assign)CGFloat mainTableView_Y;
@property(nonatomic,assign)CGFloat mainTableView_H;

@property(nonatomic, assign)CGFloat mainFooterView_Y;


;
@end
@implementation TAR_BaseUIView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self basisInitialize];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self basisInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self basisInitialize];
    }
    return self;
}

-(void)basisInitialize
{
    _mainHeaderView_H_Total = 0.0;
    mainHeaderViewBackgroundColor = [UIColor clearColor];
    
    _mainFooterView_H_Total = 0.0;
    _mainFooterView_Y = self.bounds.size.height-_mainFooterView_H_Total;
    mainFooterViewBackgroundColor = [UIColor clearColor];
    
    selfViewBackgroundColor = [UIColor whiteColor];
    
    mainTableViewBackgroundColor = [UIColor clearColor];
    _mainTableView_Y = 0.0;
    _mainTableView_H = self.bounds.size.height;

    mainTableHeaderViewBackgroundColor = [UIColor clearColor];
    mainTableHeaderView_W = mainTableView.bounds.size.width;
    
    [self basisInterfaceBuild];
}
-(void)basisInterfaceBuild
{
    [self initMainHeaderView];
    [self initMainTableView];
    [self initMainFooterView];
}
-(void)initMainHeaderView
{
    if (!_mainHeaderView) {
        _mainHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _mainHeaderView_H_Total)];
        _mainHeaderView.backgroundColor = mainHeaderViewBackgroundColor;
//        _mainHeaderView.layer.borderWidth = 1;
//        _mainHeaderView.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:_mainHeaderView];
    }
}
-(void)initMainFooterView
{
    if (!_mainFooterView) {
        _mainFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, _mainFooterView_Y, self.bounds.size.width, _mainFooterView_H_Total)];
        _mainFooterView.backgroundColor = mainFooterViewBackgroundColor;
//        _mainFooterView.layer.borderWidth = 1;
//        _mainFooterView.layer.borderColor = [UIColor yellowColor].CGColor;
        [self addSubview:_mainFooterView];
    }
}
-(void)initMainTableView
{
    if (!mainTableView) {
        mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _mainTableView_Y, self.bounds.size.width, _mainTableView_H) style:UITableViewStylePlain];
        mainTableView.bounces = NO;
        [mainTableView setShowsHorizontalScrollIndicator:YES];
        [mainTableView setShowsVerticalScrollIndicator:YES];
        mainTableView.backgroundColor = mainTableViewBackgroundColor;
//        mainTableView.layer.borderWidth = 1;
//        mainTableView.layer.borderColor = [UIColor greenColor].CGColor;
        [self addSubview:mainTableView];
        [mainTableView setTableFooterView:[[UIView alloc] init]];
    }
    
    [self initTableHeaderView];
}
-(void)initTableHeaderView
{
    if (!_mainTableHeaderView) {
        _mainTableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainTableHeaderView_W, mainTableView.height)];
        _mainTableHeaderView.backgroundColor = mainTableHeaderViewBackgroundColor;;
//        _mainTableHeaderView.layer.borderWidth = 1;
//        _mainTableHeaderView.layer.borderColor = [UIColor blueColor].CGColor;
    }
}
-(void)addTableHeaderView_H_Offset:(CGFloat)Offset_H;
{
    _tableHeaderView_H_Offset += Offset_H;
    [self setTableHeaderView_H_Total:_tableHeaderView_H_Offset+0];
}
-(void)setTableHeaderView_H_Total:(CGFloat)total_H
{
    tableHeaderView_H_Total = total_H;
    [self addTableHeaderView];
}
-(void)addTableHeaderView
{
    [_mainTableHeaderView setHeight:tableHeaderView_H_Total];
    [mainTableView setTableHeaderView:_mainTableHeaderView];
}



#pragma mark --setter--
-(void)setMainHeaderView_H_Total:(CGFloat)mainHeaderView_H_Total
{
    _mainHeaderView_H_Total = mainHeaderView_H_Total;
    if (_mainHeaderView) {
        [_mainHeaderView setHeight:_mainHeaderView_H_Total];
    }
    [self setMainTableView_Y:_mainHeaderView_H_Total];
}
-(void)setMainTableView_Y:(CGFloat)mainTableView_Y
{
    _mainTableView_Y = mainTableView_Y;
    if (mainTableView) {
        [mainTableView setOriginY:_mainTableView_Y];
    }
    [self setMainTableView_H:self.bounds.size.height - (_mainTableView_Y+_mainFooterView_H_Total)];
}
-(void)setMainTableView_H:(CGFloat)mainTableView_H
{
    _mainTableView_H = mainTableView_H;
    if (mainTableView) {
        [mainTableView setHeight:_mainTableView_H];
    }
}
-(void)setMainFooterView_H_Total:(CGFloat)mainFooterView_H_Total
{
    _mainFooterView_H_Total = mainFooterView_H_Total;
    if (_mainFooterView) {
        [_mainFooterView setHeight:_mainFooterView_H_Total];
    }
    [self setMainFooterView_Y:self.bounds.size.height-_mainFooterView_H_Total];
    [self setMainTableView_H:self.bounds.size.height - (_mainTableView_Y+_mainFooterView_H_Total)];
}
-(void)setMainFooterView_Y:(CGFloat)mainFooterView_Y
{
    _mainFooterView_Y = mainFooterView_Y;
    if (_mainFooterView) {
        [_mainFooterView setOriginY:_mainFooterView_Y];
    }
}

-(CGFloat)tableHeaderView_W
{
    return mainTableHeaderView_W;
}

-(void)addSubviewToMainTableHeaderView:(UIView *)subview
{
    [_mainTableHeaderView addSubview:subview];
}

-(void)addSubviewToMainFooterView:(UIView *)subview
{
    [_mainFooterView addSubview:subview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

