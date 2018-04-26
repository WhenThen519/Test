//
//  DistributionDetailViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/21.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.H"
typedef void (^chuanRefreshIndex)(int) ;

@interface DistributionDetailViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSArray *dataArr;
@property(nonatomic,copy)chuanRefreshIndex czBlock;
@property(nonatomic,assign)int refreshIndex;
@property(nonatomic,retain)NSDictionary *selectDic;
@property(nonatomic,retain)NSMutableArray *custIds;
@property(nonatomic,retain)NSString *custId;
@property(nonatomic,copy)NSString *flag;
@end
