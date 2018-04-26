//
//  YixiangDetailViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/25.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "YixiangDetailViewController.h"
#import "AlertWhyViewController.h"
#import "AlertSalersViewController.h"
#import "CY_addClientVc.h"

@interface YixiangDetailViewController ()
{
    __weak IBOutlet NSLayoutConstraint *doView_h;
    //放弃按钮
    UIButton *fangQiBtn;
    //分配按钮
    UIButton *fenPeiBtn;
    __weak IBOutlet NSLayoutConstraint *top_h;
}
@end

@implementation YixiangDetailViewController
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark - 分配客户成功
-(void)intentCust:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue] == 200)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark - 点击分配
-(void)fenPeiBtnClicked:(UIButton *)btn
{
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            
        }
            break;
            
        case 1://经理
        {
            AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
            dd.selectOKBlock = ^(NSString *salerId)
            {
                NSDictionary *dic  = @{@"intentCustId":[_dataDic objectForKey:@"IntentCustId"],@"salerId":salerId};
                [FX_UrlRequestManager postByUrlStr:IntentCust_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
            };
            [self.navigationController pushViewController:dd animated:NO];
            
        }
            break;
        case 2://总监
        {
            AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
            dd.selectOKBlock = ^(NSString *salerId)
            {
                NSDictionary *dic  = @{@"intentCustId":[_dataDic objectForKey:@"IntentCustId"],@"deptId":salerId};
                [FX_UrlRequestManager postByUrlStr:ZJassignIntentCust_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"intentCust:" andFaild:nil andIsNeedCookies:YES];
            };
            [self.navigationController pushViewController:dd animated:NO];
        }
            break;
            
            
            
        default:
            break;
    }
    
}

#pragma mark - 点击放弃
-(void)fangQiBtnClicked:(UIButton *)btn
{
    
    [FX_UrlRequestManager postByUrlStr:ReleseCustReason_url andPramas:nil andDelegate:self andSuccess:@"ReleseCustReason:" andFaild:nil andIsNeedCookies:NO];
}
#pragma mark - 释放理由查询成功
-(void)ReleseCustReason:(NSDictionary *)dic
{
    
    AlertWhyViewController *dd = [[AlertWhyViewController alloc] init];
    dd.IntentCustId = [_dataDic objectForKey:@"IntentCustId"];
    [dd startTable:[dic objectForKey:@"result"]];
    dd.isNeedOther = NO;
    [self.navigationController pushViewController:dd animated:NO];
    
    
}
#pragma mark - 点击保护
-(void)baoHuBtnClicked:(UIButton *)btn{
    
    CY_addClientVc *ghVC = [[CY_addClientVc alloc]init];
    ghVC.automaticallyAdjustsScrollViewInsets = NO;
    ghVC.comString = [_dataDic objectForKey:@"companyname"];
    ghVC.dataDic = _dataDic;
    ghVC.isYiBool = YES;
    [self.navigationController pushViewController:ghVC animated:NO];    
}

