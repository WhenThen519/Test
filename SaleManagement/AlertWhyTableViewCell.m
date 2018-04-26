//
//  AlertWhyTableViewCell.m
//  SaleManagement
//
//  Created by feixiang on 16/1/27.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "AlertWhyTableViewCell.h"

@implementation AlertWhyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   if(selected)
   {
       self.rnmImage_L.hidden = NO;
       self.content_L.textColor = [ToolList getColor:@"6052ba"];
   }
    else
    {
        self.rnmImage_L.hidden = YES;
        self.content_L.textColor = [ToolList getColor:@"333333"];
    }
    // Configure the view for the selected state
}

@end
