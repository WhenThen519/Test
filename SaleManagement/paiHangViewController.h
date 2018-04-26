//
//  paiHangViewController.h
//  SaleManagement
//
//  Created by known on 16/6/13.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CEOController.h"
#import "Fx_RootViewController.h"

@interface paiHangViewController : UIViewController
{
    
    int count;
    UILabel *_huadongLabel;
    NSString *subRank;
    NSString *deptRank;
    NSString *countryRank;
    NSString *areaRank;
    UILabel *_zjlabel;
    NSMutableArray *jlArr;
    NSMutableArray *swArr;
    UIView *huadong ;
    UIScrollView * _abstractScrollview;
    NSInteger _startIndex;
    NSTimer *_timer;
    UIScrollView *middleView;
}
@end
