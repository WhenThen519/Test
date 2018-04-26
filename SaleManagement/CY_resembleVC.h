//
//  CY_resembleVC.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CY_resembleVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *textString;
@property (nonatomic,assign)BOOL isRen;
@property (nonatomic,strong)NSString *intentCustString;

@end
