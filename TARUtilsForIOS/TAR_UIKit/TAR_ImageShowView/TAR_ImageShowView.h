//
//  TAR_ImageShowView.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/12.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TARImageShowView_CellModel;

typedef void(^imageClickBlock)(NSArray *imageViews, NSUInteger imageIndex);

/**
 图片展示（根据图片大小垂直排版）
 */
@interface TAR_ImageShowView : UIView
{
}
@property(nonatomic, assign) CGFloat self_MaxW;
@property(nonatomic, assign) CGFloat self_W;
@property(nonatomic, copy)imageClickBlock imageClickCallback;


/**
 类似帖子（根据图片大小垂直排版）
 @param imagesPath 图片地址数组
 @param block 布局回调（每布局一张图片都会执行一次该block）
 */
-(void)showVerticalImageWithImagesPath:(NSArray <TARImageShowView_CellModel *> *)imagesPath completed:(void (^)(CGSize viewSize))block;

@end



/**
 图片展示（九宫格图片）
 */
@interface TARImageShowKyushuView : UIView
{
}
typedef void(^showViewHeightBlock)(CGFloat showView_H);

@property(nonatomic, assign)CGFloat levelSpace;//图片间水平方向间距（默认5）
@property(nonatomic, assign)CGFloat verticalSpace;//图片间垂直方向间距（默认5）
@property(nonatomic, assign)CGFloat imageWidth;//图片宽度（默认平分）
@property(nonatomic, assign)CGFloat imageHeight;//图片高度（默认平分）
@property(nonatomic, assign)CGFloat rowShowNumber;//每行展示图片张数（默认4张）
@property(nonatomic, copy)imageClickBlock imageClickCallback;//图片点击回调

/**
 图片展示（九宫格图片）
 */
-(void)showSquareImageWithImagePaths:(NSArray <TARImageShowView_CellModel *> *)imagePaths completed:(void (^)(CGSize viewSize))block;

@end


/**
 图片CellModel
 */
@interface TARImageShowView_CellModel : NSObject

@property(nonatomic, copy)NSString *imagePath;//图片地址（可以是URL链接和本地图片名称）

@property(nonatomic, copy)NSString *imageID;//图片ID（可用于根据ID做各种判断）

@end




