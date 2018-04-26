//
//  buMenPMViewController.m
//  SaleManagement
//
//  Created by known on 16/6/16.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "buMenPMViewController.h"
#import "buMenNTableViewCell.h"
@interface buMenPMViewController ()
{
    //筛选按钮
    UIButton *product_Select_Btn;
    UIView *selectContentView;

    
    
}
@end

@implementation buMenPMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _requestDic = [[NSMutableDictionary alloc]init];
    _jieduanButtonArr =[[NSMutableArray alloc]init];
    bumenBtnArr = [[NSMutableArray alloc]init];
    riqiBtnArr = [[NSMutableArray alloc]init];
    _requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];
    //分司
    fensiBtnArr = [[NSMutableArray alloc]init];
    fsBMBtnArr = [[NSMutableArray alloc]init];

//    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
//    {
//        if (request) {
//
//        }
//        NSDictionary *dic =buMenArr[1];
//        
////        _requestDic[@"deptId"]=dic[@"deptId"];
//        
//        
//    }
//    else
//    {
//        _requestDic[@"deptId"]=@"";
//        
//        [FX_UrlRequestManager postByUrlStr:BuMenNArea_url andPramas:_requestDic andDelegate:self andSuccess:@"buMenNEISuccess:" andFaild:@"buMenNEIFild:" andIsNeedCookies:YES];
    
        
//    }
    NSString * s= [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
                   
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
        {
            
//            _requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];
            
            _requestDic[@"subId"]=@"";
            _requestDic[@"deptId"] =@"";
            
            [FX_UrlRequestManager postByUrlStr:QZBuMenNArea_url andPramas:_requestDic andDelegate:self andSuccess:@"QZbuMenNEISuccess:" andFaild:@"QZbuMenNEIFild:" andIsNeedCookies:YES];
        
        
        }
    else
    {
        _requestDic[@"deptId"]=@"";
        [FX_UrlRequestManager postByUrlStr:BuMenNArea_url andPramas:_requestDic andDelegate:self andSuccess:@"buMenNEISuccess:" andFaild:@"buMenNEIFild:" andIsNeedCookies:YES];
        
  
    }

    
    
    [self initView];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求总监所有部门
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
    {
        
        [FX_UrlRequestManager postByUrlStr:ZJdeptInit_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
        
    }
//    请求区总分司和部门
//    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
//    {
//        
//        [FX_UrlRequestManager postByUrlStr:QZdeptInit_url andPramas:nil andDelegate:self andSuccess:@"QZgetDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
//        
//    }

    

}
#pragma mark   区总分司和部门
-(void)QZgetDeptSuccess:(NSDictionary *)dic
{
    fenSiBMArr =[NSArray arrayWithArray:[dic objectForKey:@"result"]];
//    for(NSDictionary *tagInfoDic in fenSiBMArr)
//    {
//       fenSiBMArr =tagInfoDic[@"deptList"];
//    }
    for (int i =0 ; i<fenSiBMArr.count; i++)
    {
        if ([mrfensiId isEqualToString:fenSiBMArr[i][@"subName"]]) {
            

            fsBMArr = fenSiBMArr[i][@"deptList"];
       
        }
        
    }
  
 
    [self QZcreateSelectView];
    
}
-(void)QZcreateSelectView
{
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 85, __MainScreen_Width, 1)];
    line1.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line1];
    
    float buMen_h = 35+(fenSiBMArr.count+2)/3*45;
    float main_h = buMen_h+35;
    float main_height = (fsBMArr.count+2)/3*45;

    float btn_w = (__MainScreen_Width-48)/3.;
    
    if(main_h<__MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
//        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h+main_height+85+35);

    }
    else
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
//        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h+main_height+85+35);
    }
    //部门
    UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, __MainScreen_Width-20, 35)];
    b_l.font = [UIFont systemFontOfSize:14];
    b_l.textColor = [ToolList getColor:@"666666"];
    b_l.text = @"分司";
    [selectContentScrollView addSubview:b_l];

    
    for (int i = 0 ; i < fenSiBMArr.count; i ++) {
        
        NSDictionary *bumenDic = @{@"subId":[[fenSiBMArr objectAtIndex:i] objectForKey:@"subId"],@"deptList":[[fenSiBMArr objectAtIndex:i] objectForKey:@"deptList"],@"subName":[[fenSiBMArr objectAtIndex:i] objectForKey:@"subName"]};
        
        
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 85+35+(i/3)*45, btn_w, 30) andType:@"7" andTitle:@"分司" andTarget:self andDic:bumenDic];

        [selectContentScrollView addSubview:btn];
        
        [fensiBtnArr addObject:btn];
        NSString *dic1 =fenSiBMArr[i][@"subName"];
        if ([dic1 isEqualToString:mrfensiId])
        {
            btn.isSelect = YES;
            [btn changeType1Btn:YES];
        }
    }
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 85+buMen_h, __MainScreen_Width, 1)];
    line2.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line2];
    //部门
    UILabel *qzb_l = [[UILabel alloc] initWithFrame:CGRectMake(10, line2.frame.origin.y+line2.frame.size.height, __MainScreen_Width-20, 35)];
    qzb_l.font = [UIFont systemFontOfSize:14];
    qzb_l.textColor = [ToolList getColor:@"666666"];
    qzb_l.text = @"部门";
    [selectContentScrollView addSubview:qzb_l];
    
    
    for (int i = 0 ; i < fsBMArr.count; i ++) {
        
//        NSDictionary *bumenDic = @{@"deptList":[[fenSiBMArr objectAtIndex:i] objectForKey:@"deptList"],@"subId":[[fenSiBMArr objectAtIndex:i] objectForKey:@"subId"],@"subName":[[fenSiBMArr objectAtIndex:i] objectForKey:@"subName"]};
        
        //        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), jieDuan_h+zhuangTai_h+35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"部门" andTarget:self andDic:bumenDic];
        
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12),  qzb_l.frame.origin.y+qzb_l.frame.size.height+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"部门" andTarget:self andDic:[fsBMArr objectAtIndex:i]];
//
        [selectContentScrollView addSubview:btn];
        
        [fsBMBtnArr addObject:btn];
        
        NSString *dic1 =fsBMArr[i][@"deptName"];
        if ([dic1 isEqualToString:mrbmId])
        {
            btn.isSelect = YES;
            [btn changeType1Btn:YES];
        }
        
    }

    
    
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 85+buMen_h+35+main_height, __MainScreen_Width, 1)];
    line3.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line3];
 
    UIButton *btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCommit.frame = CGRectMake(0, line3.frame.origin.y, __MainScreen_Width, 35);
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCommit setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    [btnCommit setTitle:@"完成" forState:UIControlStateNormal];
    [btnCommit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [selectContentScrollView addSubview:btnCommit];
    selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, btnCommit.frame.origin.y+btnCommit.frame.size.height+85+35);

