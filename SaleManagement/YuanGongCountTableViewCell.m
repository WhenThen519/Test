//
//  YuanGongCountTableViewCell.m
//  SaleManagement
//
//  Created by feixiang on 15/12/31.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "YuanGongCountTableViewCell.h"

@implementation YuanGongCountTableViewCell

- (void)awakeFromNib {
    _bottomView.layer.borderWidth = 0.5;
    _bottomView.layer.borderColor = [ToolList getColor:@"dddddd"].CGColor;
    CGRect frame =  _line.frame ;
    _line.frame = CGRectMake(__MainScreen_Width*0.37, frame.origin.y, 1, frame.size.height);
    //画虚线
    
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = 0.5f;
    [lineShape setLineJoin:kCALineJoinRound];
    [lineShape setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
      [NSNumber numberWithInt:2],nil]];
    lineShape.strokeColor = [[ToolList getColor:@"dddddd"] CGColor];
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat toX = 0;
    CGFloat toY = _line.frame.size.height;
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    lineShape.path = linePath;
    [[_line layer] addSublayer:lineShape];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
