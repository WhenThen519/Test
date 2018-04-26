//
//  AddNewScheduleViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/3/30.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "SearchViewController.h"
#import "AddNewScheduleViewController.h"
#import "OneSelectViewController.h"
@interface AddNewScheduleViewController ()
{
    UIDatePicker *datePicker;//时间选择器
    UIView *datePickerView;//视图
    int dateFlag;//开始或者结束点击标记
    NSDateFormatter *dateFormatter;//日期格式
    NSString *type;
    int secound;//提前多少分钟
    NSArray *alertArr;
    NSArray *typeArr;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *high;
@end

@implementation AddNewScheduleViewController
#pragma mark - 创建完成按你点击
-(void)finish
{
    if(_titleTextField.text.length == 0)
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入日程名称" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        return;
    }
    if(_leixing_L.text.length == 0)
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择类型" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        return;
    }
    if(_kaishi_L.text.length == 0)
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择开始时间" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        return;
    }
    if(_jieshu_L.text.length == 0)
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择结束时间" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        return;
    }
    if([_leixing_L.text isEqualToString:@"拜访客户"] || [_leixing_L.text isEqualToString:@"电联客户"])
    {
        if(_guanlian_L.text.length == 0)
        {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择关联客户名称" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        return;
        }
    }
    NSDate *startDate = [dateFormatter dateFromString:_kaishi_L.text];
    NSDate *endDate = [dateFormatter dateFromString:_jieshu_L.text];
   NSDate *resultDate = [startDate earlierDate:endDate];
    if([endDate isEqualToDate:resultDate])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"结束时间应晚于开始时间！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        return;
    }
