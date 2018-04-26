//
//  renWuViewController.m
//  SaleManagement
//
//  Created by known on 16/5/11.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "renWuViewController.h"
#import "renWuTableViewCell.h"
#define NUMBERS @".0123456789\n"

@interface renWuViewController ()
{
    UITableView *_tableView;

}
@end

@implementation renWuViewController
-(void)closeKeyboard
{
    [self.view endEditing:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tap];
    _listArray =[[ NSMutableArray alloc]init];
    [self addNavgationbar:@"目标任务" leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"rightBt"];
    
    [self requestData];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    
    UINib * nib = [UINib nibWithNibName:@"renWuTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
    
    //观察键盘的弹出和消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
    
   }
- (void)keyboardHide:(NSNotification *)notification{
    
    
    float y = IOS7_StaticHeight;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0,IOS7_Height, self.view.frame.size.width, self.view.frame.size.height - IOS7_Height);
    }];

}
- (void)keyboardShow:(NSNotification *)notification{
    
    //动态计算键盘高度
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //移动tableView和textField 键盘的弹出只要0.3s
    [UIView animateWithDuration:0.3f animations:^{
        _tableView.frame = CGRectMake(0, IOS7_Height, self.view.frame.size.width, self.view.frame.size.height - IOS7_Height - height);
    }];
 
    
}
//完成按钮
-(void)rightBt
{
    [self.view endEditing:YES];

    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    [dic setObject:_listArray forKey:@"goals"];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 1://经理
        {
            [FX_UrlRequestManager postByUrlStr:baoCUNRenWu_url andPramas:dic andDelegate:self andSuccess:@"requestBaoCunSuccess:" andFaild:nil andIsNeedCookies:YES];
            
            
        }
            break;
            
        case 2://总监
        {
            [FX_UrlRequestManager postByUrlStr:ZJbaoCUNRenWu_url andPramas:dic andDelegate:self andSuccess:@"requestBaoCunSuccess:" andFaild:nil andIsNeedCookies:YES];
            
            
        }
            
            break;
            
            
            
    }

    
}
-(void)requestData
{
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 1://经理
        {
            [FX_UrlRequestManager postByUrlStr:addRenWu_url andPramas:nil andDelegate:self andSuccess:@"requestMuBiaoSuccess:" andFaild:nil andIsNeedCookies:NO];

            
                  }
            break;

                case 2://总监
                {
                    [FX_UrlRequestManager postByUrlStr:ZJRenWu_url andPramas:nil andDelegate:self andSuccess:@"requestMuBiaoSuccess:" andFaild:nil andIsNeedCookies:NO];
                    
                    
                }
            break;
    
    
    
    
    }
}
// 完成按钮
-(void)requestBaoCunSuccess:(NSDictionary *)dic
{
    
    
    
        if([[dic objectForKey:@"code"] intValue] == 200)
        {
            
            [ToolList showRequestFaileMessageLittleTime:@"存储成功"];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            
        }
        
   
  
}
-(void)requestMuBiaoSuccess:(NSDictionary *)dic
{
    
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [_listArray addObjectsFromArray:[dic objectForKey:@"result"]];
        NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
        
        switch (isSW.intValue) {
            case 1://经理
            {
                jiBen =dic[@"deptBaseGoal"] ;
                
                
            }
                break;
                
            case 2://总监
            {
                jiBen =dic[@"subBaseGoal"] ;
                
                
            }
                break;
                
                
                
                
        }

//        renWu =dic[@"deptTargetGoal"];
    }
    [_tableView reloadData];
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    UIView *headView =[[ UIView alloc]initWithFrame:CGRectMake(0, 64, __MainScreen_Width, 85)];
    headView.backgroundColor = [ToolList getColor:@"FFFFFF"];
    
//    [self.view addSubview:headView];
    UILabel *leftLabel =[[ UILabel alloc]initWithFrame:CGRectMake(0, 20, __MainScreen_Width, 16)];
    leftLabel.text =@"基本任务";
    leftLabel.font =[UIFont systemFontOfSize:16];
    leftLabel.textColor =[ToolList getColor:@"4A4A4A"];
    leftLabel.textAlignment= NSTextAlignmentCenter;

    [headView addSubview:leftLabel];
//    UILabel *rightLabel =[[ UILabel alloc]initWithFrame:CGRectMake(leftLabel.frame.origin.x+64+79, 20, 64, 16)];
//    rightLabel.text =@"目标任务";
//    rightLabel.font =[UIFont systemFontOfSize:16];
//    rightLabel.textColor =[ToolList getColor:@"4A4A4A"];
//    [headView addSubview:rightLabel];
    
    _leftMoneyLabel =[[ UILabel alloc]initWithFrame:CGRectMake((__MainScreen_Width-66)/2, leftLabel.frame.origin.y+16+12, 60, 22)];
    _leftMoneyLabel.text =jiBen;
//    _leftMoneyLabel.textAlignment= NSTextAlignmentCenter;
    _leftMoneyLabel.font =[UIFont systemFontOfSize:22];
    _leftMoneyLabel.textColor =[ToolList getColor:@"9013FE"];
    [headView addSubview:_leftMoneyLabel];
    
