//
//  XieJiLuSearch.h
//  SaleManagement
//
//  Created by cat on 2017/9/4.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Search_Data)(NSDictionary *) ;

@interface XieJiLuSearch : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)Search_Data Serach_Block;
@property(nonatomic,retain)UIViewController * ss;

@end
