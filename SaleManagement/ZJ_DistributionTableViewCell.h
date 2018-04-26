//
//  DistributionTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(NSDictionary *) ;
@interface ZJ_DistributionTableViewCell : UITableViewCell
@property(assign,nonatomic)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelother;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property(nonatomic,copy)chuanzhi czBlock;

@end
