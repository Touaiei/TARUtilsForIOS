//
//  TAR_AdScrollView.h
//  JiaDuanAPP
//
//  Created by TAR on 2016/12/12.
//  Copyright © 2016年 TAR. All rights reserved.
//
/*
 *滚动广告自定义view
 */

#import <UIKit/UIKit.h>
#import "TARScrollViewItemModel.h"

@interface MyUIScrollView : UIScrollView

@end


@protocol AdScrollViewDelegate <NSObject>
-(void)clickJumpToAdWithIndex:(NSInteger)index withDataArray:(NSArray <TARScrollViewItemModel *> *)DataArray;
@end

/**
 pageControl位置
 - pageControlLocation_center: 中
 - pageControlLocation_left: 左
 - pageControlLocation_right: 右
 */
typedef NS_ENUM(NSInteger, PageControlLocation) {
    PageControlLocation_center = 0,
    PageControlLocation_left = 1,
    PageControlLocation_right = 2
};


@interface TAR_AdScrollView : UIView
{
//    MyUIScrollView  *AD_ScrollView; // 广告
    
    NSArray <TARScrollViewItemModel *> *itemDataArray;//横幅数据项Array

}
@property (nonatomic, strong)MyUIScrollView *AD_ScrollView; // 广告


@property(nonatomic,assign)id<AdScrollViewDelegate>delegate;



//
@property (nonatomic,assign)BOOL isOpenTimer;
@property (nonatomic, strong)NSTimer *timer;
/*自动滚动间隔时间*/
@property (nonatomic, assign)NSTimeInterval timeInterval;
//底部view
@property (nonatomic, strong)UIView *bottomView;
//底部view高度
@property (nonatomic, assign)CGFloat bottomViewHeight;
//底部view透明度
@property (nonatomic, assign)CGFloat bottomViewAlpha;
//底部view颜色
@property (nonatomic, strong)UIColor *bottomViewColor;
//是否隐藏底部view
@property (nonatomic, assign)BOOL bottomViewIsHidden;
//广告页码
@property (nonatomic, strong)UIPageControl *pageControl;
/*页面指示器色调的颜色*/
@property (nonatomic, strong)UIColor *pageIndicatorTintColor;
/*当前页面指示器色调的颜色 */
@property (nonatomic, strong)UIColor *currentPageIndicatorTintColor;
/*是否隐藏pageControl*/
@property (nonatomic, assign)BOOL pageControlIsHidden;

/**
 pageControl分页控制器位置
 */
@property (nonatomic, assign)PageControlLocation pageControlLocation;



/*显示广告描述标题内容*/
@property (nonatomic, strong)UILabel *describeTextLabel;
/*广告标题是否隐藏*/
@property (nonatomic, assign)BOOL describeTextLabelIsHidden;
/*广告标题文字颜色*/
@property (nonatomic, strong)UIColor *describeTextLabelColor;

@property (nonatomic, strong)UIImageView *moneyImageView;

@property (nonatomic, strong)UIImage *placeholderImage;

/**
 是否需要跨越最大（小）边界继续滚动
 */
@property (nonatomic, assign)BOOL isThroughBorder;



-(void)setPlaceholderImage:(UIImage *)image;
- (void)adLoadWithArray:(NSArray <TARScrollViewItemModel *>*)array;//添加图片数据
-(void)distantPastTimer;//定时器开始运行
-(void)distantFutureTimer;//定时器暂停运行
-(void)startTimer;//初始化定时器
-(void)stopTimer;//销毁定时器

@end
