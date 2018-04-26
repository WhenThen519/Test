//
//  YixiangViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "UserDetailViewController.h"
#import "YixiangViewController.h"
#import "Fx_TableView.h"
#import "YixiangTableViewCell.h"
#import "YixiangDetailViewController.h"
#import "peiYuKuViewController.h"
#import "YIxiangSelectDateController.h"
#import "AlertWhyViewController.h"
#import "FenPeiSelectTools.h"
@interface YixiangViewController ()
{
    
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
    //请求传参
    NSMutableDictionary *requestDic;
    //开始数据标识
    int startPage;
    int selectIndex;
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
 
    BOOL flagNeedReload;
//意向单号
    NSString *orderId;
    
    UILabel *label;
    UIButton *button;
    UIView *selectContentView;
    UIScrollView *selectContentScrollView;
    UIView *duanBlackView;
    UILabel *bm_l;
    UIView *line2;
    UIView *swView;
    UIView *operateView2;
}
@property (nonatomic,strong)NSMutableArray *buMenArr;//部门旗下的商务

@property (nonatomic,strong)NSMutableArray *bumenBtnArr;
@property (nonatomic,strong)NSMutableArray *swBtnArr;

@property (nonatomic,strong)NSString *my_salerId;
@property (nonatomic,strong)NSString *my_deptId;
@end

@implementation YixiangViewController

#define mark - 筛选
-(void)changeBtnAction:(UIButton *)bt{
    YIxiangSelectDateController *s = [[YIxiangSelectDateController alloc] init];
    s.czDicBlock = ^(NSDictionary *strDate) {
        NSLog(@"%@", strDate);
        requestDic[@"createTime"]=[strDate objectForKey:@"createTime"];
        requestDic[@"sjCustMark"]=[strDate objectForKey:@"sjCustMark"];
        [self requestAlldata];
    };
    [self.navigationController pushViewController:s animated:NO];
//    return;
//    bt.selected = !bt.selected;
//    
//    if (bt.selected) {
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            selectContentView.frame =CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
//            
//            [self.view bringSubviewToFront:selectContentView];
//        }];
//    }else{
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            selectContentView.frame =CGRectMake(0,  -IOS7_Height-45-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45);
//        }];
//    }
 
}
-(void)bb
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)back_back
{
    [self.navigationController popViewControllerAnimated:NO];
    [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"sjCustMark"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"strDate"];
}
#pragma mark - 页面初始化
-(void)initView
{

//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bb) name:@"FANGQIOK" object:nil];
    //数据初始化
    _my_deptId=_my_salerId = @"";
    startPage = 1;
    dataArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    dataArr = [[NSMutableArray alloc] init];
    _bumenBtnArr =[[NSMutableArray alloc]init];
    _swBtnArr =[[NSMutableArray alloc]init];
    _buMenArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
       [self addNavgationbar:@"意向客户" leftImageName:nil rightImageName:nil target:self leftBtnAction:@"back_back"  rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];
 
    if(isSW.intValue == 0)
    {
        
     
  
    }
    else if(isSW.intValue == 1)
    {
        //请求经理所有部门
        [FX_UrlRequestManager postByUrlStr:GetSalers_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
        
    }else if(isSW.intValue == 2) {
        //请求总监所有部门、、ZJdeptInit_url
        [FX_UrlRequestManager postByUrlStr:deptListInit_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(__MainScreen_Width-80, IOS7_StaticHeight, 44, 44);
//        [btn setTitle:@"培育库" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Rectangle 2"] forState:UIControlStateNormal];

        [btn setTitleColor:[ToolList getColor:@"C5C5C5"] forState:UIControlStateNormal];
        btn.titleLabel.alpha = 0.9;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(peiYuKu) forControlEvents:UIControlEventTouchUpInside];
        [self.headview addSubview:btn];

    }
  
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
    label.text =@"共计0条";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [ToolList getColor:@"999999"];
    [bgView addSubview:label];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(__MainScreen_Width-55, 0, 50, 44);
    [button setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [button addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    
    selectContentView = [[UIView alloc] initWithFrame:CGRectMake(0,- IOS7_Height-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-44)];
    selectContentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    [self.view addSubview:selectContentView];
    selectContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    selectContentScrollView.showsVerticalScrollIndicator = NO;
    selectContentScrollView.backgroundColor = [UIColor whiteColor];
    [selectContentView addSubview:selectContentScrollView];
    
    //阶段展示区域
    duanBlackView = [[UIView alloc] initWithFrame:selectContentScrollView.bounds];
    [selectContentScrollView addSubview:duanBlackView];
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45-45) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    [table.refreshHeader autoRefreshWhenViewDidAppear];
    table.tableFooterView = [UIView new];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __MainScreen_Height)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, IOS7_Height)];
    [searchView addSubview:headView];
    //搜索框
    text = [[UITextField alloc] initWithFrame:CGRectMake(13, IOS7_StaticHeight + 7, __MainScreen_Width-56, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    text.leftView = imgView;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.backgroundColor = [ToolList getColor:@"dedee0"];
    text.placeholder = @"请输入客户名称";
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
    
  
    
    //根据权限判断意向客户几个操作
    
    int countNo = (isSW.intValue == 1)? 2:3;

    operateView2 = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-45, __MainScreen_Width, 45)];
    
    UIButton* shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"放弃" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 0, __MainScreen_Width/countNo, 45);
    [shiFangBtn addTarget:self action:@selector(fangqi) forControlEvents:UIControlEventTouchUpInside];
    [operateView2 addSubview:shiFangBtn];
    [operateView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/countNo, 12) toPoint:CGPointMake(__MainScreen_Width/countNo, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    UIButton* fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配商务" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    
    [fenPeiBtn addTarget:self action:@selector(fenPeiSW) forControlEvents:UIControlEventTouchUpInside];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/countNo, 0, __MainScreen_Width/countNo, 45);
    [operateView2 addSubview:fenPeiBtn];
    
    UIButton* fenPeiBMBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBMBtn setTitle:@"分配部门" forState:UIControlStateNormal];
    fenPeiBMBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBMBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBMBtn.backgroundColor = [UIColor clearColor];
    
    [fenPeiBMBtn addTarget:self action:@selector(fenPeiBM) forControlEvents:UIControlEventTouchUpInside];
    fenPeiBMBtn.frame = CGRectMake(__MainScreen_Width/countNo*2, 0, __MainScreen_Width/countNo, 45);
    if(isSW.intValue == 2)
    {
        [operateView2 addSubview:fenPeiBMBtn];
        [operateView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/countNo*2, 12) toPoint:CGPointMake(__MainScreen_Width/countNo*2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
        
    }

    [self.view addSubview:operateView2];
    [self.view addSubview:searchView];


}

