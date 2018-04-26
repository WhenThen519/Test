//
//  renWuViewController.h
//  SaleManagement
//
//  Created by known on 16/5/11.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
@interface renWuViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    NSString *jiBen;
    NSString *renWu;
    NSString *sjiBen;
    NSString *srenWu;
}

@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic)UILabel *leftMoneyLabel;
@property (strong, nonatomic)UILabel *rightMoneyLabel;

@end
