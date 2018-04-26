//
//  XieJiLu_search2.m
//  SaleManagement
//
//  Created by cat on 2017/9/4.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "XieJiLu_search2.h"
#import "Fx_TableView.h"
#import "BuMenTableViewCell.h"
#import "CY_popupV.h"

@interface XieJiLu_search2 (){
    
    UIView *searchView2;
    
}
@property (nonatomic,strong)UITextField *search_text2;
@property(nonatomic,strong)Fx_TableView *searchTable;
@property(nonatomic,strong)NSMutableArray *searchData;
@end

@implementation XieJiLu_search2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_searchView];
}

-(void)init_searchView{
    
#pragma mark - 页面初始化
    //搜索区域
    searchView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:searchView2];
    searchView2.backgroundColor = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, IOS7_Height)];
    [searchView2 addSubview:headView];
    //搜索框
    _search_text2 = [[UITextField alloc] initWithFrame:CGRectMake(13, IOS7_StaticHeight + 7, __MainScreen_Width-56, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    _search_text2.leftView = imgView;
    _search_text2.leftViewMode = UITextFieldViewModeAlways;
    _search_text2.backgroundColor = [ToolList getColor:@"dedee0"];
    _search_text2.placeholder = @"请输入搜索内容";
    _search_text2.text = _myText;
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
    
   CY_popupV *popuV = [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andMessage:@"客户不存在，您可以添加客户" andBtTitel:@"添加客户" andtarget:self];
    
//    [self.view addSubview:popuV];
   
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
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 84.5) toPoint:CGPointMake(__MainScreen_Width, 84.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [_searchData objectAtIndex:indexPath.row];
    //    cell.nameLabel.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    
    NSMutableDictionary *request_dic =[[NSMutableDictionary alloc]init];
    request_dic[@"custName"]=theTextField.text;
    [FX_UrlRequestManager postByUrlStr:searchCustForVisit_url andPramas:request_dic andDelegate:self andSuccess:@"searchCustForVisitSuccess:" andFaild:nil andIsNeedCookies:YES];
    
    return YES;
}

-(void)searchCustForVisitSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"] intValue] == 200) {
        if (_searchData.count) {
//            [_flagArray removeAllObjects];
            [_searchData removeAllObjects];
            
        }
        _searchData = [[NSMutableArray alloc]initWithArray: [dic objectForKey:@"result"]];
        
        if (_searchData.count) {
            
//            for (NSDictionary *dicc in _searchData) {
//                
//                [_flagArray addObject:@"0"];
//            }
        }
//        _table_Height.constant = __MainScreen_Height-104;
        
        [_searchTable reloadData];
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
