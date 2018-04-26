//
//  QZ_MXView.m
//  SaleManagement
//
//  Created by chaiyuan on 16/7/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "QZ_MXView.h"
#import "QZTableViewCell.h"
#import "JL_newJingxianjinTableViewCell.h"

#define CYHANDVIEW_H 44
#define CELLVIEW_H 62

@implementation QZ_MXView{
    
    UIButton *qz_AddLink;//筛选按钮
    FX_Button *SButton;//筛选条件显示按钮
    NSMutableArray *selectArr;
    UIView *blackView;//筛选弹出框
    NSArray *childArr;
    NSInteger selectIndex;
    UILabel *moneyL;//共计多少资金
}


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
       
        [self makeView];
        
        if (_myRootArr == nil) {
          
            _QZrequestDic[@"dataFilter"]=[NSNumber numberWithInt:1];
            
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){//区总
            
            [FX_UrlRequestManager postByUrlStr:QZgetAreaYeJi_url andPramas:_QZrequestDic andDelegate:self andSuccess:@"QZgetAreaYeJiSuccess:" andFaild:@"QZgetAreaYeJiFild:" andIsNeedCookies:YES];
        }
        else  if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
                
            [FX_UrlRequestManager postByUrlStr:SubYeji_url andPramas:_QZrequestDic andDelegate:self andSuccess:@"QZgetAreaYeJiSuccess:" andFaild:@"QZgetAreaYeJiFild:" andIsNeedCookies:YES];
        }
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)//经理
            {
                
                [FX_UrlRequestManager postByUrlStr:DeptYeji_url andPramas:_QZrequestDic andDelegate:self andSuccess:@"QZgetAreaYeJiSuccess:" andFaild:@"QZgetAreaYeJiFild:" andIsNeedCookies:YES];

            }
        }

    }
    return self;
}



-(void)makeView{
    
    _QZrequestDic = [[NSMutableDictionary alloc]init];
    _selectBtArr = [[NSMutableArray alloc]init];
    childArr =[[NSArray alloc]init];
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+CYHANDVIEW_H+43-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45)];
    
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addSubview:blackView];

    UIView *sxView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width,44)];
    sxView.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [self addSubview:sxView];
        
    qz_AddLink = [UIButton buttonWithType:UIButtonTypeCustom];
    qz_AddLink.frame = CGRectMake(__MainScreen_Width-52-13, 3, 52, 35);
    qz_AddLink.backgroundColor = [UIColor clearColor];
    [qz_AddLink setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [qz_AddLink setTitle:@"筛选" forState:UIControlStateNormal];
    [qz_AddLink addTarget:self action:@selector(qz_pSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qz_AddLink setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    qz_AddLink.titleLabel.font = [UIFont systemFontOfSize:12];
    [sxView addSubview:qz_AddLink];
    
    //筛选条件显示
    SButton = [[FX_Button alloc] initWithFrame:CGRectMake(12 , 5,  (__MainScreen_Width-63)/4, 34) andType:@"1" andTitle:@"日期" andTarget:nil andDic:@{@"1":@"今日"}];
    [SButton changeType1Btn:YES];
    [sxView addSubview:SButton];
    
    //筛选条件显示
    moneyL = [[UILabel alloc] initWithFrame:CGRectMake(SButton.frame.origin.x+SButton.frame.size.width+10 , 5,173, 34)];
    moneyL.textColor = [ToolList getColor:@"666666"];
    moneyL.backgroundColor = [UIColor clearColor];
    moneyL.font = [UIFont systemFontOfSize:13];
    [sxView addSubview:moneyL];
    
    //阶段展示区域
    UIView *duanView = [[UIView alloc] init];
    duanView.backgroundColor = [UIColor whiteColor];
    duanView.frame = CGRectMake(0, 0, __MainScreen_Width, 85);
    [blackView addSubview:duanView];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 58, 14)];
    zhuangtaiL.text = @"日期";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [duanView addSubview:zhuangtaiL];
    
    NSArray *zhuangtaiA =@[@{@"1":@"今日"},@{@"2":@"昨日"},@{@"3":@"本月"},@{@"4":@"上月"}];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i+1)+i*((__MainScreen_Width-63)/zhuangtaiA.count) , 36, (__MainScreen_Width-63)/zhuangtaiA.count, 34) andType:@"1" andTitle:@"日期" andTarget:self andDic:dic];
        
        [duanView addSubview:btn2];
        
        if (i==0) {
            btn2.isSelect = YES;
            [btn2 changeType1Btn:YES];
        }
        
        [_selectBtArr addObject:btn2];
    }
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)

    {

    _myRootTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45) style:UITableViewStylePlain];
    _myRootTabel.dataSource = self;
    _myRootTabel.delegate = self;
    [_myRootTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_myRootTabel];
    }
   else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
   {
    _myJLRootTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45) style:UITableViewStylePlain];
       
    _myJLRootTabel.dataSource = self;
    _myJLRootTabel.delegate = self;
    [_myJLRootTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_myJLRootTabel];
   }
    
}

