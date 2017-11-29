//
//  TAR_NavBarView.m
//  YouJiaApp
//
//  Created by TAR on 2016/12/23.
//  Copyright © 2016年 TAR. All rights reserved.
//

#import "TAR_NavBarView.h"

@implementation TAR_NavBarView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = Color_NavBar;
        UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 20)];
        statusBar.backgroundColor = Color_NavBar;
        [self addSubview:statusBar];
        UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.width, 44)];
        navBarView.backgroundColor = Color_NavBar;
        [self addSubview:navBarView];
        double leftButton_H = 44.0;
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(5, (navBarView.height-leftButton_H)/2.0, leftButton_H, leftButton_H);
        [_leftButton setImage:[UIImage imageNamed:@"navBar_backButton_white"] forState:UIControlStateNormal];
        [navBarView addSubview:_leftButton];
        /*标题*/
        double titleLabel_W = 100.0;
        double titleLabel_H = 20.0;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((navBarView.width - titleLabel_W)/2.0, (navBarView.height - titleLabel_H)/2.0, titleLabel_W, titleLabel_H)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.text = @"标题";
        [navBarView addSubview:_titleLabel];

        

    }
    return self;
}

-(void)setTitleLabelText:(NSString *)titleLabelText
{
    _titleLabel.text = titleLabelText;
}
-(void)setTitleTextColor:(UIColor *)titleTextColor
{
    _titleLabel.textColor = titleTextColor;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
