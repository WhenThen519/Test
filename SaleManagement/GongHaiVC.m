//
//  GongHaiVC.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "GongHaiVC.h"
#import "CY_Tabel.h"
#import "Fx_TableView.h"
#import "GongHaiCell.h"

enum Devices{
    down_ShowType = 0,
    protect_ShowType ,
    collect_down_ShowType
};

@interface GongHaiVC (){
    
    enum Devices show_TYPE;
    UIScrollView *mainScroll ;
    UITextField *field;
    NSInteger tagNum;
}

@property (nonatomic,strong)NSMutableArray *dataArr;//表格里面的数据

@property (nonatomic, assign)NSInteger openIndex;//-1不显示操作，其他数字显示

@property (nonatomic,strong)Fx_TableView *seaTable;

@property (nonatomic,strong)CY_Tabel *searchTable;
@property (nonatomic,strong)NSMutableArray *searchData;
@property (nonatomic,strong)FX_Button *diquBtn;

@property (nonatomic,strong)FX_Button *tuijianBtn;

@property (nonatomic,strong)NSMutableArray *areaDrr;
@property (nonatomic,strong)NSMutableDictionary *requestDic;//所有选择请求参数
@property(nonatomic,assign)NSInteger startPage;//分页参数，为第几页

@property(nonatomic,strong)NSMutableArray *typeArr;//表格状态汇总

@end

@implementation GongHaiVC

-(void)RightAction:(UIButton *)sender
{
     
    _seaTable.frame = CGRectMake(__MainScreen_Width, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height);
    //     [_seaTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_dataArr removeAllObjects];
//    _seaTable.arr = _dataArr;
    [_seaTable reloadData];
    CGPoint position = CGPointMake(__MainScreen_Width, 0);
    
    [mainScroll setContentOffset:position animated:YES];
}

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)RightHome:(UIButton *)sender{
    
    [field resignFirstResponder];
     field.text = @"";
    
    _seaTable.frame = CGRectMake(0, IOS7_Height+selectView.frame.size.height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-selectView.frame.size.height);
    
    _requestDic[@"recommendFlag"]=[NSNumber numberWithInt:0];
    _requestDic[@"custName"]=@"";
    _requestDic[@"searchTagId"]=@"";
    
    _startPage = 1;
    
    [self requestAlldata];
    
    CGPoint position = CGPointMake(0, 0);
    
    [mainScroll setContentOffset:position animated:YES];
    
}

-(void)viewDidLayoutSubviews
{
    if ([self.seaTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.seaTable setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.seaTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.seaTable setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    tagNum = -1;
    _openIndex = -1;//非展开状态
    _typeArr=[[NSMutableArray alloc]init];
    _requestDic = [[NSMutableDictionary alloc]init];
    show_TYPE = 0;
    
    mainScroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    mainScroll.contentSize = CGSizeMake(__MainScreen_Width*2, __MainScreen_Height);
    mainScroll.scrollEnabled = NO;
    [self.view addSubview:mainScroll];
    
    handView *Hvc = [[handView alloc]initWithTitle:@"公海客户" andRightImage:@"btn_search_homepage" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
  
    
    _requestDic[@"recommendFlag"]=[NSNumber numberWithInt:0];
    _requestDic[@"custName"]=@"";
    _requestDic[@"searchTagId"]=@"";

    _startPage = 1;
    
    [self requestAlldata];

    [self makeView];
    [mainScroll addSubview:_seaTable];
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 42-0.8) toPoint:CGPointMake(__MainScreen_Width, 42-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    [selectTuijianView addSubview:selectTuijianContentView];
    [selectDiQuView addSubview:selectDiQuContentView];

    [mainScroll addSubview:selectDiQuView];
    [mainScroll addSubview:selectTuijianView];
    
    [selectView addSubview:_tuijianBtn];
    [mainScroll addSubview:selectView];
    
    [selectView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 8) toPoint:CGPointMake(__MainScreen_Width/2, 42-8) andWeight:0.1 andColorString:@"666666"]];
 
   
    [mainScroll addSubview:Hvc];
    
    handView *searchView = [[handView alloc]initWithFram:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, IOS7_Height) SearchandTarget:self];
      field = (UITextField *)[ searchView viewWithTag:1199];
    [mainScroll addSubview:searchView];
    

}

