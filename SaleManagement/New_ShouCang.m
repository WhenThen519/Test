//
//  New_Gonghai.m
//  SaleManagement
//
//  Created by feixiang on 2017/2/28.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "New_ShouCang.h"
#import "Fx_TableView.h"
#import "New_ShouCangCell.h"
#import "UserDetailViewController.h"
#import "Select.h"
#import "promptVc.h"

@interface New_ShouCang ()
{
    __weak IBOutlet NSLayoutConstraint *top1;
    Select *selectView;
    __weak IBOutlet NSLayoutConstraint *top2;
    //是否选20条
    BOOL isSelect20;
    NSIndexPath *index ;
    //筛选内容
    UIScrollView *selectDiQuContentView;
  
    //搜索框
    UITextField *text;
    //搜索区域
    UIView *searchView;
       //数据列表
    Fx_TableView *table;
    //底部操作层
    UIView *doView;
    //数据
    NSMutableArray *dataArr;

    //筛选条件请求传参
    NSMutableDictionary *requestDic;
  
    //开始数据标识
    int startPage;
    //请求传参
    NSMutableArray *selectArr;
    BOOL flagNeedReload;
    UIButton *shiFangBtn;
    UIButton *fenPeiBtn;

}
@property (weak, nonatomic) IBOutlet UILabel *allCount;

@property (nonatomic,strong)NSMutableArray *selectArr;//保护的BT
@property (nonatomic,strong)NSMutableArray *cancelArr;//取消的BT
@property (nonatomic,strong)NSMutableDictionary *Search_requestDic;
@end

