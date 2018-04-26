//
//  Fx_RootViewController.h
//  SaleManagement
//
//  Created by feixiang on 15/12/22.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Fx_RootViewController : UIViewController

@property(nonatomic,retain)UIView *headview;
@property(nonatomic,retain)UIButton *btnR;
-(void)addNavgationbar:(NSString *)titleStr leftImageName:(NSString *)leftImageName rightImageName:(NSString *)rightImageName target:(id)target leftBtnAction:(NSString *)leftBtnAction rightBtnAction:(NSString *)rightBtnAction leftHiden:(BOOL)leftHiden  rightHiden:(BOOL)rightHiden;
-(void)addNavgationbar:(NSString *)titleStr leftBtnName:(NSString *)leftBtnName rightBtnName:(NSString *)rightBtnName target:(id)target leftBtnAction:(NSString *)leftBtnAction rightBtnAction:(NSString *)rightBtnAction ;
@end
