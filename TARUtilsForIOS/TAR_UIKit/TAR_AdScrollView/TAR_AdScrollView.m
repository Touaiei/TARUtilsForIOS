//
//  TAR_AdScrollView.m
//  JiaDuanAPP
//1111
//  Created by TAR on 2016/12/12.
//  Copyright © 2016年 TAR. All rights reserved.
//
/*
 *滚动广告自定义view
 */

#import "TAR_AdScrollView.h"

#define self_W self.bounds.size.width

@interface MyUIScrollView()
{
}
@end
@implementation MyUIScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"开始触摸屏幕!");
    if (!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸屏幕并移动!");
    if (!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸屏幕结束了!");
    if (!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸屏幕取消了!");
}
@end



typedef NS_ENUM(NSInteger,AdJumpToTarget) {
    AdJumpToTarget_Middle = 0,  //中间正常的
    AdJumpToTarget_First = 1,   //去第一个
    AdJumpToTarget_Last = -1    //去最后一个
};

@interface TAR_AdScrollView()
{
    //    enum _jmpFalg { NORMAL = 0, LAST = -1, FIRST = 1 };
    //    BOOL bJmp = NORMAL;
    
    AdJumpToTarget adToTarget;
    
    float maxLoc,minLoc;
}
@end
@implementation TAR_AdScrollView
#define ADIMG_INDEX 888

#pragma mark - ----- init frame
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        // init...
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self initializes];
    }
    return self;
}

-(void)initializes
{
    /*这里设置了一些默认属性,如果没有特别指定的话*/
    _timeInterval = 5.0f;
    _bottomViewColor = [UIColor blackColor];
    _bottomViewHeight = 25;
    _pageIndicatorTintColor = [UIColor whiteColor];
    _currentPageIndicatorTintColor = [UIColor redColor];
    _bottomViewAlpha = 0.5;
    _bottomViewIsHidden = NO;
    _pageControlIsHidden = NO;
    _isOpenTimer = YES;
    _describeTextLabelColor = [UIColor whiteColor];
    _describeTextLabelIsHidden = NO;
}
-(void)setPlaceholderImage:(UIImage *)image
{
    _placeholderImage = image;
}
- (void)adLoadWithArray:(NSArray<TARScrollViewItemModel *> *)array
{
    /* ad imgs */
    itemDataArray = array;
    NSLog(@"array===%@",array);
    /* ad scroll view */
    
    if(!_AD_ScrollView)
    {
        _AD_ScrollView = [[MyUIScrollView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.frame.size.width, self.frame.size.height)];
        _AD_ScrollView.delegate = self;
        _AD_ScrollView.userInteractionEnabled = YES;
        [_AD_ScrollView setScrollEnabled:YES];
        [_AD_ScrollView setPagingEnabled:YES];
        [_AD_ScrollView setShowsHorizontalScrollIndicator:NO];
        [_AD_ScrollView setShowsVerticalScrollIndicator:NO];
        [_AD_ScrollView setAlwaysBounceVertical:NO];
        [self addSubview:_AD_ScrollView];
    }
    [_AD_ScrollView setContentSize:CGSizeMake(self_W *([itemDataArray count]>0?[itemDataArray count]:0), _AD_ScrollView.frame.size.height)];
    
    /*bottomView*/
    if(!_bottomView)
    {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-_bottomViewHeight, self.bounds.size.width, _bottomViewHeight)];
        [_bottomView setAlpha:_bottomViewAlpha];
        [_bottomView setHidden:_bottomViewIsHidden];
        _bottomView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:_bottomView];
    }
    
    /* PageControl */
    if(!_pageControl)
    {
//        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 64.f, 8.f)];
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setCenter:CGPointMake(_AD_ScrollView.bounds.size.width/2.f, _bottomView.centerY)];
        _pageControl.backgroundColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
        [_pageControl setUserInteractionEnabled:YES];
        [_pageControl setAutoresizesSubviews:YES];
        [_pageControl setHidden:_pageControlIsHidden];
        [_pageControl setAlpha:1.f];
        [_pageControl setCurrentPage:0];
    }
    [_pageControl setNumberOfPages:([itemDataArray count]>0?[itemDataArray count]:0)];
    [self addSubview:_pageControl];
    
    /*用于显示广告描述内容*/
    if(!_describeTextLabel)
    {
        _describeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, _bottomView.bounds.size.width/3.0, _bottomView.bounds.size.height)];
        _describeTextLabel.centerY = _bottomView.centerY;
        [_describeTextLabel setHidden:_describeTextLabelIsHidden];
        [self describeTextContent];
        _describeTextLabel.font = [UIFont systemFontOfSize:14.0];
        _describeTextLabel.textColor = _describeTextLabelColor;
        [self addSubview:_describeTextLabel];
    }
    
    [self AddAdImg:array];
}
-(void)setPageControlLocation:(PageControlLocation)pageControlLocation
{
    _pageControlLocation = pageControlLocation;
    switch (pageControlLocation) {
            case PageControlLocation_left:
            break;
            case PageControlLocation_center:
            [_pageControl setCenter:CGPointMake(_AD_ScrollView.bounds.size.width/2.f, _bottomView.centerY)];

            break;
            case PageControlLocation_right:
            
            break;
        default:
            break;
    }
    
    
}






