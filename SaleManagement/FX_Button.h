//
//  FX_Button.h
//  SaleManagement
//
//  Created by feixiang on 15/11/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FX_Button : UIButton
@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,assign)id target;
@property(nonatomic,retain)NSDictionary * dic;
-(void)changeBigAndColorCliked:(UIButton *)btn;
-(void)change:(NSString *)flag;
-(void)changeType1Btn:(BOOL )flag;
-(void)changeColorCliked1:(BOOL )flag;

- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type andTitle:(NSString *)title andTarget:(id)target andDic:(NSDictionary *)dic;
@end
