//
//  CY_myClientVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/4.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_myClientVC.h"
#import "Fx_TableView.h"
#import "CY_addClientVc.h"
#import "CY_releseCell.h"
#import "UserDetailViewController.h"
#import "SearchViewController.h"
#import "CY_custTypesCell.h"
#import "CY_alertWhyVC.h"
#import "CY_popupV.h"

#define HANDVIEW_H 42
#define VIEW_HEIGHT __MainScreen_Height-IOS7_Height-35-HANDVIEW_H

@interface CY_myClientVC (){
    
    UIScrollView *mainScroll;
    UIView *selectView;
    BOOL isRe;//yes加载更多   no刷新
    UIView *duanBlackView;
    UIView *duanView;//保护客户
    UIView *taiBlackView;
    UIView *taiView;//签约客户
    UIView *jianBlackView;
    UIView *jianView;//收藏夹客户
    UIView *liuBlackView;
    UIView *liuView;//流失客户
    
    BOOL isXuan;//改变状态、筛选、排序要清除原来的数据
    NSMutableArray *selectArr;
    UIButton *addLink;//筛选按钮
    UIView *searchView;
    CY_popupV *poV;//弹出框
    
    int shareState;
    int _websiteOrNot;
}
@property (nonatomic,strong)FX_Button *duanB;
@property (nonatomic,strong)FX_Button *taiB;
@property (nonatomic,strong)FX_Button *xuB;

@property (nonatomic,strong)Fx_TableView *myClientTable;
@property (nonatomic,strong)NSMutableArray *myClientArr;

@property (nonatomic,assign)NSInteger startPage;
@property (nonatomic,strong)NSMutableDictionary *requestDic;//放置请求参数

@property (nonatomic,strong)NSMutableArray *jieduanArr;//阶段状态数据
@property (nonatomic,strong)NSMutableArray *zhuangtaiArr;//状态数据

@property (nonatomic,strong)NSMutableArray *jieduanButtonArr;//阶段按钮数组
@property (nonatomic,strong)NSMutableArray *zhuangtaiButtonArr;//状态按钮数组

@property (nonatomic,strong)NSMutableArray *jieduanRequestArr;
@property (nonatomic,strong)NSMutableArray *zhuangtaiRequestArr;

@property (nonatomic,assign)NSInteger downPage;//保护库 1  签约客户 2 收藏夹 3

@property (nonatomic,strong)NSString *totalStr;//总条数

@property (nonatomic, assign)NSInteger openIndex;//-1不显示操作，其他数字显示
@property (nonatomic,strong)NSMutableArray *typesArr;//承载保护、再联系等状态

@property (nonatomic,strong)NSArray *gxArr;//共享类型
@property (nonatomic,strong)NSArray *lxArr;//客户类型
@property (nonatomic,strong)NSMutableArray *oneButtonArr;//承载单选按钮状态
@property (nonatomic,strong)NSMutableArray *GXoneButtonArr;//共享承载单选按钮状态

@end

@implementation CY_myClientVC

-(void)addTarget:(UIButton *)addBt{
    
    CY_addClientVc *ghVC = [[CY_addClientVc alloc]init];
    ghVC.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController pushViewController:ghVC animated:NO];
}

