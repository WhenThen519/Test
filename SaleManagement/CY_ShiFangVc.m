//
//  CY_ShiFangVc.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/25.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_ShiFangVc.h"
#import "CY_releseCell.h"
#import "UserDetailViewController.h"
#import "Fx_TableView.h"

@interface CY_ShiFangVc ()

@property(nonatomic,strong)NSMutableArray *resultDic;
@property(nonatomic,strong)Fx_TableView *releseTable;
@property(nonatomic,strong)UIImageView *contentLineImageView;


@property (nonatomic, assign) BOOL reloading;//是否加载更多
@property (nonatomic,assign)int startPage;

@end

@implementation CY_ShiFangVc


-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
        _startPage = 1;
        [self requestAlldata];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
    handView *Hvc = [[handView alloc]initWithTitle:@"即将释放客户" andRightImage:@"" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];

    _releseTable = [[Fx_TableView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _releseTable.delegate = self;
    _releseTable.dataSource = self;
    _releseTable.backgroundColor = [UIColor whiteColor];
    [_releseTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    [self.view addSubview:_releseTable];
    

}

#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    _startPage = 1;
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    _startPage += 1;
    [self requestAlldata];
    
}

-(void)requestAlldata{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];

    reqDic[@"pageNo"] = [NSString stringWithFormat:@"%ld",_startPage];
    reqDic[@"pagesize"] = @"10";
    
    [FX_UrlRequestManager postByUrlStr:release_url andPramas:reqDic andDelegate:self andSuccess:@"releaseSuccess:" andFaild:@"releaseFild:" andIsNeedCookies:YES];
}

-(void)releaseSuccess:(NSMutableDictionary *)dic1{
    
    [_releseTable.refreshHeader endRefreshing];
    [_releseTable.refreshFooter endRefreshing];
    
    if ([[dic1 objectForKey:@"code"]intValue]==200) {
      
        if (_startPage==1) {
                
                _resultDic = [[NSMutableArray alloc]initWithArray:[dic1 objectForKey:@"result"]];
           
            
            if (_resultDic.count == 0) {

                [ToolList showRequestFaileMessageLittleTime:@"商务代表即将释放无数据"];
                
//                return;
            }
            
            [_releseTable reloadData];
            
        }else{
            
            if ([[dic1 objectForKey:@"result"] count]==0) {
                
                 [ToolList showRequestFaileMessageLittleTime:@"即将释放暂无更多数据"];
                
                return;
            }
            
            [_resultDic addObjectsFromArray:[dic1 objectForKey:@"result"]];
            
            [_releseTable reloadData];
        }
        
       
    }

}



#pragma UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_resultDic objectAtIndex:indexPath.row];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
    [self.navigationController pushViewController:s animated:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CY_releseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];

    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CY_releseCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
        
    }
    

    NSDictionary *dataDic = [_resultDic objectAtIndex:indexPath.row];
    cell.nameLabel.text = [ToolList changeNull:[dataDic objectForKey:@"custName"]];

    NSString *timeI = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"exceedTime"]];
    
    if ([timeI intValue]==0) {
        
         timeI = @"小于1小时";
        
    }
    
    NSString *label2 = [NSString stringWithFormat:@"%@ | %@ | %@",[ToolList changeNull:[dataDic objectForKey:@"protectCustType"]],[ToolList changeNull:[dataDic objectForKey:@"intentType"]],timeI];
 
        
    NSRange range = [timeI rangeOfString:@"小时"];
   //小于24小时显示为红色
    if (range.length) {
       
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:label2];
        //设置字体
        UIFont *baseFont = [UIFont systemFontOfSize:14];
        [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(label2.length-timeI.length, timeI.length)];
        
        // 设置颜色
        UIColor *color = [ToolList getColor:@"ff3333"];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:color
                           range:NSMakeRange(label2.length-timeI.length, timeI.length)];
        cell.typeLabel.attributedText = attrString;
        
    }else{

                                                                      
        cell.typeLabel.text = label2;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_resultDic count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85.0f;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
