//
//  CY_recordVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/8.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import <ImageIO/ImageIO.h>
#import "CY_recordVc.h"
#import "CY_recordCell.h"
#import "UIImageView+WebCache.h"
#import "CY_photoVc.h"
#import "CY_writContenVc.h"
#import "CY_OneRecordVC.h"
#import "UserDetailViewController.h"
#import "CY_popupV.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "XiejiluViewController.h"
#import "QFDatePickerView.h"
#import "AppDelegate.h"
#define LUN_TAG 109
#define ZAN_TAG 1232
#define CELL_TAG 11

@interface CY_recordVc (){
    
    //    UIImageView *urlImage;
    //播语音
    AVAudioPlayer *audioPlayer;
    BOOL isRe;
    UILabel *label;
    
    UIView *selectContentView;
    UIScrollView *selectContentScrollView;
    UIView *duanBlackView;
    NSString *bumenId;
    NSString *depId;
    UIView *swView;//筛选--商务承载页面
    UIView * line2;
    UILabel *bm_l;
    UIButton *button;//筛选按钮
    UIImageView *urlImage_2;
    
    
    float main2_h;
}

@property (nonatomic,strong)Fx_TableView *recordTable;

@property (nonatomic,strong)NSMutableArray *recordArr;
@property (nonatomic,strong)UIImageView *loadingImage;
@property (nonatomic,strong)NSMutableArray *bigUrlArr;
@property (nonatomic,assign)NSInteger startPage;

@property (nonatomic,strong)NSMutableDictionary *requestDic;//放置请求参数

@property (nonatomic,strong)NSMutableArray *zanArr;
@property (nonatomic,strong)NSMutableArray *zanNumArr;

@property (nonatomic,strong)UIButton *senderbt;//

@property (nonatomic,strong)NSMutableArray *emojiTags;//表情TAG

@property (nonatomic,strong)NSMutableArray *emojiImages;//表情对应图片

@property (nonatomic,strong)NSArray *ZTArr;//状态：全部，待回访，有效回访
@property (nonatomic,strong)NSArray *buMenArr;//部门旗下的商务
@property (nonatomic,strong)NSMutableArray *bumenBtnArr;
@property (nonatomic,strong)NSMutableArray *zhuangtaiBtnArr;
@property (nonatomic,strong)NSMutableArray *swBtnArr;
@property (nonatomic,strong) QFDatePickerView *datePickerView;
@end

@implementation CY_recordVc

