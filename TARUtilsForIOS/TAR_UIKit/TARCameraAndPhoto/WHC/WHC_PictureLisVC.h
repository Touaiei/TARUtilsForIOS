//
//  WHC_PictureLisVC.h
//  photoPlay
//
//  Created by GL on 16/3/7.
//  Copyright © 2016年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHC_ChoicePictureVC.h"

@interface WHC_PictureLisVC : UIViewController
@property (nonatomic,weak)id<WHC_ChoicePictureVCDelegate>delegate;
@property (nonatomic,assign) NSInteger maxChoiceImageNumberumber;


@end
