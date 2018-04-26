//
//  ViewController.h
//  SaleManagement
//
//  Created by feixiang on 15/11/19.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTabBar.h"



@interface ViewController : UIViewController<UIScrollViewDelegate>{
    
    UIScrollView *middleView;//首页总的滑动视图
    
    UIView *_tabbarView;//首页下面的分页图
    UIButton *addBtn;
    handView *xxHand;
    
    UIButton *handImage; //首页图片
    NSMutableArray *bottomBtnArr;
}


- (void)_initTabbarView:(NSArray *)DataArr andNormalImage:(NSArray *)NormalArr andselected:(NSArray *)selectedArr andSelectIndex:(NSInteger)index;//tabar自定义


@end