@implementation New_ShouCang
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"New_ShouCangCell";
    New_ShouCangCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"New_ShouCangCell" owner:self options:nil] lastObject];

        
    }
   
    [cell.selectBtn2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(70, 0) andWeight:0.5 andColorString:@"e7e7e7"]];
    
    cell.selectBtn1.tag = 1000*indexPath.row;
    cell.selectBtn2.tag =  1000*indexPath.row;
    
    
    for (UIButton *bt in _selectArr) {
        if (bt.tag == cell.selectBtn1.tag) {
            
              [ cell.selectBtn1 setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
        }
    }
    
    for (UIButton *button in _cancelArr) {
        if (button.tag == cell.selectBtn2.tag) {
            
            [ cell.selectBtn2 setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
        }
    }
    
   NSDictionary *   dic = [dataArr objectAtIndex:indexPath.row];
    cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    cell.addL.text = [NSString stringWithFormat:@"%@万元 | %@ 人 ",[dic objectForKey:@"custRegisterMoney"],[dic objectForKey:@"custRegisterPeopleNumberType"]];
    cell.addl2.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"industryClassBig"],[dic objectForKey:@"custAddress"]];
    if([[dic objectForKey:@"homepageHint"] intValue]==0)
    {
        cell.guan.hidden = YES;
    }
    else
    {
        cell.guan.hidden = NO;
    }
    if([[dic objectForKey:@"releaseCount"] intValue]!=0)
    {
        cell.xin.layer.cornerRadius = 4;
        cell.xin.layer.masksToBounds = YES;
        cell.xin.backgroundColor = [UIColor redColor];
        [cell.xin setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"releaseCount"]] forState:UIControlStateNormal];
        [cell.xin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.xin setBackgroundImage:nil forState:UIControlStateNormal];

        cell.xin.titleLabel.font = [UIFont systemFontOfSize:8];
    }
    else
    {
        [cell.xin setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];

    }
    if([[dic objectForKey:@"channelNumber"] intValue]==0)
    {
        cell.tui.hidden = YES;
    }
   else
   {
       cell.tui.hidden = NO;
   }
    NSArray *telArr =[dic objectForKey:@"linkManInfo"];
    
    if (telArr.count) {
        
        float telArrH = 0.0f;
        
        for (int i=0;i<telArr.count;i++) {
            
            NSString *telStr = [ToolList changeNull:[telArr objectAtIndex:i]];
            
            UIFont *font = [UIFont systemFontOfSize:13];
            CGSize size = CGSizeMake(__MainScreen_Width-87,2000); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: font};
            CGSize labelsize = [telStr boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;

            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, telArrH, cell.telView.frame.size.width,labelsize.height+4)];
            label.textColor = [ToolList getColor:@"999999"];
            label.font = [UIFont systemFontOfSize:13];
            label.numberOfLines =0;
            label.text =telStr;
            [cell.telView addSubview:label];
            
             telArrH += labelsize.height+4;
            
        }
        
        cell.telH.constant = telArrH;

    }else{
        cell.telH.constant =0.0f;
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *   dic = [dataArr objectAtIndex:indexPath.row];
    NSArray *telArr =[dic objectForKey:@"linkManInfo"];
    
    if (telArr.count) {
        float telArrHeight = 0.0f;
        for (int i=0;i<telArr.count;i++) {
            
            NSString *telStr = [ToolList changeNull:[telArr objectAtIndex:i]];
            
            UIFont *font = [UIFont systemFontOfSize:13];
            CGSize size = CGSizeMake(__MainScreen_Width-87,2000); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: font};
            CGSize labelsize = [telStr boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
             telArrHeight = labelsize.height+4+telArrHeight;
        }

        return 100.0+telArrHeight;
    }
    
    return 100.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    New_ShouCangDetail *ee = [[New_ShouCangDetail alloc] init];
//    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
//    ee.receiveDic = dic;
//    [self.navigationController pushViewController:ee animated:NO];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [dic objectForKey:@"custName"];
    s.custId = [dic objectForKey:@"custId"];
   // s.flagRefresh = @"xiangqing";
    s.isShouCang = YES;
    [self.navigationController pushViewController:s animated:NO];
    
}
#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    
    
    [_Search_requestDic setObject:theTextField.text forKey:@"custName"];
    startPage = 1;
    flagNeedReload = NO;
    [self search_requestAlldata];
    return YES;
}
#pragma mark - 搜索数据请求
-(void) search_requestAlldata
{
  
    [_Search_requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
      [_Search_requestDic setObject:@"10" forKey:@"pagesize"];
    
    [FX_UrlRequestManager postByUrlStr:vagueSearch_url andPramas:_Search_requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}

-(void)shifangok
{
    startPage = 1;
    [self requestAlldata];
}

-(void)LeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)RightAction:(UIButton *)sender{
    
    [self searchClicked:sender];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shifangok) name:@"WSHIFANGOK" object:nil];
    _Search_requestDic = [[NSMutableDictionary alloc] init];
     [_Search_requestDic setObject:@"1" forKey:@"type"];
    top2.constant = IOS7_Height;
    top1.constant = IOS7_Height;
    _selectArr =[[NSMutableArray alloc] init];
    _cancelArr = [[NSMutableArray alloc] init];
    //数据初始化
    flagNeedReload = YES;
    isSelect20 = NO;
    startPage = 1;
    dataArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    [requestDic setObject:@"" forKey:@"custAddressProvince"];
    [requestDic setObject:@"" forKey:@"custAddressCity"];
    [requestDic setObject:@"" forKey:@"custAddressRegion"];
    [requestDic setObject:@"" forKey:@"industryClassBig"];
    [requestDic setObject:@"" forKey:@"custRegisterPeopleNumberType"];
    [requestDic setObject:@"" forKey:@"custName"];
    [requestDic setObject:@"" forKey:@"custRegisterMoneyType"];
    [requestDic setObject:@"3" forKey:@"channelNumber"];
    [requestDic setObject:@"3" forKey:@"homepageHint"];
    //标题
