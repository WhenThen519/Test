//
//  GonghaiTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(NSDictionary *) ;

@interface GonghaiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *guan;
@property(assign,nonatomic)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *tui;
@property (weak, nonatomic) IBOutlet UILabel *addl2;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *xin;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addL;
@property(nonatomic,copy)chuanzhi czBlock;

@end
