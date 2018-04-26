//
//  PullDownMenu.h
//  SaleManagement
//
//  Created by chaiyuan on 15/12/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPullDownKey @"salerId"
#define kPullDownValue @"salerName"
#define kPullDownChildren @"deptEmp"

@class PullDownMenu;

@protocol PullDownMenuDelegate<NSObject>

@optional

-(void)pullDownMenu:(PullDownMenu*)pullDownMenu didSelectedCell:(NSDictionary*)info selectedMenuIndex:(NSInteger)tag;

-(void)pullDownMenuWillDismiss:(PullDownMenu*)pullDownMenu;

-(void)pullDownMenuDidDismiss:(PullDownMenu*)pullDownMenu;

-(void)getDic:(NSDictionary *)dic andDepID:(NSString *)depId andDepName:(NSString *)depName;

@end

@interface PullDownMenu : NSObject

@property (assign, nonatomic) id<PullDownMenuDelegate> delegate;

+ (instancetype)sharedMenu;

+ (void)showMenuBelowView:(UIView *)filterView
                    array:(NSArray *)array
        selectedMenuIndex:(NSInteger)tag
           selectedDetail:(NSDictionary*)selectedDetail
                 delegate:(id<PullDownMenuDelegate>)delegate;

+ (void)dismissActiveMenu:(void (^)(BOOL finished))completion;
+ (void)dismissActiveMenu;

+ (BOOL)isMenuActive;

@end