//    [self addNavgationbar:@"收藏夹" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:NO];
    handView *Hvc = [[handView alloc]initWithTitle:@"收藏夹" andRightImage:@"btn_search_homepage.png" andLeftTitle:@"" andRightTitle:@"" andTarget:self];
    [self.view addSubview:Hvc];
    
    UIButton *msgBt = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBt.frame = CGRectMake(__MainScreen_Width-125, IOS7_StaticHeight, 90, 40);
    msgBt.backgroundColor = [UIColor clearColor];
    msgBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [msgBt setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
    [msgBt setTitle:@"话术提示" forState:UIControlStateNormal];
     [msgBt addTarget:self action:@selector(TSBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [msgBt setImage:[UIImage imageNamed:@"帮助.png"] forState:UIControlStateNormal];
    [self.view addSubview:msgBt];
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height-44) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    table.dataSource = self;
    table.delegate = self;
    [table.refreshHeader autoRefreshWhenViewDidAppear];
    
    [self.view addSubview:table];
   
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-44, __MainScreen_Width, 44)];
    footView.backgroundColor = [UIColor whiteColor];
    //线
    [footView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"e7e7e7b"]];
    
    UIButton *footBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [footBt setTitle:@"批量完成" forState:UIControlStateNormal];
    footBt.titleLabel.font = [UIFont systemFontOfSize:16];
    [footBt setTitleColor:[ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    [footBt addTarget:self action:@selector(moreClocked:) forControlEvents:UIControlEventTouchUpInside];
    footBt.backgroundColor = [UIColor clearColor];
    footBt.frame = CGRectMake(0, 0, footView.frame.size.width, footView.frame.size.height);
    [footView addSubview:footBt];
    [self.view addSubview:footView];

    
    //搜索区域
    searchView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __MainScreen_Height)];
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
    
    UIButton *cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelSearchBtn.frame = CGRectMake(__MainScreen_Width-43, IOS7_StaticHeight, 43, 44);
    [cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelSearchBtn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
    cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelSearchBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    cancelSearchBtn.backgroundColor = [UIColor clearColor];
    [searchView addSubview:cancelSearchBtn];
    [searchView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, IOS7_Height-0.5) toPoint:CGPointMake(__MainScreen_Width,IOS7_Height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
    //底部操作层
    doView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-CaozuoViewHeight, __MainScreen_Width, CaozuoViewHeight)];
    doView.backgroundColor = [ToolList getColor:@"fafafa"];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0.8) toPoint:CGPointMake(__MainScreen_Width, 0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"保护" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [shiFangBtn addTarget:self action:@selector(baoHuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_shifang.png"] forState:UIControlStateNormal];
    [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:shiFangBtn];
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"收藏" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [fenPeiBtn addTarget:self action:@selector(shouCangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
    [self.view addSubview:doView];
    doView.hidden = YES;
    [self.view addSubview:searchView];
    
    startPage = 1;
    [self requestAlldata];

}

#pragma mark---话术提示
-(void)TSBtnClicked:(UIButton *)TSbt{
    
    promptVc *promptV = [[promptVc alloc] init];
    [self.navigationController pushViewController:promptV animated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    

}
#pragma mark - 保护操作
-(void)baoHuBtnClicked:(UIButton *)btn
{
    
}
#pragma mark - 收藏操作
-(void)shouCangBtnClicked:(UIButton *)btn
{
    
}
#pragma mark - 收藏夹搜索
-(void)searchClicked:(UIButton *)sender
{
    text.text = @"";
//    [requestDic setObject:@"" forKey:@"custAddressProvince"];
//    [requestDic setObject:@"" forKey:@"custAddressCity"];
//    [requestDic setObject:@"" forKey:@"custAddressRegion"];
//    [requestDic setObject:@"" forKey:@"industryClassBig"];
//    [requestDic setObject:@"" forKey:@"custRegisterPeopleNumberType"];
//    [requestDic setObject:@"" forKey:@"custName"];
//    [requestDic setObject:@"" forKey:@"custRegisterMoneyType"];
//    [requestDic setObject:@"3" forKey:@"channelNumber"];
//    [requestDic setObject:@"3" forKey:@"homepageHint"];
    
    [_Search_requestDic setObject:@"" forKey:@""];
     [_Search_requestDic setObject:@"" forKey:@""];
     [_Search_requestDic setObject:@"" forKey:@""];
     [_Search_requestDic setObject:@"" forKey:@""];
    
    startPage = 1;
    [text becomeFirstResponder];
    [selectView removeFromSuperview];
    selectView = nil;
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(0, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark - 收藏夹取消搜索
-(void)cancelSearch:(UIButton *)btn
{
    startPage = 1;
    flagNeedReload = YES;
    [_Search_requestDic setObject:@"" forKey:@"custName"];
//    [self requestAlldata];
    [text resignFirstResponder];
   
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
}
#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    startPage = 1;
    [self requestAlldata];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    startPage += 1;
    [self requestAlldata];
    
}
#pragma mark - 数据请求成功
-(void)requestSuccess:(NSDictionary *)dic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    [requestDic setObject:@"" forKey:@"custName"];
    //    [self requestAlldata];
    [text resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(__MainScreen_Width, 0, __MainScreen_Width,__MainScreen_Height);
    }];
    if(startPage == 1)
    {
        [dataArr removeAllObjects];
    }
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        if(startPage == 1)
        {
            [dataArr removeAllObjects];
            [table reloadData];
        }
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        _allCount.text = [NSString stringWithFormat:@"共计%@条",@"0"];
    }
    else
    {
        _allCount.text = [NSString stringWithFormat:@"共计%@条",[dic objectForKey:@"total"]];
        [dataArr addObjectsFromArray:[dic objectForKey:@"result"]];
        
        [table reloadData];
    }
}
-(void) requestAlldata
{
//    
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];

//            
            [FX_UrlRequestManager postByUrlStr:salerCollectionCust_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}


#pragma mark - 筛选创建
-(void)initSelectView:(NSDictionary *)dicF
{
    if(selectView)
    {
        [selectView removeFromSuperview];
        selectView = nil;
    }
    selectView = [[[NSBundle mainBundle] loadNibNamed:@"Select" owner:self options:nil] lastObject];
    selectView.frame = CGRectMake(0, IOS7_Height+SelectViewHeight, __MainScreen_Width, __MainScreen_Height-SelectViewHeight-IOS7_Height);
    selectView.h8.constant = 0;
    selectView.h_8.constant = 0;
    selectView.hide1.hidden = YES;
    selectView.hide2.hidden = YES;
    selectView.baidu_h.constant = 0;
    selectView.baiduView_h.constant = 0;
    selectView.baidu.hidden = YES;
    selectView.baiduView.hidden = YES;
    selectView.tuiSubView.hidden = YES;
    selectView.tuiSubView_h.constant = 0;
    selectView.ICP_h.constant = 0;
    selectView.ICPView_h.constant = 0;
    selectView.ICP.hidden = YES;
    selectView.ICPView.hidden = YES;
    selectView.otherBtn.hidden = YES;
    selectView.otherBtn_h.constant = 0;
    selectView.createTime = [dicF objectForKey:@"createTime"];
    selectView.industryclassBig = [dicF objectForKey:@"industryclassBig"];
    selectView.registerMoney = [dicF objectForKey:@"registerMoney"];
    selectView.registerPeopleNum = [dicF objectForKey:@"registerPeopleNum"];
    [selectView createView];
    selectView.czDicBlock = ^(NSDictionary *dic)
    {
        NSLog(@"%@",dic);
        [requestDic setValuesForKeysWithDictionary:dic];
        startPage = 1;
        [self requestAlldata];

    };
    
    
    
    [self.view addSubview:selectView];
}
-(void)requestSelectSuccess:(NSDictionary *)dictionary
{
    [self initSelectView:[dictionary objectForKey:@"result"]];
}
-(void)requestSelect
{
    [FX_UrlRequestManager postByUrlStr:SWfilterData_url andPramas:requestDic andDelegate:self andSuccess:@"requestSelectSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 筛选按钮点击
- (IBAction)selectBtnClicked:(id)sender {
    [self requestSelect];
}
#pragma mark - 筛选20按钮点击
- (IBAction)select20BtnClicked:(id)sender {
    isSelect20 = !isSelect20;
    if(isSelect20)
    {
        [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_selectALLBtn setImage:[UIImage imageNamed:@"xuanze20_N.png"] forState:UIControlStateNormal];
    }
    [_selectALLBtn setTitle:@"选择20条" forState:UIControlStateNormal];
    //    [self initSelectView];
}

#pragma mark-----放弃
-(IBAction)abandonBt:(UIButton *)abandonBt{

    abandonBt.selected = !abandonBt.selected;
    New_ShouCangCell *cell = (New_ShouCangCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:abandonBt.tag/1000 inSection:0]];

    if (abandonBt.selected) {
        
        [ abandonBt setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
         [_cancelArr addObject:abandonBt];
        
        for (NSInteger j= _selectArr.count; j>0; j--) {
            
            UIButton *bt =(UIButton *)[_selectArr objectAtIndex:j-1];
            if (bt.tag == abandonBt.tag) {
                
                [_selectArr removeObjectAtIndex:j-1];
                cell.selectBtn1.selected = NO;
                [ cell.selectBtn1 setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
            }

        }
        
    }else{
          [ abandonBt setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
        for (NSInteger i = _cancelArr.count; i>0; i--) {
            
            UIButton *bt =(UIButton *)[_cancelArr objectAtIndex:i-1];
            
            if (bt.tag == abandonBt.tag) {
                
                [_cancelArr removeObjectAtIndex:i-1];
                
            }
        }
     
    }
    
}

#pragma mark-----保护
-(IBAction)protectBT:(UIButton *)aprotectBt{

    aprotectBt.selected = !aprotectBt.selected;
    
    New_ShouCangCell *cell = (New_ShouCangCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:aprotectBt.tag/1000 inSection:0]];

    if (aprotectBt.selected) {
      
        [ aprotectBt setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
        
        [_selectArr addObject:aprotectBt];
        for (NSInteger i = _cancelArr.count; i>0; i--) {
            
            UIButton *bt =(UIButton *)[_cancelArr objectAtIndex:i-1];
            
            if (bt.tag == aprotectBt.tag) {
                
                [_cancelArr removeObjectAtIndex:i-1];
                cell.selectBtn2.selected = NO;
                [ cell.selectBtn2 setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
            }
        }

        
    }else{
        [ aprotectBt setTitleColor:[ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
        
        for (NSInteger i = _selectArr.count; i>0; i--) {
            
            UIButton *bt =(UIButton *)[_selectArr objectAtIndex:i-1];
            
            if (bt.tag == aprotectBt.tag) {
                
                [_selectArr removeObjectAtIndex:i-1];
            }
        }
    }
    
   
}

#pragma mark-----批量操作
-(void)moreClocked:(UIButton *)bt{
    
    if (_selectArr.count==0 && _cancelArr.count==0) {
        
      [ToolList showRequestFaileMessageLongTime:@"请选择公司操作"];
        return;
    }
    NSMutableString *releaseStr =[[NSMutableString alloc]initWithString:@""];
    NSMutableString *protectStr =[[NSMutableString alloc]initWithString:@""];
    if (_cancelArr.count) {
        
        for (UIButton *releaseBt in _cancelArr) {
            NSDictionary *dicd =[dataArr objectAtIndex:releaseBt.tag/1000];
            [releaseStr appendFormat:@"%@,",[dicd objectForKey:@"custId"]];
        }
         [releaseStr deleteCharactersInRange:NSMakeRange([releaseStr length]-1, 1)];
        NSLog(@"____________%@",releaseStr);
    }
    if (_selectArr.count) {
        for (UIButton *protectBt in _selectArr) {
            
            NSDictionary *dicc =[dataArr objectAtIndex:protectBt.tag/1000];
            
            [protectStr appendFormat:@"%@,",[dicc objectForKey:@"custId"]];
             NSLog(@"=============%@",protectStr);
        }
       [protectStr deleteCharactersInRange:NSMakeRange([protectStr length]-1, 1)];
       
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"releaseCustId"] = releaseStr;//释放客户的ID
    dic[@"protectCustId"] = protectStr;//保护客户的ID
    
    [FX_UrlRequestManager postByUrlStr:protectAndRelease_url andPramas:dic andDelegate:self andSuccess:@"protectAndReleaseSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)protectAndReleaseSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue]==200) {
        
        [ToolList showRequestFaileMessageLittleTime:[NSString stringWithFormat:@"%@",[sucDic objectForKey:@"msg"]]];
        if (_cancelArr.count) {
            [_cancelArr removeAllObjects];
        }
        if (_selectArr.count) {
            [_selectArr removeAllObjects];
        }
        [self headerRefresh:table];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
