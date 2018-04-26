//
//  YuanGongCountTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/31.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuanGongCountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *shoucangjia;
@property (weak, nonatomic) IBOutlet UILabel *baohugenjin;
@property (weak, nonatomic) IBOutlet UILabel *yixiangkehu;
@property (weak, nonatomic) IBOutlet UILabel *wangzhanqianyue;
@property (weak, nonatomic) IBOutlet UILabel *qitaqianyue;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
