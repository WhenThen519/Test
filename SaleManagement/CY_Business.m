//
//  CY_Business.m
//  SaleManagement
//
//  Created by chaiyuan on 15/11/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "S_ScheduleViewController.h"
#import"New_Gonghai.h"
#import "CY_Business.h"
#import "CY_MSN.h"
#import "GongHaiVC.h"
#import "CY_ShiFangVc.h"
#import "CY_debtVc.h"
#import "CY_producingVc.h"
#import "CY_EndTimeVc.h"
#import "CY_myClientVC.h"
#import "CY_recordVc.h"
#import "CY_OrientationVc.h"
#import "CY_intentVC.h"
#import "CY_moneyVC.h"
#import "XiejiluViewController.h"
#import "CY_addClientVc.h"
#import "MeViewController.h"
#import "CY_tjVC.h"
#import "AddNewScheduleViewController.h"
#import "paiHangViewController.h"
#import "MP_ViewController.h"
#import "webViewController.h"
#import "New_ShouCang.h"


#define BUTTON_TAG 1110;
@interface CY_Business (){
    UIImageView *bgImage;
    bool isSelectAddBtn;
   UIImageView *showImageV;
    UIImage *chosenImage;//名片照片
}

@property (nonatomic,strong)NSArray *messageArr;//中间部分标题

@property (nonatomic,strong)NSDictionary *resultDic;//首页请求数据

@property (nonatomic,strong)NSArray *tadayData;
@property (nonatomic,strong)CIContext *context;
#define IOS7_HeightPlus (IOS7?20:0)

@end

@implementation CY_Business



-(void)BusinessFild:(NSError *)err{
    
}

-(void)BusinessSuccess:(NSMutableDictionary *)dic{
    
    if (dic.count == 0) {
        
        
        return;
    }
    
    if ([[dic objectForKey:@"code"]intValue]==200) {
        
        _resultDic = [dic objectForKey:@"result"];

        [self makeHandView];
        
    }
    
 
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    isSelectAddBtn = NO;
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    addBtn.transform = transform;
    bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
    [FX_UrlRequestManager postByUrlStr:Business_url andPramas:nil andDelegate:self andSuccess:@"BusinessSuccess:" andFaild:@"BusinessFild:" andIsNeedCookies:NO];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    
    _resultDic = [[NSDictionary alloc]init];
    
    _tadayData = [[NSArray alloc]init];
    

    /* 底部导航名称 */
    NSArray *tableArr = @[@"首页",@"日程",@"写记录",@"客户",@"设置"];
    
     /* 首页表格名称 */
    _dataArray = @[@"公海客户",@"归属地查询",@"常用联系人",@"拜访统计",@"附近客户"];
    
     /* 底部导航未点击状态图片 */
   NSArray * normalArr = @[@"btn_home.png",@"normal-1.png",@"xjl.png",@"kh.png",@"sz.png"];
    
     /* 底部导航点击状态图片 */
    NSArray * selectArr = @[@"btn_home_selected.png",@"activation.png",@"xjl.png",@"kh_select.png",@"sz_select.png"];
 
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50)];
    bgImage.image = [UIImage imageNamed:@"口号.png"];
    bgImage.userInteractionEnabled = YES;
    //计算间距
    float btnWight = 47;
    float btnHight = 60;
    float leftPx = 60;
    float btnPointY = __MainScreen_Height-70-btnHight;
    
    float space = (__MainScreen_Width-leftPx*2-btnWight*3)/2.;
    
    //商务
   
        //写记录
        UIButton *xiejiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        xiejiluBtn.frame = CGRectMake(leftPx,btnPointY , btnWight, btnHight);
        [xiejiluBtn addTarget:self action:@selector(goWritView) forControlEvents:UIControlEventTouchUpInside];
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

    [self.view addSubview:bgImage];

    [super _initTabbarView:tableArr andNormalImage:normalArr andselected:selectArr andSelectIndex:0];

    _messageArr = @[@"即将释放",@"产品到期",@"生产中",@"客户尾款",@"我的客户",@"意向客户",@"收藏夹",@"公海客户",@"归属地查询",@"常用联系人",@"拜访统计",@"案例库"];
    
}
#pragma mark - 添加日程
-(void)addSchedule
{
    S_ScheduleViewController *an = [[S_ScheduleViewController alloc] init];
    [self.navigationController  pushViewController:an animated:NO];
}
#pragma mark -- 我
-(void) me
{
   
    MeViewController *gh = [[MeViewController alloc] init];
    [self.navigationController pushViewController:gh animated:NO];
}

