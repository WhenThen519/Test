//
//  ScheduleDetailViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/4/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "ScheduleOtherDetailViewController.h"
#import "AddNewScheduleViewController.h"
@interface ScheduleOtherDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top2;

@end

@implementation ScheduleOtherDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _top1.constant = IOS7_Height+10;
    _top2.constant = IOS7_Height+10;
     [self addNavgationbar:@"日程详情" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
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
