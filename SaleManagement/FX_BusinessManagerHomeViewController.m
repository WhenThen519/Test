//
//  FX_BusinessManagerHomeViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/11/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "GetAreaJLViewController.h"
#import "YidongViewController.h"
#import "J_ScheduleViewController.h"
#import "XiejiluViewController.h"
#import "New_Gonghai.h"
#import "FX_BusinessManagerHomeViewController.h"
#import "InProductionViewController.h"
#import "QianKuanViewController.h"
#import "ZJQianKuanViewController.h"
#import "DueProductsViewController.h"
#import "ZJDueProductsViewController.h"
#import "DistributionViewController.h"
#import "YuanGongCountViewController.h"
#import "BuMenViewController.h"
#import "JingxianjinViewController.h"
#import "YixiangViewController.h"
#import "CY_OrientationVc.h"
#import "CY_recordVc.h"
#import "MeViewController.h"
#import "ZJ_DistributionViewController.h"
#import "JLBuMenVc.h"
#import "ScheduleViewController.h"
#import "CY_tjVC.h"
#import "AddNewScheduleViewController.h"
#import "GetAreaXJViewController.h"
#import "paiHangViewController.h"
#import "webViewController.h"
#import "SJFP.h"
#import "Visit.h"
#define IOS7_HeightPlus (IOS7?20:0)


@interface FX_BusinessManagerHomeViewController ()
{
    UIImageView *bgImage;
    bool isSelectAddBtn;
    //保存返回数据
    NSDictionary *resultDic;
    //今日净现金到账
    UILabel *todayAcctAmount;
    //本月净现金到账
    UILabel *monthAcctAmount;
    //本月目标
    UILabel *currentMonthGoal;
    //待分配
    UILabel *noAssignCustCount;
    //产品到期
    UILabel *dueProductCustCount;
    //生产中
    UILabel *inProductionCustCount;
    //欠款客户
    UILabel *arearCustCount;
}
@end

@implementation FX_BusinessManagerHomeViewController
#pragma mark - 按钮点击事件
#pragma mark - 今日到账点击


