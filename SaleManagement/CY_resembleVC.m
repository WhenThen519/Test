//
//  CY_resembleVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_resembleVC.h"
#import "CY_Tabel.h"
#import "UserDetailViewController.h"
#import "CY_intentVC.h"
#import "CY_myClientVC.h"

@interface CY_resembleVC (){
    CY_Tabel *table;
}

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CY_resembleVC


-(void)goUserview:(NSNotification *)notification{
    
    NSDictionary *dataDic =notification.object;
    
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [dataDic objectForKey:@"custName"];
    s.custId = [dataDic objectForKey:@"custId"];
    [self.navigationController pushViewController:s animated:NO];
}

-(void)goyxview:(NSNotification *)notification{
    
    NSString *dataStr =notification.object;
    
    if ([dataStr isEqualToString:@"意向客户"]) {
        
        CY_intentVC *s = [[CY_intentVC alloc] init];
        [self.navigationController pushViewController:s animated:NO];
        
    }else if ([dataStr isEqualToString:@"我的客户"]){

        CY_myClientVC *myClientV = [[CY_myClientVC alloc]init];
        [self.navigationController pushViewController:myClientV animated:NO];
    }
}


-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];

    //通知跳转到添加联系人页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftAction:) name:@"GOADDDVIEW" object:nil];
    
    //通知跳转意向或者我的客户页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goyxview:) name:@"GOYXVIEW" object:nil];
    
    //通知跳到详情页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goUserview:) name:@"GOUSERVIEW" object:nil];
    
    handView *Hvc = [[handView alloc]initWithTitle:@"相似客户" andRightImage:@"" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];
    
    UILabel *redL = [[UILabel alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 37)];
    redL.text = @"   您输入的客户名称存在相似客户";
    redL.textColor = [UIColor redColor];
    redL.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:redL];
    
    if (_isRen) {
        
        NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
        requestDic[@"certificateNo"]= self.textString;
        
        [FX_UrlRequestManager postByUrlStr:personalSimilarCustGet_url andPramas:requestDic andDelegate:self andSuccess:@"similarCustSuccess:" andFaild:@"similarCustFild:" andIsNeedCookies:YES];
        
    }else{
    
        NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
        requestDic[@"custName"]= self.textString;
        requestDic[@"intentCustId"]= self.intentCustString;
        [FX_UrlRequestManager postByUrlStr:similarCust_url andPramas:requestDic andDelegate:self andSuccess:@"similarCustSuccess:" andFaild:@"similarCustFild:" andIsNeedCookies:YES];
    
    }
}

-(void)similarCustSuccess:(NSDictionary *)sucDic{
    
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        _dataArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
        
        table = [[CY_Tabel alloc]initWithStyle:UITableViewStylePlain];
        table.view.frame = CGRectMake(0, IOS7_Height+37, __MainScreen_Width, __MainScreen_Height-IOS7_Height-37);
        table.arr = _dataArr;
        table.SintentCustId =self.intentCustString;
        NSMutableArray *typeArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in _dataArr) {
            
            [typeArr addObject:@"0"];
        }
        table.siTypeArr = typeArr;
        table.openIndexC = -1;
        [self.view addSubview:table.view];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
