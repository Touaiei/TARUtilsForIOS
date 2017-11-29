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
