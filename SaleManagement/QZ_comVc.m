//
//  CY_comVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/6/14.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "QZ_comVc.h"
#import "ComTableViewCell.h"
#import "DepTableViewCell.h"

#define CYHANDVIEW_H 44

@interface QZ_comVc (){
    UIButton * SWSelect_Btn;
    NSArray *buMenArr;
    UIScrollView *selectContentScrollView;
    UIButton *addLink;
    NSMutableArray *selectArr;
    UIView *duanBlackView;
    FX_Button *renBtn;//个人排行
    FX_Button *comBtn;//部门排行
    FX_Button * dayButton;
    UIView *duanView;
    NSMutableArray *bumenBtnArr;

    
}
@property (nonatomic,strong)UITableView *DepTable;
@property (nonatomic,strong)UITableView *myClientTable;
@property (nonatomic,strong)NSMutableDictionary *requestDic;
@property (nonatomic,strong)NSMutableArray *tableArr;
@property (nonatomic,strong)NSMutableArray *jieduanButtonArr;
@end

@implementation QZ_comVc

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    
    _requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];
    
    _requestDic[@"subId"]=@"";
    [FX_UrlRequestManager postByUrlStr:PersonalSubRankSaler_url andPramas:_requestDic andDelegate:self andSuccess:@"CountryPersonalSuccess:" andFaild:@"CountryPersonalFild:" andIsNeedCookies:YES];
}

#pragma mark - 获得所有部门成功
-(void)getDeptSuccess:(NSDictionary *)dic
{
    buMenArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
    for (int i =0 ; i<buMenArr.count; i++)
    {
        NSString *dic1 =buMenArr[i][@"subName"];
        if ([dic1 isEqualToString:SWSelect_Btn.titleLabel.text])
        {
            _requestDic[@"subId"] =buMenArr[i][@"subId"];
            
            
        }
        
    }
    
    //    bumenId = buMenArr[0][@"deptId"];
    
   
    
}
-(void)createSelectView
{
    for (UIView *view in duanView.subviews) {
        [view removeFromSuperview];
    }
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 85, __MainScreen_Width, 1)];
    line1.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [duanView addSubview:line1];
    
    float buMen_h = 35+(buMenArr.count+2)/3*45;
    float main_h = buMen_h+35;
    float btn_w = (__MainScreen_Width-48)/3.;
    
    if(main_h<__MainScreen_Height-IOS7_Height-SelectViewHeight-SelectViewHeight1)
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, main_h);
    }
    else
    {
//        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, selectContentView.bounds.size.height);
//        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
    }
    //阶段展示区域
    duanView = [[UIView alloc] init];
    duanView.backgroundColor = [UIColor whiteColor];
    duanView.frame = CGRectMake(0, 0, __MainScreen_Width, 85);
    [duanBlackView addSubview:duanView];
    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 58, 14)];
    zhuangtaiL.text = @"日期";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [duanView addSubview:zhuangtaiL];
    
    NSArray *zhuangtaiA =@[@{@"1":@"今日"},@{@"2":@"昨日"},@{@"3":@"本月"},@{@"4":@"上月"}];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i+1)+i*((__MainScreen_Width-63)/4) , 36, (__MainScreen_Width-63)/4, 34) andType:@"1" andTitle:@"日期" andTarget:self andDic:dic];
        
        [duanView addSubview:btn2];
        
        if (i+1==[[_requestDic objectForKey:@"dataFilter"] intValue]) {
            btn2.isSelect = YES;
            [btn2 changeType1Btn:YES];
        }
        
        [_jieduanButtonArr addObject:btn2];
    }
    //部门
    UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, __MainScreen_Width-20, 35)];
    b_l.font = [UIFont systemFontOfSize:14];
    b_l.textColor = [ToolList getColor:@"666666"];
    b_l.text = @"分司";
    [duanView addSubview:b_l];
    NSDictionary *dic = buMenArr[1];
    
    for (int i = 0 ; i < buMenArr.count; i ++) {
        NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
        [dicTemp setObject:[[buMenArr objectAtIndex:i] objectForKey:@"subName"] forKey:[[buMenArr objectAtIndex:i] objectForKey:@"subId"]];
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 85+35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"分司" andTarget:self andDic:dicTemp];
        [duanView addSubview:btn];
        
        [bumenBtnArr addObject:btn];
        //        if (i==0) {
        //
        //        }
        NSString *dic1 =buMenArr[i][@"subName"];
        if ([dic1 isEqualToString:SWSelect_Btn.titleLabel.text])
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
    [duanView addSubview:btnCommit];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 85+buMen_h, __MainScreen_Width, 1)];
    line2.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [duanView addSubview:line2];
    duanView.frame = CGRectMake(0, 0, __MainScreen_Width, 85+buMen_h+35);
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [FX_UrlRequestManager postByUrlStr:SubByAreaId_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
    bumenBtnArr = [[NSMutableArray alloc]init];
    _requestDic = [[NSMutableDictionary alloc]init];
   
   _jieduanButtonArr =[[NSMutableArray alloc]init];
    
    [self makeView];
}


