//
//  QZ_TJView.m
//  SaleManagement
//
//  Created by chaiyuan on 16/7/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "QZ_TJView.h"
#import "QZ_TJCell.h"


#define CYHANDVIEW_H 44

@implementation QZ_TJView{
    
    UIButton *mx_AddLink;
    UIView *mx_blackView;
    int startNum;
    UIScrollView *selectContentScrollView;
    UIButton *btnCommit;
    NSMutableArray *fensiBtnArr;
    UIView *swView;
    NSMutableArray *swBtnArr;
    NSString *bumenId;//分司
    NSString *depId;//部门
    UILabel *numL;
    FX_Button *SButton;
}

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {

        
       [self makeSelfView];
        
        if (_mxArr == nil) {
            startNum = 1;
            
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
                _MXrequestDic[@"subId"]=@"";
            }
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
                _MXrequestDic[@"salerId"]=@"";
            }
            _MXrequestDic[@"dataFilter"]=[NSNumber numberWithInt:1];
            _MXrequestDic[@"deptId"]=@"";
            
            [self allMxRequest];
        }
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
            
            [FX_UrlRequestManager postByUrlStr:qz_getSubAndDeptByAreaIdNew_url andPramas:nil andDelegate:self andSuccess:@"getSubAndDeptByAreaIdNewSuccess:" andFaild:nil andIsNeedCookies:NO];
        }
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
            
               [FX_UrlRequestManager postByUrlStr:deptListInit_url andPramas:nil andDelegate:self andSuccess:@"getSubAndDeptByAreaIdNewSuccess:" andFaild:nil andIsNeedCookies:NO];
        }
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
            
            [FX_UrlRequestManager postByUrlStr:SalerAndAll_url andPramas:nil andDelegate:self andSuccess:@"getSubAndDeptByAreaIdNewSuccess:" andFaild:nil andIsNeedCookies:NO];
        }
    }
    return self;
}

-(void)allMxRequest{
       
    _MXrequestDic[@"pageNo"]=[NSNumber numberWithInt:startNum];
    _MXrequestDic[@"pagesize"]=@"10";
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
         [FX_UrlRequestManager postByUrlStr:MXgetAreaYeJi_url andPramas:_MXrequestDic andDelegate:self andSuccess:@"mxGetAreaYeJiSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
         [FX_UrlRequestManager postByUrlStr:ZJDeptYejiDetail_url andPramas:_MXrequestDic andDelegate:self andSuccess:@"mxGetAreaYeJiSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        [FX_UrlRequestManager postByUrlStr:DeptYejiDetail_url andPramas:_MXrequestDic andDelegate:self andSuccess:@"mxGetAreaYeJiSuccess:" andFaild:nil andIsNeedCookies:YES];
    }

//    NSLog(@"###########%@",_MXrequestDic);
}

-(void)mxGetAreaYeJiSuccess:(NSDictionary *)sucDic{
    
    
    [_mxTabel.refreshHeader endRefreshing];
    [_mxTabel.refreshFooter endRefreshing];
//    NSLog(@"+++++++++%@",sucDic);
    if ([[sucDic objectForKey:@"code"]intValue]==200) {

           numL.text = [NSString stringWithFormat:@"共 %@元(%@条)",[sucDic objectForKey:@"totalAccount"],[sucDic objectForKey:@"total"]];
        
        if (startNum ==1) {
            
            if ([[sucDic objectForKey:@"result"] count ]== 0) {
                
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据!"];
                
            }
            _mxArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
            
        }else{
            
            NSArray *dataArr =[sucDic objectForKey:@"result"];
            
            if (dataArr.count) {
                
                [_mxArr addObjectsFromArray:dataArr];
                
            }else{
                
                [ToolList showRequestFaileMessageLittleTime:@"暂无更多数据!"];
            }

        }

        [_mxTabel reloadData];
        
        
    }

}

#pragma mark----获取区总下分司和部门（带上不限字段）
-(void)getSubAndDeptByAreaIdNewSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"]intValue]==200){

         _comArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
        
         [self createSelectView];

    }
}

