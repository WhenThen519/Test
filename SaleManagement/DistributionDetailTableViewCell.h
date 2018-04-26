//
//  DistributionTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DistributionDetailTableViewCell : UITableViewCell
@property(assign,nonatomic)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
-(void)change;
@end
