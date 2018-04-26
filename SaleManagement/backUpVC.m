//
//  backUpVC.m
//  SaleManagement
//
//  Created by chaiyuan on 2017/3/2.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "backUpVC.h"
#import "CY_popupV.h"

@interface backUpVC (){
    
   NSString* reasonStr;
    NSMutableArray *chooseArr;
    UIView *blackV;
    __weak IBOutlet NSLayoutConstraint *top;
}

@end

@implementation backUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    reasonStr = @"";
    top.constant = IOS7_Height;
    [self addNavgationbar:@"请选择放弃原因" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    chooseArr = [[NSMutableArray alloc]initWithObjects:_bt1,_bt2,_bt3,_bt4,_bt5,_bt6,_bt7,_bt8,_bt9,_bt10,_bt11,_bt12, nil];
    
    _custL.text = _custName;
    _nameL.text =  [NSString stringWithFormat:@"联系人：%@",[_dataDic objectForKey:@"linkManName"]];
    
    float bigViewH = 0.0f;
    
    if ([[_dataDic objectForKey:@"mobileList"]count] !=0) {
        NSArray *mobileArr =[_dataDic objectForKey:@"mobileList"];
        
        for (int i=0; i<mobileArr.count; i++) {
            
            UILabel *contentL = [[UILabel alloc]init];
            contentL.frame =CGRectMake(22, 6*(i+1)+16*i+_nameL.frame.origin.y+_nameL.frame.size.height, __MainScreen_Width-86, 16);
            contentL.text = [NSString stringWithFormat:@"手机%d：%@",i,[mobileArr objectAtIndex:i]];
            contentL.font = [UIFont systemFontOfSize:16];
            contentL.textColor = [ToolList getColor:@"5d5d5d"];
            [_contentView addSubview:contentL];
        }
        
        bigViewH += mobileArr.count *22;
    }
    
    if ([[_dataDic objectForKey:@"telList"] count]!=0 && [_dataDic objectForKey:@"telList"]!=nil) {
        
        NSArray *telArr =[_dataDic objectForKey:@"telList"];
        
        for (int i=0; i<telArr.count; i++) {
            
            UILabel *contentL = [[UILabel alloc]init];
            contentL.frame =CGRectMake(22,  6*(i+1)+16*i+_nameL.frame.origin.y+_nameL.frame.size.height+bigViewH, __MainScreen_Width-86, 16);
            contentL.text = [NSString stringWithFormat:@"电话%d：%@",i,[telArr objectAtIndex:i]];
            contentL.font = [UIFont systemFontOfSize:16];
            contentL.textColor = [ToolList getColor:@"5d5d5d"];
            [_contentView addSubview:contentL];
        }
        bigViewH += telArr.count *22;
    }
    
    if ([[_dataDic objectForKey:@"mailList"] count ]!= 0) {
        
        NSArray *mailArr =[_dataDic objectForKey:@"mailList"];
        
        for (int i=0; i<mailArr.count; i++) {
            
            UILabel *contentL = [[UILabel alloc]init];
            contentL.frame =CGRectMake(22, 6*(i+1)+16*i+_nameL.frame.origin.y+_nameL.frame.size.height+bigViewH, __MainScreen_Width-86, 16);
            contentL.text = [NSString stringWithFormat:@"邮箱%d：%@",i,[mailArr objectAtIndex:i]];
            contentL.font = [UIFont systemFontOfSize:16];
            contentL.textColor = [ToolList getColor:@"5d5d5d"];
            [_contentView addSubview:contentL];
        }
        
        bigViewH += mailArr.count *22;
    }
    
    _telH.constant =bigViewH;
    _contentBgH.constant =bigViewH+IOS7_Height+10;
    
    _btView.layer.cornerRadius = 10;
    _btView.layer.masksToBounds = YES;
    
    _btView.frame = CGRectMake((__MainScreen_Width-350)/2, 12+_contentBgH.constant, 350, 360);
    _bgH.constant =12+_contentBgH.constant+380;
    
    [self makeView];

}

