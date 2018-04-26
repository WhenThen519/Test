//
//  TaskThanViewController.m
//  SaleManagement
//
//  Created by known on 16/6/14.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "TaskThanViewController.h"
#import "TaskThanTableViewCell.h"

@interface TaskThanViewController ()
{
    //筛选按钮
    UIButton *product_Select_Btn;
    BOOL isUpSelectView;
    UIView *selectContentView;

}
@end

@implementation TaskThanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isUpSelectView = NO;
    _tableArr = [[NSMutableArray alloc]init];
    _jieduanButtonArr =[[NSMutableArray alloc]init];

    _requestDic = [[NSMutableDictionary alloc]init];
    _requestDic[@"dataFilter"]=[NSNumber numberWithInteger:1];
    [FX_UrlRequestManager postByUrlStr:ZJWanChengBi_url andPramas:_requestDic andDelegate:self andSuccess:@"ZJWanChengBiSuccess:" andFaild:@"ZJWanChengBiNEIFild:" andIsNeedCookies:YES];
    


    // Do any additional setup after loading the view.
    [self addNavgationbar:@"任务完成比" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    product_Select_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    product_Select_Btn.frame = CGRectMake(__MainScreen_Width-55, IOS7_Height, 52, SelectViewHeight1);
    [product_Select_Btn setTitle:@"筛选" forState:UIControlStateNormal];
    product_Select_Btn.hidden = NO;
    product_Select_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [product_Select_Btn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    product_Select_Btn.backgroundColor = [UIColor clearColor];
    [product_Select_Btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [product_Select_Btn setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    [product_Select_Btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [self.view addSubview:product_Select_Btn];
    

    Select_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Select_Btn.frame = CGRectMake(12 , IOS7_Height+5, (__MainScreen_Width-63)/4, 30);
    [Select_Btn setTitle:@"本月" forState:UIControlStateNormal];
    Select_Btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [Select_Btn setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
    Select_Btn.layer.borderColor = [ToolList getColor:@"6052ba"].CGColor;
    Select_Btn.layer.cornerRadius = 4;
    Select_Btn.layer.masksToBounds = YES;
    Select_Btn.layer.borderWidth = 1;
    [self.view addSubview:Select_Btn ];

    
    selectContentView = [[UIView alloc] initWithFrame:CGRectMake(0,IOS7_Height+44-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44)];
    selectContentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:selectContentView];
    //阶段展示区域
    duanBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45)];
    duanBlackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:duanBlackView];
    UIView *duanView = [[UIView alloc] init];
    duanView.backgroundColor = [UIColor whiteColor];
    duanView.frame = CGRectMake(0, 0, __MainScreen_Width, 85);
    [duanBlackView addSubview:duanView];

    
    UILabel *zhuangtaiL = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 58, 14)];
    zhuangtaiL.text = @"日期";
    zhuangtaiL.font = [UIFont systemFontOfSize:14];
    zhuangtaiL.textColor = [ToolList getColor:@"666666"];
    [duanView addSubview:zhuangtaiL];
    
    NSArray *zhuangtaiA =@[@{@"1":@"本月"},@{@"2":@"上月"}];
    
    for (int i = 0; i < zhuangtaiA.count; i ++ ) {
        
        NSDictionary *dic = [zhuangtaiA objectAtIndex:i];
        
        FX_Button * btn2 = [[FX_Button alloc] initWithFrame:CGRectMake(12*(i+1)+i*((__MainScreen_Width-63)/2) , 36, (__MainScreen_Width-63)/2, 34) andType:@"1" andTitle:@"日期" andTarget:self andDic:dic];
        
        [duanView addSubview:btn2];
        
        if (i==0) {
            btn2.isSelect = YES;
            [btn2 changeType1Btn:YES];
        }
        
        [_jieduanButtonArr addObject:btn2];
    }
    
    

    //添加列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+44, __MainScreen_Width, __MainScreen_Height-44-IOS7_Height) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:table];

//    UINib * nib = [UINib nibWithNibName:@"TaskThanTableViewCell" bundle:nil];
//    [table registerNib:nib forCellReuseIdentifier:@"Cell"];
//    [self.view addSubview:table];
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [table setLayoutMargins:UIEdgeInsetsZero];
        
    }

}
#pragma mark -- ****条件筛选未点击完成前
-(void)btnBackDic:(NSDictionary *)dic

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
    
    [self selectBtnClicked:product_Select_Btn];
    
    [_requestDic removeAllObjects];
    _requestDic[@"dataFilter"]=[[dic1 allKeys] lastObject];
    
    [FX_UrlRequestManager postByUrlStr:ZJWanChengBi_url andPramas:_requestDic andDelegate:self andSuccess:@"ZJWanChengBiSuccess:" andFaild:@"ZJWanChengBiNEIFild:" andIsNeedCookies:YES];




}

-(void)ZJWanChengBiSuccess:(NSDictionary *)dic
{
    
    if ([[dic objectForKey:@"code"]intValue]==200) {
        
        _tableArr = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"result"]];
        
        if (_tableArr.count == 0 ) {
            
            [ToolList showRequestFaileMessageLittleTime:@"任务完成比无数据"];
            //            [_table removeFromSuperview];
            
        }
    }
    
    [table reloadData];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];//以indexPath来唯一确定cell
    TaskThanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        NSBundle *bundle = [NSBundle mainBundle];//加载cell的xib 文件
        NSArray *objs = [bundle loadNibNamed:@"TaskThanTableViewCell" owner:nil options:nil];
        cell = [objs lastObject];
        
    }
    NSDictionary *dataDic =_tableArr[indexPath.row];

       if ([[dataDic objectForKey:@"rank"] intValue]==1) {
            [cell.imageTItle setBackgroundImage:[UIImage imageNamed:@"金杯icon.png"] forState:UIControlStateNormal];
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==2) {
            [cell.imageTItle setBackgroundImage:[UIImage imageNamed:@"银杯icon.png"] forState:UIControlStateNormal];
            
            
        }
        else if ([[dataDic objectForKey:@"rank"] intValue]==3) {
            [cell.imageTItle setBackgroundImage:[UIImage imageNamed:@"铜杯icon.png"] forState:UIControlStateNormal];
            
            
        }

    
    
    else
    {
        NSString *str = [NSString stringWithFormat:@"%d",[[dataDic objectForKey:@"rank"] intValue]];
        [cell.imageTItle setTitle:str forState:UIControlStateNormal];
        cell.imageTItle.titleLabel.font =[UIFont fontWithName:@"Black Ops One" size:30];
        [cell.imageTItle setTitleColor:[ToolList getColor:@"FFBB2C"] forState:UIControlStateNormal];
    }

    cell.gongSiLabel.text =[ToolList changeNull:[dataDic objectForKey:@"subName"]];
    NSString *str2 = [NSString stringWithFormat:@"%.2f%%",[[ToolList changeNull:[dataDic objectForKey:@"finish"]] floatValue]*100];
    cell.biLiLabel.text =str2;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - 筛选点击
-(void)selectBtnClicked:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [UIView animateWithDuration:0.3 animations:^{
            duanBlackView.frame =CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
            
            [self.view bringSubviewToFront:duanBlackView];
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            duanBlackView.frame =CGRectMake(0, IOS7_Height+45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
        }];
    }
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
