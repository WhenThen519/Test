//
//  MyFormViewController.m
//  victor_server_template
//
//  Created by feixiang on 14-7-16.
//  Copyright (c) 2014年 huangsm. All rights reserved.
//
#import "MyFormHeaderView.h"
#import "MyFormViewController.h"
#import "MyFormDetailTableViewCell.h"
#import "InProductionDetailViewController.h"
#import "UserDetailViewController.h"

#define IOS7_HeightPlus (IOS7?20:0)
@interface MyFormViewController ()

@end

@implementation MyFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)goUserView{

    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = _custName;
    s.custId = _custId;
    [self.navigationController pushViewController:s animated:NO];
}

-(void)LeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    
    handView *Hvc = [[handView alloc]initWithTitle:_custName andRightImage:@"" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];
    
    UIButton *nameB = [UIButton buttonWithType:UIButtonTypeCustom];
    nameB.frame = CGRectMake(60,IOS7_HeightPlus, __MainScreen_Width-120, 44);
    nameB.backgroundColor = [UIColor clearColor];
    [nameB addTarget:self action:@selector(goUserView) forControlEvents:UIControlEventTouchUpInside];
    [Hvc addSubview:nameB];
//    //顶部
//    [self addNavgationbar:_custName leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height -IOS7_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    [self requestUrl];
    // Do any additional setup after loading the view.
}
//请求数据
-(void)requestUrl
{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setValue:_custId forKey:@"custId"];
    [FX_UrlRequestManager postByUrlStr:ZJArrearCustDetail_url andPramas:reqDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}

//表单数据请求回调
- (void)requestSuccess:(NSMutableDictionary *)receiveDic
{
    
    if ([[receiveDic objectForKey:@"code"] intValue] == 200)
    {
        [_dataArray removeAllObjects];
        NSArray* resultArray = [receiveDic objectForKey:@"result"];
        if(resultArray.count)
        {
            for (NSDictionary *dic in resultArray)
            {
                NSMutableArray *items = [NSMutableArray arrayWithArray:[dic objectForKey:@"orderInstanceList"]];
                MyFormHeaderView *headerView = [[MyFormHeaderView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 45) andDic:dic];
            headerView.formArticles = items;
            [_dataArray addObject:headerView];
            }
            [_tableView reloadData];
        }
        else
        {
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];

        }
    }
    
}
#pragma mark table代理
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        return 83;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyFormHeaderView *headerView = [_dataArray objectAtIndex:section];
    
   return headerView.formArticles.count;
  
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyFormHeaderView *headerView = [_dataArray objectAtIndex:section];

    return headerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFormHeaderView *headerView = [_dataArray objectAtIndex:indexPath.section];
    NSDictionary *dic = [headerView.formArticles objectAtIndex:indexPath.row];
    static NSString *cellidid = @"MyFormDetailTableViewCell";
    MyFormDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidid];
    if(cell == nil)
    {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"MyFormDetailTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    cell.custName.text = [NSString stringWithFormat:@"• 订购号:%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"orderRecordCode"]]];
    cell.other1Label.text = [NSString stringWithFormat:@"  %@ | %@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"productTrade"]],[NSString stringWithFormat:@"%@",[dic objectForKey:@"businessType"]]];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"surplusTotalMoney"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyFormHeaderView *headerView = [_dataArray objectAtIndex:indexPath.section];
    NSDictionary *dic = [headerView.formArticles objectAtIndex:indexPath.row];
    InProductionDetailViewController *inP = [[InProductionDetailViewController alloc] init];
    inP.orderInstanceCode = [dic objectForKey:@"orderInstanceCode"];
    [self.navigationController  pushViewController:inP animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
