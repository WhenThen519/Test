//
//  AppDelegate.h
//  SaleManagement
//
//  Created by feixiang on 15/11/19.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#import <UIKit/UIKit.h>
//自己测试key
//static NSString *appKey = @"d4e28c3d552e1a5ad7af203f";
//郭强key
static NSString *appKey = @"4b561e5ad9b78952bcbcee7d";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *windowUrl;
@end

