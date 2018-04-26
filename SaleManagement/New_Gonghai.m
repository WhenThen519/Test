//
//  New_Gonghai.m
//  SaleManagement
//
//  Created by feixiang on 2017/2/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "New_Gonghai.h"
#import "AppDelegate.h"

#import "Fx_TableView.h"
#import "GonghaiTableViewCell.h"
#import "Select.h"
#import "CY_Business.h"
@interface New_Gonghai ()
{
    //方案
    __weak IBOutlet NSLayoutConstraint *top1;
    NSArray *planList;
    NSDictionary *mainDic;
    __weak IBOutlet NSLayoutConstraint *top2;
    
    //是否选20条
    BOOL isSelect20;
    NSIndexPath *index ;
    //筛选内容
    UIScrollView *selectDiQuContentView;
    NSMutableArray* countIndexFlag;
    Select *selectView ;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
    //数据列表
    Fx_TableView *table;
    //底部操作层
    UIView *doView;
    //数据
    NSMutableArray *dataArr;
    
    //筛选条件请求传参
    NSMutableDictionary *requestDic;
    NSMutableDictionary *searchRequestDic;
    
    //开始数据标识
    int startPage;
    //请求传参
    NSMutableArray *selectArr;
    NSMutableArray *fanganArr;

    UIButton *shiFangBtn;
    UIButton *fenPeiBtn;
    UIView *fangAnView;
    UIView *vvv;
    BOOL isFangAnRequest;
}
@property(nonatomic,strong)NSArray *listArr;
@property (nonatomic,assign)BOOL isSearch;//no列表刷新，其他为

@end

@implementation New_Gonghai
- (void)otherBtnClicked {
    _isSearch = NO;
    isFangAnRequest = NO;
        selectView.btn2.hidden = NO;
        selectView.btn3.hidden = NO;
        selectView.btn4.hidden = NO;
        selectView.btn5.hidden = NO;
        selectView.btn6.hidden = NO;
        selectView.btn7.hidden = NO;
        selectView.hide1.hidden = NO;
        selectView.baidu.hidden = NO;
        selectView.ICP.hidden = NO;
        selectView.btn_h2.constant = 54;
        selectView.btn_h3.constant = 54;
        selectView.btn_h4.constant = 54;
        selectView.btn_h5.constant = 54;
        selectView.btn_h6.constant = 54;
        selectView.btn_h7.constant = 54;
        selectView.baidu_h.constant = 54;
        selectView.ICP_h.constant = 54;
        selectView.h_8.constant = 54;
    

        
    
}

