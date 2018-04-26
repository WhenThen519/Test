//
//  Select.h
//  SaleManagement
//
//  Created by feixiang on 2017/3/7.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(NSDictionary *) ;

@interface Select : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_h7;

@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIView *view_Shi;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheng_h_t;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qu_h_t;
@property (weak, nonatomic) IBOutlet UIView *view_Qu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qu_h;
@property (weak, nonatomic) IBOutlet UIButton *hide1;
@property (weak, nonatomic) IBOutlet UIView *hide2;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherBtn_h;

@property (weak, nonatomic) IBOutlet UIView *view_Sheng;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shi_h_t;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shi_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheng_h;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tuiSubView_h;
@property (weak, nonatomic) IBOutlet UIView *tuiSubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screen_w;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h_8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h5;
@property(nonatomic,copy)chuanzhi czDicBlock;
@property (weak, nonatomic) IBOutlet UIButton *baidu;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baidu_h;
@property (weak, nonatomic) IBOutlet UIView *baiduView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baiduView_h;
@property (weak, nonatomic) IBOutlet UIButton *ICP;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ICP_h;
@property (weak, nonatomic) IBOutlet UIView *ICPView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ICPView_h;

@property (weak, nonatomic) IBOutlet UIView *view_city;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_city_h;

@property (retain, nonatomic)  NSArray *arr1;
@property (retain, nonatomic)  NSArray *arr2;
@property (retain, nonatomic)  NSArray *arr3;
@property (retain, nonatomic)  NSArray *arr4;
@property (retain, nonatomic)  NSArray *arr5;
@property (retain, nonatomic)  NSArray *arr6;
@property (retain, nonatomic)  NSArray *arr7;
@property (retain, nonatomic)  NSArray *arr8;
@property (retain, nonatomic)  NSArray *arr9;
@property (retain, nonatomic)  NSArray *arr10;


@property (retain, nonatomic)  NSArray *createTime;//创建时间
@property (retain, nonatomic)  NSArray *industryclassBig;//行业
@property (retain, nonatomic)  NSArray *registerMoney;//注册资金
@property (retain, nonatomic)  NSArray *registerPeopleNum;//企业规模
@property (retain, nonatomic)  NSArray *baiduExponent;//百度指数
@property (retain, nonatomic)  NSArray *icpDateFilter;//ICP
@property (retain, nonatomic)  NSArray *channeList;//推广数量

@property(nonatomic,strong) NSArray *provinceS;
@property(nonatomic,strong) NSArray *cityS;
@property(nonatomic,strong) NSArray *areas;
@property(nonatomic,strong) NSArray *markets;//市场

@property(nonatomic,strong)IBOutlet UIButton *scBt;

-(void)createView;

@end
