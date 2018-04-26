//
//  OneSelectViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/4/1.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "OneSelectViewController.h"
#import "AlertSalersTableViewCell.h"
@interface OneSelectViewController ()
{
    UITableView *table;
    NSDictionary *returnDic;
}
@end

@implementation OneSelectViewController
#pragma mark --table代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AlertSalersTableViewCell";
    AlertSalersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlertSalersTableViewCell" owner:self options:nil] lastObject];
        
    }
    NSDictionary *dic1 = [_dataArr objectAtIndex:indexPath.row];
    cell.name.text = [[dic1 allValues] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   returnDic = [_dataArr objectAtIndex:indexPath.row];
    
}
-(void)finish
{
    if(returnDic && returnDic.count)
    {
        self.selectOKBlock(returnDic);
        
      [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [ToolList showRequestFaileMessageLittleTime:@"请选一项"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavgationbar:_view_Title leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = 0;
    [self.view addSubview:table];
    if(_dataArr)
    {
        [table reloadData];
    }
    // Do any additional setup after loading the view.
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
