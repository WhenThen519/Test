//
//  AssessmentStandardView.m
//  SaleManagement
//
//  Created by 飞翔 on 2017/10/16.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "AssessmentStandardView.h"

@implementation AssessmentStandardView
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    _mainView.layer.cornerRadius = 8.;
    _mainView.layer.masksToBounds = YES;
    _mainView.clipsToBounds = NO;
    _top.constant = IOS7_Height;
    self.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
}
-(void)loadUrl
{
    if (_web_url.length) {
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_web_url]]];
        
    }
    else
        
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [ToolList showRequestFaileMessageLongTime:@"数据加载中"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [[mainWindow viewWithTag:8888] removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [ToolList showRequestFaileMessageLittleTime:@"数据加载失败"];
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [[mainWindow viewWithTag:8888] removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
