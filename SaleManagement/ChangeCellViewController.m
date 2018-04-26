//
//  ChangeCellViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 16/7/5.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "ChangeCellViewController.h"
#import "CY_Business.h"
#import "AppDelegate.h"
#import "FX_BusinessManagerHomeViewController.h"
#import "QZViewController.h"

@interface ChangeCellViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@property (nonatomic,weak)IBOutlet UIButton *validationBt;

@property (nonatomic,weak)IBOutlet UITextField *telText;

@property (nonatomic,weak)IBOutlet UITextField *ValidationField;
@property (strong, nonatomic) NSTimer *verificationTimer;
@property (assign, nonatomic) int timeSecond;

@end

@implementation ChangeCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _timeSecond = 60;
    _top.constant = IOS7_Height + 10;
    [self addNavgationbar:@"绑定手机" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
}

#pragma mark---获取验证码
-(void)getCode{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    reqDic[@"phone"] = _telText.text;
    
  [FX_UrlRequestManager postByUrlStr:getPhoneValidateCode_url andPramas:reqDic andDelegate:self andSuccess:@"handleGetPhoneValidateCodeSuccess:" andFaild:@"handleGetPhoneValidateCodeFailed:" andIsNeedCookies:YES];
  
}

- (void)handleGetPhoneValidateCodeSuccess:(NSMutableDictionary *)receiveDic
{
  
    if ([[receiveDic objectForKey:@"code"] intValue] == 200) {
        NSLog(@"验证码:%@",[[receiveDic objectForKey:@"result"] objectForKey:@"code"]);
    }else{
        
        [ToolList showRequestFaileMessageLittleTime:@"验证码获取失败！"];
        
        [_verificationTimer invalidate];
        _timeSecond = 60;
        _validationBt.userInteractionEnabled = YES;
        _validationBt.backgroundColor = [UIColor colorWithRed:0 green:170/255.0 blue:255/255.0 alpha:1.0];
        [_validationBt setTitle:@"发送验证" forState:UIControlStateNormal];
        
    }
}

- (void)handleGetPhoneValidateCodeFailed:(NSMutableDictionary *)receiveDic
{

    [_verificationTimer invalidate];
    _timeSecond = 60;
    _validationBt.userInteractionEnabled = YES;
    _validationBt.backgroundColor = [UIColor colorWithRed:0 green:170/255.0 blue:255/255.0 alpha:1.0];
    [_validationBt setTitle:@"发送验证" forState:UIControlStateNormal];
    
}

#pragma mark---发送验证
- (IBAction)getValidation:(id)sender {
    
    if ([_telText.text isEqualToString:@""]){
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入正确的手机号码"];
        
        return;
    }
    
    else if (!wiNSStringIsValidPhone(_telText.text)) {
        
        [ToolList showRequestFaileMessageLittleTime:@"手机有误，请重新输入"];
        
        return;
    }
    
   [self getCode];
    
    _validationBt.userInteractionEnabled = NO;
    _validationBt.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    [_validationBt setTitle:[NSString stringWithFormat:@"%dS",_timeSecond] forState:UIControlStateNormal];
    self.verificationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeVerificationCodeTime) userInfo:nil repeats:YES];

}

//获取验证码控制
- (void)changeVerificationCodeTime
{
    if (--_timeSecond == 0) {
        
        [_verificationTimer invalidate];
        _timeSecond = 60;
        _validationBt.userInteractionEnabled = YES;
        _validationBt.backgroundColor = [UIColor colorWithRed:0 green:170/255.0 blue:255/255.0 alpha:1.0];
        [_validationBt setTitle:@"发送验证" forState:UIControlStateNormal];
    }else{
        [_validationBt setTitle:[NSString stringWithFormat:@"%dS",_timeSecond] forState:UIControlStateNormal];
    }
    
}

