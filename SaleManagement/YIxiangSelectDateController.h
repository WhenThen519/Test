//
//  YIxiangSelectDateController.h
//  SaleManagement
//
//  Created by feixiang on 2017/8/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"
typedef void (^chuanzhi)(NSDictionary *) ;
@interface YIxiangSelectDateController : Fx_RootViewController
@property(nonatomic,copy)chuanzhi czDicBlock;

@end
