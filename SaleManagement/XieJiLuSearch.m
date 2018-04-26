//
//  XieJiLuSearch.m
//  SaleManagement
//
//  Created by cat on 2017/9/4.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "XieJiLuSearch.h"
#import "Fx_TableView.h"
#import "CY_popupV.h"
#import "BuMenTableViewCell.h"
#import "CY_addClientVc.h"
#import "XieJiLuSearch2.h"

@interface XieJiLuSearch (){
    
    UIView *searchView;//第一个搜索页面
    UITextField *search_text;
    
}


@property(nonatomic,strong)Fx_TableView *searchTable;
@property(nonatomic,strong)NSMutableArray *searchData;
@property (nonatomic,strong)CY_popupV *popuV;

@property(nonatomic,strong)UIView *bgView;//保护库、老客户、收藏夹的背景页面；
@property(nonatomic,strong)NSDictionary *suc_Dic;
@end

@implementation XieJiLuSearch

- (void)viewDidLoad {
    [super viewDidLoad];
    _suc_Dic = [[NSDictionary alloc]init];
    [self initView];
    
}


-(void)initView{

#pragma mark - 页面初始化
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor whiteColor];
    //搜索框
    search_text = [[UITextField alloc] initWithFrame:CGRectMake(13, IOS7_StaticHeight + 7, __MainScreen_Width-56, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    search_text.leftView = imgView;
    search_text.leftViewMode = UITextFieldViewModeAlways;
    search_text.backgroundColor = [ToolList getColor:@"dedee0"];
    search_text.placeholder = @"请输入搜索内容";
    search_text.font = [UIFont systemFontOfSize:15];
    search_text.textColor = [ToolList getColor:@"333333"];
    search_text.layer.cornerRadius = 8;
    search_text.layer.masksToBounds = YES;
    search_text.clearButtonMode = UITextFieldViewModeAlways;
    search_text.delegate = self;
    search_text.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:search_text];
    [search_text becomeFirstResponder];
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(searchClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView addSubview:cancelSearchBtn];
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    
    _searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width,__MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:NO target:self];
    _searchTable.dataSource = self;
    _searchTable.delegate = self;
    [self.view addSubview:_searchTable];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height)];
    _bgView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.05, __MainScreen_Width, 14)];
    label.text = @"搜索指定范围客户";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [ToolList getColor:@"D4D4D4"];
    label.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:label];
    
    NSArray *buttonArr = @[@"保护库",@"老客户",@"收藏夹"];
    
    for (int i=0; i<3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(__MainScreen_Width/3.0), __MainScreen_Height*0.05+label.frame.size.height+label.frame.origin.y, __MainScreen_Width/3.0, 44);
        [button setTitle:[buttonArr objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = 188+i;
        [button addTarget:self action:@selector(button_clocked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
        [_bgView addSubview:button];
        
        if (i!=0) {
            
             [button.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 16) toPoint:CGPointMake(0,28-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        }
    }

   
}

#pragma mark-----保护库、老客户、收藏夹
-(void)button_clocked:(UIButton *)button{
    
    NSInteger buttonTag = button.tag-188;
    XieJiLuSearch2 *ghVC = [[XieJiLuSearch2 alloc]init];
    ghVC.search_Type = buttonTag;
    ghVC.back_view =_ss;
    ghVC.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController pushViewController:ghVC animated:NO];
   
    search_text.text = @"";   
}


#pragma mark - 搜索按钮点击
-(void)searchClicked:(UIButton *)btn
{
    search_text.text = @"";
    [search_text becomeFirstResponder];
  
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"-------");
    return YES;
}

#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    if (theTextField.text.length ==0) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入搜索内容"];
        return YES;
    }
    NSMutableDictionary *request_dic =[[NSMutableDictionary alloc]init];
    request_dic[@"custName"]=theTextField.text;
    [FX_UrlRequestManager postByUrlStr:searchCustForVisit_url andPramas:request_dic andDelegate:self andSuccess:@"searchCustForVisitSuccess:" andFaild:nil andIsNeedCookies:YES];
    
    return YES;
}
#pragma mark-----取消按钮，返回上一页
-(void)cancelBtn:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BuMenTableViewCell";
    BuMenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuMenTableViewCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 69.5) toPoint:CGPointMake(__MainScreen_Width, 69.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [_searchData objectAtIndex:indexPath.row];
    cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    cell.labelother.text =[ToolList changeNull:[dic objectForKey:@"custType"]];
    cell.addL.hidden = YES;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_searchData objectAtIndex:indexPath.row];
    NSString *flag_str =[ToolList changeNull:[dic objectForKey:@"flag"]];
    
    NSInteger flag =[flag_str integerValue];
    if (_popuV) {
        [_popuV removeFromSuperview];
        _popuV = nil;
    }
    switch (flag) {
        case -1:
        {
            //不存在
           
            _popuV = [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andMessage:[ToolList changeNull:[dic objectForKey:@"desc"]] andBtTitel:@"添加客户" andtarget:self andTag:indexPath.row+12];
            
            [self.view addSubview:_popuV];
        }
            break;
        case 0:
        {
            //无权操作
           
            _popuV = [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andMessage:[ToolList changeNull:[dic objectForKey:@"desc"]] andBtTitel:@"知道了" andtarget:self andTag:indexPath.row+12];
            
            [self.view addSubview:_popuV];
        }
            break;
        case 1:
        {
            //公海客户--收藏及保护操作
            _popuV = [[CY_popupV alloc]initWithMessage:@"客户在公海，您可以收藏/保护客户" andBtTitel_one:@"收藏" andBtTitel_two:@"保护" andtarget:self andTag:indexPath.row+12];
            [self.view addSubview:_popuV];
        }
            break;
        case 2:
        {
            //其他--保护
            _popuV = [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andMessage:@"客户已被其他商务收藏，您可以保护客户" andBtTitel:@"保护客户" andtarget:self andTag:indexPath.row+12];
            
            [self.view addSubview:_popuV];
        }
            break;
        case 3:
        {
           self.Serach_Block(dic);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark----操作
-(void)goAddView:(UIButton *)bt{
    
    [_popuV removeFromSuperview];
    _popuV = nil;
    NSDictionary *dic = [_searchData objectAtIndex:bt.tag-12];
    NSString *flag_str =[ToolList changeNull:[dic objectForKey:@"flag"]];
    NSInteger flag =[flag_str integerValue];
    switch (flag) {
        case -1:
        {
            CY_addClientVc *ghVC = [[CY_addClientVc alloc]init];
            ghVC.ss = _ss;
            ghVC.comString = search_text.text;
            ghVC.automaticallyAdjustsScrollViewInsets = NO;
            [self.navigationController pushViewController:ghVC animated:NO];
            
        }
            break;
        case 0:
        {
      
         
        }
            break;
            
        case 1:
        {
           //收藏
            _suc_Dic = dic;
            NSMutableDictionary *request_dic_2 =[[NSMutableDictionary alloc]init];
            request_dic_2[@"custId"]=[ToolList changeNull:[_suc_Dic objectForKey:@"custId"]];
            request_dic_2[@"custType"]=@"1";
            [FX_UrlRequestManager postByUrlStr:getOneCust_url andPramas:request_dic_2 andDelegate:self andSuccess:@"getOneCustSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
            break;
            
        case 2:
        {
             _suc_Dic = dic;
            NSMutableDictionary *request_dic_3 =[[NSMutableDictionary alloc]init];
            request_dic_3[@"custId"]=[ToolList changeNull:[_suc_Dic objectForKey:@"custId"]];
            [FX_UrlRequestManager postByUrlStr:protectCustomer_url andPramas:request_dic_3 andDelegate:self andSuccess:@"getOneCustSuccess:" andFaild:nil andIsNeedCookies:YES];
 
        }
            break;
            
        default:
            break;
    }

  
}

-(void)goAddView2:(UIButton *)bt{
    
    _suc_Dic = [_searchData objectAtIndex:bt.tag-12];
    //保护
    NSMutableDictionary *request_dic =[[NSMutableDictionary alloc]init];
    request_dic[@"custId"]=[ToolList changeNull:[_suc_Dic objectForKey:@"custId"]];
    request_dic[@"custType"]=@"2";
    [FX_UrlRequestManager postByUrlStr:getOneCust_url andPramas:request_dic andDelegate:self andSuccess:@"getOneCustSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)getOneCustSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue] == 200){
        
        [ToolList showRequestFaileMessageLittleTime:@"操作成功"];
        
        self.Serach_Block(_suc_Dic);
        [self.navigationController popViewControllerAnimated:YES];
    }
        
}

-(void)searchCustForVisitSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"] intValue] == 200) {
        if (_bgView) {
            
            [_bgView removeFromSuperview];
            _bgView = nil;
        }
        if (_searchData.count) {
            [_searchData removeAllObjects];
       
        }
        _searchData = [[NSMutableArray alloc]initWithArray: [dic objectForKey:@"result"]];
        [_searchTable reloadData];
        if (_searchData.count == 0) {
            
             [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
