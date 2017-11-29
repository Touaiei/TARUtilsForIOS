//
//  TARBaseWebViewController.m
//  YouJiaApp
//
//  Created by TAR on 2017/1/5.
//  Copyright © 2017年 TAR. All rights reserved.
//
/*
 共用Web页面VC
 */

#import "TARBaseWebViewController.h"
#import "TARWebPageProgressBar.h"
#import "TAR_StringToolClass.h"
#import "TARToolsClass_UpdateAppVersion.h"

@interface TARBaseWebViewController ()
<
WKNavigationDelegate,
WKUIDelegate,
WKScriptMessageHandler
>
{
    CGFloat mainWebView_Y;
    NSArray *OCMethodNameArray;
    WKNavigation *backNavigationIdentifier;
}
@property(nonatomic, strong)WKWebView *mainWebView;
@property(nonatomic, strong)NSURL *homeURL;
@property(nonatomic, strong)NSURL *currentPageURL;//当前页的地址
@property(nonatomic,strong)UIBarButtonItem *navLeftReturnButtonItem;
@property(nonatomic,strong)UIBarButtonItem *navLeftCloseButtonItem;
//@property(nonatomic,strong)UIProgressView *webProgressView;
@property(nonatomic,strong)TARWebPageProgressBar *webProgressView;


@property(nonatomic,strong)UIButton *navLeftReturnButton2;
@property(nonatomic,strong)UIWindow *mainKeyWindow;

@end

@implementation TARBaseWebViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObservers];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserver];
    [_webProgressView removeFromSuperview];
    [_navLeftReturnButton2 removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initNav];
    [self initUI];
}
-(void)dealloc
{
    NSLog(@"dealloc");
}
-(void)initNav
{
    switch (_pageJumpWay) {
        case pageJumpWay_modal:
            [self initNavBarModal];
            break;
        case pageJumpWay_push:
            [self initNavBarPush];
            break;
        default:
            break;
    }
}
#pragma mark --初始化导航栏View--
-(void)initNavBarPush
{ 
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    /*返回按钮*/
    UIButton *navLeftReturnButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Macro_NavBarBackButton_Size.width, Macro_NavBarBackButton_Size.height)];
    [navLeftReturnButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [navLeftReturnButton setImage:Macro_NavBarBackButtonImageWhite forState:UIControlStateNormal];
    navLeftReturnButton.tag = 100;
    [navLeftReturnButton addTarget:self action:@selector(baseNavLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _navLeftReturnButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navLeftReturnButton];
    /*关闭按钮*/
    UIButton *navLeftCloseButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(navLeftReturnButton.frame)+0, 0, 35, 35)];
    //    [navLeftCloseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [navLeftCloseButton setTitle:@"ㄨ" forState:UIControlStateNormal];
    [navLeftCloseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    navLeftCloseButton.titleLabel.font = [UIFont systemFontOfSize:22];
    navLeftCloseButton.tag = 200;
    [navLeftCloseButton addTarget:self action:@selector(baseNavLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _navLeftCloseButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navLeftCloseButton];
    self.navigationItem.leftBarButtonItems = @[_navLeftReturnButtonItem];

    /*右边按钮_关注*/
    /*
    UIButton *_rightButton_Attention = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Macro_NavBarRightButton_Size.width, Macro_NavBarRightButton_Size.height)];
    _rightButton_Attention.tag = 100;
    [_rightButton_Attention setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_rightButton_Attention setImage:[UIImage imageNamed:@"service_drop_down_ic"] forState:UIControlStateNormal];
    [_rightButton_Attention addTarget:self action:@selector(navRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem_Attention = [[UIBarButtonItem alloc]initWithCustomView:_rightButton_Attention];
    [self.navigationItem setRightBarButtonItems:@[rightItem_Attention] animated:YES];
    */
    
    [self initProgressBar];
}
#pragma mark --初始化modal跳转导航栏View--
-(void)initNavBarModal
{
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    [self.view addSubview:navBarView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 20, 100, 44);
    //    backButton.backgroundColor = [UIColor grayColor];
    [backButton setTitle:@"返回注册" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClickModal:) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, navBarView.frame.size.width, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"阅读用户协议";
    [navBarView addSubview:titleLabel];
    
}
#pragma mark --初始化网页加载进度条View--
-(void)initProgressBar
{
    if (!_webProgressView) {
        _webProgressView = [[TARWebPageProgressBar alloc]initWithFrame:CGRectMake(0, 41, W_Screen, 3)];
        [_webProgressView setProgressViewStyle:UIProgressViewStyleDefault];
        _webProgressView.progress = 0.2;
        [_webProgressView setProgressTintColor:[UIColor blueColor]];
        [self.navigationController.navigationBar addSubview:_webProgressView];
    }
}

#pragma mark --初始UI--
-(void)initUI
{
    if (_pageJumpWay == pageJumpWay_modal) {
        mainWebView_Y = 64;
    }else if (_pageJumpWay == pageJumpWay_push){
        mainWebView_Y = 0;
    }
    if (!_mainWebView) {
        
        _mainWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, mainWebView_Y, W_mainView, H_mainView-64) configuration:[self addWebViewConfiguration]];
        _mainWebView.navigationDelegate = self;
        _mainWebView.UIDelegate = self;
        [self.view addSubview:_mainWebView];
    }
    [self loadRequestData];
}
-(WKWebViewConfiguration *)addWebViewConfiguration
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = [self addUserCC];
    return configuration;
}
-(WKUserContentController *)addUserCC
{
    WKUserContentController *userCC = [[WKUserContentController alloc]init];
    for (NSString *name in [self addOCMethodNames]) {
        [userCC addScriptMessageHandler:self name:name];
    }
    return userCC;
}

