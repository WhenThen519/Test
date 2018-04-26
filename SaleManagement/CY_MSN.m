//
//  CY_MSN.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/22.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_MSN.h"
#import "ChineseString.h"
#import "CY_MSNCell.h"
#import "CY_addDetailsVC.h"
#import "CY_addMenVC.h"
#import "CY_MSNSeachV.h"

@interface CY_MSN (){
    
    UITableView *tableview;
}

@property(nonatomic,retain)NSMutableArray *indexArray;
//设置每个section下的cell内容
@property(nonatomic,retain)NSMutableArray *LetterResultArr;

@property (nonatomic,strong)NSArray *allData;//所有数据

@property (nonatomic,strong)NSMutableArray *nameArr;//姓名

@end

@implementation CY_MSN


-(void)LeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)RightAction:(id)sender{
    
    CY_MSNSeachV *msnSeach = [[CY_MSNSeachV alloc]init];
    [self.navigationController pushViewController:msnSeach animated:NO];
}

#pragma mark----添加联系人
-(void)addTarget:(UIButton *)bt{
    
    CY_addMenVC *addMen = [[CY_addMenVC alloc]init];

    [self.navigationController pushViewController:addMen animated:NO];
   
}

-(IBAction)cellM:(UIButton *)sender{
   
    NSDictionary *dic = [_allData objectAtIndex:sender.tag];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[dic objectForKey:@"mobilePhone"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [self shuaxin];
}

-(void)getFrequentContactsSuccess:(NSDictionary *)sucDic{
    
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {


        
        NSArray *dataArr =[sucDic objectForKey:@"result"];
        
            if (_nameArr.count) {
                
                [_nameArr removeAllObjects];
            }
            for (NSDictionary *dic in dataArr) {
                
                [_nameArr addObject:[dic objectForKey:@"linkManName"]];
            }

        if (dataArr.count==0) {
            
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        }
        self.indexArray = [ChineseString IndexArray:_nameArr];
        self.LetterResultArr = [ChineseString LetterSortArray:_nameArr];
    
        
                if (_allData==nil) {
        
                   _allData = [[NSArray alloc]initWithArray:[ChineseString changeDataArray:dataArr andStringArr:_nameArr]];
        
                }else{
        
                    _allData =[ChineseString changeDataArray:dataArr andStringArr:_nameArr];
                }
        
 
        
        
        [tableview reloadData];
       
    }//a.\U6d4b\U8bd55.\U6d4b\U8bd52.\U6d4b\U8bd54.\U4eba.\U9676\U94b0\U7389.wdy.wdy02.wdy6.\U96e8
}

-(void)shuaxin{
    
    [FX_UrlRequestManager postByUrlStr:getFrequentContacts_url andPramas:nil andDelegate:self andSuccess:@"getFrequentContactsSuccess:" andFaild:@"getFrequentContactsFild:" andIsNeedCookies:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _nameArr = [[NSMutableArray alloc]init];
    
    handView *Hvc = [[handView alloc]initWithTitle:@"常用联系人" andRightImage:@"btn_search_homepage" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(shuaxin) name:@"CHANGYONGREN" object:nil];
//    [center postNotificationName:@"CHANGYONGREN" object:nil];
    
//    [FX_UrlRequestManager postByUrlStr:getFrequentContacts_url andPramas:nil andDelegate:self andSuccess:@"getFrequentContactsSuccess:" andFaild:@"getFrequentContactsFild:" andIsNeedCookies:NO];

    //添加客户按钮
    UIButton *addV = [UIButton buttonWithType:UIButtonTypeCustom];
    addV.frame = CGRectMake(__MainScreen_Width-69, IOS7_StaticHeight, 40, 40);
    [addV setImage:[UIImage imageNamed:@"btn_add_top.png"] forState:UIControlStateNormal];
    [addV addTarget:self action:@selector(addTarget:) forControlEvents:UIControlEventTouchUpInside];
    [Hvc addSubview:addV];
    
    tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.sectionIndexColor = [ToolList getColor:@"666666"];
    tableview.sectionIndexBackgroundColor = [ToolList getColor:@"ffffff" andAlpha:0.01];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
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

 
    
    NSDictionary *dic ;

    for (NSDictionary *dd in _allData) {
        
        if ([[dd objectForKey:@"linkManName"]isEqualToString:[[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]) {
            
            dic = dd;
            break;
        }
    }
    
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
    NSString *srt = [[self.LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
   
    CY_addDetailsVC *addDetails = [[CY_addDetailsVC alloc]init];
    
    for (NSMutableDictionary *fff in _allData) {
        
        if ([[fff objectForKey:@"linkManName"]isEqualToString:srt]) {
            
            addDetails.dataDic = fff;
        }
    }

    addDetails.isChang = YES;
    [self.navigationController pushViewController:addDetails animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
