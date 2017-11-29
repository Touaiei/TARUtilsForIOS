//
//  TAR_CategoryScrollView.h
//  JiaDuanAPP
//
//  Created by TAR on 2016/12/12.
//  Copyright © 2016年 TAR. All rights reserved.
//
/*
 TAR的 类别View
 */
#import <UIKit/UIKit.h>
#import "TARCategoryViewItemModel.h"

//定义分类视图的风格 枚举
typedef NS_ENUM(NSUInteger,CategoryViewStyle) {
    CategoryViewStyle_OneLine,//一行可向右滑动
    CategoryViewStyle_TwoLine,//二行可向右滑动
    CategoryViewStyle_ThreeLine,//三行可向右滑动
    CategoryViewStyle_MoreLine//多行更多型
};

@protocol categoryScrollViewDelegate <NSObject>
//-(void)jumpToFenLeiWithIndex:(NSInteger)index withView:(UIView*)cellView withArray:(NSArray*)array;
- (void)TARCategoryView:(UIView *)categoryView didSelectItemAtIndex:(NSInteger)index withArray:(NSArray <TARCategoryViewItemModel *>*)array;;

@end

@interface TAR_CategoryScrollView : UIView
{
    UIScrollView  *myScrollView;
    CGFloat contentViewHight;//整体视图高度
}
@property(nonatomic,assign)double cell_W;
@property(nonatomic,assign)double cell_H;
@property(nonatomic,assign)double categoryBackView_W;
@property(nonatomic,assign)double categoryBackView_H;
@property(nonatomic,assign)BOOL isShowPagingControl;//左右滑动时是否显示分页控制器
@property(nonatomic,assign)BOOL isShowUnderline;//左右滑动时是否显示下划线




@property(nonatomic,weak)id<categoryScrollViewDelegate>delegate;
@property(nonatomic,assign)BOOL isSetBac;
@property(nonatomic,copy)NSMutableArray *viewsArray;
@property(nonatomic,strong)NSArray<TARCategoryViewItemModel *> *dataArray;
@property(nonatomic,assign)NSInteger selectIndex;//
@property(nonatomic,copy)NSString *pageJumpSource;//页面跳转来源
@property(nonatomic,assign)CategoryViewStyle categoryStyle;//分类视图的风格枚举
@property(nonatomic,assign)BOOL isShowRemindMark;//是否显示右上角提醒标记



-(void)addMyScrollSubViewsWithArray:(NSArray <TARCategoryViewItemModel *> *)array;
-(CGFloat)getContentViewHight;



@end