#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if(flagNeedReload)
    //    {
    //        return dataArr.count;
    //    }
    //    else
    //    {
    //        return dataSearchArr.count;
    //    }
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GonghaiTableViewCell";
    GonghaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dic =  [dataArr objectAtIndex:indexPath.row];

    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GonghaiTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 101.5) toPoint:CGPointMake(__MainScreen_Width, 101.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        
    }
    cell.selectBtn.tag = indexPath.row;
    
    cell.czBlock = ^(NSDictionary * dicc)
    { //记录状态
        if([[dicc objectForKey:@"isSelect"] intValue])
        {
            if(countIndexFlag.count)
            {
                if([countIndexFlag indexOfObject:[dicc objectForKey:@"index"]] == NSNotFound)
                {
                    if(countIndexFlag.count==50)
                    {
                        [ToolList showRequestFaileMessageLittleTime:@"最多选50条"];
                            [cell.selectBtn setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [countIndexFlag addObject:[dicc objectForKey:@"index"]];
  
                    }
                }
            }
            else
            {
                [countIndexFlag addObject:[dicc objectForKey:@"index"]];
            }
        }
        else
        {
            
            if([countIndexFlag indexOfObject:[dicc objectForKey:@"index"]] != NSNotFound)
            {
                [countIndexFlag removeObject:[dicc objectForKey:@"index"]];
            }
        }
        
        
    
        if(countIndexFlag.count)
        {
            doView.hidden = NO;
        }
        else
        {
            doView.hidden = YES;
        }
        
    };


    
        cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
        cell.addL.text = [NSString stringWithFormat:@"%@万元 | %@ 人 ",[dic objectForKey:@"custRegisterMoney"],[dic objectForKey:@"custRegisterPeopleNumberType"]];
        cell.addl2.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"industryClassBig"],[dic objectForKey:@"custAddress"]];
        if([[dic objectForKey:@"homepageHint"] intValue]==0)
        {
            cell.guan.hidden = YES;
        }
    else
    {
        cell.guan.hidden = NO;
 
    }
        if([[dic objectForKey:@"releaseCount"] intValue]!=0)
        {
            cell.xin.layer.cornerRadius = 4;
            cell.xin.layer.masksToBounds = YES;
            [cell.xin setBackgroundImage:nil forState:UIControlStateNormal];

            [cell.xin setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"releaseCount"]] forState:UIControlStateNormal];
            [cell.xin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.xin.titleLabel.font = [UIFont systemFontOfSize:8];
        }
    else
    {
        [cell.xin setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
    }
        if([[dic objectForKey:@"channelNumber"] intValue]==0)
        {
            cell.tui.hidden = YES;
        }
    else
    {
        cell.tui.hidden = NO;
 
    }
    
    if([countIndexFlag indexOfObject:[NSNumber numberWithLong:indexPath.row]] == NSNotFound)
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
        
    }
    if(!_isS)
    {
        cell.selectBtn.hidden = YES;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSDictionary *dic;
    //    if(flagNeedReload)
    //    {
    //        dic = [dataArr objectAtIndex:indexPath.row];
    //    }
    //    else
    //    {
    //        dic = [dataSearchArr objectAtIndex:indexPath.row];
    //    }    if([[ToolList changeNull:[dic objectForKey:@"recommendFlag"]] intValue] != 1)
    //    {
    //        cellDemo = [tableView cellForRowAtIndexPath:indexPath];
    //        index = indexPath;
    //        if(flagNeedReload)
    //        {
    //            [FX_UrlRequestManager postByUrlStr:Recommend_url andPramas:[NSMutableDictionary dictionaryWithObject:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"custId"] forKey:@"custId"] andDelegate:self andSuccess:@"doZanSuccess:" andFaild:nil andIsNeedCookies:YES];
    //        }
    //        else
    //        {
    //            [FX_UrlRequestManager postByUrlStr:Recommend_url andPramas:[NSMutableDictionary dictionaryWithObject:[[dataSearchArr objectAtIndex:indexPath.row] objectForKey:@"custId"] forKey:@"custId"] andDelegate:self andSuccess:@"doZanSuccess:" andFaild:nil andIsNeedCookies:YES];
    //        }
    //    }
    
    
}
#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    _selectALLBtn.userInteractionEnabled = NO;
    startPage = 1;
    _isSearch = YES;
    [self request_search];
    return YES;
}