-(void)makeView{
    
    selectArr = [[NSMutableArray alloc]init];
    NSArray *typeA = @[@"个人排名",@"部门排名"];

    duanBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+CYHANDVIEW_H+45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45)];
    duanBlackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:duanBlackView];
    
    [self addNavgationbar:@"分司内排行榜" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    //头部点击操作区域-- 个人排名--部门内排名
    UIImageView *handV = [[UIImageView alloc]initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, CYHANDVIEW_H)];
    handV.userInteractionEnabled = YES;
    handV.image = [UIImage imageNamed:@"bg_filter.png"];
    [self.view addSubview:handV];
    
    renBtn = [[FX_Button alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width/2, SelectViewHeight+2-0.8) andType:@"4" andTitle:[typeA objectAtIndex:0] andTarget:self andDic:nil];
    renBtn.tag = 0;
    renBtn.isSelect = YES;
    [renBtn changeBigAndColorCliked:renBtn];
    [handV addSubview:renBtn];
    
    comBtn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, SelectViewHeight+2-0.8) andType:@"4" andTitle:[typeA objectAtIndex:1] andTarget:self andDic:nil];
    comBtn.tag = 1;
    [handV addSubview:comBtn];
    
    
    UIView *sxView= [[UIView alloc]initWithFrame:CGRectMake(0, CYHANDVIEW_H+IOS7_Height, __MainScreen_Width,44)];
    sxView.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:sxView];
    
    
    addLink = [UIButton buttonWithType:UIButtonTypeCustom];
    addLink.frame = CGRectMake(__MainScreen_Width-52-13, 5, 52, 34);
    addLink.backgroundColor = [UIColor clearColor];
    [addLink setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [addLink setTitle:@"筛选" forState:UIControlStateNormal];
    [addLink addTarget:self action:@selector(pSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addLink setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    addLink.titleLabel.font = [UIFont systemFontOfSize:12];
    [sxView addSubview:addLink];
    
     dayButton = [[FX_Button alloc] initWithFrame:CGRectMake(12 , 5, (__MainScreen_Width-63)/4, 34) andType:@"1" andTitle:@"日期" andTarget:nil andDic:@{@"1":@"今日"}];
//    [dayButton setTitle:@"今日" forState:UIControlStateNormal];
//    dayButton.isSelect = YES;
    [dayButton changeType1Btn:YES];
     [sxView addSubview:dayButton];
    
   
    
   
    
    _myClientTable = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+CYHANDVIEW_H+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45) style:UITableViewStylePlain];
    _myClientTable.dataSource = self;
    _myClientTable.delegate = self;
    [_myClientTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_myClientTable];
    //增加的内容
    SWSelect_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    SWSelect_Btn.frame = CGRectMake(12+(__MainScreen_Width-63)/4+10 ,5, (__MainScreen_Width-48)/3., 34);
    [SWSelect_Btn setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
    SWSelect_Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    SWSelect_Btn.layer.borderColor = [ToolList getColor:@"6052ba"].CGColor;
    SWSelect_Btn.layer.cornerRadius = 4;
    SWSelect_Btn.layer.masksToBounds = YES;
    SWSelect_Btn.layer.borderWidth = 1;
    
    [sxView addSubview:SWSelect_Btn ];
   
}
#pragma mark - 完成筛选
-(void)commit:(UIButton *)btn
{
    if (addLink.selected == YES) {
        
        [self pSelectBtnClicked:addLink];
    }    //个人
    if (renBtn.isSelect == YES) {
            [FX_UrlRequestManager postByUrlStr:PersonalSubRankSaler_url andPramas:_requestDic andDelegate:self andSuccess:@"CountryPersonalSuccess:" andFaild:@"CountryPersonalFild:" andIsNeedCookies:YES];
    }
    else
    {
            [FX_UrlRequestManager postByUrlStr:DeptSubRank_url andPramas:_requestDic andDelegate:self andSuccess:@"CountryDeptSuccess:" andFaild:@"CountryPersonalFild:" andIsNeedCookies:YES];
    }
    
    
    

}

#pragma mark -- ****条件筛选未点击完成前
-(void)btnBackDic:(NSDictionary *)dic

{
   
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
        NSString *str = [dic objectForKey:@"tag"];
    
        if([str isEqualToString:@"日期"])
        {
            for (FX_Button *btnS in _jieduanButtonArr)
            {
                
                if (btnS == btn)
                {
                    btn.selected = YES;
                    [btnS changeType1Btn:YES];
                    [dayButton setTitle:[NSString stringWithFormat:@"%@",[[dic1 allValues]lastObject]] forState:UIControlStateNormal];
                    _requestDic[@"dataFilter"]=[[dic1 allKeys] lastObject];
                    
                }else
                {
                    btn.selected = NO;
                    [btnS changeType1Btn:NO];
                }
                
            }
            

        }
        //分司
        else
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
                [SWSelect_Btn setTitle:[[dic1 allValues]lastObject] forState:UIControlStateNormal];
                _requestDic[@"subId"]=[[dic1 allKeys] lastObject];
                
            }
            else
            {
                _requestDic[@"subId"]=@"";
            }

         
        }

   

}

