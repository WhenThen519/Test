//
//  CY_popupV.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/22.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_popupV.h"

@implementation CY_popupV

- (id)initWithFrame:(CGRect)frame andMessage:(NSString *)message
{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    
    if (self) {

        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]]; //设置视图背景颜色

        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5;
        messageView.layer.masksToBounds = YES;
        //    messageView.tag = 9991;
        messageView.center = self.center;
        [self addSubview:messageView];
        
        UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 59, 10, 13)];
        addImage.image = [UIImage imageNamed:@"icon_gtjl_dingwei_see.png"];
        addImage.backgroundColor = [UIColor clearColor];
        [messageView addSubview:addImage];
        
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize size = CGSizeMake(__MainScreen_Width-60,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [message boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        UILabel *messageLable = [[UILabel alloc] initWithFrame:CGRectMake(20+10+10, 55, __MainScreen_Width-60, labelsize.height+5)];
        messageLable.text = message;
        messageLable.textColor = [ToolList getColor:@"333333"];
        messageLable.font = [UIFont boldSystemFontOfSize:15];
        messageLable.numberOfLines = 0;
        messageLable.backgroundColor = [UIColor clearColor];
        [messageView addSubview:messageLable];
        messageView.frame = CGRectMake(15,( __MainScreen_Height-messageLable.frame.size.height-110)/2, __MainScreen_Width-30, messageLable.frame.size.height+110);
        
        UIButton *deleB = [UIButton buttonWithType:UIButtonTypeCustom];
        deleB.frame = CGRectMake(messageView.frame.size.width-55, 3, 55, 55);
        [deleB setImage:[UIImage imageNamed:@"btn_close_popup.png"] forState:UIControlStateNormal];
        [deleB addTarget:self action:@selector(closeClickButton:) forControlEvents:UIControlEventTouchUpInside];
        deleB.backgroundColor = [UIColor clearColor];
        [messageView addSubview:deleB];

    }
    return self;
}

- (id)initWithMessage:(NSDictionary *)message andName:(NSString *)nameStr{
    
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]]; //设置视图背景颜色
        
        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5;
        messageView.layer.masksToBounds = YES;
        messageView.center = self.center;
        [self addSubview:messageView];
        
        UILabel *messageLable = [[UILabel alloc] init];
        messageLable.text = [message objectForKey:@"contractCode"];
        messageLable.frame = CGRectMake(20, 40, __MainScreen_Width-70,25);
        messageLable.textColor = [ToolList getColor:@"333333"];
        messageLable.font = [UIFont systemFontOfSize:25];
        messageLable.numberOfLines = 0;
        messageLable.backgroundColor = [UIColor clearColor];
        [messageView addSubview:messageLable];
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(20, messageLable.frame.size.height+messageLable.frame.origin.y+15, 68, 14)];
        titleL.text = @"客户名称:";
        titleL.font = [UIFont systemFontOfSize:14];
        titleL.textColor = [ToolList getColor:@"666666"];
        [messageView addSubview:titleL];
        
        UILabel *nameL = [[UILabel alloc]init];
        nameL.text = nameStr;
        UIFont *font = [UIFont systemFontOfSize:14];
        nameL.numberOfLines = 0;
        CGSize size = CGSizeMake(__MainScreen_Width-70-68,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [nameL.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

        nameL.frame = CGRectMake(titleL.frame.size.width+titleL.frame.origin.x+2, titleL.frame.origin.y-2, __MainScreen_Width-70-68, labelsize.height);
        
        nameL.font = [UIFont systemFontOfSize:14];
        nameL.textColor = [ToolList getColor:@"666666"];
        [messageView addSubview:nameL];
        
        for (int i=0; i<5; i++) {
            
            UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectMake(20, i*14+nameL.frame.origin.y+nameL.frame.size.height+(i+1)*10, __MainScreen_Width-70-68, 14)];
            switch (i) {
                case 0:
                    contentL.text = [NSString stringWithFormat:@"文本序号：%@",[message objectForKey:@"textCode"]];
                    break;
                case 1:
                   contentL.text = [NSString stringWithFormat:@"签单日期：%@",[message objectForKey:@"signingTime"]];
                    break;
                case 2:
                    contentL.text = [NSString stringWithFormat:@"录入日期：%@",[message objectForKey:@"createDate"]];
                    break;
                case 3:
                    contentL.text = [NSString stringWithFormat:@"签单金额：￥%@",[message objectForKey:@"contractAmount"]];
                    break;
                case 4:
                    contentL.text = [NSString stringWithFormat:@"   分单人：%@",[message objectForKey:@"salerName"]];
                    break;
                    
                default:
                    break;
            }
           
            contentL.numberOfLines = 1;
            contentL.font = [UIFont systemFontOfSize:14];
            contentL.textColor = [ToolList getColor:@"666666"];
            [messageView addSubview:contentL];
        }
       
        
        messageView.frame = CGRectMake(15, (__MainScreen_Height-240-labelsize.height)/2, __MainScreen_Width-30, 240+labelsize.height);
        
        UIButton *deleB = [UIButton buttonWithType:UIButtonTypeCustom];
        deleB.frame = CGRectMake(messageView.frame.size.width-55, 3, 55, 55);
        [deleB setImage:[UIImage imageNamed:@"btn_close_popup.png"] forState:UIControlStateNormal];
        [deleB addTarget:self action:@selector(closeClickButton:) forControlEvents:UIControlEventTouchUpInside];
        deleB.backgroundColor = [UIColor clearColor];
        [messageView addSubview:deleB];
    }
    
    return self;
}