#pragma mark - 点击放弃
    -(void)fangqi
    {
        if(selectIndex == -1)
        {
            [ToolList showRequestFaileMessageLittleTime:@"请选择要放弃的公司"];
        }
        else
        {
        [FX_UrlRequestManager postByUrlStr:ReleseCustReason_url andPramas:nil andDelegate:self andSuccess:@"ReleseCustReason:" andFaild:nil andIsNeedCookies:NO];
        }
    }
#pragma mark - 释放理由查询成功
    -(void)ReleseCustReason:(NSDictionary *)dic
    {
        
        AlertWhyViewController *dd = [[AlertWhyViewController alloc] init];
       
        NSDictionary *dic1 = [dataArr objectAtIndex:selectIndex];
        dd.isNeedOther = NO;
        dd.IntentCustId = [dic1 objectForKey:@"custId"];
        [dd startTable:[dic objectForKey:@"result"]];
        
        [self.navigationController pushViewController:dd animated:NO];
        
        
    }

#pragma mark - 分配商务
-(void)fenPeiSW
{
    if(selectIndex == -1)
    {
        [ToolList showRequestFaileMessageLittleTime:@"请选择要操作的公司"];
        return;
    }
    //总监角色传所有，经理只传商务（数组之前已经提前判断好，直接传过去就行）
    FenPeiSelectTools *tooll = [[FenPeiSelectTools alloc] init];
    tooll.data = _buMenArr;
    NSDictionary *dic = [dataArr objectAtIndex:selectIndex];
    tooll.custId = [dic objectForKey:@"custId"];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
if(isSW.intValue == 2)
{
    tooll.all = YES;
}
    else
    {
        tooll.all = NO;
    }
    [self.navigationController pushViewController:tooll animated:NO];
}
#pragma mark - 分配部门
-(void)fenPeiBM
{
    if(selectIndex == -1)
    {
        [ToolList showRequestFaileMessageLittleTime:@"请选择要操作的公司"];
        return;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    
    //只把部门传过去
    for (NSDictionary *dic in _buMenArr) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
        
        [dic1 setObject:[dic objectForKey:@"deptId"] forKey:@"deptId"];
        [dic1 setObject:[dic objectForKey:@"deptName"] forKey:@"deptName"];
        [arr addObject:dic1];
        
    }
    FenPeiSelectTools *tooll = [[FenPeiSelectTools alloc] init];
    tooll.data = arr;
    tooll.all = NO;
    NSDictionary *dic = [dataArr objectAtIndex:selectIndex];
    tooll.custId = [dic objectForKey:@"custId"];
    [self.navigationController pushViewController:tooll animated:NO];


}
#pragma mark - 获得所有部门成功
-(void)getDeptSuccess:(NSDictionary *)dic
{
    [_buMenArr removeAllObjects];
       NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    NSArray *tempArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
  
        [_buMenArr addObjectsFromArray:tempArr];
    
//    [self makeSeachView];
    
}

