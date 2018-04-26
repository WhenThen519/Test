//
//  SearchViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "SearchViewController.h"
#import "Fx_TableView.h"
#import "BuMenTableViewCell.h"
#import "UserDetailViewController.h"
#import "ZJ_DistributionTableViewCell.h"
#import "AlertSalersViewController.h"

@interface SearchViewController ()
{
    //搜索请求传参
    NSMutableDictionary *searchRequestDic;
    
    //开始数据标识
    int startPage;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
    //搜索数据列表
    Fx_TableView *searchTable;
    //数据
    NSMutableArray *dataArr;
    
    UIButton *shiFangBtn;
    UIButton *fenPeiBtn;

}
@property(nonatomic,strong)NSMutableArray *fenpeiArr;//选择分配的公司

@end

@implementation SearchViewController
#pragma mark - 页面初始化
-(void)initView
{
#pragma mark - 数据初始化
    
    startPage = 1;
   
    _fenpeiArr =[[NSMutableArray alloc]init];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 0://商务
        {
            searchRequestDic = [[NSMutableDictionary alloc] init];
            [searchRequestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
            [searchRequestDic setObject:@"10" forKey:@"pagesize"];
        }
            break;
            
        case 1://经理
        {
            
            searchRequestDic = [[NSMutableDictionary alloc] init];
            [searchRequestDic setObject:@"" forKey:@"salerId"];
            [searchRequestDic setObject:@[@"0"] forKey:@"custTypes"];
            [searchRequestDic setObject:@[@"-1"] forKey:@"intenttypes"];
            [searchRequestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
            [searchRequestDic setObject:@"10" forKey:@"pagesize"];
        }
            break;
        case 2://总监
        {
            searchRequestDic = [[NSMutableDictionary alloc] init];
            [searchRequestDic setObject:@"" forKey:@"salerId"];
            [searchRequestDic setObject:@"" forKey:@"deptId"];
            [searchRequestDic setObject:@[@"0"] forKey:@"custTypes"];
            [searchRequestDic setObject:@[@"-1"] forKey:@"intenttypes"];
            [searchRequestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
            [searchRequestDic setObject:@"10" forKey:@"pagesize"];
        }
            break;
            
            
            
        default:
            break;
    }
    
    
    dataArr = [[NSMutableArray alloc] init];
    
    //    swSearchRequestDic = [[NSMutableDictionary alloc]init];
    //    [swSearchRequestDic setObject:@"10" forKey:@"pagesize"];
    //    [swSearchRequestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    
#pragma mark - 页面初始化
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
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
    [text becomeFirstResponder];
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView addSubview:cancelSearchBtn];
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    searchTable.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height - IOS7_Height);
    searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-barHeight) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    [searchView addSubview:searchTable];
    
  
    
}
#pragma mark - 取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - 数据请求成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [searchTable.refreshHeader endRefreshing];
    [searchTable.refreshFooter endRefreshing];
    if(startPage == 1)
    {
        [dataArr removeAllObjects];
    }
    if([[resultDic objectForKey:@"result"] count] <= 0 )
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        if(startPage == 1)
        {
        [dataArr removeAllObjects];
        [searchTable reloadData];
        }
    }
    else
    {
       
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        if([[[dataArr objectAtIndex:0]allKeys] containsObject:@"flag"]){
            [self makeTabBar];
        }
        [searchTable reloadData];
    }
    
}
#pragma mark---底部操作
-(void)makeTabBar{
    
    int flatStr = [[[dataArr objectAtIndex:0] objectForKey:@"flag"] intValue];
  
    //底部操作层
    UIView *doView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-CaozuoViewHeight-barHeight, __MainScreen_Width, CaozuoViewHeight)];
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
   
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    if (flatStr ==1) {//签约客户
         fenPeiBtn.frame = CGRectMake(0, 1, __MainScreen_Width, CaozuoViewHeight-1);
    }else{
        
         fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
         [doView addSubview:shiFangBtn];
    }
   
    [fenPeiBtn addTarget:self action:@selector(fenPeiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
     [self.view addSubview:doView];
}
#pragma mark - 释放按钮点击
-(void)shiFangBtnClicked:(UIButton *)btn
{
    if(_fenpeiArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSNumber *num in _fenpeiArr) {
        NSDictionary *dic = [dataArr objectAtIndex:[num intValue]];
        NSString *custId = [dic objectForKey:@"custId"];
        [arr addObject:custId];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        
        [FX_UrlRequestManager postByUrlStr:ZJReleaseCust_url andPramas:[NSMutableDictionary dictionaryWithObject:arr forKey:@"custIds"] andDelegate:self andSuccess:@"shifangSuccess:" andFaild:nil andIsNeedCookies:YES];
    }

    
}
#pragma mark - 释放成功
-(void)shifangSuccess:(NSDictionary *)dic
{
    [_fenpeiArr removeAllObjects];
    
    if([[dic objectForKey:@"code"] intValue]==200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"释放成功"];
       [self.navigationController popViewControllerAnimated:YES];
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
    [_fenpeiArr removeAllObjects];
  
    if([[dic objectForKey:@"code"] intValue] == 200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"分配成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
       }
        
}
#pragma mark - 分配按钮点击
-(void)fenPeiBtnClicked:(UIButton *)btn
{
    if(_fenpeiArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSMutableArray *custIds = [[NSMutableArray alloc] init];
    
    for (NSNumber *num in _fenpeiArr) {
        NSDictionary *dic = [dataArr objectAtIndex:[num intValue]];
        NSString *custId = [dic objectForKey:@"custId"];
        [custIds addObject:custId];
    }
        
        AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
        dd.selectOKBlock = ^(NSString *salerId)
        {
//            NSDictionary *dic  = @{@"custIds":custIds,@"assignToDeptId":salerId};
//            [FX_UrlRequestManager postByUrlStr:ZJAssignCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
            
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
                NSDictionary *dic  = @{@"custIds":custIds,@"assignToDeptId":salerId};
                
                [FX_UrlRequestManager postByUrlStr:ZJAssignCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
            }
            
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
                NSDictionary *requestD = @{@"custIds":custIds,@"assignToSalerId":salerId};
                [FX_UrlRequestManager postByUrlStr:AssignCustToSaler_url andPramas:[NSMutableDictionary dictionaryWithDictionary:requestD] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
            }
        };
    
        [_fenpeiArr removeAllObjects];
        [self.navigationController pushViewController:dd animated:NO];

    
  
 
    
}


#pragma mark - 数据请求
-(void) requestAlldata
{
    
    [searchRequestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 0://商务
        {
            if (_type.length) {
                
                [FX_UrlRequestManager postByUrlStr:vagueSearch_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
                
            }else{
                [FX_UrlRequestManager postByUrlStr:SwCustM_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            }
            
            
        }
            break;
            
        case 1://经理
        {
            if (_swSearchRequestDic) {
                
                [FX_UrlRequestManager postByUrlStr:WillAssignCustByCustName_url andPramas:_swSearchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            }else{
                [FX_UrlRequestManager postByUrlStr:DeptCustM_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            }
        }
            break;
        case 2://总监
        {
            if (_swSearchRequestDic) {
                 [FX_UrlRequestManager postByUrlStr:WillAssignCustByCustName1_url andPramas:_swSearchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            }else{
                [FX_UrlRequestManager postByUrlStr:SubCust_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            }
        }
            break;
            
            
            
        default:
            break;
    }
    
    
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
#pragma mark - 搜索按钮点击
-(void)searchClicked:(UIButton *)btn
{
    text.text = @"";
    [text becomeFirstResponder];
    searchTable.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    if (_swSearchRequestDic) {
        [_swSearchRequestDic setObject:theTextField.text forKey:@"custName"];
    }else{
         [searchRequestDic setObject:theTextField.text forKey:@"custName"];
        if (_type.length) {
          [searchRequestDic setObject:_type forKey:@"type"];
        }
    }
   
    startPage = 1;
    [self requestAlldata];
    return YES;
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_swSearchRequestDic) {
        
        static NSString *cellID = @"ZJ_DistributionTableViewCell";
        ZJ_DistributionTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell2==nil)
        {
            cell2 = [[[NSBundle mainBundle] loadNibNamed:@"ZJ_DistributionTableViewCell" owner:self options:nil] lastObject];
            //线
            [cell2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }

       NSDictionary *dic2 = [dataArr objectAtIndex:indexPath.row];
    
        cell2.nameLabel.text = [ToolList changeNull:[dic2 objectForKey:@"custName"]];
        NSString *oldOrNew = [ToolList changeNull:[dic2 objectForKey:@"oldOrNew"]];
        NSString *exceedTime = [ToolList changeNull:[dic2 objectForKey:@"deptName"]];
          cell2.labelother.text = [NSString stringWithFormat:@"%@ | %@",oldOrNew,exceedTime];
        
        cell2.czBlock = ^(NSDictionary * dicc){
           
            if ([[dicc objectForKey:@"isSelect"] integerValue]) {
                [_fenpeiArr addObject:[dicc objectForKey:@"index"]];
            }else{
                [_fenpeiArr removeObject:[dicc objectForKey:@"index"]];
            }
                
        };
        return cell2;
    }
    
    static NSString *cellID = @"BuMenTableViewCell";
    BuMenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuMenTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 0://商务
        {
            
            NSString *str = [NSString stringWithFormat:@"%@ | %@" ,[dic objectForKey:@"custVirtualType"],[dic objectForKey:@"intenttype"]];
            
            cell.labelother.text = str;
        }
            break;
            
        case 1://经理
        {
            
            
            NSString *str = [NSString stringWithFormat:@"%@ | %@ | %@" ,[dic objectForKey:@"salerName"],[dic objectForKey:@"custVirtualType"],[dic objectForKey:@"intenttype"]];
            
            
            cell.labelother.text = str;
        }
            break;
        case 2://总监
        {
            NSString *str = [NSString stringWithFormat:@"%@ | %@ | %@ | %@" ,[dic objectForKey:@"deptName"],[dic objectForKey:@"salerName"],[dic objectForKey:@"custVirtualType"],[dic objectForKey:@"intenttype"]];
            
            
            cell.labelother.text = str;
        }
            break;
            
            
            
        default:
            break;
    }
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isMyclient) {
        
        NSDictionary *dataDic = [dataArr objectAtIndex:indexPath.row];
        if ([[dataDic objectForKey:@"custId"]length]) {
            
            UserDetailViewController *userV = [[UserDetailViewController alloc]initwithCust:[dataDic objectForKey:@"custId"]];
            userV.custNameStr = [dataDic objectForKey:@"custName"];
            [self.navigationController pushViewController:userV animated:NO];
        }
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"custId"],@"castid",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"custName"],@"castname", nil];
        self.czBlock(dic);
        [self .navigationController popViewControllerAnimated:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
  
}

-(void)backOk{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    if (_isMyclient){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backOk) name:@"myClientV" object:nil];
    }
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
