//
//  MenuItemModel.h
//  YouJiaApp
//
//  Created by TAR on 2017/9/7.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItemModel : NSObject

@property(nonatomic, copy)NSString *menuItemName;
@property(nonatomic, copy)NSString *menuItemID;
@property(nonatomic, assign)BOOL isShowSmallRedDot;
//@property(nonatomic, copy)NSString *messages;//

@end
