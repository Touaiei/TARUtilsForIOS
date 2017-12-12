//
//  TAR_AppInfoFromStore.h
//  YouJiaApp
//
//  Created by TAR on 2017/6/22.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAR_AppInfoFromStore : NSObject

/**AppStore的信息*/
@property(nonatomic, copy)NSString *appTrackId;
@property(nonatomic, copy)NSString *appTrackName;
@property(nonatomic, copy)NSString *appTrackViewUrl;
@property(nonatomic, copy)NSString *appTrackContentRating;
@property(nonatomic, copy)NSString *appVersion;
/*AppStore的信息**/

@property(nonatomic, weak)id targetVC;


@property(nonatomic, assign)BOOL isOpenUpdate;//是否打开App更新提醒（这是后台配置的，如果为YES则正常提醒，如果为NO则不提醒）


+(instancetype)sharedInstance;

/**
 检查是否打开APP版本更新提醒（从服务器后台获取的）
 */
-(void)requestIsOpenAppVersionUpdate;

/**
 自动检查更新（无更新时不会弹出提示框）
 */
-(void)automaticCheckVersionUpdateWithApppID:(NSString *)appID;
/**
 手动检查更新（有无更新都会弹出提示框）
 */
-(void)manualCheckVersionUpdateWithApppID:(NSString *)appID;





@end


