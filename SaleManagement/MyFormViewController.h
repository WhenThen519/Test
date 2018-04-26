//
//  MyFormViewController.h
//  victor_server_template
//
//  Created by feixiang on 14-7-16.
//  Copyright (c) 2014年 huangsm. All rights reserved.
//
#import "Fx_RootViewController.h"

@interface MyFormViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSString *custId;
@property(nonatomic,copy) NSString *custName;

@end
