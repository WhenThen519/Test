//
//  PingdiaoListCell.m
//  SaleManagement
//
//  Created by feixiang on 16/4/12.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "PingdiaoListCell.h"

@implementation PingdiaoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//全部带走
- (IBAction)all:(id)sender {
    self.ccBlock(@"1");

}
//只带自签
- (IBAction)some:(id)sender {
    self.ccBlock(@"2");

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
