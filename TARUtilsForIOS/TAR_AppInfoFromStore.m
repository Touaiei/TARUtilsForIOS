//
//  TAR_AppInfoFromStore.m
//  YouJiaApp
//
//  Created by TAR on 2017/6/22.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_AppInfoFromStore.h"
#import "TAR_HttpNetworkRequestService.h"
#import "TAR_StringToolClass.h"


@interface TAR_AppInfoFromStore()
{
    TAR_HttpNetworkRequestService *httpNetworkRequestService;
    BOOL _isAutomaticUpdate;
}
@end


@implementation TAR_AppInfoFromStore
// 创建静态对象 防止外部访问
static TAR_AppInfoFromStore *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //    @synchronized (self) {
    //        // 为了防止多线程同时访问对象，造成多次分配内存空间，所以要加上线程锁
    //        if (_instance == nil) {
    //            _instance = [super allocWithZone:zone];
    //        }
    //        return _instance;
    //    }
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)sharedInstance
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    @synchronized(self){
        if(_instance == nil){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}


// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}
/*
 - (instancetype)init
 {
 @throw [NSException exceptionWithName:@"这个是个单例"
 reason:@"应该这样调用 [TAR_AppInfoFromStore sharedInstance]"
 userInfo:nil];
 return nil;
 }
 */


-(void)automaticCheckVersionUpdateWithApppID:(NSString *)appID
{
    _isAutomaticUpdate = YES;
    [self requestAppStoreInfo:appID];
}
-(void)manualCheckVersionUpdateWithApppID:(NSString *)appID
{
    _isAutomaticUpdate = NO;
    [self requestAppStoreInfo:appID];
}


/**
 获取APP AppStore的信息
 @param appID 应用程序的appID
 */
-(void)requestAppStoreInfo:(NSString *)appID;
{
    if (!httpNetworkRequestService) {
        httpNetworkRequestService = [[TAR_HttpNetworkRequestService alloc]init];
        httpNetworkRequestService.targetVC = _targetVC;
    }
    /**
     *  kAPP_URL : http://itunes.apple.com/lookup?id=
     *  kAppId : 在iTunes connect上申请的APP ID
     */
    NSString *kAPP_URL = @"http://itunes.apple.com/lookup?id=";
    //    NSString *kAppID = @"1188612954";//业主APP
    //    NSString *kAppID = @"1253298270";//员工APP
    NSString *kAppID = appID;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAPP_URL, kAppID];
    [httpNetworkRequestService httpNetRequestUpdateAppWithURL:urlStr andParams:nil andProgress:^(id uploadProgress) {
        
        
    } andSucceed:^(id responseObject) {
        NSLog(@"获取APP信息成功==%@",responseObject);
        //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        // NSData转为NSString
        //        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@", jsonStr);
        NSArray *array = responseObject[@"results"];//结果集
        NSDictionary *Dictionary = [array firstObject];
        NSString *appStoreVersion = Dictionary[@"version"];//appStore上版本号
        NSString *trackName = Dictionary[@"trackName"];//应用名
        NSString *trackViewUrl = Dictionary[@"trackViewUrl"];//应用下载地址
        
        [[NSUserDefaults standardUserDefaults] setObject:[appStoreVersion length]>0?appStoreVersion:@"" forKey:@"AppVersion_AppStore_KEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"trackName:::%@",trackName);
        NSLog(@"AppStore版本号:::%@",appStoreVersion);
        //取得当前iPhone上的APP版本号
        NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString * currentVersion = infoDict[@"CFBundleShortVersionString"];
        NSLog(@"currentVerSion:::%@",currentVersion);
        
        [self setValueWithData:@{@"appTrackId":@"",@"appTrackName":trackName,@"appTrackViewUrl":trackViewUrl,@"appTrackContentRating":@"",@"appVersion":appStoreVersion,}];
        
        [self checkVersionUpdateAlert];
    } andFail:^(id error) {
        NSLog(@"获取APP信息错误==%@",error);
    }];
}

/**
 *  @param dataDic       数据来源数组
 */
-(void)setValueWithData:(NSDictionary *)dataDic
{
    _appTrackId = [dataDic objectForKey:@"appTrackId"] ;
    _appTrackName = [dataDic objectForKey:@"appTrackName"];
    _appTrackViewUrl = [dataDic objectForKey:@"appTrackViewUrl"];
    _appTrackContentRating = [dataDic objectForKey:@"appTrackContentRating"];
    _appVersion = [dataDic objectForKey:@"appVersion"];
}


/**
 检查是否打开APP版本更新提醒（从服务器后台获取的）
 */
-(void)requestIsOpenAppVersionUpdate
{
    if (!httpNetworkRequestService) {
        httpNetworkRequestService = [[TAR_HttpNetworkRequestService alloc]init];
        httpNetworkRequestService.targetVC = _targetVC;
    }
    NSString *url = @"";
    [httpNetworkRequestService postServiceRequestWithURL:url andParams:nil andProgress:^(id uploadProgress) {
        
    } andSucceed:^(BOOL isSuccess, NSString *statusCode, NSString *errorMsg, id responseObject) {
        NSLog(@"checkAppVersionUpdateSuccess==%@",responseObject);
        
        NSDictionary *Response = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:responseObject withKey:@"Response"]?@{}:responseObject[@"Response"];
        NSString *isUpdate = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:Response withKey:@"isUpdate"]?@"":Response[@"isUpdate"];
        
        if (isSuccess) {
            BOOL isOpenUpdate;
            if ([TAR_StringToolClass isEqualPureInt:isUpdate]) {
                isOpenUpdate = [isUpdate boolValue];
            }else{
                isOpenUpdate = 0;
            }
            if (isOpenUpdate == 1) {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"IsOpenUpdateApp_KEY"];//是否打开APP更新
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"IsOpenUpdateApp_KEY"];//是否打开APP更新
            }
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            //判断两个版本是否相同
            //            [self appVersionUpdateAlertWithServerVersion:APPVersion_Native :appInfoFromStore];
        }else{
            NSLog(@"errorMsg==%@",errorMsg);
        }
    } andFail:^(id error) {
        NSLog(@"checkAppVersionUpdateError==%@",error);
    }];
}

