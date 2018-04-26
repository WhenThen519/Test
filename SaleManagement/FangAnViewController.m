//
//  FangAnViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 16/4/1.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "FangAnViewController.h"

#define BGHEIGHT 433
@interface FangAnViewController (){
    
    NSArray *typeArr;
    NSArray *timeArr;
    NSMutableArray *selectButtonArr;//选中按钮
    NSMutableArray *selcetTypeArr;
    NSString *selcetTime;
    BOOL istextView;
}

@property (nonatomic,strong)IBOutlet UIView *comView;

@property (nonatomic,strong)IBOutlet UIView *timeView;
@property (nonatomic,strong)IBOutlet UILabel *com_Label;
@property (nonatomic,strong)IBOutlet UILabel *time_Label;
@property (nonatomic,strong)IBOutlet UIView *bgView;

@property (nonatomic,strong)IBOutlet UITextField *yuan_text;//报价金额
@property (nonatomic,strong)IBOutlet UITextView *content_text;//输入内容，不是必填项

@end

@implementation FangAnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    istextView  = NO;
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _bgV_top.constant = IOS7_Height;
    
    selectButtonArr = [[NSMutableArray alloc]init];
    selcetTypeArr =[[NSMutableArray alloc]init];
    
    typeArr = @[@{@"1":@"网站"},@{@"2":@"资源"},@{@"3":@"邮局"},@{@"4":@"电商"},@{@"5":@"推广"}];
    
     [self addNavgationbar:_titleStr leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"next"];
    
    [self makeView];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_content_text resignFirstResponder];
     [_yuan_text resignFirstResponder];
}

-(void)makeView{
    
    if ([_titleStr isEqualToString:@"方案报价"]) {
        
        timeArr = @[@{@"6":@"本周"},@{@"7":@"本月"},@{@"8":@"下月"}];
        
        _com_Label.text = @"产品";
        _time_Label.text = @"时间";
        
    }else{
        timeArr = @[@{@"6":@"首购"},@{@"7":@"续签"},@{@"8":@"其它"}];
        _com_Label.text = @"签单产品";
        _time_Label.text = @"签单类型";
    }
    
    for (int i=0; i<typeArr.count; i++) {
        
        float btn_W =( __MainScreen_Width-60)/5.0;
        
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(10+(btn_W + 10)*i, 15, btn_W, 40) andType:@"1" andTitle:@"typefangan" andTarget:self andDic:[typeArr objectAtIndex:i]];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        if(i == 0)
        {
            [btn changeType1Btn:YES];
            [selcetTypeArr addObject:@"网站"];
        }
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [_comView addSubview:btn];
    }
    
    for (int i=0; i<timeArr.count; i++) {
        
        float btn_W =( __MainScreen_Width-40)/3.0;
        
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(10+(btn_W + 10)*i, 15, btn_W, 40) andType:@"1" andTitle:@"timettt" andTarget:self andDic:[timeArr objectAtIndex:i]];
       
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        if(i == 0)
        {
            [btn changeType1Btn:YES];
            
           if ([_titleStr isEqualToString:@"方案报价"]) {
               
               selcetTime = @"本周";
               
           }else{
               selcetTime =@"首购";
           }
            
        }
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [selectButtonArr addObject:btn];
        
        [_timeView addSubview:btn];
    }
    
}

#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    //产品
    if([str isEqualToString:@"typefangan"])
    {
        if(btn.isSelect)
        {
 
            [selcetTypeArr addObject:[[dic1 allValues] lastObject]];
           
        }
        else
        {
           [selcetTypeArr removeObject:[[dic1 allValues] lastObject]];
            
        }
        
    }
    
    else
    {
        if(btn.isSelect)
        {

            for (FX_Button *btnS in selectButtonArr)
            {
               
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                     selcetTime = @"";
                    

                }else{
                 
                    selcetTime = [[dic1 allValues] lastObject];

                }
            }
        }
        else
        {
             [btn changeType1Btn:NO];
             selcetTime = @"";
        }
    }

}

-(void)next{
    
    NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
    if ([_titleStr isEqualToString:@"方案报价"]) {
      
        if (_yuan_text.text.length == 0)
        {
            [ToolList showRequestFaileMessageLittleTime:@"请输入金额！"];
            return;
        }
        
        else if (![ToolList validateNumber:_yuan_text.text]){
            
            [ToolList showRequestFaileMessageLittleTime:@"金额请输入整数或保留1位小数！"];
            return;
        }
        
       else if (selcetTypeArr.count==0) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请选择产品类型！"];
           return;
       } else if (selcetTime.length==0) {
           
           [ToolList showRequestFaileMessageLittleTime:@"请选择时间！"];
           return;
       }
        
        arr[@"visitType"] =@"5";
    }
    else{
        if (_yuan_text.text.length == 0)
        {
            [ToolList showRequestFaileMessageLittleTime:@"请输入金额！"];
            return;
        }
        else if (![ToolList validateNumber:_yuan_text.text]){
            
            [ToolList showRequestFaileMessageLittleTime:@"金额请输入整数或保留1位小数！"];
            return;
        }
        else if (selcetTypeArr.count==0) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请选择产品类型！"];
            return;
        } else if (selcetTime.length==0) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请选择签单类型！"];
            return;
        }
        
        
        arr[@"visitType"] =@"6";
    }
    
    arr[@"custId"] = _costIdStr;//客户ID
    arr[@"intentType"] = _titleStr;//客户将要变更的客户状态
    arr[@"custName"] = _custNameStr;//客户名称
    arr[@"content"] =_content_text.text;//内容
    arr[@"mobileTag"] =selcetTime;//签单类型、或者预计成单时间
    arr[@"planMoney"] = _yuan_text.text;//签单金额或报价金额
    arr[@"productTag"] =selcetTypeArr;//产品类型
    
  
    [FX_UrlRequestManager postByUrlStr:changeCustState_url andPramas:arr andDelegate:self andSuccess:@"changeCustStateSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)changeCustStateSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
          [self.delegate goVcAndType:_titleStr];
         [self.navigationController popViewControllerAnimated:NO];
       
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    
    if (result.length<=200) {
        
        return YES;
        
    }else{
        
        textView.text = [result substringToIndex:200];
        
        return NO;
        
    }
    
    return result.length <= 200;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == _content_text ) {
        istextView = YES;

    }
    return YES;
}

#pragma mark -- 键盘监听
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y ;  // 得到键盘弹出后的y坐标

    if (istextView) {
        
       _bgV_top.constant =keyBoardEndY-(BGHEIGHT+3);
    }
    
    
}
- (void)keyboardWillHide:(NSNotification *)notification{ 
    _bgV_top.constant  =IOS7_Height;
    istextView = NO;
}

@end
