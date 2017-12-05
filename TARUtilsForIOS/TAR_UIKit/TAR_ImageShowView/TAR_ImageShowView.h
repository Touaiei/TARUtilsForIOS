//
//  TAR_ImageShowView.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/12.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^imageClickBlock)(NSArray *imageViews, NSUInteger imageIndex);

@interface TAR_ImageShowView : UIView
{
    
}
@property(nonatomic, assign) CGFloat self_MaxW;
@property(nonatomic, assign) CGFloat self_W;
@property(nonatomic, copy)imageClickBlock imageClickCallback;


/**
 类似帖子垂直排版图片
 @param imagesPath 图片地址数组
 @param block 布局回调（每布局一张图片都会执行一次该block）
 */
-(void)showVerticalImageWithImagesPath:(NSArray <NSString *> *)imagesPath completed:(void (^)(CGSize viewSize))block;


//-(void)imageClickEnabled:(BOOL)isEnabled completed:(void (^)(CGSize viewSize))block;



//-(UIView *)showImageWithImagesPath:(NSArray *)imagesPath ;

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
@property(nonatomic, copy)imageClickBlock imageClickCallback;
@property(nonatomic, copy)showViewHeightBlock layoutCallback;//改变布局后回调Block


-(void)showSquareImageWithImagePaths:(NSArray <NSString *> *)imagePaths completed:(void (^)(CGSize viewSize))block;

@end






