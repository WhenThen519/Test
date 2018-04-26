//
//  FX_Button.m
//  SaleManagement
//
//  Created by feixiang on 15/11/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "FX_Button.h"

@implementation FX_Button
{
    CAShapeLayer *blueLine;
}
-(void)changeType1Btn:(BOOL )flag
{
    _isSelect = flag;
    if(!flag)
    {
        [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        self.layer.borderColor = [ToolList getColor:@"dddddd"].CGColor;
    }
    else
    {
        [self setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
        self.layer.borderColor = [ToolList getColor:@"6052ba"].CGColor;
    }
}
//带底色按钮点击
-(void)changeColorCliked1:(BOOL )flag
{
    _isSelect = flag;
    if(flag)
    {
        [self setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
        self.layer.borderColor = [ToolList getColor:@"BA81FF"].CGColor;
        self.backgroundColor = [ToolList getColor:@"BA81FF"];
        
    }
    else
    {
        [self setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
        self.layer.borderColor = [ToolList getColor:@"dedede"].CGColor;
        self.backgroundColor = [UIColor whiteColor];
    }
    
}
//带边框按钮点击
-(void)changeColorCliked:(FX_Button *)btn
{
    _isSelect = !_isSelect;
    if(_isSelect)
    {
        [self setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
        self.layer.borderColor = [ToolList getColor:@"6052ba"].CGColor;
        
    }
    else
    {
        [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        self.layer.borderColor = [ToolList getColor:@"dddddd"].CGColor;
    }
    if([_target respondsToSelector:@selector(btnBackDic:)])
    {
        [_target performSelector:@selector(btnBackDic:) withObject:_dic];
    }
}
-(void)hellohh:(UIButton *)btn
{
    if([_target respondsToSelector:@selector(btnBackDic:)])
    {
        [_target performSelector:@selector(btnBackDic:) withObject:_dic];
    }
}
-(void)changeBigAndColorCliked1:(UIButton *)btn

{
    
    if([_target respondsToSelector:@selector(changeBigAndColorClikedBack:)])
    {
        [_target performSelector:@selector(changeBigAndColorClikedBack:) withObject:self];
    }
}
-(void)changeBigAndColorCliked2:(UIButton *)btn

{
    
    if([_target respondsToSelector:@selector(changeBigAndColorClikedBack:)])
    {
        [_target performSelector:@selector(changeBigAndColorClikedBack:) withObject:self];
    }
}


//变大变颜色
-(void)changeBigAndColorCliked:(UIButton *)btn
{
    if(_isSelect)
    {
        blueLine.hidden = NO;
        [self setTitleColor:[ToolList getColor:@"564786"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.userInteractionEnabled = NO;
    }
    else
    {
        self.userInteractionEnabled = YES;
        blueLine.hidden = YES;
        [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
}
//改变按钮状态
-(void)change:(NSString *)flag
{
    if([flag isEqualToString:@"up"])
    {
        [self setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_filter_up.png"] forState:UIControlStateNormal];
        self.isSelect = YES;
    }
    else
    {
        [self setTitleColor:[ToolList getColor:@"888888"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_filter_down.png"] forState:UIControlStateNormal];
        self.isSelect = NO;
        
    }
}
//带三角按钮点击
-(void)cliked:(FX_Button *)btn
{
    
    _isSelect = !_isSelect;
    if(_isSelect)
    {
        [self setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_filter_up.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self setTitleColor:[ToolList getColor:@"888888"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_filter_down.png"] forState:UIControlStateNormal];
    }
    if([_target respondsToSelector:@selector(btnBack:)])
    {
        [_target performSelector:@selector(btnBack:) withObject:self];
    }
}
- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type andTitle:(NSString *)title andTarget:(id)target andDic:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        _target = target;
        _isSelect = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor clearColor];
        
        //带三角按钮的
        if([type isEqualToString:@"0"])
        {
            
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitleColor:[ToolList getColor:@"888888"] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:@"icon_filter_down.png"] forState:UIControlStateNormal];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width-14, 0, 0)];
            [self addTarget:self action:@selector(cliked:) forControlEvents:UIControlEventTouchUpInside];
        }
        //变颜色加边框的
        else if ([type isEqualToString:@"1"])
        {
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            [self setTitle:[[dic allValues] lastObject] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dddddd"].CGColor;
            self.layer.cornerRadius = 4;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1;
            //self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(changeColorCliked:) forControlEvents:UIControlEventTouchUpInside];
        }
        //变大变颜色加底边
        else if ([type isEqualToString:@"2"])
        {
            blueLine = [ToolList getLineFromPoint:CGPointMake(0, frame.size.height-1.5) toPoint:CGPointMake(frame.size.width, frame.size.height-1.5) andWeight:1.5 andColorString:@"6052ba"];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            [self addTarget:self action:@selector(changeBigAndColorCliked1:) forControlEvents:UIControlEventTouchUpInside];
            [self.layer addSublayer:blueLine];
            blueLine.hidden = YES;
            
        }
        //变大变颜色
        else if ([type isEqualToString:@"4"])
        {
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            [self addTarget:self action:@selector(changeBigAndColorCliked2:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        //普通圆角按钮
        else if ([type isEqualToString:@"3"]){
            
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
            [self addTarget:self action:@selector(addType:) forControlEvents:UIControlEventTouchUpInside];
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 4.0;
            self.titleLabel.font = [UIFont systemFontOfSize:15];
            self.backgroundColor = [ToolList getColor:@"5647b6"];
            
        }
        //总监部门客户筛选加商务按钮，其他地方没有使用此方法
        else if ([type isEqualToString:@"5"])
        {
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            
            
            [self setTitle:[dic objectForKey:@"deptName"] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dddddd"].CGColor;
            self.layer.cornerRadius = 4;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1;
            //self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(changeColorCliked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //总监部门客户筛选加商务按钮，其他地方没有使用此方法
        else if ([type isEqualToString:@"6"])
        {
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            
            
            [self setTitle:[dic objectForKey:@"salerName"] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dddddd"].CGColor;
            self.layer.cornerRadius = 4;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1;
            //self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(changeColorCliked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //区总部门客户筛选加商务按钮，其他地方没有使用此方法
        else if ([type isEqualToString:@"7"])
        {
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            
            
            [self setTitle:[dic objectForKey:@"subName"] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dddddd"].CGColor;
            self.layer.cornerRadius = 4;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1;
            //self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(changeColorCliked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //筛选里面的选中按钮，选中后按钮后填充成紫色
        else if ([type isEqualToString:@"8"]){
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            
            [self setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dedede"].CGColor;
            [self setBackgroundColor:[UIColor whiteColor] ];
            self.titleLabel.font = [UIFont systemFontOfSize:14];
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(changeGrangeCliked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        //筛选里面的选中按钮，选中后按钮后面加一个紫色的✔️
        else if ([type isEqualToString:@"9"]){
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            
            [self setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"b3b3b3"] forState:UIControlStateNormal];
            
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(changeHidenCliked:) forControlEvents:UIControlEventTouchUpInside];
        }
        //变颜色加边框的
        else if ([type isEqualToString:@"10"])
        {
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            [self setTitle:[[dic allValues] lastObject] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dedede"].CGColor;
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 8;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1;
            //self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(hellohh:) forControlEvents:UIControlEventTouchUpInside];
        }
        //公海筛选
        else if ([type isEqualToString:@"11"])
        {
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            [self setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dedede"].CGColor;
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 8;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1;
            //self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(hellohh:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //变颜色加边框的
        else if ([type isEqualToString:@"12"])
        {
            
            _dic = @{@"data":dic,@"Obj":self,@"tag":title};
            [self setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            
            [self setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
            self.layer.borderColor = [ToolList getColor:@"dedede"].CGColor;
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 8;
            self.layer.masksToBounds = YES;
            self.layer.borderWidth = 1;
            //self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            // [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            [self addTarget:self action:@selector(hellohh:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return self;
}
//普通按钮点击事件
-(void)addType:(UIButton *)typeBt{
    
    if([_target respondsToSelector:@selector(addType:)])
    {
        [_target performSelector:@selector(addType:) withObject:self];
    }
}



-(void)changeGrangeCliked:(FX_Button *)btn{
    
    _isSelect = !_isSelect;
    if(_isSelect)
    {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[ToolList getColor:@"ba81ff"]];
        
    }
    else
    {
        [self setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
    }
    if([_target respondsToSelector:@selector(btnBackDic:)])
    {
        [_target performSelector:@selector(btnBackDic:) withObject:_dic];
    }
    
}

//筛选页面 点击后颜色变成紫色+紫色的✔️
-(void)changeHidenCliked:(FX_Button *)btn
{
    _isSelect = !_isSelect;
    if(_isSelect)
    {
        [self setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"trun.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self setTitleColor:[ToolList getColor:@"b3b3b3"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    if([_target respondsToSelector:@selector(btnBackDic:)])
    {
        [_target performSelector:@selector(btnBackDic:) withObject:_dic];
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
