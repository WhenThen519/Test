//
//  peiYuKuViewController.m
//  SaleManagement
//
//  Created by known on 16/7/19.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "peiYuKuViewController.h"
#import "BuMenTableViewCell.h"
#import "Fx_TableView.h"
#import "peiYuKuDetailViewController.h"
@interface peiYuKuViewController ()
{
    
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
    //开始数据标识
    int startPage;
    //请求传参
    NSMutableDictionary *requestDic;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
    BOOL flagNeedReload;
    //搜索数据列表
    Fx_TableView *searchTable;

}
@end

@implementation peiYuKuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavgationbar:@"培育库" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];
    flagNeedReload = YES;
 
    //数据初始化
    startPage = 1;
    dataArr = [[NSMutableArray alloc] init];

    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];

    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    [self requestAlldata];
    
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
    text.placeholder = @"请输入意向单号";
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
    
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    [searchView addSubview:searchTable];

    

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
    [requestDic setObject:theTextField.text forKey:@"orderId"];
    startPage = 1;
    flagNeedReload = NO;
    [self requestAlldata];
    return YES;
}

#pragma mark   //取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    flagNeedReload = YES;
    startPage = 1;
    [requestDic setObject:@"" forKey:@"orderId"];
    [self requestAlldata];
    [text resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}


#pragma mark - 数据请求
-(void) requestAlldata
{
    
            [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
            [FX_UrlRequestManager postByUrlStr:peiYuKuCustDept_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            
            
    
}
#pragma mark - 部门客户列表数据请求成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
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
            if(flagNeedReload)
            {
                [table reloadData];
            }
            else
            {
                [searchTable reloadData];
            }
        }
    }
    else
    {
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        if(flagNeedReload)
        {
            [table reloadData];
        }
        searchTable.hidden = NO;
        [searchTable reloadData];

    }
//    [table reloadData];
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

#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BuMenTableViewCell";
    BuMenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuMenTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"orderId"]];
    cell.nameLabel.textColor = [ToolList getColor:@"666666"];
    cell.labelother.text = [ToolList changeNull:[dic objectForKey:@"linkManName"]];
    cell.labelother.textColor = [ToolList getColor:@"4A4A4A"];
    cell.labelother.font =[UIFont systemFontOfSize:16];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    peiYuKuDetailViewController *peiyuD = [[peiYuKuDetailViewController alloc] init];
    if (IOS7) {
        peiyuD.automaticallyAdjustsScrollViewInsets = NO;

    }

    peiyuD.dataDic = dic;
    [self.navigationController pushViewController:peiyuD animated:NO];
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
