//
//  AssessmentStandardView.h
//  SaleManagement
//
//  Created by 飞翔 on 2017/10/16.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssessmentStandardView : UIView<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (copy, nonatomic)  NSString *web_url;
-(void)loadUrl;
@end
