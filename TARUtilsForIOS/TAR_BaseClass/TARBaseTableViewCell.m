//
//  TARBaseTableViewCell.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/1.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TARBaseTableViewCell.h"

@interface TARBaseTableViewCell()
{


}

@end

@implementation TARBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCellBackgroundView];
        [self initMainUI];
        
    }
    return self;
}



-(void)initCellBackgroundView
{
    CGFloat spaceTop = 10;
    CGFloat spaceLeft = 15;
    CGFloat spaceBottom = 10;
    CGFloat spaceRight = 15;
    _cellBackgroundView = [[UIView alloc]init];
//    _cellBackgroundView.layer.borderWidth = 1;
//    _cellBackgroundView.layer.borderColor = [UIColor redColor].CGColor;
    [self addSubview:_cellBackgroundView];
    [_cellBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(spaceTop, spaceLeft, spaceBottom, spaceRight));
    }];
    _cellContent_Offset_H += (spaceTop+spaceBottom);
}




@end
