//
//  YixiangViewController.h
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface YixiangViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
-(void)selectDo:(int)flagInt;
@end
