//
//  DepTableViewCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/6/15.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyW;

@end
