//
//  CY_chooseVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/6.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_chooseVc.h"

@interface CY_chooseVc (){
    
    UIScrollView *mainScroll;
}



@end


@implementation CY_chooseVc


-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    handView *Hvc = [[handView alloc]initWithTitle:self.titleStr andRightImage:@"" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    
    [self.view addSubview:Hvc];
    
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height)];
    mainScroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainScroll];
    
    if (_dataArr ==nil) {

        if ([self.titleStr isEqualToString:@"选择职位"]) {
           
            [FX_UrlRequestManager postByUrlStr:position_url andPramas:nil andDelegate:self andSuccess:@"industrySuccess:" andFaild:@"industryFild:" andIsNeedCookies:NO];
            
        }
        
        else if ([self.titleStr isEqualToString:@"选择性质"]){
            
              [FX_UrlRequestManager postByUrlStr:getCustNature_url andPramas:nil andDelegate:self andSuccess:@"getCustNatureSuccess:" andFaild:@"getCustNatureFild:" andIsNeedCookies:NO];
        }
        
        else{
            
            [FX_UrlRequestManager postByUrlStr:industry_url andPramas:nil andDelegate:self andSuccess:@"industrySuccess:" andFaild:@"industryFild:" andIsNeedCookies:NO];
        }
        
       
    }else{
        //
        [self makeView];
    }

}

-(void)getCustNatureSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"]intValue]==200) {
        
        NSArray *arr = [dic objectForKey:@"result"];
        
        _dataArr = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in arr) {
            
            [_dataArr addObject:dic];
        }
        
        
        [self makeView];
        
    }

}


-(void)makeView{
    
    for (int i=0; i<_dataArr.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame =CGRectMake(13, 0+i*50, __MainScreen_Width-26, 50);
        [button setTitleColor:[ToolList getColor:@"333333"] forState:UIControlStateNormal];
        if ([self.titleStr isEqualToString:@"选择行业"]|| _isZhiWei){
            [button setTitle:[[_dataArr objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
        }
        else if ([self.titleStr isEqualToString:@"选择性质"]){
            
             [button setTitle:[[_dataArr objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
        }
        
        else{
            [button setTitle:[_dataArr objectAtIndex:i] forState:UIControlStateNormal];
        }
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget: self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [mainScroll addSubview:button];
        
        [button.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 49.5) toPoint:CGPointMake(__MainScreen_Width-13, 49.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    
    mainScroll.contentSize = CGSizeMake(__MainScreen_Width, _dataArr.count*50);
}

-(void)industrySuccess:(NSDictionary *)dic{

    if ([[dic objectForKey:@"code"]intValue]==200) {
       
        NSArray *arr = [dic objectForKey:@"result"];
        
         _dataArr = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in arr) {
            
            [_dataArr addObject:dic];
        }
        
        
        [self makeView];

    }
}

-(void)industryFild:(NSError *)err{
    
}

-(void)chooseType:(UIButton *)chooseB {
    
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.titleStr isEqualToString:@"选择行业"]||_isZhiWei){
       
        self.changeDicBlock([_dataArr objectAtIndex:chooseB.tag]);
     }
    else if ([self.titleStr isEqualToString:@"选择性质"]){
        
         self.changeDicBlock([_dataArr objectAtIndex:chooseB.tag]);
    }
    
    else{
    
          self.changeBlock(chooseB.titleLabel.text);//
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