-(void)LeftAction:(UIButton *)sender{
    if (_isMe) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)RightAction:(UIButton *)sender{
    
    SearchViewController *gh = [[SearchViewController alloc] init];
    gh.isMyclient = YES;
    gh.type = @"2";
//    gh.czBlock = ^(NSDictionary * dic)
//    {
//        [_myClientArr  removeAllObjects];
//        _myClientArr = [[NSMutableArray alloc]initWithObjects:dic, nil];
//        [_myClientTable reloadData];
//        
//    };
    [self.navigationController pushViewController:gh animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //释放成功
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(relseok) name:@"SWSHIFANGOK" object:nil];
    
    _openIndex = -1;
    _typesArr = [[NSMutableArray alloc]init];
    
    _jieduanButtonArr = [[NSMutableArray alloc] init];
    _zhuangtaiButtonArr = [[NSMutableArray alloc] init];

    selectArr = [[NSMutableArray alloc]init];
    _oneButtonArr = [[NSMutableArray alloc]init];
    _GXoneButtonArr =[[NSMutableArray alloc]init];
    
    isXuan = NO;
   
     _downPage = 1;
    _jieduanRequestArr = [[NSMutableArray alloc]initWithObjects:@"2",@"3", nil];
    _zhuangtaiRequestArr = [[NSMutableArray alloc] initWithObjects:@"-1",nil];
    
    NSArray *zhuangtaiArr1 =@[@{@"-1":@"不限"},@{@"6":@"初步沟通"},@{@"7":@"确定意向"},@{@"8":@"方案报价"},@{@"9":@"签单成交"}];
    
    NSArray *zhuangtaiArr2 =@[@{@"-1":@"不限"},@{@"10":@"近期无计划"},@{@"11":@"近期跟进"},@{@"12":@"方案报价"},@{@"13":@"二次成交"}];
    
    NSArray *zhuangtaiArr3 =@[@{@"-1":@"不限"},@{@"0":@"未联系"},@{@"1":@"占线"},@{@"2":@"未找到决策人"},@{@"4":@"稍后联系"},@{@"3":@"意向不明确"},@{@"5":@"有意向"}];
    
    NSArray *jieduanArr1 = @[@{@[@"2",@"3"]:@"不限"},@{@"2":@"保护跟进"},@{@"3":@"意向保护"}];
    
    NSArray *jieduanArr2 =  @[@{@[@"4",@"5",@"6",@"7"]:@"不限"},@{@"4":@"自签网站"},@{@"5":@"分配网站"},@{@"6":@"自签非网站"},@{@"7":@"分配非网站"}];
    
    NSArray *zhuangtaiArr4 =  @[@{@[@"8",@"9"]:@"不限"},@{@"8":@"推送共享"},@{@"9":@"商机共享"}];
    
    _gxArr =@[@{@"-1":@"不限"},@{@"0":@"非共享"},@{@"1":@"签单共享"}];
    _lxArr =@[@{@"-1":@"不限"},@{@"0":@"网站客户"},@{@"1":@"非网站客户"}];
    
    _jieduanArr = [[NSMutableArray alloc]initWithObjects:jieduanArr1,jieduanArr2, nil];
    
    _zhuangtaiArr = [[NSMutableArray alloc]initWithObjects:zhuangtaiArr1,zhuangtaiArr2,zhuangtaiArr2,zhuangtaiArr4, nil];
    
#pragma  mark-----筛选按钮页面
    [self xuanView];
    [self yueView];
    [self jianView];
    [self liushiV];
#pragma 页面初始化
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor whiteColor];
    
    mainScroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    mainScroll.contentSize = CGSizeMake(__MainScreen_Width*2, __MainScreen_Height);
    mainScroll.scrollEnabled = NO;
    [self.view addSubview:mainScroll];
    
    NSArray *typeA = @[@"保护库",@"签约客户",@"流失客户",@"共享客户"];
    
    //头部点击操作区域-- 保护库--签约客户--流失客户--共享客户
    UIImageView *handV = [[UIImageView alloc]initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, HANDVIEW_H)];
    handV.userInteractionEnabled = YES;
    handV.image = [UIImage imageNamed:@"bg_filter.png"];
    [mainScroll addSubview:handV];
    
    for (int i = 0 ; i < typeA.count; i ++) {
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/typeA.count*i, 0, __MainScreen_Width/typeA.count, SelectViewHeight+2-0.8) andType:@"2" andTitle:[typeA objectAtIndex:i] andTarget:self andDic:nil];
        btn.tag = i;
        [handV addSubview:btn];
        if(i == 0)
        {
            btn.isSelect = YES;
            [btn changeBigAndColorCliked:btn];
        }
        
        [selectArr addObject:btn];
        
    }
    
    UIView *sxView= [[UIView alloc]initWithFrame:CGRectMake(0, HANDVIEW_H+IOS7_Height, __MainScreen_Width,35)];
    sxView.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [mainScroll addSubview:sxView];
    
    UILabel *numL = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 28)];
    numL.textColor = [ToolList getColor:@"888888"];
    numL.font = [UIFont systemFontOfSize:12];
    numL.tag = 1893;
    numL.backgroundColor = [UIColor clearColor];
   
    [sxView addSubview:numL];

    addLink = [UIButton buttonWithType:UIButtonTypeCustom];
    addLink.frame = CGRectMake(__MainScreen_Width-52-13, 0, 52, 35);
    addLink.backgroundColor = [UIColor clearColor];
    [addLink setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [addLink setTitle:@"筛选" forState:UIControlStateNormal];
    [addLink addTarget:self action:@selector(pSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addLink setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    addLink.titleLabel.font = [UIFont systemFontOfSize:12];
    [sxView addSubview:addLink];
    
    //添加列表
    _myClientTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+handV.frame.size.height+35, __MainScreen_Width, __MainScreen_Height-IOS7_Height-handV.frame.size.height-35) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _myClientTable.dataSource = self;
    _myClientTable.delegate = self;
    [_myClientTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_myClientTable.refreshHeader autoRefreshWhenViewDidAppear];
    [mainScroll addSubview:_myClientTable];
    
    [duanBlackView addSubview:duanView];
    [taiBlackView addSubview:taiView];
    [jianBlackView addSubview:jianView];
    [liuBlackView addSubview:liuView];
    [mainScroll addSubview:duanBlackView];
    [mainScroll addSubview:taiBlackView];
    [mainScroll addSubview:jianBlackView];
    [mainScroll addSubview:liuBlackView];
    [mainScroll addSubview:selectView];
    [mainScroll addSubview:_duanB];
    [mainScroll addSubview:_taiB];
    [mainScroll addSubview:_xuB];
    
    handView *Hvc = [[handView alloc]initWithTitle:@"我的客户" andRightImage:@"btn_search_homepage" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [mainScroll addSubview:Hvc];
    
    
    //添加客户按钮
    UIButton *addV = [UIButton buttonWithType:UIButtonTypeCustom];
    addV.frame = CGRectMake(__MainScreen_Width-69, IOS7_StaticHeight, 40, 40);
    [addV setImage:[UIImage imageNamed:@"btn_add_top.png"] forState:UIControlStateNormal];
    [addV addTarget:self action:@selector(addTarget:) forControlEvents:UIControlEventTouchUpInside];
    [Hvc addSubview:addV];
    
    
    
    _requestDic = [[NSMutableDictionary alloc]init];
    _startPage = 1;
    
    isRe = NO;
    _requestDic[@"sortName"]=@"1";//1代表获取时间排序，2代表更新时间排序
    _requestDic[@"custTypes"]=_jieduanRequestArr;
    _requestDic[@"intenttypes"]=_zhuangtaiRequestArr;
    
    [self requestAlldata];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shifangok) name:@"SWSHIFANGOK" object:nil];
}
-(void)shifangok
{
    _startPage = 1;
    
    isRe = NO;
    _requestDic[@"sortName"]=@"1";//1代表获取时间排序，2代表更新时间排序
    _requestDic[@"custTypes"]=_jieduanRequestArr;
    _requestDic[@"intenttypes"]=_zhuangtaiRequestArr;
    [self requestAlldata];

}
#pragma mark---头部状态选择
-(void)changeBigAndColorClikedBack:(FX_Button *)typeBt{

    if (duanBlackView.frame.origin.y == IOS7_Height+HANDVIEW_H+35 || taiBlackView.frame.origin.y == IOS7_Height+HANDVIEW_H+35 ||jianBlackView.frame.origin.y == IOS7_Height+HANDVIEW_H+35 || jianBlackView.frame.origin.y == IOS7_Height+HANDVIEW_H+35) {

        [self pSelectBtnClicked:addLink];
    }
    
    for (int i = 0; i < selectArr.count ; i++) {
        FX_Button * clickedBtn = [selectArr objectAtIndex:i];
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
      [_jieduanRequestArr removeAllObjects];
     [_zhuangtaiRequestArr removeAllObjects];
    
    _startPage = 1;
    switch (typeBt.tag) {
        case 0://保护库
        {
            [_jieduanRequestArr addObjectsFromArray:@[@"2",@"3"]];
             _downPage = 1;
          
        }
            break;
            
        case 1://签约客户
        {
            [_jieduanRequestArr addObjectsFromArray:@[@"4",@"5",@"6",@"7"]];
            _downPage = 2;
        }
            break;
            
        case 3://共享客户
        {
            [_jieduanRequestArr addObjectsFromArray:@[@"8",@"9"]];
             _downPage = 4;
        }
            break;
            
        case 2://流失客户
        {
            [_jieduanRequestArr addObjectsFromArray:@[@"1"]];
            _downPage = 3;
        }
            break;
            
        default:
            break;
    }
  
    
    [_zhuangtaiRequestArr addObjectsFromArray:@[@"-1"]];
    _requestDic[@"sortName"]=@"1";//1代表获取时间排序，2代表更新时间排序

    [self requestAlldata];
}

#pragma mark---筛选按钮
-(void)pSelectBtnClicked:(UIButton *)selectBt{
    
    selectBt.selected = !selectBt.selected;
    
    if (_downPage==1) {
        
        if (selectBt.selected) {
            
            [UIView animateWithDuration:0.3 animations:^{
                duanBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
            }];
        }else{
            
            [UIView animateWithDuration:0.3 animations:^{
                duanBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
            }];
        }
       
    }
    else if (_downPage == 2){
        
         if (selectBt.selected) {
                [UIView animateWithDuration:0.3 animations:^{
                    taiBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
                }];
         }else{
             
             [UIView animateWithDuration:0.3 animations:^{
                 taiBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
             }];
         }

    }
    
    else if (_downPage == 3){
        
        
        if (selectBt.selected) {
            [UIView animateWithDuration:0.3 animations:^{
                liuBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                liuBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
            }];
            
        }
    }
    
    else if (_downPage == 4)
    {
        
        
        if (selectBt.selected) {
            [UIView animateWithDuration:0.3 animations:^{
                jianBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                jianBlackView.frame =CGRectMake(0, IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-HANDVIEW_H-35);
            }];
            
        }
    }
}

#pragma mark----创建保护库筛选页面
-(void)xuanView{
    
    duanBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, VIEW_HEIGHT)];
    
    duanBlackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    //阶段展示区域
    duanView = [[UIView alloc] init];
    duanView.backgroundColor = [UIColor whiteColor];
    
    NSArray *zhuangtaiA = [_zhuangtaiArr objectAtIndex:_downPage-1];
    
    UIView *zhuangtV = [[UIView alloc]init];
    zhuangtV.backgroundColor = [UIColor clearColor];
    
    if (zhuangtaiA.count%3 != 0) {
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54+59.5);
    }else{
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54);
    }
    
    [duanView addSubview:zhuangtV];
    
    //线
    [zhuangtV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, zhuangtV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, zhuangtV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 38, 14)];
    zhuangtaiL.text = @"状态";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [zhuangtV addSubview:zhuangtaiL];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"状态" andTarget:self andDic:dic];
        
        [zhuangtV addSubview:btn];
    }

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [ToolList getColor:@"f7f7fc"];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(zhuangtaiCommit:) forControlEvents:UIControlEventTouchUpInside];
    [duanView addSubview:btn];
    
    if (_downPage != 3) {
        
        NSArray *jieduanB = [_jieduanArr objectAtIndex:_downPage-1];
        
        UIView *jieDV = [[UIView alloc]init];
        jieDV.backgroundColor = [UIColor clearColor];
        if (jieduanB.count%3 ==0) {
              jieDV.frame =CGRectMake(0, zhuangtV.frame.origin.y+zhuangtV.frame.size.height, __MainScreen_Width, 34+(jieduanB.count/3)*54);
         
        }else{
             jieDV.frame =CGRectMake(0, zhuangtV.frame.origin.y+zhuangtV.frame.size.height, __MainScreen_Width, 34+(jieduanB.count/3)*54+59.5);
        }

        [duanView addSubview:jieDV];
        
        //线
//        [jieDV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, jieDV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, jieDV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
        UILabel *zhuangtaiL2 = [[UILabel alloc]init];
        zhuangtaiL2.frame = CGRectMake(12, 10, 38, 14);
        zhuangtaiL2.text = @"阶段";
        zhuangtaiL2.font = [UIFont systemFontOfSize:14];
        zhuangtaiL2.textColor = [ToolList getColor:@"666666"];
        [jieDV addSubview:zhuangtaiL2];
        
        for (int i = 0; i < jieduanB.count; i ++ ) {
            
            NSDictionary *dic2 = [jieduanB objectAtIndex:i];
            
            FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"阶段" andTarget:self andDic:dic2];
            
            [jieDV addSubview:btn2];
        }
        
        if (jieDV.frame.origin.y+jieDV.frame.size.height< VIEW_HEIGHT-40) {
            
             btn.frame = CGRectMake(0, VIEW_HEIGHT-40, __MainScreen_Width, 40);
        }
        
    }else{
        
        if (zhuangtV.frame.origin.y+zhuangtV.frame.size.height< VIEW_HEIGHT-40) {
            
            btn.frame = CGRectMake(0,  VIEW_HEIGHT-40, __MainScreen_Width, 40);
        }
        
    }

    duanView.frame = CGRectMake(0, 0, __MainScreen_Width,btn.frame.origin.y+btn.frame.size.height);
}

