//
//  MyFormHeaderView.m
//  victor_server_template
//
//  Created by feixiang on 14-7-17.
//  Copyright (c) 2014年 huangsm. All rights reserved.
//
#import "MyFormHeaderView.h"
@implementation MyFormHeaderView


- (id)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic 
{
    
    self = [super initWithFrame:frame];
    if (self) {
       
        self.backgroundColor = [ToolList getColor:@"f2f3f5"];
        //金钱label
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width-150, 0, 135, 45)];
        self.moneyLabel.backgroundColor = [UIColor clearColor];
        self.moneyLabel.textColor = [ToolList getColor:@"ff3333"];
        self.moneyLabel.font = [UIFont systemFontOfSize:16];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"surplusTotalMoneyAll"]];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.moneyLabel];
        //单号label
        self.contractCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 45)];
        self.contractCodeLabel.backgroundColor = [UIColor clearColor];
        self.contractCodeLabel.textColor = [ToolList getColor:@"666666"];
        self.contractCodeLabel.font = [UIFont systemFontOfSize:16];
        self.contractCodeLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"contractCode"]];
        [self addSubview:self.contractCodeLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
