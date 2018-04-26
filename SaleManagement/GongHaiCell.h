//
//  GongHaiCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/3/3.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GongHaiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *tImage;

@property (weak, nonatomic) IBOutlet UIButton *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *bt1;

@property (weak, nonatomic) IBOutlet UIButton *bt2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellW;


@end
