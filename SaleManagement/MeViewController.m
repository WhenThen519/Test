//
//  MeViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/20.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "ChangePasswordViewController.h"
#import "MeViewController.h"
#import "XiejiluViewController.h"
#import "LoginVC.h"
#import "AppDelegate.h"
#import "CY_addClientVc.h"
#import "AddNewScheduleViewController.h"
#import "ChangeCellViewController.h"
#import "AlertShow.h"
#import "CY_myClientVC.h"
#import "BuMenViewController.h"
#import "J_ScheduleViewController.h"
#import "ScheduleViewController.h"
#import "S_ScheduleViewController.h"

@interface MeViewController ()
{
    UIView *_tabbarView;//首页下面的分页图
     UIImageView *showImageV;
    UIImageView *bgImage;
    bool isSelectAddBtn;
    UILabel *cellStr ;//绑定手机号码
}
@property (nonatomic,strong)CIContext *context;
@end
@implementation MeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isSelectAddBtn = NO;
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    addBtn.transform = transform;
    bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
     cellStr.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"BDphone"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-50)];
    scr.backgroundColor = [ToolList getColor:@"F1F4F4"];
    [self.view addSubview:scr];
    scr.contentSize = CGSizeMake(__MainScreen_Width, 560);
    _bg_top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 180)];
    _bg_top.image = [UIImage imageNamed:@"bg-me.png"];
    [scr addSubview:_bg_top];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    _headView.center = _bg_top.center;
    [_bg_top addSubview:_headView];
    _headBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _headBtn.center = _bg_top.center;
    [_bg_top addSubview:_headBtn];
    _content1 = [[UIView alloc] initWithFrame:CGRectMake(0, 190, __MainScreen_Width, 150)];
    _content1.backgroundColor = [UIColor whiteColor];
    _userName_L = [[UILabel alloc] initWithFrame:CGRectMake(0, _headView.frame.origin.y+75, __MainScreen_Width, 20)];
    _userName_L.font = [UIFont systemFontOfSize:18];
    _userName_L.textColor = [UIColor whiteColor];
    _userName_L.textAlignment = NSTextAlignmentCenter;
    [_bg_top addSubview:_userName_L];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 45, 50)];
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [ToolList getColor:@"999999"];
    name.text = @"姓名";
    [_content1 addSubview:name];
    UILabel *zhanghao = [[UILabel alloc] initWithFrame:CGRectMake(13, 50, 45, 50)];
    zhanghao.font = [UIFont systemFontOfSize:15];
    zhanghao.textColor = [ToolList getColor:@"999999"];
    zhanghao.text = @"账号";
    [_content1 addSubview:zhanghao];
    UILabel *verson = [[UILabel alloc] initWithFrame:CGRectMake(13, 100, 45, 50)];
    verson.font = [UIFont systemFontOfSize:15];
    verson.textColor = [ToolList getColor:@"999999"];
    verson.text = @"版本";
    [_content1 addSubview:verson];
    _nameL = [[UILabel alloc] initWithFrame:CGRectMake(58, 0, __MainScreen_Width-70, 50)];
    _nameL.font = [UIFont systemFontOfSize:16];
    _nameL.textColor = [ToolList getColor:@"333333"];
    [_content1 addSubview:_nameL];
    _zhanghaoL = [[UILabel alloc] initWithFrame:CGRectMake(58, 50, __MainScreen_Width-70, 50)];
    _zhanghaoL.font = [UIFont systemFontOfSize:16];
    _zhanghaoL.textColor = [ToolList getColor:@"333333"];
    [_content1 addSubview:_zhanghaoL];
    _banbenL = [[UILabel alloc] initWithFrame:CGRectMake(58, 100, __MainScreen_Width-70, 50)];
    _banbenL.font = [UIFont systemFontOfSize:16];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currentVersion = [NSString stringWithFormat:@"v.%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
    _banbenL.text = [NSString stringWithFormat:@"%@ 版",currentVersion];
    _banbenL.textColor = [ToolList getColor:@"333333"];
    [_content1 addSubview:_banbenL];
    [_content1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_content1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 150-0.8) toPoint:CGPointMake(__MainScreen_Width, 150-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_content1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(13, 50-0.8) toPoint:CGPointMake(__MainScreen_Width-13, 50-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_content1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(13, 100-0.8) toPoint:CGPointMake(__MainScreen_Width-13, 100-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [scr addSubview:_content1];
    _content2 = [[UIView alloc] initWithFrame:CGRectMake(0, 350, __MainScreen_Width, 200)];
    _content2.backgroundColor = [UIColor whiteColor];
    
    UILabel *ggL = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 100, 50)];
    ggL.font = [UIFont systemFontOfSize:16];
    ggL.textColor = [ToolList getColor:@"333333"];
    ggL.text = @"最新公告";
    [_content2 addSubview:ggL];
    
    UILabel *changePassword = [[UILabel alloc] initWithFrame:CGRectMake(13, 50, 100, 50)];
    changePassword.font = [UIFont systemFontOfSize:16];
    changePassword.textColor = [ToolList getColor:@"333333"];
    changePassword.text = @"修改密码";
    [_content2 addSubview:changePassword];
    
    UILabel *changeCell = [[UILabel alloc] initWithFrame:CGRectMake(13, 100, 100, 50)];
    changeCell.font = [UIFont systemFontOfSize:16];
    changeCell.textColor = [ToolList getColor:@"333333"];
    changeCell.text = @"绑定手机";
    [_content2 addSubview:changeCell];
    
    
    UILabel *cacheClear = [[UILabel alloc] initWithFrame:CGRectMake(13, 150, 100, 50)];
    cacheClear.font = [UIFont systemFontOfSize:16];
    cacheClear.textColor = [ToolList getColor:@"333333"];
    cacheClear.text = @"清除缓存";
    [_content2 addSubview:cacheClear];
    
    [_content2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    [_content2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 150-0.8) toPoint:CGPointMake(__MainScreen_Width, 150-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    [_content2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(13, 50-0.8) toPoint:CGPointMake(__MainScreen_Width-13, 50-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    [_content2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(13, 100-0.8) toPoint:CGPointMake(__MainScreen_Width-13, 100-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-32, 0, 32, 50)];
    image1.contentMode = UIViewContentModeCenter;
    image1.image = [UIImage imageNamed:@"btn_open.png"];
    [_content2 addSubview:image1];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-32, 50, 32, 50)];
    image2.image = [UIImage imageNamed:@"btn_open.png"];
    image2.contentMode = UIViewContentModeCenter;
    [_content2 addSubview:image2];
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-32, 100, 32, 50)];
    image3.image = [UIImage imageNamed:@"btn_open.png"];
    image3.contentMode = UIViewContentModeCenter;
    [_content2 addSubview:image3];
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-32, 150, 32, 50)];
    image4.image = [UIImage imageNamed:@"btn_open.png"];
    image4.contentMode = UIViewContentModeCenter;
    [_content2 addSubview:image4];
    
    cellStr = [[UILabel alloc] initWithFrame:CGRectMake(95, 100, __MainScreen_Width-125, 50)];
    cellStr.font = [UIFont systemFontOfSize:15];
    cellStr.textAlignment = NSTextAlignmentRight;
    cellStr.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"BDphone"];
    cellStr.textColor = [ToolList getColor:@"999999"];
    [_content2 addSubview:cellStr];
    
    _huancunL = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, __MainScreen_Width-32, 50)];
    _huancunL.font = [UIFont systemFontOfSize:15];
    _huancunL.textAlignment = NSTextAlignmentRight;
    _huancunL.textColor = [ToolList getColor:@"999999"];
    [_content2 addSubview:_huancunL];
    
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn0.frame = CGRectMake(0, 0, __MainScreen_Width, 50);
    [btn0 addTarget:self action:@selector(goGong:) forControlEvents:UIControlEventTouchUpInside];
    [_content2 addSubview:btn0];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 50, __MainScreen_Width, 50);
    [btn1 addTarget:self action:@selector(changePassword:) forControlEvents:UIControlEventTouchUpInside];
    [_content2 addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 100, __MainScreen_Width, 50);
    [btn2 addTarget:self action:@selector(goChangeCell) forControlEvents:UIControlEventTouchUpInside];
    [_content2 addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 150, __MainScreen_Width, 50);
    [btn3 addTarget:self action:@selector(deleteHuancun:) forControlEvents:UIControlEventTouchUpInside];
    [_content2 addSubview:btn3];
    
    [scr addSubview:_content2];
    _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_quitBtn addTarget:self action:@selector(quitCount:) forControlEvents:UIControlEventTouchUpInside];
    _quitBtn.frame = CGRectMake(0, 560, __MainScreen_Width, 50);
    [_quitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    _quitBtn.backgroundColor = [UIColor whiteColor];
    [_quitBtn setTitleColor:[ToolList getColor:@"ff3333"] forState:UIControlStateNormal];
    _quitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_quitBtn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.8 andColorString:@"e7e7eb"]];
    [_quitBtn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 50-0.8) toPoint:CGPointMake(__MainScreen_Width, 50-0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [scr addSubview:_quitBtn];
    scr.contentSize = CGSizeMake(__MainScreen_Width, _quitBtn.frame.origin.y+_quitBtn.frame.size.height+20);

    _userName_L.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserRealName"];
    _nameL.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserRealName"];
    _zhanghaoL.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    
    NSArray * normalArr = @[@"btn_home.png",@"normal-1.png",@"xrw.png",@"kh.png",@"sz.png"];
    NSArray * selectArr = @[@"btn_home_selected.png",@"activation.png",@"xrw_select.png",@"kh_select.png",@"sz_select.png"];
 
    _headView.layer.cornerRadius = 65/2.;
    _headView.layer.masksToBounds = YES;
    _headView.layer.borderWidth = 1;
    _headView.layer.borderColor = [UIColor colorWithRed:32/255. green:232/255. blue:231/255. alpha:1.0].CGColor;
    _headBtn.layer.cornerRadius = 30;
    _headBtn.layer.masksToBounds = YES;
    //商务
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"QUANXIAN"] isEqualToString:@"0"])
    {
  
        _nameL.text =[NSString stringWithFormat:@"%@(%@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserRealName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"SWjobGrade"]];
       
    }
    //男
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"SEX"] intValue]==0)
    {
        [_headBtn setImage:[UIImage imageNamed:@"icon_touxiang_jl.png"] forState:UIControlStateNormal];

    }
    //女
    else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SEX"] intValue]==1)
    {
        [_headBtn setImage:[UIImage imageNamed:@"girl.png"] forState:UIControlStateNormal];
    }
    float size = [ToolList folderSizeAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/cy"]];
    _huancunL.text = [NSString stringWithFormat:@"%.2f M",size];
    // Do any additional setup after loading the view from its nib.
    
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50)];
    bgImage.image = [UIImage imageNamed:@"口号.png"];
    bgImage.userInteractionEnabled = YES;
    //计算间距
    float btnWight = 47;
    float btnHight = 60;
    float leftPx = 60;
    float btnPointY = __MainScreen_Height-70-btnHight;
    
    float space = (__MainScreen_Width-leftPx*2-btnWight*3)/2.;
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        //写记录
        UIButton *xiejiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xiejiluBtn.frame = CGRectMake(leftPx,btnPointY , btnWight, btnHight);
        [xiejiluBtn addTarget:self action:@selector(xiejilu_J) forControlEvents:UIControlEventTouchUpInside];
        [xiejiluBtn setImage:[UIImage imageNamed:@"写记录icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:xiejiluBtn];
        
        //添加日程
        UIButton *addScheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addScheduleBtn.frame = CGRectMake(xiejiluBtn.frame.origin.x+space+btnWight,btnPointY , btnWight, btnHight);
        [addScheduleBtn addTarget:self action:@selector(addSchedule) forControlEvents:UIControlEventTouchUpInside];
        [addScheduleBtn setImage:[UIImage imageNamed:@"添加日程icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:addScheduleBtn];
        //下任务
        UIButton *xiarenwuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xiarenwuBtn.frame = CGRectMake(addScheduleBtn.frame.origin.x+space+btnWight,btnPointY , btnWight, btnHight);
        [xiarenwuBtn addTarget:self action:@selector(xiarenwu) forControlEvents:UIControlEventTouchUpInside];
        [xiarenwuBtn setImage:[UIImage imageNamed:@"下达任务icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:xiarenwuBtn];
        
        
        
    }
    //总监
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
    {
        //写记录
        UIButton *xiejiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xiejiluBtn.frame = CGRectMake(leftPx,btnPointY , btnWight, btnHight);
        [xiejiluBtn addTarget:self action:@selector(xiejilu_J) forControlEvents:UIControlEventTouchUpInside];
        [xiejiluBtn setImage:[UIImage imageNamed:@"写记录icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:xiejiluBtn];
        
        //添加日程
        UIButton *addScheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addScheduleBtn.frame = CGRectMake(xiejiluBtn.frame.origin.x+space+btnWight,btnPointY , btnWight, btnHight);
        [addScheduleBtn addTarget:self action:@selector(addSchedule) forControlEvents:UIControlEventTouchUpInside];
        [addScheduleBtn setImage:[UIImage imageNamed:@"添加日程icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:addScheduleBtn];
       
    }
  else  if([[[NSUserDefaults standardUserDefaults] objectForKey:@"QUANXIAN"] isEqualToString:@"3"]){
        
        normalArr = @[@"btn_home.png",@"btn_add.png",@"btn_me.png"];
        selectArr = @[@"btn_home_selected.png",@"btn_record_click.png",@"btn_me_selected.png"];
    }
    //商务
    else
    {
        //写记录
        UIButton *xiejiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xiejiluBtn.frame = CGRectMake(leftPx,btnPointY , btnWight, btnHight);
        [xiejiluBtn addTarget:self action:@selector(goWritView:) forControlEvents:UIControlEventTouchUpInside];
        [xiejiluBtn setImage:[UIImage imageNamed:@"写记录icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:xiejiluBtn];
        
        //添加日程
        UIButton *addScheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addScheduleBtn.frame = CGRectMake(xiejiluBtn.frame.origin.x+space+btnWight,btnPointY , btnWight, btnHight);
        [addScheduleBtn addTarget:self action:@selector(addSchedule) forControlEvents:UIControlEventTouchUpInside];
        [addScheduleBtn setImage:[UIImage imageNamed:@"添加日程icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:addScheduleBtn];
        //添加客户
        UIButton *addUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addUserBtn.frame = CGRectMake(addScheduleBtn.frame.origin.x+space+btnWight,btnPointY , btnWight, btnHight);
        [addUserBtn addTarget:self action:@selector(goAddView:) forControlEvents:UIControlEventTouchUpInside];
        [addUserBtn setImage:[UIImage imageNamed:@"添加客户icon.png"] forState:UIControlStateNormal];
        [bgImage addSubview:addUserBtn];
        
        normalArr = @[@"btn_home.png",@"normal-1.png",@"xjl.png",@"kh.png",@"sz.png"];
        selectArr = @[@"btn_home_selected.png",@"activation.png",@"xjl.png",@"kh_select.png",@"sz_select.png"];
    }
    
    [self.view addSubview:bgImage];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0) {
           [super _initTabbarView:@[@"首页",@"日程",@"写记录",@"客户",@"设置"] andNormalImage:normalArr andselected:selectArr andSelectIndex:[normalArr count]-1];
        
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
        
           [super _initTabbarView:@[@"首页",@"记录",@"我"] andNormalImage:normalArr andselected:selectArr andSelectIndex:[normalArr count]-1];
    }
    else{
           [super _initTabbarView:@[@"首页",@"日程",@"下任务",@"客户",@"设置"] andNormalImage:normalArr andselected:selectArr andSelectIndex:[normalArr count]-1];
    }

}

#pragma mark---绑定手机
-(void)goChangeCell{
    
    ChangeCellViewController *changeCell = [[ChangeCellViewController alloc]init];
    [self.navigationController pushViewController:changeCell animated:NO];
 
}

#pragma mark - 经理和总监写任务
-(void)xiejilu_J
{
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"经理";
    gh.fromPage = @"home";
     gh.isShouYe = YES;//从首页跳转，不需要带客户名称，右上角添加客户按钮显示
    [self.navigationController pushViewController:gh animated:NO];
  
}
#pragma mark - 下任务
-(void)xiarenwu
{
    renWuViewController *renwu = [[renWuViewController alloc] init];
    [self.navigationController pushViewController:renwu animated:NO];
}
#pragma mark - 添加日程
-(void)addSchedule
{
    //商务
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0)
    {
        S_ScheduleViewController *an = [[S_ScheduleViewController alloc] init];
        [self.navigationController  pushViewController:an animated:NO];
    }
    //经理
   else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        J_ScheduleViewController *ss = [[J_ScheduleViewController alloc] init];
        [self.navigationController pushViewController:ss animated:NO];
    }
    //总监
    else
    {
        ScheduleViewController *ss = [[ScheduleViewController alloc] init];
        [self.navigationController pushViewController:ss animated:NO];
    }
}
- (void)changePassword:(id)sender {
    ChangePasswordViewController *c = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:c animated:NO];
}
- (void)deleteHuancun:(id)sender {
    if([_huancunL.text isEqualToString:@"0.00 M"])
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无缓存！"];
    }
    else
    {
    //删除文件夹及文件级内的文件：
    NSString *imageDir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/cy"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *err ;
    [fileManager removeItemAtPath:imageDir error:&err];
    if(!err)
    {
        [ToolList showRequestFaileMessageLittleTime:@"清理成功！"];
        _huancunL.text = @"0.00 M";
    }
    }
}
-(void)logotSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue]==200)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isRememberPassword"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isAutoLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            
            NSLog(@"哈哈哈哈哈哈哈哈rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        }];
        AppDelegate *de = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LoginVC *root =  [[LoginVC alloc] init];
        de.window.rootViewController = root;
    }
}
- (void)quitCount:(id)sender {
    [FX_UrlRequestManager postByUrlStr:LoginOut_url andPramas:nil andDelegate:self andSuccess:@"logotSuccess:" andFaild:nil andIsNeedCookies:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectedTab:(UIButton *)btn{
    isSelectAddBtn = !isSelectAddBtn;
    if(btn.tag == 199)//去首页
    {
        isSelectAddBtn = NO;
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            addBtn.transform = transform;
            bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        }];
        
         [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else if (btn.tag == 201)//商务-写记录  经理+总监--下任务
    {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]!=3){
            isSelectAddBtn = NO;
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            addBtn.transform = transform;
            bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0){
            
                [self xiejilu_J];
            
            }else{
        
                [self xiarenwu];
            }
        }
    }
    
    else if (btn.tag == 200){//日程
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]!=3){
            isSelectAddBtn = NO;
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            addBtn.transform = transform;
            bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
            
            [self addSchedule];
        }
       
    }
    else if (btn.tag == 202){//客户
        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0){
            
            CY_myClientVC *ghVC = [[CY_myClientVC alloc]init];
            ghVC.automaticallyAdjustsScrollViewInsets = NO;
            ghVC.isMe = YES;
            [self.navigationController pushViewController:ghVC animated:NO];
            
        }else{
            
            BuMenViewController *buMenVc =[[BuMenViewController alloc] init];
            [self.navigationController pushViewController:buMenVc animated:NO];
        }
 
    }
    
    else//设置-我的
    {
        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        
    }
    
}


