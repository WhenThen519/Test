//
//  CY_chooseVc.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/6.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^changeString)(NSString *) ;

typedef void (^changeDic)(NSDictionary *) ;

@protocol typeDelegate <NSObject>

-(void)chooseType:(NSString *)type andTitle:(NSString *)title;

@end

@interface CY_chooseVc : UIViewController<typeDelegate>


@property(nonatomic,copy)changeString changeBlock;
@property(nonatomic,copy)changeDic changeDicBlock;

@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic, assign) id <typeDelegate> delegate;

@property(nonatomic,assign)BOOL isZhiWei;

@end
