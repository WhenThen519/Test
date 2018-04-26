//
//  textView.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/5.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "textView.h"


@implementation textView{
    
    CGFloat offset;
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    
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
- (IBAction)choseSex:(id)sender {
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView == _nameText) {
        
        [_yanBT setTitle:@"验证" forState:UIControlStateNormal];
        [_yanBT setBackgroundColor:[ToolList getColor:@"333399"]];
        _yanBT.titleLabel.font = [UIFont systemFontOfSize:15];
        _yanBT.titleLabel.textColor = [UIColor whiteColor];
        [_yanBT setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    CGRect frame = textView.frame;
    offset = frame.origin.y + frame.size.height + 5 - (self.frame.size.height - 315);     // 这里的5可以调整输入框和输入法间距
//    CGFloat offset =315- frame.origin.y - frame.size.height - 5;
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
    CGRect rect = textView.frame;
    rect.size.height = size.height;
    if (textView == _nameText) {
        
       _nameTextH.constant =size.height;
    }else{
        
        _addTextH.constant = size.height;
    }
   
    [textView setFrame:rect];

   
    if (textView == _lxrName) {
        
        if (result.length<=5) {
            
            return YES;
            
        }else{
            textView.text = [result substringToIndex:5];
            
            return YES;
            
        }
    }else
    
    {
        if (result.length<=50) {
            
            return YES;
            
        }else{
            
            textView.text = [result substringToIndex:50];
            
            return YES;
            
        }
    }
    
    return result.length <= 50;
}

- (IBAction)changeB:(id)sender {
    [self.superview endEditing:YES];

    UIButton *bt = (UIButton *)sender;
    
    switch (bt.tag-11) {
        case 0:
        {
            
            CY_chooseVc *v = [[CY_chooseVc alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.titleStr = @"选择性质";
//            v.dataArr = @[@"民营",@"国企"];
            v.delegate = self;
//            v.changeBlock = ^(NSString * str)
//            {
//                _comL.text = str;
//
//            };
            v.changeDicBlock = ^(NSDictionary * dic)
            {
                _comL.text = [dic objectForKey:@"name"];
                _comTypeId = [dic objectForKey:@"id"];
                
            };
            
            [self.delegate goVc:v];
        }
            break;
            
        case 1:
        {
            [self.delegate presentedVC:self];
            
        }
            break;
        case 2:
        {
            CY_chooseVc *v = [[CY_chooseVc alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.titleStr = @"选择行业";
            v.changeDicBlock = ^(NSDictionary * dic)
            {
                _hangL.text = [dic objectForKey:@"name"];
               _hangId = [dic objectForKey:@"id"];
                
            }; 
            v.delegate = self;
            [self.delegate goVc:v];
        }
            break;
        case 4:
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
        case 3:
        {
            CY_chooseVc *v = [[CY_chooseVc alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.titleStr = @"选择阶段";
            v.dataArr = @[@"收藏夹",@"保护跟进"];
            v.delegate = self;
            v.changeBlock = ^(NSString * str)
            {
                _duanL.text = str;
                
            };
            [self.delegate goVc:v];
        }
            break;
            
        default:
            break;
    }
}




-(IBAction)yanZ:(id)sender{
    
    if (_nameText.text.length==0) {
        
        return;
    }
    
    NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
    requestDic[@"custName"]= _nameText.text;
    
    [FX_UrlRequestManager postByUrlStr:checkCust_url andPramas:requestDic andDelegate:self andSuccess:@"checkCustSuccess:" andFaild:@"checkCustFild:" andIsNeedCookies:YES];
}

-(void)checkCustSuccess:(NSDictionary *)dic{
    
    [_nameText resignFirstResponder];
    
    int forward = [[dic objectForKey:@"forward"] intValue];
    
    switch (forward) {
        case 0:
        {
            //0：错误提示
            _adView.hidden = YES;
        }
            break;
            
        case 1:
        {
            //1：跳转到查询相似客户页面
            _adView.hidden = YES;
            CY_resembleVC *v = [[CY_resembleVC alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.textString = _nameText.text;
            v.intentCustString = self.textIntentCustId;
            [self.delegate goVc:v];
            
        }
            break;
            
        case 2:
        {
            //2：跳转到新增客户页面
            _adView.hidden = NO;
            [ _yanBT setImage:[UIImage imageNamed:@"btn_duoxuan_s.png"] forState:UIControlStateNormal];
            _yanBT.backgroundColor = [UIColor clearColor];
             [_yanBT setTitle:@"" forState:UIControlStateNormal];
            
            if (_isduanHiden) {
                _duanL.hidden = YES;
                _changebt.hidden = YES;
                _jieduanL.hidden = YES;
                _lineL.hidden = YES;
                _rightImage.hidden = YES;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma typeDelegate

-(void)chooseType:(NSString *)type andTitle:(NSString *)title{
    
    if ([type isEqualToString:@"选择性质"]) {
        _comL.text = title;
        
    }
    if ([type isEqualToString:@"选择阶段"]) {
        
        _duanL.text = title;
    }
    if ([type isEqualToString:@"选择行业"]) {
        
        _hangL.text = title;
    }

}

@end
