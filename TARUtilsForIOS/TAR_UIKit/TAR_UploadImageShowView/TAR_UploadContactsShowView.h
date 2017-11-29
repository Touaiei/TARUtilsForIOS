//
//  TAR_UploadContactsShowView.h
//  EmployeesAPP
//
//  Created by TAR on 2017/8/15.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 上传并展示联系人View
 */
#import <UIKit/UIKit.h>

@protocol TAR_UploadContactsShowViewDelegate <NSObject>

//-(void)uploadImageButtonProtocol;
-(void)uploadContactsButtonProtocol;
-(void)uploadContactsChangeLayoutProtocol;

@end
typedef void(^showViewHeightBlock)(CGFloat showView_H);

@interface TAR_UploadContactsShowView : UIView
{
    NSInteger offsetMainViewHeight;//整个视图变化后最终高度
    
}
@property(nonatomic,weak)id<TAR_UploadContactsShowViewDelegate>delegate;
@property(nonatomic, copy)showViewHeightBlock layoutCallbackBlock;//改变布局后回调Block

/*图片展示区域*/
@property(nonatomic, strong)UIView *uploadImageBGView;//显示图片的背景view
@property(nonatomic, strong)UIView *uploadImageView;//显示图片的view
@property(nonatomic, strong)UIButton *uploadImageButton;//加号上传图片按钮
//@property(nonatomic, strong)UIImageView *cellImageView;//单个图片view
@property(nonatomic, strong)UIView *cellView;//单个Cell View

@property(nonatomic, strong)UIButton *deleteImageButton;//删除图片按钮
@property(nonatomic, strong)NSMutableArray <NSDictionary *> *imagesArrayTotal;//所以图片总数组
@property(nonatomic, strong)NSArray <NSDictionary *> *imagesArraySingle;//每次上传图片数组
@property(nonatomic, assign)NSInteger maxImageNumber;//图片最大数量

//-(void)changeShowViewLayout  showViewHeightCallbackBlock:(void (^)(CGFloat showView_H))block;

/**
 显示图片，并改变frame
 */
-(void)showContactsWithImageArray:(NSArray *)images;
-(NSArray *)getTotalImages;
-(CGFloat)getTotalHeight;

@end
