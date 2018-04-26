//
//  CY_OneRecordVC.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/19.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CY_OneRecordVC : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>


@property (nonatomic,strong)NSDictionary *dataDic;

@property (nonatomic,assign)int zanNum;

@property (nonatomic,assign)int isZan;

@end
