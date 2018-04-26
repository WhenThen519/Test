//
//  UIControl+UIControl_XY.h
//  SaleManagement
//
//  Created by feixiang on 16/3/9.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
//防止按钮重复点击
@interface UIControl (UIControl_XY)
@property (nonatomic, assign) NSTimeInterval wfx_acceptEventInterval;// 可以用这个给重复点击加间隔
@property (nonatomic, assign) NSTimeInterval wfx_acceptEventTime;

@end
