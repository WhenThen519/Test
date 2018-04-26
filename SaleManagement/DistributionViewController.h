//
//  DistributionViewController.h
//  SaleManagement
//
//  Created by feixiang on 15/12/29.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface DistributionViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *gr_Btn;
@property (weak, nonatomic) IBOutlet UIButton *bm_btn;
@property (weak, nonatomic) IBOutlet UILabel *date_L;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topX;


@end
