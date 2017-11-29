//
//  TARUpDownScrollView.m
//  AutoAdLabelScroll
//
//  Created by 陈华荣 on 16/4/6.
//  Copyright © 2016年 陈华荣. All rights reserved.
//

#import "TARUpDownScrollView.h"
#define HRViewWidth  self.bounds.size.width
#define HRViewHeight  self.bounds.size.height

#define CellViewWidth  HRViewWidth
#define CellViewHeight  HRViewHeight

@interface TARUpDownScrollView ()
/**
 *  文字广告条前面的图标
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 *  轮流显示的两个markLabel
 */
@property (nonatomic, strong) UILabel *oneCellView_OneMarkLabel;
@property (nonatomic, strong) UILabel *twoCellView_OneMarkLabel;

/**
 *  轮流显示的两个Label
 */
@property (nonatomic, strong) UILabel *oneCellView_OneLabel;
@property (nonatomic, strong) UILabel *twoCellView_OneLabel;

/**
 *  轮流显示的两个CellView
 */
@property (nonatomic, strong) UIView *oneCellView;
@property (nonatomic, strong) UIView *twoCellView;


/**
 *  计时器
 */

@property (nonatomic, strong) NSTimer *timer;




@end

@implementation TARUpDownScrollView
{
    NSUInteger index;
    CGFloat margin;
    CGFloat labelLeftRely;
    CGFloat markLabel_W;
    CGFloat markLabel_H;
    BOOL isBegin;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        margin = 0;
        labelLeftRely = 0;
        markLabel_W = 27;
        markLabel_H = 16;
        self.clipsToBounds = YES;
        self.headImg = nil;
        self.labelFont = [UIFont systemFontOfSize:16];
        self.color = [UIColor blackColor];
        self.time = 2.0f;
        self.textAlignment = NSTextAlignmentLeft;
        self.isHaveHeadImg = NO;
        self.isHaveTouchEvent = NO;
        self.isShowHeadMark = NO;
        
        index = 0;
    }
    return self;
}

+(instancetype)initWithInstance{
    //    self = [[TARUpDownScrollView alloc]init];
    
    return [[TARUpDownScrollView alloc]init];;
}

- (void)initWithTitles:(NSArray *)titles markTitles:(NSArray *)markTitles
{
    //    self = [super init];
    NSLog(@"initWithTitles==%@",titles);
    _adTitles = [[NSArray alloc]initWithArray:titles];
    _markTitles = [[NSArray alloc]initWithArray:markTitles];
    if (self) {
        if (!_headImageView) {
            _headImageView = [UIImageView new];
        }
        
        if (!_oneCellView) {
            _oneCellView = [UIView new];
            _oneCellView.frame = CGRectMake(margin, 0, CellViewWidth, CellViewHeight);
            [self addSubview:_oneCellView];
        }
        
        if (_isShowHeadMark == YES) {
            labelLeftRely = markLabel_W+5+5;
        }else{
            labelLeftRely = 0.0;
        }
        
        if (_isShowHeadMark == YES) {
            if (!_oneCellView_OneMarkLabel) {
                _oneCellView_OneMarkLabel = [self markLabel];
                [self setColorWithMarkLabel:_oneCellView_OneMarkLabel withIndex:0];
                if (_markTitles.count >=1) {
                    [_oneCellView addSubview:_oneCellView_OneMarkLabel];
                    NSLog(@"index1==%lu",(unsigned long)index);
                    _oneCellView_OneMarkLabel.text = [NSString stringWithFormat:@"%@",_markTitles[index]];
                }else{
                    _oneCellView_OneMarkLabel.text = @"";
                }
            }
        }
        if (!_oneCellView_OneLabel) {
            _oneCellView_OneLabel = [self titleLabel];
            [_oneCellView addSubview:_oneCellView_OneLabel];
            if (_adTitles.count >=1) {
                NSLog(@"index1==%lu",(unsigned long)index);
                _oneCellView_OneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
            }else{
                _oneCellView_OneLabel.text = @"";
            }
        }
        
        if (!_twoCellView) {
            _twoCellView = [UIView new];
            _twoCellView.frame = CGRectMake(margin, 0, CellViewWidth, CellViewHeight);
            [self addSubview:_twoCellView];
        }
        if (_isShowHeadMark == YES) {
            if (!_twoCellView_OneMarkLabel) {
                _twoCellView_OneMarkLabel = [self markLabel];
                [self setColorWithMarkLabel:_twoCellView_OneMarkLabel withIndex:0];
                if (_markTitles.count >=1) {
                    [_twoCellView addSubview:_twoCellView_OneMarkLabel];
                    NSLog(@"index1==%lu",(unsigned long)index);
                    _twoCellView_OneMarkLabel.text = [NSString stringWithFormat:@"%@",_markTitles[index]];
                }else{
                    _twoCellView_OneMarkLabel.text = @"";
                }
            }
        }
        if (!_twoCellView_OneLabel) {
            _twoCellView_OneLabel = [self titleLabel];
            [_twoCellView addSubview:_twoCellView_OneLabel];
        }
    }
    //    return self;
}



