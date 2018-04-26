//
//  CY_producingVc.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_producingVc.h"
#import "Fx_TableView.h"
#import "CY_debtVcCell.h"
#import "ZJProductionVc.h"

@interface CY_producingVc ()

@property (nonatomic,assign)NSInteger pageNum ;
@property (nonatomic,strong)Fx_TableView *producingTable;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CY_producingVc

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)RightAction:(UIButton *)sender
{
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _pageNum = 1;
    
    handView *Hvc = [[handView alloc]initWithTitle:@"生产中客户" andRightImage:@"" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];
    

    _producingTable = [[Fx_TableView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _producingTable.backgroundColor = [UIColor whiteColor];
    _producingTable.delegate = self;
    _producingTable.dataSource = self;

    //    [_producingTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
   // [_producingTable.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_producingTable];
    
    
    [self allRequest];

    
}

-(void)allRequest{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    reqDic[@"pageNo"] = [NSString stringWithFormat:@"%ld",_pageNum];
    reqDic[@"pagesize"] = @"10";
    [FX_UrlRequestManager postByUrlStr:producing_url andPramas:reqDic andDelegate:self andSuccess:@"producingSuccess:" andFaild:@"producingFild:" andIsNeedCookies:YES];
}

#pragma mark 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    _pageNum = 1;
    [self allRequest];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    _pageNum ++;
    [self allRequest];
    
}


-(void)producingSuccess:(NSDictionary *)sucDic{
    
    [_producingTable.refreshHeader endRefreshing];
    [_producingTable.refreshFooter endRefreshing];
    
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
            if ([[sucDic objectForKey:@"result"] count]) {
                
                if ( _pageNum == 1) {
                    
                _dataArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
               
                    
                }else{
                    
                    [_dataArr addObjectsFromArray:[sucDic objectForKey:@"result"]];
                }
                
            }else{
                
                if ( _pageNum == 1) {
                    
                   [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
                    return;
                }
                 [ToolList showRequestFaileMessageLittleTime:@"暂无更多数据"];
               
            }
        
        

                
        
        
        
        
    }
    
    [_producingTable reloadData];
}

#pragma uitableviewdelgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
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
     cell.momeyLable.hidden = YES;
  
   
//    NSString *label2 = [NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dic objectForKey:@"productName"]],[ToolList changeNull:[dic objectForKey:@"businessType"]],[ToolList changeNull:[dic objectForKey:@"productCode"]]];
    
//    cell.custName.text = [NSString stringWithFormat:@"哈哈-%ld",indexPath.row];
    /*
 custName
 protectCustType
 orderInstanceCode：订单号
 productName：产品名称 businessType:业务类型  productCode:产品标识
	
 */
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row] ;
    ZJProductionVc *inP = [[ZJProductionVc alloc] init];
    inP.zjcustId = [dic objectForKey:@"custId"];
    inP.zjcustName =[dic objectForKey:@"custName"];
    [self.navigationController  pushViewController:inP animated:NO];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}


@end
