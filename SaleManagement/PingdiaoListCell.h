//
//  PingdiaoListCell.h
//  SaleManagement
//
//  Created by feixiang on 16/4/12.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanChose)(NSString *) ;

@interface PingdiaoListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *salerName_L;
@property (weak, nonatomic) IBOutlet UILabel *content_L;
@property (weak, nonatomic) IBOutlet UILabel *zqkh_L;
@property (weak, nonatomic) IBOutlet UILabel *fpkh_L;
@property (weak, nonatomic) IBOutlet UILabel *bhkh_L;
@property(nonatomic,copy)chuanChose ccBlock;

@end
