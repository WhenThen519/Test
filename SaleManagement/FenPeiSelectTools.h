//
//  FenPeiSelectTools.h
//  SaleManagement
//
//  Created by feixiang on 2017/8/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface FenPeiSelectTools : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSArray *data;
@property(nonatomic,assign)BOOL all;
@property(nonatomic,copy)NSString *custId;

@end
