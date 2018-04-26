//
//  ChoseAddWay.h
//  SaleManagement
//
//  Created by feixiang on 16/9/5.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chooseWay)(NSString *) ;

@interface ChoseAddWay : UIViewController
@property(nonatomic,copy)chooseWay chooseWayBlock;

@end
