//
//  QZ_MXView.h
//  SaleManagement
//
//  Created by chaiyuan on 16/7/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QZ_MXView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myRootTabel;//区总和总监
@property (nonatomic,strong)NSMutableArray *myRootArr;

@property (nonatomic,strong)NSMutableArray *selectBtArr;

@property (nonatomic,strong)NSMutableArray* boolArr;//是否收缩，yes为展开，no为收缩

@property (nonatomic,strong)NSMutableDictionary *QZrequestDic;
@property (nonatomic,strong)UITableView *myJLRootTabel;//经理的table

@end
