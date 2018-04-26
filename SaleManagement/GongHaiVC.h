//
//  GongHaiVC.h
//  SaleManagement
//
//  Created by chaiyuan on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CY_FilterView.h"

@protocol GongHaiDelegate <NSObject>

-(void)shaixuanCommit:(UIButton *)btn;
-(void)diquCommit:(UIButton *)btn;

@end

@interface GongHaiVC : UIViewController<UITableViewDataSource,UITableViewDelegate,FilterViewDelegate,UITextFieldDelegate,GongHaiDelegate>{
    
    UIView *selectTuijianView;
    UIView *selectDiQuView;
    UIScrollView *selectTuijianContentView;
    UIView *selectView;
    //地区筛选内容
    UIScrollView *selectDiQuContentView;

    
    BOOL isSelect;//是否可点击
}

@end