-(void)makeView{
   
    /*
     中间选择筛选条件
     */
    selectView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 42)];
    selectView.backgroundColor = [ToolList getColor:@"fafafa"];
    _diquBtn = [[FX_Button alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width/2, 42) andType:@"0" andTitle:@"地区" andTarget:self andDic:nil];
    [selectView addSubview:_diquBtn];
    
    _tuijianBtn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, 42) andType:@"0" andTitle:@"推荐" andTarget:self andDic:nil];
    selectDiQuView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+42-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height)];
    selectDiQuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    //筛选区域
    selectDiQuContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectDiQuContentView.backgroundColor = [UIColor whiteColor];
    
    selectTuijianView = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+42-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height)];
    selectTuijianView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
  
    selectTuijianContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width,90)];
    selectTuijianContentView.backgroundColor = [UIColor whiteColor];
    
    /*
     数据表格显示区域
     */
//    _seaTable = [[CY_Tabel alloc]initWithStyle:UITableViewStylePlain];
//    _seaTable.view.frame = CGRectMake(0, IOS7_Height+selectView.frame.size.height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-selectView.frame.size.height);
////     [_seaTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    _seaTable.view.backgroundColor = [UIColor whiteColor];
    
    //添加列表
    _seaTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+selectView.frame.size.height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-selectView.frame.size.height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _seaTable.dataSource = self;
    _seaTable.delegate = self;
    [_seaTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_seaTable.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_seaTable];
}

#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    _startPage = 1;
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    _startPage ++;
    [self requestAlldata];
    
}

//筛选按钮点击
-(void)btnBack:(FX_Button *)str
{
    
    if(str.frame.origin.x == 0)
    {
        if(str.isSelect)
        {
            [_tuijianBtn change:@"down"];
            [UIView animateWithDuration:0.3 animations:^{
                selectTuijianView.frame = CGRectMake(0, 42+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-42);
            }];
            NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
            reqDic[@"custType"]=[NSNumber numberWithInt:-1];
            
            [FX_UrlRequestManager postByUrlStr:seaAdd_url andPramas:reqDic andDelegate:self andSuccess:@"AddSuccess:" andFaild:@"AddFild:" andIsNeedCookies:YES];
            
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                selectDiQuView.frame = CGRectMake(0, 42+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-42);
            }];
        }
    }
    else if (str.frame.origin.x == __MainScreen_Width/2 )
    {
        if(str.isSelect)
        {
            for (UIView *subView in selectTuijianContentView.subviews) {
                [subView removeFromSuperview];
            }
            [_diquBtn change:@"down"];
            [UIView animateWithDuration:0.3 animations:^{
                selectDiQuView.frame = CGRectMake(0, 42+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-42);
            }];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, __MainScreen_Width, 45);
            
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
            btn.tag = 0;
            [btn addTarget:self action:@selector(shaixuanCommit:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            [selectTuijianContentView addSubview:btn];
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame = CGRectMake(0, 45, __MainScreen_Width, 45);
            
            [btn1 setTitle:@"领导推荐" forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn1 setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
            btn1.tag = 1;
            [btn1 addTarget:self action:@selector(shaixuanCommit:) forControlEvents:UIControlEventTouchUpInside];
            [btn1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            [selectTuijianContentView addSubview:btn1];
            
            
            [UIView animateWithDuration:0.3 animations:^{
                selectTuijianView.frame = CGRectMake(0, 44+IOS7_Height , __MainScreen_Width,__MainScreen_Height- IOS7_Height-44);
            }];
        }
        else
        {
            
            [UIView animateWithDuration:0.3 animations:^{
                selectTuijianView.frame = CGRectMake(0, 42+IOS7_Height -__MainScreen_Height, __MainScreen_Width,__MainScreen_Height- IOS7_Height-42);
            }];
        }
        
    }
}


-(void) requestAlldata
{
    _requestDic[@"custType"]=[NSNumber numberWithInt:-1];
    _requestDic[@"pagesize"]=[NSNumber numberWithInt:10];
    
    [_requestDic setObject:[NSString stringWithFormat:@"%ld",_startPage] forKey:@"pageNo"];
    [FX_UrlRequestManager postByUrlStr:sea_url andPramas:_requestDic andDelegate:self andSuccess:@"SeaSuccess:" andFaild:@"SeaFild:" andIsNeedCookies:YES];
}

#pragma mark--选择推荐

-(void)shaixuanCommit:(UIButton *)btn
{
    [_diquBtn change:@"down"];
    [_tuijianBtn change:@"down"];


    if (btn.tag == 0)
    {
         _requestDic[@"recommendFlag"]=[NSNumber numberWithInt:0];
         _requestDic[@"searchTagId"]=@"";
         _requestDic[@"custName"]=@"";
        [_tuijianBtn setTitle:@"全部"  forState:UIControlStateNormal];
    }
    else
    {

        _requestDic[@"recommendFlag"]=[NSNumber numberWithInt:1];
        
         [_tuijianBtn setTitle:@"领导推荐"  forState:UIControlStateNormal];
    }
    
    
    _startPage = 1;
    [self requestAlldata];
    
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+44-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - 44);
        selectTuijianView.frame = CGRectMake(0, IOS7_Height+44-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - 44);
    }];
}

