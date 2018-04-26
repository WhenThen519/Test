//
//  GetAreaXJViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 16/7/14.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "GetAreaXJViewController.h"
#import "QZ_TJView.h"
#import "QZ_MXView.h"

#define CYHANDVIEW_H 44
@interface GetAreaXJViewController (){
   
    FX_Button *TJBtn;//统计按钮
    FX_Button *MXBtn;//明细按钮
    
}

@property(nonatomic,strong)QZ_MXView *mxV;
@property(nonatomic,strong)QZ_TJView *tjV;
@end

@implementation GetAreaXJViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];

}


- (void)viewDidLoad {
    [super viewDidLoad];

     [self makeMyView];
}


#pragma mark  ---- ---创建页面
-(void)makeMyView{
    
    {
        
        NSArray *typeA = @[@"统计",@"明细"];
        
        [self addNavgationbar:@"净现金到账明细" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
        
        //头部点击操作区域-- @"统计",@"明细"
        UIImageView *handV = [[UIImageView alloc]initWithFrame:CGRectMake(0,IOS7_Height, __MainScreen_Width, CYHANDVIEW_H)];
        handV.userInteractionEnabled = YES;
        handV.image = [UIImage imageNamed:@"bg_filter.png"];
        [self.view addSubview:handV];
        
        TJBtn = [[FX_Button alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width/2, SelectViewHeight+2-0.8) andType:@"4" andTitle:[typeA objectAtIndex:0] andTarget:self andDic:nil];
        TJBtn.tag = 0;
        TJBtn.isSelect = YES;
        [TJBtn changeBigAndColorCliked:TJBtn];
        [handV addSubview:TJBtn];
        
        MXBtn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, SelectViewHeight+2-0.8) andType:@"4" andTitle:[typeA objectAtIndex:1] andTarget:self andDic:nil];
        MXBtn.tag = 1;
        [handV addSubview:MXBtn];
        
        if ( TJBtn.isSelect) {
            
            _mxV = [[QZ_MXView alloc]initWithFrame:CGRectMake(0, CYHANDVIEW_H+IOS7_Height, __MainScreen_Width, __MainScreen_Height-CYHANDVIEW_H-IOS7_Height)];
            [self.view insertSubview:_mxV atIndex:0];
        }
        
     
    }
     
}

#pragma mark ---- 统计、明细
-(void)changeBigAndColorClikedBack:(FX_Button *)sender{
    
    sender.isSelect = YES;
    [sender changeBigAndColorCliked:sender];
    
    if (sender.tag ==0) {// 统计、
        
        MXBtn.isSelect = NO;
        [MXBtn changeBigAndColorCliked:MXBtn];
        
        if (_mxV == nil) {
            
            _mxV = [[QZ_MXView alloc]initWithFrame:CGRectMake(0, CYHANDVIEW_H+IOS7_Height, __MainScreen_Width, __MainScreen_Height-CYHANDVIEW_H-IOS7_Height)];
            [self.view insertSubview:_mxV atIndex:0];
            
        }else{
            
            [self.view insertSubview:_mxV aboveSubview:_tjV];
        }
        
    }else{//明细
        
        
        TJBtn.isSelect = NO;
        [TJBtn changeBigAndColorCliked:TJBtn];
        
        if (_tjV == nil) {
            
            _tjV = [[QZ_TJView alloc]initWithFrame:CGRectMake(0, CYHANDVIEW_H+IOS7_Height, __MainScreen_Width, __MainScreen_Height-CYHANDVIEW_H-IOS7_Height)];
            [self.view insertSubview:_tjV aboveSubview:_mxV];
            
        }else{
            
             [self.view insertSubview:_tjV aboveSubview:_mxV];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
