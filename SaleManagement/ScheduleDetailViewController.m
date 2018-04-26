//
//  ScheduleDetailViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/4/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "AddNewScheduleViewController.h"
@interface ScheduleDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top2;

@end

@implementation ScheduleDetailViewController
#pragma mark - 删除日程
- (IBAction)deleteSchedule:(id)sender
{
    NSMutableDictionary* reqDicD = [[NSMutableDictionary alloc] init];
    [reqDicD setObject:[_dataDic objectForKey:@"id"] forKey:@"id"];
    [FX_UrlRequestManager postByUrlStr:deleteSchedule_url andPramas:reqDicD andDelegate:self andSuccess:@"deleteSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 删除日程成功
-(void)deleteSuccess:(NSDictionary *)dic
{
   if([[dic objectForKey:@"code"] intValue] == 200)
   {
       //拿到 存有 所有 推送的数组
       NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
       NSString *str =  [[NSUserDefaults standardUserDefaults] objectForKey:@"D_KEY"];
                         
            //便利这个数组 根据 key 拿到我们想要的 UILocalNotification
       for (UILocalNotification * loc in array) {
           if ([[loc.userInfo objectForKey:@"key"] isEqualToString:str]) {
               //取消 本地推送
               [[UIApplication sharedApplication] cancelLocalNotification:loc];
           }
       }
       [[NSNotificationCenter defaultCenter] postNotificationName:@"shuaxin" object:nil];
       [self.navigationController popViewControllerAnimated:NO];
   }
}
#pragma mark - 编辑
-(void)edit
{
    AddNewScheduleViewController *an = [[AddNewScheduleViewController alloc] init];
    an.recedic_dic = _dataDic;
    [self.navigationController  pushViewController:an animated:NO];
}
-(void)backFresh
{

    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _top1.constant = IOS7_Height+10;
    _top2.constant = IOS7_Height+10;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFresh) name:@"GOB_ACK" object:nil];
    [self addNavgationbar:@"日程详情" leftBtnName:@"取消" rightBtnName:@"编辑" target:self leftBtnAction:nil rightBtnAction:@"edit"];
    _title_L.text = [_dataDic objectForKey:@"title"];
    _start.text = [NSString stringWithFormat:@"开始:%@",[_dataDic objectForKey:@"startTime"]];
    _end.text = [NSString stringWithFormat:@"结束:%@",[_dataDic objectForKey:@"endTime"]];
    _type.text = [NSString stringWithFormat:@"类型:%@",[_dataDic objectForKey:@"type"]];
    if([[_dataDic objectForKey:@"flag"] intValue] == 0)
    {
        _guoqi.text = @"未过期";
        _guoqi.textColor = [UIColor greenColor];
    }
    _tixing.text = [_dataDic objectForKey:@"earlyRemindDesc"];
    _guanlian.text = [_dataDic objectForKey:@"custName"];
    _beizhu.text = [_dataDic objectForKey:@"content"];
    // Do any additional setup after loading the view from its nib.
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