#pragma 选择地区
-(void)diquCommit:(UIButton *)btn
{
    
    [_diquBtn change:@"down"];
    [_tuijianBtn change:@"down"];
    
    if (btn.tag == 0)
    {
        _requestDic[@"recommendFlag"]=[NSNumber numberWithInt:0];
        _requestDic[@"searchTagId"]=@"";
        _requestDic[@"custName"]=@"";
    }
    else
    {
        NSString *addressRegion = [NSString stringWithFormat:@"[{custAddressRegion:'%@'}]",[[_areaDrr objectAtIndex:btn.tag] objectForKey:@"optionKey"]];
        
        _requestDic[@"searchTagId"]=addressRegion;
        
    }
     [_diquBtn setTitle:[[_areaDrr objectAtIndex:btn.tag] objectForKey:@"optionValue"]  forState:UIControlStateNormal];
    
    _startPage = 1;
    
    [self requestAlldata];
    
    [UIView animateWithDuration:0.3 animations:^{
        selectDiQuView.frame = CGRectMake(0, IOS7_Height+44-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - 44);
        selectTuijianView.frame = CGRectMake(0, IOS7_Height+44-__MainScreen_Height, __MainScreen_Width,__MainScreen_Height - IOS7_Height - 44);
    }];
}

#pragma 地区数据
-(void)AddSuccess:(NSDictionary *)sucDic{
    
    
    for (UIView *subView in selectDiQuContentView.subviews) {
        [subView removeFromSuperview];
    }
  
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if ([[sucDic objectForKey:@"result"] count ]== 0) {
            
            
            return;
        }
        
       _areaDrr = [[NSMutableArray alloc] initWithArray:[[sucDic objectForKey:@"result"] objectForKey:@"areaClass"]];
        
        
        NSDictionary *dic =  @{@"optionKey":@"-1", @"optionValue":@"全部"};
        
        [_areaDrr insertObject:dic atIndex:0];
        
        selectDiQuContentView.contentSize = CGSizeMake(__MainScreen_Width, 45*_areaDrr.count);
        
        selectDiQuContentView.frame = CGRectMake(0, 0, __MainScreen_Width, 45*_areaDrr.count>__MainScreen_Height*0.68?__MainScreen_Height*0.68:_areaDrr.count);
        for (int i = 0 ; i < _areaDrr.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, i*45, __MainScreen_Width, 45);
            
            NSString *title = [[_areaDrr objectAtIndex:i] objectForKey:@"optionValue"];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 36, 0, 0)];
            btn.tag = i;
            [btn addTarget:self action:@selector(diquCommit:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 42.5) toPoint:CGPointMake(__MainScreen_Width, 42.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            [selectDiQuContentView addSubview:btn];
            
            
        }
        [UIView animateWithDuration:0.3 animations:^{
            selectDiQuView.frame = CGRectMake(0, IOS7_Height+42, __MainScreen_Width,__MainScreen_Height-42-IOS7_Height);

        }];

        
    }
    
    
}
#pragma 公海数据

