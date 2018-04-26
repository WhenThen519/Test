//
//  DistributionViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/29.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "UserDetailViewController.h"
#import "ZJ_DistributionTableViewCell.h"
#import "ZJ_DistributionViewController.h"
#import "FX_Button.h"
#import "Fx_TableView.h"
#import "AlertSalersViewController.h"
@interface ZJ_DistributionViewController ()
{
    NSMutableArray *shifangArr;
    NSMutableArray *xinKehuArr;
    NSMutableArray *wangzhankehuArr;
    NSMutableArray *tableViewArr;
    NSMutableArray *qitakehuArr;
    NSMutableArray *countIndexFlag;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
    BOOL flagNeedReload;
    //员工请求开始页
    int yuanGongStartPage;
    //商务请求开始页
    int shangWuStartPage;
    //经理请求开始页
    int zongJianStartPage;
    //商务请求参数
    NSMutableDictionary *shangWuRequestDic;
    //员工请求参数
    NSMutableDictionary *yuanGongRequestDic;
    //总监请求参数
    NSMutableDictionary *zongJianRequestDic;
    //存头部筛选按钮
    NSMutableArray *selectBtnArr;
    //当前显示页
    int currentPage;
    //员工table
    Fx_TableView *yuanGongTableView;
    //商务table
    Fx_TableView *shangWuTableView;
    //总监table
    Fx_TableView *zongJianTableView;
    //员工异动数据
    NSMutableArray *yuanGongData;
    //商务释放数据
    NSMutableArray *shangWuData;
    //总监调整数据
    NSMutableArray *zongJianData;
    //中间滑动模块
    UIScrollView *scrollView;
    //释放按钮
    UIButton *shiFangBtn;
    //分配按钮
    UIButton *fenPeiBtn;
    NSDictionary *requestDic;
    //搜索数据列表
    Fx_TableView *searchTable;
    //搜索数据
    NSMutableArray *dataSearchArr;
    //搜索请求传参
    NSMutableDictionary *searchRequestDic;
}
@end

