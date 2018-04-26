//
//  XieJiLuSearch2.m
//  SaleManagement
//
//  Created by chaiyuan on 2017/9/11.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "XieJiLuSearch2.h"
#import "Fx_TableView.h"
#import "BuMenTableViewCell.h"

@interface XieJiLuSearch2 (){
     UIView *searchView2;
   
}

@property(nonatomic,strong)Fx_TableView *searchTable;
@property(nonatomic,strong)NSMutableArray *searchData;
@property (nonatomic,strong)UITextField *search_text2;
@property (nonatomic,strong)NSMutableDictionary *request_Dic;
@property (nonatomic,assign)NSInteger startPage;

@property (nonatomic,assign)BOOL isTableData;//yes为列表数据，no为搜索数据
@end

@implementation XieJiLuSearch2

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self init_searchView];
    _request_Dic = [[NSMutableDictionary alloc]init];
    _startPage =1;
    _isTableData = YES;
    [self tableData];
    
}

-(void)tableData{
    
    switch (_search_Type) {
        case 0:
        {
            //保护库
            _request_Dic[@"sortName"]=@"1";
            _request_Dic[@"custTypes"]=@[@"2",@"3"];
            _request_Dic[@"intenttypes"]=@[@"-1"];
            
        }
            break;
            
        case 1:
        {
            //老客户
            _request_Dic[@"sortName"]=@"1";
            _request_Dic[@"custTypes"]=@[@"4",@"5",@"6",@"7"];
            _request_Dic[@"intenttypes"]=@[@"-1"];
            
        }
            break;
            
        case 2:
        {
            //收藏夹
            _request_Dic[@"sortName"]=@"1";
            _request_Dic[@"custTypes"]=@[@"1"];
            _request_Dic[@"intenttypes"]=@[@"-1"];
            
        }
            break;
            
        default:
            break;
    }
    
    _request_Dic[@"pagesize"]=[NSNumber numberWithInt:10];
    [_request_Dic setObject:[NSString stringWithFormat:@"%ld",_startPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:myClient_url andPramas:_request_Dic andDelegate:self andSuccess:@"myClientSuccess:" andFaild:@"myClientFild:" andIsNeedCookies:YES];
}

#pragma mark - 显示搜索内容页面初始化
-(void)init_searchView{
    
    //搜索区域
    searchView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:searchView2];
    
    searchView2.backgroundColor = [UIColor whiteColor];
    
    //搜索框
    _search_text2 = [[UITextField alloc] initWithFrame:CGRectMake(13, IOS7_StaticHeight + 7, __MainScreen_Width-56, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    _search_text2.leftView = imgView;
    _search_text2.leftViewMode = UITextFieldViewModeAlways;
    _search_text2.backgroundColor = [ToolList getColor:@"dedee0"];
    _search_text2.placeholder = @"请输入搜索内容";
    _search_text2.text = _text_str;
    _search_text2.font = [UIFont systemFontOfSize:15];
    _search_text2.textColor = [ToolList getColor:@"333333"];
    _search_text2.layer.cornerRadius = 8;
    _search_text2.layer.masksToBounds = YES;
    _search_text2.clearButtonMode = UITextFieldViewModeAlways;
    _search_text2.delegate = self;
    _search_text2.returnKeyType = UIReturnKeySearch;
    [searchView2 addSubview:_search_text2];
    //    [_search_text2 becomeFirstResponder];
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView2 addSubview:cancelSearchBtn];
    [searchView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    
    _searchTable.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height - IOS7_Height);
    _searchTable = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _searchTable.dataSource = self;
    _searchTable.delegate = self;
    [searchView2 addSubview:_searchTable];
    
}

#pragma mark-----取消按钮，返回上一页
-(void)cancelBtn:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)myClientSuccess:(NSDictionary *)sucDic{
    
    [_searchTable.refreshHeader endRefreshing];
    [_searchTable.refreshFooter endRefreshing];
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if (_startPage > 1 ) {
            
            NSArray *dataArr =[sucDic objectForKey:@"result"];
            
            if (dataArr.count) {
                
                [_searchData addObjectsFromArray:dataArr];
                
            }else{
                
                [ToolList showRequestFaileMessageLittleTime:@"暂无更多数据"];
            }
            
            
        }else{
            
            if ([[sucDic objectForKey:@"result"] count ]== 0) {
                
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
                
            }
            _searchData = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
        }
        
    }
    
    
    [_searchTable reloadData];
    
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
    cell.labelother.text =[ToolList changeNull:[dic objectForKey:@"custVirtualType"]];//
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
  
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SEARCH_TWO" object:dic];
//    self.Serach_Block(dic);
    [self.navigationController popToViewController:_back_view animated:NO];
}


#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
 
    if (theTextField.text.length ==0) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入搜索内容"];
        return YES;
    }
    _startPage =1;  
    _isTableData = NO;
    [self request_Alldata];
    
    return YES;
}

#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    _startPage = 1;
    
    if (_isTableData) {
        
        [self tableData];
        return;
    }
    
    [self request_Alldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    _startPage += 1;
    
    if (_isTableData) {
        
        [self tableData];
        return;
    }
    [self request_Alldata];
    
}

-(void)request_Alldata{
    
    NSMutableDictionary *request_dic2 =[[NSMutableDictionary alloc]init];
    request_dic2[@"custName"]=_search_text2.text;
    switch (_search_Type) {
        case 0:
        {
            //保护库
             request_dic2[@"custTypes"]=@[@"2",@"3"];

            
        }
            break;
            
        case 1:
        {
            //老客户
            request_dic2[@"custTypes"]=@[@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
            
        }
            break;
            
        case 2:
        {
            //收藏夹
            request_dic2[@"custTypes"]=@[@"1"];
            
        }
            break;
            
        default:
            break;
    }

    request_dic2[@"pagesize"]=[NSNumber numberWithInt:10];
    [request_dic2 setObject:[NSString stringWithFormat:@"%ld",_startPage] forKey:@"pageNo"];
    [FX_UrlRequestManager postByUrlStr:SwCustM_url andPramas:request_dic2 andDelegate:self andSuccess:@"myClientSuccess:" andFaild:nil andIsNeedCookies:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
