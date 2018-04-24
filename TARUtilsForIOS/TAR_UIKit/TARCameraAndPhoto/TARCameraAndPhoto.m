//
//  TARCameraAndPhoto.m
//  YouJiaApp
//
//  Created by TAR on 2017/4/18.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TARCameraAndPhoto.h"
#import "TAR_AlertController.h"

@interface TARCameraAndPhoto ()
{
    
}
@end
@implementation TARCameraAndPhoto

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    _photoSelectWay = TARPhotoSelectWay_Single;//默认单选
    _sourceLibraryType = TARPhotoSourceWay_Photo;//默认PhotoLibrary
    _allowsEditing = NO;//默认NO
    self.imageNumberMax = 9;
}

/**
 弹出选择菜单Alert，照相机和相册
 */
-(void)startAlertCameraAndPhoto
{
    NSArray *actionArray = @[@{@"title":@"取消",@"style":@"1"},@{@"title":@"照相机",@"style":@"2"},@{@"title":@"通过相册",@"style":@"2"}];
    [TAR_AlertController alertTitle:@"请选择图片方式：" mesasge:nil preferredStyle:UIAlertControllerStyleActionSheet actionArray:actionArray viewController:_targetVC confirmHandler:^(UIAlertAction *action1) {
        if ([action1.title isEqualToString:@"照相机"]) {
            [self takePhoto];
        }else if ([action1.title isEqualToString:@"通过相册"]) {
            [self localPhoto];
        }else{
            
        }
    }];
}
/**
 弹出选择菜单Alert，仅照相机
 */
-(void)startAlertCamera
{
    NSArray *actionArray = @[@{@"title":@"取消",@"style":@"1"},@{@"title":@"照相机",@"style":@"2"}];
    [TAR_AlertController alertTitle:@"请选择图片方式：" mesasge:nil preferredStyle:UIAlertControllerStyleActionSheet actionArray:actionArray viewController:_targetVC confirmHandler:^(UIAlertAction *action1) {
        if ([action1.title isEqualToString:@"照相机"]) {
            [self takePhoto];
        }else{
            
        }
    }];
}
/**
 弹出选择菜单Alert，仅相册
 */
-(void)startAlertPhoto
{
    NSArray *actionArray = @[@{@"title":@"取消",@"style":@"1"},@{@"title":@"通过相册",@"style":@"2"}];
    [TAR_AlertController alertTitle:@"请选择图片方式：" mesasge:nil preferredStyle:UIAlertControllerStyleActionSheet actionArray:actionArray viewController:_targetVC confirmHandler:^(UIAlertAction *action1) {
        if ([action1.title isEqualToString:@"通过相册"]) {
            [self localPhoto];
        }else{
            
        }
    }];
}


/**
 开启选择图片，通过照相机或者相册
 */
-(void)startCameraOrPhoto:(TARPhotoSourceWay)photoSourceWay
{
    _sourceLibraryType = photoSourceWay;
    switch (_sourceLibraryType) {
        case TARPhotoSourceWay_Camera:
            [self takePhoto];
            
            break;
        case TARPhotoSourceWay_Photo:
            [self localPhoto];
            break;
            
        default:
            break;
    }
    
}


#pragma mark -- 打开相册上传单张图片
-(void)localPhoto
{
    switch (_photoSelectWay) {
        case TARPhotoSelectWay_Single:
            [self singleSelectPhoto];
            break;
        case TARPhotoSelectWay_More:
            [self moreSelectphoto];
            break;
            
        default:
            break;
    }
}

#pragma mark --单选图片--
-(void)singleSelectPhoto
{
    UIImagePickerController *_imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.delegate = _imagePickerDelegate;
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
    vc.delegate = _WHCDelegate;
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
        picker.delegate = _imagePickerDelegate;
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
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    NSLog(@"imagePickerController");
    [picker dismissViewControllerAnimated:YES completion:^{
        //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        //当图片不为空时显示图片并保存图片
        if (image != nil) {
            NSArray *array = [NSArray arrayWithObject:image];
            NSLog(@"_imageView.image ==%@",image);
        }
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickedButtonAtIndex==%ld",(long)buttonIndex);
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
    
}

-(void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr
{
    NSLog(@"WHCChoicePictureVC");
}


@end