#pragma mark ---- 个人排名、分司排名
-(void)changeBigAndColorClikedBack:(FX_Button *)sender{

    
    if (addLink.selected == YES) {
        
        [self pSelectBtnClicked:addLink];
    }
    
    sender.isSelect = YES;
    [sender changeBigAndColorCliked:sender];
//    _requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];
//    _requestDic[@"subId"]=@"";
//    [dayButton setTitle:@"今日" forState:UIControlStateNormal];
    if (sender.tag ==0) {//个人排名
            
        comBtn.isSelect = NO;
        [comBtn changeBigAndColorCliked:comBtn];
        
      
        [FX_UrlRequestManager postByUrlStr:PersonalSubRankSaler_url andPramas:_requestDic andDelegate:self andSuccess:@"CountryPersonalSuccess:" andFaild:@"CountryPersonalFild:" andIsNeedCookies:YES];
       
    }else{//部门内排名
        

        renBtn.isSelect = NO;
        [renBtn changeBigAndColorCliked:renBtn];
        
        
//         [_requestDic removeAllObjects];
//         _requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];
//        _requestDic[@"type"]=[NSNumber numberWithInteger:3];
        
        [FX_UrlRequestManager postByUrlStr:DeptSubRank_url andPramas:_requestDic andDelegate:self andSuccess:@"CountryDeptSuccess:" andFaild:@"CountryPersonalFild:" andIsNeedCookies:YES];

    }
   
}

#pragma mark ---- 筛选
-(void)pSelectBtnClicked:(UIButton *)sender{
    
    sender.selected = !sender.selected;
        
        if (sender.selected) {
            
            [UIView animateWithDuration:0.3 animations:^{
                duanBlackView.frame =CGRectMake(0, IOS7_Height+CYHANDVIEW_H+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45);
                [self createSelectView];

                [self.view bringSubviewToFront:duanBlackView];
            }];
        }else{
            
            [UIView animateWithDuration:0.3 animations:^{
                duanBlackView.frame =CGRectMake(0, IOS7_Height+CYHANDVIEW_H+45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45);
            }];
        }
        
    
}

