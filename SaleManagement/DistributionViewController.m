//
//  DistributionViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/29.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "UserDetailViewController.h"
#import "DistributionTableViewCell.h"
#import "DistributionViewController.h"
#import "FX_Button.h"
#import "Fx_TableView.h"
#import "DistributionDetailViewController.h"
#import "SearchViewController.h"
#import "CY_popupV.h"
#import "AlertSalersViewController.h"

#define SELECT_H (IOS7_Height+90)
@interface DistributionViewController ()
{
  
    NSMutableArray *shifangArr;
    NSMutableArray *xinKehuArr;
    NSMutableArray *wangzhankehuArr;
    NSMutableArray *qitakehuArr;
    NSMutableArray *countIndexFlag;
    //底部操作层
    UIView *doView;
    //搜索框
    UITextField *text;
    //搜索区域
//    UIView *searchView;
  
    //请求开始页
    int startPage;
    NSDictionary *  requestDic2;
    //请求参数
    NSMutableDictionary *requestDic;
    //存头部筛选按钮
    NSMutableArray *selectBtnArr;
    NSMutableArray *select_depBtnArr;
    NSMutableArray *select_leiBtnArr;
    NSMutableArray *selectBtn2Arr;
    NSMutableArray *select_depBtn2Arr;
  
    //当前显示页
    int currentPage;
    //table
    Fx_TableView *tableView;

    //员工异动数据
    NSMutableArray *data;
  
    //释放按钮
    UIButton *shiFangBtn;
    //分配按钮
    UIButton *fenPeiBtn;
   
    //搜索数据
    NSMutableArray *dataSearchArr;
    //搜索请求传参
    NSMutableDictionary *searchRequestDic;
    //未签约客户筛选页面
    UIView *selectContentView;
   
}
@property (nonatomic,strong)NSMutableArray *isWrittenArr;//签约客户的筛选
@property (nonatomic,strong)NSMutableArray *noWrittenArr;//未签约客户的筛选
@property (nonatomic,strong)NSMutableArray *deptListArr;//全部部门
 @property (nonatomic,strong) CY_popupV  *popuV;

 @property (nonatomic,strong) NSString  *laiYuanStr;
 @property (nonatomic,strong) NSString  *depStr;
 @property (nonatomic,strong) NSString  *leiXingStr;

@end

