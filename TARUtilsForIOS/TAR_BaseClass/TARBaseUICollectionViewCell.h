//
//  TARBaseUICollectionViewCell.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/11.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TARBaseUICollectionViewCell : UICollectionViewCell
{
    
}
@property(nonatomic, strong)UIView *cellBackgroundView;
@property(nonatomic, assign)CGFloat cellContent_Offset_H;


#pragma mark --初始化主UI布局--
-(void)initMainUI;


-(void)setCellValueWithCellModel:(id)cellModel;

@end