#pragma mark----创建签约客户筛选页面
-(void)yueView{
    
    taiBlackView = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, VIEW_HEIGHT)];
    taiBlackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];

    taiView = [[UIView alloc] init];
    taiView.backgroundColor = [UIColor whiteColor];

    NSArray *zhuangtaiA = [_zhuangtaiArr objectAtIndex:1];
    UIView *zhuangtV = [[UIView alloc]init];
    zhuangtV.backgroundColor = [UIColor clearColor];
    
    if (zhuangtaiA.count%3 != 0) {
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54+59.5);
    }else{
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54);
    }
    
    [taiView addSubview:zhuangtV];
    
    //线
    [zhuangtV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, zhuangtV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, zhuangtV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 38, 14)];
    zhuangtaiL.text = @"状态";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [zhuangtV addSubview:zhuangtaiL];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"状态" andTarget:self andDic:dic];
        
        [zhuangtV addSubview:btn];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [ToolList getColor:@"f7f7fc"];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(zhuangtaiCommit:) forControlEvents:UIControlEventTouchUpInside];
    [taiView addSubview:btn];
    
    if (_downPage != 3) {
        
        NSArray *jieduanB = [_jieduanArr objectAtIndex:1];
        
        UIView *jieDV = [[UIView alloc]init];
        jieDV.backgroundColor = [UIColor clearColor];
        if (jieduanB.count%3 ==0) {
            jieDV.frame =CGRectMake(0, zhuangtV.frame.origin.y+zhuangtV.frame.size.height, __MainScreen_Width, 34+(jieduanB.count/3)*54);
            
        }else{
            jieDV.frame =CGRectMake(0, zhuangtV.frame.origin.y+zhuangtV.frame.size.height, __MainScreen_Width, 34+(jieduanB.count/3)*54+59.5);
        }
        
        [taiView addSubview:jieDV];
        
        //线
        [jieDV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, jieDV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, jieDV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
        UILabel *zhuangtaiL2 = [[UILabel alloc]init];
        zhuangtaiL2.frame = CGRectMake(12, 10, 38, 14);
        zhuangtaiL2.text = @"阶段";
        zhuangtaiL2.font = [UIFont systemFontOfSize:14];
        zhuangtaiL2.textColor = [ToolList getColor:@"666666"];
        [jieDV addSubview:zhuangtaiL2];
        
        for (int i = 0; i < jieduanB.count; i ++ ) {
            
            NSDictionary *dic2 = [jieduanB objectAtIndex:i];
            
            FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"阶段" andTarget:self andDic:dic2];
            
            [jieDV addSubview:btn2];
        }
        
        if (_downPage == 1) {
            
            UIView *gxDV = [[UIView alloc]init];
            gxDV.backgroundColor = [UIColor clearColor];
            if (_gxArr.count%3 ==0) {
                gxDV.frame =CGRectMake(0, jieDV.frame.origin.y+jieDV.frame.size.height, __MainScreen_Width, 34+(_gxArr.count/3)*54);
                
            }else{
                gxDV.frame =CGRectMake(0, jieDV.frame.origin.y+jieDV.frame.size.height, __MainScreen_Width, 34+(_gxArr.count/3)*54+59.5);
            }
            
            [taiView addSubview:gxDV];
            
            //线
//            [gxDV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, gxDV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, gxDV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
            UILabel *zhuangtaiL3 = [[UILabel alloc]init];
            zhuangtaiL3.frame = CGRectMake(12, 10, 58, 14);
            zhuangtaiL3.text = @"共享类型";
            zhuangtaiL3.font = [UIFont systemFontOfSize:14];
            zhuangtaiL3.textColor = [ToolList getColor:@"666666"];
            [gxDV addSubview:zhuangtaiL3];
            if (_GXoneButtonArr.count) {
                [_GXoneButtonArr removeAllObjects];
            }
            for (int i = 0; i < _gxArr.count; i ++ ) {
                
                NSDictionary *dic2 = [_gxArr objectAtIndex:i];
                
                FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"共享类型" andTarget:self andDic:dic2];
                
                [gxDV addSubview:btn2];
               
                [_GXoneButtonArr addObject:btn2];
            }

            if (gxDV.frame.origin.y+gxDV.frame.size.height<VIEW_HEIGHT-40) {
                
                  btn.frame = CGRectMake(0,VIEW_HEIGHT-40, __MainScreen_Width, 40);
            }
            
        }else{
            
            if (jieDV.frame.origin.y+jieDV.frame.size.height<VIEW_HEIGHT-40) {
                
                btn.frame = CGRectMake(0, VIEW_HEIGHT-40, __MainScreen_Width, 40);
            }
           
        }
        
    }
   
    else{
        
        if (zhuangtV.frame.origin.y+zhuangtV.frame.size.height<VIEW_HEIGHT-40) {
            
            btn.frame = CGRectMake(0, VIEW_HEIGHT-40, __MainScreen_Width, 40);
        }
     
    }
    
    taiView.frame = CGRectMake(0, 0, __MainScreen_Width,btn.frame.origin.y+btn.frame.size.height);
}

