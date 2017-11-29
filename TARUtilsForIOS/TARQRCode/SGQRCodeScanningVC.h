//
//  SGQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by apple on 17/3/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGQRCodeScanningVCDelegate <NSObject>

-(void)ScanCompleteJumpProtocol:(NSString *)scanResult;

@end

@interface SGQRCodeScanningVC : UIViewController

@property(nonatomic, weak)id<SGQRCodeScanningVCDelegate> delegate;


@end
