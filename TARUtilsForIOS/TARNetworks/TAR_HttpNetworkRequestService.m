//
//  TAR_HttpNetworkRequestService.m
//  JiaDuanAPP
//
//  Created by TAR on 2016/12/8.
//  Copyright © 2016年 TAR. All rights reserved.
//

#import "TAR_HttpNetworkRequestService.h"
#import "TAR_StringToolClass.h"
#import "TARToolsClass_UpdateAppVersion.h"
#import "TAR_BlankContentView.h"

#import "TAR_AlertController.h"
#import "AccountManager.h"
//#import "LoginPageViewController.h"

//#import "TARDataBaseManager.h"




@interface TAR_HttpNetworkRequestService()
<UIAlertViewDelegate>
{
    TAR_BlankContentView *blankContentView;
    TARProgressHUD *TAR_HUD;
    TARToolsClass_UpdateAppVersion *TAR_AlertBox;
}
@property(nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation TAR_HttpNetworkRequestService

// https ssl 验证函数
-(AFSecurityPolicy *)customSecurityPolicy
{
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];//证书的路径
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];//AFSecurityPolicy分三种验证模式：AFSSLPinningModeNone,AFSSLPinningModePublicKey,AFSSLPinningModeCertificate,
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = NO;

    return securityPolicy;
}

+(NSDictionary *)getRequestParamsBodyWithParams:(NSDictionary *)params
{
    NSDictionary *requestParams = [self addJiaDuanSign:params];
    NSLog(@"requestParams==%@",requestParams);
    NSString *requestParamsStr = [TAR_StringToolClass arrayOrDictionaryToJSONString:requestParams];//参数字典转换为字符串
    NSDictionary *requestBody = @{@"content":requestParamsStr};
    return requestBody;
}
+(NSDictionary *)addJiaDuanSign:(NSDictionary *)params
{
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSString *valueSortingString = [TAR_StringToolClass getSignWithDictionary:params];//Value排序后的新字符串
    NSString *ASCIICodeString = [TAR_StringToolClass stringToASCIICodeFromString:valueSortingString];//
    NSString *jiaDuanSign = [TAR_StringToolClass MD5_32Bit:ASCIICodeString];
    //添加sign参数
    [paramsDict setObject:jiaDuanSign forKey:@"sign"];
    return paramsDict;
}
+(NSDictionary *)addJiaDuanToken:(NSDictionary *)params
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDictionary *userInfo = Macro_GetUserInfo;
    NSString *token = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:userInfo withKey:@"token"]?@"":userInfo[@"token"];
    //添加token参数
    [tempDic setObject:token forKey:@"token"];
    return tempDic;
}
+(NSDictionary *)addPaging:(NSDictionary*)params pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    if (pageIndex >= 1) {
        [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"page"];
    }else{
        [tempDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"page"];
    }
    if (pageSize >= 1) {
        [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"rows"];
    }else{
        [tempDic setObject:[NSString stringWithFormat:@"%d",10] forKey:@"rows"];
    }
    return tempDic;
}
+(NSDictionary *)addQueryTime:(NSDictionary*)params stime:(NSString *)stime etime:(NSString *)etime
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([stime isKindOfClass:[NSNull class]] || stime == nil || stime.length < 1) {
        [tempDic setObject:@"" forKey:@"stime"];
    }else{
        [tempDic setObject:[NSString stringWithFormat:@"%@",stime] forKey:@"stime"];
    }
    if ([etime isKindOfClass:[NSNull class]] || etime == nil || etime.length < 1) {
        [tempDic setObject:@"" forKey:@"etime"];
    }else{
        [tempDic setObject:[NSString stringWithFormat:@"%@",etime] forKey:@"etime"];
    }
    return tempDic;
}
+(AFHTTPSessionManager *)getAFHTTPSessionManagerInstanceObject
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    //    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //申明返回的结果是json类型
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    //设置超时时间为10s
    session.requestSerializer.timeoutInterval = 10;
    //设备安全策略
    [session setSecurityPolicy:[[self alloc] customSecurityPolicy]];
    return session;
}

