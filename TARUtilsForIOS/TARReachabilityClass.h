//
//  TARReachabilityClass.h
//  LLG
//
//  Created by GL on 16/11/2.
//  Copyright © 2016年 beijiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
//@class Reachability;


@interface TARReachabilityClass : NSObject<UIAlertViewDelegate>
{
    NSString *returnState;
    Reachability  *_reachability;
    
}
-(void)currentNetworkState;
-(NSString *)checkNetworkState;
-(void)realTimeNetworkStatus;


@end