-(void)request_search{
    
    NSMutableDictionary *dicc = [[NSMutableDictionary alloc]init];

    dicc[@"custName"]=text.text;
    dicc[@"pageNo"]=[NSNumber numberWithInt:startPage];
    dicc[@"pagesize"]=[NSNumber numberWithInteger:10];//
    
    [FX_UrlRequestManager postByUrlStr:salerPublicDataSearch_url andPramas:dicc andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    top2.constant = IOS7_Height;
    top1.constant = IOS7_Height;
    if(!_isS)
    {
        _selectALLBtn.hidden = YES;
    }
    _listArr = [[NSArray alloc]init];
    //数据初始化
    isSelect20 = NO;
    dataArr = [[NSMutableArray alloc] init];
    fanganArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"" forKey:@"custName"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"50" forKey:@"pagesize"];
    [requestDic setObject:@"" forKey:@"custAddressProvince"];
    [requestDic setObject:@"" forKey:@"custAddressCity"];
    [requestDic setObject:@"" forKey:@"custAddressRegion"];
    [requestDic setObject:@"" forKey:@"industryClassBig"];
    [requestDic setObject:@"" forKey:@"custRegisterPeopleNumberType"];
    [requestDic setObject:@"3" forKey:@"homepageHint"];
    [requestDic setObject:@"" forKey:@"custRegisterMoneyType"];
    [requestDic setObject:@"3" forKey:@"channelNumber"];
    [requestDic setObject:@"" forKey:@"createTime"];
    [requestDic setObject:@"3" forKey:@"isNewCust"];
    [requestDic setObject:@"" forKey:@"channelDetail"];
    [requestDic setObject:[NSNumber numberWithInt:1] forKey:@"type"];
    countIndexFlag = [[NSMutableArray alloc] init];
    //标题
    [self addNavgationbar:@"公海客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    table.dataSource = self;
    table.delegate = self;
    [table.refreshHeader autoRefreshWhenViewDidAppear];
    
    [self.view addSubview:table];
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __MainScreen_Height)];
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
    
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView addSubview:cancelSearchBtn];
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
    //底部操作层
    doView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-CaozuoViewHeight, __MainScreen_Width, CaozuoViewHeight)];
    doView.backgroundColor = [ToolList getColor:@"fafafa"];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0.8) toPoint:CGPointMake(__MainScreen_Width, 0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"保护" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [shiFangBtn addTarget:self action:@selector(baoHuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_shifang.png"] forState:UIControlStateNormal];
    [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:shiFangBtn];
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"收藏" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [fenPeiBtn addTarget:self action:@selector(shouCangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
    [self.view addSubview:doView];
    doView.hidden = YES;
    [self.view addSubview:searchView];
    
    startPage = 1;
    [self requestAlldata];
    
    [self getMarket];
}

#pragma mark---公海专属市场和共享市场筛选项请求
-(void)getMarket{
    
      [FX_UrlRequestManager postByUrlStr:getMarket_url andPramas:nil andDelegate:self andSuccess:@"getMarketSuccess:" andFaild:nil andIsNeedCookies:NO];
}

-(void)getMarketSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue]==200) {
        _listArr =[sucDic objectForKey:@"result"];
    }
}

#pragma mark - 保护操作
-(void)baoHuBtnClicked:(UIButton *)btn
{
    if(countIndexFlag.count == 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"请选择一个客户"];
        return;
    }
    if(countIndexFlag.count > 1)
    {
        [ToolList showRequestFaileMessageLittleTime:@"只能选择一个客户"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSNumber *n in countIndexFlag) {
        NSDictionary *dic = [dataArr objectAtIndex:[n intValue]];
        [str appendString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"custId"]]];
    }
    dic[@"custId"]=str;
    dic[@"custType"]=@"2";
    
  
        [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dic andDelegate:self andSuccess:@"getCustSuccess:" andFaild:nil andIsNeedCookies:YES];
    [countIndexFlag removeAllObjects];
    [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20_N.png"] forState:UIControlStateNormal];
    doView.hidden = YES;
    isSelect20 = NO;
    
    
}
-(void)getCustSuccess:(NSDictionary *)dic
{
    [countIndexFlag removeAllObjects];
    isSelect20 = NO;
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custName"];
    [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20_N.png"] forState:UIControlStateNormal];
    _selectALLBtn.userInteractionEnabled = YES;
    doView.hidden = YES;
    startPage = 1;
    [self requestAlldata];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
//    AppDelegate *APdelegate =[UIApplication sharedApplication].delegate;
//    CY_Business *businessVc = [[CY_Business alloc]init];
//    UINavigationController *mainVC = [[UINavigationController alloc]initWithRootViewController:businessVc];
//    mainVC.navigationBarHidden = YES;
//    businessVc.automaticallyAdjustsScrollViewInsets = NO;
//    APdelegate.window.rootViewController = mainVC;
}
#pragma mark - 收藏操作
-(void)shouCangBtnClicked:(UIButton *)btn
{
    if(countIndexFlag.count == 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"请选择一个客户"];
        return;
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSNumber *n in countIndexFlag) {
      if([n intValue] < dataArr.count)
      {
        NSDictionary *dic = [dataArr objectAtIndex:[n intValue]];
            [str appendString:[NSString stringWithFormat:@"%@,",[dic objectForKey:@"custId"]]];
    }
        else
        {
            [countIndexFlag removeObject:n];
        }
    
        
    }
    dic[@"custId"]=str;
    dic[@"custType"]=@"1";
    
    
    [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dic andDelegate:self andSuccess:@"getCustSuccess:" andFaild:nil andIsNeedCookies:YES];
    [countIndexFlag removeAllObjects];
    [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20_N.png"] forState:UIControlStateNormal];
    isSelect20 = NO;
    startPage = 1;
    doView.hidden = YES;
    [self requestAlldata];
}
#pragma mark - 公海搜索
-(void)searchClicked:(UIButton *)sender
{
    text.text = @"";
    [requestDic setObject:@"" forKey:@"custAddressProvince"];
    [requestDic setObject:@"" forKey:@"custAddressCity"];
    [requestDic setObject:@"" forKey:@"custAddressRegion"];
    [requestDic setObject:@"" forKey:@"industryClassBig"];
    [requestDic setObject:@"" forKey:@"custRegisterPeopleNumberType"];
    [requestDic setObject:@"3" forKey:@"homepageHint"];
    [requestDic setObject:@"" forKey:@"custRegisterMoneyType"];
    [requestDic setObject:@"3" forKey:@"channelNumber"];
    [requestDic setObject:@"" forKey:@"createTime"];
    [requestDic setObject:@"3" forKey:@"isNewCust"];
    
    startPage = 1;
    [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20_N.png"] forState:UIControlStateNormal];
    isSelect20 = NO;
    _selectALLBtn.userInteractionEnabled = NO;
    [countIndexFlag removeAllObjects];
    [text becomeFirstResponder];
    if(fangAnView)
    {
        [fangAnView removeFromSuperview];
        fangAnView = nil;
    }
    if(selectView)
    {
        [selectView removeFromSuperview];
        selectView = nil;
    }
    if(vvv)
    {
        [vvv removeFromSuperview];
        vvv = nil;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark - 公海取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custName"];
    _selectALLBtn.userInteractionEnabled = YES;
    [text resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    startPage = 1;
    if (_isSearch) {
        
        [self request_search];
        return;
    }
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    startPage += 1;
    if (_isSearch) {
        
        [self request_search];
        return;
    }
     [self requestAlldata];
    
}
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    [requestDic setObject:@"" forKey:@"custName"];
    //    [self requestAlldata];
    [text resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];

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
          
            [table reloadData];
        
        }
    }
    else
    {
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
  
        [table reloadData];
   
    }
    
}
-(void) requestAlldata
{
    
     _isSearch = NO;
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:zjgonghaiList_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    //salerPublicDataSearch_url
    
    
}
#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    NSDictionary *receiveDic;
    if([str isEqualToString:@"shi"])
    {
     
            for (FX_Button *bt in fanganArr)
            {
                if( btn==bt)
                {
                    [bt changeColorCliked1:YES];
                }
                else
                {
                    [bt changeColorCliked1:NO];
                    
                }
                
            }
        
        if([[dic1 objectForKey:@"name"] isEqualToString:@"方案一"])
        {
            isFangAnRequest = YES;
            receiveDic = [planList objectAtIndex:0];
            selectView.otherBtn.hidden = NO;
            selectView.otherBtn_h.constant = 54;
            [selectView.otherBtn setTitle:@"农林牧渔业/制造业+注册资金大于100万+无官网+无推广" forState:UIControlStateNormal];
                }
        else if ([[dic1 objectForKey:@"name"] isEqualToString:@"方案二"])
        {
            isFangAnRequest = YES;

            receiveDic = [planList objectAtIndex:1];
            selectView.otherBtn.hidden = NO;
            selectView.otherBtn_h.constant = 54;
            [selectView.otherBtn setTitle:@"农林牧渔业/制造业+注册资金大于100万+有官网+无推广" forState:UIControlStateNormal];
        }
        else if ([[dic1 objectForKey:@"name"] isEqualToString:@"方案三"])

        {
            isFangAnRequest = YES;

            receiveDic = [planList objectAtIndex:2];
            selectView.otherBtn.hidden = NO;
            selectView.otherBtn_h.constant = 54;
            [selectView.otherBtn setTitle:@"农林牧渔业/制造业+注册资金大于100万+有官网+有推广" forState:UIControlStateNormal];
        }
        else
        {
            
            [requestDic setObject:@"" forKey:@"channelDetail"];

            [requestDic setObject:@"" forKey:@"custName"];
            [requestDic setObject:@"1" forKey:@"pageNo"];
            [requestDic setObject:@"50" forKey:@"pagesize"];
            [requestDic setObject:@"" forKey:@"custAddressProvince"];
            [requestDic setObject:@"" forKey:@"custAddressCity"];
            [requestDic setObject:@"" forKey:@"custAddressRegion"];
            [requestDic setObject:@"" forKey:@"industryClassBig"];
            [requestDic setObject:@"" forKey:@"custRegisterPeopleNumberType"];
            [requestDic setObject:@"3" forKey:@"homepageHint"];
            [requestDic setObject:@"" forKey:@"custRegisterMoneyType"];
            [requestDic setObject:@"3" forKey:@"channelNumber"];
            [requestDic setObject:@"" forKey:@"createTime"];
            [requestDic setObject:@"3" forKey:@"isNewCust"];
            selectView.otherBtn.hidden = YES;
            selectView.otherBtn_h.constant = 0;
            [self otherBtnClicked];
            return;
        }
        [requestDic setObject:@"" forKey:@"custName"];
        [requestDic setObject:@"" forKey:@"channelDetail"];

        [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
        [requestDic setObject:@"50" forKey:@"pagesize"];
        [requestDic setObject:@"" forKey:@"custAddressProvince"];
        [requestDic setObject:@"" forKey:@"custAddressCity"];
        [requestDic setObject:@"" forKey:@"custAddressRegion"];
        [requestDic setObject:@"" forKey:@"custRegisterPeopleNumberType"];
        if([[receiveDic objectForKey:@"channelNumber"] intValue] == 2)
        {
         [requestDic setObject:@"0" forKey:@"channelNumber"];
        }
        else
        {
         [requestDic setObject:[NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"channelNumber"]] forKey:@"channelNumber"];
        }
        if([[receiveDic objectForKey:@"homepageHint"] intValue] == 2)
        {
            [requestDic setObject:@"0" forKey:@"homepageHint"];
        }
        else
        {
        [requestDic setObject:[NSString stringWithFormat:@"%@",[receiveDic objectForKey:@"homepageHint"]] forKey:@"homepageHint"];
        }
        NSArray *custRegisterMoneyTypes = [mainDic objectForKey:@"registerMoney"];
        NSMutableString *custRegisterMoneyType = [[NSMutableString alloc] init];
        for (NSNumber *num in [receiveDic objectForKey:@"custRegisterMoneyType"])
        {
            NSDictionary *myDic = [custRegisterMoneyTypes objectAtIndex:num.intValue];
            [custRegisterMoneyType appendString:[NSString stringWithFormat:@"%@,",[myDic objectForKey:@"id"]]];
            
        }
        [requestDic setObject:custRegisterMoneyType forKey:@"custRegisterMoneyType"];
        
        
        NSArray *industryclassBigs = [mainDic objectForKey:@"industryclassBig"];
        NSMutableString *industryclassBig = [[NSMutableString alloc] init];
        for (NSNumber *num in [receiveDic objectForKey:@"industryClassBig"])
        {
            NSDictionary *myDic = [industryclassBigs objectAtIndex:num.intValue];
            [industryclassBig appendString:[NSString stringWithFormat:@"%@,",[myDic objectForKey:@"id"]]];
            
        }
        [requestDic setObject:industryclassBig forKey:@"industryClassBig"];
        
        
        [requestDic setObject:@"" forKey:@"createTime"];
        [requestDic setObject:@"3" forKey:@"isNewCust"];

        selectView.btn2.hidden = YES;
        selectView.btn3.hidden = YES;
        selectView.btn4.hidden = YES;
        selectView.btn5.hidden = YES;
        selectView.btn6.hidden = YES;
        selectView.btn7.hidden = YES;
        selectView.hide1.hidden = YES;
        selectView.baidu.hidden = YES;
        selectView.ICP.hidden = YES;
        selectView.view2.hidden = YES;
        selectView.h2.constant = 0;
        selectView.btn_h2.constant = 0;
        selectView.btn_h3.constant = 0;
        selectView.btn_h4.constant = 0;
        selectView.btn_h5.constant = 0;
        selectView.btn_h6.constant = 0;
        selectView.btn_h7.constant = 0;
        selectView.baidu_h.constant = 0;
        selectView.ICP_h.constant = 0;
        selectView.h_8.constant = 0;
        selectView.view7.hidden = YES;
        selectView.h7.constant = 0;
        selectView.tuiSubView.hidden = YES;
        selectView.tuiSubView_h.constant = 0;

    }
}