-(void)selectedTab:(UIButton *)btn{
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
    else if (btn.tag == 201)
    {
        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
       [self goWritView];
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
        
        CY_myClientVC *ghVC = [[CY_myClientVC alloc]init];
        ghVC.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationController pushViewController:ghVC animated:NO];
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
    [leftB addTarget:self action:@selector(goWritView) forControlEvents:UIControlEventTouchUpInside];
    leftB.titleEdgeInsets = UIEdgeInsetsMake(75, -leftB.titleLabel.bounds.size.width-70, 0, 0);
    [writV addSubview:leftB];
    
    UIButton *rightB = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightB setTitle:@"添加客户" forState:UIControlStateNormal];
      rightB.frame = CGRectMake(__MainScreen_Width*0.83-71, __MainScreen_Height*0.32-25-70, 72, 100);
    [rightB addTarget:self action:@selector(goAddView:) forControlEvents:UIControlEventTouchUpInside];
    rightB.titleLabel.font = [UIFont systemFontOfSize:15];
    if (__MainScreen_Width==320) {
        
        rightB.imageEdgeInsets = UIEdgeInsetsMake(0,rightB.imageView.bounds.size.width,25,-rightB.titleLabel.bounds.size.width);
        rightB.titleEdgeInsets = UIEdgeInsetsMake(75, -rightB.titleLabel.bounds.size.width-10, 0, 0);
        
    }else{
        rightB.imageEdgeInsets = UIEdgeInsetsMake(0,1,25,rightB.titleLabel.bounds.size.width);
         rightB.titleEdgeInsets = UIEdgeInsetsMake(75, -rightB.titleLabel.bounds.size.width-70, 0, 0);
    }
    
    [rightB setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
   
    [rightB setImage:[UIImage imageNamed:@"btn_tjkh_homepage.png"] forState:UIControlStateNormal];
    
//    rightB.backgroundColor = [UIColor yellowColor];
    [writV addSubview:rightB];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, __MainScreen_Height-49, __MainScreen_Width, 49);
    [button setImage:[UIImage imageNamed:@"btn_close_homepage.png"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(cancelImage) forControlEvents:UIControlEventTouchUpInside];
    [subV addSubview:button];
    
}
#pragma mark---进入添加客户页面
-(void)goAddView:(UIButton *)sender{
    
   
    
    CY_addClientVc *ghVC = [[CY_addClientVc alloc]init];
    ghVC.automaticallyAdjustsScrollViewInsets = NO;
    ghVC.isShou = YES;
    [self.navigationController pushViewController:ghVC animated:NO];
}

#pragma mark---进入写记录页面
-(void)goWritView{
  
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"home";
    gh.isShouYe = YES;//从首页跳转，不需要带客户名称，右上角添加客户按钮显示
    [self.navigationController pushViewController:gh animated:NO];
}

-(void)cancelImage{
    
    showImageV.hidden = YES;
}

#pragma mark --- 截屏
- (UIImage *)imageFromView: (UIView *) theView
{
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, TRUE, [[UIScreen mainScreen] scale]);
//    UIGraphicsBeginImageContext(theView.frame.size);
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

/*
 首页点击进入：净现金到账明细
 */
-(void)touchup:(UIButton *)bt{
    
    CY_moneyVC *moneyV = [[CY_moneyVC alloc]init];
    [self.navigationController pushViewController:moneyV animated:NO];
}

/*
 绘制首页
 */
