//
//  AlertShow.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "AlertShow.h"

@interface AlertShow ()
{
    UIWebView *web;
}
@end

@implementation AlertShow

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
    [self addNavgationbar:_noticeTitle leftImageName:@"btn_close_popup.png" rightImageName:nil target:self leftBtnAction:@"goBack" rightBtnAction:nil leftHiden:NO rightHiden:YES];
    self.view.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-40)];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_noticeUrl]]];
    web.delegate = self;
    web.backgroundColor = [UIColor whiteColor]; 
    [self.view addSubview:web];

   if(!_fromMe)
   {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, __MainScreen_Height-41, __MainScreen_Width, 41);
    btn.backgroundColor = [ToolList getColor:@"999999"];
    [btn addTarget:self action:@selector(know) forControlEvents:UIControlEventTouchUpInside];
       [btn setTitleColor:[ToolList getColor:@"ff7081"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
   }
    else
    {
        web.frame = CGRectMake(0,IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height);
    }
    // Do any additional setup after loading the view.
}
-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)know
{
    NSMutableDictionary *dicc = [NSMutableDictionary dictionaryWithObject:_noticeId forKey:@"noticeId"];
    [FX_UrlRequestManager postByUrlStr:signNotice_url andPramas:dicc andDelegate:self andSuccess:@"ConnectSuccess:" andFaild:nil andIsNeedCookies:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)ConnectSuccess:(NSDictionary *)dic
{
    NSLog(@"%@",dic);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[request URL ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) )
    {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL  ];
    }
    return YES;
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
