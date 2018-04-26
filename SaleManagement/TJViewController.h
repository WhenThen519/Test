//
//  TJViewController.h
//  SaleManagement
//
//  Created by chaiyuan on 16/5/9.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@interface TJViewController : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString *titleStr;//标题

@end
