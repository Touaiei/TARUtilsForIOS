//
//  TAR_ProvinceCityDistrictSelector.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2018/2/1.
//  Copyright © 2018年 TAR. All rights reserved.
//
/*
 省市区 联动选址器
 */
#import <UIKit/UIKit.h>

@protocol TARProvinceCityDistrictSelectorDelegate <NSObject>

-(void)didSelectedResultProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

@end

@interface TAR_ProvinceCityDistrictSelector : UIView
@property(nonatomic, weak)id<TARProvinceCityDistrictSelectorDelegate> delegate;
@property(nonatomic, assign)CGFloat actionBar_Height;



-(void)initInterfaceBuilder;

@end
