//
//  Visit.m
//  SaleManagement
//
//  Created by feixiang on 2017/7/20.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//
#import "CY_recordVc.h"
#import "Visit.h"
#import "Fx_TableView.h"
#import "VisitCell.h"
#import "VisitCell_JL.h"
#import "QFDatePickerView.h"
#import "AssessmentStandardView.h"


@interface Visit ()
{
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
    //请求传参
    NSMutableDictionary *requestDic;
    //提示lable
    UILabel *alertLabel ;
    //时间lable
    UILabel *dateLabel ;
    //考核标准
    AssessmentStandardView *asView;
    NSDateFormatter *dateFormatter;
    QFDatePickerView *datePickerView;
    NSString *web_url;
}
@end

@implementation Visit
#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
   // startPage = 1;
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
   // startPage += 1;
    [self requestAlldata];
    
}
#pragma mark - 数据请求
-(void) requestAlldata
{
    
   // [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
   
        [requestDic setObject:_deptId forKey:@"deptId"];
  [FX_UrlRequestManager postByUrlStr:_requestU andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}
#pragma mark - 生产中客户列表数据
-(void)requestSuccess:(NSDictionary *)resultDic
{
    
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    alertLabel.text = [resultDic objectForKey:@"tip"];
    web_url = [resultDic objectForKey:@"url"];
    dateLabel.text = [resultDic objectForKey:@"businessDate"]  ;
    
    _businessYear =  [dateLabel.text substringWithRange:NSMakeRange(0, 4)];
    if(dateLabel.text.length == 8)
    {
    _businessMonth =  [dateLabel.text substringWithRange:NSMakeRange(5, 2)];
    }
    else
    {
    _businessMonth =  [dateLabel.text substringWithRange:NSMakeRange(5, 1)];
    }
    //创建时间控件
    
    datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        _businessYear =  [str substringWithRange:NSMakeRange(0, 4)];
        _businessMonth =  [str substringWithRange:NSMakeRange(5, 2)];
        [requestDic setObject:_businessYear forKey:@"businessYear"];
        [requestDic setObject:_businessMonth forKey:@"businessMonth"];
        [self requestAlldata];
    }andYear:[dateLabel.text substringWithRange:NSMakeRange(0, 4)] andMonth:[dateLabel.text substringWithRange:NSMakeRange(5, 2)] andPickFrame:CGRectZero andButtonHiden:(BOOL)NO andSelectdic:nil];
//    if(startPage == 1)
//    {
        [dataArr removeAllObjects];
