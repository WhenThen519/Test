//
//  JLBuMenVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/3/21.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "JLBuMenVc.h"
#import "Fx_TableView.h"
#import "BuMenTableViewCell.h"
#import "FX_Button.h"
#import "UserDetailViewController.h"

#define HANDVIEW_H 42

@interface JLBuMenVc (){
    
    
    NSArray *jieduanArr;
    NSArray *zhuangtaiArr;
    
    //筛选条件请求传参
    NSMutableDictionary *requestDic;
    //搜索请求传参
    NSMutableDictionary *searchRequestDic;
    //开始数据标识
    int startPage;
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
    //阶段
    FX_Button *jieduanBtn;
    //状态
    FX_Button *zhuangtaiBtn;
    //商务
    FX_Button *shangwuBtn;
    //阶段层
    UIView *jieduanView;
    //阶段内容层
    UIView *jieduanContentView;
    //状态层
    UIView *zhuangtaiView;
    //状态内容层
    UIView *zhuangtaiContentView;
    //商务层
    UIView *shangwuView;
    //商务内容层
    UIScrollView *shangwuContentView;
    //阶段请求数组
    NSMutableArray *jieduanRequestArr;
    //状态请求数组
    NSMutableArray *zhuangtaiRequestArr;
    //阶段按钮数组
    NSMutableArray *jieduanBtnArr;
    //状态按钮数组
    NSMutableArray *zhuangtaiBtnArr;
    //商务筛选数组
    NSMutableArray *selectShangWuArr;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
    BOOL flagNeedReload;
    
    //搜索数据列表
    Fx_TableView *searchTable;
    
    NSMutableArray *selectTypes;//头部状态
}

@end

