//
//  backUpVC.h
//  SaleManagement
//
//  Created by chaiyuan on 2017/3/2.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
@interface backUpVC : Fx_RootViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bgview;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *btView;

@property (weak, nonatomic) IBOutlet UIView *butomV;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBgH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgH;

@property (weak, nonatomic) IBOutlet UIButton *bt1;

@property (weak, nonatomic) IBOutlet UIButton *bt2;
@property (weak, nonatomic) IBOutlet UIButton *bt3;
@property (weak, nonatomic) IBOutlet UIButton *bt4;
@property (weak, nonatomic) IBOutlet UIButton *bt5;
@property (weak, nonatomic) IBOutlet UIButton *bt6;
@property (weak, nonatomic) IBOutlet UIButton *bt7;
@property (weak, nonatomic) IBOutlet UIButton *bt8;
@property (weak, nonatomic) IBOutlet UIButton *bt9;
@property (weak, nonatomic) IBOutlet UIButton *bt10;
@property (weak, nonatomic) IBOutlet UIButton *bt11;
@property (weak, nonatomic) IBOutlet UIButton *bt12;
@property (weak, nonatomic) IBOutlet UILabel *custL;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIView *telView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telH;

@property (retain, nonatomic)  NSDictionary *dataDic;
@property (retain, nonatomic)  NSString *custName;
@end
