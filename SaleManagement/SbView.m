//
//  SbView.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/6.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "SbView.h"

@implementation SbView
- (IBAction)fancha:(id)sender {
    NSString * str=[NSString stringWithFormat :@"https://m.baidu.com/?from=844b&vit=fps#|src_%@|sa_ib",_nameStr];
    str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)LINK:(id)sender {
    if(_guanwang.text.length)
    {
        NSString * str=[_guanwang.text substringFromIndex:3];
        if(![str hasPrefix:@"http"]){
            str = [NSString stringWithFormat:@"http://%@",[_guanwang.text substringFromIndex:3]];
        }
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
