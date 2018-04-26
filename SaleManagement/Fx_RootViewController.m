//
//  Fx_RootViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/12/22.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface Fx_RootViewController ()

@end

@implementation Fx_RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//默认返回上一级
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)addNavgationbar:(NSString *)titleStr leftImageName:(NSString *)leftImageName rightImageName:(NSString *)rightImageName target:(id)target leftBtnAction:(NSString *)leftBtnAction rightBtnAction:(NSString *)rightBtnAction leftHiden:(BOOL)leftHiden  rightHiden:(BOOL)rightHiden
{
    _headview = [[UIView alloc] initWithFrame:CGRectMake(0,0 , __MainScreen_Width, IOS7_Height)];
    [_headview.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.8) toPoint:CGPointMake(__MainScreen_Width, IOS7_Height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    _headview.backgroundColor = [ToolList getColor:@"fbfbfc"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, IOS7_StaticHeight, 64, 44);
    if(leftImageName)
    {
        [btn setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    }
    if (leftBtnAction) {
        [btn addTarget:target action:NSSelectorFromString(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btn addTarget:target action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    UIButton *btnR = [UIButton buttonWithType:UIButtonTypeCustom];
    btnR.frame = CGRectMake(__MainScreen_Width- 44, IOS7_StaticHeight, 44, 44);
    if(rightImageName)
    {
        [btnR setImage:[UIImage imageNamed:rightImageName] forState:UIControlStateNormal];
    }
    else
    {
        [btnR setImage:[UIImage imageNamed:@"btn_search_homepage.png"] forState:UIControlStateNormal];
    }
    if(rightBtnAction)
    {
        [btnR addTarget:target action:NSSelectorFromString(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_headview];
    if(!leftHiden)
    {
        [_headview addSubview:btn];
    }
    if(!rightHiden)
    {
        [_headview addSubview:btnR];
    }
    if(titleStr)
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, IOS7_StaticHeight, __MainScreen_Width-100, 44)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [ToolList getColor:@"333333"];
        title.text = titleStr;
        title.font = [UIFont systemFontOfSize:19];
        [_headview addSubview:title];
    }
}

-(void)addNavgationbar:(NSString *)titleStr leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName target:(id)target leftBtnAction:(NSString *)leftBtnAction rightBtnAction:(NSString *)rightBtnAction
{
    _headview = [[UIView alloc] initWithFrame:CGRectMake(0,0 , __MainScreen_Width, IOS7_Height)];
    [_headview.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.8) toPoint:CGPointMake(__MainScreen_Width, IOS7_Height-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    _headview.backgroundColor = [ToolList getColor:@"fbfbfc"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, IOS7_StaticHeight, 64, 44);
    [btn setTitle:leftBtnName forState:UIControlStateNormal];
    [btn setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    if ([leftBtnName length]==0) {
        [btn setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal]; 
    }
    if (leftBtnAction) {
        [btn addTarget:target action:NSSelectorFromString(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [btn addTarget:target action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _btnR = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnR.frame = CGRectMake(__MainScreen_Width- 74, IOS7_StaticHeight, 74, 44);
    [_btnR setTitle:rightBtnName forState:UIControlStateNormal];
    [_btnR setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
    _btnR.titleLabel.font = [UIFont systemFontOfSize:17];
    if(rightBtnAction)
    {
        _btnR.wfx_acceptEventInterval = 0.5;
        [_btnR addTarget:target action:NSSelectorFromString(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_headview];
    
    if(titleStr)
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, IOS7_StaticHeight, __MainScreen_Width-100, 44)];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [ToolList getColor:@"333333"];
        title.text = titleStr;
        title.font = [UIFont systemFontOfSize:19];
        [_headview addSubview:title];
    }
    [_headview addSubview:btn];
    [_headview addSubview:_btnR];
    
    
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