-(void)leftBtn11Action{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark----筛选
-(void)rightBtnAction:(UIButton *)sender{
    
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    //    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"recordArr"] count]) {
    //
    //
    //        _recordArr = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"recordArr"]];
    //
    //        [_recordTable reloadData];
    //
    //       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"recordArr"];
    //
    //        return;
    //    }
    
    [self allRequest];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    main2_h=0.0f;
    _startPage = 1;
    isRe = NO;
    _requestDic = [[NSMutableDictionary alloc]init];
    
    _emojiTags = [[NSMutableArray alloc]init];
    _emojiImages =[[NSMutableArray alloc]init];
    _bumenBtnArr =[[NSMutableArray alloc]init];
    _zhuangtaiBtnArr =[[NSMutableArray alloc]init];
    _swBtnArr =[[NSMutableArray alloc]init];
    
    if (_state.length==0 || _state == nil) {
        
        _state = @"0";
    }
    _requestDic[@"salerId"]=_salerId;
    _requestDic[@"deptId"]=_deptId;
    _requestDic[@"state"]= _state;
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0){
        _ZTArr =@[@{@"-1":@"全部"},@{@"0":@"待回访"},@{@"3":@"有效拜访"}];
    }
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        _ZTArr =@[@{@"-1":@"全部"},@{@"0":@"待回访"},@{@"1":@"已回访"},@{@"2":@"已陪访"}];
        //请求经理所有部门
        [FX_UrlRequestManager postByUrlStr:GetSalers_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
        
        
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        _ZTArr =@[@{@"-1":@"全部"},@{@"0":@"待回访"},@{@"1":@"已回访"},@{@"2":@"已陪访"}];
        //请求总监所有部门、、ZJdeptInit_url
        [FX_UrlRequestManager postByUrlStr:deptListInit_url andPramas:nil andDelegate:self andSuccess:@"getDeptSuccess:" andFaild:nil andIsNeedCookies:NO];
    }
    
    for(int i = 0 ; i < 8;i++)
    {
        NSString *tag = [NSString stringWithFormat:@"[bq_%d]",i+1];
        NSString *image = [NSString stringWithFormat:@"bq_%d.png",i+1];
        [_emojiTags addObject:tag];
        [_emojiImages addObject:[UIImage imageNamed:image]];
        
    }
    [self addNavgationbar:@"拜访记录" leftImageName:nil rightImageName:nil target:self leftBtnAction:@"leftBtn11Action" rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
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
    [button addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0)
    {
        
        [self makeSeachView];
        
    }
    _recordTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+5+bgView.frame.size.height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-5-bgView.frame.size.height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _recordTable.dataSource = self;
    _recordTable.delegate = self;
    _recordTable.backgroundColor = [UIColor clearColor];
    [_recordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_recordTable.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_recordTable];
    
}

#pragma mark - 获得所有部门成功
-(void)getDeptSuccess:(NSDictionary *)dic
{
    _buMenArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
    [self makeSeachView];
    
}

#pragma mark----筛选页面
-(void)makeSeachView{
    
    float btn_w = (__MainScreen_Width-48)/3.;//按钮的宽度
    float ZhuangTai_h = 35+(_ZTArr.count+2)/3*45;//状态的高度
    float buMen_h=0.0f;
    if (_buMenArr.count) {
        buMen_h = 35+(_buMenArr.count+2)/3*45;
    }
    
    main2_h = ZhuangTai_h+buMen_h;
    
    selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, selectContentView.bounds.size.height-45);
    selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, main2_h);
    
    //状态
    UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, __MainScreen_Width-20, 35)];
    b_l.font = [UIFont systemFontOfSize:14];
    b_l.textColor = [ToolList getColor:@"666666"];
    b_l.text = @"状态";
    [selectContentScrollView addSubview:b_l];
    
    for (int i = 0 ; i < _ZTArr.count; i ++) {
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"状态" andTarget:self andDic:[_ZTArr objectAtIndex:i]];
        
        [selectContentScrollView addSubview:btn];
        
        [_zhuangtaiBtnArr addObject:btn];
        
        NSDictionary *dic1 =_ZTArr[i];
        if ([[[dic1 allKeys] lastObject] isEqualToString:_state])
        {
            btn.isSelect = YES;
            [btn changeType1Btn:YES];
        }
        
        
    }
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0,ZhuangTai_h, __MainScreen_Width, 1)];
    line3.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line3];
    
    //名字
    bm_l = [[UILabel alloc] initWithFrame:CGRectMake(10,ZhuangTai_h, __MainScreen_Width-20, 35)];
    bm_l.font = [UIFont systemFontOfSize:14];
    bm_l.textColor = [ToolList getColor:@"666666"];
    //商务
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0)
    {
        //时间
        UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, main2_h, __MainScreen_Width-20, 35)];
        b_l.font = [UIFont systemFontOfSize:14];
        b_l.textColor = [ToolList getColor:@"666666"];
        b_l.text = @"月份";
        [selectContentScrollView addSubview:b_l];
        //创建时间控件
        
        NSDictionary *dic = @{@"selectedYear":_businessYear,@"selectecMonth":_businessMonth};
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
        _datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
            _businessYear =  [str substringWithRange:NSMakeRange(0, 4)];
            _businessMonth =  [str substringWithRange:NSMakeRange(5, 2)];
            [_requestDic setObject:_businessYear forKey:@"businessYear"];
            [_requestDic setObject:_businessMonth forKey:@"businessMonth"];
            
            
        }andYear:[currentDate substringWithRange:NSMakeRange(0, 4)] andMonth:[currentDate substringWithRange:NSMakeRange(5, 2)] andPickFrame:CGRectMake(0, b_l.frame.size.height+b_l.frame.origin.y, __MainScreen_Width, 200) andButtonHiden:(BOOL)YES andSelectdic:dic];
        
        [selectContentScrollView addSubview:_datePickerView];
        [selectContentScrollView setScrollEnabled:NO];
        
    }
    //经理
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        
        bm_l.text = @"商务";
        
        for (int i = 0 ; i < _buMenArr.count; i ++) {
            
            FX_Button *  btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), ZhuangTai_h+35+(i/3)*45, btn_w, 30) andType:@"6" andTitle:@"部门" andTarget:self andDic:[_buMenArr objectAtIndex:i]];
            
            [selectContentScrollView addSubview:btn];
            
            [_bumenBtnArr addObject:btn];
            
            NSString *dic1 =_buMenArr[i][@"salerId"];
            if ([dic1 isEqualToString:_salerId])
            {
                btn.isSelect = YES;
                [btn changeType1Btn:YES];
            }
        }
        UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0,ZhuangTai_h+35+(_buMenArr.count/3+1)*45+10, __MainScreen_Width, 1)];
        line3.backgroundColor = [ToolList getColor:@"e7e7eb"];
        [selectContentScrollView addSubview:line3];
        //时间
        UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, line3.frame.origin.y+line3.frame.size.height+10, __MainScreen_Width-20, 35)];
        b_l.font = [UIFont systemFontOfSize:14];
        b_l.textColor = [ToolList getColor:@"666666"];
        b_l.text = @"月份";
        [selectContentScrollView addSubview:b_l];
        //创建时间控件
        
        NSDictionary *dic = @{@"selectedYear":_businessYear,@"selectecMonth":_businessMonth};
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy年MM月"];
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
        _datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
            _businessYear =  [str substringWithRange:NSMakeRange(0, 4)];
            _businessMonth =  [str substringWithRange:NSMakeRange(5, 2)];
            [_requestDic setObject:_businessYear forKey:@"businessYear"];
            [_requestDic setObject:_businessMonth forKey:@"businessMonth"];
            
            
        }andYear:[currentDate substringWithRange:NSMakeRange(0, 4)] andMonth:[currentDate substringWithRange:NSMakeRange(5, 2)] andPickFrame:CGRectMake(0, b_l.frame.size.height+b_l.frame.origin.y-10, __MainScreen_Width, 150) andButtonHiden:(BOOL)YES andSelectdic:dic];
        
        [selectContentScrollView addSubview:_datePickerView];
        [selectContentScrollView setContentSize:CGSizeMake(__MainScreen_Width, _datePickerView.frame.size.height+_datePickerView.frame.origin.y+10)];
    }else{//总监
        
        bm_l.text = @"部门";
        for (int i = 0 ; i < _buMenArr.count; i ++) {
            
            NSDictionary *bumenDic = @{@"deptId":[[_buMenArr objectAtIndex:i] objectForKey:@"deptId"],@"deptEmp":[[_buMenArr objectAtIndex:i] objectForKey:@"deptEmp"],@"deptName":[[_buMenArr objectAtIndex:i] objectForKey:@"deptName"]};
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), ZhuangTai_h+35+(i/3)*45, btn_w, 30) andType:@"1" andTitle:@"部门" andTarget:self andDic:bumenDic];
            
            [selectContentScrollView addSubview:btn];
            
            [_bumenBtnArr addObject:btn];
            //            NSLog(@"************%@",bumenDic);
            NSString *dic1 =bumenDic[@"deptId"];
            if ([dic1 isEqualToString:_deptId])
            {
                btn.isSelect = YES;
                [btn changeType1Btn:YES];
                
                if ([[bumenDic objectForKey:@"deptEmp"] isKindOfClass:[NSArray class]]) {
                    NSArray *deptEmpArr = [bumenDic objectForKey:@"deptEmp"];
                    [self makeSWtwo:deptEmpArr];
                    
                }else{
                    
                    [self makeSWtwo:nil];
                }
                
            }
        }
      
    }
    [selectContentScrollView addSubview:bm_l];
    
    
    line2 = [[UIView alloc] initWithFrame:CGRectMake(0, ZhuangTai_h+buMen_h, __MainScreen_Width, 1)];
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
    
    //状态
    if([str isEqualToString:@"状态"])
    {
        if(btn.isSelect)
        {
            
            for (FX_Button *btnS in _zhuangtaiBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            
            _state = [[dic1 allKeys] lastObject];
        }
    }
    
    //部门
    else if([str isEqualToString:@"部门"])
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
                _salerId = [dic1 objectForKey:@"salerId"];
            }else{
                
                _deptId = [dic1 objectForKey:@"deptId"];
                _salerId = @"";
                
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
            _deptId = @"";
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
            
            _salerId = [dic1 objectForKey:@"salerId"];
            
        }
        else
        {
            _salerId = @"";
            
        }
    }
}

