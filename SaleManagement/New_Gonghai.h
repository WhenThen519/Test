//
//  New_Gonghai.h
//  SaleManagement
//
//  Created by feixiang on 2017/2/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface New_Gonghai : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectALLBtn;
@property (assign, nonatomic)  BOOL isS;

@end