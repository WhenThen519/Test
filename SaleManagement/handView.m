//
//  handView.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/21.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "handView.h"

#define kHeadTitleTag 54534
#define IOS7_HeightPlus (IOS7?20:0)

#define kHeadViewFrame CGRectMake(0, 0, __MainScreen_Width, IOS7_Height)

@implementation handView

- (id)initWithTitle:(NSString *)title
     andTitleColor:(UIColor *)titleColor
         andBGColor:(UIColor *)bgColor
       andLeftImage:(NSString *)leftImage
      andRightImage:(NSString *)rightImage
       andLeftTitle:(NSString *)lefttitle
      andRightTitle:(NSString *)righttitle
          andTarget:(id)obj{
    
    if(self=[super initWithFrame:kHeadViewFrame])
    {
  
//        self.frame = kHeadViewFrame;
        self.VC=obj;
        // 中心的 title
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60,  iphone_stateBar, __MainScreen_Width-120, 44)];
        _titleLabel.tag = kHeadTitleTag;
        _titleLabel.text=title;
        _titleLabel.font=[UIFont systemFontOfSize:19];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.textColor=titleColor;
        _titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:_titleLabel];
        
        //left button
        
        UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame=CGRectMake(0, 2+iphone_stateBar, 40, 40);
        leftButton.backgroundColor=[UIColor clearColor];
        if (leftImage)
        {
            UIImage *left = [UIImage imageNamed:leftImage];
            [leftButton setImageEdgeInsets:UIEdgeInsetsMake(40/2-left.size.height/2, 40/2-left.size.width/2, 40/2-left.size.height/2, 40/2-left.size.width/2)];
            [leftButton setImage:left forState:UIControlStateNormal];
        }
       
        [leftButton setTitle:lefttitle forState:UIControlStateNormal];
        if (leftImage != nil || lefttitle !=nil)
        {
            [leftButton addTarget:self action:@selector(LeftAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:leftButton];
        
        
        //right button
        
        UIButton *right_Button=[UIButton buttonWithType:UIButtonTypeCustom];
        right_Button.backgroundColor=[UIColor clearColor];
        
        right_Button.frame=CGRectMake(__MainScreen_Width-40, 2+iphone_stateBar, 40, 40);
        
        if (rightImage)
        {
            UIImage *right = [UIImage imageNamed:rightImage];
            [right_Button setImageEdgeInsets:UIEdgeInsetsMake(40/2-right.size.height/2, 40/2-right.size.width/2, 40/2-right.size.height/2, 40/2-right.size.width/2)];
            [right_Button setImage:right forState:UIControlStateNormal];
        }
        
        right_Button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [right_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [right_Button setTitle:righttitle forState:UIControlStateNormal];
        if (rightImage != nil || righttitle !=nil)
        {
            [right_Button addTarget:self action:@selector(RightAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        right_Button.tag = 6547;
        [self addSubview:right_Button];
    }
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
    
    return self;
}

/*!
 左按钮执行的方法
 @param sender 导航条的左按钮
 
 */
-(void)LeftAction:(UIButton *)sender{
    
    
    [_VC performSelector:@selector(LeftAction:) withObject:sender];
}
/*!
 右按钮执行的方法
 @param sender 导航条的右按钮
 */

-(void)RightAction:(UIButton *)sender
{
    [_VC performSelector:@selector(RightAction:) withObject:sender];
}



- (id)initWithTitle:(NSString *)title
      andRightImage:(NSString *)rightImage
       andLeftTitle:(NSString *)lefttitle
      andRightTitle:(NSString *)righttitle
          andTarget:(id)obj{
    
    {
        if(self=[super initWithFrame:kHeadViewFrame])
        //        self.frame = kHeadViewFrame;
        self.VC=obj;
        // 中心的 title
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, iphone_stateBar, __MainScreen_Width-120, 44)];
        _titleLabel.tag = kHeadTitleTag;
        _titleLabel.text=title;
        _titleLabel.font=[UIFont systemFontOfSize:19];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.textColor=[ToolList getColor:@"333333"];
        _titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:_titleLabel];
        
        //left button
        
        UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame=CGRectMake(0, 2+iphone_stateBar, 40, 40);
        leftButton.backgroundColor=[UIColor clearColor];
        if (lefttitle.length ==0)
        {
            UIImage *left = [UIImage imageNamed:@"btn_back.png"];
            [leftButton setImageEdgeInsets:UIEdgeInsetsMake(40/2-left.size.height/2, 40/2-left.size.width/2, 40/2-left.size.height/2, 40/2-left.size.width/2)];
            [leftButton setImage:left forState:UIControlStateNormal];
        }else{
        
            [leftButton setTitle:lefttitle forState:UIControlStateNormal];
            leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
            [leftButton setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
        }
       
        [leftButton addTarget:self action:@selector(LeftAction:) forControlEvents:UIControlEventTouchUpInside];
       
        [self addSubview:leftButton];
        
        
        //right button
        
        UIButton *right_Button=[UIButton buttonWithType:UIButtonTypeCustom];
        right_Button.backgroundColor=[UIColor clearColor];
        
        right_Button.frame=CGRectMake(__MainScreen_Width-40, 2+iphone_stateBar, 40, 40);
        
        if (rightImage)
        {
            UIImage *right = [UIImage imageNamed:rightImage];
            [right_Button setImageEdgeInsets:UIEdgeInsetsMake(40/2-right.size.height/2, 40/2-right.size.width/2, 40/2-right.size.height/2, 40/2-right.size.width/2)];
            [right_Button setImage:right forState:UIControlStateNormal];
        }
        
        right_Button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [right_Button setTitleColor:[ToolList getColor:@"5647b6"] forState:UIControlStateNormal];
        [right_Button setTitle:righttitle forState:UIControlStateNormal];
        if (rightImage != nil || righttitle !=nil)
        {
            [right_Button addTarget:self action:@selector(RightAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        right_Button.tag = 6547;
        [self addSubview:right_Button];
    }
    
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    [self.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0,IOS7_Height-0.1) toPoint:CGPointMake(__MainScreen_Width, IOS7_Height-0.1) andWeight:0.1 andColorString:@"999999"]];
    
    
    
    return self;
}

- (id)initWithFram:(CGRect)farm SearchandTarget:(id)obj {
    
    if(self=[super initWithFrame:farm])
        //CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, IOS7_Height)
    self.VC=obj;
    
    //搜索框
   UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(13, iphone_stateBar + 7, __MainScreen_Width-56, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    text.tag = 1199;
    text.leftView = imgView;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.backgroundColor = [ToolList getColor:@"dedee0"];
    text.placeholder = @"请输入搜索内容";
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [ToolList getColor:@"333333"];
    text.layer.cornerRadius = 8;
    text.layer.masksToBounds = YES;
    text.clearButtonMode = UITextFieldViewModeAlways;
    text.delegate = self.VC;
    text.returnKeyType = UIReturnKeySearch;
    [self addSubview:text];
    
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(RightHome:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:cancelSearchBtn];
    [self.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
    
    return self;
}

-(void)RightHome:(UIButton *)sender{
    
    [_VC performSelector:@selector(RightHome:) withObject:sender];
}

@end
