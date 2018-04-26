//
//  XieJiLuSearch2.h
//  SaleManagement
//
//  Created by chaiyuan on 2017/9/11.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XieJiLuSearch2 : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,assign)NSInteger search_Type;
@property(nonatomic,strong)UIViewController *back_view;

@property(nonatomic,strong)NSString *text_str;
@end
