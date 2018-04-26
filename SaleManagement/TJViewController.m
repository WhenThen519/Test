//
//  TJViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 16/5/9.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "TJViewController.h"
#import "CY_releseCell.h"
#import "UserDetailViewController.h"
#import "CY_moneyCell.h"

@interface TJViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@property (nonatomic,strong)NSArray *resultArr;

@property (nonatomic,strong)IBOutlet UITableView *myTabel;
@end

@implementation TJViewController

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    if ([_titleStr isEqualToString:@"方案报价"]) {
        
        dataDic[@"flag"]= [NSNumber numberWithInt:2];
        
    }else{//重点跟进
        
        dataDic[@"flag"]= [NSNumber numberWithInt:1];
    }
    switch (isSW.intValue) {
        case 0://商务
        {
            [FX_UrlRequestManager postByUrlStr:workAccountCustDetail_url andPramas:dataDic andDelegate:self andSuccess:@"CustDetailSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
            break;
        case 1://经理
        {
            [FX_UrlRequestManager postByUrlStr:jlworkAccountCustDetail_url andPramas:dataDic andDelegate:self andSuccess:@"CustDetailSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
            break;
        case 2://总监
        {
            [FX_UrlRequestManager postByUrlStr:zjworkAccountCustDetail_url andPramas:dataDic andDelegate:self andSuccess:@"CustDetailSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
            break;
            
        default:
            break;
    }

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
  
         _tableTop.constant = IOS7_Height;

    
     [self addNavgationbar:_titleStr leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
   
    [_myTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

-(void)CustDetailSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"] intValue]==200) {
        _resultArr = [[NSArray alloc]initWithArray:[dic objectForKey:@"result"]];
        [_myTabel reloadData];
    }
}

#pragma UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_resultArr objectAtIndex:indexPath.row];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    [self.navigationController pushViewController:s animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   
    if ([_titleStr isEqualToString:@"方案报价"]) {
       
        CY_moneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CY_moneyCell"];
        
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CY_moneyCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 108.5) toPoint:CGPointMake(__MainScreen_Width, 108.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            
        }
        
        NSDictionary *dataDic = [_resultArr objectAtIndex:indexPath.row];
        cell.nameL.text = [ToolList changeNull:[dataDic objectForKey:@"custName"]];
      
        NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
        
        switch (isSW.intValue) {
            case 0://商务
            {
                cell.typeL.text =[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]];
                
            }
                break;
            case 1://经理
            {
                 cell.typeL.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dataDic objectForKey:@"salerName"]],[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]]];
                
            }
                break;
            case 2://总监
            {
               cell.typeL.text =[NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dataDic objectForKey:@"deptName"]],[dataDic objectForKey:@"salerName"],[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]]];
                
            }
                break;
                
            default:
                break;
        }

        
       NSString *label2 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dataDic objectForKey:@"mobileTag"]],[dataDic objectForKey:@"planMoney"]];
        
        NSString *money = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"planMoney"]];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:label2];
        //设置字体
        UIFont *baseFont = [UIFont systemFontOfSize:14];
        [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(label2.length-money.length, money.length)];
        
        // 设置颜色
        UIColor *color = [ToolList getColor:@"ff3333"];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:NSMakeRange(label2.length-money.length, money.length)];
        cell.timeL.attributedText = attrString;
        
       
        
        cell.moneyL.hidden = YES;
        
         return cell;

    }else{
    
        CY_releseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
        
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CY_releseCell" owner:self options:nil] lastObject];
            //线
            [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            
        }
        
        NSDictionary *dataDic = [_resultArr objectAtIndex:indexPath.row];
        cell.nameLabel.text = [ToolList changeNull:[dataDic objectForKey:@"custName"]];
        
        NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
  
        switch (isSW.intValue) {
            case 0://商务
            {
                  cell.typeLabel.text =[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]];
           
            }
                 break;
            case 1://经理
            {
                  NSString *label2 = [NSString stringWithFormat:@"%@ | %@ ",[ToolList changeNull:[dataDic objectForKey:@"salerName"]],[ToolList changeNull:[dataDic objectForKey:@"custVirtualType"]]];
                 cell.typeLabel.text =label2;
               
            }
                 break;
            case 2://总监
            {
                NSString *label2 = [NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dataDic objectForKey:@"deptName"]],[ToolList changeNull:[dataDic objectForKey:@"salerName"]],[dataDic objectForKey:@"custVirtualType"]];
                cell.typeLabel.text =label2;
                
            }
                break;
                
            default:
                break;
        }
        
       return cell;
    }
                              
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_resultArr count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_titleStr isEqualToString:@"方案报价"]){
        
         return 109.0f;
    }else{
         return 85.0f;
    }
    return 0.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
