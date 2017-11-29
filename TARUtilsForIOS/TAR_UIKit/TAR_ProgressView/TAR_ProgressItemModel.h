//
//  TAR_ProgressItemModel.h
//  EmployeesAPP
//
//  Created by TAR on 2017/9/14.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 TAR_ProgressView CellModel
 */
#import <Foundation/Foundation.h>

@interface TAR_ProgressItemModel : NSObject

@property(nonatomic, copy)NSString *headImage;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subTitle;
@property(nonatomic, copy)NSString *date;
@property(nonatomic, copy)NSString *status;


@end