#pragma mark---提交
- (IBAction)getSubmit:(id)sender {
    
    if (_telText.text.length==0 ){
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入正确的手机号码"];
        
        return;
    }
    
    else if (!wiNSStringIsValidPhone(_telText.text)) {
        
        [ToolList showRequestFaileMessageLittleTime:@"手机有误，请重新输入"];
        
        return;
    }
  
   else if (_ValidationField.text == nil || _ValidationField.text.length == 0) {
        
         [ToolList showRequestFaileMessageLittleTime:@"请输入正确的验证码！"];
        
        return;
    }
    
    NSMutableDictionary *  dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:_telText.text,@"phone",_ValidationField.text,@"code", nil];

    
    [FX_UrlRequestManager postByUrlStr:bindingPhone_url andPramas:dicc andDelegate:self andSuccess:@"ChangeSuccess:" andFaild:nil andIsNeedCookies:YES];
}


- (void)ChangeSuccess:(NSMutableDictionary *)receiveDic
{
  
    if ([[receiveDic objectForKey:@"code"] intValue] == 200) {

        [_verificationTimer invalidate];
        _timeSecond = 60;
        _validationBt.userInteractionEnabled = YES;
        _validationBt.backgroundColor = [UIColor colorWithRed:0 green:170/255.0 blue:255/255.0 alpha:1.0];
        [_validationBt setTitle:@"发送验证"forState:UIControlStateNormal];
        _ValidationField.text = @"";
        
        if (_telText.text.length) {
            
            [[NSUserDefaults standardUserDefaults] setObject:_telText.text forKey:@"BDphone"];
            [[NSUserDefaults standardUserDefaults] synchronize ];
        }
        
        if (_isPush) {
            
             AppDelegate *APdelegate =[UIApplication sharedApplication].delegate;
            if (APdelegate.window.rootViewController) {
                APdelegate.window.rootViewController = nil;
            }
            NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
            
            switch (isSW.intValue) {
                case 0://商务
                {
                    
                    CY_Business *businessVc = [[CY_Business alloc]init];
                    UINavigationController *mainVC = [[UINavigationController alloc]initWithRootViewController:businessVc];
                    mainVC.navigationBarHidden = YES;
                    businessVc.automaticallyAdjustsScrollViewInsets = NO;
                    APdelegate.window.rootViewController = mainVC;
                }
                    break;
                    
                case 1://经理
                {
                    FX_BusinessManagerHomeViewController *businessVc = [[FX_BusinessManagerHomeViewController alloc]init];
                    //    [businessVc _initTabbarView:dataArray];
                    UINavigationController *mainVC = [[UINavigationController alloc]initWithRootViewController:businessVc];
                    mainVC.navigationBarHidden = YES;
                    businessVc.automaticallyAdjustsScrollViewInsets = NO;
                    APdelegate.window.rootViewController = mainVC;
                }
                    break;
                case 2://总监
                {
                    FX_BusinessManagerHomeViewController *businessVc = [[FX_BusinessManagerHomeViewController alloc]init];
                    //    [businessVc _initTabbarView:dataArray];
                    UINavigationController *mainVC = [[UINavigationController alloc]initWithRootViewController:businessVc];
                    mainVC.navigationBarHidden = YES;
                    businessVc.automaticallyAdjustsScrollViewInsets = NO;
                    APdelegate.window.rootViewController = mainVC;
                }
                    break;
                    
                case 3://区总
                {
                    
                    QZViewController *businessVc = [[QZViewController alloc]init];
                    UINavigationController *mainVC = [[UINavigationController alloc]initWithRootViewController:businessVc];
                    mainVC.navigationBarHidden = YES;
                    businessVc.automaticallyAdjustsScrollViewInsets = NO;
                    APdelegate.window.rootViewController = mainVC;
                }
                    break;
                    
                default:
                    break;
            }

        }else{
        
        [self.navigationController popViewControllerAnimated:NO];
        }
        
    }else{
        
        [ToolList showRequestFaileMessageLittleTime:[receiveDic objectForKey:@"msg"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
