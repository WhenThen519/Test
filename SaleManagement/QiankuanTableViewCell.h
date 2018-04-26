//
//  InProductionTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/28.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiankuanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *custName;
@property (weak, nonatomic) IBOutlet UILabel *other1Label;

@property (weak, nonatomic) IBOutlet UILabel *orderInstanceCode;
@property (weak, nonatomic) IBOutlet UILabel *other2Label;

@end
