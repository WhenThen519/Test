//
//  AlertSalersViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/28.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "AlertSalersTableViewCell.h"
#import "AlertSalersViewController.h"

@interface AlertSalersViewController ()
{
    NSArray *dataArr;
    UITableView *table;
    NSString *salerID;
}
@end

@implementation AlertSalersViewController
#pragma mark 筛选商务数据请求成功
-(void)OpenSelectSuccess:(NSDictionary *)resultDic
{
    dataArr = [NSArray arrayWithArray:[resultDic objectForKey:@"result"]];
    [table reloadData];
}
#pragma mark --table代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AlertSalersTableViewCell";
    AlertSalersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlertSalersTableViewCell" owner:self options:nil] lastObject];
        
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            
        }
            break;
            
        case 1://经理
        {
           cell.name.text = [ToolList changeNull:[dic objectForKey:@"salerName"]];
        }
            break;
        case 2://总监
        {
             cell.name.text = [ToolList changeNull:[dic objectForKey:@"deptName"]];
        }
            break;
            
            
            
        default:
            break;
    }

    
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            
        }
            break;
            
        case 1://经理
        {
            salerID = [dic objectForKey:@"salerId"];
        }
            break;
        case 2://总监
        {
             salerID = [dic objectForKey:@"deptId"];
        }
            break;
            
        default:
            break;
    }

    
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = 0;
    
    [self.view addSubview:table];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            
        }
            break;
            
        case 1://经理
        {
            
            [self addNavgationbar:@"选择商务" leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
            
            
            [FX_UrlRequestManager postByUrlStr:GetSalers_url andPramas:nil andDelegate:self andSuccess:@"OpenSelectSuccess:" andFaild:nil andIsNeedCookies:NO];
        }
            break;
        case 2://总监
        {
            
            [self addNavgationbar:@"客户分配" leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
            
            
            [FX_UrlRequestManager postByUrlStr:ZJdeptInit_url andPramas:nil andDelegate:self andSuccess:@"OpenSelectSuccess:" andFaild:nil andIsNeedCookies:NO];
        }
            break;
            
            
            
        default:
            break;
    }
    

  
    // Do any additional setup after loading the view.
}
-(void)finish
{
    if(salerID && salerID.length)
    {
        self.selectOKBlock(salerID);
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"SWSHIFANGOK" object:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        
        NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
        switch (isSW.intValue) {
            case 0://商务
            {
                
            }
                break;
                
            case 1://经理
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择商务！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
                break;
            case 2://总监
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择部门！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
                break;
                
                
                
            default:
                break;
        }
       
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
