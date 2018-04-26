//
//  QZtiaoZhengViewController.m
//  SaleManagement
//
//  Created by known on 16/7/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "QZtiaoZhengViewController.h"

@interface QZtiaoZhengViewController ()

@end

@implementation QZtiaoZhengViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNavgationbar:@"选择市场" leftBtnName:@"返回" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
    _selectedRow = -1;
    _requestDic = [[NSMutableDictionary alloc]init];
    _dataArr =[[NSMutableArray alloc]init];
    _souSdataArr =[[NSMutableArray alloc]init];

    if (_data_Dic.count) {
        
        [_requestDic setObject:[_data_Dic objectForKey:@"subId"] forKey:@"adjustToSubId"];
       
    }
    isSelected= NO;
    SouSuo = NO;
    
    //搜索框
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(13,   7+IOS7_Height ,__MainScreen_Width-26, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    text.tag = 1199;
    text.leftView = imgView;
    text.clearButtonMode = UITextFieldViewModeAlways;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.backgroundColor = [ToolList getColor:@"dedee0"];
    text.placeholder = @"请输入搜索内容";
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [ToolList getColor:@"333333"];
    text.layer.cornerRadius = 8;
    text.layer.masksToBounds = YES;
    text.clearButtonMode = UITextFieldViewModeAlways;
//    text.delegate = self.VC;
    text.delegate =self;
//    text.returnKeyType = UIReturnKeySearch;
     [text addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.view addSubview:text];
//    
//    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_Height, 43, 44);
//    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
//    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [cancelSearchBtn addTarget:self action:@selector(RightHome:) forControlEvents:UIControlEventTouchUpInside];
//    cancelSearchBtn.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:cancelSearchBtn];
//    [self.view.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
//

    [self tableViewRolad];
  
  [FX_UrlRequestManager postByUrlStr:getMarketsBySubId_url andPramas:_data_Dic andDelegate:self andSuccess:@"QZshichangSuccess:" andFaild:nil andIsNeedCookies:YES];
   }
-(void)tableViewRolad
{
    //添加列表
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+44, __MainScreen_Width, __MainScreen_Height-44-IOS7_Height) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:table];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [table setTableFooterView:v];
    
}
-(void)QZshichangSuccess:(NSDictionary *)sucDic
{
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
      NSArray *arr = [sucDic objectForKey:@"result"];
        _dataArr= [[NSMutableArray alloc]initWithArray:arr];

    }
    
    [table reloadData];
}

#pragma mark    table代理源
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (SouSuo == YES) {
        return _souSdataArr.count;
        
    }
    else{
        return _dataArr.count;
        
    }
    
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
    
    if (SouSuo == YES) {
        dataDic =_souSdataArr[indexPath.row];

    }
    else{
        dataDic =_dataArr[indexPath.row];

    }
    
    cell.textLabel.text = dataDic[@"marketName"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _selectedRow)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor =[ToolList getColor:@"5647b6"];
        cell.tintColor  =[ToolList getColor:@"5647b6"];
        [_requestDic setObject: dataDic[@"marketId"] forKey:@"adjustToMarketId"];
        

    }
//    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
//    NSLog(@"%@,%ld",_requestDic,(long)indexPath.row);
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

{
    UITableViewCell *cell =(UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    
    //记录选中行的行号
    NSDictionary *dataDic = nil;
    
    if (SouSuo == YES) {
        dataDic =_souSdataArr[indexPath.row];
        
    }
    else{
        dataDic =_dataArr[indexPath.row];
        
    }
    


    if ([_marketId isEqualToString:dataDic[@"marketId"]]) {
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
        [_requestDic setObject: dataDic[@"marketId"] forKey:@"adjustToMarketId"];

    }

    NSLog(@"%@,%ld",_requestDic,(long)_selectedRow);

    
}
#pragma mark    右侧完成按钮
-(void)finish
{
    
    [_requestDic setObject:_custId forKey:@"custId"];
//    NSLog(@"%@",_requestDic);
    if (_requestDic.count) {
        [FX_UrlRequestManager postByUrlStr:QZtiaozhengtation_url andPramas:_requestDic andDelegate:self andSuccess:@"QZtiaoZhengSuccess:" andFaild:@"QZtiaoZhengFild:" andIsNeedCookies:YES];
    }
    

    
}

-(void)QZtiaoZhengSuccess:(NSDictionary *)dic
{
    
 if ([[dic objectForKey:@"code"]intValue]==200)
 {
     [ToolList showRequestFaileMessageLittleTime:dic[@"msg"]];
     [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change_market" object:nil];
     
 }
    
}

#pragma mark  textfield   实时搜索
-(void)textFieldDidChange:(UITextField *)textField
{
    [_souSdataArr removeAllObjects];
    NSLog(@"%@",textField.text);
    if (table) {
        [table removeFromSuperview];
        table =nil;
    }


    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textField.text.length) {
        
        for (int i =0 ; i< _dataArr.count; i++) {
            
            NSDictionary *dataDic =_dataArr[i];
            NSString *marketName = dataDic[@"marketName"];
            if ([marketName hasPrefix:textField.text]) {
                
                [_souSdataArr addObject:dataDic];
            }
            
        }
        if (_souSdataArr.count>0) {
        
//            [ToolList showRequestFaileMessageLittleTime:@"aaaa"];
            SouSuo = YES;

        }
        else
        {
            [ToolList showRequestFaileMessageLittleTime:@"未查到相关搜索"];
            SouSuo = YES;

        }
        
        
//        [_dataArr removeAllObjects];
//        [table removeFromSuperview];
//
//        _dataArr= [[NSMutableArray alloc]initWithArray:arr];
        _selectedRow = -1;
           }
    else
    {
        [ToolList showRequestFaileMessageLittleTime:@"搜索内容不能为空！"];
        SouSuo = NO;
        
    }
  
    
    [self tableViewRolad];
    [table reloadData];

    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"%@",textField.text);
    

        return YES;
 
    
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (textField.text  == nil  ) {
        SouSuo = NO;

    }
    [_souSdataArr removeAllObjects];
    _selectedRow = -1;

    if (table) {
        [table removeFromSuperview];
        table =nil;
    }
//    [FX_UrlRequestManager postByUrlStr:QZshichangtation_url andPramas:nil andDelegate:self andSuccess:@"QZshichangSuccess:" andFaild:nil andIsNeedCookies:NO];
//    [table removeFromSuperview];
    [self tableViewRolad];
    [table reloadData];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
    
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
