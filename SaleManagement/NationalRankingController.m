//
//  NationalRankingController.m
//  SaleManagement
//
//  Created by feixiang on 16/6/14.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "QuYuCell.h"
#import "ComTableViewCell.h"
#import "NationalRankingController.h"
#import "DepTableViewCell.h"
@interface NationalRankingController ()
{
    FX_Button * dayButton;
    int currentPage;
    //是否出现筛选页
    BOOL isUpSelectView;
    //头部按钮总和
    NSMutableArray *btnArr;
    NSMutableArray *tableViewArr;
    UIView *tableViewContent;
    NSMutableDictionary *requestDic;
    //个人table
    UITableView *geRenTableView;
    //部门table
    UITableView *buMenTableView;
    //分司table
    UITableView *fenSiTableView;
    //区域table
    UITableView *quYuTableView;
    //筛选内容区
    UIView *selectContentView;
    //筛选内容区遮照
    UIView *selectContentView_B;
    //筛选按钮
    UIButton *product_Select_Btn;
    //个人排行数据
    NSMutableArray *geRenData;
    //部门排行数据
    NSMutableArray *buMenData;
    //分司排行数据
    NSMutableArray *fenSiData;
    //区域排行数据
    NSMutableArray *quYuData;
    //筛选项数组
    NSMutableArray *selectBtnArr;
    //初始的筛选项
    NSArray *selectItems;
    //筛选联动
    NSDictionary *selectDic;
}
@end

