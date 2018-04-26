//
//  OneSelectViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/4/1.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.H"
typedef void (^SelectOk)(NSDictionary * selectDic);

@interface OneSelectViewController : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)SelectOk selectOKBlock;
@property(nonatomic,copy)NSString *view_Title;
@property(nonatomic,retain)NSArray *dataArr;

@end