#pragma mark----创建共享客户筛选页面
-(void)jianView{
    
    jianBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, VIEW_HEIGHT)];
    
    jianBlackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    //阶段展示区域
    jianView = [[UIView alloc] init];
    jianView.backgroundColor = [UIColor whiteColor];
    
    NSArray *zhuangtaiA = [_zhuangtaiArr objectAtIndex:3];
    
    UIView *zhuangtV = [[UIView alloc]init];
    zhuangtV.backgroundColor = [UIColor clearColor];
    
    if (zhuangtaiA.count%3 != 0) {
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54+59.5);
    }else{
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54);
    }
    
    [jianView addSubview:zhuangtV];
    
    //线
    [zhuangtV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, zhuangtV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, zhuangtV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 78, 14)];
    zhuangtaiL.text = @"阶段";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [zhuangtV addSubview:zhuangtaiL];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"状态" andTarget:self andDic:dic];
        
        [zhuangtV addSubview:btn];
    }
    
    UIView *lxDV = [[UIView alloc]init];
    lxDV.backgroundColor = [UIColor clearColor];
    if (_lxArr.count%3 ==0) {
        lxDV.frame =CGRectMake(0, zhuangtV.frame.origin.y+zhuangtV.frame.size.height, __MainScreen_Width, 34+(_lxArr.count/3)*54);
        
    }else{
        lxDV.frame =CGRectMake(0, zhuangtV.frame.origin.y+zhuangtV.frame.size.height, __MainScreen_Width, 34+(_lxArr.count/3)*54+59.5);
    }
    
    [jianView addSubview:lxDV];
    
    //线
