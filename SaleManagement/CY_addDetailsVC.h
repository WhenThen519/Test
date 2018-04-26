//
//  CY_addDetailsVC.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/28.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@interface CY_addDetailsVC : Fx_RootViewController

@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property(nonatomic,strong)NSString *custNameStr;

@property (nonatomic,assign)BOOL isChang;//0代表从详情的联系人进入，1代表从常用联系人进入
@end
