//
//  PFSelectViewController.h
//  SaleManagement
//
//  Created by cat on 2017/9/4.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

typedef void (^pf_Data)(NSDictionary *) ;

@interface PFSelectViewController : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,copy)pf_Data pf_Block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *table_Height;

@end
