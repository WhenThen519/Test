//
//  CY_addClientVc.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/4.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "textView.h"
#import "CY_addTextView.h"
#import "CY_selectV.h"

//typedef void (^addKH_Data)(NSDictionary *);//从写记录过来的，把添加好的客户及联系人，手机号带回去

@interface CY_addClientVc : UIViewController<chooseDelegate,HZAreaPickerDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)UIViewController * ss;

@property (nonatomic,strong)NSString *comString;//公司名称

@property (nonatomic,strong)NSDictionary *dataDic;//意向客户数据

@property (nonatomic,assign)BOOL isShou;//是否首页过来

@property (nonatomic,assign)BOOL isYiBool;//从意向客户保护跳转过来

@property(nonatomic,assign)BOOL isMP;//是否从扫名片过来的

//@property(nonatomic,copy)addKH_Data add_Block;


@end
