//
//  GonghaiTableViewCell.m
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "YixiangTableViewCell.h"

@implementation YixiangTableViewCell


- (IBAction)jianClicked:(id)sender {
    
}
- (IBAction)selectClicked:(id)sender {
    [self.delegate_my selectDo:_nono];
    NSLog(@"%ld-----",_nono);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