#pragma mark - 筛选创建
-(void)initSelectView:(NSDictionary *)dicF
{
    [requestDic setObject:@"" forKey:@"custName"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"50" forKey:@"pagesize"];
    [requestDic setObject:@"" forKey:@"custAddressProvince"];
    [requestDic setObject:@"" forKey:@"custAddressCity"];
    [requestDic setObject:@"" forKey:@"custAddressRegion"];
    [requestDic setObject:@"" forKey:@"industryClassBig"];
    [requestDic setObject:@"" forKey:@"custRegisterPeopleNumberType"];
    [requestDic setObject:@"3" forKey:@"homepageHint"];
    [requestDic setObject:@"" forKey:@"custRegisterMoneyType"];
    [requestDic setObject:@"3" forKey:@"channelNumber"];
    [requestDic setObject:@"" forKey:@"createTime"];
    [requestDic setObject:@"3" forKey:@"isNewCust"];
    [fanganArr removeAllObjects];
    if(fangAnView)
    {
        [fangAnView removeFromSuperview];
        fangAnView = nil;
    }
    if(selectView)
    {
        [selectView removeFromSuperview];
        selectView = nil;
    }
if(vvv)
{
    [vvv removeFromSuperview];
    vvv = nil;
}
    vvv =  [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, 99)];
    vvv.backgroundColor = [ToolList getColor:@"f2f3f5"];
    fangAnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 98)];
    fangAnView.backgroundColor = [UIColor whiteColor];
    [vvv addSubview:fangAnView];
    self.view.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:vvv];
    float btnW = (__MainScreen_Width-50)/4.;
    NSArray *an = @[@{@"name":@"方案一"},@{@"name":@"方案一"},@{@"name":@"方案二"},@{@"name":@"方案三"},@{@"name":@"自定义筛选"}];
    for (int i = 0; i < an.count; i ++) {
        if(i != 0)
        {
        NSDictionary *dic = [an objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(i%4*(btnW+10)-10 ,10+i/4*(54), btnW, 34) andType:@"12" andTitle:@"shi" andTarget:self andDic:dic];
        [fangAnView addSubview:btn];
            [fanganArr addObject:btn];
            if(i == 4)
            {
                btn.frame = CGRectMake((btnW) ,i/4*(54), 100, 34);
            }
        }
        else
        {
            UILabel * btn = [[UILabel alloc] initWithFrame:CGRectMake(10 ,0, btnW, 54) ];
            btn.font = [UIFont systemFontOfSize:16];
            btn.textAlignment = NSTextAlignmentLeft;
            btn.textColor = [ToolList getColor:@"666666"];
            btn.text = @"方案:";
            [fangAnView addSubview:btn];
        }
    }
    
    selectView = [[[NSBundle mainBundle] loadNibNamed:@"Select" owner:self options:nil] lastObject];
    selectView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight+99, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height-99);

    planList = [dicF objectForKey:@"planList"];
    selectView.createTime = [dicF objectForKey:@"createTime"];
    selectView.industryclassBig = [dicF objectForKey:@"industryclassBig"];
    selectView.registerMoney = [dicF objectForKey:@"registerMoney"];
    selectView.registerPeopleNum = [dicF objectForKey:@"registerPeopleNum"];
    selectView.icpDateFilter = [dicF objectForKey:@"icpDateFilter"];
    selectView.channeList = [dicF objectForKey:@"channeList"];
    selectView.baiduExponent = [dicF objectForKey:@"baiduExponent"];
    selectView.markets = _listArr;
    [selectView createView];
    selectView.btn2.hidden = YES;
    selectView.btn3.hidden = YES;
    selectView.btn4.hidden = YES;
    selectView.btn5.hidden = YES;
    selectView.btn6.hidden = YES;
    selectView.btn7.hidden = YES;
    selectView.hide1.hidden = YES;
    selectView.baidu.hidden = YES;
    selectView.ICP.hidden = YES;
    selectView.otherBtn.hidden = YES;
    selectView.otherBtn_h.constant = 0;
    selectView.btn_h2.constant = 0;
    selectView.btn_h3.constant = 0;
    selectView.btn_h4.constant = 0;
    selectView.btn_h5.constant = 0;
    selectView.btn_h6.constant = 0;
    selectView.btn_h7.constant = 0;
    selectView.baidu_h.constant = 0;
    selectView.ICP_h.constant = 0;
    selectView.h_8.constant = 0;