#pragma mark----商务筛选页面
-(void)makeSeachView{
    
    float btn_w = (__MainScreen_Width-48)/3.;//按钮的宽度
    float buMen_h=0.0f;
    if (_buMenArr.count) {
        buMen_h = 35+(_buMenArr.count+2)/3*45;
    }
    
    selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, selectContentView.bounds.size.height-45);
    selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, buMen_h);
    
       if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]!= 0) {
        
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0,0, __MainScreen_Width, 1)];
        line3.backgroundColor = [ToolList getColor:@"e7e7eb"];
//        [selectContentScrollView addSubview:line3];
        
        //部门
        bm_l = [[UILabel alloc] initWithFrame:CGRectMake(10,0, __MainScreen_Width-20, 35)];
        bm_l.font = [UIFont systemFontOfSize:14];
        bm_l.textColor = [ToolList getColor:@"666666"];
        bm_l.text = @"部门";
    }
    
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        
        bm_l.text = @"商务";
        
        for (int i = 0 ; i < _buMenArr.count; i ++) {
            
            FX_Button *  btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"6" andTitle:@"部门" andTarget:self andDic:[_buMenArr objectAtIndex:i]];
            
            [selectContentScrollView addSubview:btn];
            
            [_bumenBtnArr addObject:btn];
            
//            NSString *dic1 =_buMenArr[i][@"salerId"];
//            if ([dic1 isEqualToString:_salerId])
//            {
//                btn.isSelect = YES;
//                [btn changeType1Btn:YES];
//            }
        }
        
    }else{
        
        for (int i = 0 ; i < _buMenArr.count; i ++) {
            
            NSDictionary *bumenDic = @{@"deptId":[[_buMenArr objectAtIndex:i] objectForKey:@"deptId"],@"deptEmp":[[_buMenArr objectAtIndex:i] objectForKey:@"deptEmp"],@"deptName":[[_buMenArr objectAtIndex:i] objectForKey:@"deptName"]};
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12),35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"部门" andTarget:self andDic:bumenDic];
            
            [selectContentScrollView addSubview:btn];
            
            [_bumenBtnArr addObject:btn];
            //            NSLog(@"************%@",bumenDic);
//            NSString *dic1 =bumenDic[@"deptId"];
//            if ([dic1 isEqualToString:_deptId])
//            {
//                btn.isSelect = YES;
//                [btn changeType1Btn:YES];
//                
//                if ([[bumenDic objectForKey:@"deptEmp"] isKindOfClass:[NSArray class]]) {
//                    NSArray *deptEmpArr = [bumenDic objectForKey:@"deptEmp"];
//                    [self makeSWtwo:deptEmpArr];
//                    
//                }else{
//                    
//                    [self makeSWtwo:nil];
//                }
//                
//            }
        }
        
    }
    [selectContentScrollView addSubview:bm_l];
    
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(0, buMen_h, __MainScreen_Width, 1)];
    line2.backgroundColor = [ToolList getColor:@"e7e7eb"];
    
    UIView *line9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 1)];
    line9.backgroundColor = [ToolList getColor:@"e7e7eb"];
    
    UIButton*  btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCommit addSubview:line9];
    btnCommit.frame = CGRectMake(0, selectContentView.frame.size.height -45, __MainScreen_Width, 45);
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnCommit setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    //  btnCommit.backgroundColor = [UIColor greenColor];
    [btnCommit setTitle:@"完成" forState:UIControlStateNormal];
    [btnCommit addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [selectContentView addSubview:btnCommit];
    
}


#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic{
    
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    //部门
     if([str isEqualToString:@"部门"])
    {
        
        if(btn.isSelect)
        {
            for (FX_Button *btnS in _bumenBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
            {
                _my_salerId = [dic1 objectForKey:@"salerId"];
            }else{
                
                _my_deptId = [dic1 objectForKey:@"deptId"];
                _my_salerId = @"";
                
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
            _my_deptId = @"";
        }
    }else
    {
        
        if(btn.isSelect)
        {
            for (FX_Button *btnS in _swBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            
            _my_salerId = [dic1 objectForKey:@"salerId"];
            
        }
        else
        {
            _my_salerId = @"";
            
        }
    }
}

#pragma mark - 完成筛选
-(void)commit:(UIButton *)btn
{
    
    [self changeBtnAction:button];
    
    startPage = 1;
    
    [self requestAlldata];
    

}

#pragma mark - 总监点击部门显示商务操作
-(void)makeSWtwo:(NSArray *)empArr{
    
    float sw_h = 0.0f;
    float main_h =0.0f;
    [swView removeFromSuperview];
    swView = nil;
    
    if (empArr.count) {
        
        sw_h = 35+(empArr.count+2)/3*45;
        main_h = line2.frame.origin.y+line2.frame.size.height+sw_h+15+1;
        
        swView = [[UIView alloc]initWithFrame:CGRectMake(0, line2.frame.origin.y+line2.frame.size.height+1, __MainScreen_Width, sw_h)];
       
        swView.backgroundColor = [UIColor clearColor];
        [selectContentScrollView addSubview:swView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 1)];
        line.backgroundColor = [ToolList getColor:@"e7e7eb"];
        [swView addSubview:line];
        
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
            
            [_swBtnArr addObject:btn];
//            NSString *dic1 =empArr[i][@"salerId"];
//            if ([dic1 isEqualToString:_salerId])
//            {
//                btn.isSelect = YES;
//                [btn changeType1Btn:YES];
//            }
            
        }
        
        
        
    }else{
        sw_h = 0.0f;
        main_h = line2.frame.origin.y+line2.frame.size.height+15;
    }
    
    {
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, selectContentView.bounds.size.height-45);
        selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main_h);
        
    }
    
}



