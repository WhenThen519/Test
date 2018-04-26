//
//  CY_OrientationVc.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_OrientationVc.h"
#import "FX_Button.h"
#import "UserDetailViewController.h"
#import "CY_myClientVC.h"

#import "QZCom_ViewController.h"
@interface CY_OrientationVc (){
    
    UITextField *field;
    NSMutableArray *dicArr;
    UIView *dataViews;
}
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CY_OrientationVc

-(void)RightHome:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    handView *searchView = [[handView alloc]initWithFram:CGRectMake(0, 0, __MainScreen_Width, IOS7_Height) SearchandTarget:self];
    field = (UITextField *)[ searchView viewWithTag:1199];
    [field becomeFirstResponder];
    [self.view addSubview:searchView];
    
//    dataViews = [[UIView alloc]initWithFrame:CGRectMake(0, searchView.frame.size.height, __MainScreen_Width, __MainScreen_Height-searchView.frame.size.height)];
//    dataViews.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:dataViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shichangtz) name:@"shiChangTZ" object:nil];
    [self popView:@"" isNoData:NO];
}
-(void)shichangtz
{

    [_dataArr removeAllObjects];
    [dicArr removeAllObjects];
    
    if (dataViews) {
        [dataViews removeFromSuperview];
        dataViews =nil;
    }
    
    [self popView:@"" isNoData:NO];
    field.text = @"";
    
}

-(void)makeView{

    dataViews = [[UIView alloc]initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height)];
    dataViews.backgroundColor = [UIColor clearColor];
    [self.view addSubview:dataViews];
    
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 61)];
    nameL.font = [UIFont boldSystemFontOfSize:16];
    nameL.textColor = [ToolList getColor:@"333333"];
    nameL.text = [[dicArr objectAtIndex:0]objectForKey:@"custName"];
    [dataViews addSubview:nameL];
//     nameL.backgroundColor = [UIColor yellowColor];
    [dataViews.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, nameL.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width-26,nameL.frame.size.height-0.5) andWeight:0.5 andColorString:@"cccccc"]];
    
    for (int i=0; i<_dataArr.count; i++) {
        
        UILabel *dataL = [[UILabel alloc]initWithFrame:CGRectMake(13, nameL.frame.origin.y+nameL.frame.size.height+i*50, __MainScreen_Width-26, 50)];
        dataL.font = [UIFont systemFontOfSize:15];
        dataL.textColor = [ToolList getColor:@"333333"];
        [dataViews addSubview:dataL];
        dataL.numberOfLines = 0;
        NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:[_dataArr objectAtIndex:i]];
        //设置字体
        [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 3)];//设置所有的字体
        // 设置颜色
        [attrString1 addAttribute:NSForegroundColorAttributeName
                            value:[ToolList getColor:@"999999"]
                            range:NSMakeRange(0, 3)];
        dataL.attributedText = attrString1;
        
        [dataL.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, dataL.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width-26,dataL.frame.size.height-0.5) andWeight:0.5 andColorString:@"cccccc"]];
    }
    
            if ([[[dicArr objectAtIndex:0] allKeys]containsObject:@"operate"]) {
    
              NSString  *scString = [[dicArr objectAtIndex:0] objectForKey:@"operate"];
    //                 scString = @"3";
                
                
                //  区总 调整按钮
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3 ) {
                    [self qzoperateType:[scString intValue] isF:YES andCount:1 andChange:NO];
 
                    
                }
                else
                {
                   
                    
                    
                    NSArray *array = [scString componentsSeparatedByString:@","];
                    
                    if (array.count==2) {//两种操作
                        
                        [self operateTypes:array];
                        
                    }else{//一种操作
                        
                        [self operateType:[scString intValue] isF:YES andCount:1 andChange:NO];
                    }

                }
               
                
                }
    
}

