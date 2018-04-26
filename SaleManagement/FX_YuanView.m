//
//  FX_YuanView.m
//  SaleManagement
//
//  Created by feixiang on 15/11/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "FX_YuanView.h"

@implementation FX_YuanView

- (void)drawRect:(CGRect)rect {
    //饼状图
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [ToolList getColor:@"ff0000"].CGColor);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextMoveToPoint(context, rect.size.width/2 , rect.size.height/2);
    //填充圆，无边框
    CGContextAddArc(context, rect.size.width/2 , rect.size.height/2, (__MainScreen_Width/(2.*158)*82-13)/2, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
    
    //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
    CGContextSetFillColorWithColor(context, [ToolList getColor:@"008100"].CGColor);//填充颜色
    CGContextMoveToPoint(context, rect.size.width/2 , rect.size.height/2);
   

    //填扇形
    CGContextAddArc(context, rect.size.width/2 , rect.size.height/2, (__MainScreen_Width/(2.*158)*82-13)/2, 0, -_hudu*M_PI, 1); //添加一个圆
    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFill);//绘制填充
}
@end
