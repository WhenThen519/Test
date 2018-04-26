//
//  peiYuKuViewController.h
//  SaleManagement
//
//  Created by known on 16/7/19.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface peiYuKuViewController : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
 //意向单号
@property (nonatomic,strong) NSString *orderId;

@end