-(void)CountryPersonalSuccess:(NSDictionary *)dic{
    
    [_tableArr removeAllObjects];
    [SWSelect_Btn setTitle:[dic objectForKey:@"subName"] forState:UIControlStateNormal];

    if ([[dic objectForKey:@"code"]intValue]==200) {

         _tableArr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"result"]];
       
        if (_tableArr.count == 0 ) {
            
           [ToolList showRequestFaileMessageLittleTime:@"分司个人排名无数据"];
        }
    }
     if (_myClientTable == nil) {
    //添加列表
    _myClientTable = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+CYHANDVIEW_H+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45) style:UITableViewStylePlain];
    _myClientTable.dataSource = self;
    _myClientTable.delegate = self;
    [_myClientTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_myClientTable];
         
     }else{
         
         [self.view bringSubviewToFront:_myClientTable];
     }
    
    [_myClientTable reloadData];
}

-(void)CountryDeptSuccess:(NSDictionary *)sucDic{
    
     [_tableArr removeAllObjects];
   [SWSelect_Btn setTitle:[sucDic objectForKey:@"subName"] forState:UIControlStateNormal];
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
         _tableArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
        
        if (_tableArr.count == 0 ) {
            
            [ToolList showRequestFaileMessageLittleTime:@"分司部门内排名无数据"];
        }
    }
    
    if (_DepTable == nil) {
        
        //添加列表
        _DepTable = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+CYHANDVIEW_H+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-CYHANDVIEW_H-45) style:UITableViewStylePlain];
        _DepTable.dataSource = self;
        _DepTable.delegate = self;
        [_DepTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_DepTable];
        
    }else{
        
         [self.view bringSubviewToFront:_DepTable];
    }
    [_DepTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_tableArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_DepTable == tableView) {
        
        return 60.0f;
    }
        
   
    return 76.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (_myClientTable == tableView) {
    
    static NSString *CellIdentifier = @"ComTableViewCell";
    ComTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ComTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 75.5) toPoint:CGPointMake(__MainScreen_Width, 75.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    
    NSDictionary *dataDic = [_tableArr objectAtIndex:indexPath.row];
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
        cell.numL.text = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"rank"] intValue]];
    }
    
    return cell;
   }
   else{
       
       static NSString *CellIdentifier = @"DepTableViewCell";
       DepTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
       if(cell1==nil)
       {
           cell1 = [[[NSBundle mainBundle] loadNibNamed:@"DepTableViewCell" owner:self options:nil] lastObject];
           //线
           [cell1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 59.5) toPoint:CGPointMake(__MainScreen_Width, 59.5) andWeight:0.5 andColorString:@"e7e7eb"]];
           
       }
       
       NSDictionary *dataDic = [_tableArr objectAtIndex:indexPath.row];
       cell1.nameL.text = [ToolList changeNull:[dataDic objectForKey:@"deptName"]];
       cell1.moneyL.text=[NSString stringWithFormat:@"%@",[ToolList changeNull:[dataDic objectForKey:@"finish"]]];
       
       if ([[dataDic objectForKey:@"rank"] intValue]==1) {
           cell1.numL.hidden = YES;
           cell1.imageV.hidden = NO;
           cell1.imageV.image = [UIImage imageNamed:@"金杯icon.png"];
       }
       else if ([[dataDic objectForKey:@"rank"] intValue]==2) {
           cell1.numL.hidden = YES;
           cell1.imageV.hidden = NO;
           cell1.imageV.image = [UIImage imageNamed:@"银杯icon.png"];
       }
       else if ([[dataDic objectForKey:@"rank"] intValue]==3) {
           cell1.numL.hidden = YES;
           cell1.imageV.hidden = NO;
           cell1.imageV.image = [UIImage imageNamed:@"铜杯icon.png"];
       }else{
           cell1.numL.hidden = NO;
           cell1.imageV.hidden = YES;
           UIFont *font = [UIFont fontWithName:@"Black Ops One" size:30];
           cell1.numL.font = font;
           cell1.numL.text = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"rank"] intValue]];
       }
       
       return cell1;
   }
    return 0;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
