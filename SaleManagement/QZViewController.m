//
//  QZViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 16/7/13.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "QZViewController.h"
#import "GetAreaXJViewController.h"
#import "paiHangViewController.h"
#import "CY_OrientationVc.h"
#import "MeViewController.h"


#define IOS7_HeightPlus (IOS7?20:0)
@interface QZViewController ()
{
    
    UIImageView *bgImage;
}

@property (nonatomic,strong)NSDictionary *mobileAreaMDic;//首页请求数据
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation QZViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    isSelectAddBtn = NO;
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    addBtn.transform = transform;
    bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
    
    [FX_UrlRequestManager postByUrlStr:mobileAreaM_url andPramas:nil andDelegate:self andSuccess:@"mobileAreaMSuccess:" andFaild:@"mobileAreaMFild:" andIsNeedCookies:NO];
}

-(void)mobileAreaMSuccess:(NSMutableDictionary *)dic{
    
    if (dic.count == 0) {
        
        
        return;
    }
    
    if ([[dic objectForKey:@"code"]intValue]==200) {
        
        _mobileAreaMDic = [dic objectForKey:@"result"];
        
        [self makemobileAreaMView];
        
    }
    
}

-(void)makemobileAreaMView{
    
    if(xxHand)
    {
        [xxHand removeFromSuperview];
    }
    
    xxHand = [[handView alloc]initWithTitle:@"销售管理" andTitleColor:[ToolList getColor:@"9794e4"]  andBGColor:[UIColor clearColor] andLeftImage:nil andRightImage:@"" andLeftTitle:nil andRightTitle:nil andTarget:self];
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
    
    UIButton *paihangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    paihangBtn.frame = CGRectMake(__MainScreen_Width-42,IOS7_HeightPlus , 30, 30);
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
    currentMonthGoalL.text = [NSString stringWithFormat:@"%@w",[_mobileAreaMDic objectForKey:@"currentMonthGoal"]];//
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
    yueLabel.text = [NSString stringWithFormat:@"%@",[_mobileAreaMDic objectForKey:@"monthAcctAmount"]];
    yueLabel.textAlignment = NSTextAlignmentCenter;
    yueLabel.font = [UIFont systemFontOfSize:24];
    yueLabel.textColor = [ToolList getColor:@"46FB89"];
    [handImage addSubview:yueLabel];
    
    NSString *currStr = [NSString stringWithFormat:@"%@",[_mobileAreaMDic objectForKey:@"currentMonthGoal"]];
    
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
    NSString *swStr;
    if([currStr intValue] == 0 && immutableString.intValue > 0)
    {
        bi = 100;
        swStr= @"任务完成比 100%";
    }
    else if ([currStr intValue] == 0 && immutableString.intValue == 0)
    {
        bi = 0;
          swStr= @"任务完成比 0.00%";
    }
    else
    {
        bi = [immutableString floatValue]/([currStr floatValue]*100);
          swStr= [NSString stringWithFormat:@"任务完成比 %.2f%%",immutableString.floatValue/((currStr.floatValue)*100)];
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
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今日净现金 %@",[_mobileAreaMDic objectForKey:@"todayAcctAmount"]]];
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
    
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:swStr];
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
    
    [handImage addSubview:todayM];
    
    [handImage addSubview:chaE];
    
    /*
     首页表格内容
     */
    for (int i = 0; i < _dataArray.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, handImage.frame.size.height + 0 + i*__MainScreen_Height*0.096, __MainScreen_Width,  __MainScreen_Height*0.096);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnCliked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, (btn.frame.size.height-30)/2., 30, 30)];
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d.png",i]];
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
    
    middleView.contentSize = CGSizeMake(__MainScreen_Width,handImage.frame.size.height+0+_dataArray.count*__MainScreen_Height*0.096);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _mobileAreaMDic = [[NSDictionary alloc]init];
    
    /* 首页表格名称 */
    _dataArray = @[@"客户市场调整"];
    
    /* 底部导航名称 */
    NSArray *tableArr = @[@"首页",@"添加",@"我"];
    /* 底部导航未点击状态图片 */
    NSArray * normalArr = @[@"btn_home.png",@"首页置灰icon.png",@"btn_me.png"];
    /* 底部导航点击状态图片 */
    NSArray * selectArr = @[@"btn_home_selected.png",@"首页置灰icon.png",@"btn_me_selected.png"];
    
     [super _initTabbarView:tableArr andNormalImage:normalArr andselected:selectArr andSelectIndex:0];
    
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50)];
    bgImage.image = [UIImage imageNamed:@"口号.png"];
    bgImage.userInteractionEnabled = YES;

    [self.view addSubview:bgImage];
    
}

#pragma mark -- 我
-(void) me
{
    MeViewController *gh = [[MeViewController alloc] init];
    [self.navigationController pushViewController:gh animated:NO];
}

-(void)selectedTab:(UIButton *)btn{
    
    //    isSelectAddBtn = !isSelectAddBtn;
    if(btn.tag == 199)
    {
        //        isSelectAddBtn = NO;
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeRotation(0);
            addBtn.transform = transform;
            bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        }];
    }
    else if (btn.tag == 200)
    {
        //       [btn setUserInteractionEnabled:NO];
    }
    else
    {
        //        isSelectAddBtn = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        addBtn.transform = transform;
        bgImage.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height-50);
        [self me];
    }
    
    
}



#pragma mark---表格点击事件
-(void)btnCliked:(UIButton *)sender{
    
    switch (sender.tag) {
        case 0:
        {
            //客户市场调整
            
            CY_OrientationVc *orientationV = [[CY_OrientationVc alloc]init];
            orientationV.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:orientationV animated:NO];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark---排行榜进入接口

-(void)paihangBT{
//    paiHangViewController *paih =[[paiHangViewController alloc]init];
//    [self.navigationController pushViewController:paih animated:NO];
    
}
-(void)RightAction:(UIButton *)sender
{
    paiHangViewController *paiHangView = [[paiHangViewController alloc]init];
    [self.navigationController pushViewController:paiHangView animated:NO];
    
}

#pragma mark---净现金到账

-(void)touchup:(UIButton *)sender{
    
    GetAreaXJViewController *getArea = [[GetAreaXJViewController alloc]init];
    [self.navigationController pushViewController:getArea animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
