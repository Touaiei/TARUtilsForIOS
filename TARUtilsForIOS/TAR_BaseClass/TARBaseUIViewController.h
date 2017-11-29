//
//  TARBaseUIViewController.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/8.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TARBaseUIViewController : UIViewController

@property(nonatomic,copy)NSString *navTitle;

@property(nonatomic,strong)UIColor *navTitleColor;


-(void)initNavBar;

-(void)initMainUI;

-(void)initRefresh;

-(void)requestMainData;





@end