//    _rightMoneyLabel =[[ UILabel alloc]initWithFrame:CGRectMake(rightLabel.frame.origin.x, leftLabel.frame.origin.y+16+12, 47, 22)];
//    _rightMoneyLabel.text =renWu;
////    _rightMoneyLabel.textAlignment= NSTextAlignmentCenter;
//    _rightMoneyLabel.font =[UIFont systemFontOfSize:22];
//    _rightMoneyLabel.textColor =[ToolList getColor:@"9013FE"];
//    [headView addSubview:_rightMoneyLabel];
    
    UILabel *left =[[ UILabel alloc]initWithFrame:CGRectMake(_leftMoneyLabel.frame.origin.x+_leftMoneyLabel.frame.size.width+3, _leftMoneyLabel.frame.origin.y+6, 14, 14)];
    left.text =@"万";
    left.font =[UIFont systemFontOfSize:14];

    left.textColor =[ToolList getColor:@"4A4A4A"];
    [headView addSubview:left];
    
//    UILabel *right =[[ UILabel alloc]initWithFrame:CGRectMake(_rightMoneyLabel.frame.origin.x+48+5.5, _leftMoneyLabel.frame.origin.y+6, 14, 14)];
//    right.text =@"万";
//    right.font =[UIFont systemFontOfSize:14];
//    right.textColor =[ToolList getColor:@"4A4A4A"];
//    [headView addSubview:right];

    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 85;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    renWuTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary * dic = _listArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 1://经理
        {
            cell.nameLabel.text = [ToolList changeNull:dic[@"salerName"]];
            cell.jiBenTF.text =[ToolList changeNull:dic [@"salerBaseGoal"]];
            cell.muBiaoTF.text =[ToolList changeNull: dic [@"salerTargetGoal"]];
        }
            break;
        case 2://总监
        {
            cell.nameLabel.text = [ToolList changeNull:dic[@"deptName"]];
            cell.jiBenTF.text =[ToolList changeNull:dic [@"deptBaseGoal"]];
            cell.muBiaoTF.text =[ToolList changeNull: dic [@"deptTargetGoal"]];
        }
            
            break;
            
            
            
    }

    
   

    cell.jiBenTF.tag = indexPath.row+100;
    cell.muBiaoTF.tag = indexPath.row+100;
    [cell.muBiaoTF addTarget:self action:@selector(muBiaoBT:) forControlEvents:UIControlEventEditingChanged];
//    cell.jiBenTF.keyboardType= UIKeyboardTypeNumberPad;
    cell.jiBenTF.delegate=self;
    cell.muBiaoTF.delegate = self;

    return cell;
}
- (void)muBiaoBT:(UITextField *)textField
{
    NSIndexPath *ind = [NSIndexPath indexPathForRow:textField.tag-100 inSection:0];
    
    renWuTableViewCell *cell = (renWuTableViewCell *)[_tableView cellForRowAtIndexPath:ind];
    if (textField == cell.muBiaoTF) {
        if ([cell.muBiaoTF.text integerValue] < [cell.jiBenTF.text integerValue])
        {
            [ToolList showRequestFaileMessageLittleTime:@"目标任务不能小于基本任务"];
        }
        else
        {
            cell.muBiaoTF.text =textField.text;
            
        }
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
        NSIndexPath *ind = [NSIndexPath indexPathForRow:textField.tag-100 inSection:0];
    
    renWuTableViewCell *cell = (renWuTableViewCell *)[_tableView cellForRowAtIndexPath:ind];
    NSDictionary * dic = _listArray[textField.tag-100];
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (textField == cell.jiBenTF) {
        
        
        if ([textField.text isEqualToString:@""]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"基本任务不能为空"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }

        cell.jiBenTF.text = textField.text;
        float mub = [textField.text floatValue];
        NSString *str =[NSString stringWithFormat:@"%.2f",mub*1];
        cell.muBiaoTF.text =str;
    }
    else
    {
        if ([textField.text isEqualToString:@""]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"目标任务不能为空"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
 
        if ([cell.muBiaoTF.text integerValue] < [cell.jiBenTF.text integerValue]) {
            [ToolList showRequestFaileMessageLittleTime:@"目标任务不能小于基本任务"];

            return;
        }
        else
        {
            cell.muBiaoTF.text =textField.text;
        }
    }
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 1://经理
        {
            [mutableDic setObject:cell.jiBenTF.text forKey:@"salerBaseGoal"];
            [mutableDic setObject:cell.muBiaoTF.text forKey:@"salerTargetGoal"];
        }
            break;
        case 2://总监
        {
            [mutableDic setObject:cell.jiBenTF.text forKey:@"deptBaseGoal"];
            [mutableDic setObject:cell.muBiaoTF.text forKey:@"deptTargetGoal"];
        }
            break;
            
            
            
            
    }

   
    NSInteger index = [_listArray indexOfObject:dic];
    [_listArray replaceObjectAtIndex:index withObject:[mutableDic copy]];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
