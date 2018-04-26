//
//  CY_debtVc.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_debtVc.h"
#import "Fx_TableView.h"
#import "CY_debtVcCell.h"
#import "MyFormViewController.h"

@interface CY_debtVc ()

@property (nonatomic,assign)NSInteger detb_pageNum ;
@property (nonatomic,strong)Fx_TableView *debtTable;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CY_debtVc

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    _detb_pageNum = 1;
    
    handView *Hvc = [[handView alloc]initWithTitle:@"客户尾款" andRightImage:@"" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];


    [self allRequest];
    
    _debtTable = [[Fx_TableView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _debtTable.backgroundColor = [UIColor whiteColor];
    _debtTable.delegate = self;
    _debtTable.dataSource = self;
    [_debtTable.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_debtTable];
}


#pragma mark 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    _detb_pageNum = 1;
    [self allRequest];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    _detb_pageNum ++;
    [self allRequest];
    
}

-(void)allRequest{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    
    reqDic[@"pageNo"] = [NSString stringWithFormat:@"%ld",_detb_pageNum];
    reqDic[@"pagesize"] = @"10";
    
    [FX_UrlRequestManager postByUrlStr:debt_url andPramas:reqDic andDelegate:self andSuccess:@"debtSuccess:" andFaild:@"debtFild:" andIsNeedCookies:YES];
}

-(void)debtSuccess:(NSDictionary *)sucDic{
  
    
    [_debtTable.refreshHeader endRefreshing];
    [_debtTable.refreshFooter endRefreshing];
        
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
     
        if (_detb_pageNum==1) {
            
            if ([[sucDic objectForKey:@"result"] count]==0) {
                
                [ToolList showRequestFaileMessageLittleTime:@"欠款客户暂无数据"];
                return;
            }
             _dataArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
            
             [_debtTable reloadData];
            
        }else{
            
            if ([[sucDic objectForKey:@"result"] count]==0) {
                
                [ToolList showRequestFaileMessageLittleTime:@"欠款客户暂无更多数据"];
                return;
            }
            
            [_dataArr addObjectsFromArray:[sucDic objectForKey:@"result"]];
            
             [_debtTable reloadData];
        }
        
      
    }
   

}

#pragma uitableviewdelgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"CY_debtVcCell";
    CY_debtVcCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CY_debtVcCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 65.5) toPoint:CGPointMake(__MainScreen_Width, 65.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    cell.nameLable.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    cell.momeyLable.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"surplusTotalMoneyStr"]];
     /*
     custName
     protectCustType 客户所处状态
     orderInstanceCode：订单号
     productName：产品名称 businessType:业务类型  productCode:产品标识

     surplusTotalMoneyStr：未付款金额
     */
 
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    MyFormViewController *s = [[MyFormViewController alloc] init];
    
    s.custName = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    //    s.custId = @"0$tPls3GdafGT3qjDyR@yK";
    [self.navigationController pushViewController:s animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
