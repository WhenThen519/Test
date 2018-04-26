//
//  CY_writContenVc.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/19.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@interface CY_writContenVc : Fx_RootViewController<UITextViewDelegate>

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDic:(NSDictionary *)dic andListArr:(NSArray *)listArr;

@end
