//
//  DistributionTableViewCell.m
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "ZJ_DistributionTableViewCell.h"

@implementation ZJ_DistributionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)selectBtnClicked:(id)sender {
    _isSelect = !_isSelect;
    if(_isSelect)
    {
        [_selectBtn setImage:[UIImage imageNamed:@"btn_duoxuan_s.png"] forState:UIControlStateNormal];
    }
    else
    {
       [_selectBtn setImage:[UIImage imageNamed:@"btn_duoxuan.png"] forState:UIControlStateNormal]; 
    }
    NSDictionary *dic = @{@"index":[NSNumber numberWithLong: _selectBtn.tag],@"isSelect":[NSNumber numberWithBool:_isSelect]};
    self.czBlock(dic);
}

@end
