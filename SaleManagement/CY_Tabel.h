//
//  CY_Tabel.h
//  SaleManagement
//
//  Created by chaiyuan on 15/12/22.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GongHaiVC.h"

@interface CY_Tabel : UITableViewController<UITableViewDelegate>

@property(nonatomic,strong)NSArray *arr;

@property(nonatomic,strong)NSMutableArray *custArr;//扫名片添加客户传送custid、custname

@property (nonatomic, assign)NSInteger openIndexC;

@property (nonatomic,assign)id<GongHaiDelegate>delegate;


@property (nonatomic,strong)NSMutableArray *siTypeArr;
@property (nonatomic,strong)NSString *SintentCustId;

@end
