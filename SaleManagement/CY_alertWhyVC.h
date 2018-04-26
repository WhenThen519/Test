//
//  CY_alertWhyVC.h
//  SaleManagement
//
//  Created by chaiyuan on 16/2/15.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@interface CY_alertWhyVC : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString *IntentCustId;

@end