#pragma mark - 完成筛选
-(void)commit:(UIButton *)btn
{
    _requestDic[@"salerId"]=_salerId;
    _requestDic[@"deptId"]=_deptId;
    _requestDic[@"state"]= _state;
    
    [self rightBtnAction:button];
    
    _startPage = 1;
    
    [self allRequest];
    
    
}

#pragma mark - 总监点击部门显示商务操作
-(void)makeSWtwo:(NSArray *)empArr{
    
    float sw_h = 0.0f;
    float main_h =0.0f;
    [swView removeFromSuperview];
    swView = nil;
    
    if (empArr.count) {
        
        sw_h = 35+(empArr.count+2)/3*45;
        main_h = main2_h+sw_h+15+1;
        
        swView = [[UIView alloc]initWithFrame:CGRectMake(0, main2_h+1, __MainScreen_Width, sw_h)];
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
        
        for (int i = 0 ; i < empArr.count; i ++)
        {
            
            FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(12+(i%3)*(btn_w+12), 35+(i/3)*45, btn_w, 30) andType:@"6" andTitle:@"商务" andTarget:self andDic:[empArr objectAtIndex:i]];
            
            [swView addSubview:btn];
            
            [_swBtnArr addObject:btn];
            NSString *dic1 =empArr[i][@"salerId"];
            if ([dic1 isEqualToString:_salerId])
            {
                btn.isSelect = YES;
                [btn changeType1Btn:YES];
            }
            
        }
        
        
        
    }else{
        sw_h = 0.0f;
        main_h = line2.frame.origin.y+line2.frame.size.height+15;
    }
    
 
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0,main_h, __MainScreen_Width, 1)];
    line3.backgroundColor = [ToolList getColor:@"e7e7eb"];
    [selectContentScrollView addSubview:line3];
    //时间
    UILabel *b_l = [[UILabel alloc] initWithFrame:CGRectMake(10, line3.frame.origin.y+line3.frame.size.height, __MainScreen_Width-20, 35)];
    b_l.font = [UIFont systemFontOfSize:14];
    b_l.textColor = [ToolList getColor:@"666666"];
    b_l.text = @"月份";
    [selectContentScrollView addSubview:b_l];
    //创建时间控件
    
    NSDictionary *dic = @{@"selectedYear":_businessYear,@"selectecMonth":_businessMonth};
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    _datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        _businessYear =  [str substringWithRange:NSMakeRange(0, 4)];
        _businessMonth =  [str substringWithRange:NSMakeRange(5, 2)];
        [_requestDic setObject:_businessYear forKey:@"businessYear"];
        [_requestDic setObject:_businessMonth forKey:@"businessMonth"];
        
        
    }andYear:[currentDate substringWithRange:NSMakeRange(0, 4)] andMonth:[currentDate substringWithRange:NSMakeRange(5, 2)] andPickFrame:CGRectMake(0, b_l.frame.size.height+b_l.frame.origin.y-10, __MainScreen_Width, 150) andButtonHiden:(BOOL)YES andSelectdic:dic];
    
    [selectContentScrollView addSubview:_datePickerView];
    
    
        selectContentScrollView.frame = CGRectMake(0, 0, __MainScreen_Width, selectContentView.bounds.size.height-45);
    [selectContentScrollView setContentSize:CGSizeMake(__MainScreen_Width, _datePickerView.frame.size.height+_datePickerView.frame.origin.y+10)];

    
    
}


