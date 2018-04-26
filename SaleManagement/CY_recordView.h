//
//  CY_recordView.h
//  SaleManagement
//
//  Created by chaiyuan on 2017/2/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
#import "backUpVC.h"

@interface CY_recordView : Fx_RootViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(retain,nonatomic)NSDictionary *from_dic;
@property(retain,nonatomic)NSString *custName;
@property(retain,nonatomic)NSDictionary *fromAll_dic;

@property (weak, nonatomic) IBOutlet UIButton *button1;//收藏

@property (weak, nonatomic) IBOutlet UIButton *button2;//保护
@property (weak, nonatomic) IBOutlet UIButton *button3;//放弃
@property (weak, nonatomic) IBOutlet UIView *telView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewH;
@property (weak, nonatomic) IBOutlet UILabel *custNameL;
@property (weak, nonatomic) IBOutlet UILabel *linkNameL;



@end
