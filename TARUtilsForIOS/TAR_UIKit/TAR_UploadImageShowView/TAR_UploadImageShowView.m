//
//  TAR_UploadImageShowView.m
//  YouJiaApp
//
//  Created by TAR on 2017/5/3.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 上传并展示图片View
 */
#import "TAR_UploadImageShowView.h"

#define UploadPictureBGView_W self.width
#define UploadPicturesView_W (UploadPictureBGView_W - 20)
#define UploadPicturesView_H (UploadPicturesView_W / 5.0)
#define imageCellView_W_H UploadPicturesView_H

@interface TAR_UploadImageShowView()
{
    CGFloat uploadButton_X;
    CGFloat uploadButton_Y;

}


@end



@implementation TAR_UploadImageShowView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imagesArrayTotal = [[NSMutableArray alloc]init];
        _imagesArraySingle = [[NSMutableArray alloc]init];
        [self initUploadPicturesView];
        
        
    }
    return self;
}


-(void)initUploadPicturesView
{
    /*显示图片背景View*/
    _uploadImageBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UploadPictureBGView_W, UploadPicturesView_H+20)];
//    _uploadImageBGView.layer.borderColor = [UIColor redColor].CGColor;
//    _uploadImageBGView.layer.borderWidth =1;
    _uploadImageBGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_uploadImageBGView];
    
    _uploadImageView = [[UIView alloc]initWithFrame:CGRectMake((_uploadImageBGView.width - UploadPicturesView_W)/2.0, 10, UploadPicturesView_W, UploadPicturesView_H)];
//    _uploadImageView.layer.borderColor = [UIColor yellowColor].CGColor;
//    _uploadImageView.layer.borderWidth =1;
    _uploadImageView.backgroundColor = [UIColor whiteColor];
    [_uploadImageBGView addSubview:_uploadImageView];
    
    if (!_uploadImageButton) {
        _uploadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _uploadImageButton.frame = CGRectMake(0, 0, imageCellView_W_H, imageCellView_W_H);
    _uploadImageButton.hidden = NO;
    _uploadImageButton.layer.cornerRadius = 5;
//    [_uploadImageButton setTitle:@"上传" forState:UIControlStateNormal];
    [_uploadImageButton addTarget:self action:@selector(uploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadImageButton setBackgroundImage:[UIImage imageNamed:@"service_repair_picture_add"] forState:UIControlStateNormal];
    [_uploadImageView addSubview:_uploadImageButton];
}


-(void)showImagesWithImageArray:(NSArray<TARUploadImageViewItemModel *> *)images
{
    NSLog(@"imageArray == %@",images);
    _imagesArraySingle = images;
    if (images != nil) {
        [_imagesArrayTotal addObjectsFromArray:images];
    }
    //    _maxImageNumber = _maxImage - _imagesArray.count;

    CGFloat uploadImageButton_W_H = imageCellView_W_H*(3/3.0);
    if (!_uploadImageButton) {
        _uploadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _uploadImageButton.frame = CGRectMake(uploadButton_X+5, 0, uploadImageButton_W_H, uploadImageButton_W_H);
//    [_uploadImageButton setTitle:@"上传" forState:UIControlStateNormal];
    _uploadImageButton.hidden = NO;
    [_uploadImageButton addTarget:self action:@selector(uploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadImageButton setBackgroundImage:[UIImage imageNamed:@"service_repair_picture_add"] forState:UIControlStateNormal];
    [_uploadImageView addSubview:_uploadImageButton];
     
    NSLog(@"_maxImageNumber == %ld",(long)_maxImageNumber);
    if (_maxImageNumber - _imagesArrayTotal.count <= 0) {
        _uploadImageButton.hidden = YES;
    }else{
        _uploadImageButton.hidden = NO;
    }
    NSLog(@"_imagesArrayTotal.count == %ld",(unsigned long)_imagesArrayTotal.count);
    int columnsNumber = 4;//列数（每行item个数）
    int columnSpacing = 20;//列间距
    int rowNumber = 0;//行数（每列item个数）
    int rowSpacing = 5;//行间距
    for (int i = 0; i < _imagesArrayTotal.count; i++) {
        rowNumber = (i+1)/columnsNumber+1;
        UIImageView *_cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%columnsNumber*(imageCellView_W_H+columnSpacing), i/columnsNumber*(imageCellView_W_H+rowSpacing), imageCellView_W_H, imageCellView_W_H)];
        _cellImageView.image = [_imagesArrayTotal objectAtIndex:i].image;
        _cellImageView.userInteractionEnabled = YES;
        [_uploadImageView addSubview:_cellImageView];
        
        uploadButton_X = CGRectGetMaxX(_cellImageView.frame);
        
        /*ㄨㄨ*/
        UIButton *_deleteImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _deleteImageButton.backgroundColor = Color_RGBA(0, 0, 0, 0.6);
        _deleteImageButton.layer.cornerRadius = 12.5;
        _deleteImageButton.tag = i;
        _deleteImageButton.frame = CGRectMake(_cellImageView.width-12.5, -12.5, 25, 25);
//        [_deleteImageButton setTitle:@"ㄨ" forState:UIControlStateNormal];
        [_deleteImageButton setBackgroundImage:[UIImage imageNamed:@"service_repair_picture_delete"] forState:UIControlStateNormal];
        [_deleteImageButton addTarget:self action:@selector(deleteImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cellImageView addSubview:_deleteImageButton];
        
        _uploadImageButton.origin = CGPointMake(((i+1)%columnsNumber)*(imageCellView_W_H+columnSpacing), (i+1)/columnsNumber*imageCellView_W_H);
        
//        [_uploadImageButton setOriginX:CGRectGetMaxX(_cellImageView.frame)+columnSpacing];
        
        _uploadImageView.height = rowNumber*(imageCellView_W_H+(rowNumber-1)*rowSpacing);//从新指定背景视图高度
        _uploadImageBGView.height = _uploadImageView.height+20;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadImageCompleteResponse:)]) {
        [self.delegate uploadImageCompleteResponse:_imagesArrayTotal];
    }
//    _uploadImageView.height = (rowNumber)*UploadPicturesView_H;//从新指定背景视图高度
//    _uploadImageBGView.height = _uploadImageView.height+20;
}


#pragma mark --上传照片按钮点击事件--
-(void)uploadButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadImageButtonProtocol)]) {
        [self.delegate uploadImageButtonProtocol];
    }
}
#pragma mark --删除图片按钮点击事件--
-(void)deleteImageButtonClick:(UIButton *)sender
{
    [_imagesArrayTotal removeObjectAtIndex:sender.tag];
    [_uploadImageView removeAllSubviews];
    if (_imagesArrayTotal.count>0) {
        [self showImagesWithImageArray:nil];
    }else{
        [self initUploadPicturesView];
    }
}

-(NSArray<TARUploadImageViewItemModel *> *)getTotalImages
{
    return _imagesArrayTotal;
}

-(CGFloat)getTotalHeight
{
    return _uploadImageBGView.height;
}

@end


