//
//  promptVc.h
//  SaleManagement
//
//  Created by chaiyuan on 2017/3/1.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
#import "promptVcTableViewCell.h"

@interface promptVc : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic,strong)NSMutableArray *sectionArray;
@property (nonatomic,strong)NSMutableArray *flagArray;
@property (nonatomic,strong)UITableView *tableView;
@end