-(void)postRequest:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull uploadProgress))progress success:(requestResponseBlock)success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    AFHTTPSessionManager *session = [[self class] getAFHTTPSessionManagerInstanceObject];
    [session POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress==%@",uploadProgress);
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSLog(@"responseObject===>%@",responseObject);

        NSDictionary *responseObj = [TAR_StringToolClass nullToNonnullWithDictionary:responseObject];
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            if ([[responseObj allKeys] containsObject:@"status"] == YES) {
                NSString *errorMsg = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:responseObj withKey:@"msg"]?@"":responseObj[@"msg"];
                NSString *status = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:responseObj withKey:@"status"]?@"":responseObj[@"status"];
                NSString *statusCode = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:responseObj withKey:@"scode"]?@"":responseObj[@"scode"];
                if ([status isEqualToString:@"1"]) {
                    NSLog(@"请求数据成功==%@",responseObj);
                    success(YES, statusCode, errorMsg, responseObj);
                }else{
                    NSLog(@"请求数据失败，错误信息==%@",errorMsg);
                    success(NO, statusCode, errorMsg, responseObj);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求接口错误，错误信息==%@",error.localizedDescription);
        failure(task,error);
    }];
}


/**
 POST请求，需要权限才能访问
 */
-(void)postServiceRequestWithURL:(NSString *)url andParams:(NSDictionary *)params andProgress:(void (^)(NSProgress *))progre andSucceed:(requestResponseBlock)succe andFail:(void (^)(id))fail
{
    NSString *requestUrl =[JDRequestURL stringByAppendingString:url];
    NSLog(@"requestUrl==%@",requestUrl);
    NSDictionary *tempDic = [[self class] addJiaDuanToken:params];
    NSDictionary *requestParamsBody = [[self class] getRequestParamsBodyWithParams:tempDic];
    [self postRequest:requestUrl parameters:requestParamsBody progress:^(NSProgress * _Nonnull uploadProgress) {
        progre(uploadProgress);
    } success:^(BOOL isSuccess, NSString *statusCode, NSString *errorMsg, id responseObject) {
        if (isSuccess) {
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }else{
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *str = error.localizedDescription;
        //        [[self alloc] showAlertBoxWithPromptText:str];
        [self showHUDWithHUDMode:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow PromptText:str afterDelay:-1];
        fail(error.localizedDescription);
    }];
}

-(void)saveDataWithItemID:(NSString *)itemID item:(NSDictionary *)item
{
    // 创建
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@{@"item":item,@"itemID":itemID}];
//
//    // 启动
//    [thread start];
    
    [self performSelectorInBackground:@selector(dddd:) withObject:@{@"itemID":itemID,@"item":item}];
}
-(void)dddd:(nullable id)object
{
    NSLog(@"object==%@",object);
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSString *itemID = [object objectForKey:@"itemID"];
        NSDictionary *item = [object objectForKey:@"item"];
//        [TARDataBaseManager saveDataWithItemID:itemID itemDict:item];
    }
}

/*
 GET请求，
 */
-(void)getRequestWithURL:(NSString *)url andParams:(NSDictionary *)params andProgress:(void (^)(id))progre andSucceed:(void (^)(id))succe andFail:(void (^)(id))fail
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progre(downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        succe(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
    }];
}

/*
 POST请求，不需要权限即可访问
 */
-(void)postRequestNoTokenRequestWithURL:(NSString *)url andParams:(id)params andProgress:(void (^)(id))progre andSucceed:(requestResponseBlock)succe andFail:(void (^)(id))fail
{
    NSString *requestUrl =[JDRequestURL stringByAppendingString:url];
    NSLog(@"requestUrl==%@",requestUrl);
    NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:params];
    NSDictionary *requestParamsBody = [[self class] getRequestParamsBodyWithParams:tempDic];
    [self postRequest:requestUrl parameters:requestParamsBody progress:^(NSProgress * _Nonnull uploadProgress) {
        progre(uploadProgress);
    } success:^(BOOL isSuccess, NSString *statusCode, NSString *errorMsg, id responseObject) {
        if (isSuccess) {
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }else{
            NSLog(@"errorMsg==%@",errorMsg);
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *str = error.localizedDescription;
        //        [[self alloc] showAlertBoxWithPromptText:str];
        [self  showHUDWithHUDMode:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow PromptText:str afterDelay:-1];
        fail(error);
    }];
}

