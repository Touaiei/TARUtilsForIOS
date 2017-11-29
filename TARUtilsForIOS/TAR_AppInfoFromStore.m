//
//  TAR_AppInfoFromStore.m
//  YouJiaApp
//
//  Created by TAR on 2017/6/22.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TAR_AppInfoFromStore.h"

@implementation TAR_AppInfoFromStore


/**
 *  @param dataArray       数据来源数组
 *  @return 返回数据模型结果
 */
-(void)setModelDataWithArray:(NSDictionary *)dataDic
{
    
    _appTrackId = [dataDic objectForKey:@"appTrackId"] ;
    _appTrackName = [dataDic objectForKey:@"appTrackName"];
    _appTrackViewUrl = [dataDic objectForKey:@"appTrackViewUrl"];
    _appTrackContentRating = [dataDic objectForKey:@"appTrackContentRating"];
    _appVersion = [dataDic objectForKey:@"appVersion"];
    
    
//    NSMutableArray *modelsArray = [[NSMutableArray alloc]init];
//    for (NSDictionary *dic in dataArray) {
//        PropertyWeatherViewModel *model = [PropertyWeatherViewModel new];
//        
//        model.temperatureValue = [TAR_StringToolClass isEqualEmptyFromSingleLayerWithDictionary:dic withKey:@"temperatureValue"]?@"":[NSString stringWithFormat:@"%@",dic[@"temperatureValue"]];
//        
//        [modelsArray addObject:model];
//        //        NSLog(@"model===%@  %@  %@  %@",model.redEnvelopeEarningsRankStr,model.nameStr,model.moneyNumberStr,model.RankStr);
//    }
//    NSLog(@"modelsArray===>%@",modelsArray);
//    return modelsArray;
    
    


}


@end
