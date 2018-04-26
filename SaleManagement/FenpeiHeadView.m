//
//  FenpeiHeadView.m
//  SaleManagement
//
//  Created by feixiang on 2017/8/31.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "FenpeiHeadView.h"

@implementation FenpeiHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _name_L = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 45)];
        _name_L.font = [UIFont systemFontOfSize:16];
        _name_L.textColor = [ToolList getColor:@"7d7d7d"];
        _image_V = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        _image_V.frame = CGRectMake(0, 0, __MainScreen_Width, 45);
        _image_V.imageEdgeInsets = UIEdgeInsetsMake(0, __MainScreen_Width-80,0, 0);
        [_image_V setImage:[UIImage imageNamed:@"filed"] forState:UIControlStateNormal];
        _image_V.contentMode = UIViewContentModeCenter;
        [_image_V addTarget:self action:@selector(cc) forControlEvents:UIControlEventTouchUpInside];
        //线
        [self.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 44.5) toPoint:CGPointMake(__MainScreen_Width, 44.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        [self addSubview:_name_L];
        [self addSubview:_image_V];
    }
    return self;
}
-(void)cc
{
    _cz(self.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
