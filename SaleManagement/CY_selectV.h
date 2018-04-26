//
//  CY_selectV.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/11.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZLocation.h"

typedef enum {
    HZAreaPickerWithStateAndCity,
    HZAreaPickerWithStateAndCityAndDistrict
} HZAreaPickerStyle;

@class HZAreaPickerView;

@protocol HZAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;
- (void)changeNativePlace:(NSString *)string andPid:(NSString *)pid andcityid:(NSString *)cityId andareaid:(NSString *)areaid;//点击完成回调

@end

@interface CY_selectV : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)IBOutlet UIPickerView *locatePicker;

@property (assign, nonatomic) id <HZAreaPickerDelegate> delegate;
@property (strong, nonatomic) HZLocation *locate;
@property (nonatomic) HZAreaPickerStyle pickerStyle;

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate Province:(NSString *)province City:(NSString *)city District:(NSString *)district;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
