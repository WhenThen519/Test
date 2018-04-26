//
//  BuMenViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "BuMenViewController.h"
#import "Fx_TableView.h"
#import "BuMenTableViewCell.h"
#import "FX_Button.h"
#import "UserDetailViewController.h"
#define Btn_W 90
@interface BuMenViewController ()
{
    UIView *selectContentView;
    UIScrollView *selectContentScrollView;
    NSString *bumenId;
    NSString *depId;
    NSArray *buMenArr;
    NSArray *new_addArr;

    NSArray *jieduanArr;
    NSArray *zhuangtaiArr;
    NSMutableArray *jieduanBtnArr;
    NSMutableArray *zhuangtaiBtnArr;
    NSMutableArray *bumenBtnArr;
    NSMutableArray *swBtnArr;
    NSMutableArray *new_addBtnArr;
    BOOL isUpSelectView;
    //个数
    UILabel *productNum_L;
    //筛选按钮
    UIButton *product_Select_Btn;
    //当前列
    int currentPage;
    //筛选条件请求传参
    NSMutableDictionary *requestDic;
 
    //开始数据标识
    int startPage;
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
    NSMutableArray *selectBtnArr;
    //搜索请求传参
    NSMutableDictionary *searchRequestDic;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
    BOOL flagNeedReload;
    
    //搜索数据列表
    Fx_TableView *searchTable;
    
    UIView *line2;
    UIButton *btnCommit;
    UIView *swView;
    UIScrollView *selectView;
}
@end

@implementation BuMenViewController

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

#pragma mark - 总监点击部门显示商务操作
-(void)makeSWtwo:(NSArray *)empArr{
    
   
    float sw_h = 0.0f;
    float main_h =0.0f;
     [swView removeFromSuperview];
    swView = nil;
    
    if (empArr.count) {
       
       sw_h = 35+(empArr.count+2)/3*45;
       main_h = line2.frame.origin.y+line2.frame.size.height+sw_h+35;
        
        swView = [[UIView alloc]initWithFrame:CGRectMake(0, line2.frame.origin.y+line2.frame.size.height, __MainScreen_Width, sw_h)];
        swView.backgroundColor = [UIColor clearColor];
        [selectContentScrollView addSubview:swView];
        
        //商务
        UILabel *z_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, __MainScreen_Width-20, 35)];
        z_l.font = [UIFont systemFontOfSize:14];
        z_l.textColor = [ToolList getColor:@"666666"];
        z_l.text = @"商务";
        [swView addSubview:z_l];
        
        float btn_w = (__MainScreen_Width-48)/3.;
        
        for (int i = 0 ; i < empArr.count; i ++) {
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"6" andTitle:@"商务" andTarget:self andDic:[empArr objectAtIndex:i]];
            
            [swView addSubview:btn];
            
            [swBtnArr addObject:btn];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sw_h, __MainScreen_Width, 1)];
        line.backgroundColor = [ToolList getColor:@"e7e7eb"];
//        [swView addSubview:line];
        
    }else{
        sw_h = 0.0f;
         main_h = line2.frame.origin.y+line2.frame.size.height+35;
    }
    

//    if(main_h<__MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)
//    {
//        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, main_h);
//        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
//      
//    }
//    else
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, selectContentView.bounds.size.height-45);
        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
   
    }
    
    // btnCommit.frame = CGRectMake(0, main_h-35, __MainScreen_Width, 35);
   
}