//    duanView.frame = CGRectMake(0, 0, __MainScreen_Width, 85+buMen_h+35+main_height+35);
}
#pragma mark - 获得所有部门成功
-(void)getDeptSuccess:(NSDictionary *)dic
{
    buMenArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
    for (int i =0 ; i<buMenArr.count; i++)
    {
        NSString *dic1 =buMenArr[i][@"deptName"];
        if ([dic1 isEqualToString:@"商务1部"])
        {
            _requestDic[@"deptId"] =buMenArr[i][@"deptId"];
            
            
        }
        
    }
    request =YES;
    
//    bumenId = buMenArr[0][@"deptId"];

    [self createSelectView];
                [FX_UrlRequestManager postByUrlStr:BuMenNArea_url andPramas:_requestDic andDelegate:self andSuccess:@"buMenNEISuccess:" andFaild:@"buMenNEIFild:" andIsNeedCookies:YES];

}
-(void)createSelectView
{
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 85, __MainScreen_Width, 1)];
    line1.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line1];

    float buMen_h = 35+(buMenArr.count+2)/3*45;
    float main_h = buMen_h+35;
    float btn_w = (__MainScreen_Width-48)/3.;

    if(main_h<__MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, main_h+85);
    }
    else
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width,main_h+85);
//        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
    }
    //部门
    UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, __MainScreen_Width-20, 35)];
    b_l.font = [UIFont systemFontOfSize:14];
    b_l.textColor = [ToolList getColor:@"666666"];
    b_l.text = @"部门";
    [selectContentScrollView addSubview:b_l];
    NSDictionary *dic = buMenArr[1];

    for (int i = 0 ; i < buMenArr.count; i ++) {

        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 85+35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"部门" andTarget:self andDic:[buMenArr objectAtIndex:i]];
        [selectContentScrollView addSubview:btn];
        
        [bumenBtnArr addObject:btn];
