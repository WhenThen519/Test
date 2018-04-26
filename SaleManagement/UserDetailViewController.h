//
//  UserDetailViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/21.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fx_RootViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FangAnViewController.h"

@interface UserDetailViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,FangAnDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

-(id)initwithCust:(NSString *)custID;
@property (nonatomic,strong)NSMutableArray *buMenArr;//部门旗下的商务

@property(nonatomic,retain)NSString *sjFlag;
@property(nonatomic,retain)UILabel *contentL;

@property(nonatomic,retain)NSString *custNameStr;
@property(nonatomic,retain)NSString *backWhere;

@property(nonatomic,copy)NSString *custId;

@property(nonatomic,copy)NSString *oldOrNew;
@property (nonatomic,strong)NSString *flagRefresh;
@property (nonatomic,assign)BOOL isShouCang;//1为收藏夹点击进详情

-(void)makeSjDoview;
@end