-(void)makeHandView{
    if(xxHand)
    {
        [xxHand removeFromSuperview];
    }

    xxHand = [[handView alloc]initWithTitle:@"销售管理" andTitleColor:[ToolList getColor:@"9794e4"]  andBGColor:[UIColor clearColor] andLeftImage:@"" andRightImage:@"" andLeftTitle:nil andRightTitle:nil andTarget:self];
    [self.view addSubview:xxHand];
    for (UIView *subV in middleView.subviews)
    {
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

    [handImage setBackgroundImage:[UIImage imageNamed:@"bg-homepage.png"] forState:UIControlStateNormal];
    
    [middleView addSubview:handImage];
    middleView.showsVerticalScrollIndicator = NO;
    [handImage addTarget:self action:@selector(touchup:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *mpBt =[UIButton buttonWithType:UIButtonTypeCustom];
    mpBt.frame = CGRectMake(12,iphone_stateBar , 30, 30);
    [mpBt addTarget:self action:@selector(mpBT) forControlEvents:UIControlEventTouchUpInside];
    [mpBt setImage:[UIImage imageNamed:@"btn_QRcode.png"] forState:UIControlStateNormal];
   // [middleView addSubview:mpBt];
    
    UIButton *paihangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    paihangBtn.frame = CGRectMake(__MainScreen_Width-42,iphone_stateBar , 30, 30);
    [paihangBtn addTarget:self action:@selector(paihangBT) forControlEvents:UIControlEventTouchUpInside];
    [paihangBtn setImage:[UIImage imageNamed:@"排行榜入口icon.png"] forState:UIControlStateNormal];
    [middleView addSubview:paihangBtn];

    UIImageView *imageV = [[UIImageView alloc]init];
  
    if (__MainScreen_Height<=568){
        
        imageV.frame =CGRectMake((__MainScreen_Width-225.5)/2, handImage.frame.size.height*0.28, 225.6, 103.2);
    }else{
        
        imageV.frame =CGRectMake((__MainScreen_Width-225.5)/2, handImage.frame.size.height*0.32, 225.6, 103.2);
    }
    
    [handImage addSubview:imageV];
    
    UILabel *monthAcctmountL = [[UILabel alloc]initWithFrame:CGRectMake(0, imageV.frame.origin.y+103.2-19, imageV.frame.origin.x-7, 19)];
    monthAcctmountL.font = [UIFont systemFontOfSize:14];
    monthAcctmountL.text = @"0.0";
    monthAcctmountL.textAlignment = NSTextAlignmentRight;
    monthAcctmountL.backgroundColor = [UIColor clearColor];
    monthAcctmountL.textColor = [ToolList getColor:@"ff33333"];
    [handImage addSubview:monthAcctmountL];
    
    //任务金额
    UILabel *currentMonthGoalL = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x+imageV.frame.size.width+7, monthAcctmountL.frame.origin.y, __MainScreen_Width-imageV.frame.origin.x-imageV.frame.size.width, 19)];
    currentMonthGoalL.font = [UIFont systemFontOfSize:14];
      currentMonthGoalL.backgroundColor = [UIColor clearColor];
    currentMonthGoalL.text = [NSString stringWithFormat:@"%@w",[_resultDic objectForKey:@"currentMonthGoal"]];//
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
    yueLabel.text = [NSString stringWithFormat:@"%@",[_resultDic objectForKey:@"currentMonthDeductAmount"]];
    yueLabel.textAlignment = NSTextAlignmentCenter;
    yueLabel.font = [UIFont systemFontOfSize:24];
    yueLabel.textColor = [ToolList getColor:@"46FB89"];
    [handImage addSubview:yueLabel];
    
    NSString *currStr = [NSString stringWithFormat:@"%@",[_resultDic objectForKey:@"currentMonthGoal"]];
    
    
    NSString *immutableString;
    NSMutableString *str = [NSMutableString stringWithString:yueLabel.text];
    NSRange range =[str rangeOfString: @","];
    if (range.location != NSNotFound) {
        
        [str deleteCharactersInRange: range];
        immutableString = [NSString stringWithString:str];
    }else{
        immutableString =yueLabel.text;
    }
    
    float bi ;
    if([currStr intValue] == 0 && immutableString.intValue > 0)
    {
        bi = 100;
    }
    else if ([currStr intValue] == 0 && immutableString.intValue == 0)
    {
        bi = 0;
    }
    else
    {
        bi = [immutableString floatValue]/([currStr floatValue]*100);
    }
//   int bi = 288889/5000;
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
     [handImage.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(imageV.frame.origin.x+38, yueLabel.frame.origin.y+7+yueLabel.frame.size.height) toPoint:CGPointMake(imageV.frame.origin.x+38+150, yueLabel.frame.origin.y+7+yueLabel.frame.size.height) andWeight:2 andColorString:@"C77CE9"]];
    
    UILabel *wenLabel = [[UILabel alloc]initWithFrame:CGRectMake((__MainScreen_Width-56)/2, yueLabel.frame.origin.y+yueLabel.frame.size.height+15, 66, 14)];
    wenLabel.textAlignment =NSTextAlignmentCenter;
    wenLabel.text = @"本月累计";
    wenLabel.font = [UIFont systemFontOfSize:14];
    wenLabel.textColor = [ToolList getColor:@"ffffff"];
    [handImage addSubview:wenLabel];
   
    /* 今日净现金 */
    FX_Label *todayM = [[FX_Label alloc]initWithFrame:CGRectMake(8, wenLabel.frame.origin.y+11+wenLabel.frame.size.height, __MainScreen_Width/2-10, 19) andTitleColor:[ToolList getColor:@"FF3333"] andFont:16.0 andMent:NSTextAlignmentLeft andLines:1];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日净现金 %@",[_resultDic objectForKey:@"todayDeductAmount"]]];
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
        
    
    /* 晋级差额 */
    FX_Label *chaE = [[FX_Label alloc]initWithFrame:CGRectMake(__MainScreen_Width/2, todayM.frame.origin.y, __MainScreen_Width/2-10, 19) andTitleColor:[ToolList getColor:@"FF3333"] andFont:16.0 andMent:NSTextAlignmentRight andLines:1];
    chaE.backgroundColor = [UIColor clearColor];
    
    
      NSString *SWjobGrade = [[NSUserDefaults standardUserDefaults]objectForKey:@"SWjobGrade"];
    NSString *swStr;
    
    if ([SWjobGrade isEqualToString:@"资深客户顾问"]) {
        
       swStr =[NSString stringWithFormat:@"保级业绩差额 %@",[_resultDic objectForKey:@"promotionShortfall"]];
    }else{
        
        swStr =[NSString stringWithFormat:@"晋级业绩差额 %@",[_resultDic objectForKey:@"promotionShortfall"]];
    }
    
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:swStr];
    //
    //设置字体
    UIFont *baseFont1 = [UIFont systemFontOfSize:14];
    [attrString1 addAttribute:NSFontAttributeName value:baseFont1 range:NSMakeRange(0, 7)];//设置所有的字体
    // 设置颜色
    UIColor *color1 = [ToolList getColor:@"ffffff"];
    [attrString1 addAttribute:NSForegroundColorAttributeName
                       value:color1
                       range:NSMakeRange(0, 7)];
    chaE.attributedText = attrString1;
    
    
    /* 中间部分操作：释放、到期、生产中、欠款 */
    
    for (int i=0; i<_messageArr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+(i%4)*(__MainScreen_Width/4), handImage.frame.size.height+71*(i/4), __MainScreen_Width/4, 71);
        [button setTitle:[_messageArr objectAtIndex:i] forState:UIControlStateNormal];
        
        [button setTitleColor:[ToolList getColor:@"333333"] forState:UIControlStateNormal];
        button.tag =i;
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(touchBt:) forControlEvents:UIControlEventTouchUpInside];
        
       
        if(i < 4)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, button.frame.size.width, 22)];
            label.textAlignment =NSTextAlignmentCenter;
            switch (i) {
                case 0:
                    label.text =[NSString stringWithFormat:@"%@", [_resultDic objectForKey:@"soonReleaseNo"]];
                    break;
                case 1:
                    label.text =[NSString stringWithFormat:@"%@",[_resultDic objectForKey:@"dueProductNo"]];
                    break;
                case 2:
                    label.text = [NSString stringWithFormat:@"%@",[_resultDic objectForKey:@"productCustNo"]];
                    break;
                case 3:
                    label.text = [NSString stringWithFormat:@"%@",[_resultDic objectForKey:@"arearCustNo"]];
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
                case 4:
                    
                    label.image =[UIImage imageNamed:@"bmkh.png"];
                    break;
                case 5:
                    label.image =[UIImage imageNamed:@"yxkh.png"];
                    break;
                
                case 6:
                    label.image =[UIImage imageNamed:@"data_distribution.png"];
                    break;
                case 7:
                    label.image =[UIImage imageNamed:@"icon_0.png"];
                    break;
                case 8:
                    label.image =[UIImage imageNamed:@"icon_1.png"];
                    break;
                case 9:
                    label.image =[UIImage imageNamed:@"icon_2.png"];
                    
                    break;
                case 10:
                    label.image =[UIImage imageNamed:@"icon_3.png"];
                    break;
                case 11:
                label.image =[UIImage imageNamed:@"alk.png"];
                break;
                    
                default:
                    break;
            }
            
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 1, -30, 0);
            [button addSubview:label];
        }
        [middleView addSubview:button];

        
    }
    middleView.backgroundColor = [UIColor whiteColor];

    //线
    [middleView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 72+handImage.frame.size.height) toPoint:CGPointMake(__MainScreen_Width, 72+handImage.frame.size.height) andWeight:0.1 andColorString:@"999999"]];
    
    [middleView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 142.8+handImage.frame.size.height) toPoint:CGPointMake(__MainScreen_Width, 142.8+handImage.frame.size.height) andWeight:0.1 andColorString:@"999999"]];
    
    [middleView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 213.6+handImage.frame.size.height) toPoint:CGPointMake(__MainScreen_Width, 213.6+handImage.frame.size.height) andWeight:0.1 andColorString:@"999999"]];
    
    [handImage addSubview:todayM];
    
    [handImage addSubview:chaE];

  /*
   
 //    首页表格内容
   
    for (int i = 0; i < _dataArray.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 128+handImage.frame.size.height  + i*__MainScreen_Height*0.096, __MainScreen_Width,  __MainScreen_Height*0.096);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnCliked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, (btn.frame.size.height-30)/2., 30, 30)];
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png",i]];
        [btn addSubview:imageV];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(52, (btn.frame.size.height-18)/2., 150, 18)];
        titleL.text = [_dataArray objectAtIndex:i];
        titleL.font = [UIFont  systemFontOfSize:16];
        if(i != 5)
        {
        titleL.textColor = [ToolList getColor:@"333333"];
        }
        else
        {
        titleL.textColor = [ToolList getColor:@"dedede"];
        }
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
    middleView.contentSize = CGSizeMake(__MainScreen_Width, 213.6+handImage.frame.size.height);  
}

#pragma mark - 拍照模块代理
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

    chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
//    chosenImage = [UIImage imageNamed:@"IMG_0153.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1);
    NSInteger lenth =[imageData length]/1024;
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"http://bcr2.intsig.net/BCRService/BCR_VCF2&iexcl;PIN=290BD181296&amp;user=gaopeng@300.cn&amp;pass=MEWN3546L669SKPK&amp;lang=7&amp;size=%ld",lenth];
    
    [FX_UrlRequestManager postByUrlStr:url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:@"vvvv:" andIsNeedCookies:NO andImageArray:chosenImage ];
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)requestSuccess:(NSString *)dic{
    
    NSLog(@"+++++++++");
}

-(void)vvvv:(NSString *)dic{
    
    [self parseVCardString:dic];
}

//解析vcf
-(void)parseVCardString:(NSString*)vcardString
{
    if (vcardString.length != 0) {
//        mpViewController *mpView = [[mpViewController alloc]init];
//        mpView.vcardString =vcardString;
//        [self.navigationController pushViewController:mpView animated:YES];
        //调个后台统计接口
        [FX_UrlRequestManager postByUrlStr:ScanCard_url andPramas:nil andDelegate:self andSuccess:@"countSuccess:" andFaild:nil andIsNeedCookies:NO];
        MP_ViewController *mpView = [[MP_ViewController alloc]init];
        mpView.vcardString =vcardString;
        mpView.photoImage = chosenImage;
        [self.navigationController pushViewController:mpView animated:YES];
    }

}
-(void)countSuccess:(NSDictionary *)dic{
    
    NSLog(@"后台扫名片统计成功！");
}

#pragma mark---扫名片入口
-(void)LeftAction:(UIButton *)sender{

    //拍照
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }

   

}

-(void)paihangBT
{
    paiHangViewController *paiHangView = [[paiHangViewController alloc]init];
    [self.navigationController pushViewController:paiHangView animated:YES];
    
    
}

#pragma mark---排行榜入口
-(void)RightAction:(UIButton *)sender
{
    paiHangViewController *paiHangView = [[paiHangViewController alloc]init];
    [self.navigationController pushViewController:paiHangView animated:NO];
    
}
/*
 表格点击事项
 */
