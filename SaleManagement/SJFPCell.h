//
//  GonghaiTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(NSDictionary *) ;

@interface SJFPCell : UITableViewCell

@property(assign,nonatomic)BOOL isSelect;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addL;
@property(nonatomic,copy)chuanzhi czBlock;

@end
