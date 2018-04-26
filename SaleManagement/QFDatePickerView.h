//
//  QFDatePickerView.h
//  dateDemo
//
//  Created by 情风 on 2017/1/12.
//  Copyright © 2017年 情风. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFDatePickerView : UIView
/*

 year 为截止年份
 month 为截止月份
  is_Def为NO时 样式即为从下而上的动画展示，添加用show方法，且PickFrame与Select_dic可以填写为空
  is_Def为yes时 样式无动画效果，添加用addsubview方法，且PickFrame为显示的整体Frame，Select_dic为默认选择的年月，key分别为selectedYear  selectecMonth，不可为空。
 */
- (instancetype)initDatePackerWithResponse:(void(^)(NSString*))block andYear:(NSString *)year andMonth:(NSString *)month andPickFrame:(CGRect)PickFrame andButtonHiden:(BOOL)is_Def andSelectdic:(NSDictionary *)Select_dic;

- (void)show;

@end