-(void)btnCliked:(UIButton *)sender{
    
    switch (sender.tag) {
            //公海客户
        case 0:
        {
//            if ([self respondsToSelector:@selector(traitCollection)]) {
//                if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
//                    
//                    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
//                        
//                        
//                    }
//                }
//            }
            
            New_Gonghai *ghVC = [[New_Gonghai alloc]init];
            ghVC.isS = YES;
            [self.navigationController pushViewController:ghVC animated:NO];
       
        }
            break;
          //客户归属地查询
        case 1:
        {
            
//            ScreenViewController *orientationV=[[ScreenViewController alloc]init];
            CY_OrientationVc *orientationV = [[CY_OrientationVc alloc]init];
            orientationV.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:orientationV animated:NO];
            
            
     
         
       
        }
            break;
            //附近客户
        case 2:
        {
//            [ToolList showRequestFaileMessageLittleTime:@"模块正在研发中..."];

            CY_MSN *msn = [[CY_MSN alloc]init];
            msn.automaticallyAdjustsScrollViewInsets = NO;
            //            msn.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:msn animated:NO];
        }
            break;
          //工作统计
        case 3:
        {
            CY_tjVC *tjV = [[CY_tjVC alloc]init];
            tjV.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:tjV animated:NO];
        }
            break;
           //我的日程
        case 4:
        {
            S_ScheduleViewController *ghVC = [[S_ScheduleViewController alloc]init];
            [self.navigationController pushViewController:ghVC animated:NO];
            
          
            
        }
            break;
            
        case 5:
        {

            [ToolList showRequestFaileMessageLittleTime:@"模块正在研发中..."];
          

            
        }
            break;
            
      
            
        default:
            break;
    }
    
}