@implementation DistributionViewController
#pragma mark - 非签约客户点击
- (IBAction)grBtnClicked:(UIButton *)sender {
    
    sender.selected = YES;
    _bm_btn.selected = NO;

    _leiXingStr = @"";
    _depStr = @"";
    _laiYuanStr = @"";
    [self initSelectView];
 
    for (UIView *view_sub in [doView subviews])
    {
        [view_sub removeFromSuperview];
    }
    [doView addSubview:shiFangBtn];
    [doView addSubview:fenPeiBtn];
      fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custSource"];
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    [requestDic setObject:@"0" forKey:@"isWritten"];
    [requestDic setObject:@"-1" forKey:@"isWebsite"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2) {//总监
        [requestDic setObject:@"" forKey:@"deptId"];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){//经理
        
        [requestDic setObject:@"" forKey:@"salerId"];
    }
    _gr_Btn.backgroundColor = [ToolList getColor:@"ba81ff"];
    [_gr_Btn setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
    _bm_btn.backgroundColor = [ToolList getColor:@"ffffff"];
    [_bm_btn setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
    [self requestData];

    
}
#pragma mark - 签约客户点击
- (IBAction)bmBtnClicked:(UIButton *)sender {
    sender.selected = YES;
    _gr_Btn.selected = NO;
    _leiXingStr = @"";
    _depStr = @"";
    _laiYuanStr = @"";
    [self initSelectView2];
  
    for (UIView *view_sub in [doView subviews])
    {
        [view_sub removeFromSuperview];
    }
     [doView addSubview:fenPeiBtn];
      fenPeiBtn.frame = CGRectMake(0, 1, __MainScreen_Width, CaozuoViewHeight-1);
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custSource"];
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    [requestDic setObject:@"1" forKey:@"isWritten"];
    [requestDic setObject:@"-1" forKey:@"isWebsite"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2) {//总监
        [requestDic setObject:@"" forKey:@"deptId"];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){//经理
        
        [requestDic setObject:@"" forKey:@"salerId"];
    }
    [self requestData];
    _bm_btn.backgroundColor = [ToolList getColor:@"ba81ff"];
    [_bm_btn setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
    _gr_Btn.backgroundColor = [ToolList getColor:@"ffffff"];
    [_gr_Btn setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];

    
}
#pragma mark - 取消筛选
-(void)cancel
{

    [requestDic setObject:@"" forKey:@"custSource"];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
          [requestDic setObject:@"" forKey:@"deptId"];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
         [requestDic setObject:@"" forKey:@"salerId"];
    }
    [requestDic setObject:@"-1" forKey:@"isWebsite"];
   
    [UIView animateWithDuration:0.3 animations:^{
        selectContentView.frame = CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H);
    }];

  
}
#pragma mark - 完成筛选
-(void)finish
{
    [UIView animateWithDuration:0.3 animations:^{
        selectContentView.frame = CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H);
    }];
  
    if (_bm_btn.selected) {
        [self initSelectView2];
    }
    else if (_gr_Btn.selected){
        [self initSelectView];
    }
    [self requestData];
}
#pragma mark - 筛选按钮点击
- (IBAction)selectBtnClicked:(UIButton *)sender {

    if (_gr_Btn.selected) {

        [self initSelectView];
    }
    if (_bm_btn.selected) {
       
         [self initSelectView2];
    }
   
    [UIView animateWithDuration:0.3 animations:^{
        selectContentView.frame = CGRectMake(0, SELECT_H, __MainScreen_Width, __MainScreen_Height-SELECT_H);
    }];
  
}
#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];

    if ([str isEqualToString:@"未签约来源"]) {
        
        for (FX_Button *bt in selectBtnArr) {
            if( btn==bt)
            {
                [bt changeColorCliked1:YES];
            }
            else
            {
                [bt changeColorCliked1:NO];
                
            }
            
        }
        _laiYuanStr =[dic1 objectForKey:@"id"];
         [requestDic setObject:[dic1 objectForKey:@"id"] forKey:@"custSource"];
    }
    else if ([str isEqualToString:@"签约来源"]){
        
        for (FX_Button *bt in selectBtn2Arr) {
            if( btn==bt)
            {
                [bt changeColorCliked1:YES];
            }
            else
            {
                [bt changeColorCliked1:NO];
                
            }
            
        }
          [requestDic setObject:[dic1 objectForKey:@"id"] forKey:@"custSource"];
         _laiYuanStr =[dic1 objectForKey:@"id"];
    }
    else if ([str isEqualToString:@"未签约部门"]){
        
        for (FX_Button *bt in select_depBtnArr) {
            if( btn==bt)
            {
                [bt changeColorCliked1:YES];
            }
            else
            {
                [bt changeColorCliked1:NO];
                
            }
            
        }
        
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
            [requestDic setObject:[dic1 objectForKey:@"salerId"] forKey:@"salerId"];
             _depStr =[dic1 objectForKey:@"salerId"];
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
            [requestDic setObject:[dic1 objectForKey:@"deptId"] forKey:@"deptId"];
              _depStr =[dic1 objectForKey:@"deptId"];
        }
        
    }
    else if ([str isEqualToString:@"签约部门"]){
        for (FX_Button *bt in select_depBtn2Arr) {
            if( btn==bt)
            {
                [bt changeColorCliked1:YES];
            }
            else
            {
                [bt changeColorCliked1:NO];
                
            }
            
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
              [requestDic setObject:[dic1 objectForKey:@"salerId"] forKey:@"salerId"];
            _depStr =[dic1 objectForKey:@"salerId"];
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
              [requestDic setObject:[dic1 objectForKey:@"deptId"] forKey:@"deptId"];
            _depStr =[dic1 objectForKey:@"deptId"];
        }
        
       
    }
    else if ([str isEqualToString:@"客户类型"]){
        for (FX_Button *bt in select_leiBtnArr) {
            if( btn==bt)
            {
                [bt changeColorCliked1:YES];
            }
            else
            {
                [bt changeColorCliked1:NO];
                
            }
            
        }
         [requestDic setObject:[dic1 objectForKey:@"id"] forKey:@"isWebsite"];
        _depStr =[dic1 objectForKey:@"id"];
    }
}
#pragma mark----创建未签约客户筛选页面
-(void)initSelectView{

    //重绘
    for (UIView *sub in selectContentView.subviews) {
        if(sub)
        {
            [sub removeFromSuperview];
        }
    }

    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 145)];
    vv.backgroundColor = [UIColor whiteColor];
    [selectContentView addSubview:vv];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 35)];
    zhuangtaiL.text = @"  来源";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [vv addSubview:zhuangtaiL];
   
    [selectBtnArr removeAllObjects];
    float btn_w = (__MainScreen_Width-60)/4.;
     int coust_2 = _noWrittenArr.count%4 >0 ?1:0;
    for (int i = 0; i < _noWrittenArr.count; i ++ ) {
        
        NSDictionary *dic = [_noWrittenArr objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%4)*(btn_w+12), 35+(i/4)*45, btn_w, 30) andType:@"10" andTitle:@"未签约来源" andTarget:self andDic:dic];
        
        [selectBtnArr addObject:btn];
        [vv addSubview:btn];
     
        if ([[dic objectForKey:@"id"] isEqualToString:_laiYuanStr])
        {
            [btn changeColorCliked1:YES];
        }
        
    }
    
    //线
    [vv.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 35+(_noWrittenArr.count/4+coust_2)*45-0.5) toPoint:CGPointMake(__MainScreen_Width, 35+(_noWrittenArr.count/4+coust_2)*45-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
 
    UILabel *deptL = [[UILabel alloc]initWithFrame:CGRectMake(0, 35+(_noWrittenArr.count/4+coust_2)*45, __MainScreen_Width, 35)];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
         deptL.text = @"  原商务";
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
         deptL.text = @"  部门";
    }
   
    deptL.font = [UIFont systemFontOfSize:14];
    deptL.textColor = [ToolList getColor:@"666666"];
    [vv addSubview:deptL];
  
     [select_depBtnArr removeAllObjects];
 int coust_1 = _deptListArr.count%4 >0 ?1:0;
    for (int i = 0; i < _deptListArr.count; i ++ ) {
        
        NSDictionary *dic = [_deptListArr objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%4)*(btn_w+12), deptL.frame.size.height+deptL.frame.origin.y+(i/4)*45, btn_w, 30) andType:@"10" andTitle:@"未签约部门" andTarget:self andDic:dic];
        
        [select_depBtnArr addObject:btn];
        [vv addSubview:btn];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
          
            if ([[dic objectForKey:@"salerId"] isEqualToString:_depStr])
            {
                
                [btn changeColorCliked1:YES];
            }
            
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
          
            if ([[dic objectForKey:@"deptId"] isEqualToString:_depStr])
            {
                
                [btn changeColorCliked1:YES];
            }
        }
        
       
    }
    
    //按钮区域
    UIView *bottomBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, deptL.frame.size.height+deptL.frame.origin.y+(_deptListArr.count/4+coust_1)*45, __MainScreen_Width, 44)];