#pragma mark - ----- -> 初始化添加广告图片
- (void)AddAdImg:(NSArray <TARScrollViewItemModel *> *)arr_adimgs
{
    for (int i = 0; i < ([arr_adimgs count]>0?[arr_adimgs count]:0); ++i)
    {
        UIImageView *img_Ad = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0.f, self.frame.size.width, self.frame.size.height)];
        NSString *imageUrl;
        if (i < arr_adimgs.count) {
            TARScrollViewItemModel *itemModel = [arr_adimgs objectAtIndex:i];
            imageUrl = [NSString stringWithFormat:@"%@",itemModel.imagePath];
        }else{
            imageUrl = @"";
        }
        if ([imageUrl hasPrefix:@"http"]) {
            [img_Ad sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:Macro_PlaceholderImage];
        }else{
            [img_Ad setImage:[UIImage imageNamed:imageUrl]];
        }
        [img_Ad setTag:ADIMG_INDEX+i];
        [img_Ad setUserInteractionEnabled:YES];
        [_AD_ScrollView addSubview:img_Ad];
    }

    [self startTimer];

//    [self createMoneyIcon];
}

#pragma mark --描述文本显示的内容
-(void)describeTextContent
{
    NSInteger currentPage = _pageControl.currentPage;
    int count = (int)itemDataArray.count;
    TARScrollViewItemModel *itemModel = count-1 >= currentPage ? [itemDataArray objectAtIndex:currentPage]:[TARScrollViewItemModel new];
    NSString *describeStr = itemModel.title;
    _describeTextLabel.text = describeStr;
}
#pragma mark - ----- -> 点击广告
- (void)OpenAd:(int)iTag
{
    //    NSLog(@"click ad%d", iTag);
    if(self.description && [self.delegate respondsToSelector:@selector(clickJumpToAdWithIndex:withDataArray:) ])
    {
        [self.delegate clickJumpToAdWithIndex:iTag withDataArray:itemDataArray ];
    }
}
#pragma mark - ----- -> 定时器执行方法,->切换广告
static long cur_count = -1;
- (void)changedAdTimer:(NSTimer *)timer
{
//    NSLog(@"执行了timer!");
    cur_count = _pageControl.currentPage;
    ++cur_count;
    
    _pageControl.currentPage = (cur_count%[itemDataArray count]);
    
    [self changeScrollViewContentOffset];
    
    //判断闪闪的红包图标 是否显示
//    [self judgeRedEnvelopeIsShow];
    [self describeTextContent];
}

/**
 改变ScrollViewContentOffset
 */
-(void)changeScrollViewContentOffset
{
    [UIView animateWithDuration:1.0f animations:^{
        _AD_ScrollView.contentOffset = CGPointMake((_pageControl.currentPage%[itemDataArray count])*self_W, 0.f);
    }];
    maxLoc = minLoc = _AD_ScrollView.contentOffset.x;
}

#pragma mark --初始化定时器
-(void)startTimer
{
    if (_isOpenTimer == YES) {
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(changedAdTimer:) userInfo:nil repeats:YES];
        }
    }else{
        
    }
}

#pragma mark --移除定时器,并释放内存
-(void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];//invalidate 移除定时器,这步是必须的,不然不会释放
        _timer = nil;//timer 一定置为nil
    }
}
-(void)distantPastTimer
{
    /*//定时器开始运行*/
    [_timer setFireDate:[NSDate distantPast]];//定时器开始运行
}
-(void)distantFutureTimer
{
    /*//定时器暂停运行*/
    [_timer setFireDate:[NSDate distantFuture]];//定时器暂停运行
}






