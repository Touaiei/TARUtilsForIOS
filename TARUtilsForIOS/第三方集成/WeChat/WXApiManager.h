//
//  WXApiManager.h
//  LLG
//
//  Created by GL on 16/1/21.
//  Copyright © 2016年 beijiguang. All rights reserved.
//
/*
 微信API管理类
 */

#import <Foundation/Foundation.h>
#import "WXApi.h"

typedef NS_ENUM(NSInteger,WXApiManagerShareType) {
    WXApiManagerShareType_WXFriend,         //微信好友
    WXApiManagerShareType_WXFriendsCircle   //微信朋友圈
};

@protocol WXApiManagerDelegate <NSObject>
@optional
//微信分享回调
- (void)WXApiManagerShareResultResponse:(SendMessageToWXResp *)response;
//微信身份认证回调
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;
//微信支付结果回调
-(void)WXApiManagerPayResultResponse:(PayResp *)response;

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end



@interface WXApiManager : NSObject
<
WXApiDelegate
>
@property (nonatomic, weak)id<WXApiManagerDelegate> delegate;
@property(nonatomic,assign)WXApiManagerShareType shareType;
@property(nonatomic,copy)NSString *WXAppID;//微信appID


+ (instancetype)sharedManager;

-(BOOL)registerApp:(NSString *)appid withDescription:(NSString *)appdesc;

+(BOOL)isInstalledWXApp;

/**
 发起微信支付
 */
-(void)startWeChatPayWithPayOrder:(NSDictionary *)orderDic;

/**
 发起微信分享
 */
-(void)startWeChatShareWithSendWXReq:(SendMessageToWXReq *)WXReq;

/**
 发起微信登录身份验证
 */
-(void)startWeChatSendAuthReq:(SendAuthReq *)WXReq;


/**
 通过code获取access_token，openid 等数据
 @param code 发起微信身份验证后返回的code
 @param wxAppSecret 在微信开发平台上注册APP时生成的“秘密”
 @param block 返回结果
 */
- (void)getWeiXinOpenIDWithCode:(NSString *)code wxAppSecret:(NSString *)wxAppSecret block:(void(^)(NSDictionary * wxResult))block;

/**
 获取微信用户的信息
 @param WXDic access_token，openid 等信息
 @param block 返回结果
 */
-(void)getWXUserinfoWithWXDic:(NSDictionary *)WXDic block:(void(^)(NSDictionary *userInfoResult))block;

/**
 刷新access_token有效期
 @param refresh_token 获取的refresh_token
 @param block 返回结果
 */
- (void)refreshToken:(NSString *)refresh_token block:(void(^)(NSDictionary *refreshResult))block;





@end


