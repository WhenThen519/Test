//
//  AlertWhyViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/27.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
@interface AlertWhyViewController :Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>
-(void)startTable:(NSArray *)data;
@property(nonatomic,copy)NSString *IntentCustId;
@property(nonatomic,assign)BOOL isNeedOther;

@end