@implementation ZJ_DistributionViewController
#pragma mark - 搜索按钮点击
-(void)searchClicked:(UIButton *)btn
{
    flagNeedReload = NO;
    text.text = @"";
    [text becomeFirstResponder];
    [countIndexFlag removeAllObjects];
    [shifangArr removeAllObjects];
    searchTable.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark - 请求搜索数据成功
-(void)requestSearchSuccess:(NSDictionary *)dic
{
    [dataSearchArr removeAllObjects];
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        [searchTable reloadData];
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {    searchTable.hidden = NO;

        [dataSearchArr addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [searchTable reloadData];
    }
  
}
#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    [searchRequestDic setObject:theTextField.text forKey:@"custName"];
    flagNeedReload = NO;
        [searchRequestDic setObject:@"0" forKey:@"flag"];
    [FX_UrlRequestManager postByUrlStr:WillAssignCustByCustName1_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSearchSuccess:" andFaild:nil andIsNeedCookies:YES];
    return YES;
}

#pragma mark - 取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    for (int i = 0; i < selectBtnArr.count ; i++) {
        FX_Button * clickedBtn = [selectBtnArr objectAtIndex:i];
        if (i == 0) {
            currentPage = i;
            [scrollView bringSubviewToFront:[tableViewArr objectAtIndex:i]];
            clickedBtn.isSelect = YES;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
            [shifangArr removeAllObjects];
        }
        else
        {
            clickedBtn.isSelect = NO;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
    }

    flagNeedReload = YES;
    [text resignFirstResponder];
    [countIndexFlag removeAllObjects];
    [shifangArr removeAllObjects];
    [self requestShangWuData];

    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}

#pragma mark - 数据请求
-(void) requestYuanGongData
{
    [yuanGongRequestDic setObject:[NSString stringWithFormat:@"%d",yuanGongStartPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:WillAssignCust_url andPramas:yuanGongRequestDic andDelegate:self andSuccess:@"requestYuanGongSuccess:" andFaild:nil andIsNeedCookies:YES];
}
-(void) requestShangWuData
{
    [shangWuRequestDic setObject:[NSString stringWithFormat:@"%d",shangWuStartPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:WillAssignCust_url andPramas:shangWuRequestDic andDelegate:self andSuccess:@"requestShangWuSuccess:" andFaild:nil andIsNeedCookies:YES];
}
-(void) requestZongJianData
{
    [zongJianRequestDic setObject:[NSString stringWithFormat:@"%d",zongJianStartPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:WillAssignCust_url andPramas:zongJianRequestDic andDelegate:self andSuccess:@"requestZongJianSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 数据请求成功
-(void)requestYuanGongSuccess:(NSDictionary *)dic
{
    [yuanGongTableView.refreshHeader endRefreshing];
    [yuanGongTableView.refreshFooter endRefreshing];
    if(yuanGongStartPage == 1)
    {
        [yuanGongData removeAllObjects];
    }
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        if(yuanGongStartPage == 1)
        {
            [yuanGongData removeAllObjects];
            [yuanGongTableView reloadData];
        }
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [yuanGongData addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [yuanGongTableView reloadData];
    }
}
-(void)requestShangWuSuccess:(NSDictionary *)dic
{
    [shangWuTableView.refreshHeader endRefreshing];
    [shangWuTableView.refreshFooter endRefreshing];
    if(shangWuStartPage == 1)
    {
        [shangWuData removeAllObjects];
    }
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        if(shangWuStartPage == 1)
        {
            [shangWuData removeAllObjects];
            [shangWuTableView reloadData];
        }
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        
    }
    else
    {
        [shangWuData addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [shangWuTableView reloadData];
    }
    for (NSDictionary *dicc in shangWuData) {
        NSLog(@"%@--%@",[dicc objectForKey:@"custName"],[dicc objectForKey:@"custId"]);

    }

}
-(void)requestZongJianSuccess:(NSDictionary *)dic
{
    [zongJianTableView.refreshHeader endRefreshing];
    [zongJianTableView.refreshFooter endRefreshing];
    if(zongJianStartPage == 1)
    {
        [zongJianData removeAllObjects];
    }
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        if(zongJianStartPage == 1)
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        [zongJianData removeAllObjects];
        [zongJianTableView reloadData];
        
    }
    else
    {
        [zongJianData addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [zongJianTableView reloadData];
    }
}
#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(NSString *)flag
{
    if([flag isEqualToString:@"0"])
    {
        yuanGongStartPage = 1;
        [self requestYuanGongData];
    }
    else if ([flag isEqualToString:@"1"])
    {
        shangWuStartPage = 1;
        [self requestShangWuData];
    }
    else
    {
        zongJianStartPage = 1;
        [self requestZongJianData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestShangWuData];
}
//加载更多
-(void)footerRefresh:(NSString *)flag
{
    if([flag isEqualToString:@"0"])
    {
        yuanGongStartPage += 1;
        [self requestYuanGongData];
    }
    else if ([flag isEqualToString:@"1"])
    {
        shangWuStartPage += 1;
        [self requestShangWuData];
    }
    else
    {
        zongJianStartPage += 1;
        [self requestZongJianData];
    }
    
}
#pragma mark - 初始化
-(void)initView
{
#pragma mark - 数据初始化
    shifangArr = [[NSMutableArray alloc] init];
    searchRequestDic = [[NSMutableDictionary alloc] init];
    countIndexFlag = [[NSMutableArray alloc] init];
    [searchRequestDic setObject:@"" forKey:@"custName"];
    tableViewArr = [[NSMutableArray alloc] init];
    xinKehuArr = [[NSMutableArray alloc] init];
    wangzhankehuArr = [[NSMutableArray alloc] init];
    qitakehuArr = [[NSMutableArray alloc] init];
    selectBtnArr = [[NSMutableArray alloc] init];
    currentPage = 0;
    yuanGongData = [[NSMutableArray alloc] init];
    zongJianData = [[NSMutableArray alloc] init];
    shangWuData = [[NSMutableArray alloc] init];
    yuanGongStartPage = 1;
    shangWuStartPage = 1;
    zongJianStartPage = 1;
    yuanGongRequestDic = [[NSMutableDictionary alloc] init];
    [yuanGongRequestDic setObject:@"1" forKey:@"custSource"];
    [yuanGongRequestDic setObject:[NSString stringWithFormat:@"%d",yuanGongStartPage] forKey:@"pageNo"];
    [yuanGongRequestDic setObject:@"10" forKey:@"pagesize"];
    
    shangWuRequestDic = [[NSMutableDictionary alloc] init];
    [shangWuRequestDic setObject:@"3" forKey:@"custSource"];
    [shangWuRequestDic setObject:[NSString stringWithFormat:@"%d",shangWuStartPage] forKey:@"pageNo"];
    [shangWuRequestDic setObject:@"10" forKey:@"pagesize"];
    
    zongJianRequestDic = [[NSMutableDictionary alloc] init];
    [zongJianRequestDic setObject:@"2" forKey:@"custSource"];
    [zongJianRequestDic setObject:[NSString stringWithFormat:@"%d",zongJianStartPage] forKey:@"pageNo"];
    [zongJianRequestDic setObject:@"10" forKey:@"pagesize"];
#pragma mark - 页面初始化
    //标题
    [self addNavgationbar:@"客户分配" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];
    //头部筛选
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, SelectViewHeight)];
    selectView.backgroundColor = [ToolList getColor:@"fafafa"];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, SelectViewHeight-0.8) toPoint:CGPointMake(__MainScreen_Width, SelectViewHeight-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [self.view addSubview:selectView];
    NSArray * arr = @[@"分配超时",@"经理释放",@"超180天"];
    for (int i = 0 ; i < arr.count; i ++) {
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/3*i, 0, __MainScreen_Width/3, SelectViewHeight-0.8) andType:@"2" andTitle:[arr objectAtIndex:i] andTarget:self andDic:nil];
        btn.tag = i;
        [selectView addSubview:btn];
        if(i == 0)
        {
            btn.isSelect = YES;
            [btn changeBigAndColorCliked:btn];
        }
        [selectBtnArr addObject:btn];
    }
    //中间数据层
     shangWuTableView = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-CaozuoViewHeight) style:UITableViewStylePlain isNeedRefresh:YES target:self Flag:@"1"];
    shangWuTableView.delegate = self;
    shangWuTableView.dataSource = self;
    shangWuTableView.tag = 1;
    shangWuTableView.backgroundColor = [UIColor whiteColor];
    [shangWuTableView.refreshHeader autoRefreshWhenViewDidAppear];

    yuanGongTableView = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-CaozuoViewHeight) style:UITableViewStylePlain isNeedRefresh:YES target:self Flag:@"0"];
    yuanGongTableView.delegate = self;
    yuanGongTableView.dataSource = self;
    yuanGongTableView.tag = 0;
    [yuanGongTableView.refreshHeader autoRefreshWhenViewDidAppear];
    yuanGongTableView.backgroundColor = [UIColor whiteColor];
    
    zongJianTableView = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-CaozuoViewHeight) style:UITableViewStylePlain isNeedRefresh:YES target:self Flag:@"2"];
    zongJianTableView.delegate = self;
    zongJianTableView.dataSource = self;
    zongJianTableView.backgroundColor = [UIColor whiteColor];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-CaozuoViewHeight)];
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(__MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-CaozuoViewHeight);
    [scrollView addSubview:zongJianTableView];
    [scrollView addSubview:yuanGongTableView];
    [scrollView addSubview:shangWuTableView];
    [tableViewArr addObject:shangWuTableView];
    [tableViewArr addObject:yuanGongTableView];
    [tableViewArr addObject:zongJianTableView];
    
    
    [self.view addSubview:scrollView];
    
    //底部操作层
    UIView *doView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-CaozuoViewHeight, __MainScreen_Width, CaozuoViewHeight)];
    doView.backgroundColor = [ToolList getColor:@"fafafa"];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0.8) toPoint:CGPointMake(__MainScreen_Width, 0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"释放" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [shiFangBtn addTarget:self action:@selector(shiFangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_shifang.png"] forState:UIControlStateNormal];
    [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:shiFangBtn];
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [fenPeiBtn addTarget:self action:@selector(fenPeiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
    
    dataSearchArr = [[NSMutableArray alloc] init];
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __MainScreen_Height-CaozuoViewHeight)];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, IOS7_Height)];
    [searchView addSubview:headView];
    //搜索框
    text = [[UITextField alloc] initWithFrame:CGRectMake(13, IOS7_StaticHeight + 7, __MainScreen_Width-56, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    text.leftView = imgView;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.backgroundColor = [ToolList getColor:@"dedee0"];
    text.placeholder = @"请输入搜索内容";
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [ToolList getColor:@"333333"];
    text.layer.cornerRadius = 8;
    text.layer.masksToBounds = YES;
    text.clearButtonMode = UITextFieldViewModeAlways;
    text.delegate = self;
    text.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:text];
    
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView addSubview:cancelSearchBtn];
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
    searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CaozuoViewHeight) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    [searchView addSubview:searchTable];
    [self.view addSubview:doView];

}
#pragma mark - 释放按钮点击
-(void)shiFangBtnClicked:(UIButton *)btn
{
    if(shifangArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in shifangArr) {
        [arr addObject:[dic objectForKey:@"custId"]];
    }
    [FX_UrlRequestManager postByUrlStr:ZJReleaseCust_url andPramas:[NSMutableDictionary dictionaryWithObject:arr forKey:@"custIds"] andDelegate:self andSuccess:@"shifangSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 释放成功
-(void)shifangSuccess:(NSDictionary *)dic
{
    [shifangArr removeAllObjects];

    if([[dic objectForKey:@"code"] intValue]==200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"释放成功"];
        if(flagNeedReload == NO)
        {
            flagNeedReload = YES;
            [text resignFirstResponder];
            for (int i = 0; i < selectBtnArr.count ; i++) {
                FX_Button * clickedBtn = [selectBtnArr objectAtIndex:i];
                if (i == 0) {
                    currentPage = i;
                    [scrollView bringSubviewToFront:[tableViewArr objectAtIndex:i]];
                    clickedBtn.isSelect = YES;
                    [clickedBtn changeBigAndColorCliked:clickedBtn];
                }
                else
                {
                    clickedBtn.isSelect = NO;
                    [clickedBtn changeBigAndColorCliked:clickedBtn];
                }
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
            }];
            
        }

        [countIndexFlag removeAllObjects];
        [shifangArr removeAllObjects];

        if(currentPage == 1)
        {
            yuanGongStartPage = 1;
            [self requestYuanGongData];
        }
        else if (currentPage == 0)
        {
            shangWuStartPage = 1;
            [self requestShangWuData];
        }
        else
        {
            zongJianStartPage = 1;
            [self requestZongJianData];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - 分配客户成功
-(void)intentCust:(NSDictionary *)dic
{
    [shifangArr removeAllObjects];

    if(flagNeedReload == NO)
    {
        flagNeedReload = YES;
        [text resignFirstResponder];
        for (int i = 0; i < selectBtnArr.count ; i++) {
            FX_Button * clickedBtn = [selectBtnArr objectAtIndex:i];
            if (i == 0) {
                currentPage = i;
                [scrollView bringSubviewToFront:[tableViewArr objectAtIndex:i]];
                clickedBtn.isSelect = YES;
                [clickedBtn changeBigAndColorCliked:clickedBtn];
            }
            else
            {
                clickedBtn.isSelect = NO;
                [clickedBtn changeBigAndColorCliked:clickedBtn];
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
        }];
        
    }
    if([[dic objectForKey:@"code"] intValue] == 200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"分配成功"];

        [shifangArr removeAllObjects];
        [countIndexFlag removeAllObjects];
        switch (currentPage) {
            case 0:
            {
                shangWuStartPage = 1;
                [self requestShangWuData];
            }
                break;
            case 1:
            {
                yuanGongStartPage = 1;
                [self requestYuanGongData];
            }
                break;
            case 2:
            {
                zongJianStartPage = 1;
                [self requestZongJianData];
            }
                break;
            default:
                break;
        }    }
}
#pragma mark - 分配按钮点击
-(void)fenPeiBtnClicked:(UIButton *)btn
{
    if(shifangArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [xinKehuArr removeAllObjects];
    [wangzhankehuArr removeAllObjects];
    [qitakehuArr removeAllObjects];
    NSMutableArray *custIds = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in shifangArr) {
        NSString *custId = [dic objectForKey:@"custId"];
        [custIds addObject:custId];
    }
    AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
    dd.selectOKBlock = ^(NSString *salerId)
    {
        NSDictionary *dic  = @{@"custIds":custIds,@"assignToDeptId":salerId};
        [FX_UrlRequestManager postByUrlStr:ZJAssignCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
    };
    [self.navigationController pushViewController:dd animated:NO];
//    for (NSDictionary *dic in shifangArr) {
//        if([[dic objectForKey:@"oldOrNew"] isEqualToString:@"新客户"])
//        {
//            [xinKehuArr addObject:[dic objectForKey:@"custId"]];
//        }
//        else if ([[dic objectForKey:@"oldOrNew"] isEqualToString:@"网站客户"])
//        {
//            [wangzhankehuArr addObject:[dic objectForKey:@"custId"]];
//        }
//        else
//        {
//            [qitakehuArr addObject:[dic objectForKey:@"custId"]];
//        }
//    }
//    requestDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:xinKehuArr.count],@"newCust",[NSNumber numberWithLong:wangzhankehuArr.count],@"webCust",[NSNumber numberWithLong:qitakehuArr.count],@"noWebCust", nil];
//    //查余额
//    [FX_UrlRequestManager postByUrlStr:SalerCount_url andPramas:[NSMutableDictionary dictionaryWithDictionary:requestDic] andDelegate:self andSuccess:@"chaYuSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}

#pragma mark - 点击按钮回调
-(void)changeBigAndColorClikedBack:(FX_Button *)btn
{
    [countIndexFlag removeAllObjects];
    for (int i = 0; i < selectBtnArr.count ; i++) {
        FX_Button * clickedBtn = [selectBtnArr objectAtIndex:i];
        if (clickedBtn == btn) {
            currentPage = i;
            [scrollView bringSubviewToFront:[tableViewArr objectAtIndex:i]];
            clickedBtn.isSelect = YES;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
            [shifangArr removeAllObjects];
        }
        else
        {
            clickedBtn.isSelect = NO;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
    }
    
    
    if(btn.tag == 0)
    {
        shangWuStartPage = 1;
        [self requestShangWuData];

    }
    else if (btn.tag == 1)
    {
        yuanGongStartPage = 1;
        [self requestYuanGongData];
    }
    else
    {
        zongJianStartPage = 1;
        [self requestZongJianData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    flagNeedReload = YES;

    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == shangWuTableView)
    {
        return shangWuData.count;
    }
    else if (tableView == yuanGongTableView)
    {
        return yuanGongData.count;
    }
    else if (tableView == searchTable)
    {
        return dataSearchArr.count;
    }
    else
    {
        return zongJianData.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ZJ_DistributionTableViewCell";
    ZJ_DistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZJ_DistributionTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = nil;
    if(tableView == shangWuTableView)
    {
        dic = [shangWuData objectAtIndex:indexPath.row];
    }
    else if (tableView == yuanGongTableView)
    {
        dic = [yuanGongData objectAtIndex:indexPath.row];
    }
    else if (tableView == searchTable)
    {
        dic = [dataSearchArr objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [zongJianData objectAtIndex:indexPath.row];
    }
    
    cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    NSString *oldOrNew = [ToolList changeNull:[dic objectForKey:@"oldOrNew"]];
    NSString *exceedTime = [ToolList changeNull:[dic objectForKey:@"deptName"]];
    if([countIndexFlag indexOfObject:[NSNumber numberWithLong:indexPath.row]] == NSNotFound)
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"btn_duoxuan.png"] forState:UIControlStateNormal];
   
    }
    else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"btn_duoxuan_s.png"] forState:UIControlStateNormal];
 
    }

//    
//    if([exceedTime isEqualToString:@"-1"])
//    {
//        exceedTime = @"即将释放";
//        //富文本的基本数据类型，属性字符串。以此为基础，如果这个设置了相应的属性，则会忽略上面设置的属性，默认为空
//        NSString *str = [NSString stringWithFormat:@"%@ | %@",oldOrNew,@"即将释放"];
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
//        
//        // 设置颜色
//        UIColor *color = [ToolList getColor:@"ff3333"];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:color
//                           range:[str rangeOfString:@"即将释放"]];
//        cell.labelother.attributedText = attrString;
//    }
//    else if ((exceedTime.intValue > 0 && exceedTime.intValue <=3))
//    {
//        NSString *str = [NSString stringWithFormat:@"%@ | %@天",oldOrNew,exceedTime];
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
//        
//        // 设置颜色
//        UIColor *color = [ToolList getColor:@"ff3333"];
//        [attrString addAttribute:NSForegroundColorAttributeName
//                           value:color
//                           range:[str rangeOfString:exceedTime]];
//        cell.labelother.attributedText = attrString;
//    }
//    else
//    {
    cell.labelother.text = [NSString stringWithFormat:@"%@ | 来自%@",oldOrNew,exceedTime];
//    }
    cell.selectBtn.tag = indexPath.row;
    cell.czBlock = ^(NSDictionary * dicc)
    {
        //记录状态
        if([[dicc objectForKey:@"isSelect"] intValue])
        {
//            if(countIndexFlag.count)
//            {
            if([countIndexFlag indexOfObject:[dicc objectForKey:@"index"]] == NSNotFound)
            {
                [countIndexFlag addObject:[dicc objectForKey:@"index"]];
            }
//            }
//            else
//            {
//                [countIndexFlag addObject:[dic objectForKey:@"index"]];
//            }
        }
        else
        {
            if([countIndexFlag indexOfObject:[dicc objectForKey:@"index"]] != NSNotFound)
            {
                [countIndexFlag removeObject:[dicc objectForKey:@"index"]];
            }
        }
        if(currentPage == 0)
        {
            if([[dicc objectForKey:@"isSelect"] intValue])
            {
                if([ shifangArr indexOfObject:dic] == NSNotFound)
                {
                    [shifangArr addObject:dic];
                }
            }
            else
            {
                if([ shifangArr indexOfObject:dic] != NSNotFound)
                {
                    [shifangArr removeObject:dic];
                }
            }
            
        }
        else if (currentPage == 1)
        {
          
            if([[dicc objectForKey:@"isSelect"] intValue])
            {
                if([ shifangArr indexOfObject:dic] == NSNotFound)
                {
                    [shifangArr addObject:dic];
                }
            }
            else
            {
                if([ shifangArr indexOfObject:dic] != NSNotFound)
                {
                    [shifangArr removeObject:dic];
                }
            }
//      多线程操作     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 
//             });
//           });
        }
        else
        {
            if([[dicc objectForKey:@"isSelect"] intValue])
            {
                if([ shifangArr indexOfObject:dic] == NSNotFound)
                {
                    [shifangArr addObject:dic];
                }
            }
            else
            {
                if([ shifangArr indexOfObject:dic] != NSNotFound)
                {
                    [shifangArr removeObject:dic];
                }
            }
            
        }
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic;
    if(tableView == shangWuTableView)
    {
        dic = [shangWuData objectAtIndex:indexPath.row];
    }
    else if (tableView == yuanGongTableView)
    {
        dic = [yuanGongData objectAtIndex:indexPath.row];
    }
    else if (tableView == searchTable)
    {
        dic = [dataSearchArr objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [zongJianData objectAtIndex:indexPath.row];
    }
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    s.oldOrNew = [dic objectForKey:@"oldOrNew"];
    [self.navigationController pushViewController:s animated:NO];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
