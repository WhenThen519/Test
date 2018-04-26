//
//  CY_EndTimeVc.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_EndTimeVc.h"
#import "Fx_TableView.h"
#import "DueProductsTableViewCell.h"
#import "UserDetailViewController.h"

@interface CY_EndTimeVc ()


@property (nonatomic,strong)Fx_TableView *timeTable;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CY_EndTimeVc

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)RightAction:(UIButton *)sender
{
  
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    handView *Hvc = [[handView alloc]initWithTitle:@"产品到期客户" andRightImage:@"" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];
    
    [self allRequest];
    
    _timeTable = [[Fx_TableView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    _timeTable.backgroundColor = [UIColor whiteColor];
    _timeTable.delegate = self;
    _timeTable.dataSource = self;
//    [_timeTable.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_timeTable];
}


-(void)allRequest{
    
    [FX_UrlRequestManager postByUrlStr:getDue_url andPramas:nil andDelegate:self andSuccess:@"timeSuccess:" andFaild:@"timeFild:" andIsNeedCookies:NO];
}

-(void)timeSuccess:(NSDictionary *)sucDic{

    
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        _dataArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
    }
    [_timeTable reloadData];
    
}

#pragma uitableviewdelgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 109.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"DueProductsTableViewCell";
    DueProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"DueProductsTableViewCell" owner:self options:nil] lastObject];

        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 108.5) toPoint:CGPointMake(__MainScreen_Width, 108.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    /*
     productCode：产品标识
     productEndTime：到期时间
     productName：产品名称
     
     custId = 3Cn8Na8i9crbIcxKEgIWWu;
     custName = "\U6e38\U620f\U516c\U53f8";
     productCode = "www.jjj.com";
     productEndTime = "2015-11-28";
     productName = "Z+";
     protectCustType = "--";
     */

    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    cell.custName.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    cell.other1Label.text = [ToolList changeNull:[dic objectForKey:@"protectCustType"]];
    
    cell.moneyLabel.text = [dic objectForKey:@"productEndTime"];
    
    NSString *label2 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"productName"]],[ToolList changeNull:[dic objectForKey:@"productCode"]]];
    
    cell.other2Label.text = label2;
    cell.moneyLabel.textColor = [ToolList getColor:@"999999"];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
   
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    s.flagRefresh = @"chanpin";
    [self.navigationController pushViewController:s animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
