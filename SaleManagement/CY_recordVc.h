//
//  CY_recordVc.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/8.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
#import "Fx_TableView.h"
#import <AVFoundation/AVFoundation.h>

@interface CY_recordVc : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic,copy)NSString * salerId;//商务ID，当有商务筛选时传入
@property (nonatomic,copy)NSString * deptId;//部门ID，当有部门筛选时传入
@property (nonatomic,copy)NSString * state;//状态，0=全部 1=待回访 2=有效回访3=陪访
@property(nonatomic,copy)NSString *businessYear;
@property(nonatomic,copy)NSString *businessMonth;

@end
