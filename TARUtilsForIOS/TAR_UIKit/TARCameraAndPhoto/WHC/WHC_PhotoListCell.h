//
//  WHC_PhotoListCell.h
//  photoPlay
//
//  Created by GL on 16/3/7.
//  Copyright © 2016年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WHC_PhotoListCellDelegate <NSObject>

-(BOOL)WHCPhotoListCurrentChoiceState:(BOOL)selected;

-(void)WHCPhotoListCancelChoicePhoto;

@end


@interface WHC_PhotoListCell : UITableViewCell

@property (nonatomic,assign)id<WHC_PhotoListCellDelegate>delegate;
@property (nonatomic,assign)NSInteger listColumn;

-(void)setAssets:(NSArray *)assets;

+(CGFloat)cellHeight;



@end
