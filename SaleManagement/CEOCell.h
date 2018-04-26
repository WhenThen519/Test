//
//  CY_moneyCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/11.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEOCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NO_L;
@property (weak, nonatomic) IBOutlet UILabel *shiti;
@property (weak, nonatomic) IBOutlet UILabel *ti;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyW;


@end