-(void)closeClickButton:(id)sender{
    [self removeFromSuperview];

}

- (id)initWithFrame:(CGRect)frame andMessageArr:(NSArray *)messageArr andtarget:(id)target{
   
     self = [super init];
    
    if (self) {
        
        self.frame = frame;
        self.backgroundColor = [ToolList getColor:@"e7e7eb"];
        
        for (int i=0; i<messageArr.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, i*49, __MainScreen_Width, 49);
            button.backgroundColor =[UIColor whiteColor];
            [button setTitle:[NSString stringWithFormat:@"%@",[messageArr objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[ToolList getColor:@"333333"] forState:UIControlStateNormal];
            button.tag = i+17;
            [button addTarget:target action:@selector(telMoreList:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:button];
            
            //线
            [button.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 48.5) toPoint:CGPointMake(__MainScreen_Width, 48.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        }
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, messageArr.count*49+5, __MainScreen_Width, 49);
        cancel.backgroundColor =[UIColor whiteColor];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancel addTarget:target action:@selector(cancelBt:) forControlEvents:UIControlEventTouchUpInside];
        [cancel setTitleColor:[ToolList getColor:@"333333"] forState:UIControlStateNormal];
        [self addSubview:cancel];
        
    }
    
    return self;
}

-(void)telMoreList:(UIButton *)bt{
    
    
}

//添加客户完成后是否返回意向客户弹窗
- (id)initWithFrame:(CGRect)frame andyixiangTitle:(NSString *)title andtarget:(id)target{
    
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]]; //设置视图背景颜色
        
        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5;
        messageView.layer.masksToBounds = YES;
        messageView.center = self.center;
        [self addSubview:messageView];
        
        messageView.frame = CGRectMake(15, (__MainScreen_Height-189)/2, __MainScreen_Width-30, 189);
        
        UIButton *sucBt = [UIButton buttonWithType:UIButtonTypeCustom];
        sucBt.frame = CGRectMake(15, 0, __MainScreen_Width-60, 125);
        [sucBt setTitle:@"保护成功！" forState:UIControlStateNormal];
        sucBt.titleLabel.font = [UIFont systemFontOfSize:19];
        
        [sucBt setTitleColor:[ToolList getColor:@"59b34d"] forState:UIControlStateNormal];
        [sucBt setImage:[UIImage imageNamed:@"icon_yxkh_bhcg.png"] forState:UIControlStateNormal];
        [messageView addSubview:sucBt];
        
        UIButton *deleB = [UIButton buttonWithType:UIButtonTypeCustom];
        deleB.frame = CGRectMake(20, 125, (__MainScreen_Width-80)/2, 44);
        [deleB setTitle:@"返回意向客户" forState:UIControlStateNormal];
        deleB.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleB setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
        [deleB addTarget:target action:@selector(closeClickButton) forControlEvents:UIControlEventTouchUpInside];
        deleB.layer.cornerRadius = 4;
        deleB.layer.masksToBounds = YES;
        deleB.layer.borderWidth = 0.5;
        deleB.layer.borderColor = [ToolList getColor:@"d9d9de"].CGColor;
        deleB.backgroundColor = [ToolList getColor:@"f6f5fa"];
        [messageView addSubview:deleB];
        
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(30+(__MainScreen_Width-80)/2, 125, (__MainScreen_Width-80)/2, 44);
        [myButton setTitle:@"查看我的客户" forState:UIControlStateNormal];
        myButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [myButton setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
        [myButton addTarget:target action:@selector(goMyButton) forControlEvents:UIControlEventTouchUpInside];
        myButton.layer.borderWidth = 0.5;
        myButton.layer.borderColor = [ToolList getColor:@"d9d9de"].CGColor;
        myButton.layer.cornerRadius = 4;
        myButton.layer.masksToBounds = YES;
        myButton.backgroundColor = [ToolList getColor:@"f6f5fa"];
        [messageView addSubview:myButton];
    }
    
    return self;

    
}