#pragma mark --- 绘制筛选项页面
-(void)createSelectView{

   //计算高度
   float fensi_h = _comArr.count?35+(_comArr.count+2)/3*45:0;

   float main_h = 85+fensi_h+35;
   
   if(main_h<__MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)
   {
   selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, main_h);
   selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
   }
   else
   {
   selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, mx_blackView.bounds.size.height);
   selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
   }
 
    float btn_w = (__MainScreen_Width-48)/3.;
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 58, 14)];
    zhuangtaiL.text = @"日期";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [selectContentScrollView addSubview:zhuangtaiL];
    
    NSArray *zhuangtaiA =@[@{@"1":@"今日"},@{@"2":@"昨日"},@{@"3":@"本月"},@{@"4":@"上月"}];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i+1)+i*((__MainScreen_Width-63)/4) , 36, (__MainScreen_Width-63)/4, 34) andType:@"1" andTitle:@"日期" andTarget:self andDic:dic];
        
        [selectContentScrollView addSubview:btn2];
        
        if (i==0) {
            btn2.isSelect = YES;
            [btn2 changeType1Btn:YES];
        }
        
        [_selectBtArr addObject:btn2];
    }


   UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 84, __MainScreen_Width, 1)];
   line.backgroundColor = [ToolList getColor:@"e7e7eb"];
   [selectContentScrollView addSubview:line];
   
   //区总---分司  总监---部门
   UILabel *j_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, __MainScreen_Width-20, 35)];
   j_l.font = [UIFont systemFontOfSize:14];
   j_l.textColor = [ToolList getColor:@"666666"];
    [selectContentScrollView addSubview:j_l];
    
   if(_comArr.count == 0)
   {
       j_l.hidden = YES;
   }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
        j_l.text = @"分司";
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        
        j_l.text = @"部门";
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        
        j_l.text = @"商务";
    }

   for (int i = 0 ; i < _comArr.count; i ++) {
       FX_Button * btn;
       if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
           btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 85+35+(i/3)*45, btn_w, 30) andType:@"7" andTitle:@"分司" andTarget:self andDic:[_comArr objectAtIndex:i] ];
           [selectContentScrollView addSubview:btn];
           
           if (i==0) {
               btn.isSelect = YES;
               [btn changeType1Btn:YES];
           }
           [fensiBtnArr addObject:btn];
       }
       else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
           
          btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 85+35+(i/3)*45, btn_w, 30) andType:@"5" andTitle:@"分司" andTarget:self andDic:[_comArr objectAtIndex:i] ];
           [selectContentScrollView addSubview:btn];
           
           if (i==0) {
               btn.isSelect = YES;
               [btn changeType1Btn:YES];
           }
           
           [fensiBtnArr addObject:btn];
       }
       else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
           
           btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 85+35+(i/3)*45, btn_w, 30) andType:@"6" andTitle:@"部门" andTarget:self andDic:[_comArr objectAtIndex:i] ];
           [selectContentScrollView addSubview:btn];
           
           if (i==0) {
               btn.isSelect = YES;
               [btn changeType1Btn:YES];
           }
           
           [swBtnArr addObject:btn];
       }
      
       
       
   }
   
    
   UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, fensi_h+85, __MainScreen_Width, 1)];
   line1.backgroundColor = [ToolList getColor:@"e7e7eb"];
   [selectContentScrollView addSubview:line1];
   
   
   btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
   btnCommit.frame = CGRectMake(0, 85+fensi_h, __MainScreen_Width, 35);
   btnCommit.titleLabel.font = [UIFont systemFontOfSize:16];
   [btnCommit setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
   [btnCommit setTitle:@"完成" forState:UIControlStateNormal];
   [btnCommit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
   [selectContentScrollView addSubview:btnCommit];
   

}

#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    
    //日期
    if([str isEqualToString:@"日期"])
    {
        if(btn.isSelect)
        {
            NSString *zhuangtaiNameStr = [[dic1 allKeys] lastObject];
                for (FX_Button *btnS in _selectBtArr)
                {
                    if(btnS!=btn)
                    {
                        [btnS changeType1Btn:NO];
                    }
                }
            [SButton setTitle:[NSString stringWithFormat:@"%@",[[dic1 allValues]lastObject]] forState:UIControlStateNormal];
            _MXrequestDic[@"dataFilter"]=[NSNumber numberWithInt:[zhuangtaiNameStr intValue]];

            }
    }
 
    //部门
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
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
                
                bumenId = [dic1 objectForKey:@"subId"];
                depId = @"";
                if ([[dic1 objectForKey:@"deptList"] isKindOfClass:[NSArray class]]) {
                    NSArray *deptEmpArr = [dic1 objectForKey:@"deptList"];
                    [self makeSWtwo:deptEmpArr];
                    
                }else{
                    
                    [self makeSWtwo:nil];
                    
                }
            }
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
                
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
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
            _MXrequestDic[@"subId"]=bumenId;
            _MXrequestDic[@"deptId"]=depId;
        }
       else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
           _MXrequestDic[@"salerId"]=depId;
            _MXrequestDic[@"deptId"]=bumenId;
        }
        
    }else{
        
        if(btn.isSelect)
        {
            for (FX_Button *btnS in swBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
                  depId = [dic1 objectForKey:@"deptId"];
            }
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
                 depId = [dic1 objectForKey:@"salerId"];
            }
         
            
        }
        else
        {
            depId = @"";
            
        }
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
            _MXrequestDic[@"deptId"]=depId;
        }
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
            _MXrequestDic[@"salerId"]=depId;
        }
        
    }

}

