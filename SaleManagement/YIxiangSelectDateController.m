//
//  YIxiangSelectDateController.m
//  SaleManagement
//
//  Created by feixiang on 2017/8/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "YIxiangSelectDateController.h"

@interface YIxiangSelectDateController ()
{
    NSMutableArray *new_addBtnArr;
    NSArray *new_addArr;
    NSString *sjCustMark;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerDate;

@end

@implementation YIxiangSelectDateController
- (IBAction)finish:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:_pickerDate.date];
    [[NSUserDefaults standardUserDefaults] setObject:sjCustMark forKey:@"sjCustMark"];
     [[NSUserDefaults standardUserDefaults] setObject:strDate forKey:@"strDate"];
    NSDictionary *dic = @{@"createTime":strDate,@"sjCustMark":sjCustMark};
    _czDicBlock(dic);
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *ss = [[NSUserDefaults standardUserDefaults] objectForKey:@"strDate"];
    NSString *ss1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"sjCustMark"];
    if(ss.length)
    {
    NSDate *da = [dateFormatter dateFromString:ss];
    [_pickerDate setDate:da];
    }
    sjCustMark = @"";
    new_addArr = @[@{@"1":@"新商机"},@{@"2":@"历史商机"},@{@"":@"不限"}];
    new_addBtnArr = [[NSMutableArray alloc] init];
    float btnW = 86;
    float space = (__MainScreen_Width - 86*3)/4;
    for (int i = 0 ; i < new_addArr.count; i ++) {
      
        FX_Button * btn = [[FX_Button alloc] initWithFrame:CGRectMake((space+i*(btnW+space)),390, btnW, 34) andType:@"1" andTitle:@"add" andTarget:self andDic:[new_addArr objectAtIndex:i]];
        [self.view addSubview:btn];
        [new_addBtnArr addObject:btn];
        NSDictionary *dic = [new_addArr objectAtIndex:i];
        if([[[dic allKeys] lastObject] isEqualToString:ss1])
        {
            [btn changeType1Btn:YES];
        }
    }
    [self addNavgationbar:@"录入日期筛选" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark - btn回调
-(void)btnBackDic:(NSDictionary *)dic
{
    
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    if([str isEqualToString:@"add"])
    {
        if(btn.isSelect)
        {
            sjCustMark = [[dic1 allKeys] firstObject];
             [[NSUserDefaults standardUserDefaults] setObject:sjCustMark forKey:@"sjCustMark"];
            for (FX_Button *btnS in new_addBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
        }
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
