//
//  TAR_HttpNetworkRequestService.h
//  JiaDuanAPP
//
//  Created by TAR on 2016/12/8.
//  Copyright © 2016年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Reachability.h"


typedef void(^dasdf)(NSString *sTime, NSString *eTime,BOOL isDownRefresh, BOOL isUpRefresh,BOOL isAutoRefresh);

typedef NS_ENUM(NSInteger,refreshWay) {
    refreshWay_NoRefresh = 1,
    refreshWay_DownRefresh = 2,
    refreshWay_UpRefresh = 3
};
typedef void(^refreshResult)(refreshWay refreshWay,NSInteger currentPage);





typedef void(^requestResponseBlock)(BOOL isSuccess, NSString *statusCode, NSString *errorMsg, id responseObject);




@interface TAR_HttpNetworkRequestService : NSObject
{
    
}
@property(nonatomic, weak)id targetVC;


/**
 POST请求，需要验证token权限才能访问
 */
-(void)postServiceRequestWithURL:(NSString *)url
                       andParams:(NSDictionary *)params
                     andProgress:(void (^)(NSProgress *uploadProgress))progre
                      andSucceed:(requestResponseBlock)succe
                         andFail:(void (^)(id error))fail;

/**
 POST请求，不需要验证token即可访问
 */
-(void)postRequestNoTokenRequestWithURL:(NSString *)url
                            andParams:(id)params
                          andProgress:(void (^)(id uploadProgress))progre
                           andSucceed:(requestResponseBlock)succe
                              andFail:(void (^)(id error))fail;


/**
 POST请求，登录时专用
 */
-(void)postRequestLoginServiceWithURL:(NSString *)url
                            andParams:(id)params
                          andProgress:(void (^)(id uploadProgress))progre
                           andSucceed:(requestResponseBlock)succe
                              andFail:(void (^)(id error))fail;

/**
 POST请求，上传图片数据请求方法，需要权限才能访问
 */
-(void)postUploadImageRequestWithImages:(NSArray *)images
                                 andURL:(NSString *)url
                              andParams:(NSDictionary *)params
               constructingBodyWithBloc:(void (^)(id formData))constructingBody
                            andProgress:(void (^)(NSProgress *uploadProgress))progre
                             andSucceed:(requestResponseBlock)succe
                                andFail:(void (^)(id error))fail;

/*
 GET请求，需要权限才能访问
 */
-(void)getRequestWithURL:(NSString *)url
               andParams:(NSDictionary *)params
             andProgress:(void (^)(id downloadProgress))progre
              andSucceed:(void (^)(id responseObject))succe
                 andFail:(void (^)(id error))fail;


/**
 POST请求，需要权限才能访问,UITableView、UICollectionView、UIScrollView 分页请求方法
 @param tableView 由于UITableView和UICollectionView都是继承自UIScrollView，所以在调用方法时统统转换成UIScrollView
 */
-(void)postRequestPagingWithTableView:(UIScrollView *)tableView
                            withDatas:(NSArray *)datas
                         withIsPaging:(BOOL)isPaging
                        withPageIndex:(NSInteger)pageIndex
                         withPageSize:(NSInteger)pageSize
                              WithURL:(NSString *)url
                            andParams:(NSDictionary *)params
                          andProgress:(void (^)(id uploadProgress))progre
                           andSucceed:(requestResponseBlock)succe
                              andFail:(void (^)(id error))fail;




-(void)httpNetRequestUpdateAppWithURL:(NSString *)url
                            andParams:(NSDictionary *)params
                          andProgress:(void (^)(id uploadProgress))progre
                           andSucceed:(void (^)(id responseObject))succe
                              andFail:(void (^)(id error))fail;;


/**
 POST请求，获取验证码专用
 */
-(void)postRequestValidationCode:(NSString *)validationCode phoneNumber:(NSString *)phoneNumber;


+(NSDictionary *)addJiaDuanToken:(NSDictionary *)params;

+(NSDictionary *)addJiaDuanSign:(NSDictionary *)params;

@end

/**
 自定义网络监控类
 */
@interface TAR_NetworkReachability : NSObject
{
    AFNetworkReachabilityManager *manager;
    Reachability *systemReachability;

}
typedef NS_ENUM(NSInteger,NetworkReachabilityStatus) {
    NetworkReachabilityStatus_Unknown = -1,
    NetworkReachabilityStatus_NotReachable = 0,
    NetworkReachabilityStatus_ReachableViaWWAN = 1,
    NetworkReachabilityStatus_ReachableViaWiFi = 2
};

@property(nonatomic, assign)BOOL isHaveNetwork;//是否有网络


+ (instancetype)sharedManager;
/**
 网络监控，基于AFNetworkReachabilityManager封装（二选一即可）
 */
-(void)initMonitoringNetworkReachability;
-(void)startMonitoringNetworkReachability;
-(void)stopMonitoringNetworkReachability;
/**
 网络监控，基于官方Reachability封装（二选一即可）
 */
-(void)initSystemReachability;
-(void)startSystemReachability;
-(void)stopSystemReachability;

/**
 获取当前网络状态blook回调
 @param status 状态回调
 */
-(void)getCurrentNetworkStatus:(void(^)(NetworkReachabilityStatus networkStatus))status;


@end

/**
 自定义公共刷新类
 */
@interface TAR_Refresh : NSObject
{
    
}
/**
 TableView刷新方法
 @param targetView 添加刷新控件的目标TableView或CollectionView（都需要转换为UIScrollView）
 @param currentPage 当前页码
 @param isDownRefresh 是否下刷新
 @param isUpRefresh 是否上刷新
 @param isAutoRefresh 是否自动刷新
 @param refreshResult 返回刷新状态结果
 */
+(void)RefreshTableView:(UIScrollView *)targetView withCurrentPage:(NSInteger)currentPage WithIsDownRefresh:(BOOL)isDownRefresh isUpRefresh:(BOOL)isUpRefresh isAutoRefresh:(BOOL)isAutoRefresh withRefreshResult:(refreshResult)refreshResult;



/**
 用于列表请求数据成功后，控制列表刷新方式（CollectionView或TableView）
 @param mainTableView （CollectionView或TableView）转换为UIScrollView
 @param cellDataArray 当前cell数据Array
 @param total 列表数据总条数
 @param page 当前分页
 @param isDownRefresh 是否是下刷方式
 @return 返回一个总cell数据数组
 */
+(NSMutableArray *)refreshTableView:(UIScrollView *)mainTableView totalDatas:(NSMutableArray *)totalDataArray cellDatas:(NSArray *)cellDataArray totalNumber:(NSString *)total currentPage:(NSInteger)page isDownRefresh:(BOOL)isDownRefresh;
@end

