//
//  InProductionDetailViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/2/2.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "InProductionDetailTableViewCell.h"
#import "InProductionDetailViewController.h"
@interface InProductionDetailViewController ()
{
    //数据列表
    UITableView *table;
    //数据
    NSMutableArray *dataArr;
    //请求参数
    NSMutableDictionary* requestDic;
}
@end

@implementation InProductionDetailViewController
#pragma mark - 生产中客户列表数据
-(void)requestSuccess:(NSDictionary *)resultDic
{
    
    if([[resultDic objectForKey:@"result"] count] <= 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        [dataArr removeAllObjects];
        [table reloadData];
    }
    else
    {
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        [table reloadData];
    }
}
#pragma mark - 数据请求
-(void) requestAlldata
{
    
    [FX_UrlRequestManager postByUrlStr:InProductCustDetail_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 页面初始化
-(void)initView
{
    //数据初始化
    dataArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:_orderInstanceCode forKey:@"orderInstanceCode"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(13, IOS7_Height, __MainScreen_Width-26, 35)];
    label.text = [NSString stringWithFormat:@"订单号：%@",_orderInstanceCode];
    label.textColor = [ToolList getColor:@"999999"];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    [label.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 35-0.8) toPoint:CGPointMake(__MainScreen_Width, 35-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    //添加列表
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+35, __MainScreen_Width, __MainScreen_Height-35-IOS7_Height) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = 0;
    [self.view addSubview:table];
    [self addNavgationbar:@"生产进度" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self requestAlldata];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"InProductionDetailTableViewCell";
    InProductionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InProductionDetailTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 104.5) toPoint:CGPointMake(__MainScreen_Width, 104.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    cell.blueL.text = [ToolList changeNull:[dic objectForKey:@"groupName"]];
    cell.selectionStyle = 0;
    cell.contentL1.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"workStatus"]],[ToolList changeNull:[dic objectForKey:@"assigneeName"]]];
    NSString *label2 = [NSString stringWithFormat:@"%@ | %@ ",[ToolList changeNull:[dic objectForKey:@"startDate"]],[ToolList changeNull:[dic objectForKey:@"endDate"]]];
    cell.contentL2.text = label2;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
