//
//  WXApiManager.m
//  LLG
//
//  Created by GL on 16/1/21.
//  Copyright © 2016年 beijiguang. All rights reserved.
//
/*
 微信API管理类
 */

#import "WXApiManager.h"
#import "TAR_StringToolClass.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

-(BOOL)registerApp:(NSString *)appid withDescription:(NSString *)appdesc
{
    _WXAppID = appid;
    return [WXApi registerApp:appid withDescription:appdesc];
}

+(BOOL)isInstalledWXApp
{
    return [WXApi isWXAppInstalled];
}

/**
 发起微信分享
 */
-(void)startWeChatShareWithSendWXReq:(SendMessageToWXReq *)WXReq
{
    [WXApi sendReq:WXReq];
}

/**
 发起微信登录身份验证
 */
-(void)startWeChatSendAuthReq:(SendAuthReq *)WXReq
{
    [WXApi sendReq:WXReq];
}

#pragma mark --发起微信支付--
-(void)startWeChatPayWithPayOrder:(NSDictionary *)orderDic
{
    NSString *partnerId = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:orderDic withKey:@"partnerid"]?@"":[orderDic objectForKey:@"partnerid"];
    NSString *prepayId = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:orderDic withKey:@"prepayid"]?@"":[orderDic objectForKey:@"prepayid"];
    NSString *package = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:orderDic withKey:@"package"]?@"":[orderDic objectForKey:@"package"];
    NSString *nonceStr = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:orderDic withKey:@"noncestr"]?@"":[orderDic objectForKey:@"noncestr"];
    NSString *timestamp = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:orderDic withKey:@"timestamp"]?@"":[orderDic objectForKey:@"timestamp"];
    NSString *sign = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:orderDic withKey:@"sign"]?@"":[orderDic objectForKey:@"sign"];
    
    PayReq *request = [[PayReq alloc]init];
    /** 商家向财付通申请的商家id */
    request.partnerId = partnerId;
    /** 预支付订单 */
    request.prepayId = prepayId;
    /** 商家根据财付通文档填写的数据和签名 */
    request.package = package;
    /** 随机串，防重发 */
    request.nonceStr = nonceStr;
    unsigned int time = (unsigned int)[timestamp longLongValue];
    /** 时间戳，防重发 */
    request.timeStamp = time;
    /** 商家根据微信开放平台文档对数据做的签名 */
    request.sign = sign;
    [WXApi sendReq:request];
}


