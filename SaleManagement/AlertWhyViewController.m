//
//  AlertWhyViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/27.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "AlertWhyViewController.h"
#import "AlertWhyTableViewCell.h"
@interface AlertWhyViewController ()

@end

@implementation AlertWhyViewController
{
    NSString * releaseReason;
    NSString * releaseReasonId;
    UITableView *table;
    NSMutableArray *dataArr;
    UITextView *qitaTextView;
}
-(void)startTable:(NSArray *)data
{
    dataArr = [[NSMutableArray alloc] initWithArray:data];
}
#pragma mark --取消
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark --放弃
-(void)ok
{
    
    if(releaseReasonId.intValue == -1)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择原因！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(releaseReasonId.intValue == 100)
    {
        if(qitaTextView.text.length == 0)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写原因！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            return;
        }
        else
        {
            releaseReason = qitaTextView.text;

        }
    }
    

    
  
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 0://商务
        {
            NSDictionary *dic = @{@"giveUpReason":releaseReasonId,@"custId":_IntentCustId};

            [FX_UrlRequestManager postByUrlStr:swreleaseIntentCust_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"okSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
            break;
            
        case 1://经理
        {
            NSDictionary *dic = @{@"releaseReason":releaseReasonId,@"custId":_IntentCustId};
 
           [FX_UrlRequestManager postByUrlStr:releaseIntentCust_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"okSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
            break;
        case 2://总监
        {
              NSDictionary *dic = @{@"releaseReason":releaseReasonId,@"custId":_IntentCustId};
            [FX_UrlRequestManager postByUrlStr:zjReleaseIntentCust_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"okSuccess:" andFaild:nil andIsNeedCookies:YES];

        }
            break;
            
            
            
        default:
            break;
    }
    
  
    
}
#pragma mark --释放成功
-(void)okSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue] == 200)
    {
      [self.navigationController popViewControllerAnimated:NO];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"FANGQIOK" object:nil];
    }
    [self.view endEditing:YES];
}
#pragma mark --table代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isNeedOther)
    {
    return dataArr.count+1;
    }
    else
    {
    return dataArr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(_isNeedOther == YES)
  {
      if(indexPath.row < dataArr.count)
      {
          static NSString *cellID = @"AlertWhyTableViewCell";
          AlertWhyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
          if(cell==nil)
          {
              cell = [[[NSBundle mainBundle] loadNibNamed:@"AlertWhyTableViewCell" owner:self options:nil] lastObject];
              
          }
          NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
          cell.content_L.text = [ToolList changeNull:[dic objectForKey:@"value"]];
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
                  qitaTextView  = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, __MainScreen_Width-30, 75)];
                  qitaTextView.layer.borderWidth = 0.5;
                  qitaTextView.layer.borderColor = [ToolList getColor:@"e7e7eb"].CGColor;
                  UIToolbar *aTool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 10, __MainScreen_Width, 35)];
                  aTool.barStyle= UIBarStyleDefault;
                  UIBarButtonItem *kon=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                  UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(click)];
                  NSArray *arr=[NSArray arrayWithObjects:kon,cancel, nil];
                  aTool.items=arr;
                  qitaTextView.inputAccessoryView = aTool;
                  qitaTextView.userInteractionEnabled = NO;
                  
              }
              [cell.contentView addSubview:qitaTextView];
          }
          
          return cell;
      }
  }
    else
    {
        static NSString *cellID = @"AlertWhyTableViewCell";
        AlertWhyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell==nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AlertWhyTableViewCell" owner:self options:nil] lastObject];
            
        }
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        cell.content_L.text = [ToolList changeNull:[dic objectForKey:@"value"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isNeedOther == YES)
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
    else{
        return 45;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isNeedOther == YES)
    {
    if(indexPath.row == dataArr.count )
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    //其它
    else if(indexPath.row == dataArr.count - 1)
    {
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        releaseReasonId = [dic objectForKey:@"key"];
        qitaTextView.userInteractionEnabled = YES;
        [qitaTextView becomeFirstResponder];
    }
    else
    {
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        releaseReasonId = [dic objectForKey:@"key"];
        releaseReason = @"";
        qitaTextView.text = @"";
        qitaTextView.userInteractionEnabled = NO;

    }
    }
    else{
        NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
        releaseReasonId = [dic objectForKey:@"key"];
        releaseReason = @"";
        qitaTextView.text = @"";
        qitaTextView.userInteractionEnabled = NO;
    }
 
}
#pragma mark -- 键盘监听
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y ;  // 得到键盘弹出后的y坐标
    table.frame = CGRectMake(0, keyBoardEndY-(__MainScreen_Height - IOS7_Height - 45 - 20), __MainScreen_Width, __MainScreen_Height - IOS7_Height - 45 - 20);
    
}
- (void)keyboardWillHide:(NSNotification *)notification{
    // 得到键盘弹出后的键盘视图所在y坐标
    table.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height - IOS7_Height - 45 - 20);
}
-(void)click
{
    [self.view endEditing:YES];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNavgationbar:@"选择放弃原因" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];

        table = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height - IOS7_Height - 45 - 20) style:UITableViewStylePlain];
        table.separatorStyle = 0;
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        float btnW = (__MainScreen_Width-30);
       
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(15, __MainScreen_Height - 45 - 10, btnW, 44);
        [okBtn setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        okBtn.layer.cornerRadius = 2;
        okBtn.layer.borderWidth = 0.5;
        okBtn.backgroundColor = [ToolList getColor:@"6052BA"];
        okBtn.layer.masksToBounds = YES;
        [okBtn setTitle:@"我要放弃" forState:UIControlStateNormal];
        [self.view addSubview:okBtn];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    releaseReasonId = @"-1";
    releaseReason = @"";
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
