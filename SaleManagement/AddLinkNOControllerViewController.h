//
//  AddLinkNOControllerViewController.h
//  SaleManagement
//
//  Created by feixiang on 2016/11/16.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"
typedef void (^chuanzhi)(NSDictionary *) ;
@interface AddLinkNOControllerViewController : Fx_RootViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,copy)chuanzhi czDicBlock;
@property(nonatomic,copy)NSString *linkManId;
@property(nonatomic,retain)NSMutableArray *mobilePhones;
@end