-(void)touchup:(UIButton *)bt
{
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
        //        JingxianjinViewController *inView = [[JingxianjinViewController alloc] init];
        //        [self.navigationController pushViewController:inView animated:NO];
        GetAreaJLViewController *getArea = [[GetAreaJLViewController alloc]init];
        [self.navigationController pushViewController:getArea animated:NO];
    }
    //总监
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2){
        GetAreaXJViewController *getArea = [[GetAreaXJViewController alloc]init];
        [self.navigationController pushViewController:getArea animated:NO];
    }
}
-(void)touchBt:(UIButton *)bt{
    
    switch (bt.tag) {
            //待分配
        case 0:
        {
            //经理
//            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
//            {
                DistributionViewController *inView = [[DistributionViewController alloc] init];
                [self.navigationController pushViewController:inView animated:NO];
                
//            }
//            //总监
//            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
//            {
//                ZJ_DistributionViewController *inView = [[ZJ_DistributionViewController alloc] init];
//                [self.navigationController pushViewController:inView animated:NO];
//
//            }
        }
            break;
            //产品到期
        case 1:
        {
            //经理
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
            {
                DueProductsViewController *inView = [[DueProductsViewController alloc] init];
                [self.navigationController pushViewController:inView animated:NO];
            }
            //总监
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
            {
                ZJDueProductsViewController *inView = [[ZJDueProductsViewController alloc] init];
                [self.navigationController pushViewController:inView animated:NO];
            }
            
        }
            break;
            //生产中
        case 2:{
            
            InProductionViewController *inView = [[InProductionViewController alloc] init];
            [self.navigationController pushViewController:inView animated:NO];
            
        }
            break;
            //尾款客户
        case 3:
        {
            
            
            //经理
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
            {
                QianKuanViewController *inView = [[QianKuanViewController alloc] init];
                [self.navigationController pushViewController:inView animated:NO];
            }
            //总监
            else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
            {
                ZJQianKuanViewController *inView = [[ZJQianKuanViewController alloc] init];
                [self.navigationController pushViewController:inView animated:NO];
            }
            
            
        }
            break;
        case 4:
        {
            //商机分pei

            SJFP *ss = [[SJFP alloc] init];
            [self.navigationController pushViewController:ss animated:NO];
            
            
            
        }
            break;
            //意向客户
        case 5:
        {
            
            //意向客户
            YixiangViewController *gh = [[YixiangViewController alloc] init];
            [self.navigationController pushViewController:gh animated:NO];
            
            
        }
            break;

            //部门客户
        case 6:
        {
            BuMenViewController *buMenVc =[[BuMenViewController alloc] init];
            [self.navigationController pushViewController:buMenVc animated:NO];
            
        }
            break;
            
       case 7:
        {
            // 公海客户
            New_Gonghai *gh = [[New_Gonghai alloc] init];
            gh.isS = NO;
            [self.navigationController pushViewController:gh animated:NO];
        }
            break;
       
        case 8:
        {
            //客户归属地查询
            CY_OrientationVc *orientationV = [[CY_OrientationVc alloc]init];
            orientationV.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:orientationV animated:NO];
        }
            break;
        case 9:
        {
            //拜访统计
            //经理
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1 )
            {
                Visit *ss = [[Visit alloc] init];
                ss.deptId = @"";
                ss.requestU = workAccount4DeptNew_url;
                [self.navigationController pushViewController:ss animated:NO];
            }
            // 总监
            else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
            {
                Visit *ss = [[Visit alloc] init];
                ss.deptId = @"";
                ss.requestU = workAccount4SubNew_url;
                [self.navigationController pushViewController:ss animated:NO];
            }
            //商务
            else
            {
                CY_tjVC *tjV = [[CY_tjVC alloc]init];
                
                tjV.automaticallyAdjustsScrollViewInsets = NO;
                [self.navigationController pushViewController:tjV animated:NO];
                
            }

        }
            break;
        case 10:
        {
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1 ){
                //案例库
                webViewController *debtVc = [[webViewController alloc]init];
                debtVc.automaticallyAdjustsScrollViewInsets = NO;
                [self.navigationController pushViewController:debtVc animated:NO];
  
            }else{
                //总监--员工异动
                YidongViewController *gh = [[YidongViewController alloc] init];
                [self.navigationController pushViewController:gh animated:NO];
            }
        }
            break;
   case 11:
        {
            //案例库
            webViewController *debtVc = [[webViewController alloc]init];
            debtVc.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:debtVc animated:NO];
        }
         break;
        
        default:
            break;
    }
}




