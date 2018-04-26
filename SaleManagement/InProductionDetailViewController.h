//
//  InProductionDetailViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/2/2.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.H"

@interface InProductionDetailViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *orderInstanceCode;
@end