//区总
-(void)qzoperateType:(int)type isF:(BOOL)isF andCount:(int)count andChange:(BOOL)change{
    
    switch (type) {
        case 0:
            
            break;
            
        case 1:
        {
            
            if (count==1) {
                
                FX_Button *seeBt = [[FX_Button alloc]initWithFrame:CGRectMake(13, _dataArr.count*50+61+20, __MainScreen_Width-26, 44) andType:@"3" andTitle:@"调整" andTarget:self andDic:nil];
                
                [dataViews addSubview:seeBt];
                
            }
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    
    [theTextField resignFirstResponder];
    
    [_dataArr removeAllObjects];
    [dicArr removeAllObjects];

    if (dataViews) {
          [dataViews removeFromSuperview];
        dataViews =nil;
    }
    
    theTextField.text = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (theTextField.text.length) {
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        
        dataDic[@"custName"]=theTextField.text;
        //区总
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3 ) {
            
            [FX_UrlRequestManager postByUrlStr:QZorientation_url andPramas:dataDic andDelegate:self andSuccess:@"QZorientationSuccess:" andFaild:@"orientationFild:" andIsNeedCookies:YES];

            
        }
        else
        {
            [FX_UrlRequestManager postByUrlStr:orientation_url andPramas:dataDic andDelegate:self andSuccess:@"orientationSuccess:" andFaild:@"orientationFild:" andIsNeedCookies:YES];
  
            
        }
    }else{
        
        [ToolList showRequestFaileMessageLittleTime:@"搜索内容不能为空！"];
    }
    
   
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [_dataArr removeAllObjects];
    [dicArr removeAllObjects];
    
    if (dataViews) {
        [dataViews removeFromSuperview];
        dataViews =nil;
    }
    
     [self popView:@"" isNoData:NO];
    
    return YES;
}
#pragma mark  区总 搜索结果
-(void)QZorientationSuccess:(NSDictionary *)sucDic
{
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        NSArray *arr = [sucDic objectForKey:@"result"];
        
        if (arr.count) {
            
            dicArr= [[NSMutableArray alloc]initWithArray:arr];
            
            NSDictionary *dic =[dicArr objectAtIndex:0];
            
            _dataArr = [[NSMutableArray alloc]init];
            NSString *scString = [NSString stringWithFormat:@"市场：%@",[dic objectForKey:@"marketName"]];//市场（不可缺少）
            [_dataArr addObject:scString];
            
            if ([[dic objectForKey:@"subOrgName"] length]) {
                scString = [NSString stringWithFormat:@"分司：%@",[dic objectForKey:@"subOrgName"]];
                [_dataArr addObject:scString];
            };//分公司
            
            if ([[dic objectForKey:@"deptName"] length]) {
                scString = [NSString stringWithFormat:@"部门：%@",[dic objectForKey:@"deptName"]];
                [_dataArr addObject:scString];
            };//部门
            
           
                
                if ([[dic objectForKey:@"salerName"] length]) {
                    scString = [NSString stringWithFormat:@"商务：%@",[dic objectForKey:@"salerName"]];
                    [_dataArr addObject:scString];
                };//商务（只有商务经理有此项）
            
            if ([[dic objectForKey:@"custType"] length]) {
                scString = [NSString stringWithFormat:@"阶段：%@",[dic objectForKey:@"custType"]];
                [_dataArr addObject:scString];
            };//阶段
            
            if ([ToolList changeNull:[dic objectForKey:@"assignState"]]) {
                scString = [NSString stringWithFormat:@"备注：%@",[dic objectForKey:@"assignState"]];
                [_dataArr addObject:scString];
            };//备注
            [self makeView];
            
        }else{
            
            [self popView:[sucDic objectForKey:@"msg"] isNoData:YES];
            
            return;
        }

        
    }
    
}
-(void)orientationSuccess:(NSDictionary *)sucDic{
    
    
     if ([[sucDic objectForKey:@"code"]intValue]==200) {
         
         NSArray *arr = [sucDic objectForKey:@"result"];
         
         if (arr.count) {
             
           dicArr= [[NSMutableArray alloc]initWithArray:arr];
             
             NSDictionary *dic =[dicArr objectAtIndex:0];
             
             _dataArr = [[NSMutableArray alloc]init];

             /*
              (备注) assignState = "";
              custId = 3Cn8Na8i9crbIcxKEgIWWu;
              custName = "\U6e38\U620f\U516c\U53f8";
              （阶段）  custType = "\U5176\U4ed6\U5ba2\U6237";
              （部门名称）  deptName = "\U5546\U52a11\U90e8";
              （市场） marketName = "\U90d1\U5dde\U5e02\U5e02\U573a";
              （操作）operate = 1;
              （分公司） subOrgName = "\U90d1\U5dde\U5206\U516c\U53f8";
              */
             NSString *scString = [NSString stringWithFormat:@"市场：%@",[dic objectForKey:@"marketName"]];//市场（不可缺少）
             [_dataArr addObject:scString];
             
             if ([[dic objectForKey:@"subOrgName"] length]) {
                 scString = [NSString stringWithFormat:@"分公司：%@",[dic objectForKey:@"subOrgName"]];
              [_dataArr addObject:scString];
             };//分公司
             
             if ([[dic objectForKey:@"deptName"] length]) {
                 scString = [NSString stringWithFormat:@"部门：%@",[dic objectForKey:@"deptName"]];
                [_dataArr addObject:scString];
             };//部门
             
             if ([[dic allKeys]containsObject:@"salerName"]) {
                 
                 if ([[dic objectForKey:@"salerName"] length]) {
                     scString = [NSString stringWithFormat:@"商务：%@",[dic objectForKey:@"salerName"]];
                     [_dataArr addObject:scString];
                 };//商务（只有商务经理有此项）
             }
             
             if ([[dic objectForKey:@"custType"] length]) {
                 scString = [NSString stringWithFormat:@"阶段：%@",[dic objectForKey:@"custType"]];
                 [_dataArr addObject:scString];
             };//阶段
             
             if ([[dic objectForKey:@"assignState"] length]) {
                 scString = [NSString stringWithFormat:@"备注：%@",[dic objectForKey:@"assignState"]];
                 [_dataArr addObject:scString];
             };//备注
             
       
             [self makeView];
             
         }else{
             
             [self popView:[sucDic objectForKey:@"msg"] isNoData:YES];
             
             return;
         }

        
     }
}