/*写一下set方法,这样使用 .属性 和 set方法 都可以调用了*/
- (void)setBottomViewIsHidden:(BOOL)bottomViewIsHidden{
    _bottomViewIsHidden = bottomViewIsHidden;
    self.bottomView.hidden = bottomViewIsHidden;
}

- (void)setPageControlIsHidden:(BOOL)pageControlIsHidden{
    _pageControlIsHidden = pageControlIsHidden;
    _pageControl.hidden = pageControlIsHidden;
}

- (void)setBottomViewAlpha:(CGFloat)alpha{
    _bottomViewAlpha = alpha;
    self.bottomView.alpha = alpha;
}
- (void)setBottomViewHeight:(CGFloat)height{
    _bottomViewHeight = height;
    self.bottomView.height = height;
}
- (void)setPageIndicatorTintColor:(UIColor *)color{
    _pageIndicatorTintColor = color;
    self.pageControl.pageIndicatorTintColor = color;
}
- (void)setCurrentPageIndicatorTintColor:(UIColor *)color{
    _currentPageIndicatorTintColor = color;
    self.pageControl.currentPageIndicatorTintColor = color;
}
- (void)setDescribeTextLabelIsHidden:(BOOL)isHidden{
    _describeTextLabelIsHidden = isHidden;
    self.describeTextLabel.hidden = isHidden;
}
-(void)setDescribeTextLabelColor:(UIColor *)describeTextLabelColor
{
    _describeTextLabelColor = describeTextLabelColor;
    self.describeTextLabel.textColor = describeTextLabelColor;
}


#pragma mark ----- -> touches opt
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"开始触摸屏幕!");
    //    UITouch *touch = [touches anyObject];
    //    CGPoint startPos = [touch locationInView:self];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸屏幕并移动!");
    //UITouch *touch = [touches anyObject];
    //CGPoint movePos = [touch locationInView:self];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self OpenAd:(int)_pageControl.currentPage];
    NSLog(@"触摸屏幕结束了!");
    //    UITouch *touch = [touches anyObject];
    //    CGPoint endPos;
    //    UIImageView *lbl_AdImg;
    //
    //    for (int i = 0; i < ([itemDataArray count]>0?[itemDataArray count]:0); ++i)
    //    {
    //        lbl_AdImg = (UIImageView *)[self viewWithTag:ADIMG_INDEX+i];
    //        endPos = [touch locationInView:lbl_AdImg];
    ////        [self OpenAd:i];
    //        NSLog(@"iiiii==%d",i);
    //        if (endPos.x >= 0.f && endPos.x <= WScreen){
    //
    //            [self OpenAd:i];
    //        }
    //
    //    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸屏幕取消了!");
}

#pragma mark - ----- -> scrollView opt
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"正在滚动中!");
    maxLoc = (maxLoc>scrollView.contentOffset.x)?maxLoc:scrollView.contentOffset.x;
    minLoc = (minLoc<scrollView.contentOffset.x)?minLoc:scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"将要开始拖拽!");
    
    //    [self distantFutureTimer];
    [self stopTimer];//销毁定时器,并释放内存
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"将要结束拖拽!");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"已经结束拖拽!");
    //    [self distantPastTimer];
    [self startTimer];//初始化定时器
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"将要开始减速!");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"已经结束减速!");
    do
    {
        if (maxLoc > ([itemDataArray count]-1)*self_W)
        {
            adToTarget = AdJumpToTarget_First;
            break;
        }
        else if (minLoc < 0*self_W)
        {
            adToTarget = AdJumpToTarget_Last;
            break;
        }
        else
        {
            adToTarget = AdJumpToTarget_Middle;
            break;
        }
    } while (TRUE);
    switch (adToTarget)
    {
            case AdJumpToTarget_First:
        {
            NSLog(@"AdJumpToTarget_First");
//            _pageControl.currentPage = 0;
        }
            break;
            case AdJumpToTarget_Middle:
        {
            NSLog(@"AdJumpToTarget_Middle");
            [_pageControl setCurrentPage:scrollView.contentOffset.x/self_W];
        }
            break;
            case AdJumpToTarget_Last:
        {
            NSLog(@"AdJumpToTarget_Last");
//            _pageControl.currentPage = ([itemDataArray count]>0?[itemDataArray count]:0);
        }
            break;
        default:
            break;
    }
    [self changeScrollViewContentOffset];
    
    
    
    //判断闪闪的红包图标 是否显示
//    [self judgeRedEnvelopeIsShow];
    
    [self describeTextContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"已经结束动画!");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