//        if (i==0) {
//            
//        }
            NSString *dic1 =buMenArr[i][@"deptName"];
            if ([dic1 isEqualToString:@"商务1部"])
            {
                btn.isSelect = YES;
                [btn changeType1Btn:YES];
            }
            

    }
    
    UIButton *btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCommit.frame = CGRectMake(0, buMen_h+85, __MainScreen_Width, 35);
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCommit setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    [btnCommit setTitle:@"完成" forState:UIControlStateNormal];
    [btnCommit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [selectContentScrollView addSubview:btnCommit];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 85+buMen_h, __MainScreen_Width, 1)];
    line2.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line2];
    selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, btnCommit.frame.origin.y+btnCommit.frame.size.height+20);
    
    
}
-(void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
     [self addNavgationbar:@"部门内排行榜" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    product_Select_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    product_Select_Btn.frame = CGRectMake(__MainScreen_Width-55, IOS7_Height, 52, SelectViewHeight1);
    [product_Select_Btn setTitle:@"筛选" forState:UIControlStateNormal];
    product_Select_Btn.hidden = NO;
    product_Select_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [product_Select_Btn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    product_Select_Btn.backgroundColor = [UIColor clearColor];
    [product_Select_Btn addTarget:self action:@selector(pSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [product_Select_Btn setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [product_Select_Btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
   
    
    [self.view addSubview:product_Select_Btn];

    Select_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Select_Btn.frame = CGRectMake(12 , IOS7_Height+5, (__MainScreen_Width-63 -20)/4, 30);
    [Select_Btn setTitle:@"今日" forState:UIControlStateNormal];
    Select_Btn.titleLabel.font = [UIFont systemFontOfSize:14];

    [Select_Btn setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
    Select_Btn.layer.borderColor = [ToolList getColor:@"6052ba"].CGColor;
    Select_Btn.layer.cornerRadius = 4;
    Select_Btn.layer.masksToBounds = YES;
    Select_Btn.layer.borderWidth = 1;

    [self.view addSubview:Select_Btn ];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
        SWSelect_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        SWSelect_Btn.frame = CGRectMake(12+(__MainScreen_Width-63-20)/4+10 , IOS7_Height+5, (__MainScreen_Width-48)/3., 30);
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3) {
//            [SWSelect_Btn setTitle:@"商务1部" forState:UIControlStateNormal];

        }
        else
        {
            [SWSelect_Btn setTitle:@"商务1部" forState:UIControlStateNormal];
  
        }
        [SWSelect_Btn setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
        SWSelect_Btn.titleLabel.font = [UIFont systemFontOfSize:14];

        SWSelect_Btn.layer.borderColor = [ToolList getColor:@"6052ba"].CGColor;
        SWSelect_Btn.layer.cornerRadius = 4;
        SWSelect_Btn.layer.masksToBounds = YES;
        SWSelect_Btn.layer.borderWidth = 1;

        [self.view addSubview:SWSelect_Btn ];
 
    }
     if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
     {
         
         qzSelect_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
         qzSelect_Btn.frame = CGRectMake(SWSelect_Btn.frame.origin.x+SWSelect_Btn.frame.size.width+10  , IOS7_Height+5,  (__MainScreen_Width-68)/3., 30);
         qzSelect_Btn.titleLabel.font = [UIFont systemFontOfSize:14];
         
         [qzSelect_Btn setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
         qzSelect_Btn.layer.borderColor = [ToolList getColor:@"6052ba"].CGColor;
         qzSelect_Btn.layer.cornerRadius = 4;
         qzSelect_Btn.layer.masksToBounds = YES;
         qzSelect_Btn.layer.borderWidth = 1;
         [self.view addSubview:qzSelect_Btn ];

         
         
         
     }
    
        selectContentView = [[UIView alloc] initWithFrame:CGRectMake(0,- IOS7_Height-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44)];
    selectContentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    [self.view addSubview:selectContentView];
    selectContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectContentScrollView.showsVerticalScrollIndicator = NO;
    selectContentScrollView.backgroundColor = [UIColor whiteColor];
    [selectContentView addSubview:selectContentScrollView];
    
    //阶段展示区域
    duanBlackView = [[UIView alloc] initWithFrame:selectContentScrollView.bounds];
//    duanBlackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    [selectContentScrollView addSubview:duanBlackView];
//    duanView = [[UIView alloc] init];
//    duanView.backgroundColor = [UIColor whiteColor];
//    duanView.frame = CGRectMake(0,0, __MainScreen_Width, 85);
//    duanView.backgroundColor =[ UIColor blueColor];
//    
//    [duanBlackView addSubview:duanView];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 58, 14)];
    zhuangtaiL.text = @"日期";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [selectContentScrollView addSubview:zhuangtaiL];
    
    riqiBtnArr =@[@{@"1":@"今日"},@{@"2":@"昨日"},@{@"3":@"本月"},@{@"4":@"上月"}];
    
    for (int i = 0; i < riqiBtnArr.count; i ++ ) {
        
        NSDictionary *dic = [riqiBtnArr objectAtIndex:i];
        
        FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i+1)+i*((__MainScreen_Width-63)/4) , 36, (__MainScreen_Width-63)/4, 34) andType:@"1" andTitle:@"日期" andTarget:self andDic:dic];
        
        [selectContentScrollView addSubview:btn2];
        
        if (i==0) {
            btn2.isSelect = YES;
            [btn2 changeType1Btn:YES];
        }
        
        [_jieduanButtonArr addObject:btn2];
    }
    selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, 85);

    selectContentScrollView.contentSize =CGSizeMake(__MainScreen_Width, 85);
    //添加列表
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+44, __MainScreen_Width, __MainScreen_Height-44-IOS7_Height) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.showsVerticalScrollIndicator = NO;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
   
}
#pragma mark---筛选按钮
-(void)pSelectBtnClicked:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            selectContentView.frame =CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
            
            [self.view bringSubviewToFront:selectContentView];
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            selectContentView.frame =CGRectMake(0,  -IOS7_Height-45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
        }];
    }
}
//数据
-(void)buMenNEISuccess:(NSDictionary *)dic{
    
    [_tableArr removeAllObjects];
    
    if ([[dic objectForKey:@"code"]intValue]==200) {
        
        _tableArr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"result"]];
        
        if (_tableArr.count == 0 ) {
            
            [ToolList showRequestFaileMessageLittleTime:@"部门内排名无数据"];
//            [_table removeFromSuperview];
            
        }
        if (_table == nil) {
            //添加列表
            _table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45) style:UITableViewStylePlain];
            _table.dataSource = self;
            _table.delegate = self;
            [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.view addSubview:_table];
            
        }else{
            [self.view bringSubviewToFront:_table];
        }

    }
       [_table reloadData];
}
-(void)QZbuMenNEISuccess:(NSDictionary *)dic
{
    
    [_tableArr removeAllObjects];
    
    if ([[dic objectForKey:@"code"]intValue]==200) {
        
        _tableArr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"result"]];
        mrfensiId =[dic objectForKey:@"subName"];
        mrbmId =[dic objectForKey:@"deptName"];
        [SWSelect_Btn setTitle:mrfensiId forState:UIControlStateNormal];
        [qzSelect_Btn setTitle:mrbmId forState:UIControlStateNormal];

        if (_tableArr.count == 0 ) {
            
            [ToolList showRequestFaileMessageLittleTime:@"部门内排名无数据"];
            //            [_table removeFromSuperview];
            
        }
        if (_table == nil) {
            //添加列表
            _table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45) style:UITableViewStylePlain];
            _table.dataSource = self;
            _table.delegate = self;
            [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.view addSubview:_table];
            
        }else{
            [self.view bringSubviewToFront:_table];
        }
        
    }
    [_table reloadData];
