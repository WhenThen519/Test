//
//  GonghaiTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YixiangViewController.h"
@interface YixiangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *xin;
@property (weak, nonatomic) IBOutlet UIButton *jianBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnImageSelect;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addL;
@property (assign, nonatomic) int nono;

@property (weak, nonatomic) IBOutlet UILabel *qian_Label;
@property (weak, nonatomic) IBOutlet UILabel *orderId_L;
@property (weak, nonatomic)  YixiangViewController *delegate_my;




@end
