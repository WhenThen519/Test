//
//  AlertShow.h
//  SaleManagement
//
//  Created by feixiang on 2017/3/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "ViewController.h"
#import "Fx_RootViewController.h"

@interface AlertShow : Fx_RootViewController<UIWebViewDelegate>
@property(nonatomic,copy)NSString * noticeId;
@property(nonatomic,copy)NSString * noticeUrl;
@property(nonatomic,assign)BOOL fromMe;
@property(nonatomic,copy)NSString * noticeTitle;


@end
