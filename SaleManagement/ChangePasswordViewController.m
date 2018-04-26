//
//  ChangePasswordViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/22.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "LoginVC.h"
#import "AppDelegate.h"
@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *queren_img;
@property (weak, nonatomic) IBOutlet UIImageView *xin_img;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *dangqian_img;


@end

@implementation ChangePasswordViewController
- (IBAction)show1:(id)sender {
    _dangqianmima.secureTextEntry = !_dangqianmima.secureTextEntry;
    if(_dangqianmima.secureTextEntry)
    {
        [_dangqian_img setImage:[UIImage imageNamed:@"btn_me_see.png"]];
    }
    else
    {
        [_dangqian_img setImage:[UIImage imageNamed:@"btn_me_nosee.png"]];
 
    }
}
- (IBAction)show2:(id)sender {
    _xinmima.secureTextEntry = !_xinmima.secureTextEntry;
    if(_xinmima.secureTextEntry)
    {
        [_xin_img setImage:[UIImage imageNamed:@"btn_me_see.png"]];
    }
    else
    {
        [_xin_img setImage:[UIImage imageNamed:@"btn_me_nosee.png"]];
        
    }

}
- (IBAction)show3:(id)sender {
    _querenmima.secureTextEntry = !_querenmima.secureTextEntry;
    if(_querenmima.secureTextEntry)
    {
        [_queren_img setImage:[UIImage imageNamed:@"btn_me_see.png"]];
    }
    else
    {
        [_queren_img setImage:[UIImage imageNamed:@"btn_me_nosee.png"]];
        
    }
}
-(void)click
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    _top.constant = IOS7_Height + 10;
    [self.view addGestureRecognizer:tap];
    [self addNavgationbar:@"修改密码" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    _commit.layer.cornerRadius = 2;
    _commit.layer.masksToBounds = YES;
    //_dangqianmima.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)commitNewPassword:(id)sender {
    
    if( ![_xinmima.text isEqualToString: _querenmima.text ])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新密码与确认密码是不一致，请重新输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if([_dangqianmima.text isEqualToString: _xinmima.text ])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新密码不可以与当期密码一致，请重新输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }

    
    if( _xinmima.text.length < 8 )
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"新密码长度不符合要求！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if( _querenmima.text.length < 8)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认密码长度不符合要求！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *  dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:_dangqianmima.text,@"password",_xinmima.text,@"newPassword", nil];
    
    [FX_UrlRequestManager postByUrlStr:ChangePassword_url andPramas:dicc andDelegate:self andSuccess:@"ChangeSuccess:" andFaild:nil andIsNeedCookies:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return (textField.text.length < 20);
}
-(void)ChangeSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue]==200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"密码修改成功，请重新登录"];
        [self performSelector:@selector(logout) withObject:nil afterDelay:2];
    }
}
-(void)logout
{
    AppDelegate *de = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginVC *root =  [[LoginVC alloc] init];
    de.window.rootViewController = root;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
