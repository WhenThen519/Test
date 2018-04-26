//
//  InProductionViewController.h
//  SaleManagement
//
//  Created by feixiang on 15/12/28.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "JingxianjinDetailViewController.h"
#import "Fx_RootViewController.h"
#import "PullDownMenu.h"

@interface JingxianjinDetailViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,PullDownMenuDelegate>
@property(nonatomic,copy)NSString *salerId;

-(void)getData2;
@end