#pragma mark - 网络请求回调
-(void)success:(NSDictionary *)dic
{
    resultDic = [dic objectForKey:@"result"];
    [self makeHandView];
    
}
#pragma mark - 请求数据
-(void)requestDate
{
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        [FX_UrlRequestManager postByUrlStr:BusinessM_url andPramas:nil andDelegate:self andSuccess:@"success:" andFaild:@"fail:" andIsNeedCookies:NO];
    }
    //总监
    else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
    {
        [FX_UrlRequestManager postByUrlStr:MobileMajordomoIndexAction_url andPramas:nil andDelegate:self andSuccess:@"success:" andFaild:@"fail:" andIsNeedCookies:NO];
    }
}
-(void)fail:(NSError *)err
{
    
    [self requestDate];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50)];
    bgImage.image = [UIImage imageNamed:@"口号.png"];
    bgImage.userInteractionEnabled = YES;
    //计算间距
    float btnWight = 47;
    float btnHight = 60;
    float btnPointY = __MainScreen_Height-70-btnHight;
    
    float space = (__MainScreen_Width-btnWight*2)/3.;
  /*
    //写记录
    UIButton *xiejiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiejiluBtn.frame = CGRectMake(space,btnPointY , btnWight, btnHight);
    [xiejiluBtn addTarget:self action:@selector(xiejilu) forControlEvents:UIControlEventTouchUpInside];
    [xiejiluBtn setImage:[UIImage imageNamed:@"写记录icon.png"] forState:UIControlStateNormal];
   // [bgImage addSubview:xiejiluBtn];
    
    //添加日程
    UIButton *addScheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addScheduleBtn.frame = CGRectMake(space,btnPointY , btnWight, btnHight);
    [addScheduleBtn addTarget:self action:@selector(addSchedule) forControlEvents:UIControlEventTouchUpInside];
    [addScheduleBtn setImage:[UIImage imageNamed:@"添加日程icon.png"] forState:UIControlStateNormal];
    [bgImage addSubview:addScheduleBtn];
    //下任务
    UIButton *xiarenwuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiarenwuBtn.frame = CGRectMake(addScheduleBtn.frame.origin.x+space+btnWight,btnPointY , btnWight, btnHight);
    [xiarenwuBtn addTarget:self action:@selector(xiarenwu) forControlEvents:UIControlEventTouchUpInside];
    [xiarenwuBtn setImage:[UIImage imageNamed:@"下达任务icon.png"] forState:UIControlStateNormal];
    [bgImage addSubview:xiarenwuBtn];
    
    
    [self.view addSubview:bgImage];
    */
    
    
    isSelectAddBtn = NO;
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    addBtn.transform = transform;
    bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
    //请求数据
    [self requestDate];
}
#pragma mark - 下任务
-(void)xiarenwu
{
    renWuViewController *renwu = [[renWuViewController alloc] init];
    [self.navigationController pushViewController:renwu animated:NO];
}
#pragma mark - 日程
-(void)addSchedule
{
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
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
#pragma mark - 中部按钮点击

-(void)btnCliked:(UIButton *)btn
{
    
    switch (btn.tag) {
            //公海客户
        case 0:
        {
            
            New_Gonghai *gh = [[New_Gonghai alloc] init];
            gh.isS = NO;
            [self.navigationController pushViewController:gh animated:NO];
            
        }
            break;
            
            //客户归属
        case 1:
        {
            //客户定位
            CY_OrientationVc *orientationV = [[CY_OrientationVc alloc]init];
            orientationV.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:orientationV animated:NO];
            }
            break;
            
        case 2:
        {
            
            //经理
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1 )
            {
                Visit *ss = [[Visit alloc] init];
                ss.deptId = @"";
                ss.requestU = workAccount4DeptNew_url;
                [self.navigationController pushViewController:ss animated:NO];
            }
            // 总监
            else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
            {
                Visit *ss = [[Visit alloc] init];
                ss.deptId = @"";
                ss.requestU = workAccount4SubNew_url;
                [self.navigationController pushViewController:ss animated:NO];
            }
            //商务
            else
            {
                CY_tjVC *tjV = [[CY_tjVC alloc]init];
                
                tjV.automaticallyAdjustsScrollViewInsets = NO;
                [self.navigationController pushViewController:tjV animated:NO];

            }
        }
            break;
            
        case 3:
        {
            //经理
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
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
            break;
            
            //员工异动
        case 4:
        {
            YidongViewController *gh = [[YidongViewController alloc] init];
            [self.navigationController pushViewController:gh animated:NO];
            
        }
            break;
            
        default:
            break;
    }
    
}




