//
//  CY_addMenVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/27.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_addMenVC.h"
#import "CY_chooseVc.h"
#import "SearchViewController.h"

@interface CY_addMenVC (){
    
    NSString *typeId;
    BOOL isBMtext;//当输入部门选项时，防止键盘遮挡。
}

@end

@implementation CY_addMenVC


-(void)rightBtnAction{
    
    if (_nameText==nil||_nameText.text.length==0) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入联系人名称"];
        return;
    }
    
    else if (_telText.text.length==0 && _phoneText.text.length==0){
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入正确的手机号码或座机"];
        
        return;
    }
    
       else if (!wiNSStringIsValidPhone(_telText.text)) {
            
            [ToolList showRequestFaileMessageLittleTime:@"手机有误，请重新输入"];
            return;
        }

       else if(_emailText.text.length==0){
        [ToolList showRequestFaileMessageLittleTime:@"请输入邮箱"];
        return;
       }

    else if (!wiNSStringIsValidEmail(YES, _emailText.text)) {
        
        [ToolList showRequestFaileMessageLittleTime:@"邮箱有误，请重新输入"];
        return;
    }
    else if (_saxL==nil||_saxL.text.length==0) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请选择联系人性别"];
        return;
    }
   else if (_comL==nil||_comL.text.length==0) {
       
       [ToolList showRequestFaileMessageLittleTime:@"请输入公司名称"];
       return;
   }
   else if (_zhiWeiL==nil||_zhiWeiL.text.length==0) {
       
       [ToolList showRequestFaileMessageLittleTime:@"请填写联系人职位"];
       return;
   }
    
    NSMutableDictionary *searchRequestDic = [[NSMutableDictionary alloc] init];
    [searchRequestDic setObject:_custId forKey:@"custId"];//客户ID
     [searchRequestDic setObject:_comL.text forKey:@"custName"];//客户名称
     [searchRequestDic setObject:_nameText.text forKey:@"linkManName"];//联系人名称
    [searchRequestDic setObject:_phoneText.text forKey:@"telephone"];//座机
     [searchRequestDic setObject:_telText.text forKey:@"contacts"];//电话
     [searchRequestDic setObject:_emailText.text forKey:@"email"];//邮箱
    if ([_saxL.text isEqualToString:@"男"]) {
        
        [searchRequestDic setObject:@"1" forKey:@"sex"];//联系人性别  1：先生 2：女士
    }else{
        [searchRequestDic setObject:@"2" forKey:@"sex"];//联系人性别  1：先生 2：女士
    }
    
     [searchRequestDic setObject:_buMenText.text forKey:@"dept"];//联系人部门
     [searchRequestDic setObject:typeId forKey:@"position"];//联系人职位
    if (_mySwitch.isOn) {
        
        [searchRequestDic setObject:@"1" forKey:@"flag"];//是否设为常用联系人  0：否 1：是
    }else{
         [searchRequestDic setObject:@"0" forKey:@"flag"];//是否设为常用联系人  0：否 1：是
    }
       
    [FX_UrlRequestManager postByUrlStr:addContact_url andPramas:searchRequestDic andDelegate:self andSuccess:@"addContactSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)addContactSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isBMtext = NO;
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _scorollviewX.constant = IOS7_Height;
   
    [self addNavgationbar:@"添加联系人" leftBtnName:@"取消" rightBtnName:@"完成" target:self leftBtnAction:nil  rightBtnAction:@"rightBtnAction"];
    
    [_button1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_button2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_button3 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    if(_comStr.length){
        
        _comL.text = _comStr;
        _button2.enabled = NO;
    }
    
    _nameText.textContainerInset = UIEdgeInsetsZero;
    _telText.textContainerInset = UIEdgeInsetsZero;
    _phoneText.textContainerInset = UIEdgeInsetsZero;
    _emailText.textContainerInset = UIEdgeInsetsZero;
     _buMenText.textContainerInset = UIEdgeInsetsZero;
}

-(IBAction)touchLabel:(UIButton *)sender{
    
    [_nameText resignFirstResponder];
    [_telText resignFirstResponder];
    [_emailText resignFirstResponder];
    [_buMenText resignFirstResponder];
    
    switch (sender.tag-124) {
        case 0:
        {
            //性别
            CY_chooseVc *v = [[CY_chooseVc alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.changeBlock = ^(NSString * str)
            {
                _saxL.text = str;
                
            };
            v.titleStr = @"选择性别";
            v.dataArr = [[NSMutableArray alloc]initWithObjects:@"男",@"女", nil];
            [self.navigationController pushViewController:v animated:NO];
            
        }
            break;
            
        case 1:
        {
            //公司
            SearchViewController *gh = [[SearchViewController alloc] init];
            gh.czBlock = ^(NSDictionary * dic)
            {
                _comL.text = [dic objectForKey:@"castname"];
                _custId = [dic objectForKey:@"castid"];
                
            };
            [self.navigationController pushViewController:gh animated:NO];
        }
            break;
            
        case 2:
        {
            //职位
            CY_chooseVc *v = [[CY_chooseVc alloc]init];
            v.automaticallyAdjustsScrollViewInsets = NO;
            v.isZhiWei = YES;
            v.changeDicBlock = ^(NSDictionary * dic)
            {
                _zhiWeiL.text = [dic objectForKey:@"name"];
                typeId = [dic objectForKey:@"id"];
                
            };
            v.titleStr = @"选择职位";
           
            [self.navigationController pushViewController:v animated:NO];
        }
            break;
            
        default:
            break;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (textView == _buMenText) {
        
        isBMtext = YES;
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
     NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)];
    if (textView == _telText) {
        _telH.constant = size.height;
                if (result.length<=11) {
        
                    return YES;
        
                }else{
        
                    textView.text = [result substringToIndex:11];
        
                    return NO;
        
                }
    }

    if (textView == _phoneText) {
        _phoenH.constant = size.height;
        
    }
    
    if (textView == _nameText ) {
           _nameH.constant = size.height;
                if (result.length<=50) {
        
                    return YES;
        
                }else{
        
                    textView.text = [result substringToIndex:50];
        
                    return NO;
        
                }
    }
    if ( textView == _emailText ) {

         _emailH.constant = size.height;
                if (result.length<=50) {
        
                    return YES;
        
                }else{
        
                    textView.text = [result substringToIndex:50];
        
                    return NO;
        
                }
    }
    
    if ( textView == _buMenText) {
        _buMenH.constant = size.height;
                if (result.length<=50) {
                    
                    return YES;
                    
                }else{
                    
                    textView.text = [result substringToIndex:50];
                    
                    return NO;
                    
                }
    }

    
      return YES;
}

#pragma mark -- 键盘监听
- (void)keyboardDidShow:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y ;  // 得到键盘弹出后的y坐标
    
    if (isBMtext) {
    
        _myView_X.constant =keyBoardEndY-(433+3);
    }

    
}
- (void)keyboardWillHide:(NSNotification *)notification{
  
    _myView_X.constant=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
