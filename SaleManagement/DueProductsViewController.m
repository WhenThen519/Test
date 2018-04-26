//
//  InProductionViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/28.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "DueProductsTableViewCell.h"
#import "DueProductsViewController.h"
#import "Fx_TableView.h"
#import "UserDetailViewController.h"
@interface DueProductsViewController ()
{
    //地区筛选内容
    UIScrollView *selectDiQuContentView;
    //推荐筛选内容
    UIScrollView *selectTuijianContentView;
    //地区筛选内容
    UIView *selectDiQuView;
    //推荐筛选内容
    UIView *selectTuijianView;
    //地区
    FX_Button *diquBtn;
    //推荐
    FX_Button *tuijianBtn;
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
    //请求传参
    NSMutableDictionary *requestDic;
    //开始数据标识
    int startPage;
    //请求传参
    NSMutableArray *selectArr;
}
@end

@implementation DueProductsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAlldata];
}
#pragma mark - 数据请求
-(void) requestAlldata
{
    
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:DueProducts_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 页面初始化
-(void)initView
{
    //数据初始化
    startPage = 1;
    dataArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"" forKey:@"salerId"];
    [requestDic setObject:@"-1" forKey:@"productFlag"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    [table.refreshHeader autoRefreshWhenViewDidAppear];

    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    //筛选区域
    selectDiQuContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectDiQuContentView.backgroundColor = [UIColor whiteColor];
    selectTuijianContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectTuijianContentView.backgroundColor = [UIColor whiteColor];
    
    selectDiQuView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight)];
    selectDiQuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    selectTuijianView = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight)];
    selectTuijianView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [selectDiQuView addSubview:selectDiQuContentView];
    [selectTuijianView addSubview:selectTuijianContentView];
    
    
    [self.view addSubview:selectDiQuView];
    [self.view addSubview:selectTuijianView];
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, SelectViewHeight)];
    selectView.backgroundColor = [ToolList getColor:@"fafafa"];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, SelectViewHeight-0.8) toPoint:CGPointMake(__MainScreen_Width, SelectViewHeight-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [self.view addSubview:selectView];
    
    
    diquBtn = [[FX_Button alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width/2, SelectViewHeight) andType:@"0" andTitle:@"商务" andTarget:self andDic:nil];
    [selectView addSubview:diquBtn];
    tuijianBtn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, SelectViewHeight) andType:@"0" andTitle:@"产品" andTarget:self andDic:nil];
    [selectView addSubview:tuijianBtn];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 8) toPoint:CGPointMake(__MainScreen_Width/2, SelectViewHeight-8) andWeight:0.1 andColorString:@"666666"]];
    [self addNavgationbar:@"产品到期客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    startPage = 1;
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    startPage += 1;
    [self requestAlldata];
    
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DueProductsTableViewCell";
    DueProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DueProductsTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 109.5) toPoint:CGPointMake(__MainScreen_Width, 109.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    cell.custName.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    
    NSString *label1 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"salerName"]],[ToolList changeNull:[dic objectForKey:@"custVirtualType"]]];
    cell.other1Label.text = label1;
    cell.moneyLabel.text = [ToolList changeNull:[dic objectForKey:@"productEndTime"]];
    NSString *label2 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"productName"]],[ToolList changeNull:[dic objectForKey:@"productCode"]]];
    cell.other2Label.text = label2;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    [self.navigationController pushViewController:s animated:NO];
}
#pragma mark - 产品到期客户列表数据
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    if(startPage == 1)
    {
        [dataArr removeAllObjects];
    }
    if([[resultDic objectForKey:@"result"] count] <= 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        if(startPage == 1)
        {
            [dataArr removeAllObjects];
            [table reloadData];
        }
    }
    else
    {
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        [table reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 筛选产品数据请求失败
-(void)OpenSelectFaile1:(NSDictionary *)resultDic
{
    [ToolList showRequestFaileMessageLittleTime:@"筛选条件加载失败，请重试！"];
    [tuijianBtn change:@"down"];
}
#pragma mark - 筛选产品数据请求成功
-(void)OpenSelectSuccess1:(NSDictionary *)resultDic
{
    for (UIView *subView in selectTuijianContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    selectArr = [[NSMutableArray alloc] initWithArray:[resultDic objectForKey:@"result"]];
    
    selectTuijianContentView.contentSize = CGSizeMake(__MainScreen_Width, 45*selectArr.count);
    selectTuijianContentView.frame = CGRectMake(0, 0, __MainScreen_Width, 45*selectArr.count>__MainScreen_Height*0.68?__MainScreen_Height*0.68:selectArr.count*45);
    for (int i = 0 ; i < selectArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*45, __MainScreen_Width, 45);
        
        NSString *title = [[selectArr objectAtIndex:i] objectForKey:@"productName"];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
        btn.tag = i;
        [btn addTarget:self action:@selector(shaixuanCommit:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        [selectTuijianContentView addSubview:btn];
        
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        selectTuijianView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width,__MainScreen_Height-SelectViewHeight-IOS7_Height);
        
        
    }];
}

#pragma mark - 筛选商务数据请求失败
-(void)OpenSelectFaile:(NSDictionary *)resultDic
{
    [ToolList showRequestFaileMessageLittleTime:@"筛选条件加载失败，请重试！"];
    
    [diquBtn change:@"down"];
}
#pragma mark - 筛选商务数据请求成功
-(void)OpenSelectSuccess:(NSDictionary *)resultDic
{
    for (UIView *subView in selectDiQuContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    selectArr = [[NSMutableArray alloc] initWithArray:[resultDic objectForKey:@"result"]];
    NSDictionary *dic =  @{@"salerId":@"-1", @"salerName":@"全部"};
    [selectArr insertObject:dic atIndex:0];
    
    selectDiQuContentView.contentSize = CGSizeMake(__MainScreen_Width, 45*selectArr.count);
    selectDiQuContentView.frame = CGRectMake(0, 0, __MainScreen_Width, 45*selectArr.count>__MainScreen_Height*0.68?__MainScreen_Height*0.68:selectArr.count*45);
    for (int i = 0 ; i < selectArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*45, __MainScreen_Width, 45);
        
        NSString *title = [[selectArr objectAtIndex:i] objectForKey:@"salerName"];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
        btn.tag = i;
        [btn addTarget:self action:@selector(diquCommit:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        [selectDiQuContentView addSubview:btn];
        
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width,__MainScreen_Height-SelectViewHeight-IOS7_Height);
        
        
    }];
}
#pragma mark - 筛选按钮点击
-(void)btnBack:(FX_Button *)str
{
    
    if(str.frame.origin.x == 0)
    {
        if(str.isSelect)
        {
            [tuijianBtn change:@"down"];
//            [tuijianBtn setTitle:[[selectArr objectAtIndex:str.tag] objectForKey:@"salerName"] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.3 animations:^{
                selectTuijianView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            }];
            [FX_UrlRequestManager postByUrlStr:GetSalers_url andPramas:nil andDelegate:self andSuccess:@"OpenSelectSuccess:" andFaild:@"OpenSelectFaile:" andIsNeedCookies:NO];
            
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                selectDiQuView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            }];
        }
    }
    else if (str.frame.origin.x == __MainScreen_Width/2 )
    {
        if(str.isSelect)
        {
            
            [diquBtn change:@"down"];
//             [diquBtn setTitle:[[selectArr objectAtIndex:str.tag] objectForKey:@"salerName"] forState:UIControlStateNormal];
            [FX_UrlRequestManager postByUrlStr:ProductListInit_url andPramas:nil andDelegate:self andSuccess:@"OpenSelectSuccess1:" andFaild:@"OpenSelectFaile1:" andIsNeedCookies:NO];
            [UIView animateWithDuration:0.3 animations:^{
                selectDiQuView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            }];
            
            
        }
        else
        {
            
            [UIView animateWithDuration:0.3 animations:^{
                selectTuijianView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            }];
        }
        
    }
}
#pragma mark - 产品筛选点击
-(void)shaixuanCommit:(UIButton *)btn
{
    [diquBtn change:@"down"];
    [tuijianBtn change:@"down"];
    
    [tuijianBtn setTitle:[[selectArr objectAtIndex:btn.tag] objectForKey:@"productName"]forState:UIControlStateNormal];
    
    [requestDic setObject:[[selectArr objectAtIndex:btn.tag] objectForKey:@"productFlag"] forKey:@"productFlag"];
    startPage = 1;
    [self requestAlldata];
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
        selectTuijianView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    }];
}
#pragma mark - 商务筛选点击
-(void)diquCommit:(UIButton *)btn
{
    
    [diquBtn change:@"down"];
    [tuijianBtn change:@"down"];
    
    if(btn.tag == 0 )
    {
        [requestDic setObject:@"" forKey:@"salerId"];
    }
    
    else
    {
        [requestDic setObject:[[selectArr objectAtIndex:btn.tag] objectForKey:@"salerId"] forKey:@"salerId"];
    }
    [diquBtn setTitle:[[selectArr objectAtIndex:btn.tag] objectForKey:@"salerName"]  forState:UIControlStateNormal];
    
    startPage = 1;
    [self requestAlldata];
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
        selectTuijianView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    }];
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