#pragma mark -- 点击筛选按钮
-(void)qz_pSelectBtnClicked:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            blackView.frame =CGRectMake(0, 45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45);
            
            [self bringSubviewToFront:blackView];
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            blackView.frame =CGRectMake(0, IOS7_Height+CYHANDVIEW_H+43-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45);
        }];
    }
    
    
}

#pragma mark -- ****条件筛选未点击完成前
-(void)btnBackDic:(NSDictionary *)dic

{
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    //    NSString *str = [dic objectForKey:@"tag"];
    
    
    for (FX_Button *btnS in _selectBtArr) {
        
        if (btnS == btn) {
            btn.selected = YES;
            [btnS changeType1Btn:YES];
            
        }else{
            btn.selected = NO;
            [btnS changeType1Btn:NO];
        }
        
    }
    [SButton setTitle:[NSString stringWithFormat:@"%@",[[dic1 allValues]lastObject]] forState:UIControlStateNormal];
    
    [self qz_pSelectBtnClicked:qz_AddLink];
    
          
    _QZrequestDic[@"dataFilter"]=[[dic1 allKeys] lastObject];
   
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
        
        [FX_UrlRequestManager postByUrlStr:QZgetAreaYeJi_url andPramas:_QZrequestDic andDelegate:self andSuccess:@"QZgetAreaYeJiSuccess:" andFaild:@"QZgetAreaYeJiFild:" andIsNeedCookies:YES];
    
   else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
       
    [FX_UrlRequestManager postByUrlStr:SubYeji_url andPramas:_QZrequestDic andDelegate:self andSuccess:@"QZgetAreaYeJiSuccess:" andFaild:@"QZgetAreaYeJiFild:" andIsNeedCookies:YES];
   else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)//经理
   {
       
       [FX_UrlRequestManager postByUrlStr:DeptYeji_url andPramas:_QZrequestDic andDelegate:self andSuccess:@"QZgetAreaYeJiSuccess:" andFaild:@"QZgetAreaYeJiFild:" andIsNeedCookies:YES];
       
   }
}

-(void)QZgetAreaYeJiSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        moneyL.text = [NSString stringWithFormat:@"共 %@元(%@条)",[sucDic objectForKey:@"totalAccount"],[sucDic objectForKey:@"total"]];
        
        _myRootArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
        
        _boolArr = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in _myRootArr) {
            
            [_boolArr addObject:[NSNumber numberWithBool:NO]];
        }
        
        if (_myRootArr.count == 0 ) {
            
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据！"];
        }
        
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)

        {
        [_myJLRootTabel reloadData];
        }
        else
        {
            [_myRootTabel reloadData];
   
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _myRootTabel)
    {
    return [_myRootArr count];
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _myRootTabel)
    {
    NSNumber *nub=[_boolArr objectAtIndex:section];
    
    //判断是收缩还是展开
    
    if ([nub intValue])
    {
        NSDictionary *dic=[_myRootArr objectAtIndex:section];
        NSArray *array;
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
            array=[dic objectForKey:@"deptList"];
        }
        else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
            array=[dic objectForKey:@"salerList"];
        }
        return array.count;
        
    }else
        
    {
        
        return 0;
        
    }
    }
    else
    {
     return [_myRootArr count];
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _myRootTabel)
    {
    return 44.0f;
    }
    else
    {
        return 62;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _myRootTabel)
    {
    static NSString *CellIdentifier = @"QZTableViewCell";
    QZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QZTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 43.5) toPoint:CGPointMake(__MainScreen_Width, 43.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    
    NSDictionary *childDic = [childArr objectAtIndex:indexPath.row];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
        cell.comL.text = [ToolList changeNull:[childDic objectForKey:@"deptName"]];
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        
        cell.comL.text = [ToolList changeNull:[childDic objectForKey:@"salerName"]];
    }
    
    cell.moneyL.text=[NSString stringWithFormat:@"%@",[ToolList changeNull:[childDic objectForKey:@"finish"]]];
    
    return cell;
    }
    else
    {
    
    
        static NSString *CellIdentifier = @"JL_newJingxianjinTableViewCell";
        JL_newJingxianjinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JL_newJingxianjinTableViewCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 61.5) toPoint:CGPointMake(__MainScreen_Width, 61.5) andWeight:0.5 andColorString:@"e7e7eb"]];
            
        }
        
        NSDictionary *childDic = [_myRootArr objectAtIndex:indexPath.row];
        cell.name_L.text = [childDic objectForKey:@"salerName"];
        cell.money_L.text = [childDic objectForKey:@"finish"];
        return cell;
    }
    
    
    return nil;
}

