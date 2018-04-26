//
//  GonghaiViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/22.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "GonghaiViewController.h"
#import "FX_Button.h"
#import "GonghaiTableViewCell.h"
@interface GonghaiViewController ()
{
    
    GonghaiTableViewCell *cellDemo;
    NSIndexPath *index ;
    //地区筛选内容
    UIScrollView *selectDiQuContentView;
    //推荐筛选内容
    UIScrollView *selectTuijianContentView;
    //地区筛选内容
    UIView *selectDiQuView;
    //推荐筛选内容
    UIView *selectTuijianView;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
    //地区
    FX_Button *diquBtn;
    //推荐
    FX_Button *tuijianBtn;
    //数据列表
    Fx_TableView *table;
    
    //搜索数据列表
    Fx_TableView *searchTable;
    //数据
    NSMutableArray *dataArr;
    //搜索数据
    NSMutableArray *dataSearchArr;
    //筛选条件请求传参
    NSMutableDictionary *requestDic;
    //搜索请求传参
    NSMutableDictionary *searchRequestDic;
    //开始数据标识
    int startPage;
    //请求传参
    NSMutableArray *selectArr;
    BOOL flagNeedReload;
    
}
@end

@implementation GonghaiViewController
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
#pragma mark - 导航条的右按钮
-(void)RightAction:(UIButton *)sender
{
    text.text = @"";
    [text becomeFirstResponder];
    searchTable.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}

//筛选按钮点击
-(void)btnBack:(FX_Button *)str
{
    
    if(str.frame.origin.x == 0 )
    {
        if(str.isSelect)
        {
            [tuijianBtn change:@"down"];
            
            selectTuijianView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            [FX_UrlRequestManager postByUrlStr:OpenSelect_url andPramas:requestDic andDelegate:self andSuccess:@"OpenSelectSuccess:" andFaild:@"OpenSelectFaile:" andIsNeedCookies:YES];
            
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                selectDiQuView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            }];
        }
    }
    else if (str.frame.origin.x == __MainScreen_Width/2 )
    {
        if(str.isSelect)
        {
            for (UIView *subView in selectTuijianContentView.subviews) {
                [subView removeFromSuperview];
            }
            [diquBtn change:@"down"];
            selectDiQuView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, __MainScreen_Width, 45);
            
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
            btn.tag = 0;
            [btn addTarget:self action:@selector(shaixuanCommit:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            [selectTuijianContentView addSubview:btn];
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(0, 45, __MainScreen_Width, 45);
            
            [btn1 setTitle:@"我推荐的" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn1 setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(shaixuanCommit:) forControlEvents:UIControlEventTouchUpInside];
            [btn1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            [selectTuijianContentView addSubview:btn1];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                selectTuijianView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height , __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            }];
        }
        else
        {
            
            [UIView animateWithDuration:0.3 animations:^{
                selectTuijianView.frame = CGRectMake(0, SelectViewHeight+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-SelectViewHeight);
            }];
        }
        
    }
}
-(void)shaixuanCommit:(UIButton *)btn
{
    [diquBtn change:@"down"];
    [tuijianBtn change:@"down"];
    if (btn.tag == 0)
    {
        [requestDic setObject:@"0" forKey:@"recommendFlag"];
        [tuijianBtn setTitle:@"全部" forState:UIControlStateNormal];
    }
    else
    {
        [requestDic setObject:@"1" forKey:@"recommendFlag"];
        [tuijianBtn setTitle:@"我推荐的" forState:UIControlStateNormal];

    }
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custName"];
    [self requestAlldata];
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+ SelectViewHeight -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
        selectTuijianView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAlldata];
}
#pragma mark
-(void)diquCommit:(UIButton *)btn
{
    
    [diquBtn change:@"down"];
    [tuijianBtn change:@"down"];
    
    if(btn.tag == 0 )
    {
        [requestDic setObject:@"" forKey:@"searchTagId"];
        
    }
    
    else
    {
        NSString *addressRegion = [NSString stringWithFormat:@"[{custAddressRegion:'%@'}]",[[selectArr objectAtIndex:btn.tag] objectForKey:@"optionKey"]];
        [requestDic setObject:addressRegion forKey:@"searchTagId"];
    }
    [diquBtn setTitle:[[selectArr objectAtIndex:btn.tag] objectForKey:@"optionValue"] forState:UIControlStateNormal];
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custName"];
    [self requestAlldata];
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
        selectTuijianView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    }];
}
#pragma mark - 页面初始化
-(void)initView
{
    //数据初始化
    flagNeedReload = YES;
    startPage = 1;
    dataArr = [[NSMutableArray alloc] init];
    dataSearchArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    searchRequestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"" forKey:@"custName"];
    [requestDic setObject:@"-1" forKey:@"custType"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    [requestDic setObject:@"0" forKey:@"recommendFlag"];
    [requestDic setObject:@"" forKey:@"searchTagId"];
    [searchRequestDic setObject:@"-1" forKey:@"custType"];
    [searchRequestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [searchRequestDic setObject:@"10" forKey:@"pagesize"];
    [searchRequestDic setObject:@"0" forKey:@"recommendFlag"];
    [searchRequestDic setObject:@"" forKey:@"searchTagId"];
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    table.dataSource = self;
    table.delegate = self;
    [table.refreshHeader autoRefreshWhenViewDidAppear];

    [self.view addSubview:table];
    
    
    
    //筛选区域
    selectDiQuContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectDiQuContentView.backgroundColor = [UIColor whiteColor];
    selectTuijianContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width,90)];
    selectTuijianContentView.backgroundColor = [UIColor whiteColor];
    
    selectDiQuView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight)];
    selectDiQuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    selectTuijianView = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight)];
    selectTuijianView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [selectDiQuView addSubview:selectDiQuContentView];
    [selectTuijianView addSubview:selectTuijianContentView];
    
    
    [self.view addSubview:selectDiQuView];
    [self.view addSubview:selectTuijianView];
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, SelectViewHeight)];
    selectView.backgroundColor = [ToolList getColor:@"fafafa"];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, SelectViewHeight-0.8) toPoint:CGPointMake(__MainScreen_Width, SelectViewHeight-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [self.view addSubview:selectView];
    
    
    diquBtn = [[FX_Button alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width/2, SelectViewHeight) andType:@"0" andTitle:@"地区" andTarget:self andDic:nil];
    [selectView addSubview:diquBtn];
    tuijianBtn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, SelectViewHeight) andType:@"0" andTitle:@"推荐" andTarget:self andDic:nil];
    [selectView addSubview:tuijianBtn];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 8) toPoint:CGPointMake(__MainScreen_Width/2, SelectViewHeight-8) andWeight:0.1 andColorString:@"666666"]];
    
    
    
    [self addNavgationbar:@"公海客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"RightAction:" leftHiden:NO rightHiden:NO];
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __MainScreen_Height)];
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
    
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView addSubview:cancelSearchBtn];
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
    
    searchTable.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height - IOS7_Height);
    searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    [searchView addSubview:searchTable];
    
}
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    [searchRequestDic setObject:theTextField.text forKey:@"custName"];
    startPage = 1;
    flagNeedReload = NO;
    [self requestAlldata1];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}
