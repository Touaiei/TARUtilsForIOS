//
//  TAR_ImageShowView.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/12.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_ImageShowView.h"
@interface TAR_ImageShowView()
{
    UIView *imageBGView;
    NSMutableArray *imageViews;
    NSMutableArray *images;
}
//@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,assign)CGFloat self_H;
@property(nonatomic,assign)CGSize self_Size;


@end
@implementation TAR_ImageShowView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];

    }
    return self;
}
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
    if (!imageViews) {
        imageViews = [[NSMutableArray alloc]init];
    }
    if (!images) {
        images = [[NSMutableArray alloc]init];
    }
    
    _self_MaxW = [UIScreen mainScreen].bounds.size.width;
    _self_W = self.bounds.size.width;
    _self_H = self.bounds.size.height;
    
    [self initImageBGView];
}
-(void)initImageBGView
{
    if (!imageBGView) {
        imageBGView = [[UIView alloc]initWithFrame:self.bounds];
        imageBGView.userInteractionEnabled = NO;
//        imageBGView.layer.borderColor = [[UIColor redColor]CGColor];
//        imageBGView.layer.borderWidth = 1;
        [self addSubview:imageBGView];
        [imageBGView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClickTap:)]];
    }
}

-(void)showVerticalImageWithImagesPath:(NSArray<NSString *> *)imagesPath completed:(void (^)(CGSize))block
{
    __block CGFloat imageBGViewMaxW = 0.0;
    __block CGFloat imageBGViewMaxH = 0.0;
    
    if (imagesPath.count >= 1) {
        __block CGFloat progressCellView_Y=0.0;
        __block CGFloat progressCellView_BeforeHeight = 0.0;//上一个cell的高度
        __block CGFloat contentImageView_W = 0.0;
        __block CGFloat contentImageView_H = 0.0;
        CGFloat imageHeadSpace = 0.0;
        for (int i = 0; i<imagesPath.count; i++) {
            if ([imagesPath[i] length] >= 1) {
                if (i == 0) {//设置内容图片顶部间距
                    imageHeadSpace = 0;
                }else{
                    imageHeadSpace = 10;
                }
                NSString *urlStr = [imagesPath[i] isKindOfClass:[NSString class]]?imagesPath[i]:@"";
                UIImageView *imageView = [[UIImageView alloc]init];
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;//裁剪超出父视图范围的子视图
                [imageBGView addSubview:imageView];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    CGFloat aspectRatio = image.size.width/image.size.height;
                    contentImageView_W = image.size.width > _self_MaxW ? _self_MaxW :image.size.width;
                    contentImageView_H = contentImageView_W/aspectRatio;
                    imageBGViewMaxW = contentImageView_W > imageBGViewMaxW ? contentImageView_W : imageBGViewMaxW;
                    imageBGViewMaxH += (contentImageView_H+imageHeadSpace);
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(0).priorityLow();
                        make.centerX.equalTo(imageBGView);
                        make.width.mas_equalTo(contentImageView_W);
                        make.height.mas_equalTo(contentImageView_H);
                    }];
                    
                    //设置repairProgressCellView 当前Y坐标
                    progressCellView_Y = progressCellView_Y+progressCellView_BeforeHeight+imageHeadSpace;

                    //设置ProgressCellView前一次的高度
                    progressCellView_BeforeHeight = contentImageView_H;
                    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(progressCellView_Y);
                    }];
                    
                    [imageViews addObject:imageView];
                    
                    [imageBGView setSize:CGSizeMake(imageBGViewMaxW, imageBGViewMaxH)];
                    [self setSelf_H:imageBGView.size.height];
                    block(_self_Size);
                }];
            
            }else{
            }
        }
    }else{
        
    }

}


#pragma mark --setter--
-(void)setSelf_MaxW:(CGFloat)self_MaxW
{
    _self_MaxW = self_MaxW;
}
-(void)setSelf_W:(CGFloat)self_W
{
    _self_W = self_W;
    [self setSelf_Size:CGSizeMake(_self_W, _self_H)];
}
-(void)setSelf_H:(CGFloat)self_H
{
    _self_H = self_H;
    [self setSelf_Size:CGSizeMake(_self_W, _self_H)];
}
-(void)setSelf_Size:(CGSize)self_Size
{
    _self_Size = self_Size;
    self.size = _self_Size;
}

-(void)imageViewClickTap:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)[tap view];
    self.imageClickCallback(imageViews, imageView.tag);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
