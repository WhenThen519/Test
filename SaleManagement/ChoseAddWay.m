//
//  ChoseAddWay.m
//  SaleManagement
//
//  Created by feixiang on 16/9/5.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "ChoseAddWay.h"

@interface ChoseAddWay ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mianView_h;

@end

@implementation ChoseAddWay
//扫名片
- (IBAction)saoCard:(id)sender
{
    _chooseWayBlock(@"sao");
}
//手动添加
- (IBAction)addByHand:(id)sender
{
    _chooseWayBlock(@"add");
  
}
//消失此提示页
-(void)dismiss
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mianView_h.constant = __MainScreen_Height * 0.28;
    _mainView.layer.cornerRadius = 10;
    _mainView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
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
