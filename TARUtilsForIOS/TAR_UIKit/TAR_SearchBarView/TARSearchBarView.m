//
//  TARSearchBarView.m
//  SinaWeibo
//
//  Created by user on 15/10/15.
//  Copyright © 2015年 ZT. All rights reserved.
//
/*
 自定义搜索框视图
 */

#import "TARSearchBarView.h"

@interface TARSearchBarView()
<UITextFieldDelegate>
{
    
}
@end

@implementation TARSearchBarView

- (instancetype)init
{
    self = [super init];
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

        // 提前在Xcode上设置图片中间拉伸
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];

        [self setSearchImageView];
        
    }
    return self;
}


-(void)initialize
{
    self.delegate = self;
    _isCanEditing = YES;
    self.clearButtonMode = UITextFieldViewModeAlways;//小叉叉一次性删除输入框中的内容
    //        self.layer.borderWidth = 1;
    //        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.backgroundColor = [UIColor lightGrayColor];
    self.font = [UIFont systemFontOfSize:15];
    self.textColor = [UIColor whiteColor];
    self.placeholder = @"请输入查询内容";
    [self setPlaceholderColor:[UIColor whiteColor]];
    [self setPlaceholderFont:[UIFont systemFontOfSize:15]];
}
#pragma mark --初始化主UI布局--
-(void)initMainUI
{
    
}


/**
 设置搜索图片视图
 */
-(void)setSearchImageView
{
    UIView *searchBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
//    searchBGView.layer.borderWidth = 1;
//    searchBGView.layer.borderColor = [UIColor yellowColor].CGColor;
    UITapGestureRecognizer *searchButtonTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchButtonClick:)];
    [searchBGView addGestureRecognizer:searchButtonTap];
    
    // 通过init初始化的控件大多都没有尺寸
    CGFloat searchImageView_W_H = 20;
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake((searchBGView.width-searchImageView_W_H)/2.0, (searchBGView.height-searchImageView_W_H)/2.0, searchImageView_W_H, searchImageView_W_H)];
    //        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
    searchImageView.image = [UIImage imageNamed:@"home_Pay_mechanism_search_ic"];
    // contentMode：default is UIViewContentModeScaleToFill，要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
    //        searchIcon.contentMode = UIViewContentModeCenter;
    [searchBGView addSubview:searchImageView];
    
    self.leftView.layer.borderWidth = 1;
    self.leftView.layer.borderColor = [UIColor redColor].CGColor;
    self.leftView.userInteractionEnabled = YES;
    self.leftViewMode = UIViewContentModeRedraw;
    [self setLeftView:searchBGView];
}



-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];//设置占位符文字颜色
}
-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    [self setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];//设置占位符文字大小
}

/**
 搜索按钮点击事件
 @param tap 点击手势
 */
-(void)searchButtonClick:(UITapGestureRecognizer *)tap
{
    if (self.searchBarDelegate && [self.searchBarDelegate respondsToSelector:@selector(searchButtonClickProtocol:)]) {
        [self.searchBarDelegate searchButtonClickProtocol:self.text];
    }
}


+(instancetype)searchBar
{
    return [[self alloc] init];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_isCanEditing) {
        return YES;
    }else{
        return NO;
    }
    
    
}

@end
