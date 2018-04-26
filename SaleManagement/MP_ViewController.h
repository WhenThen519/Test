//
//  MP_ViewController.h
//  SaleManagement
//
//  Created by chaiyuan on 16/8/29.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@interface MP_ViewController : Fx_RootViewController<UIScrollViewDelegate,UITextViewDelegate,typeDelegate>

@property(nonatomic,strong)UIImage *photoImage;

@property (nonatomic,strong)NSString *vcardString;//名片解析返回数据

@property(nonatomic,weak)IBOutlet UIImageView *bigImage;
@property(nonatomic,weak)IBOutlet UIScrollView *MyScroll;
@property(nonatomic,weak)IBOutlet UIView *Myview;

@property(nonatomic,weak)IBOutlet UIView *view1;
@property(nonatomic,weak)IBOutlet UIView *view2;
@property(nonatomic,weak)IBOutlet UIView *view3;
@property(nonatomic,weak)IBOutlet UIView *view4;
@property(nonatomic,weak)IBOutlet UIView *view5;
@property(nonatomic,weak)IBOutlet UIView *view6;
@property(nonatomic,weak)IBOutlet UIView *view7;
@property(nonatomic,weak)IBOutlet UIView *view8;
@property(nonatomic,weak)IBOutlet UIView *view9;
@property(nonatomic,weak)IBOutlet UIView *view10;
@property(nonatomic,weak)IBOutlet UIView *view11;
@property(nonatomic,weak)IBOutlet UIView *view12;
@property(nonatomic,weak)IBOutlet UIView *view13;
@property (weak, nonatomic) IBOutlet UIView *view14;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH7;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH11;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH12;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH13;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH14;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myViewH;

@property(nonatomic,strong)NSMutableArray *custArr;//添加客户传回来的CUSTID\CUSTNAME,里面存有所有经过验证的公司

@property(nonatomic,copy)NSString *custName;
@property(nonatomic,copy)NSString *custID    ;

@end
