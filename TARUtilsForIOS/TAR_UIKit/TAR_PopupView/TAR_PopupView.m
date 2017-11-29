//
//  TAR_PopupView.m
//  YouJiaApp
//
//  Created by TAR on 2017/8/25.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 自定义弹出窗口视图
 */
#import "TAR_PopupView.h"


@interface TAR_PopupView()
<
UITableViewDelegate,
UITableViewDataSource
>
{
}
@property(nonatomic,strong)UITableView *navBarDropDownListView;



@end
@implementation TAR_PopupView

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
    if (!_navBarDropDownListViewDatas) {
        _navBarDropDownListViewDatas = [[NSArray alloc]init];
    }
    _listCellHeight = 45;
    _navBarDropDownListViewWidth = 150;
    _BGViewAlpha = 0.1;

    
    [self setBGViewAlpha:_BGViewAlpha];
}



-(void)initInterfaceBuild
{
    switch (_popupViewStyle) {
        case NavBarPopupViewStyle_DropDown:
            [self initNavBarPopupView];

            break;
            
        default:
            
            break;
    }
    
}

-(void)startInterfaceBuild
{
    
}

-(void)initNavBarDropDownListViewWithDatas:(NSArray <PopupItemModel *> *)datas;
{
    _popupViewStyle = NavBarPopupViewStyle_DropDown;
    self.navBarDropDownListViewDatas = datas;
}


/**
 绘制向上三角形
 */
- (UIView *)upTriangleArrowView:(CGRect)rect
{
    CGFloat arrowView_X = rect.origin.x;
    CGFloat arrowView_Y = rect.origin.y;
    CGFloat arrowView_W = rect.size.width;
    CGFloat arrowView_H = rect.size.height;

    UIView *_arrowView = [[UIView alloc] init];
    // draw
    CGSize size = CGSizeMake(arrowView_W, arrowView_H);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(size.width / 2.0, 0)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    path.lineWidth = 1.0;
    
    CAShapeLayer *arrowLayer = [CAShapeLayer layer];
    arrowLayer.path = path.CGPath;
    
    _arrowView = [[UIView alloc] initWithFrame:CGRectMake(arrowView_X, arrowView_Y, size.width, size.height)];
    _arrowView.layer.mask = arrowLayer;
    _arrowView.backgroundColor = [UIColor whiteColor];

    return _arrowView;
}

/**
 绘制向下三角形
 */
- (UIView *)downTriangleArrowView:(CGRect)rect
{
    CGFloat arrowView_X = rect.origin.x;
    CGFloat arrowView_Y = rect.origin.y;
    CGFloat arrowView_W = rect.size.width;
    CGFloat arrowView_H = rect.size.height;
    
    UIView *_arrowView = [[UIView alloc] init];
    // draw
    CGSize size = CGSizeMake(arrowView_W, arrowView_H);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width / 2.0, size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    path.lineWidth = 1.0;
    
    CAShapeLayer *arrowLayer = [CAShapeLayer layer];
    arrowLayer.path = path.CGPath;
    
    _arrowView = [[UIView alloc] initWithFrame:CGRectMake(arrowView_X, arrowView_Y, size.width, size.height)];
    _arrowView.layer.mask = arrowLayer;
    _arrowView.backgroundColor = [UIColor redColor];
    
    return _arrowView;
}


-(void)initNavBarPopupView
{
    UIView *triangleArrowView = [self upTriangleArrowView:CGRectMake(self.width-38, 54, 20, 15)];
    [self addSubview:triangleArrowView];
    
    CGFloat navBarDropDownListView_X = [self getNavBarPopupListViewX];
    CGFloat navBarDropDownListView_Y = CGRectGetMaxY(triangleArrowView.frame);
    if (!_navBarDropDownListView) {
        _navBarDropDownListView = [[UITableView alloc]initWithFrame:CGRectMake(navBarDropDownListView_X, navBarDropDownListView_Y, _navBarDropDownListViewWidth, 100) style:UITableViewStylePlain];
        _navBarDropDownListView.delegate = self;
        _navBarDropDownListView.dataSource = self;
        _navBarDropDownListView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_navBarDropDownListView];

        [self setNavBarPopupListViewHeight];
    }else{
        [self navBarDropDownListViewReloadData];
    }
}