#pragma mark //--资源上传请求方法区域--
/**
 压缩图片获得imageData
 @param image 需要压缩的Image
 @return 返回压缩后的imageData
 */
+(NSData *)getImageDataFromCompressionWithImage:(UIImage *)image
{
    if ([image isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if ([imageData length]/1024.0 < 100) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }else if ([imageData length]/1024.0>=100 && [imageData length]/1024.0<250) {
        imageData = UIImageJPEGRepresentation(image, 0.4);
    }else if ([imageData length]/1024.0>=250 && [imageData length]/1024.0<500){
        imageData = UIImageJPEGRepresentation(image, 0.2);
    }else if ([imageData length]/1024.0>=500 && [imageData length]/1024.0<750){
        imageData = UIImageJPEGRepresentation(image, 0.14);
    }else if ([imageData length]/1024.0>=750 && [imageData length]/1024.0<1000){
        imageData = UIImageJPEGRepresentation(image, 0.1);
    }else if ([imageData length]/1024.0>=1000 && [imageData length]/1024.0<1500){
        imageData = UIImageJPEGRepresentation(image, 0.066);
    }else if ([imageData length]/1024.0>=1500 && [imageData length]/1024.0<2000){
        imageData = UIImageJPEGRepresentation(image, 0.05);
    }else if ([imageData length]/1024.0>=2000 && [imageData length]/1024.0<2500){
        imageData = UIImageJPEGRepresentation(image, 0.04);
    }else if ([imageData length]/1024.0>=2500 && [imageData length]/1024.0<3000){
        imageData = UIImageJPEGRepresentation(image, 0.033);
    }else if ([imageData length]/1024.0>=3000 && [imageData length]/1024.0<3500){
        imageData = UIImageJPEGRepresentation(image, 0.028);
    }else if ([imageData length]/1024.0>=3500 && [imageData length]/1024.0<4000){
        imageData = UIImageJPEGRepresentation(image, 0.025);
    }else if ([imageData length]/1024.0>=4000 && [imageData length]/1024.0<4500){
        imageData = UIImageJPEGRepresentation(image, 0.022);
    }else if ([imageData length]/1024.0>=4500 && [imageData length]/1024.0<5000){
        imageData = UIImageJPEGRepresentation(image, 0.02);
    }else if ([imageData length]/1024.0 >= 5000){
        imageData = UIImageJPEGRepresentation(image, 0.015);
    }
    return imageData;
}

/**
 POST请求，上传图片数据请求方法，需要权限才能访问
 */
-(void)postUploadImageRequestWithImages:(NSArray *)images andURL:(NSString *)url andParams:(NSDictionary *)params constructingBodyWithBloc:(void (^)(id))constructingBody andProgress:(void (^)(NSProgress *))progre andSucceed:(requestResponseBlock)succe andFail:(void (^)(id))fail
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSLog(@"requestParams==%@",paramsDic);
    NSString *requestUrl =[JDUploadImageURL stringByAppendingString:url];
    NSLog(@"requestUrl==%@",requestUrl);
    AFHTTPSessionManager *session = [[self class] getAFHTTPSessionManagerInstanceObject];
    [session POST:requestUrl parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"formData==%@",formData);
        for (int i=0; i<images.count; i++) {
            NSData *imageData = [[self class] getImageDataFromCompressionWithImage:images[i]];
            NSString *fileName =[NSString stringWithFormat:@"%i",arc4random() % 100000];
            NSString * fileWithDi = [NSString stringWithFormat:@"%@.jpg",fileName];
            NSInteger number = arc4random()%1000;
            NSString * imageName = [NSString stringWithFormat:@"%ld+mainImage",(long)number];
            [formData appendPartWithFileData:imageData name:imageName fileName:fileWithDi mimeType:@"image/jpeg"];
        }
//        constructingBody(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传图片uploadProgress!==%@",uploadProgress);
        progre(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传图片成功！==%@",responseObject);
        NSDictionary *responseObj = [TAR_StringToolClass nullToNonnullWithDictionary:responseObject];
        if ([responseObj isKindOfClass:[NSDictionary class]]) {
            if ([[responseObj allKeys] containsObject:@"status"] == YES) {
                NSString *Result = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:responseObj withKey:@"status"]?@"":responseObj[@"status"];
                NSString *errorMsg = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:responseObj withKey:@"msg"]?@"":responseObj[@"msg"];
                if ([Result isEqualToString:@"1"]) {
                    succe(YES, Result, errorMsg, responseObj);
                }else{
                    [self showHUDWithHUDMode:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow PromptText:errorMsg afterDelay:-1];
                    succe(NO, Result, errorMsg, responseObj);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片失败！==%@",error.localizedDescription);
        NSString *str = error.localizedDescription;
//        [[self alloc]showAlertBoxWithPromptText:str];
        [self showHUDWithHUDMode:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow PromptText:str afterDelay:-1];
        fail(error.localizedDescription);
    }];

}
#pragma mark --资源上传请求方法区域--//