#pragma mark 培育库按钮
-(void)peiYuKu
{
    peiYuKuViewController *peiYu =[[ peiYuKuViewController alloc]init];
    peiYu.orderId = orderId;

    [self.navigationController pushViewController:peiYu animated:NO];
   
}
#pragma mark - 搜索按钮点击
-(void)searchClicked:(UIButton *)btn
{
    text.text = @"";
    selectIndex = -1;
    [text becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    selectIndex = -1;

    flagNeedReload = YES;
    searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    [self requestAlldata];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    // Do any additional setup after loading the view.
}
#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    selectIndex = -1;
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
    [requestDic setObject:theTextField.text forKey:@"custName"];
    startPage = 1;
    flagNeedReload = NO;
    [self requestAlldata];
    [requestDic setObject:@"" forKey:@"custName"];

    return YES;
}

#pragma mark   //取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    selectIndex = -1;

    flagNeedReload = YES;
    startPage = 1;
    [requestDic setObject:@"" forKey:@"custName"];
    [self requestAlldata];
    [text resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark - 部门客户列表数据请求成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    
    label.text = [NSString stringWithFormat:@"共%@条",[resultDic objectForKey:@"total"]];
    if(startPage == 1)
    {
      
        [dataArr removeAllObjects];
    }
    if([[resultDic objectForKey:@"result"] count] <= 0 )
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        if(startPage == 1)
        {
            operateView2.hidden = YES;

            [dataArr removeAllObjects];
          
            [table reloadData];
                   }
    }
    else
    {
        operateView2.hidden = NO;

        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        for(NSDictionary *tagInfoDic in dataArr)
        {
            orderId =tagInfoDic[@"orderId"];
   
        }
    
            [table reloadData];
        
           }
}
#pragma mark - 数据请求
-(void) requestAlldata
{
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            
        }
            break;
            
        case 1://经理
        {
            
            [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
            requestDic[@"salerId"]=_my_salerId;
            [FX_UrlRequestManager postByUrlStr:IntentCustDept_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            
        }
            break;
        case 2://总监
        {
            
            [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
            requestDic[@"salerId"]=_my_salerId;
            requestDic[@"deptId"]=_my_deptId;
            [FX_UrlRequestManager postByUrlStr:ZJIntentCust2Majordomo_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            
        }
            break;
            
            
            
        default:
            break;
    }

  
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 45;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - table代理
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] init];
    return footView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YixiangTableViewCell";
    YixiangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YixiangTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 134.5) toPoint:CGPointMake(__MainScreen_Width, 134.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    cell.selectionStyle = 0;
    cell.nono = (int)indexPath.row;
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    if(indexPath.row == selectIndex)
    {
        [cell.btnImageSelect setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [cell.btnImageSelect setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];

    }
    cell.orderId_L.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    if(![[ToolList changeNull:[ NSString stringWithFormat:@"%@",[dic objectForKey:@"sjCustMark"]]] isEqualToString:@"1"])
    {
        cell.xin.hidden = YES;
    }
    cell.delegate_my = self;
    NSString *nameStr = [NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dic objectForKey:@"linkmanName"]],[ToolList changeNull:[dic objectForKey:@"mobile"]],[ToolList changeNull:[dic objectForKey:@"tel"]]];
    cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"sjCode"]];
    cell.addL.text = nameStr;
    NSString *nameStr1 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"industryName"]],[ToolList changeNull:[dic objectForKey:@"createTime"]]];
    cell.qian_Label.text =nameStr1;
    
    
    

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.buMenArr = _buMenArr;
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    s.sjFlag = @"88";
    [self.navigationController pushViewController:s animated:NO];
}
#pragma mark - 处理选中操作

-(void)selectDo:(int)flagInt
{
    selectIndex = flagInt;
    NSLog(@"%d=====",selectIndex);

    [table reloadData];
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
