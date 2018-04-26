//
//  UIControl+UIControl_XY.m
//  SaleManagement
//
//  Created by feixiang on 16/3/9.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "UIControl+UIControl_XY.h"
#import <objc/runtime.h>
@implementation UIControl (UIControl_XY)
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";
- (NSTimeInterval )wfx_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setWfx_acceptEventInterval:(NSTimeInterval)wfx_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(wfx_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )wfx_acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setWfx_acceptEventTime:(NSTimeInterval)wfx_acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(wfx_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(wfx_sendAction:to:forEvent:));
    SEL mySEL = @selector(wfx_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    //如果方法已经存在了
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
    
    //---------以上主要是实现两个方法的互换,load是gcd的只shareinstance，果断保证执行一次
    
}

- (void)wfx_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (NSDate.date.timeIntervalSince1970 - self.wfx_acceptEventTime < self.wfx_acceptEventInterval) {
        return;
    }
    
    if (self.wfx_acceptEventInterval > 0) {
        self.wfx_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self wfx_sendAction:action to:target forEvent:event];
}
@end