if(endDate )
{
    
}
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:_titleTextField.text forKey:@"title"];
    [reqDic setObject:type forKey:@"type"];
    [reqDic setObject:_guanlian_Id forKey:@"custId"];
    [reqDic setObject:_guanlian_L.text forKey:@"custName"];
    [reqDic setObject:[NSString stringWithFormat:@"%@:00",_kaishi_L.text] forKey:@"startTime"];
    [reqDic setObject:[NSString stringWithFormat:@"%@:00",_jieshu_L.text] forKey:@"endTime"];
    [reqDic setObject:_tixiang_L.text forKey:@"earlyRemindDesc"];
    [reqDic setObject:_beizhu_TextView.text forKey:@"content"];
    if(_recedic_dic == nil)
    {
        [FX_UrlRequestManager postByUrlStr:addSchedule_url andPramas:reqDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else
    {
        [reqDic setObject:[_recedic_dic objectForKey:@"id"] forKey:@"id"];
        [FX_UrlRequestManager postByUrlStr:updateSchedule_url andPramas:reqDic andDelegate:self andSuccess:@"updateSuccess:" andFaild:nil andIsNeedCookies:YES];
        
    }
}
#pragma mark - UITextView代理
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _high.constant = -250+IOS7_Height;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _high.constant = IOS7_Height;
    
}
#pragma mark - 编辑日程成功
-(void)updateSuccess:(NSDictionary *)resultDic
{
    if([[resultDic objectForKey:@"code"] intValue] == 200)
    {
        //拿到 存有 所有 推送的数组
        NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSString *str =  [[NSUserDefaults standardUserDefaults] objectForKey:@"U_KEY"];
        
        //便利这个数组 根据 key 拿到我们想要的 UILocalNotification
        for (UILocalNotification * loc in array) {
            if ([[loc.userInfo objectForKey:@"key"] isEqualToString:str]) {
                //取消 本地推送
                [[UIApplication sharedApplication] cancelLocalNotification:loc];
            }
        }
        if(secound!=-1)
        {
            //本地通知
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            //设置本地通知的触发时间
            NSDate *dd = [dateFormatter dateFromString:_kaishi_L.text];
            NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([dd timeIntervalSinceReferenceDate] - secound*60)];
            localNotification.fireDate = newDate;
            
            //设置本地通知的时区
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            if([_leixing_L.text isEqualToString:@"拜访客户"] || [_leixing_L.text isEqualToString:@"电联客户"])
            {
                //设置通知的内容
                localNotification.alertBody = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",_kaishi_L.text,_leixing_L.text,_guanlian_L.text,_titleTextField.text];
            }
            else
            {
                //设置通知的内容
                localNotification.alertBody = [NSString stringWithFormat:@"%@ | %@ | %@",_kaishi_L.text,_leixing_L.text,_titleTextField.text];
            }
            
            //设置通知动作按钮的标题
            localNotification.alertAction = @"查看";
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            localNotification.soundName = UILocalNotificationDefaultSoundName;
           
            //取消 推送 用的 字典  便于识别
            NSDictionary * inforDic = [NSDictionary dictionaryWithObject:localNotification.alertBody forKey:@"key"];
            localNotification.userInfo =inforDic;
            [[NSUserDefaults standardUserDefaults] setObject:localNotification.alertBody forKey:@"D_KEY"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        
        [ToolList showRequestFaileMessageLittleTime:[resultDic objectForKey:@"msg"]];
        //立即触发一个通知
        [self performSelector:@selector(back2) withObject:nil afterDelay:1];
    }
}

#pragma mark - 创建日程成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
    if([[resultDic objectForKey:@"code"] intValue] == 200)
    {
        if(secound!=-1)
        {
            //本地通知
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            //设置本地通知的触发时间
            NSDate *dd = [dateFormatter dateFromString:_kaishi_L.text];
            NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([dd timeIntervalSinceReferenceDate] - secound*60)];
            localNotification.fireDate = newDate;
           
            //设置本地通知的时区
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            if([_leixing_L.text isEqualToString:@"拜访客户"] || [_leixing_L.text isEqualToString:@"电联客户"])
            {
                //设置通知的内容
                localNotification.alertBody = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",_kaishi_L.text,_leixing_L.text,_guanlian_L.text,_titleTextField.text];
            }
            else
            {
                //设置通知的内容
                localNotification.alertBody = [NSString stringWithFormat:@"%@ | %@ | %@",_kaishi_L.text,_leixing_L.text,_titleTextField.text];
            }        //设置通知动作按钮的标题
            localNotification.alertAction = @"查看";
            //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
            //    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:LOC AL_NOTIFY_SCHEDULE_ID,@"id",[NSNumber numberWithInteger:10],@"time",[NSNumber numberWithInt:affair.aid],@"affair.aid", nil];
            //    localNotification.userInfo = infoDic;
            NSDictionary * inforDic = [NSDictionary dictionaryWithObject:localNotification.alertBody forKey:@"key"];
            [[NSUserDefaults standardUserDefaults] setObject:localNotification.alertBody forKey:@"D_KEY"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            localNotification.userInfo =inforDic;
            //在规定的日期触发通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        [ToolList showRequestFaileMessageLittleTime:@"添加成功！"];
        //立即触发一个通知
        //    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        [self performSelector:@selector(back) withObject:nil afterDelay:1];
        
    }
}
-(void)back2
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GOB_ACK" object:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - 类型点击
- (IBAction)leixingBtnCliked:(id)sender {
    [self closeKeyboard];

    OneSelectViewController *o = [[OneSelectViewController alloc] init];
    o.dataArr = typeArr;
    o.view_Title = @"选择类型";
    o.selectOKBlock = ^(NSDictionary *result)
    {
        type = [[result allKeys] lastObject];
        _leixing_L.text = [[result allValues] lastObject];
    };
    [self.navigationController pushViewController:o animated:NO];
}

#pragma mark - 开始时间点击
- (IBAction)kaishiBtnCliked:(id)sender
{
    dateFlag = 111;
    [self closeKeyboard];
    [UIView animateWithDuration:0.3 animations:^{
        datePickerView.frame = CGRectMake(0, __MainScreen_Height-246, __MainScreen_Width, 246);
    }];
}
#pragma mark - 结束时间点击
- (IBAction)jieshubtnClicked:(id)sender {
    dateFlag = 222;
    [self closeKeyboard];
    [UIView animateWithDuration:0.3 animations:^{
        datePickerView.frame = CGRectMake(0, __MainScreen_Height-246, __MainScreen_Width, 246);
    }];
}
#pragma mark - 关联客户点击
- (IBAction)guanliankehuCliked:(id)sender {
    SearchViewController *gh = [[SearchViewController alloc] init];
    [self closeKeyboard];

    gh.czBlock = ^(NSDictionary * dic)
    {
        _guanlian_L.text = [dic objectForKey:@"castname"];
        _guanlian_Id = [dic objectForKey:@"castid"];
        
    };
    [self.navigationController pushViewController:gh animated:NO];
}
#pragma mark - 提醒点击
- (IBAction)tixingBtnCliked:(id)sender {
    [self closeKeyboard];
    OneSelectViewController *o = [[OneSelectViewController alloc] init];
    o.dataArr = alertArr;
    o.view_Title = @"提醒";
    o.selectOKBlock = ^(NSDictionary *result)
    {
        secound = [[[result allKeys] lastObject] intValue];//提前多少分
        _tixiang_L.text = [[result allValues] lastObject];
        
    };
    [self.navigationController pushViewController:o animated:NO];
}
#pragma mark - 关闭时间选择
-(void)closePiker
{
    datePicker.date = [NSDate date];
    [UIView animateWithDuration:0.3 animations:^{
        datePickerView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, 246);
    }];
}
#pragma mark - 时间选择完毕
-(void)OKPiker
{
    [UIView animateWithDuration:0.3 animations:^{
        datePickerView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, 246);
    }];
    //开始
    if(dateFlag == 111)
    {
        _kaishi_L.text = [dateFormatter stringFromDate:[datePicker date]];
    }
    //结束
    else if(dateFlag == 222)
    {
        _jieshu_L.text = [dateFormatter stringFromDate:[datePicker date]];
    }
    
}
#pragma mark - 隐藏键盘
-(void)closeKeyboard
{
    [_beizhu_TextView resignFirstResponder];
    [_titleTextField resignFirstResponder];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _high.constant = IOS7_Height;

    [_titleTextField becomeFirstResponder];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    secound = -1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.automaticallyAdjustsScrollViewInsets = NO;
    typeArr = @[@{@"1":@"拜访客户"},@{@"2":@"电联客户"},@{@"3":@"会议"},@{@"4":@"活动"}];
    alertArr = @[@{@"-1":@"不提醒"},@{@"0":@"准时提醒"},@{@"10":@"提前十分钟"},@{@"30":@"提前三十分钟"},@{@"60":@"提前1小时"},@{@"360":@"提前6小时"},@{@"1440":@"提前1天"}];
    //标题
    [self addNavgationbar:@"日程" leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, 246)];
    datePickerView.backgroundColor = [ToolList getColor:@"f2f3f5"];
    //关闭
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 50, 30);
    [btnClose setTitleColor:[ToolList getColor:@"5647B6"] forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closePiker) forControlEvents:UIControlEventTouchUpInside];
    [datePickerView addSubview:btnClose];
    //完成
    UIButton *okClose = [UIButton buttonWithType:UIButtonTypeCustom];
    okClose.frame = CGRectMake(__MainScreen_Width-50, 0, 50, 30);
    [okClose setTitleColor:[ToolList getColor:@"5647B6"] forState:UIControlStateNormal];
    okClose.titleLabel.font = [UIFont systemFontOfSize:14];
    [okClose setTitle:@"完成" forState:UIControlStateNormal];
    [okClose addTarget:self action:@selector(OKPiker) forControlEvents:UIControlEventTouchUpInside];
    [datePickerView addSubview:okClose];
    [self.view addSubview:datePickerView];
    //时间选择器
    datePicker = [[UIDatePicker alloc] init];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, __MainScreen_Width, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minimumDate = [NSDate date];
    [datePickerView addSubview:datePicker];
    _guanlian_L.text = _guanlian_Str;
    if(_recedic_dic!=nil)
    {
        _titleTextField.text = [_recedic_dic objectForKey:@"title"];
        _beizhu_TextView.text = [_recedic_dic objectForKey:@"content"];
        _guanlian_Id = [_recedic_dic objectForKey:@"custId"];
        _guanlian_L.text = [_recedic_dic objectForKey:@"custName"];
        _kaishi_L.text = [[_recedic_dic objectForKey:@"startTime"] substringToIndex:16];
        _jieshu_L.text = [[_recedic_dic objectForKey:@"endTime"]substringToIndex:16];
        for (NSDictionary *dic in alertArr) {
            if([[[dic allValues] lastObject] isEqualToString:[_recedic_dic objectForKey:@"earlyRemindDesc"]])
            {
                _tixiang_L.text = [_recedic_dic objectForKey:@"earlyRemindDesc"];
                secound = [[[dic allKeys] lastObject] intValue];
                break;
            }
        }
        for (NSDictionary *dic in typeArr) {
            if([[[dic allValues] lastObject] isEqualToString:[_recedic_dic objectForKey:@"type"]])
            {
                _leixing_L.text = [_recedic_dic objectForKey:@"type"];
                type = [[dic allKeys] lastObject];
                break;
            }
        }
        NSString *st_U = nil;
        if([_leixing_L.text isEqualToString:@"拜访客户"] || [_leixing_L.text isEqualToString:@"电联客户"])
        {
            //设置修改的str
            st_U = [NSString stringWithFormat:@"%@ | %@ | %@ | %@",_kaishi_L.text,_leixing_L.text,_guanlian_L.text,_titleTextField.text];
        }
        else
        {
            
            st_U = [NSString stringWithFormat:@"%@ | %@ | %@",_kaishi_L.text,_leixing_L.text,_titleTextField.text];
        }
        [[NSUserDefaults standardUserDefaults] setObject:st_U forKey:@"U_KEY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