-(void)popView:(NSString *)titleSting isNoData:(BOOL)isNo{
    
    if (dataViews==nil) {
        
        dataViews = [[UIView alloc]initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height)];
        dataViews.backgroundColor = [UIColor clearColor];
        [self.view addSubview:dataViews];
    }
   
    UILabel *writV =[[UILabel alloc]init];
    writV.backgroundColor = [UIColor clearColor];
   
    writV.textColor = [ToolList getColor:@"999999"];
    writV.font = [UIFont systemFontOfSize:14];
    writV.textAlignment = NSTextAlignmentCenter;
    
    UILabel *titleL = [[UILabel alloc]init];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.text = @"客户归属地查询";
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3 ){
         titleL.text = @"客户市场调整";
    }
   
    titleL.textColor = [ToolList getColor:@"333333"];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.textAlignment = NSTextAlignmentCenter;
    
    
    
    if (isNo) {
        
        writV.frame = CGRectMake(0, 25, __MainScreen_Width,30);
         writV.text = titleSting;
        [dataViews addSubview:writV];
        
        
    }else{
        writV.frame = CGRectMake(0, 25+30, __MainScreen_Width,30);
        titleL.frame = CGRectMake(0, 25, __MainScreen_Width,30);
         writV.text = @"精确查询需输入完整的客户名称";
        [dataViews addSubview:writV];
        [dataViews addSubview:titleL];
    }
    
   

}