//[self QZcreateSelectView];
    
    
            [FX_UrlRequestManager postByUrlStr:QZdeptInit_url andPramas:nil andDelegate:self andSuccess:@"QZgetDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
 
    
    
    
}

#pragma mark -- ****条件筛选未点击完成前
-(void)btnBackDic:(NSDictionary *)dic
{
    //区总
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
        FX_Button *btn = [dic objectForKey:@"Obj"];
        NSDictionary *dic1 = [dic objectForKey:@"data"];
        NSString *str = [dic objectForKey:@"tag"];
        //状态
        if([str isEqualToString:@"日期"])
        {
            
            if(btn.isSelect)
            {
                for (FX_Button *btnS in _jieduanButtonArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
                
                
            }
            else
            {
            }
            
            
            
        }
        else if([str isEqualToString:@"分司"])
        {
            if(btn.isSelect)
            {
                for (FX_Button *btnS in fensiBtnArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
                
                
            }
            else
            {
                
                
            }
            
            
        }
        else if([str isEqualToString:@"部门"])
        {
            if(btn.isSelect)
            {
                for (FX_Button *btnS in fsBMBtnArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
                
                
            }
            else
            {
            }
            
        }

        
    }

  else  if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
    {
        FX_Button *btn = [dic objectForKey:@"Obj"];
        NSDictionary *dic1 = [dic objectForKey:@"data"];
        NSString *str = [dic objectForKey:@"tag"];

        //状态
        if([str isEqualToString:@"日期"])
        {
                       
            if(btn.isSelect)
            {
                for (FX_Button *btnS in _jieduanButtonArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
                
                
            }
            else
            {
            }

        
            
        }
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
                
                    bumenId = [dic1 objectForKey:@"deptId"];
               
            }
            else
            {
                bumenId = @"";
            }


        }
 
        
    }
    else
    {
        FX_Button *btn = [dic objectForKey:@"Obj"];
        NSDictionary *dic1 = [dic objectForKey:@"data"];
        //    NSString *str = [dic objectForKey:@"tag"];
        
        [Select_Btn setTitle:[[dic1 allValues] lastObject]forState:UIControlStateNormal];
        for (FX_Button *btnS in _jieduanButtonArr) {
            
            if (btnS == btn) {
                btn.selected = YES;
                [btnS changeType1Btn:YES];
                
            }else{
                btn.selected = NO;
                [btnS changeType1Btn:NO];
            }
            
        }
        
        [self pSelectBtnClicked:product_Select_Btn];
        
        [_requestDic removeAllObjects];
        _requestDic[@"dataFilter"]=[[dic1 allKeys] lastObject];
        _requestDic[@"deptId"]=@"";
        
        [FX_UrlRequestManager postByUrlStr:BuMenNArea_url andPramas:_requestDic andDelegate:self andSuccess:@"buMenNEISuccess:" andFaild:@"buMenNEIFild:" andIsNeedCookies:YES];
   
        
    }
   
}
#pragma mark - 完成筛选
-(void)commit:(UIButton *)btn
{
    NSMutableArray *commitRQArr = [[NSMutableArray alloc] init];
    NSMutableArray *commitBMArr = [[NSMutableArray alloc] init];
//    [_requestDic removeAllObjects];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
        for (int i = 0;i<riqiBtnArr.count;i++) {
            FX_Button *btn = [_jieduanButtonArr objectAtIndex:i];
            if (btn.isSelect) {
                NSString *s =[[[riqiBtnArr objectAtIndex:i] allKeys]lastObject];
                
                [_requestDic setObject:s forKey:@"dataFilter"];
                [Select_Btn setTitle:[[[riqiBtnArr objectAtIndex:i] allValues]lastObject]forState:UIControlStateNormal];
                
            }
                   }
        for (int i = 0;i<fenSiBMArr.count;i++) {
            FX_Button *btn = [fensiBtnArr objectAtIndex:i];
            if (btn.isSelect) {
                NSString *s =[[[fenSiBMArr objectAtIndex:i] allKeys]lastObject];
                
                [_requestDic setObject:fenSiBMArr[i][@"subId"] forKey:@"subId"];
                [SWSelect_Btn setTitle:fenSiBMArr[i][@"subName"] forState:UIControlStateNormal];
                
            }
//            else
//            {
//                [_requestDic setObject:mrfensiId forKey:@"subId"];
// 
//            }

        }
        for (int i = 0;i<fsBMArr.count;i++) {
            FX_Button *btn = [fsBMBtnArr objectAtIndex:i];
            if (btn.isSelect) {
                NSString *s =[[[fsBMArr objectAtIndex:i] allKeys]lastObject];
                
                [_requestDic setObject:fsBMArr[i][@"deptId"] forKey:@"deptId"];
                [qzSelect_Btn setTitle:fsBMArr[i][@"deptName"] forState:UIControlStateNormal];
                
            }
//            else
//            {
//                [_requestDic setObject:mrbmId forKey:@"deptId"];
//                
//            }
            
        }

        
    }
    else
    {
        for (int i = 0;i<riqiBtnArr.count;i++) {
            FX_Button *btn = [_jieduanButtonArr objectAtIndex:i];
            if (btn.isSelect) {
                NSString *s =[[[riqiBtnArr objectAtIndex:i] allKeys]lastObject];
                
                [_requestDic setObject:s forKey:@"dataFilter"];
                [Select_Btn setTitle:[[[riqiBtnArr objectAtIndex:i] allValues]lastObject]forState:UIControlStateNormal];
                
            }
            else
            {
                
                
            }
        }
        for (int i = 0;i<buMenArr.count;i++) {
            FX_Button *btn = [bumenBtnArr objectAtIndex:i];
            if (btn.isSelect) {
                NSString *s =[[[buMenArr objectAtIndex:i] allKeys]lastObject];
                
                [_requestDic setObject:buMenArr[i][@"deptId"] forKey:@"deptId"];
                [SWSelect_Btn setTitle:[[[buMenArr objectAtIndex:i] allValues]lastObject]forState:UIControlStateNormal];
                
            }
        }
  
    }
   

//        [_requestDic setObject:bumenId forKey:@"deptId"];
    product_Select_Btn.selected = NO;
//    [UIView animateWithDuration:0.3 animations:^{
//        selectContentView.frame = CGRectMake(0,IOS7_Height+45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
//    }];
//    
     [FX_UrlRequestManager postByUrlStr:BuMenNArea_url andPramas:_requestDic andDelegate:self andSuccess:@"buMenNEISuccess:" andFaild:@"buMenNEIFild:" andIsNeedCookies:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_tableArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];//以indexPath来唯一确定cell
    buMenNTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSBundle *bundle = [NSBundle mainBundle];//加载cell的xib 文件
        NSArray *objs = [bundle loadNibNamed:@"buMenNTableViewCell" owner:nil options:nil];
        cell = [objs lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 60.5) toPoint:CGPointMake(__MainScreen_Width, 60.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    NSDictionary *dataDic = [_tableArr objectAtIndex:indexPath.row];

        if ([[dataDic objectForKey:@"rank"] intValue]==1) {
            [cell.bgImageView setBackgroundImage:[UIImage imageNamed:@"金杯icon.png"] forState:UIControlStateNormal];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==2) {
            [cell.bgImageView setBackgroundImage:[UIImage imageNamed:@"银杯icon.png"] forState:UIControlStateNormal];
            
            
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==3) {
            [cell.bgImageView setBackgroundImage:[UIImage imageNamed:@"铜杯icon.png"] forState:UIControlStateNormal];
            
            
        }
 
    
    else
    {
       NSString *str = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"rank"] intValue]];
        [cell.bgImageView setTitle:str forState:UIControlStateNormal];
        cell.bgImageView.titleLabel.font =[UIFont fontWithName:@"Black Ops One" size:30];
        [cell.bgImageView setTitleColor:[ToolList getColor:@"FFBB2C"] forState:UIControlStateNormal];
    }
    cell.nameLabel.text = [ToolList changeNull:[dataDic objectForKey:@"salerName"]];
    cell.buMenLabel.text =[ToolList changeNull:[dataDic objectForKey:@"jobGrade"]];
    cell.numberLabel.text=[NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"salesAchivement"]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

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
