//
//  ZJProductionVc.h
//  SaleManagement
//
//  Created by chaiyuan on 16/3/29.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@interface ZJProductionVc : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *zjcustName;
@property (nonatomic,strong)NSString *zjcustId;

@end
