//
//  TARUploadImageViewItemModel.h
//  ZhiHuiHuanWeiAPP
//
//  Created by TAR on 2017/11/23.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 上传并展示图片View ItemModel
 */
#import <Foundation/Foundation.h>

@interface TARUploadImageViewItemModel : NSObject

@property(nonatomic, copy)NSString *imagePath;//图片地址
@property(nonatomic, strong)UIImage *image;//图片对象


@end