/**
 POST请求，获取验证码专用
 */
-(void)postRequestValidationCode:(NSString *)validationCode phoneNumber:(NSString *)phoneNumber
{
    NSString *vCode = [TAR_StringToolClass isEqualPureInt:validationCode]?validationCode:@"";
    NSString *pNumber = [TAR_StringToolClass isEqualPureInt:phoneNumber]?phoneNumber:@"";
    NSString *url = @"Users/RequestVerificationCode";
    NSDictionary *paramsDic = @{@"phoneNum":pNumber,@"verificationCode":vCode};
    [self postServiceRequestWithURL:url andParams:paramsDic andProgress:^(id uploadProgress){
        
    } andSucceed:^(BOOL isSuccess, NSString *statusCode, NSString *errorMsg, id responseObject) {
        if (isSuccess) {
            [TAR_AlertController alertControllerStyleWithTitle:@"发送成功~" mesasge:nil viewController:_targetVC afterDelay:2.0 confirmHandler:^(UIAlertAction *action) {}];
        }else{
            [TAR_AlertController alertControllerStyleWithTitle:errorMsg mesasge:nil viewController:_targetVC afterDelay:2.0 confirmHandler:^(UIAlertAction *action) {}];
        }
    } andFail:^(id error) {
        [TAR_AlertController alertControllerStyleWithTitle:error mesasge:nil viewController:_targetVC afterDelay:2.0 confirmHandler:^(UIAlertAction *action) {}];
    }];
}


#pragma mark //--列表分页请求方法区域--
/**
 POST请求，需要权限才能访问,UITableView、UICollectionView、UIScrollView 分页请求方法
 @param tableView 由于UITableView和UICollectionView都是继承自UIScrollView，所以在调用方法时统统转换成UIScrollView
 */
-(void)postRequestPagingWithTableView:(UIScrollView *)tableView withDatas:(NSArray *)datas withIsPaging:(BOOL)isPaging withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize WithURL:(NSString *)url andParams:(NSDictionary *)params andProgress:(void (^)(id))progre andSucceed:(requestResponseBlock)succe andFail:(void (^)(id))fail
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDictionary *tokenParams = [[self class] addJiaDuanToken:tempDic];
    tempDic = [NSMutableDictionary dictionaryWithDictionary:tokenParams];
    if (isPaging == YES) {//如果开启分页才添加分页
        NSDictionary *pagingParams = [[self class] addPaging:tempDic pageIndex:pageIndex pageSize:pageSize];
        tempDic = [NSMutableDictionary dictionaryWithDictionary:pagingParams];
    }
    NSDictionary *requestParamsBody = [[self class] getRequestParamsBodyWithParams:tempDic];
    NSString *requestUrl =[JDRequestURL stringByAppendingString:url];
    NSLog(@"requestUrl==%@",requestUrl);
    [self postRequest:requestUrl parameters:requestParamsBody progress:^(NSProgress * _Nonnull uploadProgress) {
        progre(uploadProgress);

    } success:^(BOOL isSuccess, NSString *statusCode, NSString *errorMsg, id responseObject) {
        if (isSuccess) {
            [self netRequestPagingSuccessWithTableView:tableView withDatas:datas withPageIndex:pageIndex withResultData:responseObject[@"body"]];
            
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }else{
            [self endRefreshingWithTableView:tableView];//结束列表刷新
            [self netRequestPagingFailureWithTableView:tableView withDatas:datas withPageIndex:pageIndex withErrorMsg:errorMsg];
            
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *str = error.localizedDescription;
        [self netRequestPagingFailureWithTableView:tableView withDatas:datas withPageIndex:pageIndex withErrorMsg:str];
        [self showHUDWithHUDMode:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow PromptText:str afterDelay:-1];
        fail(error.localizedDescription);
    }];
}