-(NSArray *)addOCMethodNames
{
    NSArray *OCMethodNames = @[@"showMobile",@"showName",@"showSendMsg",@"openMap",@"openPay",@"paySuccess",@"webBack"];
    OCMethodNameArray = OCMethodNames;
    return OCMethodNames;
}


#pragma mark --添加KVO监听--
-(void)addObservers
{
    
    [_mainWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

}
#pragma mark --移除KVO监听--
-(void)removeObserver
{
    [_mainWebView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
}
#pragma mark --加载网页请求--
-(void)loadRequestData
{
    if (![_homeURLStr hasPrefix:@"http"]) {
        _homeURLStr = [NSString stringWithFormat:@"http://%@",_homeURLStr];
    }
    _homeURL = [NSURL URLWithString:_homeURLStr];
    NSLog(@"_homeURL::%@",_homeURL);
    [_mainWebView loadRequest:[NSURLRequest requestWithURL:_homeURL]];
}
-(void)reloadHomePage
{
    [self loadRequestData];
}
#pragma mark --navBar返回按钮点击事件--
-(void)baseNavLeftButtonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            //返回按钮
            [self webViewGoBack];
            break;
        case 200:
            //关闭按钮
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            //
            break;
    }
}
-(void)webViewGoBack
{
    //如果可以返回，则返回到上一个H5页面，并在左上角添加一个关闭按钮
    if ([_mainWebView canGoBack]) {//判断当前的H5页面是否可以返回
        [_mainWebView goBack];
        self.navigationItem.leftBarButtonItems = @[_navLeftReturnButtonItem,_navLeftCloseButtonItem];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (_goBackAndReloadIsOpen == YES) {
        backNavigationIdentifier = [_mainWebView goBack];
        _goBackAndReloadIsOpen = NO;
    }
}

#pragma mark --modal返回按钮点击事件--=
-(void)backButtonClickModal:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//1. native调用js
-(void)NativeCallJSMethodWithMethodName:(NSString *)nethodName parameter:(NSDictionary *)parameter
{
    NSLog(@"nethodName==%@ \n parameter==%@",nethodName,parameter);

    NSArray *allValues = parameter.allValues;
    NSString *allValuesString = [NSString stringWithFormat:@"'%@'",[allValues componentsJoinedByString:@","]];
    NSString *JSParameters = [allValuesString isKindOfClass:[NSNull class]]?@"":allValuesString;
    NSString *JSNethodName = [nethodName isKindOfClass:[NSNull class]]?@"":nethodName;
    NSString *JSRequestScript = [NSString stringWithFormat:@"%@(%@)",JSNethodName,JSParameters];
    NSLog(@"JSRequestScript==%@",JSRequestScript);
    if (!_mainWebView.loading) {
        [_mainWebView evaluateJavaScript:JSRequestScript completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response==%@    error==%@",response,error);
        }];
    }else{
        NSLog(@"the view is currently loading content");
    }
}


