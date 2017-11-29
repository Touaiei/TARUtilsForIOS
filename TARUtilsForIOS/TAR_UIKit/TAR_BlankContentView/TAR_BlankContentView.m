//
//  TAR_BlankContentView.m
//  YouJiaApp
//
//  Created by TAR on 2017/4/20.
//  Copyright © 2017年 TAR. All rights reserved.
//


/**
 无更多内容视图
 */
#import "TAR_BlankContentView.h"
#import "TAR_StringToolClass.h"
@interface TAR_BlankContentView()
{
    UIView *backgroundView;
    
}
@property (strong, nonatomic) UIImageView *imageView;//图片View
@property (strong, nonatomic) UILabel *promptLabel;//提示Label

@end
@implementation TAR_BlankContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initialize];

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initialize];
        
    }
    return self;
}

-(void)initInterfaceBuilder
{
    switch (_blankContentViewType) {
        case blankContentViewType_NoContent:
            [self initBlankContentView];

            break;
        case blankContentViewType_LoadFailure:
            [self initBlankContentView];
            [self initReloadButton];

            break;
        default:
            break;
    }
}

-(void)initialize
{
    _promptTextSize = [UIFont systemFontOfSize:16.0];
    _promptTextColor = [UIColor lightGrayColor];
    _imageViewSize = CGSizeMake(150, 150);
}



-(void)initBlankContentView
{
    backgroundView = [[UIView alloc]init];
//    backgroundView.backgroundColor = [UIColor redColor];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(self);
    }];
 
    
    _imageView = [[UIImageView alloc]init];
    _imageView.image = [UIImage imageNamed:_imagePath];
//    _imageView.backgroundColor = [UIColor orangeColor];
//    _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _imageView.layer.borderWidth = 1;
    [TAR_StringToolClass setImageWithImageView:_imageView imagePath:_imagePath placeholder:nil];
    [backgroundView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.top.equalTo(backgroundView);
        make.width.mas_equalTo(_imageViewSize.width);
        make.height.mas_equalTo(_imageViewSize.height);
    }];
    
    _promptLabel = [[UILabel alloc]init];
    //    [_describeLabel setBackgroundColor:[UIColor yellowColor]];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.numberOfLines = 2;
    _promptLabel.font = _promptTextSize;
    _promptLabel.textColor = _promptTextColor;
    _promptLabel.text = _promptText;
    [backgroundView addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.top.equalTo(_imageView.mas_bottom).offset(10);
        make.width.mas_equalTo(backgroundView);
    }];
}

-(void)initReloadButton
{
    _reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_reloadButton setBackgroundColor:[UIColor blueColor]];
    [_reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    _reloadButton.tag = 100;
    [_reloadButton addTarget:self action:@selector(reloadButton:) forControlEvents:UIControlEventTouchUpInside];
    _reloadButton.layer.cornerRadius = 5;
    [backgroundView addSubview:_reloadButton];
    [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundView.mas_centerX);
        make.top.equalTo(_promptLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

-(void)setBlankContentViewType:(blankContentViewType)blankContentViewType
{
    _blankContentViewType = blankContentViewType;
}

-(void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
}
-(void)setImageViewSize:(CGSize)imageViewSize
{
    _imageViewSize = imageViewSize;
}
-(void)setPromptText:(NSString *)promptText
{
    _promptText = promptText;
}
-(void)setPromptTextColor:(UIColor *)promptTextColor
{
    _promptTextColor = promptTextColor;

}
-(void)setPromptTextSize:(UIFont *)promptTextSize
{
    _promptTextSize = promptTextSize;
}


-(void)reloadButton:(UIButton *)sender
{
//    self.reloadCallback(sender);
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadOrBackButton:)]) {
        [self.delegate reloadOrBackButton:sender];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