//成功
-(void)netRequestPagingSuccessWithTableView:(UIScrollView *)tableView withDatas:(NSArray *)datas withPageIndex:(NSInteger)pageIndex withResultData:(NSDictionary *)resultData
{
    for (UIView *subView in tableView.subviews) {
        if ([subView isKindOfClass:[TAR_BlankContentView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!blankContentView) {
        blankContentView = [[TAR_BlankContentView alloc]init];
    }
    blankContentView.blankContentViewType = blankContentViewType_NoContent;
    blankContentView.imagePath = @"ic_no";
    blankContentView.imageViewSize = CGSizeMake(100, 100);
    blankContentView.promptText = @"暂无内容~_~!";
    [blankContentView initInterfaceBuilder];
//            blankContentView.backgroundColor = [UIColor redColor];
    [tableView addSubview:blankContentView];
    [blankContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tableView);
        make.width.and.height.mas_equalTo(tableView.width);
    }];
    NSArray *dataArray = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:resultData withKey:@"results"]?@[]:resultData[@"results"];   
    if (dataArray.count>0) {
        [blankContentView setHidden:YES];
        tableView.mj_footer.hidden = NO;
    }else{
        if (pageIndex == 1) {
            if (datas.count < 1) {
                tableView.mj_footer.hidden = YES;
                [blankContentView setHidden:NO];
            }else{
                tableView.mj_footer.hidden = NO;
                [blankContentView setHidden:YES];
            }
        }else{
            tableView.mj_footer.hidden = NO;
            [blankContentView setHidden:YES];
            [tableView.mj_footer endRefreshingWithNoMoreData];//已经全部加载完毕
        }
    }
}
//错误，显示空白内容页 blankContentView
-(void)netRequestPagingFailureWithTableView:(UIScrollView *)tableView withDatas:(NSArray *)datas withPageIndex:(NSInteger)pageIndex withErrorMsg:(NSString *)errorMsg
{
//    tableView.mj_footer.hidden = YES;
    for (UIView *subView in tableView.subviews) {
        if ([subView isKindOfClass:[TAR_BlankContentView class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!blankContentView) {
        blankContentView = [[TAR_BlankContentView alloc]init];
        blankContentView.delegate = _targetVC;
    }
    [blankContentView setHidden:NO];
    blankContentView.blankContentViewType = blankContentViewType_LoadFailure;
    blankContentView.promptText = errorMsg;
    blankContentView.imagePath = @"ic_no";
    blankContentView.imageViewSize = CGSizeMake(100, 100);
    //            blankContentView.backgroundColor = [UIColor redColor];
    [blankContentView initInterfaceBuilder];
    [tableView addSubview:blankContentView];
    [blankContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(tableView);
        make.width.and.height.mas_equalTo(tableView.width);
    }];
    if (datas.count < 1) {
        tableView.mj_footer.hidden = YES;
        [blankContentView setHidden:NO];
    }else{
        tableView.mj_footer.hidden = NO;
        [blankContentView setHidden:YES];
    }
}

/**
 结束刷新
 */
-(void)endRefreshingWithTableView:(UIScrollView *)tableView
{
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}
#pragma mark --列表分页请求方法区域--//



#pragma mark ---检查APP版本更新请求
-(void)httpNetRequestUpdateAppWithURL:(NSString *)url andParams:(NSDictionary *)params andProgress:(void (^)(id))progre andSucceed:(void (^)(id))succe andFail:(void (^)(id))fail
{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]initWithDictionary:tempDic];
    NSLog(@"requestParams==%@",paramsDic);
    NSString *requestUrl = url;
    NSLog(@"requestUrl==%@",requestUrl);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:requestUrl parameters:paramsDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"progress");
        progre(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"成功!responseObject=====%@",responseObject);
        NSInteger resultCount = [responseObject[@"resultCount"] integerValue];
        if (resultCount == 1) {
            succe(responseObject);
        }else{
            NSLog(@"httpNetRequestUpdateApp失败！");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败!error=====%@",error.localizedDescription);
        fail(error.localizedDescription);
    }];
}




