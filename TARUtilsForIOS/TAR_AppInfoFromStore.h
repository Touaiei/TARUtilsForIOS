//
//  TAR_AppInfoFromStore.h
//  YouJiaApp
//
//  Created by TAR on 2017/6/22.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAR_AppInfoFromStore : NSObject

@property(nonatomic, copy)NSString *appTrackId;
@property(nonatomic, copy)NSString *appTrackName;
@property(nonatomic, copy)NSString *appTrackViewUrl;
@property(nonatomic, copy)NSString *appTrackContentRating;
@property(nonatomic, copy)NSString *appVersion;

-(void)setModelDataWithArray:(NSDictionary *)dataDic;

@end
