 //
//  paiHangViewController.m
//  SaleManagement
//
//  Created by known on 16/6/13.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "paiHangViewController.h"
#import "CY_comVc.h"
#import "TaskThanViewController.h"
#import "NationalRankingController.h"
#import "areaViewController.h"
#import "buMenPMViewController.h"
#import "QZ_comVc.h"

#define IOS7_HeightPlus (IOS7?20:0)

@interface paiHangViewController ()
{
    UIView *JFView;
    UILabel * danYueJFLabel;
    UILabel * zongJFLabel;
    UILabel * historyJFLabel;

}
@end

@implementation paiHangViewController
-(void)makeHandView{
    
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
     middleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    middleView.showsVerticalScrollIndicator = NO;
    // middleView.backgroundColor = [ToolList getColor:@"f1f4f4"];
    //    middleView.alwaysBounceVertical = YES;
    //    middleView.delegate = self;
    [self.view addSubview:middleView];
    UIView *bgview =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width,  IOS7_Height)];
    bgview.backgroundColor =[ToolList getColor:@"FF576B"];
    [middleView addSubview:bgview];
    
    UIButton * handImage = [UIButton buttonWithType:UIButtonTypeCustom];
    if (__MainScreen_Height<=568) {
        
        handImage.frame =CGRectMake(0, IOS7_Height, __MainScreen_Width, 150);
    }
    else{
        handImage.frame =CGRectMake(0, IOS7_Height, __MainScreen_Width, 150);
    }
    [handImage setBackgroundImage:[UIImage imageNamed:@"首页通用大图.png"] forState:UIControlStateNormal];
    [middleView addSubview:handImage];
    
    UILabel *colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, handImage.frame.origin.y+150, __MainScreen_Width, 110)];
    colorLabel.backgroundColor = [ToolList getColor:@"FFBDC5"];
    [middleView addSubview:colorLabel];
    
    //返回按钮
    UIButton *paihangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    paihangBtn.frame = CGRectMake(0, 2+IOS7_HeightPlus, 40, 40);
    [paihangBtn addTarget:self action:@selector(backBT) forControlEvents:UIControlEventTouchUpInside];
    [paihangBtn setImage:[UIImage imageNamed:@"Back Chevron.png"] forState:UIControlStateNormal];
    [middleView addSubview:paihangBtn];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((__MainScreen_Width-76)/2, 29, 76, 26)];
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.text = @"排行榜";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //        titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [ToolList getColor:@"#FFFFFF"];
    [middleView addSubview:titleLabel];
    UIButton * myPaiM = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    //总监
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
        myPaiM.frame =CGRectMake(64, handImage.frame.origin.y+150+60, (__MainScreen_Width-128),33);
        
    }
    else
    {
       myPaiM.frame =CGRectMake(64, handImage.frame.origin.y+150, (__MainScreen_Width-128),33);
    }

    [myPaiM setBackgroundImage:[UIImage imageNamed:@"商务我的排名框架.png"] forState:UIControlStateNormal];
    myPaiM.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);
    [middleView addSubview:myPaiM];
    UILabel *title= [[UILabel alloc]initWithFrame:CGRectMake((__MainScreen_Width-68)/2, myPaiM.frame.origin.y+7.9, 68, 16.1)];
    title.font = [UIFont systemFontOfSize:15.9];
    //总监
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 ||[[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
    title.text = @"我的排名";
    }
    else
    {
        title.text = @"CEO积分";
    }
    title.textAlignment = NSTextAlignmentCenter;
    //        titleLabel.backgroundColor = [UIColor clearColor];
    title.textColor = [ToolList getColor:@"666666"];
    [middleView addSubview:title];
    UIView *paihangview =[[ UIView alloc]init];
    //总监
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 ||[[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
        paihangview.frame = CGRectMake(0, myPaiM.frame.origin.y+32, __MainScreen_Width,  110);
        
    }
    else
    {
        paihangview.frame = CGRectMake(0, myPaiM.frame.origin.y+32, __MainScreen_Width,  190+50);
    }
    paihangview.backgroundColor =[ToolList getColor:@"ffffff"];
    [middleView addSubview:paihangview];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:paihangview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = paihangview.bounds;
    maskLayer.path = maskPath.CGPath;
    paihangview.layer.mask = maskLayer;
    NSArray * messageArr=[[NSArray alloc]initWithObjects:@"部门内排名",@"分司内排名",@"区域内排名",@"全国内排名", nil];
    NSArray * jingLiArr=[[NSArray alloc]initWithObjects:@"分司内排名",@"区域内排名", nil];
    //积分
    JFView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 50)];
    JFView.backgroundColor = [UIColor clearColor];
    //单月

    UILabel *danL = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, __MainScreen_Width/3, JFView.frame.size.height/2)];
    danL.textAlignment = NSTextAlignmentCenter;
    danL.textColor = [ToolList getColor:@"7d7d7d"];
    danL.font = [UIFont systemFontOfSize:13];
    danL.text = @"单月积分";
    [JFView addSubview:danL];
    danYueJFLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, JFView.frame.size.height/2, __MainScreen_Width/3, JFView.frame.size.height/2)];
    danYueJFLabel.textAlignment = NSTextAlignmentCenter;
    danYueJFLabel.textColor = [ToolList getColor:@"7d7d7d"];
    danYueJFLabel.font = [UIFont systemFontOfSize:13];
    [JFView addSubview:danYueJFLabel];
    //总的积分
    zongJFLabel = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width/3+40, 0, __MainScreen_Width/3, JFView.frame.size.height)];
    zongJFLabel.textColor = [ToolList getColor:@"ff9d00"];
    zongJFLabel.font = [UIFont systemFontOfSize:22];
    [JFView addSubview:zongJFLabel];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(zongJFLabel.frame.origin.x-24, (JFView.frame.size.height-16)/2, 16, 16)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = [UIImage imageNamed:@"zong2.png"];
    [JFView addSubview:imageV];
    //历史积分
    UILabel *zongL = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width/3*2, 5, __MainScreen_Width/3, JFView.frame.size.height/2)];
    zongL.textAlignment = NSTextAlignmentCenter;
    zongL.textColor = [ToolList getColor:@"7d7d7d"];
    zongL.font = [UIFont systemFontOfSize:13];
    zongL.text = @"历史累计";
    [JFView addSubview:zongL];
    historyJFLabel = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width/3*2, JFView.frame.size.height/2, __MainScreen_Width/3, JFView.frame.size.height/2)];
    historyJFLabel.textAlignment = NSTextAlignmentCenter;
    historyJFLabel.textColor = [ToolList getColor:@"7d7d7d"];
    historyJFLabel.font = [UIFont systemFontOfSize:13];
    [JFView addSubview:historyJFLabel];
    
    UIButton * xuxian1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    xuxian1.frame =CGRectMake(16, JFView.frame.size.height-2,     (__MainScreen_Width-32),2);
    [xuxian1 setBackgroundImage:[UIImage imageNamed:@"虚线.png"] forState:UIControlStateNormal];
    [JFView addSubview:xuxian1];
    //总监          3区总
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
 
        count ++ ;
        UIButton * xuxian = [UIButton buttonWithType:UIButtonTypeCustom];
        
        xuxian.frame =CGRectMake(16, paihangview.frame.origin.y+86, (__MainScreen_Width-32),2);
        [xuxian setBackgroundImage:[UIImage imageNamed:@"虚线.png"] forState:UIControlStateNormal];
        [middleView addSubview:xuxian];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, paihangview.frame.origin.y, __MainScreen_Width, 57.3);
        
        [button setTitleColor:[ToolList getColor:@"4A4A4A"] forState:UIControlStateNormal];
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2)
        {
            [button setTitle:@"区域内排名" forState:UIControlStateNormal];

        }
        else
        {
            [button setTitle:@"全国内排名" forState:UIControlStateNormal];

        }