/*
 POST请求，登录专用
 */
-(void)postRequestLoginServiceWithURL:(NSString *)url andParams:(id)params andProgress:(void (^)(id))progre andSucceed:(requestResponseBlock)succe andFail:(void (^)(id))fail
{
    NSString *requestUrl =[JDRequestURL stringByAppendingString:url];
    NSLog(@"requestUrl==%@",requestUrl);
    NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:params];
//    NSDictionary *tempDic = [[self class] addJiaDuanToken:params];
    NSDictionary *requestParamsBody = [[self class] getRequestParamsBodyWithParams:tempDic];
    [self postRequest:requestUrl parameters:requestParamsBody progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progre(uploadProgress);
    } success:^(BOOL isSuccess, NSString *statusCode, NSString *errorMsg, id responseObject) {
        if (isSuccess) {
            [[self class]saveLoginInfo:responseObject[@"body"] account:tempDic[@"username"] password:tempDic[@"password"]];
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }else{
            succe(isSuccess, statusCode, errorMsg, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *str = error.localizedDescription;
        //        [[self alloc] showAlertBoxWithPromptText:str];
        [self showHUDWithHUDMode:MBProgressHUDModeText addToView:[UIApplication sharedApplication].keyWindow PromptText:str afterDelay:-1];
        fail(error);
    }];
}
+(void)saveLoginInfo:(NSDictionary *)Response account:(NSString *)act password:(NSString *)pwd
{
    /*持久化保存用户信息*/
    NSString *account = [TAR_StringToolClass isEqualEmptyWithString:act]?@"":act;
    NSString *password = [TAR_StringToolClass isEqualEmptyWithString:pwd]?@"":pwd;
    NSString *token = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:Response withKey:@"token"]?@"":Response[@"token"];
    NSString *userID = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:Response withKey:@"userid"]?@"":Response[@"userid"];
//    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]initWithDictionary:[TAR_StringToolClass nullToNonnullWithDictionary:Response]];
    NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc]init];
    [userInfoDic setObject:account forKey:@"account"];
    [userInfoDic setObject:password forKey:@"password"];
    [userInfoDic setObject:token forKey:@"token"];
    [userInfoDic setObject:userID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults]setObject:userInfoDic forKey:@"UserInfo_KEY"];//持久化保存用户信息standardUserDefaults
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"userInfoDic==%@",userInfoDic);
}


