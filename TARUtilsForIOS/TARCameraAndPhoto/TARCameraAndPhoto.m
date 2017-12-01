//
//  TARCameraAndPhoto.m
//  YouJiaApp
//
//  Created by TAR on 2017/4/18.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TARCameraAndPhoto.h"

@interface TARCameraAndPhoto ()
{
    
}
@end
@implementation TARCameraAndPhoto

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"- (instancetype)init");
        _photoLibraryType = TAR_PhotoLibraryType_SingleSelect;//默认单选
        _sourceLibraryType = CameraAndPhotoLibrarySourceWay_PhotoLibrary;//默认PhotoLibrary
        _allowsEditing = NO;//默认NO
        self.imageNumberMin = 1;
        

    }
    return self;
}

+ (void)initialize
{
    if (self == [self class]) {
        NSLog(@"+ (void)initialize");
        
    }
}
-(void)setImageNumberMin:(NSUInteger)imageNumberMin
{
    _imageNumberMax = imageNumberMin;
    _imageNumberMax = imageNumberMin;
}

/**
 照相机和相册
 */
-(void)startCameraAndPhotoLibrary:(UIViewController *)targetVC
{
    _targetVC = targetVC;
    switch (_sourceLibraryType) {
        case CameraAndPhotoLibrarySourceWay_Camera:
            [self takePhoto];
            
            break;
        case CameraAndPhotoLibrarySourceWay_PhotoLibrary:
            [self localPhoto];
            break;
            
        default:
            break;
    }
    
}

/**
 仅照相机
 */
-(void)startCamera:(id)targetVC
{
    _targetVC = targetVC;
    [self takePhoto];
}

/**
 仅相册
 */
-(void)startPhotoLibrary:(id)targetVC
{
    _targetVC = targetVC;
    [self localPhoto];
}

#pragma mark -- 打开相册上传单张图片
-(void)localPhoto
{
    switch (_photoLibraryType) {
        case TAR_PhotoLibraryType_SingleSelect:
            [self singleSelectPhoto];
            break;
        case TAR_PhotoLibraryType_MoreSelect:
            [self moreSelectphoto];
            break;
            
        default:
            break;
    }
}
#pragma mark --单选图片--
-(void)singleSelectPhoto
{
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.delegate = _delegate;
    //资源类型为图片库
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //设置选择后的图片可被编辑
    _imagePicker.allowsEditing = _allowsEditing;
//    _delegate = _picker.delegate;
    [_targetVC presentViewController:_imagePicker animated:YES completion:^{
    }];
}
#pragma mark --多选图片--
-(void)moreSelectphoto
{
    WHC_PictureLisVC * vc =[[WHC_PictureLisVC alloc]init];
    vc.maxChoiceImageNumberumber = _imageNumberMax;//最大上传图片数量
    vc.delegate = _delegate;
    [_targetVC presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}


#pragma mark --拍照
-(void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = _delegate;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = _allowsEditing;
        //资源类型为照相机
        picker.sourceType = sourceType;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        
        [_targetVC presentViewController:picker animated:YES completion:nil];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注意" message:@"该设备无摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}








#pragma mark --UIImagePickerControllerDelegate--
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"imagePickerController");
    [picker dismissViewControllerAnimated:YES completion:^{
        //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        //当图片不为空时显示图片并保存图片
        if (image != nil) {
            //            NSString *str = [NSString stringWithFormat:image];
            //            _imageView.image = image;
            NSArray *array = [NSArray arrayWithObject:image];
            NSLog(@"_imageView.image ==%@",image);
//            [self uploadImagesRequestWithImageArray:array];//去到上传图片方法
            
            //如果uploadImageType == 1走单张图片上传,2走多图上传
            //            if (uploadImageType == 1) {
            //                [self uploadImageRequest:image];
            //            }else if (uploadImageType == 2){
            //                [self uploadImagesRequestWithImageArray:[NSMutableArray arrayWithObject:image]];
            //            }
            
            //执行上传图片
            //调js
            //            NSString * alertJS = [NSString stringWithFormat:@"loadUploadImgDataShow('%@','%@')",objDic[@"id"],objDic[@"iconPath"]];
            //            [_context evaluateScript:alertJS];
        }
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
}



-(void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr
{
    NSLog(@"WHCChoicePictureVC");
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex==%ld",(long)buttonIndex);
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");

}

@end
