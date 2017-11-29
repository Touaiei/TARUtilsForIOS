//
//  TAR_UploadImageShowView.h
//  YouJiaApp
//
//  Created by TAR on 2017/5/3.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 上传并展示图片View
 */
#import <UIKit/UIKit.h>
#import "TARUploadImageViewItemModel.h"

@protocol TAR_UploadImageShowViewDelegate <NSObject>

@required
-(void)uploadImageButtonProtocol;

@optional
-(void)uploadImageCompleteResponse:(NSArray<TARUploadImageViewItemModel *> *)imageModels;

@end

@interface TAR_UploadImageShowView : UIView
{
    NSInteger offsetMainViewHeight;//整个视图变化后最终高度

}
@property(nonatomic,weak)id<TAR_UploadImageShowViewDelegate>delegate;
/*图片展示区域*/
@property(nonatomic, strong)UIView *uploadImageBGView;//显示图片的背景view
@property(nonatomic, strong)UIView *uploadImageView;//显示图片的view
@property(nonatomic, strong)UIButton *uploadImageButton;//加号上传图片按钮
//@property(nonatomic, strong)UIImageView *cellImageView;//单个图片view
//@property(nonatomic, strong)UIButton *deleteImageButton;//删除图片按钮
@property(nonatomic, strong)NSMutableArray<TARUploadImageViewItemModel *> *imagesArrayTotal;//所以图片总数组
@property(nonatomic, strong)NSArray<TARUploadImageViewItemModel *> *imagesArraySingle;//每次上传图片数组
@property(nonatomic, assign)NSInteger maxImageNumber;//图片最大数量


/**
 显示图片，并改变frame
 */
-(void)showImagesWithImageArray:(NSArray<TARUploadImageViewItemModel *> *)images;
-(CGFloat)getTotalHeight;
-(NSArray<TARUploadImageViewItemModel *> *)getTotalImages;


@end