//取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    startPage = 1;
    flagNeedReload = YES;
    [requestDic setObject:@"" forKey:@"custName"];
    [self requestAlldata];
    [text resignFirstResponder];
    [diquBtn change:@"down"];
    [tuijianBtn change:@"down"];
    
    selectDiQuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    selectTuijianView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
//筛选条件数据请求失败
-(void)OpenSelectFaile:(NSDictionary *)resultDic
{
    [ToolList showRequestFaileMessageLittleTime:@"筛选条件加载失败，请重试！"];
    
    [diquBtn change:@"down"];
}
//筛选条件数据请求成功
-(void)OpenSelectSuccess:(NSDictionary *)resultDic
{
    for (UIView *subView in selectDiQuContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    selectArr = [[NSMutableArray alloc] initWithArray:[[resultDic objectForKey:@"result"] objectForKey:@"areaClass"]];
    NSDictionary *dic =  @{@"optionKey":@"-1", @"optionValue":@"全部"};
    [selectArr insertObject:dic atIndex:0];
    
    selectDiQuContentView.contentSize = CGSizeMake(__MainScreen_Width, 45*selectArr.count);
    selectDiQuContentView.frame = CGRectMake(0, 0, __MainScreen_Width, 45*selectArr.count>__MainScreen_Height*0.68?__MainScreen_Height*0.68:selectArr.count*45);
    for (int i = 0 ; i < selectArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*45, __MainScreen_Width, 45);
        
        NSString *title = [[selectArr objectAtIndex:i] objectForKey:@"optionValue"];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
        btn.tag = i;
        [btn addTarget:self action:@selector(diquCommit:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        [selectDiQuContentView addSubview:btn];
        
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width,__MainScreen_Height-SelectViewHeight-IOS7_Height);
        
        
    }];
}
//公海列表数据
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    [searchTable.refreshHeader endRefreshing];
    [searchTable.refreshFooter endRefreshing];
    if(startPage == 1)
    {
        [dataArr removeAllObjects];
        [dataSearchArr removeAllObjects];
    }
    
    id resultStr =[resultDic objectForKey:@"result"];
    
    if ([resultStr isKindOfClass:[NSArray class]]) {
        
        if([[resultDic objectForKey:@"result"] count] <= 0)
        {
            if(startPage == 1)
            {
                if(flagNeedReload)
                {
                    [dataArr removeAllObjects];
                    [table reloadData];
                }
                else
                {
                    [dataSearchArr removeAllObjects];
                    [searchTable reloadData];
                }
            }
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        }
        else
        {
            
            if(flagNeedReload)
            {
                [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
                [table reloadData];
            }
            else
            {
                [dataSearchArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
                searchTable.hidden = NO;
                [searchTable reloadData];
            }
            
        }
 
    }else{
        
         [ToolList showRequestFaileMessageLittleTime:@"无搜索结果"];
    }
    
  }
-(void) requestAlldata1
{
    
    
    [searchRequestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [FX_UrlRequestManager postByUrlStr:zjgonghaiList_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
}
-(void) requestAlldata
{
    
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [searchRequestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            
        }
            break;
            
        case 1://经理
        {
            [FX_UrlRequestManager postByUrlStr:MobileManagerResourceAction_url andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            
        }
            break;
        case 2://总监
        {
            
              [FX_UrlRequestManager postByUrlStr:zjgonghaiList_url andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            
        }
            break;
            
            
            
        default:
            break;
    }
    
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(flagNeedReload)
    {
        return dataArr.count;
    }
    else
    {
        return dataSearchArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GonghaiTableViewCell";
    GonghaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GonghaiTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        
    }
    NSDictionary *dic;
    if(flagNeedReload)
    {
        dic = [dataArr objectAtIndex:indexPath.row];
          cell.addL.text = [ToolList changeNull:[dic objectForKey:@"custAddress"]];
    }
    else
    {
        dic = [dataSearchArr objectAtIndex:indexPath.row];
          cell.addL.text = [ToolList changeNull:[dic objectForKey:@"address"]];
    }
    cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
  
//    cell.jianBtn.tag = indexPath.row;
//    if([[ToolList changeNull:[dic objectForKey:@"recommendFlag"]] intValue] == 1)
//    {
//        [cell.jianBtn setImage:[UIImage imageNamed:@"btn_list_tuijian_done.png"] forState:UIControlStateNormal];
//        cell.jianBtn.userInteractionEnabled = NO;
//    }
//    else
//    {
//        [cell.jianBtn setImage:[UIImage imageNamed:@"btn_list_tuijian.png"] forState:UIControlStateNormal];
//        cell.jianBtn.userInteractionEnabled = YES;
//    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic;
    if(flagNeedReload)
    {
        dic = [dataArr objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [dataSearchArr objectAtIndex:indexPath.row];
    }    if([[ToolList changeNull:[dic objectForKey:@"recommendFlag"]] intValue] != 1)
    {
        cellDemo = [tableView cellForRowAtIndexPath:indexPath];
        index = indexPath;
        if(flagNeedReload)
        {
        [FX_UrlRequestManager postByUrlStr:Recommend_url andPramas:[NSMutableDictionary dictionaryWithObject:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"custId"] forKey:@"custId"] andDelegate:self andSuccess:@"doZanSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
        else
        {
          [FX_UrlRequestManager postByUrlStr:Recommend_url andPramas:[NSMutableDictionary dictionaryWithObject:[[dataSearchArr objectAtIndex:indexPath.row] objectForKey:@"custId"] forKey:@"custId"] andDelegate:self andSuccess:@"doZanSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
    }
    
    
}
#pragma mark - 赞或取消
-(void)doZanSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue]==200)
    {
//        if(flagNeedReload)
//        {
//            [self headerRefresh:table];
//        }
//        else
//        {
//            [self headerRefresh:searchTable];
//        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if(flagNeedReload)
        {
        for (int i = 0; i < dataArr.count; i++)
        {
            NSDictionary * dict = [dataArr objectAtIndex:i];
            if(i == index.row)
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                [dic setObject:@"1" forKey:@"recommendFlag"];
                [arr addObject:dic];
            }
            else
            {
                [arr addObject:dict];
            }
        }
            [dataArr removeAllObjects];
            [dataArr addObjectsFromArray:arr];
        }
        else
        {
            for (int i = 0; i < dataSearchArr.count; i++)
            {
                NSDictionary * dict = [dataSearchArr objectAtIndex:i];
                if(i == index.row)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                    [dic setObject:@"1" forKey:@"recommendFlag"];
                    [arr addObject:dic];
                }
                else
                {
                    [arr addObject:dict];
                }
            }
            [dataSearchArr removeAllObjects];
            [dataSearchArr addObjectsFromArray:arr];

        }
        
//        [cellDemo.jianBtn setImage:[UIImage imageNamed:@"btn_list_tuijian_done.png"] forState:UIControlStateNormal];
//        cellDemo.jianBtn.userInteractionEnabled = NO;
    }
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