-(void)touchBt:(UIButton *)bt{
    
    NSInteger TAG =bt.tag-BUTTON_TAG;
    
    switch (bt.tag) {
            //即将释放
        case 0:
        {
            CY_ShiFangVc *releseVc = [[CY_ShiFangVc alloc]init];
            releseVc.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:releseVc animated:NO];
        }
            break;
            //产品到期
        case 1:
        {
            CY_EndTimeVc *producingVc = [[CY_EndTimeVc alloc]init];
            producingVc.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:producingVc animated:NO];
        }
            break;
           //生产中
        case 2:{
            CY_producingVc *producingVc = [[CY_producingVc alloc]init];
            //producingVc.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:producingVc animated:NO];
            
        }
            break;
            //客户尾款
        case 3:
        {
            CY_debtVc *debtVc = [[CY_debtVc alloc]init];
            debtVc.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:debtVc animated:NO];
            
        }
            break;
        //我的客户
        case 4:
        {
            CY_myClientVC *ghVC = [[CY_myClientVC alloc]init];
            ghVC.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:ghVC animated:NO];
            
        }
        break;
            //意向客户
        case 5:
        {
            CY_intentVC *ghVC = [[CY_intentVC alloc]init];
                        ghVC.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:ghVC animated:NO];
            
        }
            break;
        
           //收藏夹
        case 6:
        {
            New_ShouCang *ghVC = [[New_ShouCang alloc]init];
            [self.navigationController pushViewController:ghVC animated:NO];
            
        }
            break;
            
            //公海客户
        case 7:
        {
            New_Gonghai *ghVC = [[New_Gonghai alloc]init];
            ghVC.isS = YES;
            [self.navigationController pushViewController:ghVC animated:NO];
            
        }
            break;
            
            //客户归属地查询
        case 8:
        {
            CY_OrientationVc *orientationV = [[CY_OrientationVc alloc]init];
            orientationV.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:orientationV animated:NO];
            
        }
            break;
            
            //常用客户联系人
        case 9:
        {
            CY_MSN *msn = [[CY_MSN alloc]init];
            msn.automaticallyAdjustsScrollViewInsets = NO;
            //            msn.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:msn animated:NO];
            
        }
            break;
            
            //拜访统计
        case 10:
        {
            CY_tjVC *tjV = [[CY_tjVC alloc]init];
            tjV.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:tjV animated:NO];
            
        }
            break;
            
        //案例库
        case 11:
        {
            webViewController *debtVc = [[webViewController alloc]init];
            debtVc.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:debtVc animated:NO];
            
        }
            break;
        
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
