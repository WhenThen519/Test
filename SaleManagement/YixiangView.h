//
//  YixiangView.h
//  SaleManagement
//
//  Created by feixiang on 2017/7/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YixiangView : UIView
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *giveUpTimes;
@property(nonatomic,copy)NSString *reaDate;
@property(nonatomic,copy)NSString *reason;

-(instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic andflag:(BOOL)isflag;

@end