-(void)makeView{
    
    [_bt1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, _bt1.frame.size.height-0.8) toPoint:CGPointMake(_bt1.frame.size.width-19, _bt1.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(9, _bt2.frame.size.height-0.8) toPoint:CGPointMake(_bt2.frame.size.width, _bt2.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt3.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, _bt3.frame.size.height-0.8) toPoint:CGPointMake(_bt3.frame.size.width-9, _bt3.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt4.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(9, _bt4.frame.size.height-0.8) toPoint:CGPointMake(_bt4.frame.size.width, _bt4.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt5.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, _bt5.frame.size.height-0.8) toPoint:CGPointMake(_bt5.frame.size.width-9, _bt5.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt6.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(9, _bt6.frame.size.height-0.8) toPoint:CGPointMake(_bt6.frame.size.width, _bt6.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt7.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, _bt7.frame.size.height-0.8) toPoint:CGPointMake(_bt7.frame.size.width-9, _bt7.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt8.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(9, _bt8.frame.size.height-0.8) toPoint:CGPointMake(_bt8.frame.size.width, _bt8.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt9.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, _bt9.frame.size.height-0.8) toPoint:CGPointMake(_bt9.frame.size.width-9, _bt9.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt10.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(9, _bt10.frame.size.height-0.8) toPoint:CGPointMake(_bt10.frame.size.width, _bt10.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt11.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, _bt11.frame.size.height-0.8) toPoint:CGPointMake(_bt11.frame.size.width-9, _bt11.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt12.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(9, _bt12.frame.size.height-0.8) toPoint:CGPointMake(_bt12.frame.size.width, _bt12.frame.size.height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    [_bt1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(_bt1.frame.size.width-0.8,19) toPoint:CGPointMake(_bt1.frame.size.width-0.8, 22+19) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt3.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(_bt3.frame.size.width-0.8,19) toPoint:CGPointMake(_bt3.frame.size.width-0.8, 22+19) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt5.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(_bt5.frame.size.width-0.8,19) toPoint:CGPointMake(_bt5.frame.size.width-0.8, 22+19) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt7.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(_bt7.frame.size.width-0.8,19) toPoint:CGPointMake(_bt7.frame.size.width-0.8, 22+19) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt9.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(_bt9.frame.size.width-0.8,19) toPoint:CGPointMake(_bt9.frame.size.width-0.8, 22+19) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_bt11.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(_bt11.frame.size.width-0.8,19) toPoint:CGPointMake(_bt11.frame.size.width-0.8, 22+19) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    
    [_butomV.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2-0.8,15) toPoint:CGPointMake(__MainScreen_Width/2-0.8, 20+15) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    UIButton* NOBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [NOBtn setTitle:@"取消" forState:UIControlStateNormal];
    NOBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [NOBtn setTitleColor:[ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    NOBtn.backgroundColor = [UIColor clearColor];
    NOBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, _butomV.frame.size.height);
    [NOBtn addTarget:self action:@selector(NOBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_butomV addSubview:NOBtn];
    
    UIButton* YESBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [YESBtn setTitle:@"完成" forState:UIControlStateNormal];
    YESBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [YESBtn setTitleColor:[ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    YESBtn.backgroundColor = [UIColor clearColor];
    YESBtn.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, _butomV.frame.size.height);
    [YESBtn addTarget:self action:@selector(YESBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_butomV addSubview:YESBtn];
}

#pragma mark---取消按钮
-(void)NOBtnClicked:(UIButton *)NObt{
    reasonStr = @"";
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark---确定按钮
-(void)YESBtnClicked:(UIButton *)NObt{
   
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    [requestDic setObject:[_dataDic objectForKey:@"custId"] forKey:@"custId"];
     [requestDic setObject:reasonStr forKey:@"releaseReason"];
    [FX_UrlRequestManager postByUrlStr:SW_releaseCust_url andPramas:requestDic andDelegate:self andSuccess:@"SW_releaseCustSuccess:" andFaild:@"SW_releaseCustFild:" andIsNeedCookies:YES];

}

-(void)SW_releaseCustSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"] intValue]==200) {
        
        UIViewController *viewCtl = self.navigationController.viewControllers[1];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"WSHIFANGOK" object:nil];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
}

#pragma mark---取消的原因
-(IBAction)reasonS:(UIButton *)sender{
    
    reasonStr = sender.currentTitle;
    
    NSInteger tags = sender.tag-1001;
    
    sender.selected = !sender.selected;
    
    for (NSInteger j=0; j<[chooseArr count]; j++) {
        
        UIButton *btn = chooseArr[j] ;
        
        if (tags==j){
            
            btn.selected = sender.selected;
            if (btn.selected) {
                
                [btn setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
            }else{
               [btn setTitleColor:[ToolList getColor:@"bfbfbf"] forState:UIControlStateNormal];
            }

        }
        
        else{
            
            btn.selected = NO;
             [btn setTitleColor:[ToolList getColor:@"bfbfbf"] forState:UIControlStateNormal];
        }

        
    }
    
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