#pragma mark --WXApiDelegate微信Api代理--
#pragma mark --微信处理结果回调函数--
/*
 * 发送一个sendReq后，收到微信的回应
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 */
- (void)onResp:(BaseResp *)resp {
    NSLog(@"resp===%@",resp);
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate&& [_delegate respondsToSelector:@selector(WXApiManagerShareResultResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
               NSLog(@"messageResp.errCode :  %i",messageResp.errCode);
            if (messageResp.errCode == 0) {
                [_delegate WXApiManagerShareResultResponse:messageResp];
            }
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    }else if ([resp isKindOfClass:[PayResp class]]){
        NSString * message;
        PayResp *response = (PayResp *)resp;
        if (self.delegate && [self.delegate respondsToSelector:@selector(WXApiManagerPayResultResponse:)]) {
            [self.delegate WXApiManagerPayResultResponse:response];
        }
//        if (self.delegate && [self.delegate respondsToSelector:@selector(sdfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsf)]) {
//            [self.delegate sdfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsf];
//        }
        
//        switch (response.errCode) {
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                message = @"微信支付成功";
//                break;
//            case WXErrCodeCommon:
//                //普通错误
//                NSLog(@"支付错误");
//                message = @"微信支付错误";
//                break;
//            case WXErrCodeUserCancel:
//                //用户点击取消并返回
//                NSLog(@"支付取消并返回");
//                message = @"微信支付取消并返回";
//                break;
//            default:
//                NSLog(@"支付失败，retcode=%d",resp.errCode);
//                message = @"微信支付失败!";
//                break;
//        }
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"支付结果:" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }
    
}


/*
 * 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 */
- (void)onReq:(BaseReq *)req {
    NSLog(@"req===%@",req);
    
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}



/**
 通过code获取access_token，openid 等数据
 @param code 发起微信身份验证后返回的code
 @param wxAppSecret 在微信开发平台上注册APP时生成的“秘密”
 @param block 返回结果
 */
- (void)getWeiXinOpenIDWithCode:(NSString *)code wxAppSecret:(NSString *)wxAppSecret block:(void(^)(NSDictionary * wxResult))block
{
    /**
     返回说明
     正确的返回样例：
     {
     "access_token":"ACCESS_TOKEN",
     "expires_in":7200,
     "refresh_token":"REFRESH_TOKEN",
     "openid":"OPENID",
     "scope":"SCOPE",
     "unionid":"o6_bmasdasdsad6_2sgVt7hMZOPfL"
     }
     */
    /**
     错误返回样例：
     {"errcode":40029,"errmsg":"invalid code"}
     */
    /**
     参数             说明
     access_token    接口调用凭证
     expires_in    access_token接口调用凭证超时时间，单位（秒）
     refresh_token    用户刷新access_token
     openid    授权用户唯一标识
     scope    用户授权的作用域，使用逗号（,）分隔
     unionid    当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
     */
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",_WXAppID,wxAppSecret,code];
    NSLog(@"getAccess_tokenUrl==%@",url);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //                NSLog(@"dic==%@",dic);
                //                NSString *openID = dic[@"openid"];
                //                NSString *unionid = dic[@"unionid"];
                //                NSString *access_token = dic[@"access_token"];
                block(dic);
            }
        });
    });
    
}


/**
 获取微信用户的信息
 @param WXDic access_token，openid 等信息
 @param block 返回结果
 */
-(void)getWXUserinfoWithWXDic:(NSDictionary *)WXDic block:(void(^)(NSDictionary *userInfoResult))block
{
    NSString *openID = WXDic[@"openid"];
    NSString *access_token = WXDic[@"access_token"];
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                block(dic);
                //                NSString *openID = dic[@"openid"];
                //                NSString *unionid = dic[@"unionid"];
                //                NSLog(@"dic==%@",dic);
            }
        });
    });
    /*
     AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
     //申明请求的数据是json类型
     //    session.requestSerializer = [AFJSONRequestSerializer serializer];
     //    session.requestSerializer = [AFHTTPRequestSerializer serializer];
     //申明返回的结果是json类型
     //    session.responseSerializer = [AFJSONResponseSerializer serializer];
     //    session.responseSerializer = [AFHTTPResponseSerializer serializer];
     //设置ContentType属性
     session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
     [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSLog(@"responseObject==%@",responseObject);
     [self wxLoginCheckWithWXDic:WXDic userInfo:responseObject];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     NSLog(@"error==%@",error.localizedDescription);
     }];
     */
}

/**
 刷新access_token有效期
 @param refresh_token 获取的refresh_token
 @param block 返回结果
 */
- (void)refreshToken:(NSString *)refresh_token block:(void(^)(NSDictionary *refreshResult))block
{
    /**
     返回说明
     正确的返回样例：
     {
     "access_token":"ACCESS_TOKEN",
     "expires_in":7200,
     "refresh_token":"REFRESH_TOKEN",
     "openid":"OPENID",
     "scope":"SCOPE"
     }
     */
    /**
     错误返回样例：
     {"errcode":40030,"errmsg":"invalid refresh_token"}
     */
    /**
     参数             说明
     access_token    接口调用凭证
     expires_in    access_token接口调用凭证超时时间，单位（秒）
     refresh_token    用户刷新access_token
     openid    授权用户唯一标识
     scope    用户授权的作用域，使用逗号（,）分隔
     */
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",Macro_WXAppID,refresh_token];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //                NSString *openID = dic[@"openid"];
                //                NSString *unionid = dic[@"unionid"];
                block(dic);
            }
        });
    });
    
}

@end