-(void)bb
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    doView_h.constant = 0;
    top_h.constant = __MainScreen_Width;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bb) name:@"FANGQIOK" object:nil];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    NSMutableString *desContent = [[NSMutableString alloc] init];

    for (NSString *ss in [_dataDic objectForKey:@"remind"]) {
        [desContent appendString:[NSString stringWithFormat:@"%@\n",ss]];
    }

    CGSize  size = [desContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(__MainScreen_Width-86, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
    _cui_h.constant=size.height+10;//获取自适应文本内容高度
    _cuiTextView.text = desContent;
    
    
    CGSize  size1 = [[_dataDic objectForKey:@"memo"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(__MainScreen_Width-86, 2000) lineBreakMode:UILineBreakModeWordWrap];
    
    _beizhu_h.constant=size1.height+10>_beizhu_h.constant?size1.height+10:_beizhu_h.constant;//获取自适应文本内容高度
    _beizhu_L.text = [_dataDic objectForKey:@"memo"];
    switch (isSW.intValue) {
        case 0://商务
        {
              [self makeSW];
        }
            break;
            
        case 1://经理
        {
             [self makeJL];
            
        }
            break;
        case 2://总监
        {
             [self makeJL];
        }
            break;
            
            
            
        default:
            break;
    }

  
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];    
  
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

}

#pragma mark - 商务页面搭建
-(void)makeSW{
    
    _bottom_h.constant = __MainScreen_Height * 0.08;
    
    if([[_dataDic objectForKey:@"flag"] intValue] == 1)
    {
        _imageView_ji.hidden = NO;
    }
    else
    {
        _imageView_ji.hidden = YES;
    }
     _content_L.hidden = YES;
    
//    _tel_Bt.hidden = NO;
    
//     [_tel_Bt.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 8) toPoint:CGPointMake(0, 36) andWeight:1 andColorString:@"e7e7eb"]];
    
    //加判断
    fangQiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fangQiBtn setTitle:@"放弃" forState:UIControlStateNormal];
    fangQiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fangQiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fangQiBtn.backgroundColor = [UIColor clearColor];
    fangQiBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [fangQiBtn addTarget:self action:@selector(fangQiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fangQiBtn setImage:[UIImage imageNamed:@"icon_cz_fangqi.png"] forState:UIControlStateNormal];
    [fangQiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [_bottom_DoView addSubview:fangQiBtn];
    [_bottom_DoView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(__MainScreen_Width, 1) andWeight:1 andColorString:@"e7e7eb"]];
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"保护" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [fenPeiBtn addTarget:self action:@selector(baoHuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [_bottom_DoView addSubview:fenPeiBtn];
    [_bottom_DoView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, 46 - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    _custName_top.text = [_dataDic objectForKey:@"orderId"];
    _custName.text = [_dataDic objectForKey:@"companyname"];
    _linkMan_L.text = [_dataDic objectForKey:@"linkManName"];
    _phone_L.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"mobile"]];
    if (_phone_L.text.length==0) {
        
        _tel_Bt.hidden = YES;
    }else{
        _tel_Bt.hidden = NO;
    }
    _address_L.text = [_dataDic objectForKey:@"address"];
    _mail_L.text = [_dataDic objectForKey:@"mail"];
    _need_l.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"demandSource"]];
    _qq_L.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"qq"]];
    _zuoji_L.text = [_dataDic objectForKey:@"tel"];
    _laiYun.text =[_dataDic objectForKey:@"source"];
    _shiFang.text =[_dataDic objectForKey:@"reason"];

    if (_zuoji_L.text.length==0) {
        
        _zuoji_B.hidden = YES;
    }else{
         _zuoji_B.hidden = NO;
    }
}

#pragma mark - 经理页面搭建
-(void)makeJL{
    
    _bottom_h.constant = __MainScreen_Height * 0.08;
    
    if([[_dataDic objectForKey:@"flag"] intValue] == 1)
    {
        _imageView_ji.hidden = NO;
    }
    else
    {
        _imageView_ji.hidden = YES;
    }
    
     _tel_Bt.hidden = YES;
     _zuoji_B.hidden = YES;
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    if(isSW.intValue == 1 || isSW.intValue == 2)
    {
        //加判断
        fangQiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fangQiBtn setTitle:@"放弃" forState:UIControlStateNormal];
        fangQiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [fangQiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        fangQiBtn.backgroundColor = [UIColor clearColor];
        fangQiBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
        [fangQiBtn addTarget:self action:@selector(fangQiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [fangQiBtn setImage:[UIImage imageNamed:@"icon_cz_fangqi.png"] forState:UIControlStateNormal];
        [fangQiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [_bottom_DoView addSubview:fangQiBtn];
        [_bottom_DoView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(__MainScreen_Width, 1) andWeight:1 andColorString:@"e7e7eb"]];
        fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
        fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        fenPeiBtn.backgroundColor = [UIColor clearColor];
        fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
        [fenPeiBtn addTarget:self action:@selector(fenPeiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
        [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [_bottom_DoView addSubview:fenPeiBtn];
        [_bottom_DoView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, 46 - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
        _custName_top.text = [_dataDic objectForKey:@"orderId"];
        _content_L.text = [_dataDic objectForKey:@"followFlag"];
        
        if([[_dataDic objectForKey:@"assignFlag"] isEqualToString:@"未分配"])
        {
            _content_L.hidden = YES;
        }
        else
        {
            _bottom_DoView.hidden = YES;
        }
        
   
    }
    
   
    _custName.text = [_dataDic objectForKey:@"companyname"];
    _linkMan_L.text = [_dataDic objectForKey:@"linkManName"];
    _phone_L.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"mobile"]];
    _address_L.text = [_dataDic objectForKey:@"address"];
    _mail_L.text = [_dataDic objectForKey:@"mail"];
    _need_l.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"demandSource"]];
    _qq_L.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"qq"]];
    _zuoji_L.text = [_dataDic objectForKey:@"tel"];
    _laiYun.text =[_dataDic objectForKey:@"source"];
    _shiFang.text =[_dataDic objectForKey:@"reason"];
    
}
- (IBAction)callMe1:(id)sender
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_zuoji_L.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(IBAction)cellMe:(UIButton *)sender{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_phone_L.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
