//
//  FX_Label.m
//  SaleManagement
//
//  Created by feixiang on 15/11/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "FX_Label.h"

@implementation FX_Label

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [ToolList getColor:@"817bd8"];
        self.font = [UIFont systemFontOfSize:11.];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 1;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andTitleColor:(UIColor *)titleColor andFont:(float)fontFlot andMent:(NSTextAlignment)ment andLines:(NSInteger)lines
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = titleColor;
        self.font = [UIFont systemFontOfSize:fontFlot];
        self.textAlignment = ment;
        self.numberOfLines = lines;
    }
    return self;
}

@end
