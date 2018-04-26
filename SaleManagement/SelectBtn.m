//
//  SelectBtn.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/7.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "SelectBtn.h"

@implementation SelectBtn
{
    UILabel *name;
    UIImageView *imageView;
    
}
-(void)changeSelect
{
    if(_isSelect)
    {
        name.textColor = [ToolList getColor:@"BA81FF"];
        [imageView setImage:[UIImage imageNamed:@"trun.png"]];
    }
    else
    {
        name.textColor = [ToolList getColor:@"b3b3b3"];
        [imageView setImage:[UIImage imageNamed:@"filed.png"]];
    }
}
-(instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _myDic = dic;
       

        for (UIView *v in self.subviews) {
            [v removeFromSuperview];
        }
        name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-15, frame.size.height-1)];
        name.text = [dic objectForKey:@"name"];
        name.textColor = [ToolList getColor:@"b3b3b3"];
        name.font = [UIFont systemFontOfSize:16];
        [self addSubview:name];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-60, 0, 60, frame.size.height-1)];
        [imageView setImage:[UIImage imageNamed:@"filed.png"]];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
         [self.layer addSublayer: [ToolList getLineFromPoint:CGPointMake(15, frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width-15, frame.size.height-0.5) andWeight:0.5 andColorString:@"f3f4f5"]];
    }
    return self;
}

@end
