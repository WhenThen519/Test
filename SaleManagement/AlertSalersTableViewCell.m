//
//  AlertSalersTableViewCell.m
//  SaleManagement
//
//  Created by feixiang on 16/1/28.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "AlertSalersTableViewCell.h"

@implementation AlertSalersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if(selected)
    {
        self.iamge.hidden = NO;
        self.name.textColor = [ToolList getColor:@"6052ba"];
    }
    else
    {
        self.iamge.hidden = YES;
        self.name.textColor = [ToolList getColor:@"333333"];
    }}

@end
