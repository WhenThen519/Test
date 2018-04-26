//
//  CY_FilterView.h
//  SaleManagement
//
//  Created by chaiyuan on 15/12/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullDownMenu.h"

@class CY_FilterView;

@protocol FilterViewDelegate <NSObject>

@optional

-(void)filterView:(CY_FilterView *)filterView didSelectedCell:(NSDictionary*)info selectedMenuIndex:(NSInteger)tag;

//-(void)filterViewWillDismiss;
@end

@interface CY_FilterView : UIView

@property (strong, nonatomic) NSArray *dataArray;

@property (assign, nonatomic) BOOL enabled;
@property (assign, nonatomic) BOOL selected;

@property (assign, nonatomic) id<FilterViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
   buttonTitleArray:(NSArray*)titleArray
    dataSourceArray:(NSArray*)dataArray
           delegate:(id<FilterViewDelegate>)delegate;

@end
