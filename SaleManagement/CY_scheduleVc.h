//
//  CY_scheduleVc.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/12.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@interface CY_scheduleVc : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSString *pageCode ;

@end
