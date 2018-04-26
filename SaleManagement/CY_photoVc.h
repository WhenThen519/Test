//
//  CY_photoVc.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CY_photoVc : UIViewController<UIScrollViewDelegate>

@property (retain, nonatomic) NSArray * pArray;//图片url数组
@property (nonatomic, assign) NSInteger   currentPage;//当前页数

@end