//        [button setTitle:@"区域内排名" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _zjlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, button.frame.size.width, 22)];
        _zjlabel.textAlignment =NSTextAlignmentCenter;
        _zjlabel.font = [UIFont systemFontOfSize:22];
        _zjlabel.textColor = [ToolList getColor:@"9013FE"];
        
        [middleView addSubview:button];
        [button addSubview:_zjlabel];

        
    }

            //经理
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        [paihangview addSubview:JFView];
     
        for (int i=0; i<2; i++) {
            count++;
            UIButton * xuxian = [UIButton buttonWithType:UIButtonTypeCustom];
            
            xuxian.frame =CGRectMake(16, paihangview.frame.origin.y+86*(i+1)+50, (__MainScreen_Width-32),2);
            [xuxian setBackgroundImage:[UIImage imageNamed:@"虚线.png"] forState:UIControlStateNormal];
            [middleView addSubview:xuxian];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, paihangview.frame.origin.y+50+(57.3+29+2)*i, __MainScreen_Width, 57.3);
        
        [button setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        
        [button setTitle:[jingLiArr objectAtIndex:count-1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        

            UILabel *jllabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, button.frame.size.width, 22)];
        jllabel.textAlignment =NSTextAlignmentCenter;
//        label.text =[jlArr objectAtIndex:i];
        jllabel.font = [UIFont systemFontOfSize:22];
        jllabel.textColor = [ToolList getColor:@"9013FE"];
            jllabel.tag = i+1000;
            
        [middleView addSubview:button];
        [button addSubview:jllabel];
            [jlArr addObject:jllabel];
        }
    }

    //商务
   else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0)
    {
        
        [paihangview addSubview:JFView];
    
        for (int i=0; i<2; i++) {
            UIButton * xuxian = [UIButton buttonWithType:UIButtonTypeCustom];
            
            xuxian.frame =CGRectMake(16, paihangview.frame.origin.y+86*(i+1)+50, (__MainScreen_Width-32),2);
            [xuxian setBackgroundImage:[UIImage imageNamed:@"虚线.png"] forState:UIControlStateNormal];
            [middleView addSubview:xuxian];
            
            for (int j=0; j<2; j++) {
                
                count ++ ;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0+(j+1)*70+(__MainScreen_Width-80-80-75)/2*j, paihangview.frame.origin.y+(57.3+29+2)*i+50, 80, 57.3);
                
                [button setTitleColor:[ToolList getColor:@"333333"] forState:UIControlStateNormal];
                
                [button setTitle:[messageArr objectAtIndex:count-1] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:13.9];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, button.frame.size.width, 22)];
                label.textAlignment =NSTextAlignmentCenter;
                switch (i) {
                                     }
