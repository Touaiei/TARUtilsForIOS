//
//  TARBaseWebViewController.h
//  YouJiaApp
//
//  Created by TAR on 2017/1/5.
//  Copyright © 2017年 TAR. All rights reserved.
/*
 共用Web页面VC
 */

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, pageJumpWay) {
    pageJumpWay_push  = 0,
    pageJumpWay_modal = 1
};

@interface TARBaseWebViewController : UIViewController

@property(nonatomic, copy)NSString *homeURLStr;
@property(nonatomic, copy)NSString *baseNavTitle;
@property(nonatomic, assign)pageJumpWay pageJumpWay;
@property(nonatomic, assign)BOOL goBackAndReloadIsOpen;

/**
 重新加载主页
 */
-(void)reloadHomePage;

/**
 重新加载当前页
 */
-(void)reloadCurrentPage;

/**
 返回并重新加载
 */
-(void)goBackAndReload;


//1. native调用js
-(void)NativeCallJSMethodWithMethodName:(NSString *)nethodName parameter:(NSDictionary *)parameter;
//2. js调用native
-(void)JSCallNativeMethodSuccessWithScriptMessage:(WKScriptMessage *)scriptMessage;

@end
