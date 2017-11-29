//
//  TAR_SegmentedButtonControl.m
//  YouJiaApp
//
//  Created by TAR on 2017/8/14.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 自定义分段按钮
 */
#import "TAR_SegmentedButtonControl.h"


@interface TAR_SegmentedButtonControl()
{
    UIView *segmentedBGView;
    UIView *bottomLine;
    
}
@property(nonatomic,strong)NSMutableArray *segmentedButtonArray;//按钮集合

@end
@implementation TAR_SegmentedButtonControl
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bottomLineColor_Selected = [UIColor blueColor];
        _titleColor_Selected = [UIColor blueColor];
        _titleColor_NotSelected = [UIColor lightGrayColor];
    }
    return self;
}

#pragma mark --初始化主UI布局--
-(void)initMainUI
{
    
    
}


-(void)initSegmentedControl
{
    _segmentedButtonArray = [[NSMutableArray alloc]init];
    segmentedBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W_Screen, self.height)];
    [self addSubview:segmentedBGView];
    for (int i = 0; i<_menuItemDatas.count; i++) {
        TARSegmentedButtonItemModel *itemModel = [_menuItemDatas objectAtIndex:i];
        CGFloat segmentedButton_W = segmentedBGView.width/_menuItemDatas.count;
        CGFloat segmentedButton_H = segmentedBGView.height;
        UIButton *segmentedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentedButton.frame = CGRectMake(i*segmentedButton_W, (segmentedBGView.height - segmentedButton_H)/2.0, segmentedButton_W, segmentedButton_H);
        [segmentedButton setTitle:itemModel.name forState:UIControlStateNormal];
        segmentedButton.titleLabel.font = [UIFont systemFontOfSize:16];
        segmentedButton.tag = i;
        segmentedButton.backgroundColor = [UIColor whiteColor];
        [segmentedButton addTarget:self action:@selector(segmentedControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [segmentedBGView addSubview:segmentedButton];
        
        CGFloat levelSpaceLine_W = 2;
        CGFloat levelSpaceLine_H = segmentedButton.height;
        UIView *levelSpaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, (segmentedButton.height-levelSpaceLine_H)/2.0, levelSpaceLine_W, levelSpaceLine_H)];
        levelSpaceLine.backgroundColor = _levelSpaceLineColor;
        [segmentedButton addSubview:levelSpaceLine];
        
        CGFloat bottomLine_W = segmentedButton.width/2.0;
        CGFloat bottomLine_H = 2;
        bottomLine = [[UIView alloc]initWithFrame:CGRectMake((segmentedButton.width-bottomLine_W)/2.0, (segmentedButton.height-bottomLine_H), bottomLine_W, bottomLine_H)];
        bottomLine.backgroundColor = _bottomLineColor_Selected;
        [segmentedButton addSubview:bottomLine];
        
        if (i == 0) {
            [segmentedButton setTitleColor:_titleColor_Selected forState:UIControlStateNormal];
            bottomLine.hidden = NO;
            levelSpaceLine.hidden = YES;
        }else{
            [segmentedButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            bottomLine.hidden = YES;
            levelSpaceLine.hidden = NO;
        }
        [_segmentedButtonArray addObject:segmentedButton];
    }
}


-(void)segmentedControlClick:(UIButton *)sender
{
    for (int i = 0; i<_segmentedButtonArray.count; i++) {
        UIButton *button = [_segmentedButtonArray objectAtIndex:i];
        if (sender.tag == button.tag) {
            [button setTitleColor:_titleColor_Selected forState:UIControlStateNormal];
            UIView *line = [button.subviews lastObject];
            line.hidden = NO;
            line.backgroundColor = _bottomLineColor_Selected;
            [self segmentedControlClickAtIdenx:i];
        }else{
            [button setTitleColor:_titleColor_NotSelected forState:UIControlStateNormal];
            UIView *line = [button.subviews lastObject];
            line.hidden = YES;
        }
    }
    
    //    [self requestListData];
}
-(void)segmentedControlClickAtIdenx:(NSInteger)index
{
    self.clickItemBlock(index, _menuItemDatas);
}

-(void)setMenuItemDatas:(NSArray<TARSegmentedButtonItemModel *> *)menuItemDatas
{
    _menuItemDatas = menuItemDatas;
}

-(void)initMenuItemsWith:(NSArray<TARSegmentedButtonItemModel *> *)items
{
    self.menuItemDatas = items;
    NSLog(@"items==%@",items);
    
    [self initSegmentedControl];
}

-(void)setTitleColor_Selected:(UIColor *)titleColor_Selected
{
    _titleColor_Selected = titleColor_Selected;
}
-(void)setTitleColor_NotSelected:(UIColor *)titleColor_NotSelected
{
    _titleColor_NotSelected = titleColor_NotSelected;
}
-(void)setBottomLineColor_Selected:(UIColor *)bottomLineColor_Selected
{
    _bottomLineColor_Selected = bottomLineColor_Selected;
}
-(void)setLevelSpaceLineColor:(UIColor *)levelSpaceLineColor
{
    _levelSpaceLineColor = levelSpaceLineColor;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