-(void)SeaSuccess:(NSDictionary *)dic{
    
    [_seaTable.refreshHeader endRefreshing];
    [_seaTable.refreshFooter endRefreshing];
    
    
    
    if ([[dic objectForKey:@"code"]intValue]==200) {
        
        //刷新或无数据
        if ( _startPage == 1) {
            
            if ([[dic objectForKey:@"result"] count] == 0) {
                
                [ToolList showRequestFaileMessageLittleTime:@"筛选公海客户无数据"];
            }
            
            _dataArr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"result"]];
            
            if (_typeArr.count) {
                [_typeArr removeAllObjects];
            }
            for (id str in _dataArr) {
                
                [_typeArr addObject:[NSNumber numberWithInt:0]];
            }
            
        }else{
            
            if ([[dic objectForKey:@"result"] count] == 0) {
                
                
                [_seaTable reloadData];
                
                return;
            }
            [_dataArr addObjectsFromArray:[dic objectForKey:@"result"]];
            
            for (id str in _dataArr) {
                
                [_typeArr addObject:[NSNumber numberWithInt:0]];
            }
        }
        
      
    }

    [_seaTable reloadData];
  
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_openIndex == indexPath.row){
        
        return 122.0f;
        
    }else{
        
        return 85.0f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
     static NSString *CellIdentifier = @"GongHaiCell";
    
    GongHaiCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GongHaiCell" owner:self options:nil] lastObject];
        
        cell.bgView.hidden = YES;
    }
    
  
    cell.nameLabel.text =[[_dataArr objectAtIndex:indexPath.row]objectForKey:@"custName"];
    cell.addLabel.text =[[_dataArr objectAtIndex:indexPath.row]objectForKey:@"custAddress"];
    
    cell.bt1.tag = indexPath.row+111;
    cell.bt2.tag = indexPath.row+1112;
    
    cell.cellW.constant = __MainScreen_Width/2;
    
    //线
    [cell.bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.1 andColorString:@"999999"]];
    
     [cell.bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2.-1, 8) toPoint:CGPointMake(__MainScreen_Width/2.-1, cell.bt1.frame.size.height-8) andWeight:0.1 andColorString:@"999999"]];
    
    NSNumber *num = [_typeArr objectAtIndex:indexPath.row];
    [self showType:cell.iconImage andTag:[num integerValue]];
    if ([num intValue]==1 || [num intValue]==2) {
        
        cell.userInteractionEnabled = NO;
    }else{
        
        cell.userInteractionEnabled = YES;
    }
    
     NSNumber *hi = [[_dataArr objectAtIndex:indexPath.row]objectForKey:@"recommendFlag"];
    cell.tImage.hidden =![hi boolValue];
    
    if (_openIndex != -1 && _openIndex == indexPath.row) {
        
        cell.bgView.hidden = NO;
    }
    
    return cell;
    
}

-(void)timeEnough:(UIButton *)btn
{
    btn.selected = NO;
}

#pragma  mark--点击保护按钮
-(IBAction)protectT:(UIButton *)IDsender{
    
    if (IDsender.selected)
        return;
    IDsender.selected = YES;
    [self performSelector:@selector(timeEnough:) withObject:nil afterDelay:3.0];

        NSDictionary *dic = [_dataArr objectAtIndex:IDsender.tag-111];
        NSString *custID = [dic objectForKey:@"custId"];
        tagNum =IDsender.tag-111;
        [self requestandId:custID andType:@"2"];
    
    
    
   
}

