//
//  TARWebPageProgressBar.m
//  YouJiaApp
//
//  Created by TAR on 2017/3/8.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TARWebPageProgressBar.h"

@implementation TARWebPageProgressBar
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)initialize
{
    if (self == [self class]) {
//        NSLog(@"initialize");
    }
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSLog(@"init");
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSLog(@"initWithFrame");
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        NSLog(@"initWithCoder");
    }
    return self;
}





@end
