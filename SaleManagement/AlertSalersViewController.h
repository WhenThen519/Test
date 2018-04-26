//
//  AlertSalersViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/28.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.H"

typedef void (^SelectSalerOk)(NSString * salerId);

@interface AlertSalersViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)SelectSalerOk selectOKBlock;
@end
