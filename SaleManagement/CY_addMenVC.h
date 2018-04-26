//
//   bVC.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/27.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"


@interface CY_addMenVC : Fx_RootViewController<UITextViewDelegate,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scorollviewX;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UITextView *nameText;

@property (weak, nonatomic) IBOutlet UITextView *telText;

@property (weak, nonatomic) IBOutlet UITextView *emailText;
@property (weak, nonatomic) IBOutlet UITextView *phoneText;
@property (weak, nonatomic) IBOutlet UITextView *buMenText;

@property (weak, nonatomic) IBOutlet UILabel *zhiWeiL;
@property (weak, nonatomic) IBOutlet UILabel *comL;

@property (weak, nonatomic) IBOutlet UILabel *saxL;

@property (weak, nonatomic) IBOutlet UIButton *button1;

@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (strong,nonatomic)NSString *custId;

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (nonatomic,strong)NSString *comStr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myView_X;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buMenH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoenH;

@end
