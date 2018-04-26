//
//  Visit.h
//  SaleManagement
//
//  Created by feixiang on 2017/7/20.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface Visit : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *deptId;
@property(nonatomic,copy)NSString *requestU;
@property(nonatomic,copy)NSString *businessYear;
@property(nonatomic,copy)NSString *businessMonth;
@end
