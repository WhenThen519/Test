//
//  FangAnViewController.h
//  SaleManagement
//
//  Created by chaiyuan on 16/4/1.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"

@protocol FangAnDelegate <NSObject>

-(void)goVcAndType:(NSString *)typeStrs;//给客户详情页面改变下面的客户状态

@end

@interface FangAnViewController : Fx_RootViewController<UITextFieldDelegate,UITextViewDelegate>


@property (nonatomic,strong)NSString *titleStr;//intentType

@property (nonatomic,strong)NSString *costIdStr;//custId

@property (nonatomic,strong)NSString *custNameStr;//custName

@property (nonatomic,assign)id<FangAnDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgV_top;


@end