@implementation JLBuMenVc

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
#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    //阶段回馈
    if([str isEqualToString:@"阶段"])
    {
        if(btn.isSelect)
        {
            int index = -1;
            if([btn.titleLabel.text isEqualToString:@"不限"])
            {
                for (FX_Button *btnS in jieduanBtnArr) {
                    [btnS changeType1Btn:NO];
                }
                [jieduanBtnArr removeAllObjects];
                
            }
            else
            {
                for (FX_Button *btnS in jieduanBtnArr) {
                    if([btnS.titleLabel.text isEqualToString:@"不限"])
                    {
                        index = [jieduanBtnArr indexOfObject:btnS];
                        [btnS changeType1Btn:NO];
                    }
                }
                if(index != -1)
                {
                    [jieduanBtnArr removeObjectAtIndex:index];
                }
            }
            if([jieduanBtnArr indexOfObject:btn] == NSNotFound)
            {
                [jieduanBtnArr addObject:btn];
            }
        }
        else
        {
            if( [jieduanBtnArr indexOfObject:btn] != NSNotFound)
            {
                [jieduanBtnArr removeObject:btn];
            }
            
        }
    }
    //状态回馈
    else
    {
        if(btn.isSelect)
        {
            int index = -1;
            if([btn.titleLabel.text isEqualToString:@"不限"])
            {
                for (FX_Button *btnS in zhuangtaiBtnArr) {
                    [btnS changeType1Btn:NO];
                }
                [zhuangtaiBtnArr removeAllObjects];
                
            }
            else
            {
                for (FX_Button *btnS in zhuangtaiBtnArr) {
                    if([btnS.titleLabel.text isEqualToString:@"不限"])
                    {
                        index = [zhuangtaiBtnArr indexOfObject:btnS];
                        [btnS changeType1Btn:NO];
                    }
                }
                if(index != -1)
                {
                    [zhuangtaiBtnArr removeObjectAtIndex:index];
                }
            }
            if([zhuangtaiBtnArr indexOfObject:btn] == NSNotFound)
            {
                [zhuangtaiBtnArr addObject:btn];
            }
            
        }
        else
        {
            if( [zhuangtaiBtnArr indexOfObject:btn] != NSNotFound)
            {
                [zhuangtaiBtnArr removeObject:btn];
            }
            
        }
        
    }
}
#pragma mark - 阶段筛选完毕
-(void)jieduanCommit:(UIButton *)btn
{
    [jieduanBtn change:@"down"];
    [jieduanRequestArr removeAllObjects];
    for (FX_Button *btn in jieduanBtnArr) {
        for (NSDictionary *dic in jieduanArr) {
            if([[[dic allValues]lastObject] isEqualToString:btn.titleLabel.text])
            {
                [jieduanRequestArr addObject:[[dic allKeys] lastObject]];
                break;
            }
        }
        
    }
    [requestDic setObject:jieduanRequestArr forKey:@"custTypes"];
    startPage = 1;
    [self requestAlldata];
    
    [UIView animateWithDuration:0.3 animations:^{
        jieduanView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
        
    }];
}
#pragma mark - 状态筛选完毕
-(void)zhuangtaiCommit:(UIButton *)btn
{
    [zhuangtaiBtn change:@"down"];
    [zhuangtaiRequestArr removeAllObjects];
    for (FX_Button *btn in zhuangtaiBtnArr) {
        for (NSDictionary *dic in zhuangtaiArr) {
            if([[[dic allValues]lastObject] isEqualToString:btn.titleLabel.text])
            {
                [zhuangtaiRequestArr addObject:[[dic allKeys] lastObject]];
                break;
            }
        }
        
    }
    [requestDic setObject:zhuangtaiRequestArr forKey:@"intenttypes"];
    startPage = 1;
    [self requestAlldata];
    
    [UIView animateWithDuration:0.3 animations:^{
        zhuangtaiView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
        
    }];
}
#pragma mark - 筛选按钮点击
-(void)btnBack:(FX_Button *)str
{
    if([str.titleLabel.text isEqualToString:@"阶段"])
    {
        [zhuangtaiBtn change:@"down"];
        [shangwuBtn change:@"down"];
        zhuangtaiView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
        shangwuView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
        if(str.isSelect)
        {
            [UIView animateWithDuration:0.3 animations:^{
                jieduanView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                jieduanView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
            }];
        }
    }
    else if ([str.titleLabel.text isEqualToString:@"状态"])
    {
        [jieduanBtn change:@"down"];
        [shangwuBtn change:@"down"];
        jieduanView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
        shangwuView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
        if(str.isSelect)
        {
            [UIView animateWithDuration:0.3 animations:^{
                zhuangtaiView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                zhuangtaiView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
            }];
        }
    }
    else
    {
        zhuangtaiView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
        jieduanView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
        [jieduanBtn change:@"down"];
        [zhuangtaiBtn change:@"down"];
        if(str.isSelect)
        {
            [FX_UrlRequestManager postByUrlStr:GetSalers_url andPramas:nil andDelegate:self andSuccess:@"OpenSelectSuccess:" andFaild:@"OpenSelectFaile:" andIsNeedCookies:NO];
            
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                shangwuView.frame =CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight);
            }];
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAlldata];
}
#pragma mark - 页面初始化
-(void)initView
{
#pragma mark - 数据初始化
    //阶段请求数组
    jieduanRequestArr = [[NSMutableArray alloc] init];
    //状态请求数组
    zhuangtaiRequestArr = [[NSMutableArray alloc] init];
    //阶段按钮数组
    jieduanBtnArr = [[NSMutableArray alloc] init];
    //状态按钮数组
    zhuangtaiBtnArr = [[NSMutableArray alloc] init];
    startPage = 1;
    
    //头部状态选择数组
    selectTypes = [[NSMutableArray alloc]init];
    
    flagNeedReload = YES;
    requestDic = [[NSMutableDictionary alloc] init];
    [jieduanRequestArr addObject:@"0"];
    [zhuangtaiRequestArr addObject:@"-1"];
    searchRequestDic = [[NSMutableDictionary alloc] init];
    [searchRequestDic setObject:@"" forKey:@"salerId"];
    [searchRequestDic setObject:@[@"0"] forKey:@"custTypes"];
    [searchRequestDic setObject:@[@"-1"] forKey:@"intenttypes"];
    [searchRequestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [searchRequestDic setObject:@"10" forKey:@"pagesize"];
    
    [requestDic setObject:@"" forKey:@"salerId"];
    [requestDic setObject:jieduanRequestArr forKey:@"custTypes"];
    [requestDic setObject:zhuangtaiRequestArr forKey:@"intenttypes"];
    [requestDic setObject:@"" forKey:@"custName"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    
    jieduanArr = @[@{@"0":@"不限"},@{@"1":@"收藏夹"},@{@"2":@"保护跟进"},@{@"3":@"意向保护"},@{@"4":@"自签的网站老客户"},@{@"5":@"分配的网站老客户"},@{@"6":@"自签的其他老客户"},@{@"7":@"分配的其他老客户"}];
    
    zhuangtaiArr = @[@{@"-1":@"不限"},@{@"0":@"未联系"},@{@"1":@"初步沟通"},@{@"2":@"见面拜访"},@{@"3":@"确定意向"},@{@"4":@"方案报价"},@{@"5":@"商务谈判"}];
    
    dataArr = [[NSMutableArray alloc] init];
    
#pragma mark - 页面初始化
    
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    /*
    //筛选总区域
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, SelectViewHeight)];
    selectView.backgroundColor = [ToolList getColor:@"fafafa"];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, SelectViewHeight-0.8) toPoint:CGPointMake(__MainScreen_Width, SelectViewHeight-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
     
    jieduanBtn = [[FX_Button alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width/3, SelectViewHeight) andType:@"0" andTitle:@"阶段" andTarget:self andDic:nil];
    zhuangtaiBtn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/3*1, 0, __MainScreen_Width/3, SelectViewHeight) andType:@"0" andTitle:@"状态" andTarget:self andDic:nil];
    shangwuBtn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/3*2, 0, __MainScreen_Width/3, SelectViewHeight) andType:@"0" andTitle:@"商务" andTarget:self andDic:nil];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/3, 8) toPoint:CGPointMake(__MainScreen_Width/3, SelectViewHeight-8) andWeight:0.1 andColorString:@"666666"]];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/3*2, 8) toPoint:CGPointMake(__MainScreen_Width/3*2, SelectViewHeight-8) andWeight:0.1 andColorString:@"666666"]];
    //阶段层
    jieduanView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight)];
    jieduanView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 15)];
    v1.backgroundColor = [UIColor whiteColor];
    //阶段内容层
    jieduanContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width,15+49*4+16+40)];
    jieduanContentView.backgroundColor = [UIColor whiteColor];
    [jieduanView addSubview:jieduanContentView];
    [jieduanView addSubview:v1];
    UIView * jieduanContentView1 = [[UIView alloc] initWithFrame:CGRectMake(13, 15, __MainScreen_Width-4-13, 49*4+16+40)];
    [jieduanContentView addSubview:jieduanContentView1];
    for (int i = 0; i < jieduanArr.count; i ++ ) {
        NSDictionary *dic = [jieduanArr objectAtIndex:i];
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(((__MainScreen_Width-35)/2+9)*(i%2) , (40+9)*(i/2), (__MainScreen_Width-35)/2, 40) andType:@"1" andTitle:@"阶段" andTarget:self andDic:dic];
        [jieduanContentView1 addSubview:btn];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, jieduanContentView.frame.size.height-40, __MainScreen_Width, 40);
    btn.backgroundColor = [ToolList getColor:@"f7f7fc"];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(jieduanCommit:) forControlEvents:UIControlEventTouchUpInside];
    [jieduanContentView addSubview:btn];
    //状态层
    zhuangtaiView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight)];
    zhuangtaiView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 15)];
    v2.backgroundColor = [UIColor whiteColor];
    //状态内容层
    zhuangtaiContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 49*3+16+40+15)];
    zhuangtaiContentView.backgroundColor = [UIColor whiteColor];
    [zhuangtaiView addSubview:zhuangtaiContentView];
    [zhuangtaiView addSubview:v2];
    UIView * zhuangtaiContentView1 = [[UIView alloc] initWithFrame:CGRectMake(13, 15, __MainScreen_Width-4-13, 49*3+16+40+15)];
    [zhuangtaiContentView addSubview:zhuangtaiContentView1];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, zhuangtaiContentView.frame.size.height-40, __MainScreen_Width, 40);
    btn1.backgroundColor = [ToolList getColor:@"f7f7fc"];
    [btn1 setTitle:@"完成" forState:UIControlStateNormal];
    [btn1 setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 addTarget:self action:@selector(zhuangtaiCommit:) forControlEvents:UIControlEventTouchUpInside];
    [zhuangtaiContentView addSubview:btn1];
    for (int i = 0; i < zhuangtaiArr.count; i ++ ) {
        NSDictionary *dic = [zhuangtaiArr objectAtIndex:i];
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(((__MainScreen_Width-44)/3+9)*(i%3) , (40+9)*(i/3), (__MainScreen_Width-44)/3, 40) andType:@"1" andTitle:@"状态" andTarget:self andDic:dic];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [zhuangtaiContentView1 addSubview:btn];
    }
    //商务层
    shangwuView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight)];
    shangwuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    //商务内容层
    shangwuContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [shangwuView addSubview:shangwuContentView];
    [self.view addSubview:jieduanView];
    [self.view addSubview:zhuangtaiView];
    [self.view addSubview:shangwuView];
    [self.view addSubview:selectView];
    [selectView addSubview:jieduanBtn];
    [selectView addSubview:zhuangtaiBtn];
    [selectView addSubview:shangwuBtn];
     */
     
    //标题
    [self addNavgationbar:@"部门客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];
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
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    [self makeTypeView];
    
    searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+HANDVIEW_H+35, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    [searchView addSubview:searchTable];
}

-(void)makeTypeView{
    
    NSArray *typeA = @[@"保护库",@"签约客户",@"收藏夹"];
    
    //头部点击操作区域-- 保护库--签约客户--收藏夹
    UIImageView *handV = [[UIImageView alloc]initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, HANDVIEW_H)];
    handV.userInteractionEnabled = YES;
    handV.image = [UIImage imageNamed:@"bg_filter.png"];
    [self.view addSubview:handV];
    
    for (int i = 0 ; i < typeA.count; i ++) {
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/typeA.count*i, 0, __MainScreen_Width/typeA.count, SelectViewHeight+2-0.8) andType:@"2" andTitle:[typeA objectAtIndex:i] andTarget:self andDic:nil];
        btn.tag = i;
        [handV addSubview:btn];
        if(i == 0)
        {
            btn.isSelect = YES;
            [btn changeBigAndColorCliked:btn];
        }
        
        [selectTypes addObject:btn];
        
    }
    
    UIView *sxView= [[UIView alloc]initWithFrame:CGRectMake(0, HANDVIEW_H+IOS7_Height, __MainScreen_Width,35)];
    sxView.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:sxView];
    
    UILabel *numL = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 28)];
    numL.textColor = [ToolList getColor:@"888888"];
    numL.font = [UIFont systemFontOfSize:12];
    //    numL.tag =NUM_TAB;
    numL.backgroundColor = [UIColor clearColor];
    numL.text = @"共0条";
    [sxView addSubview:numL];
    
    UIButton *addLink = [UIButton buttonWithType:UIButtonTypeCustom];
    addLink.frame = CGRectMake(__MainScreen_Width-52-13, 0, 52, 35);
    addLink.backgroundColor = [UIColor clearColor];
    [addLink setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [addLink setTitle:@"筛选" forState:UIControlStateNormal];
    [addLink addTarget:self action:@selector(JLSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addLink setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    addLink.titleLabel.font = [UIFont systemFontOfSize:12];
    [sxView addSubview:addLink];
}

#pragma mark---头部状态选择
-(void)changeBigAndColorClikedBack:(FX_Button *)typeBt{
    
    for (int i = 0; i < selectTypes.count ; i++) {
        FX_Button * clickedBtn = [selectTypes objectAtIndex:i];
        if (clickedBtn == typeBt) {
            clickedBtn.isSelect = YES;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
        else
        {
            clickedBtn.isSelect = NO;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
    }
    
    switch (typeBt.tag) {
        case 0://保护库
        {
        
            requestDic[@"custTypes"]=jieduanRequestArr;
            
            [self requestAlldata];
            
            
        }
            break;
            
        case 1://签约客户
        {
             requestDic[@"custTypes"]=jieduanRequestArr;
            
            [self requestAlldata];
            
        }
            break;
            
        case 2://收藏夹
        {
            
             requestDic[@"custTypes"]=jieduanRequestArr;
            
            [self requestAlldata];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark---筛选按钮点击
-(void)JLSelectBtnClicked:(UIButton *)selcetB{
    
    
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
#pragma mark - 筛选商务
-(void)shangwuSelectCommit:(UIButton *)btn
{
    
    [shangwuBtn change:@"down"];
    
    if (btn.tag == 0)
    {
        [requestDic setObject:@"" forKey:@"salerId"];
        
    }
    else
    {
        
        [requestDic setObject:[[selectShangWuArr objectAtIndex:btn.tag] objectForKey:@"salerId"] forKey:@"salerId"];
    }
    startPage = 1;
    [self requestAlldata];
    
    [UIView animateWithDuration:0.3 animations:^{
        shangwuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
        
    }];
}
#pragma mark - 筛选商务数据请求失败
-(void)OpenSelectFaile:(NSDictionary *)resultDic
{
    [ToolList showRequestFaileMessageLittleTime:@"筛选条件加载失败，请重试！"];
    
    [shangwuBtn change:@"down"];
}
#pragma mark - 筛选商务数据请求成功
-(void)OpenSelectSuccess:(NSDictionary *)resultDic
{
    for (UIView *subView in shangwuContentView.subviews) {
        [subView removeFromSuperview];
    }
    
    selectShangWuArr = [[NSMutableArray alloc] initWithArray:[resultDic objectForKey:@"result"]];
    NSDictionary *dic =  @{@"salerId":@"-1", @"salerName":@"全部"};
    [selectShangWuArr insertObject:dic atIndex:0];
    
    shangwuContentView.contentSize = CGSizeMake(__MainScreen_Width, 45*selectShangWuArr.count);
    shangwuContentView.frame = CGRectMake(0, 0, __MainScreen_Width, 45*selectShangWuArr.count>__MainScreen_Height*0.68?__MainScreen_Height*0.68:selectShangWuArr.count);
    for (int i = 0 ; i < selectShangWuArr.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*45, __MainScreen_Width, 45);
        
        NSString *title = [[selectShangWuArr objectAtIndex:i] objectForKey:@"salerName"];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
        btn.tag = i;
        [btn addTarget:self action:@selector(shangwuSelectCommit:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        btn.backgroundColor = [UIColor whiteColor];
        [shangwuContentView addSubview:btn];
        
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        shangwuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width,__MainScreen_Height-SelectViewHeight-IOS7_Height);
        
        
    }];
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
    
}
#pragma mark - 数据请求
-(void) requestAlldata
{
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [searchRequestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [FX_UrlRequestManager postByUrlStr:DeptCustM_url andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    [searchRequestDic setObject:theTextField.text forKey:@"custName"];
    startPage = 1;
    flagNeedReload = NO;
    [self requestAlldata];
    return YES;
}

//取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    flagNeedReload = YES;
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custName"];
    [self requestAlldata];
    [self requestAlldata];
    [text resignFirstResponder];
    [jieduanBtn change:@"down"];
    [zhuangtaiBtn change:@"down"];
    [shangwuBtn change:@"down"];
    
    jieduanView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    zhuangtaiView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    shangwuView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - SelectViewHeight);
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
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
    cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    
    NSString *str = [NSString stringWithFormat:@"%@ | %@ | %@" ,[ToolList changeNull:[dic objectForKey:@"salerName"]],[ToolList changeNull:[dic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dic objectForKey:@"intenttype"]]];
    
    
    cell.labelother.text = str;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    [self.navigationController pushViewController:s animated:NO];
}


@end