-(void)setNavBarPopupListViewX
{
    CGFloat navBarDropDownListView_X = [self getNavBarPopupListViewX];
    if (_navBarDropDownListView) {
        [_navBarDropDownListView setOriginX:navBarDropDownListView_X];
    }
}
-(CGFloat)getNavBarPopupListViewX
{
    CGFloat navBarDropDownListView_X = self.width - (_navBarDropDownListViewWidth+10);
    return navBarDropDownListView_X;
}
-(void)setNavBarPopupListViewY
{
    CGFloat navBarDropDownListView_Y = [self getNavBarPopupListViewY];
    if (_navBarDropDownListView) {
        [_navBarDropDownListView setOriginY:navBarDropDownListView_Y];
    }
}
-(CGFloat)getNavBarPopupListViewY
{
    CGFloat navBarDropDownListView_Y = 84;
    return navBarDropDownListView_Y;
}
-(void)setNavBarPopupListViewHeight
{
    if (_navBarDropDownListView) {
        CGFloat listView_H = [self getNavBarPopupListViewHeight];
        [_navBarDropDownListView setHeight:listView_H];
    }
}
-(void)setNavBarPopupListViewWidth
{
    if (_navBarDropDownListView) {
        [_navBarDropDownListView setWidth:_navBarDropDownListViewWidth];
    }
    [self setNavBarPopupListViewX];
}
-(CGFloat )getNavBarPopupListViewHeight
{
    CGFloat listView_H = _navBarDropDownListViewDatas.count * _listCellHeight;
    return listView_H>200?200:listView_H;
}

-(void)setListCellHeight:(CGFloat)listCellHeight
{
    _listCellHeight = listCellHeight;
}
-(void)setNavBarDropDownListViewDatas:(NSArray<PopupItemModel *> *)navBarDropDownListViewDatas
{
    _navBarDropDownListViewDatas = navBarDropDownListViewDatas;
    [self navBarDropDownListViewReloadData];
}
-(void)setNavBarDropDownListViewWidth:(CGFloat)navBarDropDownListViewWidth
{
    _navBarDropDownListViewWidth = navBarDropDownListViewWidth;
    [self setNavBarPopupListViewWidth];
}

-(void)navBarDropDownListViewReloadData
{
    if (_navBarDropDownListView) {
        [_navBarDropDownListView reloadData];
    }
}

-(void)hiddenSelf
{
    if (self) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
}
-(void)showSelf
{
    if (self) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.frame = window.bounds;
        [window addSubview:self];
        [self initInterfaceBuild];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self) {
        [self hiddenSelf];
    }
}
-(void)setBGViewAlpha:(CGFloat)BGViewAlpha
{
    _BGViewAlpha = BGViewAlpha;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:_BGViewAlpha];
}






#pragma mark //--TableViewDelegate--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _navBarDropDownListViewDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"MyIdentifier";
     UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     if (cell == nil) {
     cell = [_navBarDropDownListView dequeueReusableCellWithIdentifier:cellIdentifier];
     }
    PopupItemModel *model = [_navBarDropDownListViewDatas objectAtIndex:indexPath.row];
    NSString *image = model.imagePath;
    NSString *title = model.titleName;
    cell.imageView.image = [UIImage imageNamed:image];
    cell.imageView.size = CGSizeMake(25, 25);
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _listCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopupItemModel *itemModel = [_navBarDropDownListViewDatas objectAtIndex:indexPath.row];
    self.dropDownListClickCallback(indexPath.row, itemModel);
    [self hiddenSelf];
}
#pragma mark --TableViewDelegate--//





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