//设置分组头的视图

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    if(tableView == _myRootTabel)
    {
    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, __MainScreen_Width, CELLVIEW_H)];
    
    hView.backgroundColor=[UIColor whiteColor];
    
    UIButton* eButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    eButton.titleLabel.font = [UIFont systemFontOfSize:16];
    eButton.titleLabel.textColor = [ToolList getColor:@"4A4A4A"];
    //按钮填充整个视图
    eButton.frame = hView.frame;
    
    [eButton addTarget:self action:@selector(expandButtonClicked:)
     
      forControlEvents:UIControlEventTouchUpInside];
    
    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
    
    eButton.tag = section;
    
    //设置图标
    
    //根据是否展开，切换按钮显示图片
    
    if ([self isExpanded:section])
        
        [eButton setImage: [ UIImage imageNamed: @"btn_list_down" ]forState:UIControlStateNormal];
    
    else
        
        [eButton setImage: [ UIImage imageNamed: @"btn_list_up" ]forState:UIControlStateNormal];
    
    //设置分组标题
    
    NSDictionary *dicc =[_myRootArr objectAtIndex:section];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
          [eButton setTitle:[dicc objectForKey:@"orgName"]forState:UIControlStateNormal];
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        
          [eButton setTitle:[dicc objectForKey:@"deptName"]forState:UIControlStateNormal];
    }
  
    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //设置button的图片和标题的相对位置
    
    //4个参数是到上边界，左边界，下边界，右边界的距离
    
    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    
    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,5, 0,0)];
    
    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,__MainScreen_Width-20, 0,0)];
    
    
    //线
    [eButton.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, CELLVIEW_H-0.5) toPoint:CGPointMake(__MainScreen_Width, CELLVIEW_H-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    //金钱
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(hView.frame.size.width-158,23, 128,22)];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    label.backgroundColor=[UIColor clearColor];
    label.textColor = [ToolList getColor:@"FF3333"];
    label.text =[dicc objectForKey:@"finish"];
    [hView addSubview:label];
    
    
    [hView addSubview: eButton];
    
    return hView;
    }
    
    return nil;
}

#pragma mark --- 点击分司按钮
-(void)expandButtonClicked:(UIButton *)sender{
    
    NSInteger section= sender.tag;//取得tag知道点击对应哪个块
    
    [self collapseOrExpand:section];
    
    selectIndex = section;
    
    NSDictionary *dataDic = [_myRootArr objectAtIndex:section];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
           childArr = [dataDic objectForKey:@"deptList"];
    }
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        
        childArr = [dataDic objectForKey:@"salerList"];
    }

    
    //刷新tableview
    
    [_myRootTabel reloadData];
}

//对指定的节进行“展开/折叠”操作,若原来是折叠的则展开，若原来是展开的则折叠

-(void)collapseOrExpand:(NSInteger)section{
    
    int expanded=[[_boolArr objectAtIndex:section] intValue];
    
    if (selectIndex != section) {//再次点击展开项
        [_boolArr replaceObjectAtIndex:selectIndex withObject:[NSNumber numberWithInt:0]];
        
    }
    
    if (expanded) {
        
        [_boolArr replaceObjectAtIndex:section withObject:[NSNumber numberWithInt:0]];
    }else
        
    {
        [_boolArr replaceObjectAtIndex:section withObject:[NSNumber numberWithInt:1]];
        
    }
}

//返回指定节是否是展开的

-(int)isExpanded:(NSInteger)section{
    
    NSNumber *nub=[_boolArr objectAtIndex:section];
    
    int expanded=[nub intValue];
    
    return expanded;
    
}

//控制表头分组表头高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    if(tableView == _myRootTabel)
    {
        return CELLVIEW_H;
  
    }
    return 0;
}

@end