static int a = 0;
#define Image_H 213
#pragma mark - 页面初始化
-(void)makeHandView{
    if(xxHand)
    {
        [xxHand removeFromSuperview];
    }
    
    xxHand = [[handView alloc]initWithTitle:@"销售管理" andTitleColor:[ToolList getColor:@"9794e4"]  andBGColor:[UIColor clearColor] andLeftImage:nil andRightImage:@"" andLeftTitle:nil andRightTitle:nil andTarget:self];
    [self.view addSubview:xxHand];
    
    for (UIView *subV in middleView.subviews) {
        if(subV)
        {
            [subV removeFromSuperview];
        }
    }
    
    handImage = [UIButton buttonWithType:UIButtonTypeCustom];
    if (__MainScreen_Height<=568) {
        
        handImage.frame =CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height*0.45);
    }else{
        handImage.frame =CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height*0.375);
    }
    //    handImage.frame =CGRectMake(0, 0, __MainScreen_Width, Image_H);
    [handImage setBackgroundImage:[UIImage imageNamed:@"bg-homepage.png"] forState:UIControlStateNormal];
    
    [middleView addSubview:handImage];
    middleView.showsVerticalScrollIndicator = NO;
    [handImage addTarget:self action:@selector(touchup:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *paihangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    paihangBtn.frame = CGRectMake(__MainScreen_Width-42,iphone_stateBar , 30, 30);
    //    [paihangBtn addTarget:self action:@selector(paihangBT) forControlEvents:UIControlEventTouchUpInside];
    [paihangBtn setImage:[UIImage imageNamed:@"排行榜入口icon.png"] forState:UIControlStateNormal];
    [middleView addSubview:paihangBtn];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    
    
    imageV.frame =CGRectMake((__MainScreen_Width-225.5)/2, (handImage.frame.size.height-103.2)/2, 225.6, 103.2);
    
    [handImage addSubview:imageV];
    
    UILabel *monthAcctmountL = [[UILabel alloc]initWithFrame:CGRectMake(5, imageV.frame.origin.y+103.2-19, imageV.frame.origin.x-5, 19)];
    monthAcctmountL.font = [UIFont systemFontOfSize:14];
    monthAcctmountL.text = @"0.0";
    monthAcctmountL.textAlignment = NSTextAlignmentRight;
    monthAcctmountL.backgroundColor = [UIColor clearColor];
    monthAcctmountL.textColor = [ToolList getColor:@"ff33333"];
    [handImage addSubview:monthAcctmountL];
    
    //任务金额
    UILabel *currentMonthGoalL = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x+imageV.frame.size.width+2, monthAcctmountL.frame.origin.y, __MainScreen_Width-imageV.frame.origin.x-imageV.frame.size.width+5, 19)];
    currentMonthGoalL.font = [UIFont systemFontOfSize:14];
    currentMonthGoalL.backgroundColor = [UIColor clearColor];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        currentMonthGoalL.text = [NSString stringWithFormat:@"%@w",[resultDic objectForKey:@"deptTargetGoal"]];//
    }
    else
    {
        currentMonthGoalL.text = [NSString stringWithFormat:@"%@w",[resultDic objectForKey:@"currentMonthGoal"]];
    }
    currentMonthGoalL.textAlignment = NSTextAlignmentLeft;
    currentMonthGoalL.textColor = [ToolList getColor:@"ff33333"];
    [handImage addSubview:currentMonthGoalL];
    
    UILabel *renL = [[UILabel alloc]initWithFrame:CGRectMake(currentMonthGoalL.frame.origin.x, currentMonthGoalL.frame.origin.y+currentMonthGoalL.frame.size.height+6, 38, 14)];
    renL.font = [UIFont systemFontOfSize:14];
    renL.textColor = [ToolList getColor:@"ffffff"];
    renL.text = @"任务";
    [handImage addSubview:renL];
    
    //本月累计
    UILabel *yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x+(imageV.frame.size.width-136)/2, 76+imageV.frame.origin.y, 136, 19)];
    yueLabel.text = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"monthAcctAmount"]];
    yueLabel.textAlignment = NSTextAlignmentCenter;
    yueLabel.font = [UIFont systemFontOfSize:24];
    yueLabel.textColor = [ToolList getColor:@"46FB89"];
    [handImage addSubview:yueLabel];
    
    NSString *currStr ;
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        currStr = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"deptTargetGoal"]];
    }
    else
    {
        currStr = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"currentMonthGoal"]];
    }
    
    
    NSMutableAttributedString *attrString1 = nil;
    
    NSString *immutableString;
    NSMutableString *str = [NSMutableString stringWithString:yueLabel.text];
    NSRange range =[str rangeOfString: @","];
    if (range.location != NSNotFound) {
        
        [str deleteCharactersInRange: range];
        immutableString = [NSString stringWithString:str];
    }else{
        immutableString =yueLabel.text;
    }
    
    
    float bi;
    if([currStr intValue] == 0 && immutableString.intValue > 0)
    {
        bi = 100;
        attrString1 = [[NSMutableAttributedString alloc] initWithString:@"任务完成比 100%"];
        
    }
    else if ([currStr intValue] == 0 && immutableString.intValue == 0)
    {
        bi = 0;
        attrString1 = [[NSMutableAttributedString alloc] initWithString:@"任务完成比 0.00%"];
        
    }
    else
    {
        
        
        bi = [immutableString floatValue]/([currStr floatValue]*100);
        attrString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"任务完成比 %.2f%%",immutableString.floatValue/((currStr.floatValue)*100)]];
    }
    
    if (bi>=0 && bi <3) {
        
        imageV.image = [UIImage imageNamed:@"环状0.png"];
    }
    
    else if (bi>=3 && bi<8){
        
        imageV.image = [UIImage imageNamed:@"环状5.png"];
    }
    
    else if (bi>=8 && bi<13){
        
        imageV.image = [UIImage imageNamed:@"环状10.png"];
    }
    
    else if (bi>=13 && bi<18){
        
        imageV.image = [UIImage imageNamed:@"环状15.png"];
    }
    
    else if (bi>=18 && bi<23){
        
        imageV.image = [UIImage imageNamed:@"环状20.png"];
    }
    
    else if (bi>=23 && bi<28){
        
        imageV.image = [UIImage imageNamed:@"环状25.png"];
    }
    
    else if (bi>=28 && bi<33){
        
        imageV.image = [UIImage imageNamed:@"环状30.png"];
    }
    
    else if (bi>=33 && bi<38){
        
        imageV.image = [UIImage imageNamed:@"环状35.png"];
    }
    
    else if (bi>=38 && bi<43){
        
        imageV.image = [UIImage imageNamed:@"环状40.png"];
    }
    
    else if (bi>=43 && bi<48){
        
        imageV.image = [UIImage imageNamed:@"环状45.png"];
    }
    
    else if (bi>=48 && bi<53){
        
        imageV.image = [UIImage imageNamed:@"环状50.png"];
    }
    
    else if (bi>=53 && bi<58){
        
        imageV.image = [UIImage imageNamed:@"环状55.png"];
    }
    
    else if (bi>=58 && bi<63){
        
        imageV.image = [UIImage imageNamed:@"环状60.png"];
    }
    
    else if (bi>=63 && bi<68){
        
        imageV.image = [UIImage imageNamed:@"环状65.png"];
    }
    
    else if (bi>=68 && bi<73){
        
        imageV.image = [UIImage imageNamed:@"环状70.png"];
    }
    
    else if (bi>=73 && bi<78){
        
        imageV.image = [UIImage imageNamed:@"环状75.png"];
    }
    
    else if (bi>=78 && bi<83){
        
        imageV.image = [UIImage imageNamed:@"环状80.png"];
    }
    
    else if (bi>=83 && bi<88){
        
        imageV.image = [UIImage imageNamed:@"环状85.png"];
    }
    else if (bi>=88 && bi<93){
        
        imageV.image = [UIImage imageNamed:@"环状90.png"];
    }
    else if (bi>=93 && bi<98){
        
        imageV.image = [UIImage imageNamed:@"环状95.png"];
    }
    else if (bi>=98 ){
        
        imageV.image = [UIImage imageNamed:@"环状100.png"];
    }
    
    UILabel *wenLabel = [[UILabel alloc]initWithFrame:CGRectMake((__MainScreen_Width-56)/2, yueLabel.frame.origin.y+yueLabel.frame.size.height+15, 66, 14)];
    wenLabel.textAlignment =NSTextAlignmentCenter;
    wenLabel.text = @"本月累计";
    wenLabel.font = [UIFont systemFontOfSize:14];
    wenLabel.textColor = [ToolList getColor:@"ffffff"];
    [handImage addSubview:wenLabel];
    
    
    /* 今日净现金 */
    FX_Label *todayM = [[FX_Label alloc]initWithFrame:CGRectMake(8, wenLabel.frame.origin.y+11+wenLabel.frame.size.height, __MainScreen_Width/2-10, 19) andTitleColor:[ToolList getColor:@"FF3333"] andFont:16.0 andMent:NSTextAlignmentLeft andLines:1];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日净现金 %@",[resultDic objectForKey:@"todayAcctAmount"]]];
    //
    //设置字体
    UIFont *baseFont = [UIFont systemFontOfSize:14];
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, 6)];//设置所有的字体
    // 设置颜色
    UIColor *color = [ToolList getColor:@"ffffff"];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0, 6)];
    todayM.attributedText = attrString;
    
    /* 任务完成比 */
    FX_Label *chaE = [[FX_Label alloc]initWithFrame:CGRectMake(__MainScreen_Width/2, todayM.frame.origin.y, __MainScreen_Width/2-10, 19) andTitleColor:[ToolList getColor:@"FF3333"] andFont:16.0 andMent:NSTextAlignmentRight andLines:1];
    chaE.backgroundColor = [UIColor clearColor];
    
    
    //
    //设置字体
    UIFont *baseFont1 = [UIFont systemFontOfSize:14];
    [attrString1 addAttribute:NSFontAttributeName value:baseFont1 range:NSMakeRange(0, 6)];//设置所有的字体
    // 设置颜色
    UIColor *color1 = [ToolList getColor:@"ffffff"];
    [attrString1 addAttribute:NSForegroundColorAttributeName
                        value:color1
                        range:NSMakeRange(0, 6)];
    chaE.attributedText = attrString1;
    //底部
    NSArray * normalArr = @[@"btn_home.png",@"normal-1.png",@"xrw.png",@"kh.png",@"sz.png"];
    NSArray * selectArr = @[@"btn_home_selected.png",@"activation.png",@"xrw_select.png",@"kh_select.png",@"sz_select.png"];
    [super _initTabbarView:@[@"首页",@"日程",@"下任务",@"客户",@"设置"] andNormalImage:normalArr andselected:selectArr andSelectIndex:0];

    
    NSArray *messageArr ;
    //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        _dataArray = @[@"公海客户",@"归属地查询",@"拜访统计"];
        messageArr = @[@"待分配",@"产品到期",@"生产中",@"客户尾款",@"商机分配",@"意向客户",@"部门客户",@"公海客户",@"归属地查询",@"拜访统计",@"案例库"];
        
    }
    else
    {
        _dataArray = @[@"公海客户",@"归属地查询",@"拜访统计",@"员工异动"];
        messageArr = @[@"待分配",@"产品到期",@"生产中",@"客户尾款",@"商机分配",@"意向客户",@"我司客户",@"公海客户",@"归属地查询",@"拜访统计",@"员工异动",@"案例库"];
        
    }
    /* 中间部分操作：释放、到期、生产中、欠款 */
    
    for (int i=0; i<messageArr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+(i%4)*(__MainScreen_Width/4), handImage.frame.size.height+71*(i/4), __MainScreen_Width/4, 71);
        [button setTitle:[messageArr objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[ToolList getColor:@"333333"] forState:UIControlStateNormal];
        button.tag =i;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(touchBt:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i < 5)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, button.frame.size.width, 22)];
            label.textAlignment =NSTextAlignmentCenter;
            switch (i) {
                case 0:
                    label.text =[NSString stringWithFormat:@"%@", [resultDic objectForKey:@"noAssignCustCount"]];
                    break;
                case 1:
                    label.text =[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"dueProductCustCount"]];
                    break;
                case 2:
                    label.text = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"inProductionCustCount"]];
                    break;
                case 3:
                    label.text = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"arearCustCount"]];
                    break;
                case 4:
                    label.text = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"businessOppNum"]];
                    break;
                default:
                    break;
            }
            
            label.font = [UIFont systemFontOfSize:22];
            label.textColor = [ToolList getColor:@"9013FE"];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 1, -28, 0);
            [button addSubview:label];
            
        }
        else
        {
            UIImageView *label = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, button.frame.size.width, 30)];
            label.contentMode = UIViewContentModeScaleAspectFit;
            switch (i) {
                case 5:
                    
                    label.image =[UIImage imageNamed:@"yxkh.png"];
                    break;
                case 6://
                    label.image =[UIImage imageNamed:@"bmkh.png"];
                    break;
                case 7:
                    label.image =[UIImage imageNamed:@"iconJL_0.png"];
                    break;
                case 8:
                    label.image =[UIImage imageNamed:@"iconJL_1.png"];

                    break;
                    
                case 9:
                    label.image =[UIImage imageNamed:@"iconJL_2.png"];
                    
                    break;
                
                case 10:
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1){
                    label.image =[UIImage imageNamed:@"alk.png"];
                }else{
                      label.image =[UIImage imageNamed:@"iconJL_4.png"];
                }
                    break;
                
                case 11:
                label.image =[UIImage imageNamed:@"alk.png"];
                 
                default:
                    break;
            }
            
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 1, -30, 0);
            [button addSubview:label];
        }
        [middleView addSubview:button];
        
        
    }
    
    
    [handImage addSubview:todayM];
    [handImage addSubview:chaE];
    
    //线
    [middleView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 72+handImage.frame.size.height) toPoint:CGPointMake(__MainScreen_Width, 72+handImage.frame.size.height) andWeight:0.1 andColorString:@"999999"]];
    
 [middleView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 142.8+handImage.frame.size.height) toPoint:CGPointMake(__MainScreen_Width, 142.8+handImage.frame.size.height) andWeight:0.1 andColorString:@"999999"]];
    
    [middleView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 213.6+handImage.frame.size.height) toPoint:CGPointMake(__MainScreen_Width, 213.6+handImage.frame.size.height) andWeight:0.1 andColorString:@"999999"]];
    
    middleView.backgroundColor = [UIColor whiteColor];
    /*
     首页表格内容

    for (int i = 0; i < _dataArray.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 128 + handImage.frame.size.height+__MainScreen_Height*0.096*i, __MainScreen_Width,  __MainScreen_Height*0.096);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnCliked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, (btn.frame.size.height-30)/2., 30, 30)];
        
        
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"iconJL_%d.png",i]];
        
        
        [btn addSubview:imageV];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(52, (btn.frame.size.height-18)/2., 150, 18)];
        titleL.text = [_dataArray objectAtIndex:i];
        titleL.font = [UIFont  systemFontOfSize:16];
        titleL.textColor = [ToolList getColor:@"333333"];
        [btn addSubview:titleL];
        if(i!=_dataArray.count-1)
        {
            [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(50, btn.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, btn.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        }
        UIImageView *opV = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-6-12, (btn.frame.size.height-12)/2., 6, 12)];
        opV.image = [UIImage imageNamed:@"btn_open.png"];
        [btn addSubview:opV];
        btn.backgroundColor = [UIColor whiteColor];
        [middleView addSubview:btn];
    }
         */
    middleView.contentSize = CGSizeMake(__MainScreen_Width, 213.6 + handImage.frame.size.height);
    
}
-(void)RightAction:(UIButton *)sender
{
    paiHangViewController *paiHangView = [[paiHangViewController alloc]init];
    [self.navigationController pushViewController:paiHangView animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectedTab:(UIButton *)btn
{
    isSelectAddBtn = !isSelectAddBtn;
    if(btn.tag == 199)
    {
        isSelectAddBtn = NO;
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            addBtn.transform = transform;
            bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        }];
     
    }
    else if (btn.tag == 201)//下任务
    {
        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
       [self xiarenwu];
    }
    
    else if (btn.tag == 200){//日程
        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        [self addSchedule];
    }
    else if (btn.tag == 202){//客户
        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        
        BuMenViewController *buMenVc =[[BuMenViewController alloc] init];
        [self.navigationController pushViewController:buMenVc animated:NO];
    }
    
    else//设置-我的
    {
        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        [self me];
    }
    
}
#pragma mark - 添加
-(void) xiejilu
{
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"经理";
     gh.isShouYe = YES;//从首页跳转，不需要带客户名称，右上角添加客户按钮显示
    [self.navigationController pushViewController:gh animated:NO];
}
#pragma mark - 我
-(void) me
{
    MeViewController *gh = [[MeViewController alloc] init];
    [self.navigationController pushViewController:gh animated:NO];
    
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