//    bottomBtnView.backgroundColor = [UIColor yellowColor];
    
    vv.frame = CGRectMake(0, 0, __MainScreen_Width, bottomBtnView.frame.origin.y+bottomBtnView.frame.size.height);
    //线
    [bottomBtnView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 5) toPoint:CGPointMake(__MainScreen_Width/2, 34) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    [vv addSubview:bottomBtnView];
    
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor: [ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, 44);
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:cancelBtn];
    //完成
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor: [ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    finishBtn.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, 44);
    [finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:finishBtn];
    
    [bottomBtnView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.8 andColorString:@"e7e7eb"]];
}

#pragma mark----创建签约客户筛选页面
-(void)initSelectView2{
    
    //重绘
    for (UIView *sub in selectContentView.subviews) {
        if(sub)
        {
            [sub removeFromSuperview];
        }
    }
 
    
    NSArray *leiArr = @[@{@"id":@"",@"name":@"全部"},@{@"id":@"0",@"name":@"非网站客户"},@{@"id":@"1",@"name":@"网站客户"}];
     int coust_2 = _isWrittenArr.count%4 >0 ?1:0;
     int coust_1 = _deptListArr.count%4 >0 ?1:0;
    
    UIView *vv = [[UIView alloc] init];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        vv.frame =CGRectMake(0, 0,__MainScreen_Width, 70+(_isWrittenArr.count/4+coust_2)*45+(_deptListArr.count/4+coust_1)*45+44);
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
      vv.frame =CGRectMake(0, 0,__MainScreen_Width, 105+(_isWrittenArr.count/4+coust_2)*45+(_deptListArr.count/4+coust_1)*45+44+(leiArr.count/4+1)*45);
    }
    
    vv.backgroundColor = [UIColor whiteColor];
    [selectContentView addSubview:vv];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 35)];
    zhuangtaiL.text = @"  来源";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [vv addSubview:zhuangtaiL];
    
    [selectBtn2Arr removeAllObjects];
    float btn_w = (__MainScreen_Width-60)/4.;
    
    for (int i = 0; i < _isWrittenArr.count; i ++ ) {
        
        NSDictionary *dic = [_isWrittenArr objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%4)*(btn_w+12), 35+(i/4)*45, btn_w, 30) andType:@"10" andTitle:@"签约来源" andTarget:self andDic:dic];
        
        [selectBtn2Arr addObject:btn];
        [vv addSubview:btn];
        
        if ([[dic objectForKey:@"id"] isEqualToString:_laiYuanStr])
        {
            [btn changeColorCliked1:YES];
        }
    }
   
    //线
    [vv.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 35+(_isWrittenArr.count/4+coust_2)*45-0.5) toPoint:CGPointMake(__MainScreen_Width, 35+(_isWrittenArr.count/4+coust_2)*45-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    
    UILabel *deptL = [[UILabel alloc]initWithFrame:CGRectMake(0, 35+(_isWrittenArr.count/4+coust_2)*45, __MainScreen_Width, 35)];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        deptL.text = @"  原商务";
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        deptL.text = @"  部门";
    }
    deptL.font = [UIFont systemFontOfSize:14];
    deptL.textColor = [ToolList getColor:@"666666"];
    [vv addSubview:deptL];
    
     [select_depBtn2Arr removeAllObjects];
   
    for (int i = 0; i < _deptListArr.count; i ++ ) {
        
        NSDictionary *dic = [_deptListArr objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%4)*(btn_w+12), deptL.frame.size.height+deptL.frame.origin.y+(i/4)*45, btn_w, 30) andType:@"10" andTitle:@"签约部门" andTarget:self andDic:dic];
        
        [select_depBtn2Arr addObject:btn];
        [vv addSubview:btn];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
            
            if ([[dic objectForKey:@"salerId"] isEqualToString:_depStr])
            {
                
                [btn changeColorCliked1:YES];
            }
            
        }
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
            
            if ([[dic objectForKey:@"deptId"] isEqualToString:_depStr])
            {
                
                [btn changeColorCliked1:YES];
            }
        }
    }
    
    //线
    [vv.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, deptL.frame.origin.y+deptL.frame.size.height+(_deptListArr.count/4+coust_1)*45-0.5) toPoint:CGPointMake(__MainScreen_Width, deptL.frame.origin.y+deptL.frame.size.height+(_deptListArr.count/4+coust_1)*45-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    UIView *bottomBtnView = [[UIView alloc] init];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        
        //按钮区域
        bottomBtnView.frame =CGRectMake(0, deptL.frame.size.height+deptL.frame.origin.y+(_deptListArr.count/4+coust_1)*45, __MainScreen_Width, 44);
        
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        UILabel *leiL = [[UILabel alloc]initWithFrame:CGRectMake(0, deptL.frame.origin.y+deptL.frame.size.height+(_deptListArr.count/4+coust_1)*45, __MainScreen_Width, 35)];
        leiL.text = @"  客户类型";
        leiL.font = [UIFont systemFontOfSize:14];
        leiL.textColor = [ToolList getColor:@"666666"];
        [vv addSubview:leiL];
        
        
        [select_leiBtnArr removeAllObjects];
        for (int i = 0; i < leiArr.count; i ++ ) {
            
            NSDictionary *dic = [leiArr objectAtIndex:i];
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%4)*(btn_w+12), leiL.frame.size.height+leiL.frame.origin.y+(i/4)*45, btn_w, 30) andType:@"10" andTitle:@"客户类型" andTarget:self andDic:dic];
            
            [select_leiBtnArr addObject:btn];
            [vv addSubview:btn];
            
            if ([[dic objectForKey:@"id"] isEqualToString:_leiXingStr])
            {
                [btn changeColorCliked1:YES];
            }
            
        }
        //按钮区域
        bottomBtnView.frame =CGRectMake(0, leiL.frame.size.height+leiL.frame.origin.y+(leiArr.count/4+1)*45, __MainScreen_Width, 44);
    }

    //线
    [bottomBtnView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 5) toPoint:CGPointMake(__MainScreen_Width/2, 34) andWeight:0.5 andColorString:@"e7e7eb"]];
   [bottomBtnView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.8 andColorString:@"e7e7eb"]];
    [vv addSubview:bottomBtnView];
    
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor: [ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, 44);
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:cancelBtn];
    //完成
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor: [ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    finishBtn.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, 44);
    [finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:finishBtn];
 

  
}
#pragma mark - 搜索按钮点击
-(void)searchClicked:(UIButton *)btn
{
    
    text.text = @"";
    [text becomeFirstResponder];
    [countIndexFlag removeAllObjects];
    [shifangArr removeAllObjects];
    
    SearchViewController *gh = [[SearchViewController alloc] init];
//    gh.czBlock = ^(NSDictionary * dic)
//    {
//        _comL.text = [dic objectForKey:@"castname"];
//        _custId = [dic objectForKey:@"castid"];
//
//    };
    gh.isMyclient = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"" forKey:@"custName"];
    [dic setObject:@"0" forKey:@"flag"];
    gh.swSearchRequestDic = dic;
    [self.navigationController pushViewController:gh animated:NO];
    
    
}
#pragma mark - 请求搜索数据成功
-(void)requestSearchSuccess:(NSDictionary *)dic
{
    [data removeAllObjects];
   
    [text resignFirstResponder];
    [countIndexFlag removeAllObjects];
    [shifangArr removeAllObjects];
   
    _date_L.text = [NSString stringWithFormat:@"  共 %@ 条",[dic objectForKey:@"total"]];

    if([[dic objectForKey:@"result"] count] <= 0)
    {
        [tableView reloadData];
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {

        [data addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [tableView reloadData];
    }
  
}
#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    [searchRequestDic setObject:theTextField.text forKey:@"custName"];
   
    [searchRequestDic setObject:@"0" forKey:@"flag"];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2) {
        
          [FX_UrlRequestManager postByUrlStr:WillAssignCustByCustName1_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSearchSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1) {
         [FX_UrlRequestManager postByUrlStr:WillAssignCustByCustName_url andPramas:searchRequestDic andDelegate:self andSuccess:@"requestSearchSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    
 
    return YES;
}

#pragma mark - 取消搜索
-(void)cancelSearch:(UIButton *)btn
{
 
   
    [text resignFirstResponder];
    [countIndexFlag removeAllObjects];
    [shifangArr removeAllObjects];
    [self requestData];

//    [UIView animateWithDuration:0.3 animations:^{
//        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
//    }];
}

#pragma mark - 数据请求
-(void) requestData
{
    
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2) {//总监
         [FX_UrlRequestManager postByUrlStr:WillAssignCust_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){//经理
        
          [FX_UrlRequestManager postByUrlStr:AssignCustM_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    
  
}

#pragma mark - 数据请求成功
-(void)requestSuccess:(NSDictionary *)dic
{
    [tableView.refreshHeader endRefreshing];
    [tableView.refreshFooter endRefreshing];
    [countIndexFlag removeAllObjects];
    _date_L.text = [NSString stringWithFormat:@"  共 %@ 条",[dic objectForKey:@"total"]];
    [_gr_Btn setTitle:[NSString stringWithFormat:@"未签约客户(%@)",[dic objectForKey:@"noWritten"]] forState: UIControlStateNormal];
     [_bm_btn setTitle:[NSString stringWithFormat:@"签约客户(%@)",[dic objectForKey:@"isWritten"]] forState: UIControlStateNormal];
    if(startPage == 1)
    {
        [data removeAllObjects];
    }
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        if(startPage == 1)
        {
            [data removeAllObjects];
            [tableView reloadData];
        }
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [data addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [tableView reloadData];
    }
}

#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(NSString *)flag
{
  
        startPage = 1;
        [self requestData];
  }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
    doView.hidden = YES;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
#pragma mark---总监待分配来源筛选
       [FX_UrlRequestManager postByUrlStr:getFilterData_url andPramas:nil andDelegate:self andSuccess:@"getFilterDataSuccess:" andFaild:nil andIsNeedCookies:NO];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1) {
        [FX_UrlRequestManager postByUrlStr:getWillAssignCust_url_2 andPramas:nil andDelegate:self andSuccess:@"getFilterDataSuccess:" andFaild:nil andIsNeedCookies:NO];
    }
}

-(void)getFilterDataSuccess:(NSDictionary *)dic{
  
    if ([[dic objectForKey:@"code"] intValue]==200) {
        
        if (_isWrittenArr) {
            [_isWrittenArr removeAllObjects];
        }
        if (_noWrittenArr) {
             [_noWrittenArr removeAllObjects];
        }
        _isWrittenArr = [[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"result"] objectForKey:@"isWrittenList"]];
        _noWrittenArr =[[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"result"] objectForKey:@"noWrittenList"]];
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
            _deptListArr =[[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"result"] objectForKey:@"deptList"]];
        }
        else  if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
              _deptListArr =[[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"result"] objectForKey:@"salerList"]];
        }

            [self initSelectView];
    }
}
//加载更多
-(void)footerRefresh:(NSString *)flag
{
        startPage += 1;
  
        [self requestData];
    
}
#pragma mark - 初始化
-(void)initView
{
    _leiXingStr = @"";
    _depStr = @"";
    _laiYuanStr = @"";
#pragma mark - 数据初始化
    shifangArr = [[NSMutableArray alloc] init];
    searchRequestDic = [[NSMutableDictionary alloc] init];
    countIndexFlag = [[NSMutableArray alloc] init];
    [searchRequestDic setObject:@"" forKey:@"custName"];
    xinKehuArr = [[NSMutableArray alloc] init];
    wangzhankehuArr = [[NSMutableArray alloc] init];
    qitakehuArr = [[NSMutableArray alloc] init];
    selectBtnArr = [[NSMutableArray alloc] init];
    select_depBtnArr =[[NSMutableArray alloc] init];
    selectBtn2Arr = [[NSMutableArray alloc] init];
    select_depBtn2Arr =[[NSMutableArray alloc] init];
    select_leiBtnArr=[[NSMutableArray alloc] init];
    currentPage = 0;
    data = [[NSMutableArray alloc] init];
    
    startPage = 1;
   
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"" forKey:@"custSource"];
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    [requestDic setObject:@"0" forKey:@"isWritten"];
    [requestDic setObject:@"-1" forKey:@"isWebsite"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2) {//总监
      [requestDic setObject:@"" forKey:@"deptId"];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){//经理
        
        [requestDic setObject:@"" forKey:@"salerId"];
    }
   
