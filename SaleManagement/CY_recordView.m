//
//  CY_recordView.m
//  SaleManagement
//
//  Created by chaiyuan on 2017/2/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "CY_recordView.h"
#import "promptVc.h"
#import "CY_popupV.h"
#import "New_ShouCangDetailMore.h"

@interface CY_recordView (){
    
    NSMutableArray *dataArr;
    UIView *blackV;
    __weak IBOutlet NSLayoutConstraint *top;
}

@end

@implementation CY_recordView

-(void)initView{
    top.constant = IOS7_Height;
    _button1.layer.cornerRadius = 10;
    _button1.layer.masksToBounds = YES;
    _button2.layer.cornerRadius = 10;
    _button2.layer.masksToBounds = YES;
    _button3.layer.cornerRadius = 10;
    _button3.layer.masksToBounds = YES;
    
    [_bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 10) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    _custNameL.text = _custName;
    _linkNameL.text = [NSString stringWithFormat:@"联系人：%@",[_from_dic objectForKey:@"linkManName"]];
    
    float bigViewH = 0.0f;
    
    if ([[_from_dic objectForKey:@"mobileList"]count] !=0) {
        NSArray *mobileArr =[_from_dic objectForKey:@"mobileList"];
        
        for (int i=0; i<mobileArr.count; i++) {
            
            UILabel *contentL = [[UILabel alloc]init];
            contentL.frame =CGRectMake(22, 6*(i+1)+16*i+_linkNameL.frame.origin.y+_linkNameL.frame.size.height, __MainScreen_Width-86, 16);
            contentL.text = [NSString stringWithFormat:@"手机%d：%@",i+1,[mobileArr objectAtIndex:i]];
            contentL.font = [UIFont systemFontOfSize:16];
            contentL.textColor = [ToolList getColor:@"5d5d5d"];
            [_contentView addSubview:contentL];
        }
    
        bigViewH += mobileArr.count *22;
    }
    
    if ([[_from_dic objectForKey:@"telList"] count]!=0 && [_from_dic objectForKey:@"telList"]!=nil) {
        
        NSArray *telArr =[_from_dic objectForKey:@"telList"];
        
        for (int i=0; i<telArr.count; i++) {
            
            UILabel *contentL = [[UILabel alloc]init];
            contentL.frame =CGRectMake(22,  6*(i+1)+16*i+_linkNameL.frame.origin.y+_linkNameL.frame.size.height+bigViewH, __MainScreen_Width-86, 16);
             contentL.text =[NSString stringWithFormat:@"电话%d：%@",i,[telArr objectAtIndex:i]];
            contentL.font = [UIFont systemFontOfSize:16];
            contentL.textColor = [ToolList getColor:@"5d5d5d"];
            [_contentView addSubview:contentL];
        }
        bigViewH += telArr.count *22;
    }
    
    if ([[_from_dic objectForKey:@"mailList"] count ]!= 0) {
       
        NSArray *mailArr =[_from_dic objectForKey:@"mailList"];
        
        for (int i=0; i<mailArr.count; i++) {
            
            UILabel *contentL = [[UILabel alloc]init];
            contentL.frame =CGRectMake(22, 6*(i+1)+16*i+_linkNameL.frame.origin.y+_linkNameL.frame.size.height+bigViewH, __MainScreen_Width-86, 16);
            contentL.text =[NSString stringWithFormat:@"邮箱%d：%@",i,[mailArr objectAtIndex:i]];;
            contentL.font = [UIFont systemFontOfSize:16];
            contentL.textColor = [ToolList getColor:@"5d5d5d"];
            [_contentView addSubview:contentL];
        }
        
        bigViewH += mailArr.count *22;
    }
    
    _telViewH.constant =bigViewH;
    _bgviewH.constant =bigViewH+IOS7_Height+10;
    
    _button1.frame = CGRectMake((__MainScreen_Width-24-216)/4+12,_bgviewH.constant+24+IOS7_Height , 72, 40);
    _button2.frame = CGRectMake(_button1.frame.origin.x+72+(__MainScreen_Width-24-216)/4,_button1.frame.origin.y , 72, 40);
    _button3.frame = CGRectMake(_button2.frame.origin.x+72+(__MainScreen_Width-24-216)/4,_button1.frame.origin.y , 72, 40);
    
    
    UIButton *telBt = [UIButton buttonWithType:UIButtonTypeCustom];
    telBt.frame = CGRectMake(__MainScreen_Width-72-14, _linkNameL.frame.origin.y+_linkNameL.frame.size.height+6, 72, 32);
    [telBt setImage:[UIImage imageNamed:@"拨打前.png"] forState:UIControlStateNormal];
    [telBt addTarget:self action:@selector(moreTel:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:telBt];
    
    UIButton* XQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [XQBtn setTitle:@"客户详情" forState:UIControlStateNormal];
    XQBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [XQBtn setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
    XQBtn.backgroundColor = [UIColor clearColor];
    XQBtn.frame = CGRectMake(0, 2, __MainScreen_Width/2, CaozuoViewHeight-1);
    [XQBtn addTarget:self action:@selector(XQBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [XQBtn setImage:[UIImage imageNamed:@"normal_2.png"] forState:UIControlStateNormal];
    [XQBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [_bgView addSubview:XQBtn];
    
    UIButton* TSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [TSBtn setTitle:@"话术提示" forState:UIControlStateNormal];
    TSBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [TSBtn setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
    TSBtn.backgroundColor = [UIColor clearColor];
    TSBtn.frame = CGRectMake(__MainScreen_Width/2, 2, __MainScreen_Width/2, CaozuoViewHeight-1);
    [TSBtn addTarget:self action:@selector(TSBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [TSBtn setImage:[UIImage imageNamed:@"tips.png"] forState:UIControlStateNormal];
    [TSBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [_bgView addSubview:TSBtn];
 
}



#pragma mark - 点击多个电话
    -(void)moreTel:(UIButton *)sender{
     
        NSMutableArray *telArr = [[NSMutableArray alloc]init];
        [telArr addObjectsFromArray:[_from_dic objectForKey:@"mobileList"]];
        [telArr addObjectsFromArray:[_from_dic objectForKey:@"telList"]];
        
        CY_popupV *popuTel = [[CY_popupV alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-telArr.count*49-54, __MainScreen_Width, telArr.count*49+54) andMessageArr:telArr andtarget:self];
        [blackV addSubview:popuTel];
        
        [UIView animateWithDuration:0.3 animations:^{
            blackV.frame =CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
        }];
        
    }
    
    -(void)cancelBt:(UIButton *)cancelBt{
        
        [UIView animateWithDuration:0.3 animations:^{
            blackV.frame =CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height);
        }];
    }


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ToolList getColor:@"f3f4f5"];
    
     [self addNavgationbar:@"沟通结果" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
 
    [self initView];
    
    //多个电话显示页面
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    blackV = [[UIView alloc]initWithFrame:CGRectMake(0,__MainScreen_Height , __MainScreen_Width, __MainScreen_Height)];
    blackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [mainWindow addSubview:blackV];
    
}
#pragma mark---话术提示
-(void)TSBtnClicked:(UIButton *)TSbt{
    
    promptVc *promptV = [[promptVc alloc] init];
    [self.navigationController pushViewController:promptV animated:NO];
}

#pragma mark---放弃原因
-(IBAction)backB:(id)sender{
    
    backUpVC *backUpV = [[backUpVC alloc] init];
    backUpV.dataDic = _from_dic;
    backUpV.custName = _custName;
     backUpV.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController pushViewController:backUpV animated:NO];
}

#pragma mark---客户详情
-(void)XQBtnClicked:(UIButton *)bt{
    
    New_ShouCangDetailMore *s = [[New_ShouCangDetailMore alloc]init];
    s.custId = [_fromAll_dic objectForKey:@"custId"];
    s.receiveDic = _fromAll_dic;
    [self.navigationController pushViewController:s animated:NO];
}

#pragma mark---点击收藏按钮，返回收藏夹列表页

-(IBAction)goProtect:(id)sender{

    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    [requestDic setObject:[_from_dic objectForKey:@"custId"] forKey:@"custId"];
    [requestDic setObject:[_from_dic objectForKey:@"linkManId"] forKey:@"linkManId"];
    
    [FX_UrlRequestManager postByUrlStr:SW_collectionCustomer_url andPramas:requestDic andDelegate:self andSuccess:@"SW_collectionCustomerSuccess:" andFaild:@"SW_collectionCustomerFild:" andIsNeedCookies:YES];
    
}

#pragma mark----收藏完毕以后，返回收藏列表
-(void)SW_collectionCustomerSuccess:(NSDictionary *)dicd{
    
    if ([[dicd objectForKey:@"code"] intValue]==200) {
        
       [ToolList showRequestFaileMessageLittleTime:@"收藏成功！"];
        UIViewController *viewCtl = self.navigationController.viewControllers[1];
        
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
    
}

-(IBAction)protectCustome:(id)sender{

    
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    [requestDic setObject:[_from_dic objectForKey:@"custId"] forKey:@"custId"];
    [requestDic setObject:[_from_dic objectForKey:@"linkManId"] forKey:@"linkManId"];
    
    [FX_UrlRequestManager postByUrlStr:SW_protectCustomer_url andPramas:requestDic andDelegate:self andSuccess:@"SW_protectCustomerSuccess:" andFaild:@"SW_protectCustomerFild:" andIsNeedCookies:YES];
}

-(void)SW_protectCustomerSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"] intValue]==200) {
        [ToolList showRequestFaileMessageLittleTime:@"保护成功！"];
        UIViewController *viewCtl = self.navigationController.viewControllers[1];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"WSHIFANGOK" object:nil];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
}


-(void)telMoreList:(UIButton *)telBt{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telBt.titleLabel.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
