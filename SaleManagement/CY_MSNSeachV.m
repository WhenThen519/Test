//
//  CY_MSNSeachV.m
//  SaleManagement
//
//  Created by chaiyuan on 16/2/5.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_MSNSeachV.h"
#import "CY_MSNCell.h"
#import "ChineseString.h"
#import "CY_addDetailsVC.h"

@interface CY_MSNSeachV (){
    
    UIView *searchView;
    UITextField* text;
    UITableView *searchTable;
}

@property (nonatomic,strong)NSMutableArray *dataArr;//所有数据
@property(nonatomic,retain)NSMutableArray *indexArray;
//设置每个section下的cell内容
@property(nonatomic,retain)NSMutableArray *LetterResultArr;

@property (nonatomic,strong)NSMutableArray *nameArr;//姓名

@end

@implementation CY_MSNSeachV


-(void)cancelSearch:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO]; 
}


-(void)initView{
    
#pragma mark -- 数据初始化
    
    _dataArr = [[NSMutableArray alloc] init];
    _nameArr = [[NSMutableArray alloc]init];
    
#pragma mark -- 页面初始化
    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, IOS7_Height)];
    [searchView addSubview:headView];
    //搜索框
    text = [[UITextField alloc] initWithFrame:CGRectMake(13, IOS7_StaticHeight + 7, __MainScreen_Width-56, 29)];
    UIView * imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 29)];
    text.leftView = imgView;
    text.leftViewMode = UITextFieldViewModeAlways;
    text.backgroundColor = [ToolList getColor:@"dedee0"];
    text.placeholder = @"请输入搜索内容";
    text.font = [UIFont systemFontOfSize:15];
    text.textColor = [ToolList getColor:@"333333"];
    text.layer.cornerRadius = 8;
    text.layer.masksToBounds = YES;
    text.clearButtonMode = UITextFieldViewModeAlways;
    text.delegate = self;
    text.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:text];
    [text becomeFirstResponder];
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView addSubview:cancelSearchBtn];
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    

    searchTable = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain ];
    searchTable.dataSource = self;
    searchTable.delegate = self;
    searchTable.sectionIndexColor = [ToolList getColor:@"666666"];
    searchTable.sectionIndexBackgroundColor = [ToolList getColor:@"ffffff" andAlpha:0.01];
    searchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [searchView addSubview:searchTable];
    
 
}

#pragma mark--搜索按钮点击
-(void)searchClicked:(UIButton *)btn
{
    text.text = @"";
    [text becomeFirstResponder];
    searchTable.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark --textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    [self requestData:theTextField.text];
    return YES;
}

-(void)requestData:(NSString *)textString{
    
    if (textString.length) {
        
        
        NSMutableDictionary *searchRequestDic = [[NSMutableDictionary alloc] init];
        
        [searchRequestDic setObject:textString forKey:@"searchName"];
        
        [FX_UrlRequestManager postByUrlStr:searchFrequentContacts_url andPramas:searchRequestDic andDelegate:self andSuccess:@"searchFrequentContactsSuccess:" andFaild:nil andIsNeedCookies:YES];
    }else{
        
        [ToolList showRequestFaileMessageLittleTime:@"搜索内容不能为空！"];
    }
    
}

-(void)searchFrequentContactsSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        _dataArr = [sucDic objectForKey:@"result"];
        
        if (_dataArr.count) {
            
            for (NSDictionary *dic in _dataArr) {
                
                [_nameArr addObject:[dic objectForKey:@"linkManName"]];
            }
            
            self.indexArray = [ChineseString IndexArray:_nameArr];
            self.LetterResultArr = [ChineseString LetterSortArray:_nameArr];
            
            [searchTable reloadData];
            
        }else{
            
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        
        }

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initView];
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0.01)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 25.0f;
}

#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 25)];
    lab.backgroundColor = [ToolList getColor:@"f2f3f5"];
    lab.text = [NSString stringWithFormat:@"   %@",[_indexArray objectAtIndex:section]];
    lab.textColor = [ToolList getColor:@"333333"];
    
    [lab.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"dddddd"]];
    
    return lab;
}
#pragma mark - row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    return index;
}

#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_indexArray count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.LetterResultArr objectAtIndex:section] count];
}
#pragma mark -每一行的内容为数组相应索引的值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CY_MSNCell";
    CY_MSNCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CY_MSNCell" owner:self options:nil] lastObject];;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 79.5) toPoint:CGPointMake(__MainScreen_Width, 79.5) andWeight:0.5 andColorString:@"dddddd"]];
    }
    
    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    
    //    cell.nameL.text = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ - %@",[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row],[dic objectForKey:@"postion"]]];
    NSInteger leng =[[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] length];
    //设置字体
    [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16]range:NSMakeRange(0, leng)];//设置所有的字体
    // 设置颜色
    [attrString1 addAttribute:NSForegroundColorAttributeName
                        value:[ToolList getColor:@"333333"]
                        range:NSMakeRange(0, leng)];
    
    cell.nameL.attributedText = attrString1;
    
    
    cell.comL.text = [dic objectForKey:@"custName"];
    cell.telB.tag = indexPath.row;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
#pragma mark - Select内容为数组相应索引的值
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CY_addDetailsVC *addDetails = [[CY_addDetailsVC alloc]init];
    addDetails.dataDic = [_dataArr objectAtIndex:indexPath.row];
    addDetails.isChang = YES;
    [self.navigationController pushViewController:addDetails animated:NO];
}

-(IBAction)cellM:(UIButton *)sender{
    
    NSDictionary *dic = [_dataArr objectAtIndex:sender.tag];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[dic objectForKey:@"mobilePhone"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
