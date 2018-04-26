//
//  CY_intentVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/8.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_intentVC.h"
#import "Fx_TableView.h"
#import "UserDetailViewController.h"
#import "YixiangTableViewCell.h"
#import "YixiangDetailViewController.h"

@interface CY_intentVC (){
    
    UILabel *label;
}

@property (nonatomic,strong)Fx_TableView *intentTable;
@property (nonatomic,strong)NSMutableArray *intentArr;

@property (nonatomic,strong)NSMutableDictionary *requestDic;
@property (nonatomic,assign)NSInteger startPage;

@end

@implementation CY_intentVC

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _startPage = 1;
    _intentArr = [[NSMutableArray alloc]init];
    _requestDic =[[NSMutableDictionary alloc]init];
    [self allRequest];
    
}

-(void)leftAction:(UIButton *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addNavgationbar:@"意向客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:@"leftAction:" rightBtnAction:@"RightAction:" leftHiden:NO rightHiden:YES];
   
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
    label.text =@"共计0条";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [ToolList getColor:@"999999"];
    [bgView addSubview:label];
    
    _intentTable = [[Fx_TableView alloc]initWithFrame:CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _intentTable.dataSource = self;
    _intentTable.delegate = self;
    _intentTable.backgroundColor = [UIColor clearColor];
    [_intentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [_intentTable.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_intentTable];
}

-(void)allRequest{
    
  _requestDic[@"pageNo"]= [NSNumber numberWithInteger:_startPage];
    _requestDic[@"pagesize"]= @"10";
    
    [FX_UrlRequestManager postByUrlStr:getIntentCustSaler_url andPramas:_requestDic andDelegate:self andSuccess:@"CustSalerSuccess:" andFaild:@"CustSalerFild:" andIsNeedCookies:YES];
}

#pragma mark 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    _startPage = 1;
    [self allRequest];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    _startPage += 1;
    [self allRequest];
    
}

-(void)CustSalerSuccess:(NSDictionary *)sucDic{
    
    [_intentTable.refreshHeader endRefreshing];
    [_intentTable.refreshFooter endRefreshing];
    label.text = [NSString stringWithFormat:@"共%@条",[sucDic objectForKey:@"total"]];
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
       
        if(_startPage == 1)
        {
            [_intentArr removeAllObjects];
        }
        if([[sucDic objectForKey:@"result"] count] <= 0)
        {
           
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            [_intentTable reloadData];
        }
        else
        {
            [_intentArr addObjectsFromArray:[sucDic objectForKey:@"result"]];
            
            [_intentTable reloadData];
        }

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _intentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 105.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"YixiangTableViewCell";
    
    YixiangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell =[[[NSBundle mainBundle]loadNibNamed:@"YixiangTableViewCell" owner:self options:nil] lastObject];
        
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 104.5) toPoint:CGPointMake(__MainScreen_Width, 104.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    
    NSDictionary *dic = [_intentArr objectAtIndex:indexPath.row];
    [cell.btnImageSelect removeFromSuperview];
    cell.orderId_L.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    NSString *nameStr = [NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dic objectForKey:@"exceedTime"]],[ToolList changeNull:[dic objectForKey:@"linkmanName"]],[ToolList changeNull:[dic objectForKey:@"tel"]]];
    cell.nameL.text = nameStr;
    
    cell.addL.text = [ToolList changeNull:[dic objectForKey:@"industryName"]];
    cell.qian_Label.hidden = YES;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [_intentArr objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    s.sjFlag = @"99";
    [self.navigationController pushViewController:s animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