//商务-我的客户再联系弹窗
- (id)initWithFrame:(CGRect)frame andMytextArr:(NSArray *)titleArr andtarget:(id)target andTag:(NSInteger)buTag{
    
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]]; //设置视图背景颜色
        
        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5;
        messageView.layer.masksToBounds = YES;
        messageView.center = self.center;
        [self addSubview:messageView];
     
        for (int i=0; i<titleArr.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 45+i*49, __MainScreen_Width, 49);
            button.backgroundColor =[UIColor whiteColor];
            [button setTitle:[NSString stringWithFormat:@"%@",[titleArr objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[ToolList getColor:@"333333"] forState:UIControlStateNormal];
            button.tag = buTag;
            [button addTarget:target action:NSSelectorFromString(@"changeType:") forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [messageView addSubview:button];
            
            //线
            [button.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 48.5) toPoint:CGPointMake(__MainScreen_Width, 48.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        }
        
        messageView.frame = CGRectMake(15, (__MainScreen_Height-45-49*titleArr.count)/2, __MainScreen_Width-30, 45+49*titleArr.count);
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,messageView.frame.size.width, 45)];
        titleL.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
        titleL.text = @"标签";
        titleL.textColor = [UIColor blackColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        [messageView addSubview:titleL];
        
        UIButton *deleB = [UIButton buttonWithType:UIButtonTypeCustom];
        deleB.frame = CGRectMake(messageView.frame.size.width-45, 0, 45, 45);
        [deleB setImage:[UIImage imageNamed:@"btn_close_popup.png"] forState:UIControlStateNormal];
        [deleB addTarget:target action:NSSelectorFromString(@"closeClickButton1")forControlEvents:UIControlEventTouchUpInside];
        deleB.backgroundColor = [UIColor clearColor];
        [messageView addSubview:deleB];
    }
    
    return self;
}

//message为弹框页面显示内容，title为按钮上面显示的内容
-(id)initWithFrame:(CGRect)frame andMessage:(NSString *)message andBtTitel:(NSString *)title andtarget:(id)target andTag:(NSInteger)label_tag{
    
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    
    UITapGestureRecognizer* singleRecognizer;

    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:singleRecognizer];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]]; //设置视图背景颜色
        
        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5;
        messageView.layer.masksToBounds = YES;
        //    messageView.tag = 9991;
        messageView.center = self.center;
        [self addSubview:messageView];
        
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize size = CGSizeMake(__MainScreen_Width-50,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [message boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        UILabel *messageLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, __MainScreen_Width-50, labelsize.height+5)];
        messageLable.text = message;
        messageLable.textColor = [ToolList getColor:@"4a4a4a"];
        messageLable.textAlignment = NSTextAlignmentCenter;
        messageLable.font = [UIFont systemFontOfSize:15];
        messageLable.numberOfLines = 0;
        messageLable.backgroundColor = [UIColor clearColor];
        [messageView addSubview:messageLable];
        
        messageView.frame = CGRectMake(15,( __MainScreen_Height-messageLable.frame.size.height-110)/2, __MainScreen_Width-30, messageLable.frame.size.height+110);
        
        UIButton *deleB = [UIButton buttonWithType:UIButtonTypeCustom];
        deleB.frame = CGRectMake((messageView.frame.size.width-116)/2, messageView.frame.size.height-65, 116, 40);
        [deleB setTitle:title forState:UIControlStateNormal];
        [deleB setBackgroundColor:[ToolList getColor:@"cf2bf0"]];
        deleB.titleLabel.font = [UIFont systemFontOfSize:16];
         [deleB addTarget:target action:NSSelectorFromString(@"goAddView:")forControlEvents:UIControlEventTouchUpInside];
        deleB.layer.cornerRadius = 5;
        deleB.tag = label_tag;
        deleB.layer.masksToBounds = YES;
        [messageView addSubview:deleB];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andMyNameArr:(NSArray *)titleArr andtarget:(id)target andTag:(NSInteger)buTag{
    
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
      self.tag = 1090;
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]]; //设置视图背景颜色
        
        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [ToolList getColor:@"FDFDFD"];
        messageView.layer.cornerRadius = 10;
        
        messageView.layer.masksToBounds = YES;
        messageView.center = self.center;
        [self addSubview:messageView];
        
        for (int i=0; i<titleArr.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 93+i*49, __MainScreen_Width, 49);
            button.backgroundColor =[UIColor clearColor];
            [button setTitle:[NSString stringWithFormat:@"%@",[[titleArr objectAtIndex:i]objectForKey:@"custName"]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[ToolList getColor:@"4a4a4a"] forState:UIControlStateNormal];
            button.tag = i+100;
            
//            button.titleLabel.textAlignment = NSTextAlignmentRight;
            [button addTarget:target action:NSSelectorFromString(@"changeType:") forControlEvents:UIControlEventTouchUpInside];
//            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [messageView addSubview:button];
            
            //线
            [button.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 48.5) toPoint:CGPointMake(__MainScreen_Width, 48.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        }
        
        messageView.frame = CGRectMake(15, (__MainScreen_Height-90-49*titleArr.count)/2, __MainScreen_Width-30, 93+49*titleArr.count+90);
        
        UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,messageView.frame.size.width, 93)];
        titleL.numberOfLines = 0;
        titleL.backgroundColor = [UIColor clearColor];
        titleL.font = [UIFont systemFontOfSize:12];
        titleL.textColor = [ToolList getColor:@"9b9b9b"];
        titleL.textAlignment = NSTextAlignmentCenter;
        [messageView addSubview:titleL];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"请您选择要保存的公司\n(可多选)"];
        UIFont *baseFont = [UIFont systemFontOfSize:16];
        [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, 10)];
        // 设置颜色
        UIColor *color = [ToolList getColor:@"4a4a4a"];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:NSMakeRange(0, 10)];
        titleL.attributedText = attrString;
        
        //线
        [titleL.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, titleL.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, titleL.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        
        UIButton *deleB = [UIButton buttonWithType:UIButtonTypeCustom];
        deleB.frame = CGRectMake((messageView.frame.size.width-84)/2, 93+49*titleArr.count+25, 84, 40);
      
        [deleB setBackgroundColor:[ToolList getColor:@"cf2bf0"]];
        [deleB setTitle:@"保存" forState:UIControlStateNormal];
       
        [deleB addTarget:target action:NSSelectorFromString(@"closeClickButton1:")forControlEvents:UIControlEventTouchUpInside];
        [messageView addSubview:deleB];
    }
    
    return self;

}

