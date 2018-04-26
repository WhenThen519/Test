//
//  SSCheckBoxView.h
//  SaleManagement
//
//  Created by chaiyuan on 15/11/20.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SSCheckBoxViewStyle_ {
    kSSCheckBoxViewStyleBox = 0,
    kSSCheckBoxViewStyleDark,
    kSSCheckBoxViewStyleGlossy,
    kSSCheckBoxViewStyleGreen,
    kSSCheckBoxViewStyleMono,
    
    kSSCheckBoxViewStylesCount
} SSCheckBoxViewStyle;


@interface SSCheckBoxView : UIView{
    
    UIImageView *checkBoxImageView;
    SEL stateChangedSelector;
    id<NSObject> delegate;
     BOOL enabled;
}

@property (nonatomic, readonly) SSCheckBoxViewStyle style;
@property (nonatomic, readonly) BOOL checked;
@property (nonatomic, getter=enabled, setter=setEnabled:) BOOL enabled;
@property (nonatomic, copy) void (^stateChangedBlock)(SSCheckBoxView *cbv);
@property (nonatomic, retain) UILabel *textLabel;

- (id) initWithFrame:(CGRect)frame
               style:(SSCheckBoxViewStyle)aStyle
             checked:(BOOL)aChecked;

- (void) setText:(NSString *)text;

- (void) setChecked:(BOOL)isChecked;

- (void) setStateChangedTarget:(id<NSObject>)target
                      selector:(SEL)selector;


@end
