//
//  CY_alertWhyVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/2/15.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_alertWhyVC.h"
#import "AlertWhyTableViewCell.h"

@interface CY_alertWhyVC (){
    
    UITableView *table;
    NSArray *dataArr;
    UITextView *qitaTextView;
    NSString *releaseReason;
    NSString * releaseReasonId;
}

@end

@implementation CY_alertWhyVC

-(void)leftAction{
    
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    dataArr = @[@"产品功能不足",@"嫌价格高",@"客户无计划",@"已和其他的公司合作",@"其他"];
   
    //标题
    [self addNavgationbar:@"选择放弃原因" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 45 *dataArr.count+85) style:UITableViewStylePlain];
    table.separatorStyle = 0;
    table.backgroundColor=[UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    float btnW = (__MainScreen_Width-30);
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(15, table.frame.size.height+2+IOS7_Height, btnW, 44);
    [okBtn setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [okBtn addTarget:self action:@selector(releseOk) forControlEvents:UIControlEventTouchUpInside];
    okBtn.layer.cornerRadius = 2;

    okBtn.backgroundColor = [ToolList getColor:@"6052BA"];
    okBtn.layer.masksToBounds = YES;
    [okBtn setTitle:@"我要放弃" forState:UIControlStateNormal];
    [self.view addSubview:okBtn];

}

-(void)click
{
    [qitaTextView resignFirstResponder];
}

-(void)releseOk{
    
    if(qitaTextView && qitaTextView.text.length)
    {
        releaseReason = qitaTextView.text;
    }

   
    if(!releaseReason.length)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写原因！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSDictionary *dic = @{@"releaseReason":releaseReason,@"custId":_IntentCustId};
    
    [FX_UrlRequestManager postByUrlStr:swreleaseCust_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"protectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)protectCustomerSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SWSHIFANGOK" object:nil];
        [self dismissViewControllerAnimated:NO completion:^{
          
        }];
        
        
    }
}

#pragma mark --table代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < dataArr.count)
    {
        static NSString *cellID = @"AlertWhyTableViewCell";
        AlertWhyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AlertWhyTableViewCell" owner:self options:nil] lastObject];
            
        }

        cell.content_L.text = [dataArr objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellID = @"TableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            if(qitaTextView == nil)
            {
                qitaTextView  = [[UITextView alloc] initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 75)];
                qitaTextView.layer.borderWidth = 0.5;
                qitaTextView.layer.borderColor = [ToolList getColor:@"e7e7eb"].CGColor;
                
                UIToolbar *aTool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 10, __MainScreen_Width, 35)];
                aTool.barStyle= UIBarStyleDefault;
                UIBarButtonItem *kon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(click)];
                NSArray *arr=[NSArray arrayWithObjects:kon,cancel, nil];
                aTool.items=arr;
                qitaTextView.inputAccessoryView = aTool;
            }
            [cell.contentView addSubview:qitaTextView];
        }
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == dataArr.count )
    {
        return 85;
    }
    else
    {
        return 45;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row!=dataArr.count-1) {
        
         releaseReason =[dataArr objectAtIndex:indexPath.row];
        qitaTextView.text = @"";
        qitaTextView.userInteractionEnabled = NO;
    }else{
        
        releaseReason = qitaTextView.text;
        qitaTextView.userInteractionEnabled = YES;
//        [qitaTextView becomeFirstResponder];
    }
  
    if(!releaseReason.length)
    {
        [qitaTextView becomeFirstResponder];
    }

}
#pragma mark -- 键盘监听
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y ;  // 得到键盘弹出后的y坐标
    table.frame = CGRectMake(0, keyBoardEndY-(__MainScreen_Height - IOS7_Height - 45 - 20), __MainScreen_Width, __MainScreen_Height - IOS7_Height - 45 - 20);
    
//    table.frame = CGRectMake(0,keyBoardEndY-(45*dataArr.count+85), __MainScreen_Width, 45*dataArr.count+85);
    
}
- (void)keyboardWillHide:(NSNotification *)notification{
    // 得到键盘弹出后的键盘视图所在y坐标
    table.frame = CGRectMake(0,IOS7_Height, __MainScreen_Width, 45*dataArr.count+85);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