-(void)operateType:(int)type isF:(BOOL)isF andCount:(int)count andChange:(BOOL)change{
    
    switch (type) {
        case 0:
            
            break;
            
        case 1:
        {
            
            if (count==1) {
                
                FX_Button *seeBt = [[FX_Button alloc]initWithFrame:CGRectMake(13, _dataArr.count*50+61+20, __MainScreen_Width-26, 44) andType:@"3" andTitle:@"查看" andTarget:self andDic:nil];
                
                [dataViews addSubview:seeBt];
                
            }else{
                
                if (isF) {
                    
                    FX_Button *seeBt = [[FX_Button alloc]initWithFrame:CGRectMake(13, _dataArr.count*50+61+20, (__MainScreen_Width-36)/2, 44) andType:@"3" andTitle:@"查看" andTarget:self andDic:nil];
                    
                    [dataViews addSubview:seeBt];
                    
                }else{
                    
                    FX_Button *seeBt2 = [[FX_Button alloc]initWithFrame:CGRectMake(13+(__MainScreen_Width-36)/2+10, _dataArr.count*50+61+20, (__MainScreen_Width-36)/2, 44) andType:@"3" andTitle:@"查看" andTarget:self andDic:nil];
                    
                    [dataViews addSubview:seeBt2];
                }
                
            }
           
        }
            break;
            
        case 2:
        {
            if (count == 1) {
                
                FX_Button *seeBt = [[FX_Button alloc]initWithFrame:CGRectMake(13, _dataArr.count*50+61+20, __MainScreen_Width-26, 44) andType:@"3" andTitle:@"收藏" andTarget:self andDic:nil];
                
                [dataViews addSubview:seeBt];
            }else{
                
                if (isF) {
                    
                    
                    FX_Button *seeBt = [[FX_Button alloc]initWithFrame:CGRectMake(13, _dataArr.count*50+61+20, (__MainScreen_Width-36)/2, 44) andType:@"3" andTitle:@"收藏" andTarget:self andDic:nil];
                    if (change) {
                    
                        [seeBt addTarget:self action:@selector(twoChangeType:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    [dataViews addSubview:seeBt];
                    
                }else{
                    
                    FX_Button *seeBt2 = [[FX_Button alloc]initWithFrame:CGRectMake(13+(__MainScreen_Width-36)/2+10, _dataArr.count*50+61+20, (__MainScreen_Width-36)/2, 44) andType:@"3" andTitle:@"收藏" andTarget:self andDic:nil];
                    
                    [dataViews addSubview:seeBt2];
                }
            }
        }
            break;

            
        case 3:
        {
            if (count == 1) {
                
                FX_Button *seeBt = [[FX_Button alloc]initWithFrame:CGRectMake(13, _dataArr.count*50+61+20, __MainScreen_Width-26, 44) andType:@"3" andTitle:@"保护" andTarget:self andDic:nil];
                
                [dataViews addSubview:seeBt];
            }else{
                
                if (isF) {
                    
                    FX_Button *seeBt = [[FX_Button alloc]initWithFrame:CGRectMake(13, _dataArr.count*50+61+20, (__MainScreen_Width-36)/2, 44) andType:@"3" andTitle:@"保护" andTarget:self andDic:nil];
                    
                    [dataViews addSubview:seeBt];
                    
                }else{
                    
                    
                    FX_Button *seeBt2 = [[FX_Button alloc]initWithFrame:CGRectMake(13+(__MainScreen_Width-36)/2+10, _dataArr.count*50+61+20, (__MainScreen_Width-36)/2, 44) andType:@"3" andTitle:@"保护" andTarget:self andDic:nil];
                    if (change) {
                        
                        [seeBt2 addTarget:self action:@selector(twoChangeType:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    [dataViews addSubview:seeBt2];
                }
            }
           
        }
            break;
            
        default:
            break;
    }
}

-(void)operateTypes:(NSArray *)typeArr {
  
    int s1 = [[typeArr objectAtIndex:0] intValue];
    int s2 =[[typeArr objectAtIndex:1] intValue];
   
    if (s1==2&&s2==3) {
        
        [self operateType:s1 isF:YES andCount:2 andChange:YES];
        [self operateType:s2 isF:NO andCount:2 andChange:YES];
    }else{
        [self operateType:s1 isF:YES andCount:2 andChange:NO];
        [self operateType:s2 isF:NO andCount:2 andChange:NO];
    }
}
#pragma mark   下方按钮操作     区总调整
-(void)addType:(UIButton *)bt{
    
    
    //跳转到客户详情页面
    if ([bt.titleLabel.text isEqualToString:@"查看"]) {
        
        UserDetailViewController *s = [[UserDetailViewController alloc] init];
        s.custNameStr = [[dicArr objectAtIndex:0]objectForKey:@"custName"];
        s.custId = [[dicArr objectAtIndex:0] objectForKey:@"custId"];
        [self.navigationController pushViewController:s animated:NO];
        
    }
    else if ([bt.titleLabel.text isEqualToString:@"保护"]){
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        
        dataDic[@"custId"]=[[dicArr objectAtIndex:0] objectForKey:@"custId"];
        
        [FX_UrlRequestManager postByUrlStr:protectCustomer_url andPramas:dataDic andDelegate:self andSuccess:@"swprotectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else if ([bt.titleLabel.text isEqualToString:@"调整"])
    {
        QZCom_ViewController *scVC = [[QZCom_ViewController alloc]init];
        scVC.custId =[[dicArr objectAtIndex:0] objectForKey:@"custId"];
//        isNo = NO;
         [self.navigationController pushViewController:scVC animated:NO];
        NSLog(@"rtyu1234");
    }
    

}

-(void)twoChangeType:(UIButton *)bt{
    
    if ([bt.titleLabel.text isEqualToString:@"收藏"]){
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        dataDic[@"custId"]=[[dicArr objectAtIndex:0] objectForKey:@"custId"];
        dataDic[@"custType"]=@"1";
        [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dataDic andDelegate:self andSuccess:@"swprotectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    
    else if ([bt.titleLabel.text isEqualToString:@"保护"]){
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        
        dataDic[@"custId"]=[[dicArr objectAtIndex:0] objectForKey:@"custId"];
        dataDic[@"custType"]=@"2";
        [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dataDic andDelegate:self andSuccess:@"swprotectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
}

-(void)swprotectCustomerSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue]==200) {
        
        CY_myClientVC *myclient = [[CY_myClientVC alloc]init];
        myclient.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationController pushViewController:myclient animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
   
}


@end
