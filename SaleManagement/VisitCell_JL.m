//
//  VisitCell.m
//  SaleManagement
//
//  Created by feixiang on 2017/7/20.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "VisitCell_JL.h"

@implementation VisitCell_JL

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickedBtn:(id)sender {
    UIButton *btn = sender;
    NSString *s = [NSString stringWithFormat:@"%ld",btn.tag];
    self.czStrBlock(s);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
