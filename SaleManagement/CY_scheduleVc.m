//
//  CY_scheduleVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/12.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_scheduleVc.h"
#import "CY_scheduleCell.h"

@interface CY_scheduleVc ()


@property (nonatomic,strong)UITableView *scheduleTable;

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CY_scheduleVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //标题
    [self addNavgationbar:@"生产进度" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    [self allRequest];
    
    UILabel *codeL = [[UILabel alloc]initWithFrame:CGRectMake(10, IOS7_Height, __MainScreen_Width-20, 35.5)];
    codeL.text = [NSString stringWithFormat:@"订单号：%@",_pageCode];
    codeL.font = [UIFont systemFontOfSize:14];
    codeL.textColor = [ToolList getColor:@"999999"];
    [self.view addSubview:codeL];
    
    //线
    [codeL.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(13, 35) toPoint:CGPointMake(__MainScreen_Width-26, 35) andWeight:0.5 andColorString:@"e7e7e7b"]];
    
    _scheduleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, IOS7_Height+codeL.frame.size.height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain];
    _scheduleTable.backgroundColor = [UIColor whiteColor];
    _scheduleTable.delegate = self;
    _scheduleTable.dataSource = self;
    [_scheduleTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_scheduleTable];
    
}

-(void)allRequest{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    reqDic[@"orderInstanceCode"] = _pageCode;
    [FX_UrlRequestManager postByUrlStr:achedule_url andPramas:reqDic andDelegate:self andSuccess:@"acheduleSuccess:" andFaild:@"acheduleFild:" andIsNeedCookies:YES];
}


-(void)acheduleSuccess:(NSDictionary *)sucDic{
    
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        _dataArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
    }
    [_scheduleTable reloadData];
}



#pragma uitableviewdelgate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110.0f;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"CY_scheduleCell";
    CY_scheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CY_scheduleCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(13, 109.5) toPoint:CGPointMake(__MainScreen_Width-26, 109.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        
    }
    
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [dataDic objectForKey:@"groupName"];
    
    cell.typeLabel.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dataDic objectForKey:@"workStatus"]],[ToolList changeNull:[dataDic objectForKey:@"assigneeName"]]];
    
     cell.timeLabel.text = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dataDic objectForKey:@"startDate"]],[ToolList changeNull:[dataDic objectForKey:@"endDate"]]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