-(UILabel *)titleLabel
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(labelLeftRely, 0, _oneCellView.bounds.size.width-labelLeftRely, _oneCellView.bounds.size.height) ;
    titleLabel.numberOfLines = 1;
    titleLabel.font = self.labelFont;
    titleLabel.textAlignment = self.textAlignment;
    titleLabel.textColor = self.color;
    return titleLabel;
}

-(UILabel *)markLabel
{
    UILabel *markLabel = [UILabel new];
    markLabel.frame = CGRectMake(5, (_oneCellView.height-markLabel_H)/2.0, markLabel_W, markLabel_H);
    markLabel.numberOfLines = 1;
    markLabel.font = [UIFont systemFontOfSize:11.0];
    markLabel.textColor = [UIColor blackColor];
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.layer.borderWidth = 1;
    markLabel.layer.borderColor = [UIColor blackColor].CGColor;
    markLabel.layer.cornerRadius = 4;
    return markLabel;
}
-(void)setColorWithMarkLabel:(UILabel *)label withIndex:(NSUInteger)inde
{
    for (int i = 0; i<_markTitlesColor.count; i++) {
        if (![[_markTitlesColor objectAtIndex:i] isKindOfClass:[UIColor class]]) {
            break ;
        }
        if (_markTitlesColor.count <= i) {
            break ;
        }
        if (i == inde) {
            UIColor *color = [_markTitlesColor objectAtIndex:i];
            label.textColor = color;
            label.layer.borderColor = color.CGColor;
        }
    }
}

