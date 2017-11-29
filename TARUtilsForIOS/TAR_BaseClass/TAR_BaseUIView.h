//
//  TAR_BaseUIView.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/6.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 基础UIView
 */
#import <UIKit/UIKit.h>

@interface TAR_BaseUIView : UIView

@property(nonatomic, strong)UIView *mainHeaderView;
@property(nonatomic, assign)CGFloat mainHeaderView_H_Total;

@property(nonatomic, strong)UIView *mainFooterView;
@property(nonatomic, assign)CGFloat mainFooterView_H_Total;

@property(nonatomic, strong)UIView *mainTableHeaderView;
@property(nonatomic, assign)CGFloat tableHeaderView_H_Offset;
@property(nonatomic, assign ,readonly)CGFloat tableHeaderView_W;

@property(nonatomic, assign)CGFloat mainHeaderView_H_Offset;

@property(nonatomic, assign)CGFloat mainFooterView_H_Offset;



-(void)addTableHeaderView_H_Offset:(CGFloat)Offset_H;
-(void)addSubviewToMainTableHeaderView:(UIView *)subview;
-(void)addSubviewToMainFooterView:(UIView *)subview;

@end