//    [lxDV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, lxDV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, lxDV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    UILabel *zhuangtaiL3 = [[UILabel alloc]init];
    zhuangtaiL3.frame = CGRectMake(12, 10, 58, 14);
    zhuangtaiL3.text = @"客户类型";
    zhuangtaiL3.font = [UIFont systemFontOfSize:14];
    zhuangtaiL3.textColor = [ToolList getColor:@"666666"];
    [lxDV addSubview:zhuangtaiL3];
    if (_oneButtonArr.count) {
        [_oneButtonArr removeAllObjects];
    }
    for (int i = 0; i < _lxArr.count; i ++ ) {
        
        NSDictionary *dic2 = [_lxArr objectAtIndex:i];
        
        FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"客户类型" andTarget:self andDic:dic2];
        
        [lxDV addSubview:btn2];
        
        [_oneButtonArr addObject:btn2];
    }
    

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [ToolList getColor:@"f7f7fc"];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(zhuangtaiCommit:) forControlEvents:UIControlEventTouchUpInside];
    [jianView addSubview:btn];
    
    if (lxDV.frame.origin.y+lxDV.frame.size.height<VIEW_HEIGHT-40) {
        
        btn.frame = CGRectMake(0,VIEW_HEIGHT-40, __MainScreen_Width, 40);
    }
    
    jianView.frame = CGRectMake(0, 0, __MainScreen_Width,btn.frame.origin.y+btn.frame.size.height);
}

#pragma mark----创建流失客户筛选页面
-(void)liushiV{
    
    liuBlackView = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+HANDVIEW_H+35-__MainScreen_Height, __MainScreen_Width, VIEW_HEIGHT)];
    liuBlackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    liuView = [[UIView alloc] init];
    liuView.backgroundColor = [UIColor whiteColor];
    
    NSArray *zhuangtaiA = [_zhuangtaiArr objectAtIndex:2];
    UIView *zhuangtV = [[UIView alloc]init];
    zhuangtV.backgroundColor = [UIColor clearColor];
    
    if (zhuangtaiA.count%3 != 0) {
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54+59.5);
    }else{
        
        zhuangtV.frame =CGRectMake(0, 0, __MainScreen_Width, 34+(zhuangtaiA.count/3)*54);
    }
    
    [liuView addSubview:zhuangtV];
    
    //线
