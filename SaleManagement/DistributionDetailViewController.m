//
//  DistributionDetailViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/21.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "DistributionDetailTableViewCell.h"
#import "DistributionDetailViewController.h"
#import "Fx_TableView.h"
@interface DistributionDetailViewController ()
{
    //数据列表
    Fx_TableView *table;
    //选的第几列
    long selectIndex;
    //请求传参
    NSMutableDictionary *requestDic;
    //开始数据标识
    int startPage;
    UILabel *bottomLabel;
}
@end

@implementation DistributionDetailViewController
#pragma mark - 完成
-(void)finish
{
    
    if(selectIndex!=-1)
    {
        if([self.flag isEqualToString:@"tiaozheng"])
        {
            NSDictionary *dic = [_dataArr objectAtIndex:selectIndex];
            NSString *salerId = [dic objectForKey:@"salerId"];
            NSMutableDictionary *requestD = [NSMutableDictionary dictionaryWithObjectsAndKeys:_custId,@"custId",salerId,@"adjustToSalerId", nil];
            [FX_UrlRequestManager postByUrlStr:AdjustCustToSaler_url andPramas:requestD andDelegate:self andSuccess:@"assignSuccess:" andFaild:nil andIsNeedCookies:YES];
            
        }
        else
        {
            NSDictionary *dic = [_dataArr objectAtIndex:selectIndex];
            NSString *salerId = [dic objectForKey:@"salerId"];
            NSMutableDictionary *requestD = [NSMutableDictionary dictionaryWithObjectsAndKeys:_custIds,@"custIds",salerId,@"assignToSalerId", nil];
            [FX_UrlRequestManager postByUrlStr:AssignCustToSaler_url andPramas:requestD andDelegate:self andSuccess:@"assignSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择要分配的商务！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    
}
#pragma mark - 分配完成
-(void)assignSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue] == 200)
    {
        [self.navigationController popViewControllerAnimated:NO];
        _czBlock(_refreshIndex);
    }
}
-(void)initView
{
    selectIndex = -1;
    //标题
    [self addNavgationbar:@"客户分配" leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-49) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    
    bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-49, __MainScreen_Width, 49)];
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.font = [UIFont systemFontOfSize:13];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.backgroundColor = [UIColor colorWithRed:83/255. green:82/255. blue:109/255. alpha:1];
    bottomLabel.text = [NSString stringWithFormat:@"已选：新客户%@个 | 网站客户%@个 | 非网站客户%@个",[_selectDic objectForKey:@"newCust"],[_selectDic objectForKey:@"webCust"] ,[_selectDic objectForKey:@"noWebCust"]];
    [self.view addSubview:bottomLabel];
    table.dataSource = self;
    table.delegate = self;
    [table.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:table];
    if([self.flag isEqualToString:@"tiaozheng"])
    {
        table.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height);
        bottomLabel.hidden = YES;
    }
}

#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DistributionDetailTableViewCell";
    DistributionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DistributionDetailTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    if([[dic objectForKey:@"flag"] intValue] == 0)
    {
        cell.contentView.backgroundColor = [ToolList getColor:@"f4f4f9"];
        cell.userInteractionEnabled = NO;
    }
    else
    {
        cell.contentView.backgroundColor = [ToolList getColor:@"ffffff"];
        cell.userInteractionEnabled = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"salerName"]];
    if([self.flag isEqualToString:@"tiaozheng"])
    {
        cell.contentL.text = [NSString stringWithFormat:@"余额：网站客户%@个  | 非网站客户%@个",[ToolList changeNull:[dic objectForKey:@"webNum"]],[ToolList changeNull:[dic objectForKey:@"noWebNum"]]];
    }
    else
    {
        cell.contentL.text = [NSString stringWithFormat:@"余额：保护%@个 | 网站客户%@个 | 非网站客户%@个",[ToolList changeNull:[dic objectForKey:@"protectNum"]],[ToolList changeNull:[dic objectForKey:@"webNum"]],[ToolList changeNull:[dic objectForKey:@"noWebNum"]]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = indexPath.row;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
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
