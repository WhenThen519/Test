//
//  New_ShouCangDetail.h
//  SaleManagement
//
//  Created by feixiang on 2017/3/1.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface New_ShouCangDetail : Fx_RootViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (weak, nonatomic) IBOutlet UILabel *zhongjian2;
@property (weak, nonatomic) IBOutlet UILabel *zhongjian1;
@property (weak, nonatomic) IBOutlet UILabel *gongji;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *zuixinjilu;

@property (weak, nonatomic) IBOutlet UILabel *lianxiren;
@property (weak, nonatomic) IBOutlet UIButton *xin;
@property (weak, nonatomic) IBOutlet UIButton *guan;
@property (weak, nonatomic) IBOutlet UILabel *chenglishijian;
@property (weak, nonatomic) IBOutlet UIButton *tui;
@property (weak, nonatomic) IBOutlet UILabel *hangye;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UILabel *guanwang;
@property (weak, nonatomic) IBOutlet UILabel *guimo;
@property (weak, nonatomic) IBOutlet UILabel *zhucezijin;
@property (retain, nonatomic)  NSDictionary *receiveDic;
@property (weak, nonatomic) IBOutlet UILabel *jilu;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiluX;

@property (weak, nonatomic) IBOutlet UILabel *UILabel1;
@property (weak, nonatomic) IBOutlet UILabel *UILabel2;
@property (weak, nonatomic) IBOutlet UILabel *UILabel3;

@property (weak, nonatomic) IBOutlet UILabel *ShangJiL;
@property (weak, nonatomic) IBOutlet UIScrollView *shangJiScroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shangJiSH;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigViewHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blackHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shangjW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1x;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shangjY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shangjH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jiluY;

@end