#pragma mark - 完成按钮
-(void)commit:(UIButton *)sender{
    
    [self mx_pSelectBtnClicked:mx_AddLink];
    
    startNum = 1;
    [self allMxRequest];
}

#pragma mark - 总监点击部门显示商务操作
-(void)makeSWtwo:(NSArray *)empArr{
    
     float fensi_h = _comArr.count?35+(_comArr.count+2)/3*45:0;
    float sw_h = 0.0f;
    float main_h =0.0f;
    [swView removeFromSuperview];
    
    swView = nil;
    
    if (empArr.count) {
        
        sw_h = 35+(empArr.count+2)/3*45;
        main_h = fensi_h+86+sw_h+35;
        
        swView = [[UIView alloc]initWithFrame:CGRectMake(0,fensi_h+86, __MainScreen_Width, sw_h)];
        swView.backgroundColor = [UIColor clearColor];
        [selectContentScrollView addSubview:swView];
        
        //部门
        UILabel *z_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, __MainScreen_Width-20, 35)];
        z_l.font = [UIFont systemFontOfSize:14];
        z_l.textColor = [ToolList getColor:@"666666"];
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
            
           z_l.text = @"部门";
        }
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
            
            z_l.text = @"商务";
        }
        
        
        [swView addSubview:z_l];
        
        float btn_w = (__MainScreen_Width-48)/3.;
        
        for (int i = 0 ; i < empArr.count; i ++) {
            FX_Button * btn;
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
                
                
                btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"5" andTitle:@"部门" andTarget:self andDic:[empArr objectAtIndex:i]];
            }
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
                
                
               btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"6" andTitle:@"部门" andTarget:self andDic:[empArr objectAtIndex:i]];
            }
            
            [swView addSubview:btn];
            
            if (i==0) {
                btn.isSelect = YES;
                [btn changeType1Btn:YES];
            }
            
            [swBtnArr addObject:btn];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sw_h, __MainScreen_Width, 1)];
        line.backgroundColor = [ToolList getColor:@"e7e7eb"];
        [swView addSubview:line];
        
    }else{
        sw_h = 0.0f;
        main_h = fensi_h+86+35;
    }
    
    
    if(main_h<__MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, main_h);
        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
        
    }
    else
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, mx_blackView.bounds.size.height);
        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
        
    }
    
    btnCommit.frame = CGRectMake(0, main_h-35, __MainScreen_Width, 35);
    
}


#pragma mark 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    startNum = 1;
    [self allMxRequest];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    startNum ++;
    [self allMxRequest];
    
}