//    [zhuangtV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, zhuangtV.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, zhuangtV.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 38, 14)];
    zhuangtaiL.text = @"状态";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [zhuangtV addSubview:zhuangtaiL];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i%3*2+1)+(i%3)*((__MainScreen_Width-72)/3) , 54*(i/3)+34, (__MainScreen_Width-72)/3, 34) andType:@"1" andTitle:@"状态" andTarget:self andDic:dic];
        
        [zhuangtV addSubview:btn];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [ToolList getColor:@"f7f7fc"];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(zhuangtaiCommit:) forControlEvents:UIControlEventTouchUpInside];
    [liuView addSubview:btn];
  
    if (zhuangtV.frame.origin.y+zhuangtV.frame.size.height<VIEW_HEIGHT-40) {
        
        btn.frame = CGRectMake(0, VIEW_HEIGHT-40, __MainScreen_Width, 40);
    }

    
    liuView.frame = CGRectMake(0, 0, __MainScreen_Width,btn.frame.origin.y+btn.frame.size.height);
}

#pragma mark =======状态选择完成
-(void)zhuangtaiCommit:(id)sender{

    if (_downPage != 3 || _downPage != 4) {
        
        if (_jieduanButtonArr.count) {
            
            [_jieduanRequestArr removeAllObjects];
        }
        
        for (FX_Button *btn in _jieduanButtonArr) {
            
            NSArray *dicArr = [_jieduanArr objectAtIndex:_downPage-1];
            
            for (NSDictionary *dic in dicArr) {
                
                if([[[dic allValues]lastObject] isEqualToString:btn.titleLabel.text])
                {
                    
                    if ([btn.titleLabel.text isEqualToString:@"不限"]) {
                        
                        [_jieduanRequestArr addObjectsFromArray:[[dic allKeys] lastObject]];
                        break;
                    }
                    
                    [_jieduanRequestArr addObject:[[dic allKeys] lastObject]];

                    break;
                }
                
            }
        }

    }
    
    if (_zhuangtaiButtonArr.count) {
        
         [_zhuangtaiRequestArr removeAllObjects];
    }
    
        for (FX_Button *btn in _zhuangtaiButtonArr) {
        
            NSArray *taiArr = [_zhuangtaiArr objectAtIndex:_downPage-1];
            
            for (NSDictionary *dic in taiArr) {
                
                if([[[dic allValues]lastObject] isEqualToString:btn.titleLabel.text])
                {
                    if ([btn.titleLabel.text isEqualToString:@"不限"]) {
                       
                        [_zhuangtaiRequestArr addObject:[[dic allKeys] lastObject]];
                    }else{
                         [_zhuangtaiRequestArr addObject:[[dic allKeys] lastObject]];
                    }
                    
                    break;

                }
                
            }
        
        }
    if (_downPage == 2) {
        
          [_requestDic setObject:[NSNumber numberWithInt:shareState] forKey:@"shareState"];
    }
    else if (_downPage == 4){
        
         [_requestDic setObject:[NSNumber numberWithInt:_websiteOrNot] forKey:@"websiteOrNot"];
    }
    else{
        
        [_requestDic removeObjectForKey:@"shareState"];
        [_requestDic removeObjectForKey:@"websiteOrNot"];
    }
    

    if (_downPage != 4) {
        
        [_requestDic setObject:_jieduanRequestArr forKey:@"custTypes"];
        [_requestDic setObject:_zhuangtaiRequestArr forKey:@"intenttypes"];
    }else{
        
        [_requestDic setObject:_jieduanRequestArr forKey:@"custTypes"];
       [_requestDic removeObjectForKey:@"intenttypes"];
    }
      
    _startPage = 1;
    [self requestAlldata];
    
    isRe = NO;
    
     [self pSelectBtnClicked:addLink];
    
}