-(void)accountInvalidWarning
{
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"亲，登录已经失效" message:@"请从新登录~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.delegate = _targetVC;
//        [alertView show];
    [TAR_AlertController alertTitle:@"亲，登录已经失效" mesasge:@"请从新登录~" preferredStyle:UIAlertControllerStyleAlert viewController:_targetVC confirmHandler:^(UIAlertAction *action) {
        if ([AccountManager logOut] == YES) {
            [self changeMainWindowToLoginVC];
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        if ([AccountManager logOut] == YES) {
            [[self class]changeMainWindowToLoginVC];
        }
    }
}
-(void)changeMainWindowToLoginVC
{
    /*
    [UIView animateWithDuration:0.2 animations:^{
        //切换到MainViewController，当前的这个ViewController会被销毁
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.backgroundColor = [UIColor whiteColor];
        window.rootViewController = [[LoginPageViewController alloc]init];
    }];
     */
}



#pragma mark --显示HUD提示框--
-(void)showHUDWithHUDMode:(MBProgressHUDMode)mode addToView:(UIView *)view PromptText:(NSString *)text afterDelay:(NSTimeInterval)delay
{
    if (!TAR_HUD) {
//        TAR_HUD = nil;
        TAR_HUD = [[TARProgressHUD alloc]init];
    }
    [TAR_HUD showHUDAddedTo:view animated:YES];
    TAR_HUD.modes = mode;
    TAR_HUD.promptText = text;
    TAR_HUD.userInteractionEnabled = NO;
    if (delay>0) {
        [TAR_HUD hiddenWithAnimated:YES afterDelay:delay];
    }else{
        [TAR_HUD hiddenWithAnimated:YES afterDelay:3];
    }
}
-(void)hiddenTAR_HUD
{
    [TAR_HUD hiddenWithAnimated:YES];
}
#pragma mark --显示alertBox提示框--
-(void)showAlertBoxWithPromptText:(NSString *)text
{
    if (!TAR_AlertBox) {
        TAR_AlertBox = [[TARToolsClass_UpdateAppVersion alloc]init];
    }
    [TAR_AlertBox alertBoxWithTitle:text andMessage:nil];

}
@end

@interface TAR_NetworkReachability()
{

}
@end

@implementation TAR_NetworkReachability
+ (instancetype)sharedManager {
    static TAR_NetworkReachability *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TAR_NetworkReachability alloc] init];
    });
    
    return instance;
}

#pragma mark --网络监控，基于AFNetworkReachabilityManager封装（二选一即可）--
-(void)initMonitoringNetworkReachability
{
    if (!manager) {
        manager = [AFNetworkReachabilityManager manager];
    }
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //未识别的网络
                NSLog(@"网络状态->未识别的网络");
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //不可达的网络(未连接)
                NSLog(@"网络状态->不可达的网络(未连接)");
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //wifi网络
                NSLog(@"网络状态->wifi网络");
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //移动2G,3G,4G...网络
                NSLog(@"网络状态->移动2G,3G,4G...网络");
                
                break;
                
            default:
                break;
        }
    }];
    
    [self startMonitoringNetworkReachability];
}
-(void)startMonitoringNetworkReachability
{
    //开始监控网络可达性的变化状态。
    [manager startMonitoring];
}
-(void)stopMonitoringNetworkReachability
{
    //停止监控网络可达性的变化状态。
    [manager startMonitoring];
}



#pragma mark --网络监控，基于官方Reachability封装（二选一即可）--
- (void)initSystemReachability
{
    // 设置网络状态变化时的通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChanged:)name:kReachabilityChangedNotification object:nil];
    
    // 设置网络检测的站点
    NSString *remoteHostName = @"www.apple.com";
    systemReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    systemReachability = [Reachability reachabilityForInternetConnection];
    
    //开始网络监测
    [self startSystemReachability];
}
- (void)reachabilityStatusChanged:(NSNotification *)notification
{
    Reachability* curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == systemReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:   {
                NSLog(@"网络状态->不可达的网络(未连接)");
                _isHaveNetwork = NO;
                break;
            }
            case ReachableViaWWAN: {
                NSLog(@"网络状态->移动2G,3G,4G...网络");
                _isHaveNetwork = YES;

                break;
            }
            case ReachableViaWiFi: {
                NSLog(@"网络状态->wifi网络");
                _isHaveNetwork = YES;

                break;
            }
        }
    }
}
-(void)startSystemReachability
{
    //开始监控网络可达性的变化状态。
    [systemReachability startNotifier];
}
-(void)stopSystemReachability
{
    //停止监控网络可达性的变化状态。
    [systemReachability stopNotifier];
}

-(void)getCurrentNetworkStatus:(void(^)(NetworkReachabilityStatus networkStatus))status
{
    NetworkReachabilityStatus state;
    if (systemReachability != nil) {
        switch (systemReachability.currentReachabilityStatus) {
            case NotReachable:
                state = NetworkReachabilityStatus_NotReachable;
                break;
            case ReachableViaWWAN:
                state = NetworkReachabilityStatus_ReachableViaWWAN;
                break;
            case ReachableViaWiFi:
                state = NetworkReachabilityStatus_ReachableViaWiFi;
                break;
            default:
                break;
        }
        status(state);

    }else if (manager != nil){
        switch (manager.networkReachabilityStatus) {
            case AFNetworkReachabilityStatusUnknown:
                state = NetworkReachabilityStatus_Unknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                state = NetworkReachabilityStatus_NotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                state = NetworkReachabilityStatus_ReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                state = NetworkReachabilityStatus_ReachableViaWiFi;
                break;
                
            default:
                break;
        }
        status(state);
    }
//    systemReachability.stat
//    manager.networkReachabilityStatus;
}
@end


