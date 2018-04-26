//
//  CY_tjVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/5/6.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "QFDatePickerView.h"
#import "CY_tjVC.h"
#import "TJViewController.h"
#import "CY_recordVc.h"
#import "AssessmentStandardView.h"
@interface CY_tjVC ()

{
    AssessmentStandardView *asView;
    NSMutableDictionary *requestDic;
    NSDateFormatter *dateFormatter;
    NSString *businessYear;
    NSString *businessMonth;
    NSString *web_url;
    QFDatePickerView *datePickerView;
}


@property (weak, nonatomic) IBOutlet UILabel *wekBL;
@property (weak, nonatomic) IBOutlet UILabel *yueBL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;



@end

@implementation CY_tjVC
#pragma mark - ITAlertBoxDelegate


- (IBAction)help:(id)sender {
    if (asView) {
        [asView removeFromSuperview];
        asView = nil;
    }
           asView = [[[NSBundle mainBundle] loadNibNamed:@"AssessmentStandardView" owner:self options:nil] lastObject];
    asView.web_url = web_url;
    [asView loadUrl];

   [self.view addSubview:asView];
}
- (IBAction)selectDate:(id)sender {

    [datePickerView show];
}

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 0://商务
        {
            [FX_UrlRequestManager postByUrlStr:swworkAccount_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
            break;
        case 1://经理
        {
            [FX_UrlRequestManager postByUrlStr:jlworkAccount_url andPramas:nil andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:NO];
        }
            break;
        case 2://总监
        {
            [FX_UrlRequestManager postByUrlStr:zjworkAccount_url andPramas:nil andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    requestDic = [[NSMutableDictionary alloc] init];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    _top.constant = IOS7_Height;
//    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    //_dateLabel.text = currentDate;
//    businessYear =  [_dateLabel.text substringWithRange:NSMakeRange(0, 4)];
//    businessMonth =  [_dateLabel.text substringWithRange:NSMakeRange(5, 2)];
    
    if(businessYear.length && businessMonth.length)
    {
        [requestDic setObject:businessYear forKey:@"businessYear"];
        [requestDic setObject:businessMonth forKey:@"businessMonth"];
    }
    else
    {
        [requestDic setObject:@"" forKey:@"businessYear"];
        [requestDic setObject:@"" forKey:@"businessMonth"];
    }
     [self addNavgationbar:@"拜访统计" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
  

    
  
}

-(void)requestSuccess:(NSDictionary *)sucDic{
    web_url = [sucDic objectForKey:@"url"];
    _alertLabel.text = [sucDic objectForKey:@"tip"];

    _dateLabel.text = [sucDic objectForKey:@"businessDate"]  ;
    businessYear =  [_dateLabel.text substringWithRange:NSMakeRange(0, 4)];
    if(_dateLabel.text.length == 8)
    {
        businessMonth =  [_dateLabel.text substringWithRange:NSMakeRange(5, 2)];
    }
    else
    {
        businessMonth =  [_dateLabel.text substringWithRange:NSMakeRange(5, 1)];
    }
    datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        //        NSString *string = str;
        //        _dateLabel.text = string;
        businessYear =  [str substringWithRange:NSMakeRange(0, 4)];
        businessMonth =  [str substringWithRange:NSMakeRange(5, 2)];
        [requestDic setObject:businessYear forKey:@"businessYear"];
        [requestDic setObject:businessMonth forKey:@"businessMonth"];
        //商务
        [FX_UrlRequestManager postByUrlStr:swworkAccount_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }andYear:[_dateLabel.text substringWithRange:NSMakeRange(0, 4)] andMonth:[_dateLabel.text substringWithRange:NSMakeRange(5, 2)]andPickFrame:CGRectZero andButtonHiden:(BOOL)NO andSelectdic:nil];
    if ([[sucDic objectForKey:@"code"] intValue]==200) {
        
        if ([[sucDic objectForKey:@"result"] count]) {
            
             _wekBL.text = [NSString stringWithFormat:@"%@",[[sucDic objectForKey:@"result"] objectForKey:@"invalidLogNum"]];
             _yueBL.text = [NSString stringWithFormat:@"%@",[[sucDic objectForKey:@"result"] objectForKey:@"validLogNum"]];
            
            
        }else{
            
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        }
        
    }
    
    
}

//#pragma mark---进入重点跟进跟方案报价页面
//- (IBAction)kehuTouch:(UIButton *)sender {
//   
//    TJViewController *tjV = [[TJViewController alloc]init];
//    tjV.titleStr = sender.currentTitle;
//    [self.navigationController pushViewController:tjV animated:NO];
//}

#pragma mark---进入沟通记录页面
- (IBAction)gtTouch:(UIButton *)sender {
    
      CY_recordVc *recordV = [[CY_recordVc alloc]init];
    recordV.businessYear = businessYear;
    recordV.businessMonth = businessMonth;
    if ([sender.currentTitle isEqualToString:@"待回访"]) {
        recordV.state = @"0";
        
    }else if ([sender.currentTitle isEqualToString:@"有效拜访"]){
        recordV.state = @"3";
    }
        [self.navigationController pushViewController:recordV animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