#pragma mark -- ****条件筛选未点击完成前
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
            int index = -2;
            if([btn.titleLabel.text isEqualToString:@"不限"])
            {
                for (FX_Button *btnS in _jieduanButtonArr) {
                    [btnS changeType1Btn:NO];
                }
                [_jieduanButtonArr removeAllObjects];
                
            }
            else
            {
                for (FX_Button *btnS in _jieduanButtonArr) {
                    if([btnS.titleLabel.text isEqualToString:@"不限"])
                    {
                        index = [_jieduanButtonArr indexOfObject:btnS];
                        [btnS changeType1Btn:NO];
                    }
                }
                if(index != -2)
                {
                    [_jieduanButtonArr removeObjectAtIndex:index];
                }
            }
            if([_jieduanButtonArr indexOfObject:btn] == NSNotFound)
            {
                [_jieduanButtonArr addObject:btn];
            }
        }
        else
        {
            if( [_jieduanButtonArr indexOfObject:btn] != NSNotFound)
            {
                [_jieduanButtonArr removeObject:btn];
            }
            
        }
    }
    else if ([str isEqualToString:@"共享类型"]){//单选
      
        if(btn.isSelect){
           
                for (FX_Button *btnS in _GXoneButtonArr){
                    
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                       
                    }
                }
            shareState = [[[dic1 allKeys] lastObject] intValue];
            
        }
    }
    else if ( [str isEqualToString:@"客户类型"]){
        
        for (FX_Button *btnS in _oneButtonArr){
            
            if(btnS!=btn)
            {
                [btnS changeType1Btn:NO];
            }
        }
        _websiteOrNot =[[[dic1 allKeys] lastObject] intValue];
    }
    
    //状态回馈
    else
    {
        if(btn.isSelect)
        {
            NSInteger index = -1;
            if([btn.titleLabel.text isEqualToString:@"不限"])
            {
                for (FX_Button *btnS in _zhuangtaiButtonArr) {
                    [btnS changeType1Btn:NO];
                }
                [_zhuangtaiButtonArr removeAllObjects];
            }
            else
            {
                for (FX_Button *btnS in _zhuangtaiButtonArr) {
                    if([btnS.titleLabel.text isEqualToString:@"不限"])
                    {
                        index = [_zhuangtaiButtonArr indexOfObject:btnS];
                        [btnS changeType1Btn:NO];
                    }
                }
                if(index != -1)
                {
                    [_zhuangtaiButtonArr removeObjectAtIndex:index];
                }
            }
            if([_zhuangtaiButtonArr indexOfObject:btn] == NSNotFound)
            {
                [_zhuangtaiButtonArr addObject:btn];
            }
            
        }
        else
        {
            if( [_zhuangtaiButtonArr indexOfObject:btn] != NSNotFound)
            {
                [_zhuangtaiButtonArr removeObject:btn];
            }
            
        }
        
    }
    
}

#pragma mark 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    isRe = NO;
    _startPage = 1;
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    isRe = YES;
    _startPage ++;
    [self requestAlldata];
    
}

-(void) requestAlldata
{
    _requestDic[@"pagesize"]=[NSNumber numberWithInt:10];
    
    [_requestDic setObject:[NSString stringWithFormat:@"%ld",_startPage] forKey:@"pageNo"];
//                                                         NSLog(@"++++++++%@",_requestDic);
    
    if(_downPage == 3){
        
       [FX_UrlRequestManager postByUrlStr:salerLostCust_url andPramas:_requestDic andDelegate:self andSuccess:@"myClientSuccess:" andFaild:@"myClientFild:" andIsNeedCookies:YES];
        
        return;
    }
    
    [FX_UrlRequestManager postByUrlStr:myClient_url andPramas:_requestDic andDelegate:self andSuccess:@"myClientSuccess:" andFaild:@"myClientFild:" andIsNeedCookies:YES];
}

-(void)myClientSuccess:(NSDictionary *)sucDic{
    
    [_myClientTable.refreshHeader endRefreshing];
    [_myClientTable.refreshFooter endRefreshing];

    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        _totalStr = [NSString stringWithFormat:@"%@",[sucDic objectForKey:@"total"]];
        //hhhhhhh 
        UILabel *numL = ( UILabel *)[self.view viewWithTag:1893];
        numL.text = [NSString stringWithFormat:@"共%@条",_totalStr];
        
        if (isRe ) {
           
            NSArray *dataArr =[sucDic objectForKey:@"result"];

            if (dataArr.count) {
                
                 [_myClientArr addObjectsFromArray:dataArr];
                
            }else{
                
                 [ToolList showRequestFaileMessageLittleTime:@"我的客户暂无更多数据"];
            }
            

        }else{
            
            if ([[sucDic objectForKey:@"result"] count ]== 0) {
                
                [ToolList showRequestFaileMessageLittleTime:@"我的客户暂无数据"];
                
            }
            _myClientArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
        }
        
    }

    
    [_myClientTable reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_myClientArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_downPage == 3) {
        if(_openIndex == indexPath.row){
            
            return 151.0f;
            
        }else{
            
            return 106.0f;
        }
    }
        return 85.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *CellIdentifier = @"SeaListCell";
    CY_releseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CY_releseCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    
    NSDictionary *dataDic = [_myClientArr objectAtIndex:indexPath.row];
    cell.nameLabel.text = [ToolList changeNull:[dataDic objectForKey:@"custName"]];
    
    if (_downPage == 1) {
    
        NSString *label2 = [NSString stringWithFormat:@"%@ | %@ | %@天",[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dataDic objectForKey:@"intentType"]],[ToolList changeNull:[dataDic objectForKey:@"exceedTime"]]];
        NSString *timeStr =[dataDic objectForKey:@"exceedTime"];
        NSRange range = [label2 rangeOfString:@"天"];
        
        NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:label2];
        //
        //设置字体
        UIFont *baseFont1 = [UIFont systemFontOfSize:16];
        [attrString1 addAttribute:NSFontAttributeName value:baseFont1 range:NSMakeRange(range.location-timeStr.length, timeStr.length)];//设置所有的字体
        
        // 设置颜色
        UIColor *color1 = [ToolList getColor:@"ff3333"];
        [attrString1 addAttribute:NSForegroundColorAttributeName
                            value:color1
                            range:NSMakeRange(range.location-timeStr.length, timeStr.length)];
        
        cell.typeLabel.attributedText = attrString1;

    }
    else if (_downPage == 2)
    {
        NSString *label2 = [NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dataDic objectForKey:@"intentType"]],[ToolList changeNull:[dataDic objectForKey:@"shareState"]]];
        cell.typeLabel.text = label2;
    }
  
    else if (_downPage == 3)
    {
        NSString *label2 = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"intentType"]]];
        cell.typeLabel.text = label2;
    }
    else if (_downPage == 4)
    {
        NSString *label2 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dataDic objectForKey:@"websiteOrNot"]]];
        cell.typeLabel.text = label2;
    }
    
   return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    NSDictionary *dataDic = [_myClientArr objectAtIndex:indexPath.row];
    if ([[dataDic objectForKey:@"custId"]length]) {
        
        UserDetailViewController *userV = [[UserDetailViewController alloc]initwithCust:[dataDic objectForKey:@"custId"]];
        userV.custNameStr = [dataDic objectForKey:@"custName"];
        [self.navigationController pushViewController:userV animated:NO];
    }

}