#pragma mark - 点击收藏按钮
-(IBAction)collectT:(UIButton *)sender{
    if (sender.selected)
        return;
    sender.selected = YES;
    [self performSelector:@selector(timeEnough:) withObject:nil afterDelay:3.0];
  
    NSDictionary *dic = [_dataArr objectAtIndex:sender.tag-1112];
    NSString *custID = [dic objectForKey:@"custId"];
     tagNum =sender.tag-1112;
    [self requestandId:custID andType:@"1"];
    
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    GongHaiCell *cell = (GongHaiCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (_openIndex == indexPath.row ) {
        
        _openIndex = -1;
        
        if (show_TYPE==1) {//保护
         
        [_typeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
        cell.contentView.userInteractionEnabled = NO;
        cell.userInteractionEnabled = NO;
            
        }
        else if (show_TYPE==2){//收藏
            
             [_typeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:2]];
            cell.contentView.userInteractionEnabled = NO;
            cell.userInteractionEnabled = NO;
        }
        else{
             [_typeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
            cell.contentView.userInteractionEnabled = YES;
             cell.userInteractionEnabled = YES;
        }
        
        cell.bgView.hidden = YES;

        
    }else{
        
        show_TYPE=0;
        
        if (_openIndex!=-1) {
            
            [_typeArr replaceObjectAtIndex:_openIndex withObject:[NSNumber numberWithInt:0]];
            NSIndexPath *ppp = [NSIndexPath indexPathForRow:_openIndex inSection:0];
            UITableViewCell *oldcell = [tableView cellForRowAtIndexPath:ppp];
            
            UIView *oldve=(UIView *)[oldcell.contentView viewWithTag:110];
            
            oldve.hidden = YES;
        }
        
         [_typeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:3]];
        
        _openIndex = indexPath.row;
        
        cell.bgView.hidden = NO;
        
        }
 
     [_seaTable reloadData];
   
}

-(void)requestandId:(NSString *)custid andType:(NSString *)type{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"custId"]=custid;
    dic[@"custType"]=type;
    
    if ([type intValue]==1) {
       
        [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dic andDelegate:self andSuccess:@"getCustSuccess1:" andFaild:@"SeaFild:" andIsNeedCookies:YES];
    }
    else if ([type intValue]==2){
        
         [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dic andDelegate:self andSuccess:@"getCustSuccess2:" andFaild:@"SeaFild:" andIsNeedCookies:YES];
    }
    
   
}

-(void)getCustSuccess1:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue]==200) {
        
          show_TYPE = 2;
      
          [self tableView:_seaTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:tagNum inSection:0]];
     
    }
}

-(void)getCustSuccess2:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue]==200){
        
         show_TYPE = 1;
        [self tableView:_seaTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:tagNum inSection:0]];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)showType:(UIButton *)sender andTag:(NSInteger)tag{
    
    switch (tag) {
        case 0:
        {
            [sender setImage:[UIImage imageNamed:@"btn_list_down.png"] forState:UIControlStateNormal];
        }
            break;

        case 1:
        {
            [sender setImage:[UIImage imageNamed:@"icon_list_protect_s.png"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [sender setImage:[UIImage imageNamed:@"icon_list_collect_s.png"] forState:UIControlStateNormal];
        }
            break;
         
        case 3:
        {
            [sender setImage:[UIImage imageNamed:@"btn_list_up.png"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    

}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    
    [theTextField resignFirstResponder];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    dataDic[@"custType"]=[NSNumber numberWithInt:-1];
    dataDic[@"pagesize"]=[NSNumber numberWithInt:10];
    dataDic[@"pageNo"]= [NSNumber numberWithInt:1];
    dataDic[@"custName"]= theTextField.text;
    dataDic[@"recommendFlag"]=[NSNumber numberWithInt:0];
    dataDic[@"searchTagId"]=@"";
    
    [FX_UrlRequestManager postByUrlStr:sea_url andPramas:dataDic andDelegate:self andSuccess:@"SeaSuccess:" andFaild:@"SeaFild:" andIsNeedCookies:YES];
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
