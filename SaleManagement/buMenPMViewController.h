//
//  buMenPMViewController.h
//  SaleManagement
//
//  Created by known on 16/6/16.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface buMenPMViewController : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIView *duanBlackView;
    //总监所有部门
    NSArray *buMenArr;
    UIScrollView *selectContentScrollView;
    NSMutableArray *bumenBtnArr;
    UIView *duanView;
    NSMutableArray *riqiBtnArr;
    NSString *bumenId;
    NSString *riqiId;
    UIButton * Select_Btn;
    UIButton * SWSelect_Btn;
    BOOL request;
    //分司
    NSArray *fenSiBMArr;
    NSMutableArray *fensiBtnArr;
    NSString *mrfensiId;
    NSString *mrbmId;
    UIButton * qzSelect_Btn;
    //部门
    NSArray *fsBMArr;
    NSMutableArray *fsBMBtnArr;

}
//分司
@property (strong, nonatomic)NSMutableArray *fenSiArray;

@property (nonatomic,strong)NSMutableDictionary *requestDic;
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *tableArr;
@property (nonatomic,strong)NSMutableArray *jieduanButtonArr;

@end