//    }
    if([[resultDic objectForKey:@"result"] count] <= 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
//        if(startPage == 1)
//        {
            [dataArr removeAllObjects];
            [table reloadData];
//        }
    }
    else
    {
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        [table reloadData];
    }
}
#pragma mark - 页面初始化
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    //表头数据
    NSArray *tablaTitleArr;
    //数据初始化
  //  startPage = 1;
    dataArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
   // [requestDic setObject:@"10" forKey:@"pagesize"];
    //经理带提示
    UIImageView *alertBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_tip.png"]];
    if([_requestU isEqualToString:workAccount4DeptNew_url])
    {
        tablaTitleArr = @[@"姓名",@"待回访",@"已回访",@"已陪访"];
        alertBg.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, 54);
        alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, __MainScreen_Width-15, alertBg.frame.size.height)];
        alertLabel.font = [UIFont systemFontOfSize:16];
        alertLabel.textColor = [UIColor whiteColor];
        [alertBg addSubview:alertLabel];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(__MainScreen_Width-49, 0, 49, alertBg.frame.size.height);
        [btn setImage:[UIImage imageNamed:@"帮助.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(help) forControlEvents:UIControlEventTouchUpInside];
        alertBg.userInteractionEnabled = YES;
        [alertBg addSubview:btn];
        [self.view addSubview:alertBg];
    }
    else
    {
        tablaTitleArr = @[@"部门",@"待回访",@"已回访",@"已陪访"];

        alertBg.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, 0);
    }
    //日期栏
    UIView *dateView = [[UIView alloc] init];
    dateView.backgroundColor = [ToolList getColor:@"f2f2f2"];
    dateView.frame = CGRectMake(0, alertBg.frame.origin.y+alertBg.frame.size.height, __MainScreen_Width, 43);
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, __MainScreen_Width-10, dateView.frame.size.height)];
    dateLabel.font = [UIFont systemFontOfSize:16];
    dateLabel.textColor = [ToolList getColor:@"666666"];
    [dateView addSubview:dateLabel];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(__MainScreen_Width-49, 0, 49, dateView.frame.size.height);
    [btn setImage:[UIImage imageNamed:@"日历.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:btn];
    [self.view addSubview:dateView];
   //添加表头
    float w = __MainScreen_Width /4.;
    for (int i = 0; i < tablaTitleArr.count; i++)
    {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(i*w, dateView.frame.origin.y+dateView.frame.size.height, w, 60)];
        l.textColor = [ToolList getColor:@"4a4a4a"];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:13];
        l.text = [tablaTitleArr objectAtIndex:i];
    
        [self.view addSubview:l];
    }
    
    //添加线

    
    [self.view.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, dateView.frame.origin.y+dateView.frame.size.height+59) toPoint:CGPointMake(__MainScreen_Width, dateView.frame.origin.y+dateView.frame.size.height+59) andWeight:1. andColorString:@"f2f2f2"]];
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, dateView.frame.origin.y+dateView.frame.size.height+60, __MainScreen_Width, __MainScreen_Height-dateView.frame.origin.y-dateView.frame.size.height-60) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    table.dataSource = self;
    table.delegate = self;
    [table.refreshHeader autoRefreshWhenViewDidAppear];
    
    [self.view addSubview:table];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    if(_businessYear.length == 0 && _businessMonth.length == 0){
        //dateLabel.text = currentDate;
//        _businessYear =  [dateLabel.text substringWithRange:NSMakeRange(0, 4)];
//        _businessMonth =  [dateLabel.text substringWithRange:NSMakeRange(5, 2)];

    }
    else//从外面带进来的时间
    {
        dateLabel.text = [NSString stringWithFormat:@"%@年%@月",_businessYear,_businessMonth];

    }
    if(_businessYear.length && _businessMonth.length)
    {
        [requestDic setObject:_businessYear forKey:@"businessYear"];
        [requestDic setObject:_businessMonth forKey:@"businessMonth"];
    }
    else
    {
        [requestDic setObject:@"" forKey:@"businessYear"];
        [requestDic setObject:@"" forKey:@"businessMonth"];
    }

  
}
#pragma mark - 选日期
-(void)selectDate
{

    
    [datePickerView show];
}
#pragma mark - 帮助
-(void)help
{
    if (asView) {
        [asView removeFromSuperview];
        asView = nil;
    }
  
        asView = [[[NSBundle mainBundle] loadNibNamed:@"AssessmentStandardView" owner:self options:nil] firstObject];
    asView.web_url = web_url;
    [asView loadUrl];
    [self.view addSubview:asView];
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    
    //经理
    if([_requestU isEqualToString:workAccount4DeptNew_url])
    {
        static NSString *cellID = @"VisitCell_JL";
        VisitCell_JL *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VisitCell_JL" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 67.5) toPoint:CGPointMake(__MainScreen_Width, 67.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        cell.name.text = [ToolList changeNull:[dic objectForKey:@"salerName"]];
   
        cell.dhf.text = [ToolList changeNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"invalidLogNum"]]];
        cell.yxhf.text = [ToolList changeNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"validLogNum"]]];
        cell.af.text = [ToolList changeNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"accompanyNum"]]];
        cell.czStrBlock = ^(NSString *s)
        {
            NSLog(@"------------%@",s);
            CY_recordVc *recordV = [[CY_recordVc alloc]init];
            recordV.businessYear = _businessYear;
            recordV.businessMonth = _businessMonth;
            recordV.deptId = _deptId;
            recordV.state =s;
            recordV.salerId = [dic objectForKey:@"salerId"];
            [self.navigationController pushViewController:recordV animated:NO];
        };
        return cell;

    }
    //总监
    else
    {
        static NSString *cellID = @"VisitCell";
        VisitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VisitCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 67.5) toPoint:CGPointMake(__MainScreen_Width, 67.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        cell.name.text = [ToolList changeNull:[dic objectForKey:@"deptName"]];
        cell.dhf.text = [ToolList changeNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"invalidLogNum"]]];
        cell.yxhf.text = [ToolList changeNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"validLogNum"]]];
        cell.af.text = [ToolList changeNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"accompanyNum"]]];
        return cell;
    }

    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row] ;
    //经理
    if([_requestU isEqualToString:workAccount4DeptNew_url])
    {
       

    }
    //总监
    else 
    {
    
        Visit *ss = [[Visit alloc] init];
        ss.deptId = [dic objectForKey:@"deptId"];
        ss.requestU = workAccount4DeptNew_url;
        ss.businessMonth = _businessMonth;
        ss.businessYear = _businessYear;
        [self.navigationController pushViewController:ss animated:NO];

    }


}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
     [self requestAlldata];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavgationbar:@"拜访统计" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    [self initView];
   
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
