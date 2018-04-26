//
//  YuanGongCountViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "Fx_TableView.h"
#import "YuanGongCountViewController.h"
#import "YuanGongCountTableViewCell.h"
@interface YuanGongCountViewController ()
{
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
}
@end

@implementation YuanGongCountViewController

#pragma mark table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YuanGongCountTableViewCell";
    YuanGongCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YuanGongCountTableViewCell" owner:self options:nil] lastObject];
        
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    if(indexPath.row == 0)
    {
        cell.topView.backgroundColor = [ToolList getColor:@"6052ba"];
        cell.count.textColor = [ToolList getColor:@"c9c6e5"];
    }
    cell.name.text = [ToolList changeNull:[dic objectForKey:@"salerName"]];
    cell.count.text = [NSString stringWithFormat:@"总计：%@个",[ToolList changeNull:[dic objectForKey:@"toalCount"]]];
    cell.baohugenjin.text = [NSString stringWithFormat:@"%@个",[ToolList changeNull:[dic objectForKey:@"protectCustNum"]]];
    cell.shoucangjia.text = [NSString stringWithFormat:@"%@个",[ToolList changeNull:[dic objectForKey:@"collectionCustNum"]]];
    cell.yixiangkehu.text = [NSString stringWithFormat:@"%@个",[ToolList changeNull:[dic objectForKey:@"intentCustNum"]]];
    cell.wangzhanqianyue.text = [NSString stringWithFormat:@"%@个",[ToolList changeNull:[dic objectForKey:@"signedCustNum"]]];
    cell.qitaqianyue.text = [NSString stringWithFormat:@"%@个",[ToolList changeNull:[dic objectForKey:@"secondCustNum"]]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 212;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 统计客户列表数据
-(void)requestSuccess:(NSDictionary *)resultDic
{
    
    [dataArr removeAllObjects];
    
    
    [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
    
    [table reloadData];
    
}
#pragma mark 数据请求
-(void) requestAlldata
{
    
    
    [FX_UrlRequestManager postByUrlStr:EmployeeCountM_url andPramas:nil andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:NO];
}
#pragma mark -- 页面初始化
-(void)initView
{
    
    [self addNavgationbar:@"员工客户统计" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    dataArr = [[NSMutableArray alloc] init];
    
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    table.dataSource = self;
    table.delegate = self;
    [table.refreshHeader autoRefreshWhenViewDidAppear];

    [self.view addSubview:table];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self requestAlldata];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