//                label.text =[NSString stringWithFormat:@"%d",count];
                label.font = [UIFont systemFontOfSize:21.9];
                label.textColor = [ToolList getColor:@"9013FE"];
                
                [middleView addSubview:button];
                [button addSubview:label];
                [swArr addObject:label];
            }
        }
 
        
    }
    
    for (int i = 0; i<5; i++) {
        
        
        UIButton * xuxian = [UIButton buttonWithType:UIButtonTypeCustom];
        
        xuxian.frame =CGRectMake(10+((__MainScreen_Width-35)/4+5)*(i%4), paihangview.frame.origin.y+ paihangview.frame.size.height+10+(5+(__MainScreen_Width-35)/4)*(i/4), (__MainScreen_Width-35)/4,(__MainScreen_Width-35)/4);
        switch (i) {
                            case 0:
                [xuxian setBackgroundImage:[UIImage imageNamed:@"全国排名.png"] forState:UIControlStateNormal];
                                break;
                            case 1:
                [xuxian setBackgroundImage:[UIImage imageNamed:@"区域排名.png"] forState:UIControlStateNormal];
                                break;
                            case 2:
                [xuxian setBackgroundImage:[UIImage imageNamed:@"分司排名.png"] forState:UIControlStateNormal];
                                break;
                            case 3:
                [xuxian setBackgroundImage:[UIImage imageNamed:@"部门排名.png"] forState:UIControlStateNormal];
                                break;
            case 4:
                [xuxian setBackgroundImage:[UIImage imageNamed:@"one.png"] forState:UIControlStateNormal];
                break;
                            default:
                                break;
        }
        xuxian.tag = i;
        [xuxian addTarget:self action:@selector(touchBt:) forControlEvents:UIControlEventTouchUpInside];

        [middleView addSubview:xuxian];
        middleView.contentSize = CGSizeMake(__MainScreen_Width, xuxian.frame.origin.y+(__MainScreen_Width-35)/4+30);

    }
    //总监      3区总
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
    {
      
        
        for (int i =0; i<2; i++) {
            
            UIButton * ceOBT = [UIButton buttonWithType:UIButtonTypeCustom];
            ceOBT.tag = 4+i;
            [ceOBT addTarget:self action:@selector(touchBt:) forControlEvents:UIControlEventTouchUpInside];
            ceOBT.frame =CGRectMake(10+((__MainScreen_Width-35)/4+5)*i,paihangview.frame.origin.y+paihangview.frame.size.height+10+5+(__MainScreen_Width-35)/4, (__MainScreen_Width-35)/4,(__MainScreen_Width-35)/4);
            switch (i) {
                case 0:
                    [ceOBT setBackgroundImage:[UIImage imageNamed:@"任务完成比.png"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [ceOBT setBackgroundImage:[UIImage imageNamed:@"one.png"] forState:UIControlStateNormal];
                    break;
                              default:
                    break;
            }

            [middleView addSubview:ceOBT];
            middleView.contentSize = CGSizeMake(__MainScreen_Width, ceOBT.frame.origin.y+(__MainScreen_Width-35)/4+30);
            
        }
        
    }
    else
    {
//        UIButton * ceOBT = [UIButton buttonWithType:UIButtonTypeCustom];
//        ceOBT.tag = 4;
//        [ceOBT addTarget:self action:@selector(touchBt:) forControlEvents:UIControlEventTouchUpInside];
//        ceOBT.frame =CGRectMake(10, paihangview.frame.origin.y+paihangview.frame.size.height+10+5+(__MainScreen_Width-35)/4, (__MainScreen_Width-35)/4,(__MainScreen_Width-35)/4);
//        [ceOBT setBackgroundImage:[UIImage imageNamed:@"CE.O排名.png"] forState:UIControlStateNormal];
//        [middleView addSubview:ceOBT];
   
        
    }
   huadong =[[ UIView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 30)];
    huadong.backgroundColor =[ToolList getColor:@"FFFFFF"];
    huadong.alpha = 0.8;
    
//    _abstractScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,__MainScreen_Width,30)];
//    
//    [huadong addSubview:_abstractScrollview];

    _huadongLabel =[[UILabel alloc]initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, 30)];
    _huadongLabel.font = [UIFont systemFontOfSize:14];
    _huadongLabel.textColor =[ToolList getColor:@"4A4A4A"];
//    _huadongLabel.text = @"测试效果 测试效果 测试效果 ";
    [huadong addSubview:_huadongLabel];
    
//    _startIndex = 0;
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==1)
    {
        UILabel *zongL1 = [[UILabel alloc] initWithFrame:CGRectMake((__MainScreen_Width-65)/2., 285, 65, 20)];
        zongL1.textAlignment = NSTextAlignmentCenter;
        zongL1.textColor = [ToolList getColor:@"7d7d7d"];
        zongL1.font = [UIFont systemFontOfSize:12];
        zongL1.text = @"我的排名";
        zongL1.backgroundColor = [UIColor whiteColor];
        //[middleView  addSubview:zongL1];
    }
}
-(void)leftToRight:(NSArray *)arr
{
    
    CGPoint point = _abstractScrollview.contentOffset;
    CGPoint point1 = CGPointMake(0, 0);
    UILabel *lastLabel = (UILabel *)[_abstractScrollview viewWithTag:(100 + arr.count)];

    if (point.x >= lastLabel.frame.origin.x) {
        _startIndex = 0;
        _abstractScrollview.contentOffset = point1;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];

    [UIView setAnimationDuration:4];

//    _huadongLabel.frame = CGRectMake(-__MainScreen_Width, 0, __MainScreen_Width, 30);
    
    //设置代理 指定让谁去调用动画结束方法
    [UIView setAnimationDelegate:self];
    
    //设置动画将要开始的方法
//    [UIView setAnimationWillStartSelector:@selector(animationStart)];
    
    //设置动画的结束方法
//    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    UILabel *currentView = (UILabel *)[_abstractScrollview viewWithTag:(100  + _startIndex + 1)];

    CGPoint pointmiddle = CGPointMake(currentView.frame.origin.x, 0);

    _startIndex ++;
    _abstractScrollview.contentOffset = pointmiddle;

    [UIView commitAnimations];
}