-(void)allRequest{
    
    _requestDic[@"pagesize"]=[NSNumber numberWithInt:10];
    
    [_requestDic setObject:[NSString stringWithFormat:@"%ld",_startPage] forKey:@"pageNo"];
    [_requestDic setObject:_businessYear forKey:@"businessYear"];
    [_requestDic setObject:_businessMonth forKey:@"businessMonth"];
    
    [FX_UrlRequestManager postByUrlStr:workAccountDetail_url andPramas:_requestDic andDelegate:self andSuccess:@"recordSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}

#pragma mark 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    isRe = NO;
    _startPage = 1;
    [self allRequest];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    isRe = YES;
    _startPage ++;
    [self allRequest];
    
}

/*
 
 praiseNum：点赞数量
 commentNum：评论数量
 visitAdd：拜访地址
 content：添加记录内容
 total：该客户的沟通记录总条数
 logId：沟通记录ID
 pictureList：图片地址列表
 salerName：填写记录者名字
 dateStr：沟通记录发送时间
 linkManName:联系人名称
 visitType:沟通类型
 salerId:填写沟通记录者ID
 logId:”沟通记录ID”
 videoLength：沟通记录语音长度
 salerId:填写记录者ID
 logId:沟通记录ID
 
 */
-(void)recordSuccess:(NSDictionary *)sucDic{
    
    [_recordTable.refreshHeader endRefreshing];
    [_recordTable.refreshFooter endRefreshing];
    label.text = [NSString stringWithFormat:@"共计%@条",[sucDic objectForKey:@"total"]];
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if (isRe) {//加载更多
            
            NSArray *dataArr =[sucDic objectForKey:@"result"];
            
            if (dataArr.count) {
                
                [_recordArr addObjectsFromArray:dataArr];
                
            }else{
                
                [ToolList showRequestFaileMessageLittleTime:@"暂无更多数据"];
            }
            
        }else{
            
            if ([[sucDic objectForKey:@"result"] count ]== 0) {
                
                if (_recordArr) {
                    
                    [_recordArr removeAllObjects];
                }
                
                
                [_recordTable reloadData];
                
                return;
            }
            
            _recordArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
            
        }
        /*
         if (_zanArr==nil) {
         
         _zanArr = [[NSMutableArray alloc]init];
         
         }else{
         
         [_zanArr removeAllObjects];
         }
         
         if (_zanNumArr==nil) {
         
         _zanNumArr = [[NSMutableArray alloc]init];
         
         }else{
         
         [_zanNumArr removeAllObjects];
         }
         
         for (NSDictionary *dic in _recordArr) {
         
         [_zanArr addObject:[dic objectForKey:@"praiseFlag"]];
         
         [_zanNumArr addObject:[dic objectForKey:@"praiseNum"]];
         }
         */
    }
    
    
    [_recordTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _recordArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float hh = 90.0f;
    
    NSDictionary *dic = [_recordArr objectAtIndex:indexPath.row];
    
    if ([ToolList changeNull:[dic objectForKey:@"content"]].length){
        
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [[dic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        hh = hh+labelsize.height+20;
        
    }
    if ([ToolList changeNull:[dic objectForKey:@"videoURL"]].length){
        
        hh = 10+45+hh;
    }
    
    if ([[dic objectForKey:@"pictureList"] count]) {
        
        NSArray *urlArr = [dic objectForKey:@"pictureList"];
        
        if (urlArr.count==1) {
            
            hh=hh+10+150;
            
        }else{
            float imageWW = (__MainScreen_Width-26)/3.0;
            hh+= (imageWW+3)*((urlArr.count-1)/3)+imageWW+10;
        }
    }
    hh+=35;
    
    if ([ToolList changeNull:[dic objectForKey:@"visitAdd"]].length) {
        
        hh+=30;
    }
    
    hh+=56;
    
    if ([[dic objectForKey:@"flag"] intValue] == 0) {
        hh -= 36;
        
    }
    
    if ([[dic objectForKey:@"callBackMap"] count]) {
        hh += 55;
        NSDictionary *CallDic =[dic objectForKey:@"callBackMap"];
        if ([ToolList changeNull:[CallDic objectForKey:@"content"]].length){
            
            UIFont *font = [UIFont systemFontOfSize:16];
            CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: font};
            CGSize labelsize = [[CallDic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            hh = hh+labelsize.height+20;
            
        }
        if ([ToolList changeNull:[CallDic objectForKey:@"videoURL"]].length){
            
            hh = 10+45+hh;
        }
        
        if ([[CallDic objectForKey:@"pictureList"] count]) {
            
            NSArray *urlArr = [CallDic objectForKey:@"pictureList"];
            
            if (urlArr.count==1) {
                
                hh=hh+10+150;
                
            }else{
                float imageWW = (__MainScreen_Width-26)/3.0;
                hh+= (imageWW+3)*((urlArr.count-1)/3)+imageWW+10;
            }
        }
        hh+=35;
        
        if ([ToolList changeNull:[CallDic objectForKey:@"visitAdd"]].length) {
            
            hh+=30;
        }
        
    }
    
    return hh;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CY_recordCell";
    CY_recordCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell1==nil)
    {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"CY_recordCell" owner:self options:nil] lastObject];
        
    }
    
    NSDictionary *dic = [_recordArr objectAtIndex:indexPath.row];
    cell1.touImage.layer.masksToBounds = YES;
    cell1.touImage.layer.cornerRadius = 19.0;
    cell1.litleImage.frame = CGRectMake(__MainScreen_Width-17, 11, 6, 12);
    cell1.linel.frame = CGRectMake(0, 34.5, __MainScreen_Width, 0.5);
    cell1.comBT.tag = indexPath.row+CELL_TAG;
    [cell1.comBT setTitle:[ToolList changeNull:[dic objectForKey:@"custName"]] forState:UIControlStateNormal];//公司名称
    cell1.comBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cell1.nameL.text =  [ToolList changeNull:[dic objectForKey:@"salerName"]];//商务姓名
    
    cell1.timeL.text =[ToolList changeNull:[dic objectForKey:@"dateStr"]];//回复时间
    //回复内容
    [self makeContentView:cell1.contentL andTimeLabel:cell1.timeL andDic:dic];
    //语音图片
    [self makeYuYinView:cell1.yuYinV andcontentL:cell1.contentL andYYbt:cell1.yuYinBt andMiaoL:cell1.miaoL andBT:cell1.imageAndB andDic:dic andIndex:indexPath];
    
    //图片
    [self makeImage:cell1.ImageV andYuYinV:cell1.yuYinV andDic:dic andIndexpath:indexPath andHuiFang:NO];
    
    cell1.typeL.text =[ToolList changeNull:[dic objectForKey:@"visitType"]];//标签
    
    cell1.typeNameL.text =[ToolList changeNull:[dic objectForKey:@"linkManName"]];//标签联系人
    CGSize sizetype = [cell1.typeNameL sizeThatFits:CGSizeMake( MAXFLOAT,cell1.typeNameL.frame.size.height)];
    
    float typeW = sizetype.width+10 >__MainScreen_Width-20-cell1.typeNameL.frame.origin.x?__MainScreen_Width-20-cell1.typeNameL.frame.origin.x:sizetype.width+10;
    
    cell1.typeNameL.frame = CGRectMake(cell1.typeNameL.frame.origin.x, cell1.typeNameL.frame.origin.y,typeW, cell1.typeNameL.frame.size.height);
    
    cell1.typeV.frame =CGRectMake(10, cell1.ImageV.frame.origin.y+cell1.ImageV.frame.size.height+10, __MainScreen_Width-20, 25);
    
    //定位
    if ([ToolList changeNull:[dic objectForKey:@"visitAdd"]].length) {
        
        [cell1.addL setTitle:[ToolList changeNull:[dic objectForKey:@"visitAdd"]] forState:UIControlStateNormal];
        
        CGSize size = [cell1.addL sizeThatFits:CGSizeMake( MAXFLOAT,cell1.addL.frame.size.height)];
        float addW = size.width +20>__MainScreen_Width-20?__MainScreen_Width-20:size.width;
        
        cell1.addV.frame = CGRectMake(10, cell1.typeV.frame.origin.y+cell1.typeV.frame.size.height+5,addW+20, 25);
        
        cell1.addL.frame =CGRectMake(20, 0 ,addW+20, 25);
        
    }else{
        
        cell1.addV.frame = CGRectMake(0, cell1.typeV.frame.origin.y+cell1.typeV.frame.size.height, 0, 0);
        cell1.addV.hidden = YES;
        cell1.addL.frame =CGRectMake(20, 0 ,0, 0);
    }
    
    if ([[dic objectForKey:@"flag"] intValue]==0) {//0 无操作
        
        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 0);
        cell1.touchV.hidden = YES;
        
    }else if ([[dic objectForKey:@"flag"] intValue]==1){//1 允许 回访 陪访
        
        cell1.touchV.hidden = NO;
        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 36);
        
        cell1.lunB.tag = indexPath.row+LUN_TAG;
        cell1.zanBt.tag =indexPath.row+LUN_TAG;
        
        cell1.lunB.frame = CGRectMake(0, 0,(__MainScreen_Width-1)/2, 36);
        cell1.line.frame = CGRectMake((__MainScreen_Width)/2, 5, 0.5, 28);
        cell1.zanBt.frame =CGRectMake((__MainScreen_Width)/2, 0,(__MainScreen_Width-1)/2, 36);
        
        [cell1.lunB setTitle:@"陪访"  forState:UIControlStateNormal];
        [cell1.zanBt setTitle:@"回访" forState:UIControlStateNormal];
        [cell1.lunB setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell1.zanBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    else{// 2.允许回访
        cell1.touchV.hidden = NO;
        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 36);
        cell1.zanBt.frame =CGRectMake(0, 0,__MainScreen_Width, 36);
        cell1.zanBt.tag =indexPath.row+LUN_TAG;
        [cell1.zanBt setTitle:@"回访" forState:UIControlStateNormal];
        cell1.lunB.hidden = YES;
        cell1.line.hidden = YES;
    }
    
    
    if ([[dic objectForKey:@"callBackMap"] count]){
        
        cell1.huifangView.hidden = NO;
        
        NSDictionary *subDic =[dic objectForKey:@"callBackMap"];
        cell1.touImage1.layer.masksToBounds = YES;
        cell1.touImage1.layer.cornerRadius = 19.0;
        cell1.nameL1.text =  [ToolList changeNull:[subDic objectForKey:@"salerName"]];//商务姓名
        cell1.timeL1.text =[ToolList changeNull:[subDic objectForKey:@"dateStr"]];//回复时间
        //回复内容
        [self makeContentView:cell1.contentL1 andTimeLabel:cell1.timeL1 andDic:subDic ];
        //语音图片
        [self makeYuYinView:cell1.yuYinV1 andcontentL:cell1.contentL1 andYYbt:cell1.yuYinBt1 andMiaoL:cell1.miaoL1 andBT:cell1.imageAndB1 andDic:subDic andIndex:indexPath];
        
        //图片
        [self makeImage:cell1.ImageV1 andYuYinV:cell1.yuYinV1 andDic:subDic andIndexpath:indexPath andHuiFang:YES];
        
        cell1.typeL1.text =[ToolList changeNull:[subDic objectForKey:@"visitType"]];//标签
        
        cell1.typeNameL1.text =[ToolList changeNull:[subDic objectForKey:@"linkManName"]];//标签联系人
        CGSize sizetype = [cell1.typeNameL1 sizeThatFits:CGSizeMake( MAXFLOAT,cell1.typeNameL1.frame.size.height)];
        float typeW = sizetype.width+10 >__MainScreen_Width-13-cell1.typeNameL1.frame.origin.x?__MainScreen_Width-13-cell1.typeNameL1.frame.origin.x:sizetype.width+10;
        
        cell1.typeNameL1.frame = CGRectMake(cell1.typeNameL1.frame.origin.x, cell1.typeNameL1.frame.origin.y,typeW+10, cell1.typeNameL1.frame.size.height);
        
        cell1.typeV1.frame =CGRectMake(10, cell1.ImageV1.frame.origin.y+cell1.ImageV1.frame.size.height+10, __MainScreen_Width-20, 25);
        
        //定位
        if ([ToolList changeNull:[subDic objectForKey:@"visitAdd"]].length) {
            
            [cell1.addL1 setTitle:[ToolList changeNull:[subDic objectForKey:@"visitAdd"]] forState:UIControlStateNormal];
            
            CGSize size = [cell1.addL1 sizeThatFits:CGSizeMake( MAXFLOAT,cell1.addL1.frame.size.height)];
            float addW = size.width +20>__MainScreen_Width-20?__MainScreen_Width-20:size.width;
            
            cell1.addV1.frame = CGRectMake(10, cell1.typeV1.frame.origin.y+cell1.typeV1.frame.size.height+5,addW+20, 25);
            
            cell1.addL1.frame =CGRectMake(20, 0 ,addW+20, 25);
            
        }else{
            
            cell1.addV1.frame = CGRectMake(0, cell1.typeV1.frame.origin.y+cell1.typeV1.frame.size.height, 0, 0);
            cell1.addV1.hidden = YES;
            cell1.addL1.frame =CGRectMake(20, 0 ,0, 0);
        }
        
        
        cell1.huifangView.frame = CGRectMake(cell1.huifangView.frame.origin.x, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height, __MainScreen_Width-16, cell1.typeV1.frame.origin.y+cell1.typeV1.frame.size.height+10);
        
    }else{
        cell1.huifangView.hidden = YES;
        cell1.huifangView.frame = CGRectMake(cell1.huifangView.frame.origin.x, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height,__MainScreen_Width-16, 0);
    }
    
    
    cell1.mainV.frame =CGRectMake(0,0,__MainScreen_Width, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height);
    cell1.frame =CGRectMake(0,0,__MainScreen_Width, cell1.mainV.frame.size.height+cell1.huifangView.frame.size.height+10);
    
    
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _loadingImage =cell1.imageAndB;
    //播放时喇叭动画
    //设置动画帧
    _loadingImage.animationImages=[NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_1.png"],
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_2.png"],
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"],
                                   nil ];
    
    //设置动画总时间
    _loadingImage.animationDuration=1.0;
    
    //设置重复次数，0表示不重复
    _loadingImage.animationRepeatCount=100;
    
    return cell1;
    
}

