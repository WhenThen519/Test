//
//  OnlyShow.h
//  SaleManagement
//
//  Created by feixiang on 2017/3/4.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface OnlyShow : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic)  NSString *title_Show;
@property (retain, nonatomic)  NSArray *dataArr;

@end