-(void)makeSelfView{
    
    _MXrequestDic = [[NSMutableDictionary alloc]init];
    _selectBtArr = [[NSMutableArray alloc]init];
    fensiBtnArr = [[NSMutableArray alloc]init];
    swBtnArr =[[NSMutableArray alloc]init];
    
    mx_blackView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+CYHANDVIEW_H+43-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45)];
    mx_blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addSubview:mx_blackView];
    
    selectContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectContentScrollView.showsVerticalScrollIndicator = NO;
    selectContentScrollView.backgroundColor = [UIColor whiteColor];
    [mx_blackView addSubview:selectContentScrollView];
        
    UIView *sxView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width,44)];
    sxView.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [self addSubview:sxView];
    
    mx_AddLink = [UIButton buttonWithType:UIButtonTypeCustom];
    mx_AddLink.frame = CGRectMake(__MainScreen_Width-52-13, 3, 52, 35);
    mx_AddLink.backgroundColor = [UIColor clearColor];
    [mx_AddLink setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [mx_AddLink setTitle:@"筛选" forState:UIControlStateNormal];
    [mx_AddLink addTarget:self action:@selector(mx_pSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mx_AddLink setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    mx_AddLink.titleLabel.font = [UIFont systemFontOfSize:12];
    [sxView addSubview:mx_AddLink];
    
    SButton = [[FX_Button alloc] initWithFrame:CGRectMake(12 , 5,  (__MainScreen_Width-63)/4, 34) andType:@"1" andTitle:@"日期" andTarget:nil andDic:@{@"1":@"今日"}];
    [SButton changeType1Btn:YES];
    [sxView addSubview:SButton];
    
    //筛选条件显示
    numL = [[UILabel alloc] initWithFrame:CGRectMake(SButton.frame.origin.x+SButton.frame.size.width+10 , 5,173, 34)];
    numL.textColor = [ToolList getColor:@"666666"];
    numL.font = [UIFont systemFontOfSize:13];
    [sxView addSubview:numL];
    
    _mxTabel = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, 45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _mxTabel.dataSource = self;
    _mxTabel.delegate = self;
    [self addSubview:_mxTabel];
}

#pragma mark --- 点击筛选按钮
-(void)mx_pSelectBtnClicked:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            mx_blackView.frame =CGRectMake(0, 45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45);
            
            [self bringSubviewToFront:mx_blackView];
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            mx_blackView.frame =CGRectMake(0, IOS7_Height+CYHANDVIEW_H+43-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45);
        }];
    }
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mxArr count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        return 116;
    }

    return 140.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QZ_TJCell";
    QZ_TJCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QZ_TJCell" owner:self options:nil] lastObject];
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 115.5) toPoint:CGPointMake(__MainScreen_Width, 115.5) andWeight:0.5 andColorString:@"e7e7eb"]];

        }
        else
        {
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 139.5) toPoint:CGPointMake(__MainScreen_Width, 139.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        }
        
    }
    
    NSDictionary *childDic = [_mxArr objectAtIndex:indexPath.row];
    
    cell.comL.text = [ToolList changeNull:[childDic objectForKey:@"custName"]];
    cell.moneyL.text=[NSString stringWithFormat:@"%@",[ToolList changeNull:[childDic objectForKey:@"accountDetail"]]];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
        cell.nameL.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[childDic objectForKey:@"salerName"]],[ToolList changeNull:[childDic objectForKey:@"custVirtualType"]]];
        
        cell.fenComL.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[childDic objectForKey:@"subName"]],[ToolList changeNull:[childDic objectForKey:@"deptName"]]];
        cell.proL.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[childDic objectForKey:@"orderRecordCode"]],[ToolList changeNull:[childDic objectForKey:@"productName"]]];
        cell.dayL.text = [ToolList changeNull:[childDic objectForKey:@"accountDate"]];


    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        
        cell.nameL.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[childDic objectForKey:@"custVirtualType"]]];
        cell.fenComL.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[childDic objectForKey:@"salerName"]],[ToolList changeNull:[childDic objectForKey:@"deptName"]]];
        cell.proL.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[childDic objectForKey:@"orderRecordCode"]],[ToolList changeNull:[childDic objectForKey:@"productName"]]];
        cell.dayL.text = [ToolList changeNull:[childDic objectForKey:@"accountDate"]];


    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        
        cell.nameL.text =  [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[childDic objectForKey:@"orderRecordCode"]],[ToolList changeNull:[childDic objectForKey:@"productName"]]];
        cell.fenComL.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[childDic objectForKey:@"salerName"]],[ToolList changeNull:[childDic objectForKey:@"custVirtualType"]]];
        cell.proL.text = [ToolList changeNull:[childDic objectForKey:@"accountDate"]];

        cell.dayL.hidden = YES;

    }
    
    return cell;
    
}




@end
