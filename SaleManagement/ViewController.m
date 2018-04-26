//
//  ViewController.m
//  SaleManagement
//
//  Created by feixiang on 15/11/19.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "ViewController.h"
#import "CY_MoreButton.h"
#import "SSCheckBoxView.h"
#import "UIHelpers.h"
#import "CY_OrientationVc.h"
//xiaochengjiahao
@interface ViewController (){
    
}

@property (nonatomic, strong) NSMutableArray *checkboxes;

@end

@implementation ViewController


- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    
    [UIHelpers showAlertWithTitle:@"CheckBox State Changed"
                              msg:[NSString stringWithFormat:@"checkBoxView state: %d", cbv.checked]];
    
    // toggle all
    for (SSCheckBoxView *cbv in self.checkboxes) {
        cbv.enabled = !cbv.enabled;
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    bottomBtnArr = [[NSMutableArray alloc] init];
    if(xxHand)
    {
        [xxHand removeFromSuperview];
    }

    xxHand = [[handView alloc]initWithTitle:@"销售管理" andTitleColor:[ToolList getColor:@"9794e4"]  andBGColor:[UIColor clearColor] andLeftImage:nil andRightImage:nil andLeftTitle:nil andRightTitle:nil andTarget:self];
   
    middleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-50)];
    
    middleView.backgroundColor = [ToolList getColor:@"f1f4f4"];
    //    middleView.alwaysBounceVertical = YES;
    middleView.delegate = self;
    [self.view addSubview:middleView];
    
    [self.view addSubview:xxHand];
    
    handImage = [UIButton buttonWithType:UIButtonTypeCustom];
    if (__MainScreen_Height<=568) {
        
       handImage.frame =CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height*0.45);
    }else{
        handImage.frame =CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height*0.375);
    }
    [handImage setBackgroundImage:[UIImage imageNamed:@"bg-homepage.png"] forState:UIControlStateNormal];
    
    [middleView addSubview:handImage];
    
    middleView.contentSize = CGSizeMake(__MainScreen_Width, __MainScreen_Height*0.485+__MainScreen_Height*0.096*5);
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint point=scrollView.contentOffset;
    float alphtF =(point.y)/(35);
//    float alphtF =(point.y)/(__MainScreen_Height*0.35-IOS7_Height);
    xxHand.backgroundColor = [ToolList getColor:@"ffffff" andAlpha:alphtF];
    
}

//创建自定义tabBar

- (void)_initTabbarView:(NSArray *)DataArr andNormalImage:(NSArray *)NormalArr andselected:(NSArray *)selectedArr andSelectIndex:(NSInteger)index{
    
    if (_tabbarView != nil) {
        
        [_tabbarView removeFromSuperview];
    }
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-TabbarHeight, __MainScreen_Width, TabbarHeight)];
    _tabbarView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tabbarView];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:_tabbarView.bounds];
    imageV.image = [UIImage imageNamed:@"主导航框架.png"];
    [_tabbarView addSubview:imageV];
    for (int i=0; i<DataArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==index) {
            button.selected = YES;
        }
        
        if(i != DataArr.count/2)
        {
       [button setTitle:[DataArr objectAtIndex:i]  forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NormalArr objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[selectedArr objectAtIndex:i]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:[selectedArr objectAtIndex:i]] forState:UIControlStateSelected];
        
        button.imageEdgeInsets = UIEdgeInsetsMake(5,0,27,0);
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -29, -15, 0);//（上top，左left，下bottom，右right）
        float www = (__MainScreen_Width-26*DataArr.count-14)/(DataArr.count+1);
            if (i>DataArr.count/2) {
                
                 button.frame = CGRectMake(www+i*26+i*www+14, 10, 26, _tabbarView.frame.size.height);
               
            }else{
                
                 button.frame = CGRectMake(www+i*26+i*www, 10, 26, _tabbarView.frame.size.height);
            }
       
        
        button.tag = 199 + i;
        [bottomBtnArr addObject:button];
        [button setTitleColor:[ToolList getColor:@"646766"] forState:UIControlStateNormal];
//        [button setTitleColor:[ToolList getColor:@"5647b5"] forState:UIControlStateHighlighted];
        }
        else
        {
            addBtn = button;
            button.frame = CGRectMake(__MainScreen_Width/2.-18,60/2-20, 36, _tabbarView.frame.size.height);
            if([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==3){
                    
                    [button setImage:[UIImage imageNamed:@"首页置灰icon.png"] forState:UIControlStateNormal];
                    [button setUserInteractionEnabled:NO];
              
            }else{
                 [button setTitle:[DataArr objectAtIndex:i]  forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:[NormalArr objectAtIndex:i]] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:[selectedArr objectAtIndex:i]] forState:UIControlStateHighlighted];
                [button setImage:[UIImage imageNamed:[selectedArr objectAtIndex:i]] forState:UIControlStateSelected];
                button.imageEdgeInsets = UIEdgeInsetsMake(0,3,27,0);
                button.backgroundColor = [UIColor clearColor];
                button.titleLabel.font = [UIFont systemFontOfSize:10.0];
            
                button.titleEdgeInsets = UIEdgeInsetsMake(4, -41, -15, -10);//（上top，左left，下bottom，右right）
                 [button setTitleColor:[ToolList getColor:@"646766"] forState:UIControlStateNormal];
            }
            
        }
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 199 + i;
        [bottomBtnArr addObject:button];
        [_tabbarView addSubview:button];
    }
}


-(void)selectedTab:(UIButton *)TabBT{
    
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
