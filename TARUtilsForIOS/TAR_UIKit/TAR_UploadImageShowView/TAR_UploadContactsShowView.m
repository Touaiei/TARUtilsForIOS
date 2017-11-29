//
//  TAR_UploadContactsShowView.m
//  EmployeesAPP
//
//  Created by TAR on 2017/8/15.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 上传并展示联系人View
 */
#import "TAR_UploadContactsShowView.h"
#import "TAR_StringToolClass.h"



#define UploadPictureBGView_W self.width
#define UploadPicturesView_W (UploadPictureBGView_W )
#define UploadPicturesView_H (UploadPicturesView_W / 5.0)
#define imageCellView_W_H UploadPicturesView_H

@implementation TAR_UploadContactsShowView

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
    _uploadImageBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UploadPictureBGView_W, UploadPicturesView_H)];
        _uploadImageBGView.layer.borderColor = [UIColor redColor].CGColor;
        _uploadImageBGView.layer.borderWidth =1;
    _uploadImageBGView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_uploadImageBGView];
    
    _uploadImageView = [[UIView alloc]initWithFrame:CGRectMake((_uploadImageBGView.width - UploadPicturesView_W)/2.0, 0, UploadPicturesView_W, UploadPicturesView_H)];
    _uploadImageView.layer.borderColor = [UIColor yellowColor].CGColor;
    _uploadImageView.layer.borderWidth =1;
    _uploadImageView.backgroundColor = [UIColor whiteColor];
    [_uploadImageBGView addSubview:_uploadImageView];
    
    [self initUploadImageButton:0];
    
}
-(void)initUploadImageButton:(NSInteger)index
{

    if (!_uploadImageButton) {
        _uploadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _uploadImageButton.frame = CGRectMake(0, 0, imageCellView_W_H, imageCellView_W_H);
    _uploadImageButton.hidden = NO;
//    _uploadImageButton.backgroundColor = [UIColor blueColor];
    //    _uploadImageButton.layer.cornerRadius = 5;
    //    [_uploadImageButton setTitle:@"上传" forState:UIControlStateNormal];
    [_uploadImageButton addTarget:self action:@selector(uploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [_uploadImageButton setBackgroundImage:[UIImage imageNamed:@"service_repair_picture_add"] forState:UIControlStateNormal];
    [_uploadImageView addSubview:_uploadImageButton];
    
    
    CGFloat imageView_W_H = _uploadImageButton.height*(2/3.0);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_uploadImageButton.width - imageView_W_H)/2.0, 0, imageView_W_H, imageView_W_H)];
    imageView.layer.cornerRadius = imageView_W_H/2.0;
    imageView.image = [UIImage imageNamed:@"administration_add_ic"];
//    imageView.backgroundColor = [UIColor yellowColor];
    [_uploadImageButton addSubview:imageView];
    
    CGFloat titleLabel_W = _uploadImageButton.width;
    CGFloat titleLabel_H = _uploadImageButton.height*(1/3.0);;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((_uploadImageButton.width - titleLabel_W)/2.0, _uploadImageButton.height-titleLabel_H, titleLabel_W, titleLabel_H)];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"请选择";
    [_uploadImageButton addSubview:titleLabel];
}
-(void)changeUploadImageButton
{
    
}
//-(void)showContactsWithImageArray:(NSArray *)images showViewHeightCallbackBlock:(void (^)(CGFloat))block
-(void)showContactsWithImageArray:(NSArray *)images
{
    NSLog(@"imageArray == %@",images);
    
    _imagesArraySingle = images;
    if (images != nil) {
        [_imagesArrayTotal addObjectsFromArray:images];
    }
    //    _maxImageNumber = _maxImage - _imagesArray.count;
    [self initUploadImageButton:0];
    /*
    CGFloat uploadImageButton_W_H = imageCellView_W_H*(3/3.0);
    if (!_uploadImageButton) {
        _uploadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _uploadImageButton.frame = CGRectMake(CGRectGetMaxX(_cellView.frame)+5, 0, uploadImageButton_W_H, uploadImageButton_W_H);
    //    [_uploadImageButton setTitle:@"上传" forState:UIControlStateNormal];
    _uploadImageButton.hidden = NO;
    [_uploadImageButton addTarget:self action:@selector(uploadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadImageButton setBackgroundImage:[UIImage imageNamed:@"service_repair_picture_add"] forState:UIControlStateNormal];
    [_uploadImageView addSubview:_uploadImageButton];
    */
    
    NSLog(@"_maxImageNumber == %ld",(long)_maxImageNumber);
    if (_maxImageNumber - _imagesArrayTotal.count <= 0) {
        _uploadImageButton.hidden = YES;
    }else{
        _uploadImageButton.hidden = NO;
    }
    NSLog(@"_imagesArrayTotal.count == %ld",(unsigned long)_imagesArrayTotal.count);
    int columnsNumber = 4;//列数（每行item个数）
    int columnSpacing = 5;//列间距
    int rowNumber = 0;//行数（每列item个数）
    int rowSpacing = 5;//行间距
    for (int i = 0; i < _imagesArrayTotal.count; i++) {
        rowNumber = (i+1)/columnsNumber+1;
        _cellView = [[UIView alloc]initWithFrame:CGRectMake(i%columnsNumber*(imageCellView_W_H+columnSpacing), i/columnsNumber*(imageCellView_W_H+rowSpacing), imageCellView_W_H, imageCellView_W_H)];
        _cellView.tag = i;
        _cellView.backgroundColor = [UIColor redColor];
        _cellView.userInteractionEnabled = YES;
        [_uploadImageView addSubview:_cellView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImageButtonTap:)];
        [_cellView addGestureRecognizer:tap];
        
        CGFloat imageView_W_H = _cellView.height*(2/3.0);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_cellView.width - imageView_W_H)/2.0, 0, imageView_W_H, imageView_W_H)];
        imageView.layer.cornerRadius = imageView_W_H/2.0;
        [TAR_StringToolClass setImageWithImageView:imageView imagePath:[[_imagesArrayTotal objectAtIndex:i] objectForKey:@"image"] placeholder:nil];
        imageView.backgroundColor = [UIColor yellowColor];
        [_cellView addSubview:imageView];
        
        CGFloat titleLabel_W = _cellView.width;
        CGFloat titleLabel_H = _cellView.height*(1/3.0);;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((_cellView.width - titleLabel_W)/2.0, _cellView.height-titleLabel_H, titleLabel_W, titleLabel_H)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = [[_imagesArrayTotal objectAtIndex:i] objectForKey:@"title"];
        [_cellView addSubview:titleLabel];
        
        /*
        _cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%columnsNumber*(imageCellView_W_H+columnSpacing), i/columnsNumber*(imageCellView_W_H+rowSpacing), imageCellView_W_H, imageCellView_W_H)];
        _cellImageView.image = [[_imagesArrayTotal objectAtIndex:i] objectForKey:@"image"];
        _cellImageView.userInteractionEnabled = YES;
        [_uploadImageView addSubview:_cellImageView];
        //ㄨㄨ
        _deleteImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _deleteImageButton.backgroundColor = Color_RGBA(0, 0, 0, 0.6);
        _deleteImageButton.layer.cornerRadius = 12.5;
        _deleteImageButton.tag = i;
        _deleteImageButton.frame = CGRectMake(_cellImageView.width-12.5, -12.5, 25, 25);
        //        [_deleteImageButton setTitle:@"ㄨ" forState:UIControlStateNormal];
        [_deleteImageButton setBackgroundImage:[UIImage imageNamed:@"service_repair_picture_delete"] forState:UIControlStateNormal];
        [_deleteImageButton addTarget:self action:@selector(deleteImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cellImageView addSubview:_deleteImageButton];
        */
        
        _uploadImageButton.origin = CGPointMake(((i+1)%columnsNumber)*(imageCellView_W_H+columnSpacing), (i+1)/columnsNumber*(imageCellView_W_H+rowSpacing));
        
        _uploadImageView.height = rowNumber*(imageCellView_W_H+(rowNumber-1)*rowSpacing);//从新指定背景视图高度
        _uploadImageBGView.height = _uploadImageView.height+0;
    }
    self.layoutCallbackBlock(_uploadImageBGView.height);
}


#pragma mark --上传照片按钮点击事件--
-(void)uploadButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadContactsButtonProtocol)]) {
        [self.delegate uploadContactsButtonProtocol];
    }
}
#pragma mark --删除图片按钮点击事件--
-(void)deleteImageButtonClick:(UIButton *)sender
{
    [_imagesArrayTotal removeObjectAtIndex:sender.tag];
    [_uploadImageView removeAllSubviews];
    if (_imagesArrayTotal.count>0) {
        [self showContactsWithImageArray:nil];
    }else{
        [self initUploadPicturesView];
    }
}
-(void)deleteImageButtonTap:(UITapGestureRecognizer *)sender
{
    UIView *view = [sender view];
    [_imagesArrayTotal removeObjectAtIndex:view.tag];
    [_uploadImageView removeAllSubviews];
    if (_imagesArrayTotal.count>0) {
        [self showContactsWithImageArray:nil];
    }else{
        [self initUploadPicturesView];
    }
}

-(NSArray *)getTotalImages
{
    return _imagesArrayTotal;
}

-(CGFloat)getTotalHeight
{
    return _uploadImageBGView.height;
}


@end