selectView.czDicBlock = ^(NSDictionary *dic)
    {
        if(vvv)
        {
        [ vvv removeFromSuperview];
        }
//        if(isFangAnRequest)
//        {
//        }
//        else
//        {
            [requestDic setValuesForKeysWithDictionary:dic];
  
//        }
        startPage = 1;
        
        [self requestAlldata];

    };
    
    
    
    [self.view addSubview:selectView];
}
-(void)requestSelectSuccess:(NSDictionary *)dictionary
{
    mainDic = [dictionary objectForKey:@"result"];

    [self initSelectView:mainDic];
}
-(void)requestSelect
{
     [FX_UrlRequestManager postByUrlStr:SWfilterData_url andPramas:requestDic andDelegate:self andSuccess:@"requestSelectSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 筛选按钮点击
- (IBAction)selectBtnClicked:(id)sender {
    [countIndexFlag removeAllObjects];
    UIButton *bt = (UIButton *)sender;
    bt.selected = ! bt.selected;
    if ( bt.selected) {
         [self requestSelect];
    }else{
        if(fangAnView)
        {
            [fangAnView removeFromSuperview];
            fangAnView = nil;
        }
        if(selectView)
        {
            [selectView removeFromSuperview];
            selectView = nil;
        }
        if(vvv)
        {
            [vvv removeFromSuperview];
            vvv = nil;
        }
    }
   


  
}
#pragma mark - 筛选20按钮点击
- (IBAction)select20BtnClicked:(id)sender {
    [countIndexFlag removeAllObjects];
    isSelect20 = !isSelect20;
    if(isSelect20)
    {
        if(dataArr.count < 50)
        {
            [ToolList showRequestFaileMessageLittleTime:@"暂无50条数据可供选择"];
            isSelect20 = !isSelect20;
            return;
        }
        else
        {
            for (int i = 0; i < 50; i ++) {
                [countIndexFlag addObject:[NSNumber numberWithInt:i]];
            }
        }
        doView.hidden = NO;
        [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20.png"] forState:UIControlStateNormal];

    }
    else
    {
        isSelect20 = NO;
        [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20_N.png"] forState:UIControlStateNormal];
        doView.hidden = YES;

    }
    [_selectALLBtn setTitle:@"选择50条" forState:UIControlStateNormal];
    [table reloadData];
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
