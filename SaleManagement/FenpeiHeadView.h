//
//  FenpeiHeadView.h
//  SaleManagement
//
//  Created by feixiang on 2017/8/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(long) ;

@interface FenpeiHeadView : UIView
@property(nonatomic,retain)UILabel *name_L;
@property(nonatomic,retain)UIButton *image_V;
@property(nonatomic,strong)NSMutableArray *subArr;//子项目数组
@property(nonatomic,assign)Boolean is_Select;//是否选中
@property(nonatomic,copy)chuanzhi cz;
@property(nonatomic,copy)NSDictionary *dataDic;


@end
