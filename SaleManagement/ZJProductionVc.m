//
//  ZJProductionVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/3/29.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "ZJProductionVc.h"
#import "Fx_TableView.h"
#import "ZJQiankuanTableViewCell.h"
#import "InProductionDetailViewController.h"

@interface ZJProductionVc ()
{
    Fx_TableView *table;
}
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ZJProductionVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    
    _dataArr = [[NSMutableArray alloc]init];
   
    [self addNavgationbar:@"生产中订单" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    UILabel *titleV = [[UILabel alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 44)];
    titleV.backgroundColor = [UIColor colorWithRed:240/255.0 green:241/255.0 blue:244/255.0 alpha:1.0];
    titleV.font = [UIFont systemFontOfSize:16];
    titleV.textColor = [ToolList getColor:@"666666"];
    titleV.text = [NSString stringWithFormat:@"  %@",_zjcustName];
    [self.view addSubview:titleV];
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+titleV.frame.size.height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-titleV.frame.size.height) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    table.dataSource = self;
    table.delegate = self;
  
    [self.view addSubview:table];
}

-(void)initView{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%@",self.zjcustId] forKey:@"custId"];
    [FX_UrlRequestManager postByUrlStr:ZJfindInProductionCustDetail_url andPramas:dic andDelegate:self andSuccess:@"ZJfindInProductionCustDetailSuccess:" andFaild:nil andIsNeedCookies:YES];
     
}

-(void)ZJfindInProductionCustDetailSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        [_dataArr addObjectsFromArray:[sucDic objectForKey:@"result"]];
        [table reloadData];
    }
  
}

#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ZJQiankuanTableViewCell";
    ZJQiankuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZJQiankuanTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    
    cell.custName.text = [NSString stringWithFormat:@"• %@",[dic objectForKey:@"orderInstanceCode"]];
    cell.custName.textColor = [ToolList getColor:@"666666"];
    
    NSString *label1 = [NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dic objectForKey:@"productName"]],[ToolList changeNull:[dic objectForKey:@"businessType"]],[ToolList changeNull:[dic objectForKey:@"productTrade"]]];
    cell.other1Label.text = label1;
    
    cell.moneyLabel.hidden = YES;

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    InProductionDetailViewController *inP = [[InProductionDetailViewController alloc] init];
    inP.orderInstanceCode = [dic objectForKey:@"orderInstanceCode"];
    [self.navigationController  pushViewController:inP animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
