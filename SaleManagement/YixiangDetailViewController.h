//
//  YixiangDetailViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/25.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YixiangDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *beizhu_L;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *beizhu_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cui_h;
@property (weak, nonatomic) IBOutlet UITextView *cuiTextView;
@property (weak, nonatomic) IBOutlet UIButton *zuoji_B;
@property (weak, nonatomic) IBOutlet UILabel *qq_L;
@property (weak, nonatomic) IBOutlet UILabel *zuoji_L;
@property (weak, nonatomic) IBOutlet UILabel *need_l;
@property (weak, nonatomic) IBOutlet UILabel *mail_L;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;

@property (weak, nonatomic) IBOutlet UILabel *address_L;
@property (weak, nonatomic) IBOutlet UILabel *linkMan_L;
@property (weak, nonatomic) IBOutlet UILabel *phone_L;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom_h;
@property (weak, nonatomic) IBOutlet UILabel *custName_top;
@property (weak, nonatomic) IBOutlet UILabel *content_L;
@property (weak, nonatomic) IBOutlet UILabel *custName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ji;
@property (weak, nonatomic) IBOutlet UIView *bottom_DoView;
@property (weak, nonatomic) IBOutlet UILabel *laiYun;
@property (weak, nonatomic) IBOutlet UILabel *shiFang;
@property(nonatomic,retain)NSDictionary *dataDic;

@property (weak,nonatomic)IBOutlet UIButton *tel_Bt;

@property (assign,nonatomic)BOOL isSW;//0经理1商务

@end
