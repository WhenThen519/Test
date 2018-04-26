//
//  CY_popupV.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/22.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CY_popupV : UIView

- (id)initWithFrame:(CGRect)frame andMessage:(NSString *)message;

- (id)initWithMessage:(NSDictionary *)message andName:(NSString *)nameStr;//客户详情合同点击页面

- (id)initWithFrame:(CGRect)frame andMessageArr:(NSArray *)messageArr andtarget:(id)target;//客户详情--联系人--拨打多个联系人电话

//添加客户完成后是否返回意向客户弹窗
- (id)initWithFrame:(CGRect)frame andyixiangTitle:(NSString *)title andtarget:(id)target;

//商务-我的客户再联系弹窗
- (id)initWithFrame:(CGRect)frame andMytextArr:(NSArray *)titleArr andtarget:(id)target andTag:(NSInteger)buTag;

//添加联系人验证客户可添加显示1个按钮页面
-(id)initWithFrame:(CGRect)frame andMessage:(NSString *)message andBtTitel:(NSString *)title andtarget:(id)target andTag:(NSInteger)label_tag;

//添加联系人验证客户可添加显示2个按钮页面
-(id)initWithMessage:(NSString *)message andBtTitel_one:(NSString *)title_one andBtTitel_two:(NSString *)title_two andtarget:(id)target andTag:(NSInteger)label_tag;

//扫名片，添加联系人选择保存的公司
- (id)initWithFrame:(CGRect)frame andMyNameArr:(NSArray *)titleArr andtarget:(id)target andTag:(NSInteger)buTag;

@end