#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{

    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    
    //状态
    if([str isEqualToString:@"状态"])
    {
        if(btn.isSelect)
        {
            NSString *zhuangtaiNameStr = [[dic1 allValues] lastObject];
            if([zhuangtaiNameStr isEqualToString:@"不限"])
            {
                for (FX_Button *btnS in zhuangtaiBtnArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
                
            }
            else
            {
                FX_Button *buxianBtn = [zhuangtaiBtnArr firstObject];
                [buxianBtn changeType1Btn:NO];
            }
        }
    }
    else if([str isEqualToString:@"阶段"])
    {
        if(btn.isSelect)
        {
            NSString *jieduanNameStr = [[dic1 allValues] lastObject];
            if([jieduanNameStr isEqualToString:@"不限"])
            {
                for (FX_Button *btnS in jieduanBtnArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
                
            }
            else
            {
                FX_Button *buxianBtn = [jieduanBtnArr firstObject];
                [buxianBtn changeType1Btn:NO];
            }
            
        }
    }
    else if([str isEqualToString:@"add"])
    {
        if(btn.isSelect)
        {
            for (FX_Button *btnS in new_addBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            if(currentPage == 1)
            {
            [requestDic setObject:[[[btn.dic objectForKey:@"data"] allKeys] lastObject] forKey:@"shareState"];
            }
            else
            {
            [requestDic setObject:[[[btn.dic objectForKey:@"data"] allKeys] lastObject] forKey:@"websiteOrNot"];
            }
        }
        else
        {
            if(currentPage == 1)
            {
                [requestDic setObject:@"-1" forKey:@"shareState"];
            }
            else
            {
                [requestDic setObject:@"-1" forKey:@"websiteOrNot"];
                
            }
        }
    
    }
    //部门
     else if([str isEqualToString:@"部门"])
    {
        
        if(btn.isSelect)
        {
            for (FX_Button *btnS in bumenBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
            {
                bumenId = [dic1 objectForKey:@"salerId"];
            }else{
            
                bumenId = [dic1 objectForKey:@"deptId"];
                depId = @"";
                
                if ([[dic1 objectForKey:@"deptEmp"] isKindOfClass:[NSArray class]]) {
                    NSArray *deptEmpArr = [dic1 objectForKey:@"deptEmp"];
                    [self makeSWtwo:deptEmpArr];
                    
                }else{
                   
                     [self makeSWtwo:nil];
                    
                }
                
            }
        }
        else
        {
            bumenId = @"";
        }
    }else
    {
        
        if(btn.isSelect)
        {
            for (FX_Button *btnS in swBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
           
                depId = [dic1 objectForKey:@"salerId"];
          
        }
        else
        {
            depId = @"";
           
        }
    }
}

-(void)createSelectView:(long)tag
{
    switch (tag) {
            //保护库
        case 2:
        {
            jieduanArr = @[@{@[@"2",@"3"]:@"不限"},@{@"2":@"保护跟进"},@{@"3":@"意向保护"}];
            zhuangtaiArr = @[@{@[@"-1"]:@"不限"},@{@"6":@"初步沟通"},@{@"7":@"确定意向"},@{@"8":@"方案报价"},@{@"9":@"签单成交"}];
            new_addArr =@[];
        }
            break;
            //签约客户
        case 0:
        {
            jieduanArr = @[@{@[@"4",@"5",@"6",@"7"]:@"不限"},@{@"4":@"自签网站"},@{@"5":@"分配网站"},@{@"6":@"自签非网站"},@{@"7":@"分配非网站"}];
            zhuangtaiArr = @[@{@[@"-1"]:@"不限"},@{@"10":@"近期无计划"},@{@"11":@"近期跟进"},@{@"12":@"方案报价"},@{@"13":@"二次成交"}];
         
            new_addArr =@[@{@"-1":@"不限"},@{@"0":@"非共享"},@{@"1":@"签单共享"}];


        }
            break;
            //收藏夹
        case 3:
        {
            jieduanArr = @[];
            zhuangtaiArr = @[@{@[@"-1"]:@"不限"},@{@"0":@"未联系"},@{@"1":@"占线"},@{@"2":@"未找到决策人"},@{@"3":@"意向不明确"},@{@[@"4"]:@"稍后联系"},@{@"5":@"有意向"}];
            new_addArr =@[];

        }
            //流失客户
        case 1:
        {
            jieduanArr = @[];
            zhuangtaiArr = @[@{@[@"-1"]:@"不限"},@{@"11":@"近期跟进"},@{@"12":@"方案报价"},@{@"13":@"二次交易"},@{@"10":@"近期无计划"}];
            new_addArr =@[];
        }
            break;
            
            //共享客户
        case 4:
        {
            jieduanArr =@[@{@[@"8",@"9"]:@"不限"},@{@"8":@"推送共享"},@{@"9":@"商机共享"}];
            zhuangtaiArr =@[];
            new_addArr = @[@{@"-1":@"不限"},@{@"0":@"网站客户"},@{@"1":@"非网站客户"}];
        }
            break;
            
        default:
            break;
    }

    float zhuangTai_h = 0.0f;
    if (zhuangtaiArr.count) {
        zhuangTai_h = 35+(zhuangtaiArr.count+2)/3*45;
    }else{
    //计算高度
     zhuangTai_h = 0;
    }
    //新添加的筛选
    float newAdd_h = 0.0f;
    if (new_addArr.count) {
        newAdd_h = zhuangTai_h+35+(new_addArr.count+(new_addArr.count-1))/(new_addArr.count)*45;
    }else{
        //计算高度
        newAdd_h = 0;
    }
    float jieDuan_h = jieduanArr.count?35+(jieduanArr.count+2)/3*45:0;
    float add_h = 0;
    if (new_addArr.count) {
        add_h = 35+(new_addArr.count+(new_addArr.count-1))/new_addArr.count*45;
    }
    
    float buMen_h = 35+(buMenArr.count+2)/3*45;
    float main_h = zhuangTai_h+jieDuan_h+buMen_h+35+add_h;
    
//    if(main_h<__MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)
//    {
//        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, main_h);
//        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
//    }
//    else
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, selectContentView.bounds.size.height-45);
        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
    }
    //状态
    UILabel *z_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, __MainScreen_Width-20, 35)];
    z_l.font = [UIFont systemFontOfSize:14];
    z_l.textColor = [ToolList getColor:@"666666"];
   
    z_l.text = @"状态";
    
    [selectContentScrollView addSubview:z_l];
    float btn_w = (__MainScreen_Width-48)/3.;
    for (int i = 0 ; i < zhuangtaiArr.count; i ++) {
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"状态" andTarget:self andDic:[zhuangtaiArr objectAtIndex:i]];
        [selectContentScrollView addSubview:btn];
        
        [zhuangtaiBtnArr addObject:btn];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, zhuangTai_h, __MainScreen_Width, 1)];
    line.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line];
    
    if (zhuangTai_h == 0) {
        
        line.hidden = YES;
    }
    
    //阶段
    UILabel *j_l = [[UILabel alloc] initWithFrame:CGRectMake(10, zhuangTai_h, __MainScreen_Width-20, 35)];
    j_l.font = [UIFont systemFontOfSize:14];
    j_l.textColor = [ToolList getColor:@"666666"];
    if (tag == 4) {
        z_l.text = @"阶段";
    }else{
        j_l.text = @"阶段";
    }
    [selectContentScrollView addSubview:j_l];
    if(jieduanArr.count == 0)
    {
        j_l.hidden = YES;
    }
    for (int i = 0 ; i < jieduanArr.count; i ++) {
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), zhuangTai_h+35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"阶段" andTarget:self andDic:[jieduanArr objectAtIndex:i]];
        [selectContentScrollView addSubview:btn];
        
        [jieduanBtnArr addObject:btn];
    }
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, jieDuan_h+zhuangTai_h, __MainScreen_Width, 1)];
    line1.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line1];
    //新添加的筛选
    UILabel *add_l = [[UILabel alloc] initWithFrame:CGRectMake(10, line1.frame.origin.y, __MainScreen_Width-20, 35)];
    add_l.font = [UIFont systemFontOfSize:14];
    add_l.textColor = [ToolList getColor:@"666666"];
    if (tag == 4) {
        add_l.text = @"客户类型";
    }else{
        add_l.text = @"共享类型";
    }
    [selectContentScrollView addSubview:add_l];
    if(new_addArr.count == 0)
    {
        add_l.hidden = YES;
    }
    for (int i = 0 ; i < new_addArr.count; i ++) {
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), add_l.frame.origin.y+35, btn_w, 30) andType:@"1" andTitle:@"add" andTarget:self andDic:[new_addArr objectAtIndex:i]];
        [selectContentScrollView addSubview:btn];
        
        [new_addBtnArr addObject:btn];
    }
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, jieDuan_h+zhuangTai_h+add_h, __MainScreen_Width, 1)];
    line3.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line3];
    
    //部门
    UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, jieDuan_h+zhuangTai_h+add_h, __MainScreen_Width-20, 35)];
    b_l.font = [UIFont systemFontOfSize:14];
    b_l.textColor = [ToolList getColor:@"666666"];
     b_l.text = @"部门";
   
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        b_l.text = @"商务";
        
        for (int i = 0 ; i < buMenArr.count; i ++) {
            
            FX_Button *  btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), jieDuan_h+zhuangTai_h+35+add_h+(i/3)*45, btn_w, 30) andType:@"6" andTitle:@"部门" andTarget:self andDic:[buMenArr objectAtIndex:i]];
            
            [selectContentScrollView addSubview:btn];
            
            [bumenBtnArr addObject:btn];
        }

    }else{
        
        for (int i = 0 ; i < buMenArr.count; i ++) {
            
            NSDictionary *bumenDic = @{@"deptId":[[buMenArr objectAtIndex:i] objectForKey:@"deptId"],@"deptEmp":[[buMenArr objectAtIndex:i] objectForKey:@"deptEmp"],@"deptName":[[buMenArr objectAtIndex:i] objectForKey:@"deptName"]};
            
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), jieDuan_h+zhuangTai_h+add_h+35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"部门" andTarget:self andDic:bumenDic];
            
            [selectContentScrollView addSubview:btn];
            
            [bumenBtnArr addObject:btn];
        }

    }
    [selectContentScrollView addSubview:b_l];
    
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(0, buMen_h+zhuangTai_h+jieDuan_h+add_h, __MainScreen_Width, 1)];
    line2.backgroundColor = [ToolList getColor:@"e7e7eb"];
    //[selectContentScrollView addSubview:line2];
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 1)];
    line9.backgroundColor = [ToolList getColor:@"e7e7eb"];
    btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCommit addSubview:line9];
    btnCommit.frame = CGRectMake(0, selectContentView.frame.size.height -45, __MainScreen_Width, 45);
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCommit setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    [btnCommit setTitle:@"完成" forState:UIControlStateNormal];
    [btnCommit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [selectContentView addSubview:btnCommit];

    
}
#pragma mark - 筛选点击
-(void)selectBtnClicked:(UIButton *)btn
{
    
    isUpSelectView = !isUpSelectView;
    //出现
    if(isUpSelectView)
    {
      
        
        
        [UIView animateWithDuration:0.3 animations:^{
            selectContentView.frame = CGRectMake(0,SelectViewHeight+SelectViewHeight1+IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1);
        }];
    }
    //消失
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            selectContentView.frame = CGRectMake(0,IOS7_Height+SelectViewHeight+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1);
        }];
    }
}
#pragma mark - 完成筛选
-(void)commit:(UIButton *)btn
{

    isUpSelectView = NO;
    NSMutableArray *commitZTArr = [[NSMutableArray alloc] init];
    NSMutableArray *commitJDArr = [[NSMutableArray alloc] init];

    for (int i = 0;i<zhuangtaiBtnArr.count;i++) {
        FX_Button *btn = [zhuangtaiBtnArr objectAtIndex:i];
        if (btn.isSelect) {
            [commitZTArr addObject:[[[zhuangtaiArr objectAtIndex:i] allKeys] lastObject]];
        }
    }
    for (int i = 0;i<jieduanBtnArr.count;i++) {
        FX_Button *btn = [jieduanBtnArr objectAtIndex:i];
        if (btn.isSelect) {
            [commitJDArr addObject:[[[jieduanArr objectAtIndex:i] allKeys] lastObject]];

        }
    }
    
    if(commitJDArr.count)
    {
        if([[commitJDArr lastObject] isKindOfClass:[NSArray class]])
        {
            commitJDArr = [NSMutableArray arrayWithArray:[commitJDArr lastObject]];
        }
        [requestDic setObject:commitJDArr forKey:@"custTypes"];
    }
  
    if(commitZTArr.count)
    {
        if([[commitZTArr lastObject] isKindOfClass:[NSArray class]])
        {
            commitZTArr = [NSMutableArray arrayWithArray:[commitZTArr lastObject]];
        }
        [requestDic setObject:commitZTArr forKey:@"intenttypes"];
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        [requestDic setObject:bumenId forKey:@"salerId"];
    }else{
        [requestDic setObject:bumenId forKey:@"deptId"];
        [requestDic setObject:depId forKey:@"salerId"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        selectContentView.frame = CGRectMake(0,IOS7_Height+SelectViewHeight+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1);
    }];
    startPage = 1;
    [self requestAlldata];

}