-(void)makeUI:(NSArray *)arr
{
    _startIndex = 0;
    
    _abstractScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,__MainScreen_Width,30)];
    
    [huadong addSubview:_abstractScrollview];
        _abstractScrollview.contentSize = CGSizeMake((arr.count + 1) * __MainScreen_Width, 30);
    
        for (int i = 0; i < [arr count]; i++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(__MainScreen_Width * (i+1), 0, __MainScreen_Width, 30)];
            label.text = arr[i];
            label.textColor = [ToolList getColor:@"4A4A4A"];
            label.font = [UIFont systemFontOfSize:14];
            label.tag = 100 + i;
            [_abstractScrollview addSubview:label];
            
            if (i == [arr count]-1) {
                UILabel *labelLast=[[UILabel alloc]initWithFrame:CGRectMake( __MainScreen_Width* (i + 2), 0, __MainScreen_Width, 30)];
                labelLast.text = arr[0];
                labelLast.textColor = [ToolList getColor:@"4A4A4A"];
                labelLast.font = [UIFont systemFontOfSize:14];
                labelLast.tag = 100 + i + 1;
                [_abstractScrollview addSubview:labelLast];
            }
        }
    
    
    _abstractScrollview.contentOffset=CGPointMake(0, 0);
    [self leftToRight:arr];

}

