//
//  CY_addTextView.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/6.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_addTextView.h"
#import "CY_chooseVc.h"
#import "CY_resembleVC.h"

@implementation CY_addTextView{
    CGFloat offset;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView == _numText) {
       
        [_yanButton setTitle:@"验证" forState:UIControlStateNormal];
        [_yanButton setBackgroundColor:[ToolList getColor:@"333399"]];
        _yanButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _yanButton.titleLabel.textColor = [UIColor whiteColor];
         [_yanButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    if(textView == _nameTextt ){
        if([textView.text isEqualToString:@"最多5个字"]){
            textView.text=@"";
            textView.textColor=[UIColor blackColor];
        }
    }

    CGRect frame = textView.frame;
    offset = frame.origin.y + frame.size.height + 5 - (self.frame.size.height - 315);     // 这里的5可以调整输入框和输入法间距
   
    NSTimeInterval animationDuration = 0.30f;   // 这里的0.30f可以调整动画时间
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(offset > 0)
    {
        self.frame = CGRectMake(0.0f,self.frame.origin.y -offset, self.frame.size.width, self.frame.size.height);
    }
    [UIView commitAnimations];
   
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
    
    if (textView == _nameTextt) {
        
        _nameTextHH.constant =size.height;
        if (result.length<=5) {
            
            return YES;
            
        }else{
            
            textView.text = [result substringToIndex:5];
            
            return YES;
            
        }
    }
       else if(textView == _addTextt){
        
        _addTextHH.constant = size.height;
        
        if (result.length<=50) {
            
            return YES;
            
        }else{
            
            textView.text = [result substringToIndex:50];
            
            return YES;
            
        }
        
    }

    
       return result.length <= 50;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1 && textView == _nameTextt){
        textView.text = @"最多5个字";
        textView.textColor = [UIColor grayColor];
    }
    
    if(offset > 0){
        
        [self setFrame:CGRectMake(0, self.frame.origin.y+offset, self.frame.size.width, self.frame.size.height)];
    }
    offset = 0.0f;
    
    if(self.zuoji.text.length  !=0){
        
        if(!wiNSStringIsValidZJ(self.zuoji.text))
        {
            [ToolList showRequestFaileMessageLittleTime:@"座机有误，请输入区号座机号码"];
            return;
        }
    }
}



-(IBAction)yanZ:(id)sender{
    
    if (_numText.text.length==0) {
        
        return;
    }
    
    else if (![ToolList validateIdentityCard:_numText.text]) {
        
        [ToolList showRequestFaileMessageLittleTime:@"身份证号码有误，请重新输入"];
        
        return;
    }
    
    NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
    requestDic[@"certificateNo"]= _numText.text;//需要校验的身份证号码
    requestDic[@"certificateType"]= @"1";//校验的号码类型：固定为1
    [FX_UrlRequestManager postByUrlStr:checkCertificateNo_url andPramas:requestDic andDelegate:self andSuccess:@"checkCertificateNoSuccess:" andFaild:@"checkCertificateNoFild:" andIsNeedCookies:YES];
}

-(void)checkCertificateNoSuccess:(NSDictionary *)sucDic{
    
    
    [_numText resignFirstResponder];
    
    int forward = [[sucDic objectForKey:@"forward"] intValue];
    
    switch (forward) {
        case 0:
        {
            //0：错误提示
            _daView.hidden = YES;
        }
            break;
            
        case 1:
        {
            //1：跳转到查询相似客户页面
            _daView.hidden = YES;
            CY_resembleVC *v = [[CY_resembleVC alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.isRen = YES;
            v.textString = _numText.text;
            [self.delegate goVc:v];
            
        }
            break;
            
        case 2:
        {
            //2：跳转到新增客户页面
            _daView.hidden = NO;
            [ _yanButton setImage:[UIImage imageNamed:@"btn_duoxuan_s.png"] forState:UIControlStateNormal];
            [_yanButton setTitle:@"" forState:UIControlStateNormal];
            _yanButton.backgroundColor = [UIColor clearColor];
            
        }
            break;
            
        default:
            break;
    }

}

- (IBAction)chooseType:(id)sender {
    [self.superview endEditing:YES];
    UIButton *chooseBt = (UIButton *)sender;
    
    switch (chooseBt.tag-144) {
            
        case 1:
        {
            [self.delegate presentedVC:self];
        }
            break;
            
        case 0:
        {
            CY_chooseVc *v = [[CY_chooseVc alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.titleStr = @"选择阶段";
            v.changeBlock = ^(NSString * str)
            {
                _duanLL.text = str;
                
            };
            v.dataArr = @[@"收藏夹",@"保护跟进"];
            v.delegate = self;
           
            [self.delegate goVc:v];
        }
            break;
        case 2:
        {
            CY_chooseVc *v = [[CY_chooseVc alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.titleStr = @"选择性别";
            v.dataArr = @[@"男",@"女"];
            v.delegate = self;
            v.changeBlock = ^(NSString * str)
            {
                _sex.text = str;
                
            };
            
            [self.delegate goVc:v];
        }
            break;
        default:
            break;
    }
}

#pragma HZAreaPickerDelegate
- (void)changeNativePlace:(NSString *)string{
    
    _adLable.text = string;
    UIButton *bt=(UIButton *)[_adLable viewWithTag:12];
    bt.userInteractionEnabled = YES;
}


- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
    
    
}

#pragma typeDelegate

-(void)chooseType:(NSString *)type andTitle:(NSString *)title{

    if ([type isEqualToString:@"选择阶段"]) {
        
        _duanLL.text = title;
    }

    
}

@end
