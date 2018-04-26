//
//  YidongViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/4/11.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "YidongViewController.h"
#import "Fx_TableView.h"
#import "UserDetailViewController.h"
#import "ZJ_DistributionTableViewCell.h"
#import "FX_Button.h"
#import "AlertSalersViewController.h"
#import "PingdiaoListCell.h"

@interface YidongViewController ()
{
    NSMutableDictionary *requestDic;
    //释放按钮
    UIButton *shiFangBtn;
    //分配按钮
    UIButton *fenPeiBtn;
    Fx_TableView *pingdiaoTable;
    Fx_TableView *shengqianTable;
    UIView *pingdiaoView;
    UIView *shengqianView;
    NSMutableArray *shengqianDataArr;
    NSMutableArray *pingdiaoDataArr;
    NSMutableDictionary *shengqianRequestDic;
    NSMutableArray *shifangArr;
    //升迁开始页
    int shengqianStartPage;
    NSMutableArray *countIndexFlag;
    //当前显示页
    __weak IBOutlet NSLayoutConstraint *top;
    __weak IBOutlet NSLayoutConstraint *top1;
    int currentPage;
    
}
@property (weak, nonatomic) IBOutlet UIButton *pingdiaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *shengqianBtn;

@end

@implementation YidongViewController
#pragma mark - 平调点击
- (IBAction)pingdiaoClicked:(id)sender
{
    currentPage = 1;
    [self.view bringSubviewToFront:pingdiaoView];
    [_pingdiaoBtn setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
    _pingdiaoBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_shengqianBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    _shengqianBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self requestPingdiaoData];
    
}
#pragma mark - 升迁点击
- (IBAction)shengqianClicked:(id)sender
{
    currentPage = 2;
    [self.view bringSubviewToFront:shengqianView];
    [_shengqianBtn setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
    _shengqianBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_pingdiaoBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    _pingdiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self requestShengqianData];
    
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == shengqianTable)
    {
        return shengqianDataArr.count;
    }
    
    else
    {
        return pingdiaoDataArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = nil;
    if(tableView == shengqianTable)
    {
        dic = [shengqianDataArr objectAtIndex:indexPath.row];
        static NSString *cellID = @"ZJ_DistributionTableViewCell";
        ZJ_DistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ZJ_DistributionTableViewCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
        NSString *oldOrNew = [ToolList changeNull:[dic objectForKey:@"oldOrNew"]];
        NSString *exceedTime = [ToolList changeNull:[dic objectForKey:@"deptName"]];
        if([countIndexFlag indexOfObject:[NSNumber numberWithLong:indexPath.row]] == NSNotFound)
        {
            [cell.selectBtn setImage:[UIImage imageNamed:@"btn_duoxuan.png"] forState:UIControlStateNormal];
            
        }
        else
        {
            [cell.selectBtn setImage:[UIImage imageNamed:@"btn_duoxuan_s.png"] forState:UIControlStateNormal];
            
        }
        cell.labelother.text = [NSString stringWithFormat:@"%@ | 来自%@",oldOrNew,exceedTime];
        //    }
        cell.selectBtn.tag = indexPath.row;
        cell.czBlock = ^(NSDictionary * dic)
        {
            //记录状态
            if([[dic objectForKey:@"isSelect"] intValue])
            {
                //            if(countIndexFlag.count)
                //            {
                if([countIndexFlag indexOfObject:[dic objectForKey:@"index"]] == NSNotFound)
                {
                    [countIndexFlag addObject:[dic objectForKey:@"index"]];
                }
                //            }
                //            else
                //            {
                //                [countIndexFlag addObject:[dic objectForKey:@"index"]];
                //            }
            }
            else
            {
                if([countIndexFlag indexOfObject:[dic objectForKey:@"index"]] != NSNotFound)
                {
                    [countIndexFlag removeObject:[dic objectForKey:@"index"]];
                }
            }
            
            NSDictionary *dataDic = [shengqianDataArr objectAtIndex:[[dic objectForKey:@"index"] intValue]];
            if([[dic objectForKey:@"isSelect"] intValue])
            {
                if([ shifangArr indexOfObject:dataDic] == NSNotFound)
                {
                    [shifangArr addObject:dataDic];
                }
            }
            else
            {
                if([ shifangArr indexOfObject:dataDic] != NSNotFound)
                {
                    [shifangArr removeObject:dataDic];
                }
            }
            
            
        };
        return cell;
        
        
    }
    
    else
    {
        dic = [pingdiaoDataArr objectAtIndex:indexPath.row];
        static NSString *cellID = @"PingdiaoListCell";
        PingdiaoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PingdiaoListCell" owner:self options:nil] lastObject];
        }
        cell.salerName_L.text = [ToolList changeNull:[dic objectForKey:@"salerName"]];
        cell.content_L.text = [NSString stringWithFormat:@"由 %@ 至 %@",[ToolList changeNull:[dic objectForKey:@"deptNameOld"]],[ToolList changeNull:[dic objectForKey:@"deptNameNew"]]];
        cell.bhkh_L.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"protectNum"]];
        cell.zqkh_L.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"selfOrderNum"]];
        cell.fpkh_L.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"assignNum"]];
        cell.ccBlock = ^(NSString *choose)
        {
            NSMutableDictionary *reDic = [[NSMutableDictionary alloc] init];
            [reDic setObject:choose forKey:@"choose"];
            [reDic setObject:[dic objectForKey:@"salerId"] forKey:@"salerId"];
            requestDic = reDic;
            //全部带走
            if(choose.intValue == 1)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定全部带走客户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
                [alert show];
                return;
            }
            //只带自签
            else if (choose.intValue == 2)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确定只带自签客户？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
                [alert show];
                return;
            }
            
            
        };
        return cell;
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == shengqianTable)
    {
        return 85;
    }
    else
    {
        return 180;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic;
    if(tableView == shengqianTable)
    {
        dic = [shengqianDataArr objectAtIndex:indexPath.row];
        UserDetailViewController *s = [[UserDetailViewController alloc] init];
        
        s.custNameStr = [dic objectForKey:@"custName"];
        s.custId = [dic objectForKey:@"custId"];
        s.oldOrNew = [dic objectForKey:@"oldOrNew"];
        [self.navigationController pushViewController:s animated:NO];
    }
    else
    {
        //dic = [zongJianData objectAtIndex:indexPath.row];
    }
}
#pragma mark - alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //确认操作
    if(buttonIndex == 1)
    {
        [FX_UrlRequestManager postByUrlStr:EmpTurnoverChoose_url andPramas:requestDic andDelegate:self andSuccess:@"pingdiaoDoSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
}
#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(NSString *)flag
{
    //平调
    if([flag isEqualToString:@"1"])
    {
        [self requestPingdiaoData];
    }
    //升迁
    else if ([flag isEqualToString:@"2"])
    {
        shengqianStartPage = 1;
        [self requestShengqianData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
//加载更多
-(void)footerRefresh:(NSString *)flag
{
    if ([flag isEqualToString:@"1"])
    {
        [self requestPingdiaoData];
    }
    else
    {
        shengqianStartPage += 1;
        [self requestShengqianData];
    }
    
}

#pragma mark - 平调操作成功
-(void)pingdiaoDoSuccess:(NSDictionary *)dic
{
    if ([[dic objectForKey:@"code"] intValue] == 200) {
        [ToolList showRequestFaileMessageLittleTime:@"操作成功"];
        [self performSelector:@selector(requestPingdiaoData) withObject:nil afterDelay:1];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}
#pragma mark - 请求升迁列表数据成功
-(void)requestShengqianSuccess:(NSDictionary *)dic
{
    [shengqianTable.refreshHeader endRefreshing];
    [shengqianTable.refreshFooter endRefreshing];
    
    [shengqianDataArr removeAllObjects];
    
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        
        [shengqianTable reloadData];
        
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [shengqianDataArr addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [shengqianTable reloadData];
    }
    
}
#pragma mark - 请求升迁列表数据
-(void)requestShengqianData
{
    [shengqianRequestDic setObject:[NSString stringWithFormat:@"%d",shengqianStartPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:WillAssignCust_url andPramas:shengqianRequestDic andDelegate:self andSuccess:@"requestShengqianSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 请求平调列表数据
-(void)requestPingdiaoData
{
    [FX_UrlRequestManager postByUrlStr:EmpTurnover_url andPramas:nil andDelegate:self andSuccess:@"requestPingdiaoSuccess:" andFaild:nil andIsNeedCookies:NO];
    
}
#pragma mark - 请求平调列表数据成功
-(void)requestPingdiaoSuccess:(NSDictionary *)dic
{
    [pingdiaoDataArr removeAllObjects];
    
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        
        [pingdiaoTable reloadData];
        
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [pingdiaoDataArr addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [pingdiaoTable reloadData];
    }
    
}
#pragma mark - 页面和数据初始化
-(void)initView
{
#pragma mark - 数据初始化
    top.constant = IOS7_Height;
    top1.constant = IOS7_Height+4;
    shifangArr = [[NSMutableArray alloc] init];
    countIndexFlag = [[NSMutableArray alloc] init];
    shengqianDataArr = [[NSMutableArray alloc] init];
    pingdiaoDataArr = [[NSMutableArray alloc] init];
    currentPage = 1;
    shengqianStartPage = 1;
    shengqianRequestDic = [[NSMutableDictionary alloc] init];
    [shengqianRequestDic setObject:@"0" forKey:@"custSource"];
    [shengqianRequestDic setObject:[NSString stringWithFormat:@"%d",shengqianStartPage] forKey:@"pageNo"];
    [shengqianRequestDic setObject:@"10" forKey:@"pagesize"];
    
    
    
    
    //标题
    [self addNavgationbar:@"员工异动" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    //中间数据层
    pingdiaoTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    pingdiaoTable.backgroundColor = [UIColor whiteColor];
    pingdiaoTable.dataSource = self;
    pingdiaoTable.delegate = self;
    shengqianView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-45-IOS7_Height)];
    shengqianView.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:shengqianView];
    pingdiaoView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-45-IOS7_Height)];
    pingdiaoView.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:pingdiaoView];
    [pingdiaoView addSubview:pingdiaoTable];
    shengqianTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-IOS7_Height-89) style:UITableViewStylePlain isNeedRefresh:YES target:self Flag:@"2"];
    shengqianTable.backgroundColor = [UIColor whiteColor];
    shengqianTable.dataSource = self;
    shengqianTable.delegate = self;
    [shengqianTable.refreshHeader autoRefreshWhenViewDidAppear];
    [shengqianView addSubview:shengqianTable];
    //底部操作层
    UIView *doView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-IOS7_Height-88, __MainScreen_Width, 44)];
    doView.backgroundColor = [ToolList getColor:@"fafafa"];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0.8) toPoint:CGPointMake(__MainScreen_Width, 0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"释放" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, 44-1);
    [shiFangBtn addTarget:self action:@selector(shiFangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_shifang.png"] forState:UIControlStateNormal];
    [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:shiFangBtn];
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, 44-1);
    [fenPeiBtn addTarget:self action:@selector(fenPeiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
    [shengqianView addSubview:doView];
}
#pragma mark - 释放按钮点击
-(void)shiFangBtnClicked:(UIButton *)btn
{
    if(shifangArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in shifangArr) {
        [arr addObject:[dic objectForKey:@"custId"]];
    }
    [FX_UrlRequestManager postByUrlStr:ZJReleaseCust_url andPramas:[NSMutableDictionary dictionaryWithObject:arr forKey:@"custIds"] andDelegate:self andSuccess:@"shifangSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 分配按钮点击
-(void)fenPeiBtnClicked:(UIButton *)btn
{
    if(shifangArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSMutableArray *custIds = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in shifangArr) {
        NSString *custId = [dic objectForKey:@"custId"];
        [custIds addObject:custId];
    }
    AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
    dd.selectOKBlock = ^(NSString *salerId)
    {
        NSDictionary *dic  = @{@"custIds":custIds,@"assignToDeptId":salerId};
        [FX_UrlRequestManager postByUrlStr:ZJAssignCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
    };
    [self.navigationController pushViewController:dd animated:NO];
    
    
}
#pragma mark - 释放成功
-(void)shifangSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue]==200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"释放成功"];
        [countIndexFlag removeAllObjects];
        [shifangArr removeAllObjects];
        
        if(currentPage == 2)
        {
            shengqianStartPage = 1;
            [self performSelector:@selector(requestShengqianData) withObject:nil afterDelay:1];
        }
        
        else
        {
            
        }
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
    if([[dic objectForKey:@"code"] intValue] == 200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"分配成功"];
        [shifangArr removeAllObjects];
        [countIndexFlag removeAllObjects];
        switch (currentPage)
        {
                
            case 2:
            {
                shengqianStartPage = 1;
                [self performSelector:@selector(requestShengqianData) withObject:nil afterDelay:1];
            }
                break;
            default:
                break;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self requestPingdiaoData];
    
    // Do any additional setup after loading the view from its nib.
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
