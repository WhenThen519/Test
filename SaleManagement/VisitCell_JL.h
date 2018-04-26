//
//  VisitCell.h
//  SaleManagement
//
//  Created by feixiang on 2017/7/20.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(NSString *) ;

@interface VisitCell_JL : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *dhf;
@property (weak, nonatomic) IBOutlet UILabel *yxhf;
@property (weak, nonatomic) IBOutlet UILabel *af;
@property(nonatomic,copy)chuanzhi czStrBlock;

@end
