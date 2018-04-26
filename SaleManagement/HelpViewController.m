//
//  HelpViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 2017/3/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation HelpViewController

-(void)goBack{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _top.constant = IOS7_Height + 6;
    //标题
    [self addNavgationbar:@"帮助" leftImageName:nil rightImageName:nil target:self leftBtnAction:@"goBack" rightBtnAction:nil leftHiden:NO rightHiden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
