//
//  ComplaintProgressViewCell.h
//  YouJiaApp
//
//  Created by TAR on 2017/12/7.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplaintProgressViewCellModel.h"
@interface ComplaintProgressViewCell : UIView

@property(nonatomic, strong)ComplaintProgressViewCellModel *itemModel;
@property(nonatomic, assign)double selfView_TotalH;
@property(nonatomic, assign)BOOL isShowCellLeftViewImageView;
@property(nonatomic, assign)int row;//当前（行）索引位置
@property(nonatomic, assign)BOOL isFirst;//是第一个
@property(nonatomic, assign)BOOL isLast;//是最后一个


-(void)initWithItemModel:(ComplaintProgressViewCellModel *)itemModel;
@end



#pragma mark ------------------------我是分割线------------------------
@interface ComplaintProgressViewCellLeftView : UIView
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *timeLabel;

@property(nonatomic, copy)NSString *titleName;
@property(nonatomic, copy)NSString *timeName;

-(CGFloat)getViewTotal_H;
-(void)interfaceBuilder;
@end



#pragma mark ------------------------我是分割线------------------------
@interface ComplaintProgressViewCellLineView : UIView
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIImageView *lineImageView;

@property(nonatomic, assign)BOOL isFirst;
@property(nonatomic, assign)BOOL isLast;
@property(nonatomic, assign)NSUInteger index;

-(void)resetLayout;
-(void)interfaceBuilder;
@end



#pragma mark ------------------------我是分割线------------------------
@interface ComplaintProgressViewCellRightView : UIView
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *timeLabel;
@property(nonatomic, copy)NSString *titleName;
@property(nonatomic, copy)NSString *timeName;

@property(nonatomic, assign)BOOL isFirst;
@property(nonatomic, assign)BOOL isLast;
@property(nonatomic, assign)NSUInteger index;

-(CGFloat)getViewTotal_H;
-(void)interfaceBuilder;
@end








