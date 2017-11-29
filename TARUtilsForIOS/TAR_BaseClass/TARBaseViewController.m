//
//  TARBaseViewController.m
//  JiaDuanAPP
//
//  Created by TAR on 2016/12/14.
//  Copyright © 2016年 TAR. All rights reserved.
//

#import "TARBaseViewController.h"
#import "TAR_NavBarView.h"


@interface TARBaseViewController ()
{
    TAR_NavBarView *alphaView;
}
@end

@implementation TARBaseViewController
-(void)viewWillAppear:(BOOL)animated
{
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"navigationBarSubviews===%@",[[alphaView superview] subviews]);
    NSLog(@"navigationControllers===%@",self.navigationController.viewControllers);
    if (self.navigationController.viewControllers.count <= 1) {
        for (UIView *tempView in [[alphaView superview] subviews]) {
            NSLog(@"tempView==%@",tempView);
            if ([tempView isKindOfClass:[TAR_NavBarView class]]) {
                [tempView removeFromSuperview];
            }
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavs];

}

-(void)initNavs
{
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    float alpha = 1.0; // 初始化透明度
    CGRect frame = self.navigationController.navigationBar.frame;
    alphaView = [[TAR_NavBarView alloc] initWithFrame:CGRectMake(0, -20, frame.size.width, frame.size.height+20)];
    //    alphaView.backgroundColor = Color_NavBar;
    alphaView.userInteractionEnabled = NO;
    alphaView.leftButton.hidden = NO;
    alphaView.alpha = alpha;
//    alphaView.titleLabel.text = @"物业";
    [self.navigationController.navigationBar insertSubview: alphaView atIndex:0];
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.view endEditing:YES];//使当前视图或任何子视图,放弃第一响应者（关闭键盘）
}













/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
