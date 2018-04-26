//
//  ScheduleDetailViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/4/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.H"

@interface ScheduleDetailViewController : Fx_RootViewController
@property (weak, nonatomic) IBOutlet UILabel *guoqi;
@property (weak, nonatomic) IBOutlet UILabel *title_L;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *tixing;
@property (weak, nonatomic) IBOutlet UILabel *guanlian;
@property (weak, nonatomic) IBOutlet UILabel *beizhu;
@property(retain,nonatomic) NSDictionary *dataDic;
@end