#pragma mark----点击按钮收缩、显示操作
-(IBAction)clearTouch:(UIButton *)sender{
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-1011 inSection:0];
        
        CY_custTypesCell *cell = (CY_custTypesCell *)[_myClientTable cellForRowAtIndexPath:indexPath];
        
        if (_openIndex == indexPath.row ) {
            
            _openIndex = -1;
            
            cell.PicImage.image = [UIImage imageNamed:@"btn_list_up.png"];
            cell.bgView.hidden = YES;
            
            
        }else{
            
            if (_openIndex!=-1) {
                
                NSIndexPath *ppp = [NSIndexPath indexPathForRow:_openIndex inSection:0];
                CY_custTypesCell *oldcell = [_myClientTable cellForRowAtIndexPath:ppp];
                
                UIView *oldve=(UIView *)[oldcell.contentView viewWithTag:110];
                oldcell.PicImage.image = [UIImage imageNamed:@"btn_list_down.png"];
                oldve.hidden = YES;
            }
            
            cell.PicImage.image = [UIImage imageNamed:@"btn_list_up.png"];
            _openIndex = indexPath.row;
            
            cell.bgView.hidden = NO;
            
        }
        
        [_myClientTable reloadData];
  
}

#pragma mark----释放
-(IBAction)relseTouch:(UIButton *)sender{
    
    NSDictionary *dic = [_myClientArr objectAtIndex:sender.tag-666];
    
    CY_alertWhyVC *dd = [[CY_alertWhyVC alloc] init];
    
    dd.IntentCustId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"custId"]];
    
    [self presentViewController:dd animated:YES completion:^{
        
    }];
}

-(void)relseok{
    _openIndex = -1;

    [_jieduanRequestArr removeAllObjects];
    [_zhuangtaiRequestArr removeAllObjects];
    if (_downPage ==1) {
        
          [_jieduanRequestArr addObjectsFromArray:@[@"2",@"3"]];
    }
    else if (_downPage ==2){
        [_jieduanRequestArr addObjectsFromArray:@[@"4",@"5",@"6",@"7"]];
    }
    else if (_downPage ==3){
        
        [_zhuangtaiRequestArr addObjectsFromArray:@[@"-1"]];
    }
    else if (_downPage ==4){
        
        [_zhuangtaiRequestArr addObjectsFromArray:@[@"8",@"9"]];
    }
  
    [_zhuangtaiRequestArr addObjectsFromArray:@[@"-1"]];


}

#pragma mark --- 在联系
-(IBAction)lianxiTouch:(UIButton *)sender{

    if (poV== nil) {

        poV = [[CY_popupV alloc]initWithFrame:CGRectMake(13, 100, __MainScreen_Width-26, 200) andMytextArr:@[@"占线",@"未找到决策人",@"意向不明确",@"稍后联系",@"有意向"] andtarget:self andTag:sender.tag];
        
        [self.view addSubview:poV];
        
    }
    
}

#pragma mark --- 关闭弹窗
-(void)closeClickButton1{
     _openIndex = -1;
    [poV removeFromSuperview];
    poV = nil;
     [self headerRefresh:_myClientTable];
}

 #pragma mark --- 在联系选择条件后
-(void)changeType:(UIButton *)bt{
  
    if ([bt.titleLabel.text length]) {
        NSDictionary *dic = [_myClientArr objectAtIndex:bt.tag-777];
        NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
        [arr setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"custId"]] forKey:@"custId"];
        [arr setObject:bt.titleLabel.text forKey:@"intentType"];
        [FX_UrlRequestManager postByUrlStr:changeCustState_url andPramas:arr andDelegate:self andSuccess:@"changeCustStateSuccess:" andFaild:nil andIsNeedCookies:YES];
    }

    [poV removeFromSuperview];
    poV = nil;
}

-(void)changeCustStateSuccess:(NSDictionary *)dic{
    
       _openIndex = -1;
    if ([[dic objectForKey:@"code"] intValue]==200) {
     
         [self headerRefresh:_myClientTable];
    }
}

#pragma mark --- 保护
-(IBAction)protectTouch:(UIButton *)sender{
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    NSDictionary *dic = [_myClientArr objectAtIndex:sender.tag-888];
    dataDic[@"custId"]= [NSString stringWithFormat:@"%@",[dic objectForKey:@"custId"]];
    [FX_UrlRequestManager postByUrlStr:protectCustomer_url andPramas:dataDic andDelegate:self andSuccess:@"swprotectSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)swprotectSuccess:(NSDictionary *)sucDic{
    
    _openIndex = -1;
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        [self headerRefresh:_myClientTable];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
