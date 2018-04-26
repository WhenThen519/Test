//
//  AddNewScheduleViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/3/30.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.H"

@interface AddNewScheduleViewController : Fx_RootViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *leixing_L;
@property (weak, nonatomic) IBOutlet UILabel *kaishi_L;
@property (weak, nonatomic) IBOutlet UILabel *jieshu_L;
@property (weak, nonatomic) IBOutlet UILabel *guanlian_L;
@property (copy, nonatomic)  NSString *guanlian_Id;
@property (copy, nonatomic)  NSString *guanlian_Str;

@property (weak, nonatomic) IBOutlet UILabel *tixiang_L;
@property (weak, nonatomic) IBOutlet UITextView *beizhu_TextView;
@property (copy, nonatomic)  NSDictionary *recedic_dic;
@property (weak, nonatomic) IBOutlet UIScrollView *main_scroll;

@end
