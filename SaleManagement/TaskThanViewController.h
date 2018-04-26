//
//  TaskThanViewController.h
//  SaleManagement
//
//  Created by known on 16/6/14.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface TaskThanViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * table;
    UIView *duanBlackView;
    UIButton * Select_Btn;

}
@property (nonatomic,strong)NSMutableDictionary *requestDic;
@property (nonatomic,strong)NSMutableArray *tableArr;
@property (nonatomic,strong)NSMutableArray *jieduanButtonArr;

@end
