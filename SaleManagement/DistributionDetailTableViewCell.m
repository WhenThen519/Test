//
//  DistributionTableViewCell.m
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "DistributionDetailTableViewCell.h"

@implementation DistributionDetailTableViewCell
-(void)change
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        
        self.nameL.textColor = [ToolList getColor:@"5647b6"];
        self.nameL.font = [UIFont boldSystemFontOfSize:17];
        self.flagImage.hidden = NO;
    }
    else
    {
        self.nameL.font = [UIFont systemFontOfSize:17];
        self.nameL.textColor = [ToolList getColor:@"333333"];
        self.flagImage.hidden = YES;
    }
    // Configure the view for the selected state
}


@end