#pragma mark - 点击按钮回调
-(void)changeBigAndColorClikedBack:(FX_Button *)btn
{
    if(btn.tag!=currentPage)
    {
        isUpSelectView = NO;
        startPage = 1;
        [UIView animateWithDuration:0.3 animations:^{
            selectContentView.frame = CGRectMake(0,IOS7_Height+SelectViewHeight+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1);
        }];
        
        //先清再加
        [jieduanBtnArr removeAllObjects];
        [bumenBtnArr removeAllObjects];
        [new_addBtnArr removeAllObjects];
        [zhuangtaiBtnArr removeAllObjects];
        [swBtnArr removeAllObjects];
        [requestDic setObject:@"-1" forKey:@"websiteOrNot"];
        [requestDic setObject:@"-1" forKey:@"shareState"];

        for (UIView *view_sub in [selectContentScrollView subviews])
        {
            [view_sub removeFromSuperview];
        }
        [self createSelectView:btn.tag];
    }
  
  
    for (int i = 0; i < selectBtnArr.count ; i++) {
        FX_Button * clickedBtn = [selectBtnArr objectAtIndex:i];
        if (clickedBtn == btn) {
            currentPage = i;
            clickedBtn.isSelect = YES;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
        else
        {
            clickedBtn.isSelect = NO;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
    }
    
    
    if(btn.tag == 2)
    {
        [requestDic setObject:@[@"2",@"3"] forKey:@"custTypes"];
        
    }
    else if (btn.tag == 0)
    {
        [requestDic setObject:@[@"4",@"5",@"6",@"7"] forKey:@"custTypes"];
        
    }
    else if (btn.tag == 3){
        
        [requestDic setObject:@[@"1"] forKey:@"custTypes"];
    }
    else
    {
        [requestDic setObject:@[@"8",@"9"] forKey:@"custTypes"];
    }
    [requestDic setObject:@[@"-1"] forKey:@"intenttypes"];
    [requestDic setObject:@"" forKey:@"deptId"];
    [requestDic setObject:@"" forKey:@"salerId"];

    [self requestAlldata];
    

}
#pragma mark - 页面初始化
-(void)initView
{
#pragma mark - 数据初始化
    isUpSelectView = NO;
    startPage = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    requestDic = [[NSMutableDictionary alloc] init];
    searchRequestDic = [[NSMutableDictionary alloc] init];
//    [searchRequestDic setObject:@"" forKey:@"salerId"];
//    [searchRequestDic setObject:@[@"0"] forKey:@"custTypes"];
//    [searchRequestDic setObject:@[@"-1"] forKey:@"intenttypes"];
    [searchRequestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [searchRequestDic setObject:@"10" forKey:@"pagesize"];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
           [requestDic setObject:@"" forKey:@"salerId"];
         [searchRequestDic setObject:@"3" forKey:@"type"];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
         [searchRequestDic setObject:@"4" forKey:@"type"];
    }
  
    [requestDic setObject:@"" forKey:@"custName"];
    //默认签约客户
    [requestDic setObject:@[@"4",@"5",@"6",@"7"] forKey:@"custTypes"];
    [requestDic setObject:@[@"-1"] forKey:@"intenttypes"];
    bumenId = @"";
    depId=@"";
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    selectBtnArr = [[NSMutableArray alloc]init];
    jieduanBtnArr = [[NSMutableArray alloc]init];
    new_addBtnArr = [[NSMutableArray alloc]init];
    zhuangtaiBtnArr = [[NSMutableArray alloc]init];
    bumenBtnArr = [[NSMutableArray alloc]init];
    dataArr = [[NSMutableArray alloc] init];
    swBtnArr =[[NSMutableArray alloc] init];
#pragma mark - 页面初始化
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight+SelectViewHeight1, __MainScreen_Width, __MainScreen_Height-SelectViewHeight1- SelectViewHeight-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
    selectContentView = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+SelectViewHeight+SelectViewHeight1-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)];
    selectContentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:selectContentView];
    selectContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectContentScrollView.showsVerticalScrollIndicator = NO;
    selectContentScrollView.backgroundColor = [UIColor whiteColor];
    [selectContentView addSubview:selectContentScrollView];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
    //标题
        [self addNavgationbar:@"部门客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];

    }
    else
    {
        [self addNavgationbar:@"我司客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];

    }
    //筛选区域
    UIView *selectViewFa = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, SelectViewHeight1)];
    selectViewFa.backgroundColor = [ToolList getColor:@"fafafa"];
    [selectViewFa.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, SelectViewHeight1-0.8) toPoint:CGPointMake(__MainScreen_Width, SelectViewHeight1-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    productNum_L = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, SelectViewHeight1)];
    productNum_L.backgroundColor = [UIColor clearColor];
    productNum_L.font = [UIFont systemFontOfSize:12];
    productNum_L.textColor = [ToolList getColor:@"999999"];
    [selectViewFa addSubview:productNum_L];
    product_Select_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    product_Select_Btn.frame = CGRectMake(__MainScreen_Width-55, 0, 52, SelectViewHeight1);
    [product_Select_Btn setTitle:@"筛选" forState:UIControlStateNormal];
    product_Select_Btn.hidden = NO;
    product_Select_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [product_Select_Btn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    product_Select_Btn.backgroundColor = [UIColor clearColor];
    [product_Select_Btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [product_Select_Btn setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [product_Select_Btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [selectViewFa addSubview:product_Select_Btn];
    
    
    //标题总区域
    selectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, SelectViewHeight)];
    
    selectView.backgroundColor = [ToolList getColor:@"ffffff"];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, SelectViewHeight-0.8) toPoint:CGPointMake(__MainScreen_Width, SelectViewHeight-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [self.view addSubview:selectViewFa];
    [self.view addSubview:selectView];
    NSArray * arr;
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
    arr = @[@"签约客户",@"流失客户",@"保护库",@"收藏夹",@"共享客户"];
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
    {
     
    // arr = @[@"签约客户",@"流失客户",@"保护库",@"收藏夹",@"共享客户",@"管家独享"];
        arr = @[@"签约客户",@"流失客户",@"保护库",@"收藏夹",@"共享客户"];
        
    }
    selectView.contentSize = CGSizeMake(arr.count * Btn_W , SelectViewHeight);
    selectView.showsHorizontalScrollIndicator = NO;
    for (int i = 0 ; i < arr.count; i ++) {
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(Btn_W*i, 0, Btn_W, SelectViewHeight-0.8) andType:@"2" andTitle:[arr objectAtIndex:i] andTarget:self andDic:nil];
        btn.tag = i;
        [selectBtnArr addObject:btn];
        [selectView addSubview:btn];
        if(i == 0)
        {
            btn.isSelect = YES;
            [btn changeBigAndColorCliked:btn];
        }
    }
    
    
    
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
    
    searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    [searchView addSubview:searchTable];
    

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

#pragma mark - 筛选商务数据请求失败
-(void)OpenSelectFaile:(NSDictionary *)resultDic
{
    [ToolList showRequestFaileMessageLittleTime:@"筛选条件加载失败，请重试！"];
    
}

#pragma mark - 部门客户列表数据请求成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
 
    

     [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    [searchTable.refreshHeader endRefreshing];
    [searchTable.refreshFooter endRefreshing];
    if(startPage == 1 || startPage == 0)
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
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            if(startPage == 0 || startPage == 1 )
            {
            [table scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
        }
        searchTable.hidden = NO;
        [searchTable reloadData];
       
    }
    productNum_L.text = [NSString stringWithFormat:@"共%@个",[resultDic objectForKey:@"total"]];
    NSLog(@"^^^^^^%ld",dataArr.count);
}
#pragma mark - 数据请求
-(void) requestAlldata
{

    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [searchRequestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    if(currentPage!=1)
    {
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
            [FX_UrlRequestManager postByUrlStr:flagNeedReload?DeptCustM_url:vagueSearch_url  andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
       
        
    }else{

        [FX_UrlRequestManager postByUrlStr:flagNeedReload?SubCust_url:vagueSearch_url  andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
    }
    else if (currentPage==1 && flagNeedReload == NO)
    {
        //经理
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
        {
            
     [FX_UrlRequestManager postByUrlStr:flagNeedReload?DeptCustM_url:vagueSearch_url andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
  
        }else{
            
            
            [FX_UrlRequestManager postByUrlStr:flagNeedReload?SubCust_url:vagueSearch_url andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
  
    }
    else
    {
        //经理
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
        {
            
            [FX_UrlRequestManager postByUrlStr:flagNeedReload?DepLostCust_url:vagueSearch_url  andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
        }else{
            
            [FX_UrlRequestManager postByUrlStr:flagNeedReload?DepLostCustZJ_url:vagueSearch_url  andPramas:flagNeedReload?requestDic:searchRequestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
   
    }
   
}
#pragma mark - 获得所有部门成功
-(void)getDeptSuccess:(NSDictionary *)dic
{
   
        buMenArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
        [self createSelectView:0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        //请求经理所有部门
        [FX_UrlRequestManager postByUrlStr:GetSalers_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
         
    }else{
        //请求总监所有部门、、ZJdeptInit_url
        [FX_UrlRequestManager postByUrlStr:deptListInit_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
    }
    
    
    [self initView];
    
    flagNeedReload = YES;
    searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    [self requestAlldata];
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
        [text resignFirstResponder];

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
    if(currentPage == 0)
    {
        cell.addL.text = [ToolList changeNull:[dic objectForKey:@"shareState"]];
  
    }
    if(currentPage == 4)
    {
        cell.addL.text = [ToolList changeNull:[dic objectForKey:@"websiteOrNot"]];
  
    }
   if(currentPage != 1 || flagNeedReload == NO)
   {
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        if (currentPage == 4 && flagNeedReload == YES) {
            
            NSString *str = [NSString stringWithFormat:@"%@ | %@ |  %@" ,[ToolList changeNull:[dic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dic objectForKey:@"shareState"]],[ToolList changeNull:[dic objectForKey:@"salerName"]]];
            
            cell.labelother.text = str;
            
        }else{
            NSString *str = [NSString stringWithFormat:@"%@ | %@ | %@" ,[ToolList changeNull:[dic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dic objectForKey:@"intenttype"]],[ToolList changeNull:[dic objectForKey:@"salerName"]]];
        
            cell.labelother.text = str;
        }
    }
    else{
    
        if (currentPage == 4 && flagNeedReload == YES) {
            
             NSString *str = [NSString stringWithFormat:@"%@ | %@ | %@ | %@" ,[ToolList changeNull:[dic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dic objectForKey:@"shareState"]],[ToolList changeNull:[dic objectForKey:@"deptName"]],[ToolList changeNull:[dic objectForKey:@"salerName"]]];
            
            cell.labelother.text = str;
            
        }else{

            NSString *str = [NSString stringWithFormat:@"%@-%@ | %@ | %@" ,[ToolList changeNull:[dic objectForKey:@"deptName"]],[ToolList changeNull:[dic objectForKey:@"salerName"]],[ToolList changeNull:[dic objectForKey:@"custVirtualType"]],[ToolList changeNull:[dic objectForKey:@"intenttype"]]];
    
            cell.labelother.text = str;
        }
    }
   }

    else
    {
       
            NSString *str = [NSString stringWithFormat:@"%@ | %@" ,[ToolList changeNull:[dic objectForKey:@"content"]],[ToolList changeNull:[dic objectForKey:@"intentType"]]];
            
            cell.labelother.text = str;
            
        
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    [self.navigationController pushViewController:s animated:NO];
}


@end