-(id)initWithMessage:(NSString *)message andBtTitel_one:(NSString *)title_one andBtTitel_two:(NSString *)title_two andtarget:(id)target andTag:(NSInteger)label_tag{
    
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    UITapGestureRecognizer* singleRecognizer;
    
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    self.userInteractionEnabled=YES;
    [self addGestureRecognizer:singleRecognizer];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]]; //设置视图背景颜色
        
        UIView *messageView = [[UIView alloc] init];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5;
        messageView.layer.masksToBounds = YES;
        //    messageView.tag = 9991;
        messageView.center = self.center;
        [self addSubview:messageView];
        
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize size = CGSizeMake(__MainScreen_Width-50,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [message boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        UILabel *messageLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, __MainScreen_Width-50, labelsize.height+5)];
        messageLable.text = message;
        messageLable.textColor = [ToolList getColor:@"4a4a4a"];
        messageLable.textAlignment = NSTextAlignmentCenter;
        messageLable.font = [UIFont systemFontOfSize:15];
        messageLable.numberOfLines = 0;
        messageLable.backgroundColor = [UIColor clearColor];
        [messageView addSubview:messageLable];
        
        messageView.frame = CGRectMake(15,( __MainScreen_Height-messageLable.frame.size.height-110)/2, __MainScreen_Width-30, messageLable.frame.size.height+110);
        
        UIButton *deleB = [UIButton buttonWithType:UIButtonTypeCustom];
        deleB.frame = CGRectMake((messageView.frame.size.width-140)/3, messageView.frame.size.height-65, 70, 40);
        [deleB setTitle:title_one forState:UIControlStateNormal];
        [deleB setBackgroundColor:[ToolList getColor:@"cf2bf0"]];
        deleB.titleLabel.font = [UIFont systemFontOfSize:16];
        [deleB addTarget:target action:NSSelectorFromString(@"goAddView:")forControlEvents:UIControlEventTouchUpInside];
        deleB.layer.cornerRadius = 5;
        deleB.tag = label_tag;
        deleB.layer.masksToBounds = YES;
        [messageView addSubview:deleB];
        
        UIButton *deleA = [UIButton buttonWithType:UIButtonTypeCustom];
        deleA.frame = CGRectMake((messageView.frame.size.width-140)/3*2+70, messageView.frame.size.height-65, 70, 40);
        [deleA setTitle:title_two forState:UIControlStateNormal];
        [deleA setBackgroundColor:[ToolList getColor:@"cf2bf0"]];
        deleA.titleLabel.font = [UIFont systemFontOfSize:16];
        [deleA addTarget:target action:NSSelectorFromString(@"goAddView2:")forControlEvents:UIControlEventTouchUpInside];
        deleA.layer.cornerRadius = 5;
        deleA.tag = label_tag;
        deleA.layer.masksToBounds = YES;
        [messageView addSubview:deleA];
        
    }
    return self;
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer {
    
    [self removeFromSuperview];
   
}

@end
