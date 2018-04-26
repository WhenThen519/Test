//
//  SelectBtn.h
//  SaleManagement
//
//  Created by feixiang on 2017/3/7.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBtn : UIButton
@property(assign,nonatomic)Boolean isSelect;
@property(retain,nonatomic)NSDictionary * myDic;

-(void)changeSelect;
-(instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic;
@end