#pragma mark---计算记录的内容
-(void)makeContentView:(UITextView *)contentView andTimeLabel:(UILabel *)timeLabel andDic:(NSDictionary *)dic {
    
    if ([ToolList changeNull:[dic objectForKey:@"content"]].length) {
        
        contentView.text = [dic objectForKey:@"content"];
        
        NSString *motherstr = [dic objectForKey:@"content"];
        NSString * sonstr = @"[";
        NSRange rang = [motherstr rangeOfString:sonstr options:NSBackwardsSearch range:NSMakeRange(0, motherstr.length)];
        
        while  (rang.location != NSNotFound) {
            
            
            EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
            
            NSString *str = [[dic objectForKey:@"content"] substringWithRange:NSMakeRange(rang.location,6)];
            
            emojiTextAttachment.emojiTag = str;
            
            for (int i=0;i<_emojiTags.count;i++) {
                
                if ([[_emojiTags objectAtIndex:i ] isEqualToString:str]) {
                    
                    emojiTextAttachment.image = _emojiImages[(NSUInteger) i]; ;
                }
            }
            
            
            emojiTextAttachment.emojiSize = CGSizeMake(20, 20);
            
            [contentView.textStorage replaceCharactersInRange:NSMakeRange(rang.location,6) withAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]];
            
            NSUInteger start = 0;
            NSUInteger end = rang.location;
            NSRange temp = NSMakeRange(start,end);
            rang =[motherstr rangeOfString:sonstr options:NSBackwardsSearch range:temp];
            
        }
        
        
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [[dic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        CGRect rect = contentView.frame;
        rect.size.height =labelsize.height+10;
        rect.origin.y =timeLabel.frame.origin.y+timeLabel.frame.size.height+10;
        [contentView setFrame:rect];
        
        contentView.editable = NO;
        contentView.scrollEnabled = NO;
        
    }
    
    else{
        
        [contentView setFrame:CGRectMake(0, timeLabel.frame.origin.y+timeLabel.frame.size.height, 0, 0)];
    }
    
}

#pragma mark---语音
-(void)makeYuYinView:(UIView *)yuYinView andcontentL:(UITextView *)contentL andYYbt:(UIButton *)yuYinBt andMiaoL:(UILabel *)miaoL andBT:(UIImageView *)imageBt andDic:(NSDictionary *)dic andIndex:(NSIndexPath *)indexPath{
    
    if ([ToolList changeNull:[dic objectForKey:@"videoURL"]].length) {
        
        int mI = [[dic objectForKey:@"videoLength"] intValue];
        
        yuYinView.frame = CGRectMake(10, contentL.frame.origin.y+contentL.frame.size.height+10, __MainScreen_Width-20, 45);
        
        yuYinBt.tag = indexPath.row;
        miaoL.text = [NSString stringWithFormat:@"%@''",[dic objectForKey:@"videoLength"]];
        yuYinView.hidden = NO;
        imageBt.image = [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"];
        imageBt.frame= CGRectMake(13,15, 11, 15);
        
        if (mI<31) {
            
            yuYinBt.frame= CGRectMake(0, 0, 102, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_0-30.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>30 && mI<61){
            
            yuYinBt.frame= CGRectMake(0, 0, 136, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_31-60.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>60 && mI<91){
            
            yuYinBt.frame= CGRectMake(0, 0, 193, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_61-90.png"] forState:UIControlStateNormal];
            
            
        }else{
            yuYinBt.frame= CGRectMake(0, 0, 241, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_91-120.png"] forState:UIControlStateNormal];
            
        }
        miaoL.frame = CGRectMake(yuYinBt.frame.size.width+5, 12, 42, 21);
        
    }else{
        
        yuYinView.frame =CGRectMake(0, contentL.frame.origin.y+contentL.frame.size.height, 0, 0);
        yuYinView.hidden = YES;
    }
}
#pragma mark---图片
-(void)makeImage:(UIView *)imageV andYuYinV:(UIView *)YuYinV  andDic:(NSDictionary *)dic andIndexpath:(NSIndexPath *)indexpath andHuiFang:(BOOL)isHuiFang{
    
    if ([[dic objectForKey:@"pictureList"] count]) {
        NSArray *urlArr = [dic objectForKey:@"pictureList"];
        
        if ([urlArr count]==1) {
            
            NSDictionary *urlDic = [urlArr objectAtIndex:0];
            
            NSString *urlString = [urlDic objectForKey:@"bigUrlPath"];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            //生成图片
            UIImageView  *urlImage = [[UIImageView alloc]init];
            urlImage.backgroundColor = [UIColor clearColor];
            urlImage.userInteractionEnabled = YES;
            [imageV addSubview:urlImage];
            
            UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
            urlBt.backgroundColor = [UIColor clearColor];
            urlBt.tag = indexpath.row*100;
            if (isHuiFang) {//回访里面的图片处理
                
                [urlBt addTarget:self action:@selector(goBig_Pic:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [urlImage addSubview:urlBt];
            
            [urlImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                float mainFloat =image.size.width>image.size.height?image.size.height:image.size.width;
                
                if (mainFloat>150 || mainFloat == 150) {
                    
                    //宽度长
                    if (image.size.width>image.size.height) {
                        
                        CGSize imagesize = image.size;
                        imagesize.height =150;
                        imagesize.width =(image.size.width *150.0)/mainFloat;
                        //对图片大小进行压缩--
                        //                         image = [self imageWithImage:image scaledToSize:imagesize];
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }else{
                        
                        CGSize imagesize = image.size;
                        imagesize.width =150;
                        imagesize.height =(image.size.height *150.0)/mainFloat;
                        //对图片大小进行压缩--
                        //                         image = [self imageWithImage:image scaledToSize:imagesize];
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }
                    //                     image = [self cutImage:image];
                    image = [ToolList cutImage:image];
                }
                
                else{
                    
#pragma 图片小于300的时候处理
                    urlImage.contentMode = UIViewContentModeScaleAspectFill;
                    urlImage.clipsToBounds = YES;
                    [urlImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"]];
                }
            }];
            
            
            
            imageV.frame = CGRectMake(10, YuYinV.frame.origin.y+YuYinV.frame.size.height+10,150,150);
            
            urlImage.frame = CGRectMake(0, 0, imageV.frame.size.width, imageV.frame.size.height);
            urlBt.frame =CGRectMake(0, 0, urlImage.frame.size.width, urlImage.frame.size.height);
            
            
        }else{//多张图片处理
            
            
            float imageWW = (__MainScreen_Width-26)/3.0;
            
            imageV.frame = CGRectMake(10, YuYinV.frame.origin.y+YuYinV.frame.size.height+10,__MainScreen_Width,(imageWW+3)*((urlArr.count-1)/3)+imageWW);
            
            for (int i=0;i<urlArr.count;i++) {
                
                NSDictionary *dic = [urlArr objectAtIndex:i];
                NSString *smallUrl = [dic objectForKey:@"smallUrlPath"];
                
                
                UIImageView * urlImage1 = [[UIImageView alloc]init];
                urlImage1.backgroundColor = [UIColor clearColor];
                urlImage1.frame = CGRectMake((i%3)*(imageWW+3), i/3 *(imageWW+3), imageWW, imageWW);
                urlImage1.tag = i;
                urlImage1.userInteractionEnabled=YES;
                urlImage1.contentMode = UIViewContentModeScaleAspectFill;
                urlImage1.clipsToBounds = YES;
                NSURL *url =  [NSURL URLWithString:smallUrl];
                [urlImage1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"]];
                [imageV addSubview:urlImage1];
                
                UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
                urlBt.backgroundColor = [UIColor clearColor];
                urlBt.tag = i+100*indexpath.row;
                if (isHuiFang) {//回访里面的图片处理
                    
                    [urlBt addTarget:self action:@selector(goBig_Pic:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                urlBt.frame =CGRectMake(0,0, urlImage1.frame.size.width, urlImage1.frame.size.height);
                [urlImage1 addSubview:urlBt];
            }
            
        }
        
    }else{
        [imageV setFrame:CGRectMake(0, YuYinV.frame.origin.y+YuYinV.frame.size.height, 0, 0)];
    }
}

#pragma mark----回访
-(IBAction)goZan:(UIButton *)sender{
    
    NSDictionary *dic = [_recordArr objectAtIndex:sender.tag-LUN_TAG];
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"other";
    gh.kehuNameStr = [dic objectForKey:@"custName"];
    gh.kehuNameId = [dic objectForKey:@"custId"];
    NSString *str = [dic objectForKey:@"linkManName"];
    gh.lianxirenId = [str substringToIndex:(str.length-11)];
    gh.lianxirenName = [str substringFromIndex:(str.length-10)];
    gh.logId =[dic objectForKey:@"logId"];
    gh.lianxirenId =[dic objectForKey:@"contact"];
    gh.lianxirenName =[dic objectForKey:@"name"];
    gh.isHuiFang = 1;
    gh.chooseId = 0;
    //    _flagRefresh = @"jilu";
    [self.navigationController pushViewController:gh animated:NO];
}

-(void)zanSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if ([_senderbt.currentImage isEqual:[UIImage imageNamed:@"icon_gtjl_zan_s.png"]]) {//取消
            
            [_senderbt setTitleColor:[ToolList getColor:@"929292"] forState:UIControlStateNormal];
            
            [_senderbt setImage:[UIImage imageNamed:@"icon_cz_zan.png"] forState:UIControlStateNormal];
            
            int num = [_senderbt.titleLabel.text intValue];
            
            if (num==1) {
                
                [_senderbt setTitle:@"赞" forState:UIControlStateNormal];
                
                [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:num]];
                
                
            }else{
                
                [_senderbt setTitle:[NSString stringWithFormat:@"%d",num-1] forState:UIControlStateNormal];
                [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:num-1]];
                
            }
            
            
            
            [_zanArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:0]];
            
        }else{//点赞
            
            [_senderbt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [_senderbt setImage:[UIImage imageNamed:@"icon_gtjl_zan_s.png"] forState:UIControlStateNormal];
            
            if ([_senderbt.titleLabel.text isEqualToString:@"赞"]) {
                
                [_senderbt setTitle:@"1" forState:UIControlStateNormal];
                [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:1]];
            }else{
                
                int num = [_senderbt.titleLabel.text intValue];
                
                [_senderbt setTitle:[NSString stringWithFormat:@"%d",num+1] forState:UIControlStateNormal];
                [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:num+1]];
                
            }
            
            
            [_zanArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:1]];
            
        }
        
        
        
    }
    
}

#pragma mark--进入陪访页面
-(IBAction)goWrit:(UIButton *)sender{
    
    NSDictionary *dic = [_recordArr objectAtIndex:sender.tag-LUN_TAG];
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"other";
    gh.kehuNameStr = [dic objectForKey:@"custName"];
    gh.kehuNameId = [dic objectForKey:@"custId"];
    NSString *str = [dic objectForKey:@"linkManName"];
    gh.lianxirenId = [str substringToIndex:(str.length-11)];
   gh.lianxirenName = [str substringFromIndex:(str.length-10)];
    gh.logId =[dic objectForKey:@"logId"];
    gh.lianxirenId =[dic objectForKey:@"contact"];
    gh.lianxirenName =[dic objectForKey:@"name"];
    gh.isHuiFang = 1;
    gh.chooseId = 1;
    //    _flagRefresh = @"jilu";
    [self.navigationController pushViewController:gh animated:NO];
    
}
#pragma mark---回访-点击看大图

-(void)goBig_Pic:(UIButton *)bt{
    
    if (_bigUrlArr==nil) {
        
        _bigUrlArr = [[NSMutableArray alloc]init];
        
    }else{
        
        [_bigUrlArr removeAllObjects];
    }
    
    NSInteger intag = bt.tag/100;
    
    NSDictionary *dic = [_recordArr objectAtIndex:intag];
    NSArray *arr;
    if ([[dic objectForKey:@"callBackMap"] count])
    {
        arr = [[dic objectForKey:@"callBackMap"] objectForKey:@"pictureList"];
        
        for (dic in arr) {
            
            [_bigUrlArr addObject:
             [dic objectForKey:@"bigUrlPath"] ];
        }
        
        CY_photoVc *bigPic = [[CY_photoVc alloc]init];
        bigPic.pArray = _bigUrlArr;
        bigPic.currentPage = bt.tag%100;
        
        [self.navigationController pushViewController:bigPic animated:NO];
    }
    
}

#pragma mark---点击看大图

-(void)goBigPic:(UIButton *)bt{
    
    if (_bigUrlArr==nil) {
        
        _bigUrlArr = [[NSMutableArray alloc]init];
        
    }else{
        
        [_bigUrlArr removeAllObjects];
    }
    
    NSInteger intag = bt.tag/100;
    
    NSDictionary *dic = [_recordArr objectAtIndex:intag];
    
    NSArray * arr = [dic objectForKey:@"pictureList"];
    
    for (dic in arr) {
        
        [_bigUrlArr addObject:[dic objectForKey:@"bigUrlPath"]];
    }
    
    CY_photoVc *bigPic = [[CY_photoVc alloc]init];
    bigPic.pArray = _bigUrlArr;
    bigPic.currentPage = bt.tag%100;
    
    [self.navigationController pushViewController:bigPic animated:NO];
}

#pragma mark--查看详细地址

-(IBAction)touchAdd:(UIButton *)sender{
    
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    CY_popupV *dialogView ;
    if (dialogView == nil) {
        
        dialogView = [[CY_popupV alloc] initWithFrame:CGRectMake(0, 0, 200, 300) andMessage:sender.titleLabel.text];
    }else{
        
        dialogView.hidden = NO;
    }
    
    
    [mainWindow addSubview:dialogView];
}


#pragma 进入单个沟通记录页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSDictionary *dic = [_recordArr objectAtIndex:indexPath.row];
    //    CY_OneRecordVC *oneR = [[CY_OneRecordVC alloc]init];
    //    oneR.dataDic = dic;
    //    oneR.isZan =[[_zanArr objectAtIndex:indexPath.row] intValue];
    //    oneR.zanNum = [[_zanNumArr objectAtIndex:indexPath.row] intValue];
    //    [self.navigationController pushViewController:oneR animated:NO];
    
}

#pragma 缓存语音

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag  {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        //初始化播放
        NSError *playerError;
        audioPlayer = nil;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playerError];
        
        audioPlayer.meteringEnabled = YES;
        audioPlayer.delegate = self;
        [audioPlayer play];
        
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //          [ToolList showRequestFaileMessageLongTime:@"语音下载中..."];
        
        //下载附件
        NSURL *url = [NSURL URLWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        //        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        //已完成下载
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            
            //初始化播放
            NSError *playerError;
            audioPlayer = nil;
            
            audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playerError];
            
            audioPlayer.meteringEnabled = YES;
            audioPlayer.delegate = self;
            [audioPlayer play];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            [ToolList showRequestFaileMessageLongTime:@"语音下载失败！"];
        }];
        
        [operation start];
    }
}

#pragma mark - 回访或陪访播放语音
- (IBAction)bofang_LuYin:(UIButton *)sender
{
    
    NSInteger path = sender.tag;
    NSDictionary *dic = [_recordArr objectAtIndex:path];
    if ([[dic objectForKey:@"callBackMap"] count])
    {
        NSString *urlPath = [[dic objectForKey:@"callBackMap"] objectForKey:@"videoURL"];
        
        NSArray *array = [urlPath componentsSeparatedByString:@"/"];
        [self downloadFileURL:urlPath savePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/cy"] fileName:[array lastObject] tag:_recordArr.count-sender.tag];
        
        
        _loadingImage = (UIImageView *)[sender.superview viewWithTag:143];
        
        [_loadingImage startAnimating];
    }
    
}

#pragma mark-- 播放语音
- (IBAction)bofangLuYin:(UIButton *)sender
{
    
    NSInteger path = sender.tag;
    NSDictionary *dic = [_recordArr objectAtIndex:path];
    NSString *urlPath = [dic objectForKey:@"videoURL"];
    
    NSArray *array = [urlPath componentsSeparatedByString:@"/"];
    [self downloadFileURL:urlPath savePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/cy"] fileName:[array lastObject] tag:_recordArr.count-sender.tag];
    
    
    _loadingImage = (UIImageView *)[sender.superview viewWithTag:143];
    
    [_loadingImage startAnimating];
    
}

#pragma mark --播放音频完成后的回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //成功播放完音频后释放资源
    if ([player isPlaying]) {
        [player stop];
    }
    [_loadingImage stopAnimating];
    
}

-(IBAction)goUserView:(UIButton *)sender{
    
    NSDictionary *dataDic = [_recordArr objectAtIndex:sender.tag-CELL_TAG];
    if ([[dataDic objectForKey:@"custId"]length]) {
        
        UserDetailViewController *userV = [[UserDetailViewController alloc]initwithCust:[dataDic objectForKey:@"custId"]];
        userV.custId = [dataDic objectForKey:@"custId"];
        userV.custNameStr = [dataDic objectForKey:@"custName"];
        [self.navigationController pushViewController:userV animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
