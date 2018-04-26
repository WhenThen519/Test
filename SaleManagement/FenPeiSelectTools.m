//
//  FenPeiSelectTools.m
//  SaleManagement
//
//  Created by feixiang on 2017/8/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "FenPeiSelectTools.h"
#import "FenpeiHeadView.h"
#import "FenpeiCell.h"

@interface FenPeiSelectTools ()
{
    __weak IBOutlet UIButton *fenpeiBtn;
    UITableView *table;
    NSMutableArray *headArr;
    NSIndexPath *cellIndexPath;
    NSIndexPath * headIndexPath;
}
@end

@implementation FenPeiSelectTools
- (IBAction)fenpei:(id)sender {
    NSDictionary *dic ;
    FenpeiHeadView *headerView;
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];

    //总监
    if(_all)
    {
        if(cellIndexPath.row == 1000 )
        {
            [ToolList showRequestFaileMessageLittleTime:@"请选择分配对象"];
            return;
        }
        headerView = [headArr objectAtIndex:cellIndexPath.section];

       dic = [headerView.subArr objectAtIndex:cellIndexPath.row];
        UIAlertController *alert    = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确定将客户分配给'%@'吗？",[dic objectForKey:@"salerName"]] preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction     = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            //总监分配商机到商务
            NSLog(@"走接口");
            NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
            [requestDic setObject:[dic objectForKey:@"salerId"] forKey:@"salerId"];
            [requestDic setObject:_custId forKey:@"custId"];
            [FX_UrlRequestManager postByUrlStr:assignSjToSaler_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if(headIndexPath.row == 1000 )
        {
            [ToolList showRequestFaileMessageLittleTime:@"请选择分配对象"];
            return;
        }
        headerView = [headArr objectAtIndex:headIndexPath.section];


        dic = headerView.dataDic;
        UIAlertController *alert;
        
        if(isSW.intValue == 1)
        {
       alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确定将客户分配给'%@'吗？",[dic objectForKey:@"salerName"]] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction     = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                //经理分配商机到商务
                NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
                [requestDic setObject:[dic objectForKey:@"salerId"] forKey:@"salerId"];
                [requestDic setObject:_custId forKey:@"custId"];
                [FX_UrlRequestManager postByUrlStr:assignSjToSaler_url_jl andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
        }
        else
        {
             alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"确定将客户分配给'%@'吗？",[dic objectForKey:@"deptName"]] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction     = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                //总监分配商机到部门
                NSLog(@"走接口");
                NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
                [requestDic setObject:[dic objectForKey:@"deptId"] forKey:@"deptId"];
                [requestDic setObject:_custId forKey:@"custId"];
                [FX_UrlRequestManager postByUrlStr:assignSjToDept_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
                
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
        }
      
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(void)requestSuccess:(NSDictionary *)dic
{
    [ToolList showRequestFaileMessageLittleTime:@"分配成功"];
    [self performSelector:@selector(finish) withObject:nil afterDelay:1.5];
}
-(void)finish
{
    [self.navigationController popViewControllerAnimated:NO];
[[NSNotificationCenter defaultCenter]postNotificationName:@"FANGQIOK" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [fenpeiBtn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"e7e7eb"]];

    headIndexPath = [NSIndexPath indexPathForRow:1000 inSection:1000];;
    cellIndexPath = [NSIndexPath indexPathForRow:1000 inSection:1000];;
    headArr = [[NSMutableArray alloc] init];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    int no1 = 0;
    for (NSDictionary *dic in _data)
    {
        FenpeiHeadView *headView = [[FenpeiHeadView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 45)];
        headView.backgroundColor = [UIColor whiteColor];
        
        headView.tag = no1;
        headView.dataDic = dic;
        no1++;
        if(isSW.intValue == 2)
        {
        headView.name_L.text = [dic objectForKey:@"deptName"];
        headView.subArr = [dic objectForKey:@"deptEmp"];
        }
        else if (isSW.intValue == 1)
        {
        headView.name_L.text = [dic objectForKey:@"salerName"];
        }
        headView.is_Select = NO;
        headView.cz = ^(long a)
        {
            for (long i = 0; i < headArr.count; i++) {
                FenpeiHeadView *head = [headArr objectAtIndex:i];
                headIndexPath = [NSIndexPath indexPathForRow:0 inSection:a];;
                if(a == i)
                {
                    head.is_Select = YES;
                    [head.name_L setTextColor:[ToolList getColor:@"ba81ff"]];
                    [head.image_V setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
                }
                else
                {
                    head.is_Select = NO;
                    [head.name_L setTextColor:[ToolList getColor:@"7d7d7d"]];
                    [head.image_V setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];
                }
            }
            [table reloadData];
        };
        [headArr addObject:headView];
    }
    [self addNavgationbar:@"分配" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = 0;
    [self.view addSubview:table];
    [table reloadData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark table代理
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FenpeiHeadView *headerView = [headArr objectAtIndex:section];
    if(headerView.is_Select)
    {
    return headerView.subArr.count;
    }
    else
    {
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FenpeiHeadView *headerView = [headArr objectAtIndex:section];
    
    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FenpeiHeadView *headerView = [headArr objectAtIndex:indexPath.section];
    NSDictionary *dic = [headerView.subArr objectAtIndex:indexPath.row];
    static NSString *cellidid = @"FenpeiCell";
    FenpeiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidid];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FenpeiCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(15, 44.5) toPoint:CGPointMake(__MainScreen_Width-15, 44.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    if(cellIndexPath.section == indexPath.section && cellIndexPath.row == indexPath.row)
    {
            [cell.name setTextColor:[ToolList getColor:@"ba81ff"]];
            [cell.btn setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.name setTextColor:[ToolList getColor:@"7d7d7d"]];
            [cell.btn setImage:[UIImage imageNamed:@"filed.png"] forState:UIControlStateNormal];
        }

    cell.name.text = [dic objectForKey:@"salerName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cellIndexPath = indexPath;
    [table reloadData];
 
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
