//
//  MyFormHeaderView.h
//  victor_server_template
//
//  Created by feixiang on 14-7-17.
//  Copyright (c) 2014年 huangsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFormHeaderView : UIView
@property(nonatomic,strong)NSMutableArray *formArticles;//子项目标题数组
@property(nonatomic,strong)UILabel *contractCodeLabel;//单号
@property(nonatomic,strong)UILabel *moneyLabel;//显示金额

- (id)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic
;
@end
