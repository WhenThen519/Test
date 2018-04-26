//
//  New_Gonghai.m
//  SaleManagement
//
//  Created by feixiang on 2017/2/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "SJFP.h"
#import "Fx_TableView.h"
#import "SJFPCell.h"
#import "Select.h"
@interface SJFP ()
{
    __weak IBOutlet NSLayoutConstraint *top1;
    NSString *khlx;
    NSString *sw;
    __weak IBOutlet NSLayoutConstraint *top2;
    NSString *bm;
    int a;
    UIButton *btnCommit;
    //是否选20条
    BOOL isSelect20;
    NSIndexPath *index ;
    //筛选内容
    UIScrollView *selectDiQuContentView;
    NSMutableArray* countIndexFlag;
    Select *selectView ;
    NSMutableArray *selectArr;
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
    NSMutableArray *selectBtnArr;
    UIButton *fenPeiBtn;
    NSArray *jieduanArr;
    UIScrollView *selectContentScrollView;
    
}
@end

@implementation SJFP
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
    static NSString *cellID = @"SJFPCell";
    SJFPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dic =  [dataArr objectAtIndex:indexPath.row];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SJFPCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 69.5) toPoint:CGPointMake(__MainScreen_Width, 69.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        
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
                    if(countIndexFlag.count==20)
                    {
                        [ToolList showRequestFaileMessageLittleTime:@"最多选20条"];
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
        
        
        
        
    };
    
    
    
    cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    cell.addL.text = [dic objectForKey:@"oldOrNew"];
    
    if([countIndexFlag indexOfObject:[NSNumber numberWithLong:indexPath.row]] == NSNotFound)
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
        
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    [requestDic setObject:theTextField.text forKey:@"custName"];
    startPage = 1;
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        [FX_UrlRequestManager postByUrlStr:jl_sou_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }else{
        
        [FX_UrlRequestManager postByUrlStr:ZJ_sou_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    [requestDic setObject:@"" forKey:@"custName"];

    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    
    //状态
    if([str isEqualToString:@"客户类型"])
    {
        if(btn.isSelect)
        {
            khlx = [[dic1 allKeys]lastObject];
            for (FX_Button *btnS in selectBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            
        }
        else
        {
            khlx = @"";
        }
    }
    else if ([str isEqualToString:@"商务"])
    {
        if(btn.isSelect)
        {
            sw = [dic1 objectForKey:@"salerId"];
            for (FX_Button *btnS in selectBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            
        }
        else
        {
            sw = @"";
        }
        
    }
    else
    {
        if(btn.isSelect)
        {
            bm = [dic1 objectForKey:@"deptId"];
            for (FX_Button *btnS in selectBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            
        }
        else
        {
            bm = @"";
        }
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    top1.constant = IOS7_Height;
    top2.constant = IOS7_Height;
    khlx = @"-1";
    sw = @"";
    bm = @"";
    jieduanArr = @[@{@"-1":@"不限"},@{@"1":@"网站客户"},@{@"0":@"非网站客户"}];
    selectBtnArr = [[NSMutableArray alloc] init];
    //数据初始化
    isSelect20 = NO;
    dataArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"" forKey:@"custName"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
   
    countIndexFlag = [[NSMutableArray alloc] init];
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height-CaozuoViewHeight) style:UITableViewStylePlain isNeedRefresh:YES target:self];
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
    
    
    
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.frame = CGRectMake(0, 1, __MainScreen_Width, CaozuoViewHeight-1);
    [fenPeiBtn addTarget:self action:@selector(fenpeiClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
    [self.view addSubview:doView];
    
    startPage = 1;
    [self requestAlldata];
    selectContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45-__MainScreen_Height, __MainScreen_Width, -IOS7_Height-45+__MainScreen_Height)];
    selectContentScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];
    [self.view addSubview:selectContentScrollView];
    //标题
    [self addNavgationbar:@"商机分配" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];
    [self.view addSubview:searchView];

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
    startPage = 1;
    [self requestAlldata];
    
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
    [table reloadData];
}
-(void)GetSalersSuccess:(NSDictionary *)dic
{
    [ self createSelectView:@"商务" :[dic objectForKey:@"result"]];
}
#pragma mark - 分配操作
-(void)fenpeiClicked:(UIButton *)btn
{
    if(countIndexFlag.count == 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"请选择一个客户"];
        return;
    }

    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        [FX_UrlRequestManager postByUrlStr:GetSalers_url andPramas:nil andDelegate:self andSuccess:@"GetSalersSuccess:" andFaild:nil andIsNeedCookies:NO];
    }else{
        
        [FX_UrlRequestManager postByUrlStr:ZJdeptInit_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
    }
    
    
}
#pragma mark - 获得所有部门成功
-(void)getDeptSuccess:(NSDictionary *)dic
{
    
    [ self createSelectView:@"商务部门" :[dic objectForKey:@"result"]];
    
}
#pragma mark - 公海搜索
-(void)searchClicked:(UIButton *)sender
{
    startPage = 1;
      selectContentScrollView.frame = CGRectMake(0, IOS7_Height+45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-45-IOS7_Height);
    text.text = @"";
    [requestDic removeAllObjects];
    [requestDic setObject:@"1" forKey:@"flag"];
   
    [countIndexFlag removeAllObjects];
    [text becomeFirstResponder];
    [selectView removeFromSuperview];
    selectView = nil;
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
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    startPage += 1;
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
    if([[resultDic objectForKey:@"result"] count] <= 0)
    {
        if(startPage == 1)
        {
            [dataArr removeAllObjects];
            [table reloadData];
        }
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        _count_L.text = [NSString stringWithFormat:@"共计 %@ 条",@"0"];
    }
    else
    {
        _count_L.text = [NSString stringWithFormat:@"共计 %@ 条",[resultDic objectForKey:@"total"]];
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        
        [table reloadData];
    }
    
}
-(void) requestAlldata
{
    [requestDic setObject:khlx forKey:@"isWebsite"];
    [requestDic setObject:@"10" forKey:@"pagesize"];

    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
   
    
    // [searchRequestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
         [requestDic setObject:@"6" forKey:@"custSource"];
        [FX_UrlRequestManager postByUrlStr:getWillAssignCust_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }else{
         [requestDic setObject:@"4" forKey:@"custSource"];
        [FX_UrlRequestManager postByUrlStr:getWillAssignCust_url_ZJ andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    
    
    
}
#pragma mark - 筛选创建
-(void)createSelectView:(NSString *)name :(NSArray *)arr
{
    if([name isEqualToString:@"客户类型"])
    {
    a = 0;
    }
    else
    {
        a =1;
    }
    for (UIView *sub in selectContentScrollView.subviews) {
        if(sub)
        {
            [sub removeFromSuperview];
        }
    }
   
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 75+((arr.count+2)/3)*45)];
    bg.backgroundColor = [UIColor whiteColor];
    [selectContentScrollView addSubview:bg];
    selectContentScrollView.frame = CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
    //状态
    UILabel *z_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, __MainScreen_Width-20, 35)];
    z_l.font = [UIFont systemFontOfSize:14];
    z_l.textColor = [ToolList getColor:@"666666"];
    
    [bg addSubview:z_l];
    
    
    z_l.text = name;
    
    
    float btn_w = (__MainScreen_Width-48)/3.;
    if([name isEqualToString:@"客户类型"])
    {
        for (int i = 0 ; i < arr.count; i ++) {
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"客户类型" andTarget:self andDic:[arr objectAtIndex:i]];
            [bg addSubview:btn];
            
            [selectBtnArr addObject:btn];
        }
  
    }
    else if ([name isEqualToString:@"商务"])
    {
        selectContentScrollView.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height);

        for (int i = 0 ; i < arr.count; i ++) {
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"商务" andTarget:self andDic:[arr objectAtIndex:i]];
            [bg addSubview:btn];
            
            [selectBtnArr addObject:btn];
        }
    }
    else
    {
        selectContentScrollView.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height);
        for (int i = 0 ; i < arr.count; i ++) {
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"商务部门" andTarget:self andDic:[arr objectAtIndex:i]];
            [bg addSubview:btn];
            
            [selectBtnArr addObject:btn];
        }
  
    }

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40+((arr.count+2)/3)*45, __MainScreen_Width, 1)];
    line.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [bg addSubview:line];
    
    
    
    btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCommit.frame = CGRectMake(0, line.frame.origin.y+1, __MainScreen_Width, 35);
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCommit setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    [btnCommit setTitle:@"完成" forState:UIControlStateNormal];
    [btnCommit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btnCommit];
    
    
}
-(void)assignSuccess:(NSDictionary *)dic
{
    [countIndexFlag removeAllObjects];
    [self requestAlldata];
}
-(void)commit:(UIButton *)btn
{
    NSMutableArray *str = [[NSMutableArray alloc] init];
    for (NSNumber *n in countIndexFlag) {
        if([n intValue] < dataArr.count)
        {
            NSDictionary *dic = [dataArr objectAtIndex:[n intValue]];
            [str addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"custId"]]];
        }
        else
        {
            [countIndexFlag removeObject:n];
        }
        
        
    }

    if(a == 1)
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        
        NSMutableDictionary *requestD = [NSMutableDictionary dictionaryWithObjectsAndKeys:str,@"custIds",sw,@"assignToSalerId", nil];
        [FX_UrlRequestManager postByUrlStr:AssignCustToSaler_url andPramas:requestD andDelegate:self andSuccess:@"assignSuccess:" andFaild:nil andIsNeedCookies:YES];
    }else{
        
        NSDictionary *dic  = @{@"custIds":str,@"assignToDeptId":bm};
        [FX_UrlRequestManager postByUrlStr:ZJassignCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"assignSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
 
}else
{
    [self requestAlldata];
}
    bm = @"";
    sw = @"";
    khlx = @"-1";
    selectContentScrollView.frame = CGRectMake(0, IOS7_Height+45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-45-IOS7_Height);
    
}
-(void)requestSelectSuccess:(NSDictionary *)dictionary
{
    // [self initSelectView:[dictionary objectForKey:@"result"]];
}

#pragma mark - 筛选按钮点击
- (IBAction)selectBtnClicked:(id)sender {
    [countIndexFlag removeAllObjects];
    [self createSelectView:@"客户类型" :jieduanArr];
    
    
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
