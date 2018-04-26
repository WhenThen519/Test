//
//  GonghaiTableViewCell.m
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "GonghaiTableViewCell.h"

@implementation GonghaiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)selectBtnClicked:(id)sender {
    _isSelect = !_isSelect;
    if(_isSelect)
    {
        [_selectBtn setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_selectBtn setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];
    }
    NSDictionary *dic = @{@"index":[NSNumber numberWithLong: _selectBtn.tag],@"isSelect":[NSNumber numberWithBool:_isSelect]};
    self.czBlock(dic);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
