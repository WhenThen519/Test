//
//  LoginVC.m
//  SaleManagement
//
//  Created by chaiyuan on 15/11/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "LoginVC.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "CY_Business.h"
#import "FX_BusinessManagerHomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ChangeCellViewController.h"
#import "QZViewController.h"
#import "AlertShow.h"
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIView *logoBg;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *NameTextView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *TextView;

@property (assign,nonatomic)BOOL isManger;

@property (weak, nonatomic) IBOutlet UIImageView *nameImage;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImage;


@end

@implementation LoginVC
{
    BOOL isRememberPassword;
    BOOL isAutoLogin;
}

-(IBAction)goHelp:(id)sender{
    
    HelpViewController *helpView = [[HelpViewController alloc]init];
    [self presentViewController:helpView animated:YES completion:^{
        
    }];
    
}

- (IBAction)rememberPasswordBtnClicked:(id)sender {
    isRememberPassword = !isRememberPassword;
    //记住密码
    if(isRememberPassword)
    {
        [_rememberPasswordBtn setImage:[UIImage imageNamed:@"已选.png"] forState:UIControlStateNormal];
    }
    else
    {
        isAutoLogin = NO;
        [_autoLoginBtn setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        [_rememberPasswordBtn setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
    }
   
}
- (IBAction)autoLoginBtnClicked:(id)sender {
    isAutoLogin = !isAutoLogin;
    //自动登录
    if(isAutoLogin)
    {
        isRememberPassword = YES;
        [_autoLoginBtn setImage:[UIImage imageNamed:@"已选.png"] forState:UIControlStateNormal];
        [_rememberPasswordBtn setImage:[UIImage imageNamed:@"已选.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_autoLoginBtn setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];

    }
}

-(void)animationStart
{
    
    [UIView animateWithDuration:0.3 animations:^{
        _logoBg.frame = CGRectMake(_logoBg.frame.origin.x, __MainScreen_Height * 0.13, _logoBg.frame.size.width, _logoBg.frame.size.height);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.frame = CGRectMake(_contentView.frame.origin.x, __MainScreen_Height * 0.13+_logoBg.frame.size.height+37, _contentView.frame.size.width, _contentView.frame.size.height);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            _loginBtn.frame = CGRectMake(_loginBtn.frame.origin.x,  __MainScreen_Height * 0.13+_logoBg.frame.size.height+37+100+15, _loginBtn.frame.size.width, _loginBtn.frame.size.height);
        }];
        _top1.constant = __MainScreen_Height * 0.13;
        _top2.constant = __MainScreen_Height * 0.13+_logoBg.frame.size.height+37;
        _top3.constant = __MainScreen_Height * 0.13+_logoBg.frame.size.height+37+100+55;
    }];
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _loginBtn.layer.cornerRadius = 22;
    _loginBtn.layer.masksToBounds = YES;
    [self performSelector:@selector(animationStart) withObject:nil afterDelay:0.2];
    _NameTextView.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    if(_NameTextView.text.length)
    {
        [_TextView becomeFirstResponder];
    }
    else
    {
        [_NameTextView becomeFirstResponder];
    }

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion1 = [NSString stringWithFormat:@"v.%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
    NSString *currentVersion = [NSString stringWithFormat:@"版本号:%@",currentVersion1];
    
    _vLabel.text =currentVersion;
    
    isRememberPassword = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isRememberPassword"] boolValue];
    isAutoLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isAutoLogin"] boolValue];
    //记住密码
    if(isRememberPassword)
    {
        [_rememberPasswordBtn setImage:[UIImage imageNamed:@"已选.png"] forState:UIControlStateNormal];
        _TextView.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.backgroundColor = [ToolList getColor:@"6052ba"];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = [ToolList getColor:@"EEECEC"];
        [_loginBtn setTitleColor:[ToolList getColor:@"cccccc"] forState:UIControlStateNormal];
        isAutoLogin = NO;
        [_autoLoginBtn setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        [_rememberPasswordBtn setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        _TextView.text = @"";
    }
    //自动登录
    if(isAutoLogin)
    {
        isRememberPassword = YES;
        [_autoLoginBtn setImage:[UIImage imageNamed:@"已选.png"] forState:UIControlStateNormal];
        [_rememberPasswordBtn setImage:[UIImage imageNamed:@"已选.png"] forState:UIControlStateNormal];
        [self LoginUp:nil];
    }
    else
    {
        [_autoLoginBtn setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        
    }

    //测测商务代表
    //        [FX_UrlRequestManager postByUrlStr:Business_url andPramas:nil andDelegate:self andSuccess:@"ConnectSuccess:" andFaild:@"ConnectSuccess1:" andIsNeedCookies:NO];
    
}

- (BOOL)supportEmoji
{
    BOOL hasEmoji = NO;
#define kPreferencesPlistPath @"/private/var/mobile/Library/Preferences/com.apple.Preferences.plist"
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:kPreferencesPlistPath];
    NSNumber *emojiValue = [plistDict objectForKey:@"KeyboardEmojiEverywhere"];
    if (emojiValue)     //value might not exist yet
        hasEmoji = YES;
    else
        hasEmoji = NO;
    
    return hasEmoji;
}

/* 点击登录按钮 */
-(IBAction)LoginUp:(id)sender{
    
    [self resign];
    
// NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"wuhhexing@300.cn",@"loginName",@"1q2w3e4r",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
 

//    NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"zzfuliying@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//    NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"zzjiangzhuoqun@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//     NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"tyduliang@300.cn",@"loginName",@"dl123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//    NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"qdwanghaibin@300.cn",@"loginName",@"1q2w3e4r",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//    NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"qdtianshuhui@300.cn",@"loginName",@"12345678",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
//     NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"qdtiannaiwang@300.cn",@"loginName",@"1q2w3e4r",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
//    NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"sjzwenjingxian@300.cn",@"loginName",@"12345678",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//    NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"tscuijinmei@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//     NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"qdxiefang@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];//经理
    
// NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"sjzlinxiaohong@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//    NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"bdzhangchunjuan@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//     NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"zzliumeixia@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
// NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ytfanshiwen@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
//     NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"zzliumeixia@300.cn",@"loginName",@"aa123456",@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];

    [[NSUserDefaults standardUserDefaults] setObject:_NameTextView.text forKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:_TextView.text forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isRememberPassword] forKey:@"isRememberPassword"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isAutoLogin] forKey:@"isAutoLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"登陆后%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"]);
    //商务经理
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [NSString stringWithFormat:@"v.%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];

   NSMutableDictionary *dicc =[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"phoneType",currentVersion,@"version",_NameTextView.text,@"loginName",_TextView.text,@"password",[[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoken"],@"iosDeviceToken", nil];
    
    [FX_UrlRequestManager postByUrlStr:Login_url andPramas:dicc andDelegate:self andSuccess:@"ConnectSuccess:" andFaild:nil andIsNeedCookies:YES];
    
    
    //    [FX_UrlRequestManager postByUrlStr:@"http://10.12.40.205/group1/M00/00/05/Cgwo0FZ7j0-Ab-8DAAr-sfuLiZo532.mp3" andPramas:nil andDelegate:self andSuccess:@"ConnectSuccess:" andFaild:@"ConnectFild:" andIsNeedCookies:NO];
    
    

}

-(void)ConnectSuccess:(NSMutableDictionary *)dic
{
    AppDelegate *APdelegate =[UIApplication sharedApplication].delegate;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"tag"] forKey:@"TAG"];
     [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"alias"] forKey:@"BIEMING"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"sex"] forKey:@"SEX"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"token"] forKey:@"IOSTOKEN"];
     [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"userName"] forKey:@"UserRealName"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"jobGrade"] forKey:@"SWjobGrade"];
    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"result"] forKey:@"QUANXIAN"];

    if ([[dic objectForKey:@"phone"] length]) {
         [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"phone"] forKey:@"BDphone"];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([JPUSHService registrationID] && [[JPUSHService registrationID] length])
    {
        if([Host_url isEqualToString:@"http://m.api.ceboss.cn/SmaMobile/"])
        {
        [JPUSHService setTags:[NSSet setWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TAG"]] alias:[[NSUserDefaults standardUserDefaults]objectForKey:@"BIEMING"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            
            NSLog(@"哈哈哈哈哈哈哈哈rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        }];
        }
    }
  
    if (APdelegate.window.rootViewController) {
        APdelegate.window.rootViewController = nil;
    }
    
    if ([[dic objectForKey:@"binding"]intValue]==0) {
        
        ChangeCellViewController *businessVc = [[ChangeCellViewController alloc]init];
        businessVc.isPush = YES;
        UINavigationController *mainVC = [[UINavigationController alloc]initWithRootViewController:businessVc];
        mainVC.navigationBarHidden = YES;
        businessVc.automaticallyAdjustsScrollViewInsets = NO;
        APdelegate.window.rootViewController = mainVC;
        
        return;
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
    int noticeFlag = [[dic objectForKey:@"noticeFlag"] intValue];
    NSString *noticeId = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"noticeId"] intValue]];
    NSString *noticeUrl = [dic objectForKey:@"noticeUrl"];
    NSString *noticeTitle = [dic objectForKey:@"noticeTitle"];
    [[NSUserDefaults standardUserDefaults] setObject:noticeId forKey:@"noticeId"];
     [[NSUserDefaults standardUserDefaults] setObject:noticeUrl forKey:@"noticeUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:noticeTitle forKey:@"noticeTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
if(noticeFlag == 0  && noticeUrl.length && noticeId.length)
{
    AlertShow *a = [[AlertShow alloc] init];
//    [a setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    a.noticeUrl = noticeUrl;
    a.noticeId = noticeId;
    a.noticeTitle = noticeTitle;
    a.fromMe = NO;
    [APdelegate.window.rootViewController presentViewController:a animated:YES completion:^{
        
    }];
}
   



}

-(void)ConnectFild:(NSError *)err
{
    
}

/* 收缩键盘*/
-(IBAction)dismissKeyboard:(id)sender{
    
    [self resign];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self resign];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(_NameTextView.text.length&& _TextView.text.length )
    {
        _loginBtn.userInteractionEnabled = YES;
        _loginBtn.backgroundColor = [ToolList getColor:@"6052ba"];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if(string.length==0 && _TextView.text.length==1)
        
    {
        _loginBtn.userInteractionEnabled = NO;
        _loginBtn.backgroundColor = [ToolList getColor:@"EEECEC"];
        [_loginBtn setTitleColor:[ToolList getColor:@"cccccc"] forState:UIControlStateNormal];
    }
    return YES;
}

-(void)resign{
    
    [_NameTextView resignFirstResponder];
    
    [_TextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
