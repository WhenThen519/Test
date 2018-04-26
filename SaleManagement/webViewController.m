//
//  webViewController.m
//  SaleManagement
//
//  Created by known on 2016/12/6.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "webViewController.h"

@interface webViewController ()
{
    UIWebView * webView;
    NSString *str1;
    NSString * str;
}
@end

@implementation webViewController
-(void)back
{
    if([str1 isEqualToString:str])
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
    [webView goBack];
    }
    
}
-(void)close
{
   
        [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self addNavgationbar:@"案例库" leftImageName:nil rightImageName:nil target:self leftBtnAction:@"back" rightBtnAction:nil leftHiden:NO rightHiden:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(44, IOS7_StaticHeight, 44, 44);
    btn.contentMode = UIViewContentModeLeft;
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"btn_close_popup.png"] forState:UIControlStateNormal];
    [self.headview addSubview:btn];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    str = @"http://m.300.cn/mobile_case/";
    webView.scalesPageToFit = YES;

    NSURL * url = [NSURL URLWithString:str];
    //请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    //加载请求
    [webView loadRequest:request];
[ToolList showRequestFaileMessageLongTime:@"数据加载中..."];
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    str1 = request.URL.absoluteString;
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [[mainWindow viewWithTag:8888] removeFromSuperview];
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
