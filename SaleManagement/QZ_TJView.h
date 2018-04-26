//
//  QZ_TJView.h
//  SaleManagement
//
//  Created by chaiyuan on 16/7/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_TableView.h"

@interface QZ_TJView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)Fx_TableView *mxTabel;
@property(nonatomic,strong)NSMutableArray *mxArr;
@property (nonatomic,strong)NSMutableDictionary *MXrequestDic;
@property (nonatomic,strong)NSMutableArray *selectBtArr;
@property (nonatomic,strong)NSArray *comArr;

@end
