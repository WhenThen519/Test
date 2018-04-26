//
//  SearchViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^chuanzhi)(NSDictionary *) ;

@interface SearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
}
@property(nonatomic,copy)chuanzhi czBlock;
@property(nonatomic,strong)NSMutableDictionary *swSearchRequestDic;//待分配页面传输的数据

@property (nonatomic,assign)BOOL isMyclient;

@property (nonatomic,strong)NSString *type;//1.收藏夹2.我的客户（保护库，签约库，流失客户，共享客户）3.部门客户4.分司客户

@end
