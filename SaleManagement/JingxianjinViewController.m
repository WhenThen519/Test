//
//  JingxianjinViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/30.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "JingxianjinViewController.h"
#import "Fx_TableView.h"
#import "JingxianjinTableViewCell.h"
#import "JingxianjinDetailViewController.h"
@interface JingxianjinViewController ()
{
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
}
@end

@implementation JingxianjinViewController

#pragma mark - 页面初始化
-(void)initView
{
    [self addNavgationbar:@"净现金到账" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    dataArr = [[NSMutableArray alloc] init];
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    table.dataSource = self;
    table.delegate = self;
     [table.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:table];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestAlldata];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
#pragma mark - 部门客户列表数据请求成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [dataArr removeAllObjects];
    
    if([[resultDic objectForKey:@"result"] count] <= 0 )
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        [table reloadData];
    }
    else
    {
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        [table reloadData];
    }
    
}
#pragma mark - 数据请求
-(void) requestAlldata
{
    
        NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
        switch (isSW.intValue) {
            case 0://商务
            {

            }
                break;
    
            case 1://经理
            {
                [FX_UrlRequestManager postByUrlStr:DeptYeji_url andPramas:nil andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:NO];
            }
                break;
            case 2://总监
            {
    
                   [FX_UrlRequestManager postByUrlStr:SubYeji_url andPramas:nil andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:NO];
            }
                break;
    
    
    
            default:
                break;
        }

    
 
}



#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"JingxianjinTableViewCell";
    JingxianjinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JingxianjinTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 55.5) toPoint:CGPointMake(__MainScreen_Width, 55.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
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
            
            cell.salerName.text = [ToolList changeNull:[dic objectForKey:@"salerName"]];
            if([[ToolList changeNull:[dic objectForKey:@"dayCount"]] intValue] != 0)
            {
                //富文本的基本数据类型，属性字符串。以此为基础，如果这个设置了相应的属性，则会忽略上面设置的属性，默认为空
                NSString *s = [NSString stringWithFormat:@"+%@ | %@元",[ToolList changeNull:[dic objectForKey:@"dayCount"]],[ToolList changeNull:[dic objectForKey:@"monthCount"]]];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:s];
                NSString *ss = [NSString stringWithFormat:@"+%@",[ToolList changeNull:[dic objectForKey:@"dayCount"]]];
                
                // 设置颜色
                UIColor *color = [ToolList getColor:@"59b54d"];
                [attrString addAttribute:NSForegroundColorAttributeName
                                   value:color
                                   range:[s rangeOfString:ss]];
                cell.contentLabel.attributedText = attrString;
            }
            else
            {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@元",[ToolList changeNull:[dic objectForKey:@"monthCount"]]];
            }
        }
            break;
        case 2://总监
        {
            
            
            cell.salerName.text = [ToolList changeNull:[dic objectForKey:@"deptName"]];
            
            if([[ToolList changeNull:[dic objectForKey:@"dayCount"]] intValue] != 0)
            {
                //富文本的基本数据类型，属性字符串。以此为基础，如果这个设置了相应的属性，则会忽略上面设置的属性，默认为空
                NSString *s = [NSString stringWithFormat:@"+%@ | %@元",[ToolList changeNull:[dic objectForKey:@"dayCount"]],[ToolList changeNull:[dic objectForKey:@"monthCount"]]];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:s];
                NSString *ss = [NSString stringWithFormat:@"+%@",[ToolList changeNull:[dic objectForKey:@"dayCount"]]];
                
                // 设置颜色
                UIColor *color = [ToolList getColor:@"59b54d"];
                [attrString addAttribute:NSForegroundColorAttributeName
                                   value:color
                                   range:[s rangeOfString:ss]];
                cell.contentLabel.attributedText = attrString;
            }
            else
            {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@元",[ToolList changeNull:[dic objectForKey:@"monthCount"]]];
            }
        }
            break;
            
            
            
        default:
            break;
    }

   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            
        }
            break;
            
        case 1://经理
        {            
            JingxianjinDetailViewController *jd = [[JingxianjinDetailViewController alloc] init];
            jd.salerId = [dic objectForKey:@"salerId"];
            [self.navigationController pushViewController:jd animated:NO];
        }
            break;
        case 2://总监
        {

            JingxianjinDetailViewController *jd = [[JingxianjinDetailViewController alloc] init];
            jd.salerId = [dic objectForKey:@"deptId"];
            [self.navigationController pushViewController:jd animated:NO];
        }
            break;
            
            
            
        default:
            break;
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
