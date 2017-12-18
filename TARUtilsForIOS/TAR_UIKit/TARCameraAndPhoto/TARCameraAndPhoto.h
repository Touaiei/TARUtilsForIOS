//
//  TARCameraAndPhoto.h
//  YouJiaApp
//
//  Created by TAR on 2017/4/18.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WHC_PictureLisVC.h"


/**
 照片库选取数量类型枚举
 */
typedef NS_ENUM(NSInteger, TARPhotoSelectWay) {
    TARPhotoSelectWay_Single,//单选
    TARPhotoSelectWay_More   //多选
};

/**
 选择资源库类型是 相册还是照相机
 */
typedef NS_ENUM(NSInteger, TARPhotoSourceWay) {
    TARPhotoSourceWay_Photo,//通过相册
    TARPhotoSourceWay_Camera//通过照相机
    
};

@protocol TARCameraAndPhotoDelegate <NSObject>

@end

@interface TARCameraAndPhoto: NSObject
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
WHC_ChoicePictureVCDelegate,
UIAlertViewDelegate,
UIActionSheetDelegate
>
{
    
}
@property(nullable,nonatomic,weak)id <TARCameraAndPhotoDelegate> delegate;
@property(nullable,nonatomic,weak)id <UINavigationControllerDelegate, UIImagePickerControllerDelegate> imagePickerDelegate;
@property (nullable,nonatomic,weak)id<WHC_ChoicePictureVCDelegate> WHCDelegate;

/**
 多选时可用，可选择最大图片数量
 */
@property(nonatomic,assign)NSUInteger imageNumberMax;
@property(nonatomic,assign)TARPhotoSelectWay photoSelectWay;
@property(nonatomic,assign)TARPhotoSourceWay sourceLibraryType;
@property(nonatomic,strong)id _Nonnull targetVC;
@property(nonatomic,assign)BOOL allowsEditing;//是否允许编辑图片。default value is NO.


/**
 弹出选择菜单Alert，照相机和相册
 */
-(void)startAlertCameraAndPhoto;

/**
 弹出选择菜单Alert，仅照相机
 */
-(void)startAlertCamera;

/**
 弹出选择菜单Alert，仅相册
 */
-(void)startAlertPhoto;

/**
 开启选择图片，通过照相机或者相册
 */
-(void)startCameraOrPhoto:(TARPhotoSourceWay)photoSourceWay;


@end





