//
//  SbView.h
//  SaleManagement
//
//  Created by feixiang on 2017/3/6.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SbView : UIView
@property (weak, nonatomic) IBOutlet UIButton *xin;
@property (weak, nonatomic) IBOutlet UIButton *guan;
@property (weak, nonatomic) IBOutlet UIButton *tui;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *dizhi;
@property (weak, nonatomic) IBOutlet UILabel *guimo;
@property (weak, nonatomic) IBOutlet UILabel *zhucezijin;
@property (weak, nonatomic) IBOutlet UILabel *guanwang;
@property (weak, nonatomic) IBOutlet UILabel *hangye;
@property (weak, nonatomic) IBOutlet UILabel *chenglishijian;
@property(copy,nonatomic)NSString *nameStr;

@property (weak, nonatomic) IBOutlet UIButton *fancha;

@end
