//
//  ScheduleListCell.h
//  SaleManagement
//
//  Created by feixiang on 16/4/5.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dian;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
