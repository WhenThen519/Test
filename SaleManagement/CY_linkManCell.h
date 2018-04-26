//
//  CY_linkManCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/26.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CY_linkManCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *telL;

@property (weak, nonatomic) IBOutlet UIButton *telB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameW;
@property (weak, nonatomic) IBOutlet UIImageView *changImage;


@end