@implementation NationalRankingController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initView];
    [self requestGeren];
    [self createSelectCounts:selectItems];

    // Do any additional setup after loading the view.
}
#pragma mark - 请求个人数据
-(void)requestGeren
{
    
    [FX_UrlRequestManager postByUrlStr:CountryPersonal_url andPramas:requestDic andDelegate:self andSuccess:@"geRenSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 请求个人数据成功
-(void)geRenSuccess:(NSDictionary *)dic
{
    [geRenData removeAllObjects];

        if([[dic objectForKey:@"result"] count] <= 0 )
        {
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        }
    else
    {
        [geRenData addObjectsFromArray:[dic objectForKey:@"result"]];
    }
    [geRenTableView reloadData];
}
#pragma mark - 请求部门数据
-(void)requestBumen
{
    
    [FX_UrlRequestManager postByUrlStr:CountryDept_url andPramas:requestDic andDelegate:self andSuccess:@"buMenSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 部门数据成功
-(void)buMenSuccess:(NSDictionary *)dic
{
    [buMenData removeAllObjects];
    
    if([[dic objectForKey:@"result"] count] <= 0 )
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [buMenData addObjectsFromArray:[dic objectForKey:@"result"]];
    }
    [buMenTableView reloadData];
}
#pragma mark - 请求分司数据
-(void)requestFensi
{
    
    [FX_UrlRequestManager postByUrlStr:CountrySub_url andPramas:requestDic andDelegate:self andSuccess:@"fenSiSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 分司数据成功
-(void)fenSiSuccess:(NSDictionary *)dic
{
    [fenSiData removeAllObjects];
    
    if([[dic objectForKey:@"result"] count] <= 0 )
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [fenSiData addObjectsFromArray:[dic objectForKey:@"result"]];
    }
    [fenSiTableView reloadData];
}
#pragma mark - 请求区域数据
-(void)requestQuyu
{
    
    [FX_UrlRequestManager postByUrlStr:CountryArea_url andPramas:requestDic andDelegate:self andSuccess:@"quYuSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 请求区域数据成功
-(void)quYuSuccess:(NSDictionary *)dic
{
    [quYuData removeAllObjects];
    
    if([[dic objectForKey:@"result"] count] <= 0 )
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [quYuData addObjectsFromArray:[dic objectForKey:@"result"]];
    }
    [quYuTableView reloadData];
}
#pragma mark - 页面和数据初始化
-(void)initView
{
#pragma mark - 数据初始化
    selectItems = @[@{@"1":@"今日"},@{@"2":@"昨日"},@{@"3":@"本月"},@{@"4":@"上月"}];
    selectBtnArr  = [[NSMutableArray alloc] init];
    btnArr  = [[NSMutableArray alloc] init];
    geRenData  = [[NSMutableArray alloc] init];
    buMenData  = [[NSMutableArray alloc] init];
    fenSiData  = [[NSMutableArray alloc] init];
    quYuData  = [[NSMutableArray alloc] init];
    tableViewArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc]init];
    //默认全国、今日
    requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];
    requestDic[@"type"]=[NSNumber numberWithInteger:1];
#pragma mark - view初始化
    //table页
    tableViewContent = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight1+44, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight1-44)];
    geRenTableView = [[UITableView alloc] initWithFrame:tableViewContent.bounds style:UITableViewStylePlain];
    geRenTableView.delegate = self;
    geRenTableView.dataSource = self;
    geRenTableView.separatorStyle = 0;
    geRenTableView.backgroundColor = [UIColor whiteColor];
    
    buMenTableView = [[UITableView alloc] initWithFrame:tableViewContent.bounds style:UITableViewStyleGrouped ];
    buMenTableView.sectionFooterHeight = 0;
    buMenTableView.delegate = self;
    buMenTableView.dataSource = self;
    buMenTableView.separatorStyle = 0;
    buMenTableView.backgroundColor = [UIColor whiteColor];
    
    fenSiTableView = [[UITableView alloc] initWithFrame:tableViewContent.bounds style:UITableViewStyleGrouped ];
    fenSiTableView.delegate = self;
    fenSiTableView.dataSource = self;
    fenSiTableView.separatorStyle = 0;
    fenSiTableView.backgroundColor = [UIColor whiteColor];
    
    quYuTableView = [[UITableView alloc] initWithFrame:tableViewContent.bounds style:UITableViewStylePlain ];
    quYuTableView.delegate = self;
    quYuTableView.dataSource = self;
    quYuTableView.separatorStyle = 0;
    quYuTableView.backgroundColor = [UIColor whiteColor];
    
    [tableViewArr addObject:geRenTableView];
    [tableViewArr addObject:buMenTableView];
    [tableViewArr addObject:fenSiTableView];
    [tableViewArr addObject:quYuTableView];
    
    [tableViewContent addSubview:buMenTableView];
    [tableViewContent addSubview:fenSiTableView];
    [tableViewContent addSubview:quYuTableView];
    [tableViewContent addSubview:geRenTableView];
    [self.view addSubview:tableViewContent];
    //筛选下拉页面
    selectContentView_B = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+44+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44-SelectViewHeight1)];
    selectContentView_B.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    selectContentView = [[UIView alloc] initWithFrame:CGRectMake(0,0, __MainScreen_Width, 85)];
    selectContentView.backgroundColor = [UIColor whiteColor];
    [selectContentView_B addSubview:selectContentView];
    [self.view addSubview:selectContentView_B];
    //标题
    [self addNavgationbar:@"全国排行榜" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    NSArray * arr = @[@"个人排名",@"部门排名",@"分司排名",@"区域排名"];
    for (int i = 0 ; i < arr.count; i ++) {
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/4*i, IOS7_Height, __MainScreen_Width/4, 43.5) andType:@"4" andTitle:[arr objectAtIndex:i] andTarget:self andDic:nil];
        btn.tag = i;
        [self.view addSubview:btn];
        [btnArr addObject:btn];
        if(i == 0)
        {
            btn.isSelect = YES;
            [btn changeBigAndColorCliked:btn];
        }
        btn.backgroundColor = [UIColor whiteColor];
        
        //竖线
        [self.view.layer addSublayer:[ToolList getLineFromPoint:CGPointMake((__MainScreen_Width/4)*(i+1), IOS7_Height + 10) toPoint:CGPointMake((__MainScreen_Width/4)*(i+1), IOS7_Height + 34) andWeight:1. andColorString:@"e7e7eb"]];
    }
    //横向线
    [self.view.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height+43.5) toPoint:CGPointMake(__MainScreen_Width, IOS7_Height+43.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    //筛选区域
    UIView *selectViewFa = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+43, __MainScreen_Width, SelectViewHeight1+1)];
    selectViewFa.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [selectViewFa.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, SelectViewHeight1+1-0.8) toPoint:CGPointMake(__MainScreen_Width, SelectViewHeight1) andWeight:0.8 andColorString:@"e7e7eb"]];
    selectDic = @{@"1":@"今日"};
    dayButton = [[FX_Button alloc] initWithFrame:CGRectMake(12 , 4, (__MainScreen_Width-63)/4, 28) andType:@"1" andTitle:@"日期" andTarget:nil andDic:selectDic];
    dayButton.userInteractionEnabled = NO;
    [dayButton changeType1Btn:YES];
    [selectViewFa addSubview:dayButton];
    product_Select_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    product_Select_Btn.frame = CGRectMake(__MainScreen_Width-55, 0, 52, SelectViewHeight1+1);
    [product_Select_Btn setTitle:@"筛选" forState:UIControlStateNormal];
    product_Select_Btn.hidden = NO;
    product_Select_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [product_Select_Btn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    product_Select_Btn.backgroundColor = [UIColor clearColor];
    [product_Select_Btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [product_Select_Btn setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [product_Select_Btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [selectViewFa addSubview:product_Select_Btn];
    [self.view addSubview:selectViewFa];
    
    
}
#pragma mark - 筛选点击
-(void)selectBtnClicked:(UIButton *)btn
{
    
    isUpSelectView = !isUpSelectView;
    //出现
    if(isUpSelectView)
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            selectContentView_B.frame = CGRectMake(0,44+SelectViewHeight1+IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44-SelectViewHeight1);
        }];
    }
    //消失
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            selectContentView_B.frame = CGRectMake(0,IOS7_Height+44+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44-SelectViewHeight1);
        }];
    }
}
#pragma mark - 生成筛选项
-(void)createSelectCounts:(NSArray *)items
{
    [selectBtnArr removeAllObjects];
    for (UIView *subView in selectContentView.subviews) {
        if(subView)
        {
            [subView removeFromSuperview];
        }
    }
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, __MainScreen_Width-12, 38)];
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"日期";
    title.textColor = [ToolList getColor:@"666666"];
    [selectContentView addSubview:title];
    float weight = (__MainScreen_Width-(items.count+1)*12)/items.count;
    for (int i = 0;i < items.count;i ++ )
    {
        NSDictionary *dic = [items objectAtIndex:i];
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(weight+12)*i, 36, weight, 34) andType:@"1" andTitle:[NSString stringWithFormat:@"%d",currentPage] andTarget:self andDic:dic];
        if([[[selectDic allValues]lastObject] isEqualToString:[[dic allValues]lastObject]])
        {
            [btn changeType1Btn:YES];
        }
        [selectContentView addSubview:btn];
        [selectBtnArr addObject:btn];
    }
    
}
#pragma mark - 筛选按钮回调
-(void)btnBackDic:(NSDictionary *)dic
{
    FX_Button *btn = [dic objectForKey:@"Obj"];
  if(currentPage == 3)
  {
      selectDic = @{@"1":@"今日"};

  }
    else
    {
        selectDic = [dic objectForKey:@"data"];
   
    }
    NSString *zhuangtaiNameStr = [[[dic objectForKey:@"data"] allKeys] lastObject];

        if(btn.isSelect)
        {
             [dayButton setTitle:[NSString stringWithFormat:@"%@",[[[dic objectForKey:@"data"] allValues]lastObject]] forState:UIControlStateNormal];
            isUpSelectView = NO;
            [UIView animateWithDuration:0.3 animations:^{
                selectContentView_B.frame = CGRectMake(0,IOS7_Height+44+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44-SelectViewHeight1);
            }];
            requestDic[@"dataFilter"]=zhuangtaiNameStr;
                for (FX_Button *btnS in selectBtnArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
            if(currentPage == 0)
            {
            [self requestGeren];
            }
            else if (currentPage == 1)
            {
                [self requestBumen];
            }
            else if (currentPage == 2)
            {
                [self requestFensi];
            }
            else
            {
                [self requestQuyu];
            }
        }
    else
    {

        requestDic[@"dataFilter"]=@"1";

    }
}
#pragma mark - 按钮回调
-(void)changeBigAndColorClikedBack:(FX_Button *)btn
{
    requestDic[@"type"]=[NSNumber numberWithInteger:1];
    isUpSelectView = NO;
    selectContentView_B.frame = CGRectMake(0,IOS7_Height+44+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44-SelectViewHeight1);
    for (int i = 0; i < btnArr.count ; i++) {
        FX_Button * clickedBtn = [btnArr objectAtIndex:i];
        if (clickedBtn == btn) {
            [tableViewContent bringSubviewToFront:[tableViewArr objectAtIndex:i]];
            clickedBtn.isSelect = YES;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
            if(i !=3 )
            {
               [dayButton setTitle:[NSString stringWithFormat:@"%@",[[selectDic allValues]lastObject]] forState:UIControlStateNormal];
                requestDic[@"dataFilter"]=[[selectDic allKeys] lastObject];

            }
            else
            {
                [dayButton setTitle:@"本月" forState:UIControlStateNormal];
                selectDic = @{@"1":@"今日"};
                requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];

            }
 
        }
        else
        {
            clickedBtn.isSelect = NO;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
    }
    currentPage = (int)btn.tag;

    selectItems = @[@{@"1":@"今日"},@{@"2":@"昨日"},@{@"3":@"本月"},@{@"4":@"上月"}];
    if(btn.tag == 0)
    {
        [self requestGeren];
        
    }
    else if (btn.tag == 1)
    {
        [self requestBumen];
    }
    else if(btn.tag == 2)
    {
        [self requestFensi];
    }
    else
    {
        [self requestQuyu];
        selectItems = @[@{@"1":@"本月"},@{@"2":@"上月"}];
    }
    [self createSelectCounts:selectItems];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == buMenTableView)
    {
        return buMenData.count;
    }
    else if (tableView == fenSiTableView)
    {
        return fenSiData.count;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (geRenTableView == tableView)
    {
        return geRenData.count;
    }
    else if (buMenTableView == tableView)
    {
        NSDictionary *dic = [buMenData objectAtIndex:section];
        return [[dic objectForKey:@"areaList"] count];
    }
    else if (fenSiTableView == tableView)
    {
        NSDictionary *dic = [fenSiData objectAtIndex:section];
        return [[dic objectForKey:@"areaList"] count];
    }
    else
    {
        return quYuData.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (buMenTableView == tableView || fenSiTableView == tableView)
    {
    return 33;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = nil;
    if(tableView == buMenTableView)
    {
    dic = [buMenData objectAtIndex:section];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 33)];
        l.backgroundColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = [dic objectForKey:@"areaName"];
        l.font = [UIFont systemFontOfSize:14];
        l.textColor = [ToolList getColor:@"666666"];
        return l;
    }
    else if (tableView == fenSiTableView)
    {
    dic = [fenSiData objectAtIndex:section];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 33)];
        l.backgroundColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = [dic objectForKey:@"areaName"];
        l.font = [UIFont systemFontOfSize:14];
        l.textColor = [ToolList getColor:@"666666"];
        return l;
    }
    else
    {
        return nil;
    }
   
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == quYuTableView)
    {
        
        static NSString *CellIdentifier = @"QuYuCell";
        QuYuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QuYuCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 59.5) toPoint:CGPointMake(__MainScreen_Width, 59.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        
        NSDictionary *dataDic = [quYuData objectAtIndex:indexPath.row];
        cell.nameL.text = [ToolList changeNull:[dataDic objectForKey:@"areaName"]];
        
        if ([[dataDic objectForKey:@"rank"] intValue]==1) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"金杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==2) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"银杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==3) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"铜杯icon.png"];
        }else{
            
            cell.numL.hidden = NO;
            cell.imageV.hidden = YES;
            UIFont *font = [UIFont fontWithName:@"Black Ops One" size:30];
            cell.numL.font = font;
            cell.numL.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"rank"]]];;
        }
        
        return cell;
    }
    else if(tableView == buMenTableView )
    {
        static NSString *CellIdentifier = @"ComTableViewCell";
        ComTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ComTableViewCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        NSDictionary *dataDic1 = [buMenData objectAtIndex:indexPath.section];
        
        NSDictionary *dataDic = [[dataDic1 objectForKey:@"areaList"] objectAtIndex:indexPath.row];
        cell.nameL.text = [ToolList changeNull:[dataDic objectForKey:@"deptName"]];
        cell.typeL.text =[ToolList changeNull:[dataDic objectForKey:@"content"]];
        cell.moneyL.text=[NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"salesAchivement"]]];
        
        if ([[dataDic objectForKey:@"rank"] intValue]==1) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"金杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==2) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"银杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==3) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"铜杯icon.png"];
        }else{
            
            cell.numL.hidden = NO;
            cell.imageV.hidden = YES;
            UIFont *font = [UIFont fontWithName:@"Black Ops One" size:30];
            cell.numL.font = font;
            cell.numL.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"rank"]]];;
        }
        
        return cell;

    }
    else if( tableView == fenSiTableView)
    {
        static NSString *CellIdentifier = @"ComTableViewCell";
        ComTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ComTableViewCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        NSDictionary *dataDic1 = [fenSiData objectAtIndex:indexPath.section];
    
        NSDictionary *dataDic = [[dataDic1 objectForKey:@"areaList"] objectAtIndex:indexPath.row];
        cell.nameL.text = [ToolList changeNull:[dataDic objectForKey:@"subName"]];
        cell.typeL.text =[ToolList changeNull:[dataDic objectForKey:@"content"]];
        cell.moneyL.text=[NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"salesAchivement"]]];
        
        if ([[dataDic objectForKey:@"rank"] intValue]==1) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"金杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==2) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"银杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==3) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"铜杯icon.png"];
        }else{
            
            cell.numL.hidden = NO;
            cell.imageV.hidden = YES;
            UIFont *font = [UIFont fontWithName:@"Black Ops One" size:30];
            cell.numL.font = font;
            cell.numL.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"rank"]]];;
        }
        
        return cell;
        
    }

    else  {
        
        static NSString *CellIdentifier = @"ComTableViewCell";
        ComTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ComTableViewCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 75.5) toPoint:CGPointMake(__MainScreen_Width, 75.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        
        NSDictionary *dataDic = [geRenData objectAtIndex:indexPath.row];
        cell.nameL.text = [ToolList changeNull:[dataDic objectForKey:@"salerName"]];
        cell.typeL.text =[ToolList changeNull:[dataDic objectForKey:@"content"]];
        cell.moneyL.text=[NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"salesAchivement"]]];
        
        if ([[dataDic objectForKey:@"rank"] intValue]==1) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"金杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==2) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"银杯icon.png"];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==3) {
            cell.numL.hidden = YES;
            cell.imageV.hidden = NO;
            cell.imageV.image = [UIImage imageNamed:@"铜杯icon.png"];
        }else{
            
            cell.numL.hidden = NO;
            cell.imageV.hidden = YES;
            UIFont *font = [UIFont fontWithName:@"Black Ops One" size:30];
            cell.numL.font = font;
            cell.numL.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"rank"]]];;
        }
        
        return cell;
    }

    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (quYuTableView == tableView)
    {
        return 60;
    }
   
    else
    {
       return 76;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSDictionary *dic;
    //    if(tableView == shangWuTableView)
    //    {
    //        dic = [shangWuData objectAtIndex:indexPath.row];
    //    }
    //    else if (tableView == yuanGongTableView)
    //    {
    //        dic = [yuanGongData objectAtIndex:indexPath.row];
    //    }
    //    else if (tableView == searchTable)
    //    {
    //        dic = [dataSearchArr objectAtIndex:indexPath.row];
    //    }
    //    else
    //    {
    //        dic = [zongJianData objectAtIndex:indexPath.row];
    //    }
    //    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    //
    //    s.custNameStr = [dic objectForKey:@"custName"];
    //    s.custId = [dic objectForKey:@"custId"];
    //    s.oldOrNew = [dic objectForKey:@"oldOrNew"];
    //    [self.navigationController pushViewController:s animated:NO];
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
