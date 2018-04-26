//
//  QZtiaoZhengViewController.h
//  SaleManagement
//
//  Created by known on 16/7/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface QZtiaoZhengViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

{
    UITableView * table;
    int _selectedRow ;
    BOOL isSelected;
    BOOL SouSuo;
    
}
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *souSdataArr;

@property (nonatomic,strong)NSString *marketId;
@property (nonatomic,strong)NSString *custId;
@property (nonatomic,strong)NSMutableDictionary *requestDic;

@property (nonatomic,strong)NSMutableDictionary *data_Dic;//承载上一个页面传送过来的参数
@end