#pragma mark -- 我
-(void) me
{
    
    MeViewController *gh = [[MeViewController alloc] init];
    [self.navigationController pushViewController:gh animated:NO];
}

#pragma mark---进入添加客户页面
-(void)goAddView:(UIButton *)sender{
    
    CY_addClientVc *ghVC = [[CY_addClientVc alloc]init];
    ghVC.automaticallyAdjustsScrollViewInsets = NO;
    ghVC.isShou = YES;
    [self.navigationController pushViewController:ghVC animated:NO];
}

#pragma mark --- 截屏
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark ---模糊效果
- (UIImage *)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur {
    self.context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur),
                        nil];
    
    CIImage *outputImage = filter.outputImage;
    
    CGImageRef outImage = [self.context createCGImage:outputImage
                                             fromRect:CGRectMake([outputImage extent].origin.x+4*blur, [outputImage extent].origin.y+4*blur, [outputImage extent].size.width-8*blur, [outputImage extent].size.height-8*blur)];
    return [UIImage imageWithCGImage:outImage];
}

-(void)addCancel:(UIImageView *)subV{
    
    UIView *blackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-49-__MainScreen_Height*0.39)];
    blackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [subV addSubview:blackV];
    
    UIView *writV = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-49-__MainScreen_Height*0.39, __MainScreen_Width, __MainScreen_Height*0.39)];
    writV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    writV.userInteractionEnabled = YES;
    [subV addSubview:writV];
    
    UIButton *leftB = [UIButton buttonWithType:UIButtonTypeCustom];
    leftB.frame = CGRectMake(__MainScreen_Width*0.17-1, __MainScreen_Height*0.32-25-70, 72,100);
    [leftB setImage:[UIImage imageNamed:@"btn_xjl_homepage.png"] forState:UIControlStateNormal];
    leftB.imageEdgeInsets = UIEdgeInsetsMake(0,1,25,leftB.titleLabel.bounds.size.width);
    [leftB setTitle:@"写记录" forState:UIControlStateNormal];
    leftB.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftB setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    leftB.backgroundColor = [UIColor clearColor];
    [leftB addTarget:self action:@selector(goWritView:) forControlEvents:UIControlEventTouchUpInside];
    leftB.titleEdgeInsets = UIEdgeInsetsMake(75, -leftB.titleLabel.bounds.size.width-70, 0, 0);
    [writV addSubview:leftB];
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightB setTitle:@"添加客户" forState:UIControlStateNormal];
    rightB.frame = CGRectMake(__MainScreen_Width*0.83-71, __MainScreen_Height*0.32-25-70, 72, 100);
    [rightB addTarget:self action:@selector(goAddView:) forControlEvents:UIControlEventTouchUpInside];
    rightB.titleLabel.font = [UIFont systemFontOfSize:15];
    rightB.imageEdgeInsets = UIEdgeInsetsMake(0,1,25,rightB.titleLabel.bounds.size.width);
    [rightB setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    rightB.titleEdgeInsets = UIEdgeInsetsMake(75, -rightB.titleLabel.bounds.size.width-70, 0, 0);
    [rightB setImage:[UIImage imageNamed:@"btn_tjkh_homepage.png"] forState:UIControlStateNormal];
    [writV addSubview:rightB];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, __MainScreen_Height-49, __MainScreen_Width, 49);
    [button setImage:[UIImage imageNamed:@"btn_close_homepage.png"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(cancelImage) forControlEvents:UIControlEventTouchUpInside];
    [subV addSubview:button];
    
}



#pragma mark---进入写记录页面
-(void)goWritView:(UIButton *)sender{
    [showImageV removeFromSuperview];
    showImageV = nil;
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"home";
     gh.isShouYe = YES;//从首页跳转，不需要带客户名称，右上角添加客户按钮显示
    [self.navigationController pushViewController:gh animated:NO];
}

-(void)cancelImage{
    
    showImageV.hidden = YES;
}

#pragma mark---进入最新公告页面
-(void)goGong:(id)sender{
    AppDelegate *APdelegate =[UIApplication sharedApplication].delegate;

    NSString *noticeId = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"noticeId"] intValue]];
    NSString *noticeUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"noticeUrl"];
    NSString *noticeTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"noticeTitle"];
    if(noticeUrl.length && noticeId.length)
    {
        AlertShow *a = [[AlertShow alloc] init];
        //    [a setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        a.noticeUrl = noticeUrl;
        a.noticeId = noticeId;
        a.noticeTitle = noticeTitle;
        a.fromMe = YES;
        [APdelegate.window.rootViewController presentViewController:a animated:YES completion:^{
            
        }];
    }
    else
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无公告"];
    }
    
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