-(void)touchBt:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
          //全国排行
            NationalRankingController *gh = [[NationalRankingController alloc] init];
            [self.navigationController pushViewController:gh animated:NO];
        }
            break;
            
        case 1:
        {
           //区域排行
            
            areaViewController *areaVc = [[areaViewController alloc]init];
            [self.navigationController pushViewController:areaVc animated:NO];
        }
            break;
            
        case 2:{
           //分司排行
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3) {
                QZ_comVc *comV = [[QZ_comVc alloc]init];
                [self.navigationController pushViewController:comV animated:NO];

            }
            else
            {
                CY_comVc *cy = [[CY_comVc alloc]init];
                [self.navigationController pushViewController:cy animated:NO];
            }
            
        }
            break;
            
        case 3:
        {
            //部门内排行
            buMenPMViewController *buMenP = [[buMenPMViewController alloc]init];
            [self.navigationController pushViewController:buMenP animated:NO];

            
        }
            break;
        case 4:
        {
            //总监  区总    任务完成比
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==2 || [[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3)
            {
                TaskThanViewController *taskThanVC =[[ TaskThanViewController alloc]init];
                [self.navigationController pushViewController:taskThanVC animated:NO];
                
            }
            else
            {
                CEOController*taskThanVC =[[ CEOController alloc]init];
                [self.navigationController pushViewController:taskThanVC animated:NO];
            }

            
        }
            break;
        case 5:
        {
            CEOController*taskThanVC =[[ CEOController alloc]init];
            [self.navigationController pushViewController:taskThanVC animated:NO];        }
            break;
            
        default:
            break;
    }

}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    jlArr = [[NSMutableArray alloc]init];
    swArr = [[NSMutableArray alloc]init];

    count =0;
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
            //商务
        case 0:
            
            [FX_UrlRequestManager postByUrlStr:SWpaihangbang_url andPramas:nil andDelegate:self andSuccess:@"requestSWSuccess:" andFaild:nil andIsNeedCookies:NO];
            break;
            //经理
        case 1:
            [FX_UrlRequestManager postByUrlStr:JLpaihangbang_url andPramas:nil andDelegate:self andSuccess:@"requestJLSuccess:" andFaild:nil andIsNeedCookies:NO];
            
            break;
            //总监
        case 2:
            [FX_UrlRequestManager postByUrlStr:ZJpaihangbang_url andPramas:nil andDelegate:self andSuccess:@"requestPaiHangSuccess:" andFaild:nil andIsNeedCookies:NO];
            
            break;
            //区总
        case 3:
            [FX_UrlRequestManager postByUrlStr:QZpaihangbang_url andPramas:nil andDelegate:self andSuccess:@"QZrequestPaiHangSuccess:" andFaild:nil andIsNeedCookies:NO];
            
            break;
            
            
        default:
            break;
    }
    [self makeHandView];
  
}
//区总请求成功
-(void)QZrequestPaiHangSuccess:(NSDictionary *)dic
{
    
//    areaRank=[NSString stringWithFormat:@"%@",[dic objectForKey:@"areaRank"]] ;
    NSString *str=   [ToolList changeNull:[dic objectForKey:@"areaRank"]];
    areaRank=[NSString stringWithFormat:@"%@",str] ;

    _zjlabel.text =areaRank;
    
    NSArray *arr = [dic objectForKey:@"result"];
    NSString *string = [arr componentsJoinedByString:@"      "];
    _huadongLabel.text = string;
       
    if (_huadongLabel.text.length <= 0 ) {
        
        [huadong removeFromSuperview];
    }
    else
    {
        [middleView addSubview:huadong];
        
        if (_timer == nil) {
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(kaishi) userInfo:nil repeats:YES];
        }
    }
 
    
}
//总监请求成功
-(void)requestPaiHangSuccess:(NSDictionary *)dic
{
    NSString *str=   [ToolList changeNull:[dic objectForKey:@"areaRank"]];

    areaRank=[NSString stringWithFormat:@"%@",str] ;
    _zjlabel.text =areaRank;
    
    NSArray *arr = [dic objectForKey:@"result"];
    NSString *string = [arr componentsJoinedByString:@"      "];
    _huadongLabel.text = string;
//    CGSize size = [_huadongLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(9999, 30) lineBreakMode:NSLineBreakByCharWrapping];
//    NSLog(@"%f",size.width);

    if (_huadongLabel.text.length <= 0 ) {
        
        [huadong removeFromSuperview];
    }
    else
    {
        [middleView addSubview:huadong];

        if (_timer == nil) {
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(kaishi) userInfo:nil repeats:YES];
        }
    }

}
//经理请求成功
-(void)requestJLSuccess:(NSDictionary *)dic
{
    NSString *str=   [ToolList changeNull:[dic objectForKey:@"subcompanyRank"]];
    countryRank=[NSString stringWithFormat:@"%@",str] ;
    
//    countryRank= [NSString stringWithFormat:@"%@",[dic objectForKey:@"subcompanyRank"]] ;
    NSString *str1=   [ToolList changeNull:[dic objectForKey:@"areaRank"]];
    areaRank=[NSString stringWithFormat:@"%@",str1] ;

//    areaRank= [NSString stringWithFormat:@"%@",[dic objectForKey:@"areaRank"]] ;
    UILabel * la= [jlArr objectAtIndex:0];
    la.text = countryRank;
    UILabel * la1= [jlArr objectAtIndex:1];
    la1.text = areaRank;
   
    NSArray *arr = [dic objectForKey:@"result"];
    NSString *string = [arr componentsJoinedByString:@"      "];
    _huadongLabel.text = string;
    danYueJFLabel.text =[NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"thisIntegral"]]] ;
    zongJFLabel.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"toalIntegral"]]];
    historyJFLabel.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"agoIntegral"]]];
    if (arr.count <= 0 ) {
        
        [huadong removeFromSuperview];
    }
    else
    {
        [middleView addSubview:huadong];

        if (_timer == nil) {
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(kaishi) userInfo:nil repeats:YES];
        }
    }

                   
                   
                   }
