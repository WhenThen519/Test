//
//  ComTableViewCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/6/14.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@end
