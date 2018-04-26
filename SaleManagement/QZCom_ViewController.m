//
//  QZCom_ViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 2018/1/12.
//  Copyright © 2018年 cn.300.cn. All rights reserved.
//

#import "QZCom_ViewController.h"
#import "QZtiaoZhengViewController.h"

@interface QZCom_ViewController ()<UITableViewDelegate,UITableViewDataSource>{
    int _selectedRow;
}

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)NSString *marketId;
@property (nonatomic,strong)NSMutableDictionary *requestDic;
@end

@implementation QZCom_ViewController
 
-(void)change_market{
    
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shiChangTZ" object:nil];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change_market) name:@"change_market" object:nil];
    
    _selectedRow = -1;
    _requestDic = [[NSMutableDictionary alloc]init];
    //标题
    [self addNavgationbar:@"选择分公司" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    [self tableView_Rolad];
     [FX_UrlRequestManager postByUrlStr:SubByAreaId_url andPramas:nil andDelegate:self andSuccess:@"QZshichangSuccess:" andFaild:nil andIsNeedCookies:NO];
}

-(void)QZshichangSuccess:(NSDictionary *)sucDic
{
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        NSArray *arr = [sucDic objectForKey:@"result"];
        _dataArr= [[NSMutableArray alloc]initWithArray:arr];
        
    }
    
    [_table reloadData];
}

-(void)tableView_Rolad
{
    //添加列表
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_table];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 50)];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(20, 10, __MainScreen_Width-40, 40);
    bt.backgroundColor = [ToolList getColor:@"5647b6"];
    bt.titleLabel.font = [UIFont systemFontOfSize:14];
    [bt setTitle:@"选定" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(target_change) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:bt];
    [_table setTableFooterView:v];
    
}
#pragma mark---选定按钮
-(void)target_change{
    
    QZtiaoZhengViewController *tiaozhengVC =[[QZtiaoZhengViewController alloc]init];
    //        tiaozhengVC.marketId = [[dicArr objectAtIndex:0] objectForKey:@"marketId"];
    tiaozhengVC.custId = _custId;
    if (_requestDic.count) {
        tiaozhengVC.data_Dic = _requestDic;
        [self.navigationController pushViewController:tiaozhengVC animated:NO];
    }else{
          [ToolList showRequestFaileMessageLittleTime:@"请选定分公司"];
        
    }
    
}

#pragma mark    table代理源
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];//以indexPath来唯一确定cell
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dataDic = nil;
  
    dataDic =_dataArr[indexPath.row];

    
    cell.textLabel.text = dataDic[@"subName"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _selectedRow)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor =[ToolList getColor:@"5647b6"];
        cell.tintColor  =[ToolList getColor:@"5647b6"];
        [_requestDic setObject: dataDic[@"subId"] forKey:@"subId"];
//        [_requestDic setObject:dataDic[@"subName"] forKey:@"subName"];
        
    }

    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }

     [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 43.5) toPoint:CGPointMake(__MainScreen_Width, 43.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

{
    UITableViewCell *cell =(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //
    //记录选中行的行号
    NSDictionary *dataDic = nil;

    dataDic =_dataArr[indexPath.row];

    if ([_marketId isEqualToString:dataDic[@"subId"]]) {
        [ToolList showRequestFaileMessageLittleTime:@"客户已在该市场"];
        
    }
    else
    {
        _selectedRow = indexPath.row ;
        
        //刷新表
        [tableView reloadData];
        
    }
    if (indexPath.row == _selectedRow)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor =[ToolList getColor:@"5647b6"];
        cell.tintColor  =[ToolList getColor:@"5647b6"];
        [_requestDic setObject: dataDic[@"subId"] forKey:@"subId"];
//        [_requestDic setObject:dataDic[@"subName"] forKey:@"subName"];
        
    }
    
//    NSLog(@"%@,%ld",_requestDic,(long)_selectedRow);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
