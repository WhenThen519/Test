//
//  Fx_TableView.m
//  SaleManagement
//
//  Created by feixiang on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "Fx_TableView.h"
@implementation Fx_TableView
{
    id delegate;
}
- (void)setupRefresh
{
   
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addToScrollView:self];
    refreshHeader.flag = _flag;
    [refreshHeader addTarget:delegate refreshAction:@selector(headerRefresh:)];
    _refreshHeader = refreshHeader;
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self isEffectedByNavigationController:NO];
    refreshFooter.flag = _flag;
    [refreshFooter addTarget:delegate refreshAction:@selector(footerRefresh:)];
    _refreshFooter = refreshFooter;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style isNeedRefresh:(BOOL)isNeedRefresh target:(id)target
{
    self =  [super initWithFrame:frame style:style];
    if(self)
    {
        delegate = target;
        self.separatorStyle = 0;
       if(isNeedRefresh)
       {
           // 集成刷新控件
           [self setupRefresh];
           //监听停止刷新
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopRefresh) name:@"STOP_REFRESH" object:nil];
       }
    }
    return self;
}
//停止刷新
-(void)stopRefresh
{
    [_refreshHeader endRefreshing];
    [_refreshFooter endRefreshing];
}
- (id)copyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    return copyInstance;
}
//多个table在一个页面上带标识
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style isNeedRefresh:(BOOL)isNeedRefresh target:(id)target Flag:(NSString *)flag
{
    _flag = flag;
    self = [self initWithFrame:frame style:style isNeedRefresh:isNeedRefresh target:target];
 
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