#pragma mark //--WKNavigationDelegate--
#pragma mark --在发送请求之前，决定是否跳转--
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"decidePolicyForNavigationAction:");
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
    
}
#pragma mark --页面开始加载时调用--
//准备开始加载页面
/*
 WKNavigationDelegate - webView:didStartProvisionalNavigation:
 对应
 UIWebViewDelegate - webView:shouldStartLoadWithRequest:navigationType
 */
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"didStartProvisionalNavigation:");
    [self asdfasdf:[NSString stringWithFormat:@"%@",webView.URL]];

}
#pragma mark --在收到响应后，决定是否跳转--
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"decidePolicyForNavigationResponse:");
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);

}


#pragma mark --当内容开始返回时调用--
//已开始加载页面，可以在这一步向view中添加一个过渡动画
/*
 WKNavigationDelegate - webView:didCommitNavigation:
 对应
 UIWebViewDelegate - webViewDidStartLoad:
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"didCommitNavigation:");
    
    
}
#pragma mark --页面加载完成之后调用--
//页面已全部加载，可以在这一步把过渡动画去掉
/*
 WKNavigationDelegate - webView:didFinishNavigation:
 对应
 UIWebViewDelegate - webViewDidFinishLoad:
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"didFinishNavigation");
    
    [self setBaseNavTitle:_mainWebView.title];
    [self setCurrentPageURL:webView.URL];
    [self goBackRefresh:navigation];
    
}

#pragma mark --页面开始加载数据时出现错误的方法--
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailProvisionalNavigation:");
}

#pragma mark --页面加载数据过程中出现错误的方法--
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailNavigation:withError:");
}
#pragma mark -- --
//-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
//{
//    
//}

#pragma mark --接收到服务器跳转请求之后调用--
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"didReceiveServerRedirectForProvisionalNavigation:");
    
}
#pragma mark --Web内容进程终止了--
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"webViewWebContentProcessDidTerminate:");

}
#pragma mark --WKNavigationDelegate--//




#pragma mark //--WKUIDelegate--
#pragma mark --创建一个新的WebView--
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return [[WKWebView alloc]init];
}
#pragma mark ----
- (void)webViewDidClose:(WKWebView *)webView
{

    NSLog(@"webViewDidClose:");
}
#pragma mark --警告框--
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler
{
    NSLog(@"runJavaScriptAlertPanelWithMessage:");
    
    NSLog(@"message==%@",message);

    TARToolsClass_UpdateAppVersion *dd = [[TARToolsClass_UpdateAppVersion alloc]init];
    [dd alertBoxWithTitle:@"" andMessage:message];
    
    completionHandler();
    
}
#pragma mark --确认框--
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    NSLog(@"runJavaScriptConfirmPanelWithMessage:");

}

#pragma mark --输入框--
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(nonnull NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"runJavaScriptTextInputPanelWithPrompt:");

}
#pragma mark ----

//- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(nonnull WKPreviewElementInfo *)elementInfo
//{
//}
#pragma mark ----

//- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(nonnull WKPreviewElementInfo *)elementInfo defaultActions:(nonnull NSArray<id<WKPreviewActionItem>> *)previewActions
//{
//}
#pragma mark ----

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(nonnull UIViewController *)previewingViewController
{
    
}
#pragma mark --WKUIDelegate--//




#pragma mark //--WKScriptMessageHandler协议方法--
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    NSLog(@"%@",message.body);
    
    [self JSCallNativeMethodWithScriptMessage:message];
}
-(void)JSCallNativeMethodWithScriptMessage:(WKScriptMessage *)scriptMessage
{
    NSLog(@"scriptMessage.name==%@  scriptMessage.body==%@",scriptMessage.name,scriptMessage.body);

    for (NSString *OCMethodName in OCMethodNameArray) {
        if ([scriptMessage.name isEqualToString:OCMethodName]) {

            [self JSCallNativeMethodSuccessWithScriptMessage:scriptMessage];
            
            break;
        }else{
            NSLog(@"无JS要调的Native方法~!");
        }
    }
}

#pragma mark --WKScriptMessageHandler协议方法--//
-(void)showMsg:(NSString *)msg
{
    NSLog(@"showMsg:==%@",msg);
}

#pragma mark --KVO监听实现--
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"_mainWebView.estimatedProgress == %f",_mainWebView.estimatedProgress);
        if (_mainWebView.estimatedProgress>0.0 && _mainWebView.estimatedProgress<1.0) {
            _webProgressView.hidden = NO;
            [_webProgressView setProgress:_mainWebView.estimatedProgress animated:YES];
        }else{
            _webProgressView.progress = 0.2;
            _webProgressView.hidden = YES;
        }
    }
}
-(void)setGoBackAndReloadIsOpen:(BOOL)goBackAndReloadIsOpen
{
    _goBackAndReloadIsOpen = goBackAndReloadIsOpen;
}
-(void)goBackAndReload
{
    [self setGoBackAndReloadIsOpen:YES];
    [self webViewGoBack];

//    if ([_mainWebView canGoBack]) {//判断当前的H5页面是否可以返回
//    }
}
-(void)setCurrentPageURL:(NSURL *)currentPageURL
{
    _currentPageURL = currentPageURL;
}
-(void)reloadCurrentPage
{
     [_mainWebView reload];
}
-(void)goBackRefresh:(WKNavigation *)navigation
{
    if ([backNavigationIdentifier isEqual:navigation]) {
        NSLog(@"这次的加载是点击返回产生的，刷新");
        [self reloadCurrentPage];
        backNavigationIdentifier = nil;
    }
}
-(void)setBaseNavTitle:(NSString *)baseNavTitle
{
    if ([baseNavTitle length]>0) {
        _baseNavTitle = baseNavTitle;
        self.title = _baseNavTitle;
    }
}

-(void)asdfasdf:(NSString *)url
{
    // || [url isEqualToString:@"http://mini.eastday.com/"]
    NSLog(@"asdfasdf==%@",url);
    if ([url isEqualToString:@"http://toutiao.eastday.com/"]) {
//        self.navigationController.navigationBar.hidden = YES;
        [_mainWebView setOriginY: -44];
        [_mainWebView setHeight:H_Screen-20];
//        [_mainWebView setHeight:H_Screen-20];
//        [self changeNavLeftReturnButton:NO];
    }else{
//        self.navigationController.navigationBar.hidden = NO;
        [_mainWebView setOriginY: mainWebView_Y];
        [_mainWebView setHeight:H_Screen-64];
//        [self changeNavLeftReturnButton:YES];
    }
}

-(void)changeNavLeftReturnButton:(BOOL)hidden
{
    CGFloat navLeftReturnButton_H = Macro_NavBarBackButton_Size.height;
    /*返回按钮*/
     _navLeftReturnButton2 = [[UIButton alloc]initWithFrame:CGRectMake(0,  ((44-navLeftReturnButton_H)/2.0)+20 , 50, navLeftReturnButton_H)];
    _navLeftReturnButton2.userInteractionEnabled = YES;
    [_navLeftReturnButton2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_navLeftReturnButton2 setImage:Macro_NavBarBackButtonImageWhite forState:UIControlStateNormal];
    _navLeftReturnButton2.tag = 100;
    [_navLeftReturnButton2 addTarget:self action:@selector(baseNavLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    navLeftReturnButton.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:navLeftReturnButton];
    
    if (!_mainKeyWindow) {
//        _mainKeyWindow = [[UIApplication sharedApplication] keyWindow];
//        [_mainKeyWindow addSubview:_navLeftReturnButton2];
    }
        [self.view addSubview:_navLeftReturnButton2];

    _navLeftReturnButton2.hidden = NO;
//    if (hidden == YES) {
//        [_navLeftReturnButton2 removeFromSuperview];
//        _navLeftReturnButton2 = nil;
//    }else{
//        
//    }
    
}
-(void)dasfsdfds
{
    for (UIView *view in _mainKeyWindow.subviews) {
        if ([view isKindOfClass:[_navLeftReturnButton2 class]]) {
            [view removeFromSuperview];
        }
//        if ([view isMemberOfClass:[_navLeftReturnButton2 class]]) {
//            
//        }
    }
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