@interface TAR_Refresh()

@end
@implementation TAR_Refresh

#pragma mark //--上下刷新通用方法--
/**
 TableView上下刷新通用方法
 */
+(void)RefreshTableView:(UIScrollView *)targetView withCurrentPage:(NSInteger)currentPage WithIsDownRefresh:(BOOL)isDownRefresh isUpRefresh:(BOOL)isUpRefresh isAutoRefresh:(BOOL)isAutoRefresh withRefreshResult:(refreshResult)refreshResult
{
    switch (targetView.mj_header.state) {
        case MJRefreshStateRefreshing:
            NSLog(@"刷新正在进行中~");
            return;
            break;
        default:
            break;
    }
    __block NSUInteger pageIndex = currentPage;
    //判断是否需要下拉刷新界面
    if (isDownRefresh == YES) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSLog(@"MJRefreshHeader");
            pageIndex = 1;
            refreshResult(refreshWay_DownRefresh,pageIndex);
        }];
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        targetView.mj_header = header;
        if (isAutoRefresh == YES) {
            // 马上进入下拉刷新状态
            [targetView.mj_header beginRefreshing];
        }else{
            pageIndex = 1;
            refreshResult(refreshWay_NoRefresh,pageIndex);
        }
    }else{
        pageIndex = 1;
        refreshResult(refreshWay_NoRefresh,pageIndex);
    }
    if (isUpRefresh == YES) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            pageIndex++;
            refreshResult(refreshWay_UpRefresh, pageIndex);
        }];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        targetView.mj_footer = footer;
        
        targetView.mj_footer.hidden = YES;
    }
}
#pragma mark --上下刷新通用方法--//

+(NSMutableArray *)refreshTableView:(UIScrollView *)mainTableView totalDatas:(NSMutableArray *)totalDataArray cellDatas:(NSArray *)cellDataArray totalNumber:(NSString *)total currentPage:(NSInteger)page isDownRefresh:(BOOL)isDownRefresh
{
//    NSLog(@"isDownRefresh==%d",isDownRefresh);
//    NSLog(@"cellDataArray.count==%lu",(unsigned long)cellDataArray.count);
//    NSLog(@"totalCount==%@",total);
    if (!totalDataArray) {
        totalDataArray = [[NSMutableArray alloc]init];
    }
    NSString *totalCount;
    if ([TAR_StringToolClass isEqualPureInt:total]) {
        totalCount = [NSString stringWithFormat:@"%@",total];
    }else{
        totalCount = @"0";
    }
    NSArray *dataArray = [TAR_StringToolClass isEqualEmptyWithArray:cellDataArray]?@[]:cellDataArray;
    if (isDownRefresh == YES) {
        if (dataArray.count>0) {
            if (totalDataArray != nil) {
                [totalDataArray removeAllObjects];
            }
            totalDataArray = [[NSMutableArray alloc]initWithArray:dataArray];
            if ([totalCount intValue] <= dataArray.count) {
                if (page>1) {
                    mainTableView.mj_footer.hidden = NO;
                    [mainTableView.mj_footer endRefreshingWithNoMoreData];//已经全部加载完毕
                }else{
                    mainTableView.mj_footer.hidden = YES;
                }
            }else{
                mainTableView.mj_footer.hidden = NO;
            }
        }else{
            totalDataArray = [[NSMutableArray alloc]initWithArray:@[]];
            mainTableView.mj_footer.hidden = YES;
        }
    }else{
        if (dataArray.count>0) {
            [totalDataArray addObjectsFromArray:dataArray];
        }else{
            [mainTableView.mj_footer endRefreshingWithNoMoreData];//已经全部加载完毕
        }
    }
    return totalDataArray;
}

@end