/**
 获取是否打开APP更新提示（从服务器后台获取的）
 */
-(BOOL)getIsOpenUpdate
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"IsOpenUpdateApp_KEY"];//是否打开APP更新
}


-(void)checkVersionUpdateAlert
{
    NSString *appStoreVersion = self.appVersion;
    NSString *trackName = self.appTrackName;
    NSString *trackViewUrl = self.appTrackViewUrl;
    NSString *nativeVersion = APPVersion_Native;
    NSLog(@"appStoreVersion==%@",appStoreVersion);
    NSLog(@"nativeVersion==%@",nativeVersion);
    
    BOOL asdf = [self getIsOpenUpdate];
    if (asdf != YES) {
        return;
    }
    if ([TAR_StringToolClass compareVesionWithServerVersion:appStoreVersion nativeVesion:nativeVersion]) {
        NSString *titleStr = [NSString stringWithFormat:@"%@ 提示您：", trackName];
        NSString *messageStr = [NSString stringWithFormat:@"发现新版本（%@）是否更新?", appStoreVersion];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlertA = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *updateAlertA = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //点击”升级“按钮，就从打开app store上应用的详情页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
        }];
        [alertC addAction:cancelAlertA];
        [alertC addAction:updateAlertA];
        [_targetVC presentViewController:alertC animated:YES completion:nil];
    }else{
        if (_isAutomaticUpdate) {
            
        }else{
            NSString *titleStr = [NSString stringWithFormat:@"%@ 提示您：", trackName];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titleStr message:@"暂无新版本！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAlertA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:cancelAlertA];
            [_targetVC presentViewController:alertC animated:YES completion:nil];
        }
    }
}





@end
