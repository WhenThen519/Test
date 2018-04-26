//
//  JieShiViewController.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/8.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "JieShiViewController.h"

@interface JieShiViewController ()

@end

@implementation JieShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    [self addNavgationbar:@"名词解释" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:YES];
    // Do any additional setup after loading the view from its nib.
    UITextView *ff = [[UITextView alloc] initWithFrame:CGRectMake(5, IOS7_Height+5, __MainScreen_Width-10, __MainScreen_Height-IOS7_Height-10)];
    ff.text =@"\n渠道：指的是相关B2B电子商务平台。\n\nHTML5：新一代超文本标记语言。\n\nCSS3： CSS3是CSS技术的升级版本,用以控制页面的布局、字体、颜色、背景和其它效果。\n\nW3C标准偏离：网页编码规范是否符合W3C标准。\n\n百度权重：针对网站关键词排名预计给网站带来的流量，范围0-10。\n\nIP地理位置：反映IP地址的归属地。\n\n访问错误率：在一定测试次数下，访问网站时无法正常打开次数的所占比例。";
    ff.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:ff];
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
