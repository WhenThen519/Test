//
//  OnlyShow.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/4.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "OnlyShow.h"
#import "Fx_TableView.h"
#import "JieShiViewController.h"
@interface OnlyShow ()
{
    //数据列表
    Fx_TableView *table;
}
@end

@implementation OnlyShow
-(void)jieshi
{
    JieShiViewController *d = [[JieShiViewController alloc] init];
    [self.navigationController pushViewController:d animated:NO];
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CangCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *   arr = [_dataArr objectAtIndex:indexPath.row];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 20*arr.count-0.5) toPoint:CGPointMake(__MainScreen_Width, 20*arr.count-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        for (int i = 0; i<arr.count; i++)
        {
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(8, i*20,__MainScreen_Width-8 , 20)];
            nameL.textColor = [ToolList getColor:@"7d7d7d"];
            nameL.font = [UIFont systemFontOfSize:14];
            nameL.text = [arr objectAtIndex:i];
            [cell.contentView addSubview:nameL];
        }
    }
   
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *   arr = [_dataArr objectAtIndex:indexPath.row];

    return 20*arr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加标题
 [self addNavgationbar:_title_Show leftImageName:nil rightImageName:@"解释.png" target:self leftBtnAction:nil rightBtnAction:@"jieshi" leftHiden:NO rightHiden:NO];
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
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