- (void)timeRepeat{
    if (index < self.adTitles.count-1) {
        index++;
    }else{
        index = 0;
    }
    NSLog(@"indexindex==%lu",(unsigned long)index);
    
    /*给Label赋值*/
    if (index == 0) {
        if (self.adTitles.count>index) {
            NSLog(@"index2==%lu",(unsigned long)index);
            _oneCellView_OneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
        }else{
            _oneCellView_OneLabel.text = @"";
        }
        if (self.markTitles.count>index) {
            _oneCellView_OneMarkLabel.text = [NSString stringWithFormat:@"%@",self.markTitles[index]];
        }else{
            _oneCellView_OneMarkLabel.text = @"";
        }
        [self setColorWithMarkLabel:_oneCellView_OneMarkLabel withIndex:index];
    }else{
        switch (index%2) {
                case 0:
            {
                if (self.adTitles.count>index) {
                    NSLog(@"index3==%lu",(unsigned long)index);
                    _oneCellView_OneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
                }else{
                    _oneCellView_OneLabel.text = @"";
                }
                if (self.markTitles.count>index) {
                    _oneCellView_OneMarkLabel.text = [NSString stringWithFormat:@"%@",self.markTitles[index]];
                }else{
                    _oneCellView_OneMarkLabel.text = @"";
                }
                [self setColorWithMarkLabel:_oneCellView_OneMarkLabel withIndex:index];

            }
                break;
                
            default:
            {
                if (self.adTitles.count>index) {
                    NSLog(@"index4==%lu",(unsigned long)index);
                    _twoCellView_OneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
                }else{
                    _twoCellView_OneLabel.text = @"";
                }
                if (self.markTitles.count>index) {
                    _twoCellView_OneMarkLabel.text = [NSString stringWithFormat:@"%@",self.markTitles[index]];
                }else{
                    _twoCellView_OneMarkLabel.text = @"";
                }
                [self setColorWithMarkLabel:_twoCellView_OneMarkLabel withIndex:index];

            }
                break;
        }
        
    }
    
    
    /*改变Label frame*/
    if (index == 0) {
        if (self.adTitles.count %2 == 0) {
            [UIView animateWithDuration:1 animations:^{
                _oneCellView.frame = CGRectMake(margin, 0, CellViewWidth, CellViewHeight);
                _twoCellView.frame = CGRectMake(margin, -CellViewHeight, CellViewWidth, CellViewHeight);
            } completion:^(BOOL finished){
                _twoCellView.frame = CGRectMake(margin, CellViewHeight, CellViewWidth, CellViewHeight);
            }];
        }else{
            [UIView animateWithDuration:1 animations:^{
                _oneCellView.frame = CGRectMake(margin, 0, CellViewWidth, CellViewHeight);
            } completion:^(BOOL finished){
                _twoCellView.frame = CGRectMake(margin, CellViewHeight, CellViewWidth, CellViewHeight);
            }];
        }
    }else{
        if (index%2 == 0) {
            [UIView animateWithDuration:1 animations:^{
                _oneCellView.frame = CGRectMake(margin, 0, CellViewWidth, CellViewHeight);
                _twoCellView.frame = CGRectMake(margin, -CellViewHeight, CellViewWidth, CellViewHeight);
            } completion:^(BOOL finished){
                _twoCellView.frame = CGRectMake(margin, CellViewHeight, CellViewWidth, CellViewHeight);
            }];
        }else{
            [UIView animateWithDuration:1 animations:^{
                _twoCellView.frame = CGRectMake(margin, 0, CellViewWidth, CellViewHeight);
                _oneCellView.frame = CGRectMake(margin, -CellViewHeight, CellViewWidth, CellViewHeight);
            } completion:^(BOOL finished){
                _oneCellView.frame = CGRectMake(margin, CellViewHeight, CellViewWidth, CellViewHeight);
            }];
        }
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.isHaveHeadImg == YES) {
        [self addSubview:self.headImageView];
        self.headImageView.frame = CGRectMake(0, 0, HRViewHeight,HRViewHeight);
        margin = HRViewHeight + 10;
    }else{
        
        if (self.headImageView) {
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        margin = 0;
    }
    _oneCellView.frame = CGRectMake(margin, 0, CellViewWidth, CellViewHeight);
    _twoCellView.frame = CGRectMake(margin, CellViewHeight, CellViewWidth, CellViewHeight);
}


- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timeRepeat) userInfo:self repeats:YES];
    }
    return _timer;
}



- (void)beginScroll{
    
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)closeScroll{
    
    [self.timer invalidate];
    self.timer = nil;
}



- (void)setIsHaveHeadImg:(BOOL)isHaveHeadImg{
    _isHaveHeadImg = isHaveHeadImg;
    
}

- (void)setIsHaveTouchEvent:(BOOL)isHaveTouchEvent{
    _isHaveTouchEvent = isHaveTouchEvent;
    if (isHaveTouchEvent) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }else{
        self.userInteractionEnabled = NO;
    }
}

- (void)setTime:(NSTimeInterval)time{
    _time = time;
    if (self.timer.isValid) {
        [self.timer isValid];
        self.timer = nil;
    }
}


- (void)setHeadImg:(UIImage *)headImg{
    _headImg = headImg;
    
    self.headImageView.image = headImg;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    
    _oneCellView_OneLabel.textAlignment = _textAlignment;
    _twoCellView_OneLabel.textAlignment = _textAlignment;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    _oneCellView_OneLabel.textColor = _color;
    _twoCellView_OneLabel.textColor = _color;
}

- (void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
    _oneCellView_OneLabel.font = _labelFont;
    _twoCellView_OneLabel.font = _labelFont;
}
-(void)setMarkTitlesColor:(NSArray<UIColor *> *)markTitlesColor
{
    _markTitlesColor = markTitlesColor;
}

- (void)clickEvent:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self.adTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index % 2 == 0 && [_oneCellView_OneLabel.text isEqualToString:obj]) {
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }else if(index % 2 != 0 && [_twoCellView_OneLabel.text isEqualToString:obj]){
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }
    }];
    
}


@end
