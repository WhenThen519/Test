//
//  Fx_TableView.h
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"

@interface Fx_TableView : UITableView

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, copy) NSString *flag;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style isNeedRefresh:(BOOL)isNeedRefresh target:(id)target;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style isNeedRefresh:(BOOL)isNeedRefresh target:(id)target Flag:(NSString *)flag;

@end