#pragma mark - 页面初始化
    _selectView.layer.cornerRadius = 4;
    _selectView.layer.masksToBounds = YES;
    _selectView.layer.borderWidth = 1;
    _selectView.layer.borderColor = [ToolList getColor:@"ba81ff"].CGColor;
    //标题
    [self addNavgationbar:@"待分配客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];

    //中间数据层
     tableView = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight*2, __MainScreen_Width, __MainScreen_Height-IOS7_Height-SelectViewHeight-CaozuoViewHeight) style:UITableViewStylePlain isNeedRefresh:YES target:self Flag:@"1"];
    [tableView.refreshHeader autoRefreshWhenViewDidAppear];

    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 1;
    tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:tableView];
    
    
    selectContentView = [[UIView alloc] initWithFrame:CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H)];
    [self.view addSubview:selectContentView];
    selectContentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    //底部操作层
    doView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-CaozuoViewHeight, __MainScreen_Width, CaozuoViewHeight)];
    doView.backgroundColor = [ToolList getColor:@"fafafa"];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0.8) toPoint:CGPointMake(__MainScreen_Width, 0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"释放" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [shiFangBtn addTarget:self action:@selector(shiFangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_shifang.png"] forState:UIControlStateNormal];
    [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:shiFangBtn];
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [fenPeiBtn addTarget:self action:@selector(fenPeiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
    
    dataSearchArr = [[NSMutableArray alloc] init];
   /*
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __MainScreen_Height-CaozuoViewHeight)];
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
    */
    [self.view addSubview:doView];
    doView.hidden = YES;
//    [self.view addSubview:searchView];

     _gr_Btn.selected = YES;

}
#pragma mark - 释放按钮点击
-(void)shiFangBtnClicked:(UIButton *)btn
{
    if(shifangArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    _popuV = [[CY_popupV alloc]initWithMessage:@"确定要释放该客户吗？" andBtTitel_one:@"取消" andBtTitel_two:@"确定" andtarget:self andTag:btn.tag];
    [self.view addSubview:_popuV];
    
    return;
    
   
}
#pragma mark - 释放成功
-(void)shifangSuccess:(NSDictionary *)dic
{
    [shifangArr removeAllObjects];
    doView.hidden = YES;
    [_popuV removeFromSuperview];
    _popuV = nil;
    if([[dic objectForKey:@"code"] intValue]==200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"释放成功"];
      
            startPage = 1;
            [self requestData];
        
    
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - 分配按钮点击
-(void)fenPeiBtnClicked:(UIButton *)btn
{
    if(shifangArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){

        NSMutableArray *custIds = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in shifangArr) {
            NSString *custId = [dic objectForKey:@"custId"];
            [custIds addObject:custId];
        }
        AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
        dd.selectOKBlock = ^(NSString *salerId)
        {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
            NSDictionary *dic  = @{@"custIds":custIds,@"assignToDeptId":salerId};
          
            [FX_UrlRequestManager postByUrlStr:ZJAssignCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
            }
           
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
                  NSDictionary *requestD = @{@"custIds":custIds,@"assignToSalerId":salerId};
                 [FX_UrlRequestManager postByUrlStr:AssignCustToSaler_url andPramas:[NSMutableDictionary dictionaryWithDictionary:requestD] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
            }
           
        };
        [shifangArr removeAllObjects];
        [self.navigationController pushViewController:dd animated:NO];
    
        return;
        
//    }
    
    [xinKehuArr removeAllObjects];
    [wangzhankehuArr removeAllObjects];
    [qitakehuArr removeAllObjects];
    for (NSDictionary *dic in shifangArr) {
        if([[dic objectForKey:@"oldOrNew"] isEqualToString:@"新客户"])
        {
            [xinKehuArr addObject:[dic objectForKey:@"custId"]];
        }
        else if ([[dic objectForKey:@"oldOrNew"] isEqualToString:@"网站客户"])
        {
            [wangzhankehuArr addObject:[dic objectForKey:@"custId"]];
        }
        else
        {
            [qitakehuArr addObject:[dic objectForKey:@"custId"]];
        }
    }
     requestDic2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:xinKehuArr.count],@"newCust",[NSNumber numberWithLong:wangzhankehuArr.count],@"webCust",[NSNumber numberWithLong:qitakehuArr.count],@"noWebCust", nil];
    //查余额
    [FX_UrlRequestManager postByUrlStr:SalerCount_url andPramas:[NSMutableDictionary dictionaryWithDictionary:requestDic2] andDelegate:self andSuccess:@"chaYuSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}
#pragma mark - 查询商务经理名下客户剩余名额
-(void)chaYuSuccess:(NSDictionary *)dic
{
    DistributionDetailViewController *detail = [[DistributionDetailViewController alloc] init];
    detail.dataArr = [dic objectForKey:@"result"];
    detail.refreshIndex = currentPage;
    if(detail.dataArr.count)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:xinKehuArr];
        [arr addObjectsFromArray:wangzhankehuArr];
        [arr addObjectsFromArray:qitakehuArr];
        detail.custIds = arr;
        detail.selectDic = requestDic2;
        detail.czBlock = ^(int index)
        {
               startPage = 1;
                [self requestData];
            
        };
        [self.navigationController pushViewController:detail animated:NO];
        [shifangArr removeAllObjects];
        doView.hidden = YES;


    }
    else
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无合适的分配人员"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    if([[UIApplication sharedApplication] statusBarFrame].size.height>20){
        _topX.constant = 88.0f;
    }else{
         _topX.constant = 64.0f;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
        return data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DistributionTableViewCell";
    DistributionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DistributionTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic =  [data objectAtIndex:indexPath.row];
    
  
   
        
    cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    NSString *oldOrNew = [ToolList changeNull:[dic objectForKey:@"oldOrNew"]];
    NSString *custSource = [ToolList changeNull:[dic objectForKey:@"custSource"]];
    NSString *createTime =[ToolList changeNull:[dic objectForKey:@"createTime"]];
    NSString *oldOrNew1 = [ToolList changeNull:[dic objectForKey:@"deptName"]];
    NSString *exceedTime1 = [ToolList changeNull:[dic objectForKey:@"exceedTime"]];
    NSString *salerName =[ToolList changeNull:[dic objectForKey:@"salerName"]];
    if([countIndexFlag indexOfObject:[NSNumber numberWithLong:indexPath.row]] == NSNotFound)
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];
   
    }
    else
    {
        [cell.selectBtn setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
 
    }

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2) {//总监
       
        
        if (_gr_Btn.selected) {
             cell.labelother.text = [NSString stringWithFormat:@"%@ | %@",custSource,oldOrNew1];
        }
        if (_bm_btn.selected) {
             cell.labelother.text = [NSString stringWithFormat:@"%@ | %@ | %@",oldOrNew,custSource,oldOrNew1];
        }
        
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){//经理
        if (_gr_Btn.selected) {
             cell.labelother.text = [NSString stringWithFormat:@"%@ | %@ | %@ | %@天",custSource,salerName,createTime,exceedTime1];
        }
        if (_bm_btn.selected) {
             cell.labelother.text = [NSString stringWithFormat:@"%@ | %@",oldOrNew,custSource];
        }
        
       
    }

    cell.selectBtn.tag = indexPath.row;
    cell.czBlock = ^(NSDictionary * dicc)
    {
        //记录状态
        if([[dicc objectForKey:@"isSelect"] intValue])
        {
            if(countIndexFlag.count)
            {
            if([countIndexFlag indexOfObject:[dicc objectForKey:@"index"]] == NSNotFound)
            {
                [countIndexFlag addObject:[dicc objectForKey:@"index"]];
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
      
      
            if([[dicc objectForKey:@"isSelect"] intValue])
            {
                if([ shifangArr indexOfObject:dic] == NSNotFound)
                {
                    [shifangArr addObject:dic];
                }
            }
            else
            {
                if([ shifangArr indexOfObject:dic] != NSNotFound)
                {
                    [shifangArr removeObject:dic];
                }
            }
        if(countIndexFlag.count)
        {
            doView.hidden = NO;
        }
        else
        {
            doView.hidden = YES;
        }

    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [data objectAtIndex:indexPath.row];
    
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    s.oldOrNew = [dic objectForKey:@"oldOrNew"];
    [self.navigationController pushViewController:s animated:NO];
}

-(void)goAddView:(UIButton *)bt{
    
    [_popuV removeFromSuperview];
    _popuV = nil;
}
-(void)goAddView2:(UIButton *)bt{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in shifangArr) {
        [arr addObject:[dic objectForKey:@"custId"]];
    }
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        [FX_UrlRequestManager postByUrlStr:ZJReleaseCust_url andPramas:[NSMutableDictionary dictionaryWithObject:arr forKey:@"custIds"] andDelegate:self andSuccess:@"shifangSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        
        [FX_UrlRequestManager postByUrlStr:ReleaseCust_url andPramas:[NSMutableDictionary dictionaryWithObject:arr forKey:@"custIds"] andDelegate:self andSuccess:@"shifangSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
}
#pragma mark - 分配客户成功
-(void)intentCust:(NSDictionary *)dic{
    if([[dic objectForKey:@"code"] intValue] == 200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"分配成功"];
    
        [shifangArr removeAllObjects];
        [countIndexFlag removeAllObjects];
  
        startPage = 1;
        [self requestData];
    }
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
