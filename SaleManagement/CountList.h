//
//  CountList.h
//  SaleManagement
//
//  Created by feixiang on 2017/3/6.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"
#import "Fx_TableView.h"
#import "UIImageView+WebCache.h"
#define LUN_TAG 109
#define ZAN_TAG 1232

@interface CountList : Fx_RootViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)Fx_TableView *countTabel;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSString *custId;
@property (nonatomic,strong)UIImageView *loadingImage;

@property (nonatomic,strong)NSMutableArray *emojiImages;
@property (nonatomic,strong)NSMutableArray *emojiTags;
@property (nonatomic,strong)NSMutableArray *bigUrlArr;
@end
