//
//  TARBaseUIViewController.m
//  YouJiaApp
//
//  Created by TAR on 2017/9/8.
//  Copyright © 2017年 TAR. All rights reserved.
//

#import "TARBaseUIViewController.h"

@interface TARBaseUIViewController ()<UIGestureRecognizerDelegate>
{
    
}
@property(nonatomic,strong)UIButton *navLeftBackButton;
@end

@implementation TARBaseUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self initMainNavBar];
    [self addRightSlidingBackGesture];
}

#pragma mark --初始化导航栏--
-(void)initMainNavBar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /*返回按钮*/
    _navLeftBackButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Macro_NavBarBackButton_Size.width, Macro_NavBarBackButton_Size.height)];
    [_navLeftBackButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_navLeftBackButton setImage:Macro_NavBarBackButtonImageWhite forState:UIControlStateNormal];
    _navLeftBackButton.tag = 100;
    [_navLeftBackButton addTarget:self action:@selector(navLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *navLeftBackButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_navLeftBackButton];
    self.navigationItem.leftBarButtonItems = @[navLeftBackButtonItem];
}
-(void)navLeftButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addRightSlidingBackGesture

{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self.navigationController.viewControllers count] == 1) {
        return NO;
    }else{
        return YES;
    }
}


#pragma amrk --setter--
-(void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    self.title = _navTitle;
}
-(void)setNavTitleColor:(UIColor *)navTitleColor
{
    _navTitleColor = navTitleColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:_navTitleColor}];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
