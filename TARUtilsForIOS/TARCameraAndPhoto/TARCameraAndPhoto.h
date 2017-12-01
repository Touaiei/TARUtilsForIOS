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
typedef NS_ENUM(NSInteger, TAR_PhotoLibraryType) {
    TAR_PhotoLibraryType_SingleSelect,//单选
    TAR_PhotoLibraryType_MoreSelect   //多选
};

/**
 选择资源库类型是 相册还是相机
 */
typedef NS_ENUM(NSInteger, TAR_CameraAndPhotoLibrarySourceWay) {
    CameraAndPhotoLibrarySourceWay_PhotoLibrary,
    CameraAndPhotoLibrarySourceWay_Camera

};
@protocol TAR_CameraAndPhotoLibraryClassDelegate <NSObject>
-(void)TAR_CameraAndPhotoLibraryClasProtocol;
@required


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
@property(nonatomic,weak)id <UINavigationControllerDelegate, UIImagePickerControllerDelegate> delegate;

/**
 多选时可用，可选择最大图片数量
 */
@property(nonatomic,assign)NSUInteger imageNumberMax;
@property(nonatomic,assign,)NSUInteger imageNumberMin;


/**
 选择相册类型（单选或多选 类型）
 */
@property(nonatomic,assign)TAR_PhotoLibraryType photoLibraryType;
@property(nonatomic,assign)TAR_CameraAndPhotoLibrarySourceWay sourceLibraryType;
@property(nonatomic,strong)id targetVC;

@property(nonatomic,strong)UIImagePickerController *imagePicker;

@property(nonatomic,assign)BOOL allowsEditing;//是否允许编辑图片。default value is NO.


/**
 照相机和相册
 */
-(void)startCameraAndPhotoLibrary:(UIViewController *)targetVC;

/**
 仅照相机
 */
-(void)startCamera:(id)targetVC;

/**
 仅相册
 */
-(void)startPhotoLibrary:(id)targetVC;


@end





