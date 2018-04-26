//
//  GonghaiTableViewCell.h
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(NSDictionary *) ;

@interface New_ShouCangCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *tui;
@property (weak, nonatomic) IBOutlet UIButton *guan;
@property (weak, nonatomic) IBOutlet UIButton *xin;
@property(assign,nonatomic)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UILabel *addl2;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *addL;
@property(nonatomic,copy)chuanzhi czBlock;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn1;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn2;

@property (weak, nonatomic) IBOutlet UIView *telView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telH;

@end