//商务请求成功
-(void)requestSWSuccess:(NSDictionary *)dic
{
    
//    areaRank= [NSString stringWithFormat:@"%@",[dic objectForKey:@"areaRank"]] ;
//    countryRank= [NSString stringWithFormat:@"%@",[dic objectForKey:@"countryRank"]] ;
//    deptRank= [NSString stringWithFormat:@"%@",[dic objectForKey:@"deptRank"]] ;
//    subRank= [NSString stringWithFormat:@"%@",[dic objectForKey:@"subRank"]] ;
    danYueJFLabel.text =[NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"thisIntegral"]]] ;
    zongJFLabel.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"toalIntegral"]]];
    historyJFLabel.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"agoIntegral"]]];
    NSString *str1=   [ToolList changeNull:[dic objectForKey:@"areaRank"]];
    areaRank=[NSString stringWithFormat:@"%@",str1] ;
    NSString *str2=   [ToolList changeNull:[dic objectForKey:@"countryRank"]];
    countryRank=[NSString stringWithFormat:@"%@",str2] ;
    NSString *str3=   [ToolList changeNull:[dic objectForKey:@"deptRank"]];
    deptRank=[NSString stringWithFormat:@"%@",str3] ;
    NSString *str4=   [ToolList changeNull:[dic objectForKey:@"subRank"]];
    subRank=[NSString stringWithFormat:@"%@",str4] ;
    UILabel * la= [swArr objectAtIndex:0];
    la.text = deptRank;
    
    UILabel * la1= [swArr objectAtIndex:1];
    la1.text = subRank;
    UILabel * la2= [swArr objectAtIndex:2];
    la2.text = areaRank;
    
    UILabel * la3= [swArr objectAtIndex:3];
    la3.text = countryRank;
    NSArray *arr = [dic objectForKey:@"result"];
//    NSArray *arr =[[ NSArray alloc]initWithObjects:@"1111111",@"asdf",@"fhjk88", nil];
    
    NSString *string = [arr componentsJoinedByString:@"      "];
    
    _huadongLabel.text = string;
   
    if (arr.count <= 0 ) {
        
        [huadong removeFromSuperview];
    }
    else
    {
        [middleView addSubview:huadong];

        if (_timer == nil) {

        _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(kaishi) userInfo:nil repeats:YES];
        }
    }


}
-(void)kaishi
{
    CGSize size = [_huadongLabel.text boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size;

    size.width = ceilf(size.width);

    if(_huadongLabel.frame.origin.x==-size.width)
    {
        _huadongLabel.frame = CGRectMake(self.view.frame.size.width, 0,  size.width, 30);
    }
    else
    {
    
        [UIView animateWithDuration:0.1 animations:^{
            
            int x = _huadongLabel.frame.origin.x-1;
            _huadongLabel.frame = CGRectMake(x, 0,  size.width, 30);
            
        }];
        
    }
    
}

-(void)backBT
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)dealloc
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }

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
