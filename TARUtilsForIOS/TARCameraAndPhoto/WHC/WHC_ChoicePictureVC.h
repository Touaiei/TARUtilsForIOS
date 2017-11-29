//
//  WHC_ChoicePictureVC.h
//  photoPlay
//
//  Created by GL on 16/3/7.
//  Copyright © 2016年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class WHC_ChoicePictureVC;

@protocol WHC_ChoicePictureVCDelegate <NSObject>

-(void)WHCChoicePictureVC:(WHC_ChoicePictureVC *)choicePictureVC didSelectedPhotoArr:(NSArray *)photoArr;

@end

@interface WHC_ChoicePictureVC : UIViewController

@property (nonatomic,weak)id<WHC_ChoicePictureVCDelegate> delegate;
@property (nonatomic,assign)NSInteger maxChoiceImageNumber;
@property (nonatomic,strong)ALAssetsGroup * assetsGroup;

@end
