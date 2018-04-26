//
//  Select.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/7.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Select.h"
#import "WHC_XMLParser.h"
#import "SelectBtn.h"
#import "FX_Button.h"
#define BTN_H 56
@implementation Select
{
   
    BOOL bool1;
    BOOL bool2;
    BOOL bool3;
    BOOL bool4;
    BOOL bool5;
    BOOL bool6;
    BOOL bool7;
    BOOL bool8;
    BOOL bool9;
    BOOL bool10;
    BOOL bool7_7;
    bool otherBtn;
    float float1;
    float float2;
    float float3;
    float float4;
    float float5;
    float float6;
    float float7;
    float float7_7;
    float float8;
    float float9;
    float float10;
    NSMutableArray *arr_m1;
    NSMutableArray *arr_m2;
    NSMutableArray *arr_m3;
    NSMutableArray *arr_m4;
    NSMutableArray *arr_m5;
    NSMutableArray *arr_m6;
    NSMutableArray *arr_m7;
    NSMutableArray *arr_m7_7;
    NSMutableArray *arr_m8;
    NSMutableArray *arr_m9;
    NSMutableArray *arr_m10;
    NSMutableArray *arr_sheng;
    NSMutableArray *arr_shi;
    NSMutableArray *arr_qu;
    NSMutableArray *arr_market;
    FX_Button *sheng;
    FX_Button *shi;
    FX_Button *market;
    SelectBtn *gw;
    SelectBtn *tg;
    SelectBtn *nsj;
    SelectBtn *clsj;
    SelectBtn *bd;
    SelectBtn *icp;
    SelectBtn *tg_sub;



}
-(void)createView
{
    _shi_h_t.constant = 40;
    _sheng_h_t.constant = 40;
    _qu_h_t.constant = 40;
    _view1.hidden = NO;
//    NSURL *xmlFilePath = [[NSBundle mainBundle] URLForResource:@"area2.0.xml" withExtension:nil];
//    NSData *xmlData = [NSData dataWithContentsOfURL:xmlFilePath options:NSDataReadingUncached error:NULL];
//    
//    NSDictionary *dict = [[WHC_XMLParser dictionaryForXMLData:xmlData] objectForKey:@"china"];
//    _provinceS = [dict objectForKey:@"province"];
    _scBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self creatmarket];
    
    //行业
    
    for (int i = 0; i < _industryclassBig.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[_industryclassBig objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(hangyeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [arr_m2 addObject:btn];
        [_view2 addSubview:btn];
    }
    
    self.h2.constant = BTN_H*_industryclassBig.count;
    float2 = _h2.constant;
    
    
    for (int i = 0; i < _registerPeopleNum.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[_registerPeopleNum objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(guimoClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view3 addSubview:btn];
        [arr_m3 addObject:btn];
        
    }
    
    self.h3.constant = BTN_H*_registerPeopleNum.count;
    float3 = _h3.constant;
    
    //注册资金
    for (int i = 0; i < _registerMoney.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[_registerMoney objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(zczjClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view4 addSubview:btn];
        [arr_m4 addObject:btn];
        
    }
    
    self.h4.constant = BTN_H*_registerMoney.count;
    float4 = _h4.constant;
    
    //成立时间
    
    for (int i = 0; i < _createTime.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[_createTime objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(clsjClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view5 addSubview:btn];
        [arr_m5 addObject:btn];
        
    }
    
    self.h5.constant = BTN_H*_createTime.count;
    float5 = _h5.constant;
    
    //有无官网
    NSDictionary *dic1 = @{@"name":@"不限",@"id":@"3"};
    NSDictionary *dic2 = @{@"name":@"有",@"id":@"1"};
    NSDictionary *dic3 = @{@"name":@"无",@"id":@"0"};
    NSArray *arr_gw = @[dic1,dic2,dic3];
    for (int i = 0; i < arr_gw.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[arr_gw objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(gwClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view6 addSubview:btn];
        [arr_m6 addObject:btn];
        
    }
    
    self.h6.constant = BTN_H*arr_gw.count;
    float6 = _h6.constant;
    
    //有无推广
    NSDictionary *dic22 = @{@"name":@"有",@"id":@"1"};
    NSDictionary *dic33 = @{@"name":@"无",@"id":@"0"};
    NSArray *arr_gw1 = @[dic33,dic22];
    
    for (int i = 0; i < arr_gw1.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[arr_gw1 objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(tgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view7 addSubview:btn];
        [arr_m7 addObject:btn];
        
    }
    
    self.h7.constant = BTN_H*arr_gw1.count;
    float7 = _h7.constant;
    
    for (int i = 0; i < _channeList.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[_channeList objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(tgSubClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tuiSubView addSubview:btn];
        [arr_m7_7 addObject:btn];
        
    }
    
    self.tuiSubView_h.constant = BTN_H*_channeList.count;
    float7_7 = _tuiSubView_h.constant;
    
    //是否新数据
    NSDictionary *dic111 = @{@"name":@"不限",@"id":@"3"};
    NSDictionary *dic222 = @{@"name":@"是",@"id":@"1"};
    NSDictionary *dic333 = @{@"name":@"否",@"id":@"0"};
    NSArray *arr11 = @[dic111,dic222,dic333];
    for (int i = 0; i < arr11.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[arr11 objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(nsjClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_view8 addSubview:btn];
        [arr_m8 addObject:btn];
        
    }
    
    self.h8.constant = BTN_H*arr11.count;
    float8 = _h8.constant;
    
    //baidu
    
    for (int i = 0; i < _baiduExponent.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[_baiduExponent objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(baiduClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_baiduView addSubview:btn];
        [arr_m9 addObject:btn];
        
    }
    
    self.baiduView_h.constant = BTN_H*_baiduExponent.count;
    float9 = _baiduView_h.constant;
    
    //icp
    
    for (int i = 0; i < _icpDateFilter.count; i ++)
    {
        SelectBtn *btn = [[SelectBtn alloc] initWithFrame:CGRectMake(0, BTN_H*i, __MainScreen_Width, BTN_H) andDic:[_icpDateFilter objectAtIndex:i]];
        btn.tag = i;
        btn.isSelect = NO;
        [btn addTarget:self action:@selector(icpClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_ICPView addSubview:btn];
        [arr_m10 addObject:btn];
        
    }
    
    self.ICPView_h.constant = BTN_H*_icpDateFilter.count;
    float10 = _ICPView_h.constant;
    
    _h1.constant = 0;
    _h2.constant = 0;
    _h3.constant = 0;
    _h4.constant = 0;
    _h5.constant = 0;
    _h6.constant = 0;
    _h7.constant = 0;
    _h8.constant = 0;
    _baiduView_h.constant = 0;
    _ICPView_h.constant = 0;
    _tuiSubView_h.constant = 0;
    _view1.hidden = YES;
    _view2.hidden = YES;
    _view3.hidden = YES;
    _view4.hidden = YES;
    _view5.hidden = YES;
    _view6.hidden = YES;
    _view7.hidden = YES;
    _view8.hidden = YES;
    _tuiSubView.hidden = YES;
    _baiduView.hidden = YES;
    _ICPView.hidden = YES;

}
-(void)awakeFromNib
{
    [super awakeFromNib];
    arr_m1 = [[NSMutableArray alloc] init];
    arr_m2 = [[NSMutableArray alloc] init];
    arr_m3 = [[NSMutableArray alloc] init];
    arr_m4 = [[NSMutableArray alloc] init];
    arr_m5 = [[NSMutableArray alloc] init];
    arr_m6 = [[NSMutableArray alloc] init];
    arr_m7 = [[NSMutableArray alloc] init];
    arr_m7_7 = [[NSMutableArray alloc] init];
    arr_m8 = [[NSMutableArray alloc] init];
    arr_m9 = [[NSMutableArray alloc] init];
    arr_m10 = [[NSMutableArray alloc] init];
    arr_sheng = [[NSMutableArray alloc] init];
    arr_shi = [[NSMutableArray alloc] init];
    arr_qu = [[NSMutableArray alloc] init];
    arr_market =[[NSMutableArray alloc] init];
    
    _screen_w.constant = __MainScreen_Width;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)hangyeClicked:(SelectBtn *)btn
{
    NSLog(@"%ld",btn.tag);
    btn.isSelect = !btn.isSelect;
    [btn changeSelect];
}
-(void)guimoClicked:(SelectBtn *)btn
{
    NSLog(@"%@",btn.myDic);
    btn.isSelect = !btn.isSelect;
    [btn changeSelect];
}
-(void)zczjClicked:(SelectBtn *)btn
{
    NSLog(@"%ld",btn.tag);
    btn.isSelect = !btn.isSelect;
    [btn changeSelect];
}
-(void)clsjClicked:(SelectBtn *)btn
{
    NSLog(@"%ld",btn.tag);
    clsj = btn;
    for (SelectBtn *b in arr_m5) {
        if(b == btn)
        {
            b.isSelect = YES;
        }
        else
        {
            b.isSelect = NO;
        }
        [b changeSelect];
    }
}
-(void)gwClicked:(SelectBtn *)btn
{
  
    gw = btn;
    for (SelectBtn *b in arr_m6) {
        if(b == btn)
        {
            b.isSelect = YES;
        }
        else
        {
            b.isSelect = NO;
        }
         [b changeSelect];
    }
}
-(void)baiduClicked:(SelectBtn *)btn
{
    bd = btn;
    for (SelectBtn *b in arr_m9) {
        if(b == btn)
        {
            b.isSelect = YES;
        }
        else
        {
            b.isSelect = NO;
        }
        [b changeSelect];
    }
}
-(void)icpClicked:(SelectBtn *)btn
{
    icp = btn;
    for (SelectBtn *b in arr_m10) {
        if(b == btn)
        {
            b.isSelect = YES;
        }
        else
        {
            b.isSelect = NO;
        }
        [b changeSelect];
    }
}
-(void)tgSubClicked:(SelectBtn *)btn
{
    btn.isSelect = !btn.isSelect;
    [btn changeSelect];
}
-(void)tgClicked:(SelectBtn *)btn
{
    
    for (SelectBtn *b in arr_m7) {
        if(b == btn)
        {
            b.isSelect = YES;
        }
        else
        {
            b.isSelect = NO;
        }
        [b changeSelect];
    }
    //有推广
    if([[btn.myDic objectForKey:@"id"] intValue] == 1)
    {
        tg = btn;
        _tuiSubView_h.constant = float7_7;
        _tuiSubView.hidden = NO;
    }
    else//无推广
    {
        tg = btn;
        _tuiSubView_h.constant = 0;
        _tuiSubView.hidden = YES;
    }
}
-(void)nsjClicked:(SelectBtn *)btn
{
    
    nsj = btn;
    for (SelectBtn *b in arr_m8) {
        if(b == btn)
        {
            b.isSelect = YES;
        }
        else
        {
            b.isSelect = NO;
        }
        [b changeSelect];
    }
}
#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];

    if ([str isEqualToString:@"market"]) {
        for (FX_Button *bt in arr_market)
        {
            if( btn==bt)
            {
                market = bt;
                [bt changeColorCliked1:YES];
            
                [self creatSheng:btn.tag-1199];
           
            }
            else
            {
                [bt changeColorCliked1:NO];
                
            }
            
        }
    }
    
    else if([str isEqualToString:@"sheng"])
{
    for (FX_Button *bt in arr_sheng)
    {
        if( btn==bt)
        {
            [bt changeColorCliked1:YES];
            sheng = btn;
            
              id city1 = [dic1 objectForKey:@"cityList"];
            
            if ([city1 isKindOfClass:[NSArray class]]) {
                
                _cityS =[dic1 objectForKey:@"cityList"];
                
            }
            else if ([city1 isKindOfClass:[NSDictionary class]]){
                
                NSDictionary *cdict = [dic1 objectForKey:@"cityList"];
                
                NSArray *cityArr = [[NSArray alloc]initWithObjects:cdict,nil];
                
                _cityS =cityArr;
            }
//            cityS = [dic1 objectForKey:@"city"];
            //建市
//            if(cityS.count>3)
//            {
                _shi_h_t.constant = 40;
               [self createShi];
//            }
           
//            //建区
//            else
//            {
//                [arr_qu removeAllObjects];
//                _shi_h_t.constant = 0;
//                _shi_h.constant = 0;
//                areas = [(NSDictionary *)cityS objectForKey:@"area"];
//                if([areas isKindOfClass:[NSDictionary class]])
//                {
//                    areas = @[areas];
//                }
//                for (UIView *sub in _view_Shi.subviews) {
//                    [sub removeFromSuperview];
//                }
//                [self createQu];
//            }
        }
        else
        {
            [bt changeColorCliked1:NO];
            
        }
        
    }
}
    else if ([str isEqualToString:@"shi"])
    {
        
        
        for (FX_Button *bt in arr_shi)
        {
            if( btn==bt)
            {
                [bt changeColorCliked1:YES];
                shi = btn;
//                areas = [dic1 objectForKey:@"area"];
                
                id city1 = [dic1 objectForKey:@"areaList"];
                
                if ([city1 isKindOfClass:[NSArray class]]) {
                    
                    _areas =[dic1 objectForKey:@"areaList"];
                    
                }
                else if ([city1 isKindOfClass:[NSDictionary class]]){
                    
                    NSDictionary *cdict = [dic1 objectForKey:@"areaList"];
                    
                    NSArray *cityArr = [[NSArray alloc]initWithObjects:cdict,nil];
                    
                    _areas =cityArr;
                }

                
                [arr_qu removeAllObjects];

                [self createQu];

            }
            else
            {
                [bt changeColorCliked1:NO];
                
            }
            
        }
        
        
        
    }
    else if ([str isEqualToString:@"qu"])
    {
        if([arr_qu indexOfObject:btn]==NSNotFound)
        {
            [arr_qu addObject:btn];
            [btn changeColorCliked1:YES];

        }
        else
        {
            [arr_qu removeObject:btn];
            [btn changeColorCliked1:NO];

        }
    }

}
- (IBAction)otherBtnClicked:(id)sender {
    otherBtn = !otherBtn;
    if(otherBtn)
    {
        self.btn2.hidden = NO;
        self.btn3.hidden = NO;
        self.btn4.hidden = NO;
        self.btn5.hidden = NO;
        self.btn6.hidden = NO;
        self.btn7.hidden = NO;
        self.hide1.hidden = NO;
        self.baidu.hidden = NO;
        self.ICP.hidden = NO;
        self.btn_h2.constant = 54;
        self.btn_h3.constant = 54;
        self.btn_h4.constant = 54;
        self.btn_h5.constant = 54;
        self.btn_h6.constant = 54;
        self.btn_h7.constant = 54;
        self.baidu_h.constant = 54;
        self.ICP_h.constant = 54;
        self.h_8.constant = 54;
//        self.h1.constant = float1;
//        self.view1.hidden = NO;
//        self.view2.hidden = NO;
//        self.view3.hidden = NO;
//        self.view4.hidden = NO;
//        self.view5.hidden = NO;
//        self.view6.hidden = NO;
//        self.view7.hidden = NO;
//        self.baiduView.hidden = NO;
//        self.ICPView.hidden = NO;
//        self.tuiSubView.hidden = NO;
//        self.h2.constant = float2;
//        self.h3.constant = float3;
//        self.h4.constant = float4;
//        self.h5.constant = float5;
//        self.h6.constant = float6;
//        self.h7.constant = float7;
//        self.baiduView_h.constant = float9;
//        self.tuiSubView_h.constant = float7_7;
//        self.ICPView_h.constant = float10;

    }
    else
    {
        self.btn2.hidden = YES;
        self.btn3.hidden = YES;
        self.btn4.hidden = YES;
        self.btn5.hidden = YES;
        self.btn6.hidden = YES;
        self.btn7.hidden = YES;
        self.hide1.hidden = YES;
        self.baidu.hidden = YES;
        self.ICP.hidden = YES;
//        self.view1.hidden = YES;
        self.view2.hidden = YES;
        self.view3.hidden = YES;
        self.view4.hidden = YES;
        self.view5.hidden = YES;
        self.view6.hidden = YES;
        self.view7.hidden = YES;
        self.baiduView.hidden = YES;
        self.ICPView.hidden = YES;
        self.tuiSubView.hidden = YES;
        
//        self.h1.constant = 0;
        self.btn_h2.constant = 0;
        self.btn_h3.constant = 0;
        self.btn_h4.constant = 0;
        self.btn_h5.constant = 0;
        self.btn_h6.constant = 0;
        self.btn_h7.constant = 0;
        self.baidu_h.constant = 0;
        self.ICP_h.constant = 0;
        self.h_8.constant = 0;
        self.h2.constant = 0;
        self.h3.constant = 0;
        self.h4.constant = 0;
        self.h5.constant = 0;
        self.h6.constant = 0;
        self.h7.constant = 0;
        self.baiduView_h.constant = 0;
        self.tuiSubView_h.constant = 0;
        self.tuiSubView_h.constant = 0;

        
        
    }
}
-(void)createQu
{
    for (UIView *sub in _view_Qu.subviews) {
        [sub removeFromSuperview];
    }
    for (int i = 0; i < _areas.count; i ++ ) {
        
        NSDictionary *dic = [_areas objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(10+(i%4)*((__MainScreen_Width-50)/4+10) ,44*(i/4), (__MainScreen_Width-50)/4, 34) andType:@"12" andTitle:@"qu" andTarget:self andDic:dic];
        [_view_Qu addSubview:btn];
    }
    _qu_h.constant = _areas.count%4==0?(_areas.count/4)*44:(_areas.count/4+1)*44;
    _h1.constant = 120+_sheng_h.constant+_shi_h.constant+_qu_h.constant+_shi_h_t.constant+_view_city_h.constant;
}
-(void)createShi
{
    _qu_h.constant = 0;
    for (UIView *sub in _view_Shi.subviews) {
        [sub removeFromSuperview];
    }
    for (int i = 0; i < _cityS.count; i ++ ) {
        
        NSDictionary *dic = [_cityS objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(10+(i%4)*((__MainScreen_Width-50)/4+10) ,44*(i/4), (__MainScreen_Width-50)/4, 34) andType:@"12" andTitle:@"shi" andTarget:self andDic:dic];
        [_view_Shi addSubview:btn];
        [arr_shi addObject:btn];

    }
    _shi_h.constant = _cityS.count%4==0?(_cityS.count/4)*44:(_cityS.count/4+1)*44;
    _h1.constant = 160+_sheng_h.constant+_shi_h.constant+_view_city_h.constant;
  
}

-(void)creatmarket{
    
    _shi_h.constant = 0;
    _qu_h.constant = 0;
    _sheng_h.constant = 0;
    
    for (int j=0; j<_markets.count; j++) {
        
        NSDictionary *dic = [_markets objectAtIndex:j];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(10+(j%4)*((__MainScreen_Width-50)/4+10) ,44*(j/4), (__MainScreen_Width-50)/4, 34) andType:@"12" andTitle:@"market" andTarget:self andDic:dic];
        btn.tag = 1199+j;
        [arr_market addObject:btn];
        [_view_city addSubview:btn];
    }
    _view_city_h.constant =_markets.count%4==0?(_markets.count/4)*44:(_markets.count/4+1)*44;
    _h1.constant = 160+_view_city_h.constant;
    float1 = _h1.constant;
}

-(void)creatSheng:(NSInteger)indexpath
{
    _shi_h.constant = 0;
    _qu_h.constant = 0;
    _provinceS = [[_markets objectAtIndex:indexpath] objectForKey:@"provinceList"];
    
    for (UIView *sub in _view_Sheng.subviews) {
        [sub removeFromSuperview];
    }
    for (UIView *sub1 in _view_Shi.subviews) {
        
         [sub1 removeFromSuperview];
    }
    for (UIView *sub2 in _view_Qu.subviews) {
        
        [sub2 removeFromSuperview];
    }
    
    for (int i = 0; i < _provinceS.count; i ++ ) {
        
        NSDictionary *dic = [_provinceS objectAtIndex:i];
        
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake(10+(i%4)*((__MainScreen_Width-50)/4+10) ,44*(i/4), (__MainScreen_Width-50)/4, 34) andType:@"12" andTitle:@"sheng" andTarget:self andDic:dic];
        [arr_sheng addObject:btn];
        [_view_Sheng addSubview:btn];
    }
    _sheng_h.constant =_provinceS.count%4==0?(_provinceS.count/4)*44:(_provinceS.count/4+1)*44;
    _h1.constant = 160+_sheng_h.constant+_view_city_h.constant;
    float1 = _h1.constant;
}
- (IBAction)clicked:(id)sender {
    UIButton *btn = sender;
    switch (btn.tag) {
            //省市区
        case 1:
        {
            bool1 = !bool1;
            if(bool1)
            {
                _h1.constant = float1;
                _view1.hidden = NO;
            }
            else
            {
                _h1.constant = 0;
                _view1.hidden = YES;
            }
            break;
        }
            //行业
        case 2:
        {
            bool2 = !bool2;
            if(bool2)
            {
                _h2.constant = float2;
                _view2.hidden = NO;
            }
            else
            {
                _h2.constant = 0;
                _view2.hidden = YES;
            }
            break;
        }
            //规模
        case 3:
        {
            bool3 = !bool3;
            if(bool3)
            {
                _h3.constant = float3;
                _view3.hidden = NO;
            }
            else
            {
                _h3.constant = 0;
                _view3.hidden = YES;
            }
            break;
        }
            //注册资金
        case 4:
        {
            bool4 = !bool4;
            if(bool4)
            {
                _h4.constant = float4;
                _view4.hidden = NO;
            }
            else
            {
                _h4.constant = 0;
                _view4.hidden = YES;
            }
            break;
        }
            //成立时间
        case 5:
        {
            bool5 = !bool5;
            if(bool5)
            {
                _h5.constant = float5;
                _view5.hidden = NO;
            }
            else
            {
                _h5.constant = 0;
                _view5.hidden = YES;
            }
            break;
        }
            //有无官网
        case 6:
        {
            bool6 = !bool6;
            if(bool6)
            {
                _h6.constant = float6;
                _view6.hidden = NO;
            }
            else
            {
                _h6.constant = 0;
                _view6.hidden = YES;
            }
            break;
        }
            //有无推广
        case 7:
        {
            bool7 = !bool7;
            if(bool7)
            {
                _h7.constant = float7;
                _view7.hidden = NO;
                _tuiSubView_h.constant = float7_7;
                _tuiSubView.hidden = NO;
            }
            else
            {
                _h7.constant = 0;
                _view7.hidden = YES;
                _tuiSubView_h.constant = 0;
                _tuiSubView.hidden = YES;
            }
            break;
        }
            //是否新数据
        case 8:
        {
            bool8 = !bool8;
            if(bool8)
            {
                _h8.constant = float8;
                _view8.hidden = NO;
            }
            else
            {
                _h8.constant = 0;
                _view8.hidden = YES;
            }
            break;
        }
            //baidu
        case 9:
        {
            bool9 = !bool9;
            if(bool9)
            {
                _baiduView_h.constant = float9;
                _baiduView.hidden = NO;
            }
            else
            {
                _baiduView_h.constant = 0;
                _baiduView.hidden = YES;
            
            }
            break;
        }
        case 10:
        {
            bool10 = !bool10;
            if(bool10)
            {
                _ICPView_h.constant = float10;
                _ICPView.hidden = NO;
            }
            else
            {
                _ICPView_h.constant = 0;
                _ICPView.hidden = YES;
                
            }
            break;
        }
        default:
            break;
    }
}
- (IBAction)finish:(id)sender {
  
   NSString * type_str = @"";
    if ([[[market.dic objectForKey:@"data"]objectForKey:@"code"]length]) {
        
           type_str = [[market.dic objectForKey:@"data"] objectForKey:@"code"];
    }
    
    for (FX_Button *btn in arr_qu) {
        NSLog(@"%@-%@-%@",[[sheng.dic objectForKey:@"data"] objectForKey:@"name"],[[shi.dic objectForKey:@"data"] objectForKey:@"name"],[[btn.dic objectForKey:@"data"] objectForKey:@"name"]);
        
    }
    NSString *custAddressProvince = @"";
    if([[[sheng.dic objectForKey:@"data"] objectForKey:@"code"] length])
    {
        custAddressProvince = [[sheng.dic objectForKey:@"data"] objectForKey:@"code"];
    }
    NSString *custAddressCity = @"";
    if([[[shi.dic objectForKey:@"data"] objectForKey:@"code"] length])
    {
        custAddressCity = [[shi.dic objectForKey:@"data"] objectForKey:@"code"];
    }
   
    NSMutableString *custAddressRegion = [NSMutableString stringWithString:@""];
    if(arr_qu.count)
    {
        for (FX_Button *btn in arr_qu) {
           
            [custAddressRegion appendString:[NSString stringWithFormat:@"%@",[[btn.dic objectForKey:@"data"] objectForKey:@"code"]]];
        }
 
    }
    NSMutableString *industryClassBig = [NSMutableString stringWithString:@""];
    if(arr_m2.count)
    {
    for (SelectBtn *btn in arr_m2) {
        if(btn.isSelect)
        {
        [industryClassBig appendString:[NSString stringWithFormat:@"%@,",[btn.myDic objectForKey:@"id"]]];
        }
    }
    }
    
    
    NSMutableString *custRegisterPeopleNumberType = [NSMutableString stringWithString:@""];
    if(arr_m3.count)
    {
        for (SelectBtn *btn in arr_m3) {
            if(btn.isSelect)
            {
                [custRegisterPeopleNumberType appendString:[NSString stringWithFormat:@"%@,",[btn.myDic objectForKey:@"id"]]];
            }
        }
    }
    NSMutableString *channelDetail = [NSMutableString stringWithString:@""];
    if(arr_m7_7.count)
    {
        for (SelectBtn *btn in arr_m7_7) {
            if(btn.isSelect)
            {
                [channelDetail appendString:[NSString stringWithFormat:@"%@,",[btn.myDic objectForKey:@"id"]]];
            }
        }
    }
    
    NSMutableString *custRegisterMoneyType = [NSMutableString stringWithString:@""];
    if(arr_m4.count)
    {
        for (SelectBtn *btn in arr_m4) {
            if(btn.isSelect)
            {
                [custRegisterMoneyType appendString:[NSString stringWithFormat:@"%@,",[btn.myDic objectForKey:@"id"]]];
            }
        }
    }
    NSString *createTime = @"";
    if([[clsj.myDic objectForKey:@"id"]  length])
    {
        createTime = [clsj.myDic objectForKey:@"id"];
    }
    NSString *homepageHint = @"3";
    if([[gw.myDic objectForKey:@"id"]  length])
    {
        homepageHint = [gw.myDic objectForKey:@"id"];
    }
    NSString *channelNumber  = @"3";
    if([[tg.myDic objectForKey:@"id"]  length])
    {
        channelNumber = [tg.myDic objectForKey:@"id"];
    }
    NSString *isNewCust   = @"3";
    if([[nsj.myDic objectForKey:@"id"]  length])
    {
        isNewCust   = [nsj.myDic objectForKey:@"id"];
    }
    
    NSString *baiduExponent = @"0";
    if([[bd.myDic objectForKey:@"name"]  length])
    {
        baiduExponent = [bd.myDic objectForKey:@"id"];
    }
    NSString *ICPDateFilter = @"0";
    if([[icp.myDic objectForKey:@"name"]  length])
    {
        ICPDateFilter = [icp.myDic objectForKey:@"id"];
    }
    int type_int = 1;
    if (type_str.length) {
         type_int = [type_str intValue];
    }
   
    NSDictionary *dic = @{@"custAddressProvince":custAddressProvince,@"custAddressCity":custAddressCity,@"custAddressRegion":custAddressRegion,@"industryClassBig":industryClassBig,@"custRegisterPeopleNumberType":custRegisterPeopleNumberType,@"custRegisterMoneyType":custRegisterMoneyType,@"createTime":createTime,@"homepageHint":homepageHint,@"channelNumber":channelNumber,@"isNewCust":isNewCust,@"channelDetail":channelDetail,@"baiduExponent":baiduExponent,@"ICPDateFilter":ICPDateFilter,@"channelDetail":channelDetail,@"type":[NSNumber numberWithInt:type_int]};
    
    
    self.czDicBlock(dic);
    [self removeFromSuperview];


}
- (IBAction)cancel:(id)sender {
    NSDictionary *dic = @{};
    self.czDicBlock(dic);
    [self removeFromSuperview];

}

@end
