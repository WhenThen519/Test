//
//  CEOController.m
//  SaleManagement
//
//  Created by feixiang on 2017/1/3.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//
#import "CEOController.h"

#define TOP_H (IOS7_Height+90)
#define SELECT_H (IOS7_Height+45)

@interface CEOController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *gr_Btn;
@property (weak, nonatomic) IBOutlet UIButton *bm_btn;
@property (weak, nonatomic) IBOutlet UILabel *date_L;

@end

@implementation CEOController
{
    //数据列表
    Fx_TableView *table;
    //数据
    NSMutableArray *dataArr;
    //请求传参
    NSMutableDictionary *requestDic;
    //开始数据标识
    int startPage;
    //个人还是部门列表标识
    int grORbmPage;
    UIView *selectContentView;
    UIScrollView * selectContentScrollView;
    NSArray *selectContentArr;
    UITextField *searchField;
    //已选
    NSMutableArray *hasSelectArr;

}
#pragma mark - 个人排名点击
- (IBAction)grBtnClicked:(id)sender {
    searchField.text = @"";
    searchField.userInteractionEnabled = YES;
    [hasSelectArr removeAllObjects];
    selectContentView.frame = CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H);

    _gr_Btn.backgroundColor = [ToolList getColor:@"ba81ff"];
    [_gr_Btn setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
    _bm_btn.backgroundColor = [ToolList getColor:@"ffffff"];
    [_bm_btn setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
    [requestDic removeAllObjects];
    [requestDic setObject:@"" forKey:@"areaName"];
    [requestDic setObject:@"" forKey:@"subName"];
    [requestDic setObject:@"" forKey:@"deptName"];
    [requestDic setObject:@"" forKey:@"searchName"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    grORbmPage = 0;
    startPage = 1;
    [self requestAlldata];

}
#pragma mark - 部门排名点击
- (IBAction)bmBtnClicked:(id)sender {
    searchField.text = @"";
    [hasSelectArr removeAllObjects];
    searchField.userInteractionEnabled = NO;
    selectContentView.frame = CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H);

    _bm_btn.backgroundColor = [ToolList getColor:@"ba81ff"];
    [_bm_btn setTitleColor:[ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
    _gr_Btn.backgroundColor = [ToolList getColor:@"ffffff"];
    [_gr_Btn setTitleColor:[ToolList getColor:@"ba81ff"] forState:UIControlStateNormal];
    [requestDic removeAllObjects];
    [requestDic setObject:@"" forKey:@"areaName"];
    [requestDic setObject:@"" forKey:@"subName"];
    [requestDic setObject:@"" forKey:@"deptName"];
    [requestDic setObject:@"" forKey:@"searchName"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    grORbmPage = 1;
    startPage = 1;
    [self requestAlldata];

}
#pragma mark - 筛选按钮点击
- (IBAction)selectBtnClicked:(id)sender {
    [self initSelectView];
    [UIView animateWithDuration:0.3 animations:^{
        selectContentView.frame = CGRectMake(0, SELECT_H, __MainScreen_Width, __MainScreen_Height-SELECT_H);
    }];
}
#pragma mark - 筛选清空
-(void)qingkong
{
    [hasSelectArr removeAllObjects];
    [self initSelectView];
}
#pragma mark - 取消
-(void)cancel
{
    searchField.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        selectContentView.frame = CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H);
    }];
    [requestDic removeAllObjects];
    [hasSelectArr removeAllObjects];
    [self initSelectView];
}
#pragma mark - 完成
-(void)finish
{
    
    [requestDic removeAllObjects];
    switch (hasSelectArr.count) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [requestDic setObject:[hasSelectArr objectAtIndex:0] forKey:@"areaName"];
 
        }
            break;
        case 2:
        {
            [requestDic setObject:[hasSelectArr objectAtIndex:0] forKey:@"areaName"];
            [requestDic setObject:[hasSelectArr objectAtIndex:1] forKey:@"subName"];

        }
            break;
        case 3:
        {
            [requestDic setObject:[hasSelectArr objectAtIndex:0] forKey:@"areaName"];
            [requestDic setObject:[hasSelectArr objectAtIndex:1] forKey:@"subName"];
            [requestDic setObject:[hasSelectArr objectAtIndex:2] forKey:@"deptName"];

        }
            break;
        default:
            break;
    }
    [requestDic setObject:searchField.text forKey:@"searchName"];
    startPage = 1;
    [self requestAlldata];
    
    [UIView animateWithDuration:0.3 animations:^{
        selectContentView.frame = CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H);
    }];
    [hasSelectArr removeAllObjects];
    [self initSelectView];
    searchField.text = @"";

}
#pragma mark - 区域选择
-(void)quyuSelect:(UIButton *)btn
{
    NSLog(@"%@",btn.titleLabel.text);
    if([hasSelectArr indexOfObject:btn.titleLabel.text] == NSNotFound)
    {
        [hasSelectArr addObject:btn.titleLabel.text];
    }
    [self initSelectView];
    
}
#pragma mark - 部门选择
-(void)bumenSelect:(UIButton *)btn
{
    NSLog(@"%@",btn.titleLabel.text);
    if([hasSelectArr indexOfObject:btn.titleLabel.text] == NSNotFound)
    {
        [hasSelectArr addObject:btn.titleLabel.text];
    }
    [self initSelectView];
    
}
#pragma mark - 分司选择
-(void)fensiSelect:(UIButton *)btn
{
    NSLog(@"%@",btn.titleLabel.text);
    if([hasSelectArr indexOfObject:btn.titleLabel.text] == NSNotFound)
    {
        [hasSelectArr addObject:btn.titleLabel.text];
    }
    [self initSelectView];
    
}
#pragma mark - 删除已选项
-(void)deleteHasSelect:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
    switch (btn.tag) {
        case 0:
        {
            [hasSelectArr removeAllObjects];
            break;
        }
        case 1:
        {
         
            NSString *ss = [hasSelectArr firstObject];
            [hasSelectArr removeAllObjects];
            [hasSelectArr addObject:ss];

            break;
        }
        case 2:
        {
            [hasSelectArr removeLastObject];
            break;
        }
        default:
            break;
    }
    [self initSelectView];
}
#pragma mark - 筛选页面根据已选数组初始化
-(void)initSelectView
{
    //重绘
    for (UIView *sub in selectContentScrollView.subviews) {
        if(sub)
        {
            [sub removeFromSuperview];
        }
    }
    UIView *hasSelectView = nil;
    //有已选区域
    if(hasSelectArr.count)
    {
    hasSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 100)];
        UILabel *s_L = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, __MainScreen_Width-20, 35)];
        s_L.text = @"已选";
        s_L.textColor = [ToolList getColor:@"7d7d7d"];
        s_L.font = [UIFont systemFontOfSize:14];
        //线
        [s_L.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 35) toPoint:CGPointMake(__MainScreen_Width-20, 35) andWeight:0.5 andColorString:@"e7e7eb"]];
        [hasSelectView addSubview:s_L];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setTitle:@"x 清空" forState:UIControlStateNormal];
        [clearBtn setTitleColor: [ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        clearBtn.frame = CGRectMake(__MainScreen_Width-50, 0, 50, 34);
        [clearBtn addTarget:self action:@selector(qingkong) forControlEvents:UIControlEventTouchUpInside];
        [hasSelectView addSubview:clearBtn];
        //已选按钮区域
        UIView *hasBtnView = [[UIView alloc] initWithFrame:CGRectMake(10, 35, __MainScreen_Width-20, 65)];
        [hasSelectView addSubview:hasBtnView];
        float btnWeight = (hasBtnView.frame.size.width-30)/3;
        //按钮
        for (int i = 0 ;i < hasSelectArr.count;i++) {
            NSString *title = [hasSelectArr objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.cornerRadius = 8;
            btn.layer.masksToBounds = YES;
            btn.backgroundColor = [ToolList getColor:@"BA81FF"];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor: [ToolList getColor:@"ffffff"] forState:UIControlStateNormal];
            btn.tag = i;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.frame = CGRectMake((btnWeight+10)*i, 10, btnWeight, 35);
            [btn addTarget:self action:@selector(deleteHasSelect:) forControlEvents:UIControlEventTouchUpInside];
            [hasBtnView addSubview:btn];
            UIImageView *ima = [[UIImageView alloc] initWithFrame:CGRectMake(btnWeight-35, 0, 35, 35)];
            ima.contentMode = UIViewContentModeCenter;
            ima.image = [UIImage imageNamed:@"huise.png"];
            [btn addSubview:ima];
        }
        [hasSelectView addSubview:s_L];
        [selectContentScrollView addSubview:hasSelectView];

    }
  //按钮区域
    UIView *bottomBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 44)];
    //线
    [bottomBtnView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 5) toPoint:CGPointMake(__MainScreen_Width/2, 34) andWeight:0.5 andColorString:@"e7e7eb"]];
    [bottomBtnView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"e7e7eb"]];

    [selectContentScrollView addSubview:bottomBtnView];
    
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor: [ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, 44);
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:cancelBtn];
    //完成
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor: [ToolList getColor:@"5d5d5d"] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    finishBtn.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, 44);
    [finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:finishBtn];
        switch (hasSelectArr.count) {
            //创建不带已选的分区
        case 0:
        {
            UILabel *s_ = [[UILabel alloc] initWithFrame:CGRectMake(10, hasSelectView.frame.origin.y+hasSelectView.frame.size.height, __MainScreen_Width-20, 35)];
            s_.text = @"区域";
            s_.textColor = [ToolList getColor:@"7d7d7d"];
            s_.font = [UIFont systemFontOfSize:14];
            //线
            [s_.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 35) toPoint:CGPointMake(__MainScreen_Width-20, 35) andWeight:0.5 andColorString:@"e7e7eb"]];
            [selectContentScrollView addSubview:s_];
            float btnWeight = (__MainScreen_Width - 40)/3;
            for (int i = 0; i < selectContentArr.count; i++)
            {
                NSDictionary *dic = [selectContentArr objectAtIndex:i];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.cornerRadius = 8;
                btn.layer.masksToBounds = YES;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = [ToolList getColor:@"7d7d7d"].CGColor;
                [btn setTitle:[dic objectForKey:@"areaName"] forState:UIControlStateNormal];
                [btn setTitleColor: [ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
                btn.tag = i;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.frame = CGRectMake(10+(btnWeight+10)*(i%3), 45+(10+35)*(i/3), btnWeight, 35);
                [btn addTarget:self action:@selector(quyuSelect:) forControlEvents:UIControlEventTouchUpInside];
                [selectContentScrollView addSubview:btn];
            }
            bottomBtnView.frame = CGRectMake(0, 45+45*((selectContentArr.count+2)/3), __MainScreen_Width, 44);
            float scrollHight = bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height <__MainScreen_Height - TOP_H?bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height :__MainScreen_Height - TOP_H;
            selectContentScrollView.frame = CGRectMake(0, 44, __MainScreen_Width, scrollHight);
            selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height);
         break;
        }
            //创建带已选的分司
        case 1:
        {
            UILabel *s_ = [[UILabel alloc] initWithFrame:CGRectMake(10, hasSelectView.frame.origin.y+hasSelectView.frame.size.height-10, __MainScreen_Width-20, 35)];
            s_.text = @"分司";
            s_.textColor = [ToolList getColor:@"7d7d7d"];
            s_.font = [UIFont systemFontOfSize:14];
            //线
            [s_.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 35) toPoint:CGPointMake(__MainScreen_Width-20, 35) andWeight:0.5 andColorString:@"e7e7eb"]];
            [selectContentScrollView addSubview:s_];
            float btnWeight = (__MainScreen_Width - 30)/2;
            NSArray *fensiArr = nil;
            for (NSDictionary *dic in selectContentArr) {
                if([[hasSelectArr objectAtIndex:0] isEqualToString:[dic objectForKey:@"areaName"]])
                {
                    fensiArr  = [dic objectForKey:@"subNames"];
                    break;
                }
            }
            for (int i = 0; i < fensiArr.count; i++)
            {
                NSDictionary *dic = [fensiArr objectAtIndex:i];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.cornerRadius = 8;
                btn.layer.masksToBounds = YES;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = [ToolList getColor:@"7d7d7d"].CGColor;
                [btn setTitle:[dic objectForKey:@"subName"] forState:UIControlStateNormal];
                [btn setTitleColor: [ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
                btn.tag = i;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.frame = CGRectMake(10+(btnWeight+10)*(i%2), s_.frame.origin.y+s_.frame.size.height+10+(10+35)*(i/2), btnWeight, 35);
                [btn addTarget:self action:@selector(fensiSelect:) forControlEvents:UIControlEventTouchUpInside];
                [selectContentScrollView addSubview:btn];
            }
            bottomBtnView.frame = CGRectMake(0, s_.frame.origin.y+s_.frame.size.height+10+45*((fensiArr.count+1)/2), __MainScreen_Width, 44);
            float scrollHight = bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height <__MainScreen_Height - TOP_H?bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height :__MainScreen_Height - TOP_H;
            selectContentScrollView.frame = CGRectMake(0, 44, __MainScreen_Width, scrollHight);
            selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height);
            break;
        }
            //创建带已选的部门
        case 2:
        {
            UILabel *s_ = [[UILabel alloc] initWithFrame:CGRectMake(10, hasSelectView.frame.origin.y+hasSelectView.frame.size.height-10, __MainScreen_Width-20, 35)];
            s_.text = @"部门";
            s_.textColor = [ToolList getColor:@"7d7d7d"];
            s_.font = [UIFont systemFontOfSize:14];
            //线
            [s_.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 35) toPoint:CGPointMake(__MainScreen_Width-20, 35) andWeight:0.5 andColorString:@"e7e7eb"]];
            [selectContentScrollView addSubview:s_];
            float btnWeight = (__MainScreen_Width - 30)/2;
            NSArray *fensiArr = nil;
            NSArray *bumenArr = nil;

            for (NSDictionary *dic in selectContentArr) {
                if([[hasSelectArr objectAtIndex:0] isEqualToString:[dic objectForKey:@"areaName"]])
                {
                    fensiArr  = [dic objectForKey:@"subNames"];
                    for (NSDictionary *dicSub in fensiArr) {
                        NSLog(@"%@----%@",[hasSelectArr objectAtIndex:1],[dicSub objectForKey:@"subName"]);
                        if([[hasSelectArr objectAtIndex:1] isEqualToString:[dicSub objectForKey:@"subName"]])
                        {
                            bumenArr = [dicSub objectForKey:@"deptNames"];
                            break;

                        }
                    }
                    break;
                }
            }
            for (int i = 0; i < bumenArr.count; i++)
            {
                NSDictionary *dic = [bumenArr objectAtIndex:i];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.cornerRadius = 8;
                btn.layer.masksToBounds = YES;
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = [ToolList getColor:@"7d7d7d"].CGColor;
                [btn setTitle:[dic objectForKey:@"deptName"] forState:UIControlStateNormal];
                [btn setTitleColor: [ToolList getColor:@"7d7d7d"] forState:UIControlStateNormal];
                btn.tag = i;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.frame = CGRectMake(10+(btnWeight+10)*(i%3), s_.frame.origin.y+s_.frame.size.height+10+(10+35)*(i/3), btnWeight, 35);
                [btn addTarget:self action:@selector(bumenSelect:) forControlEvents:UIControlEventTouchUpInside];
                [selectContentScrollView addSubview:btn];
            }
            bottomBtnView.frame = CGRectMake(0, s_.frame.origin.y+s_.frame.size.height+10+45*((bumenArr.count+2)/3), __MainScreen_Width, 44);
            float scrollHight = bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height <__MainScreen_Height - TOP_H?bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height :__MainScreen_Height - TOP_H;
            selectContentScrollView.frame = CGRectMake(0, 44, __MainScreen_Width, scrollHight);
            selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, bottomBtnView.frame.origin.y + bottomBtnView.frame.size.height);
            break;
        }
            //创建带已选的俩按钮
        case 3:
        {
            bottomBtnView.frame = CGRectMake(0, 90, __MainScreen_Width, 44);
            selectContentScrollView.frame = CGRectMake(0, 44, __MainScreen_Width, 134);
            selectContentScrollView.contentSize = CGSizeMake(__MainScreen_Width, 134);
            break;
        }
        default:
            break;
    }
}
#pragma mark - 页面初始化

-(void)initView
{
    _top.constant = IOS7_Height;
    _selectBtn.userInteractionEnabled = NO;
    //数据初始化
    startPage = 1;
    grORbmPage = 0;//默认是个人积分
    hasSelectArr = [[NSMutableArray alloc] init];
    dataArr = [[NSMutableArray alloc] init];
    requestDic = [[NSMutableDictionary alloc] init];
    [requestDic setObject:@"" forKey:@"areaName"];
    [requestDic setObject:@"" forKey:@"subName"];
    [requestDic setObject:@"" forKey:@"deptName"];
    [requestDic setObject:@"" forKey:@"searchName"];
    [requestDic setObject:[NSNumber numberWithInt:startPage] forKey:@"pageNo"];
    [requestDic setObject:@"10" forKey:@"pagesize"];
    
    _selectView.layer.cornerRadius = 4;
    _selectView.layer.masksToBounds = YES;
    _selectView.layer.borderWidth = 1;
    _selectView.layer.borderColor = [ToolList getColor:@"ba81ff"].CGColor;
    
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, TOP_H, __MainScreen_Width, __MainScreen_Height-TOP_H) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    [table.refreshHeader autoRefreshWhenViewDidAppear];
    
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    //添加筛选和搜索页面
    selectContentView = [[UIView alloc] initWithFrame:CGRectMake(0, SELECT_H-__MainScreen_Height, __MainScreen_Width, __MainScreen_Height-SELECT_H)];
    selectContentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:selectContentView];
    UIView *dd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 44)];
    dd.backgroundColor = [ToolList getColor:@"f2f3f5"];
    UIView *d = [[UIView alloc] initWithFrame:CGRectMake(5, 7, __MainScreen_Width-10, 30)];
    d.backgroundColor = [UIColor whiteColor];
    d.layer.cornerRadius = 5;
    d.layer.masksToBounds = YES;
    UIImageView *sea = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    sea.contentMode = UIViewContentModeCenter;
    sea.image = [UIImage imageNamed:@"Search Icon.png"];
    [d addSubview:sea];
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, __MainScreen_Width-40, 30)];
    searchField.placeholder = @"请输入要搜索内容";
    searchField.textColor = [ToolList getColor:@"5d5d5d"];
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [d addSubview:searchField];
    
    [selectContentView addSubview:dd];
    [dd addSubview:d];
    selectContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, __MainScreen_Width, 0)];
    selectContentScrollView.showsVerticalScrollIndicator = NO;
    selectContentScrollView.backgroundColor = [UIColor whiteColor];
    [selectContentView addSubview:selectContentScrollView];
    [self addNavgationbar:@"CE∙O积分" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];

}



#pragma mark - 筛选数据查询成功
-(void)requestSelectSuccess:(NSDictionary *)resultDic
{
    _selectBtn.userInteractionEnabled = YES;

    selectContentArr = [resultDic objectForKey:@"result"];
    [self initSelectView];
    NSLog(@"%@",selectContentArr);

}

#pragma mark - 列表数据查询成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    _date_L.text = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"tip"]];
    if(startPage == 1)
    {
        [dataArr removeAllObjects];
    }
    if([[resultDic objectForKey:@"result"] count] <= 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        if(startPage == 1)
        {
            [dataArr removeAllObjects];
            [table reloadData];
        }
    }
    else
    {
        [dataArr addObjectsFromArray:[resultDic objectForKey:@"result"]];
        [table reloadData];
    }
}
#pragma mark - 请求筛选数据
-(void)requestSelectdata
{
    
    [FX_UrlRequestManager postByUrlStr:getFilter_url andPramas:nil andDelegate:self andSuccess:@"requestSelectSuccess:" andFaild:nil andIsNeedCookies:NO];
    
}
#pragma mark - 数据请求
-(void) requestAlldata
{
    
    [requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    //请求个人
    if(grORbmPage == 0)
    {
    [FX_UrlRequestManager postByUrlStr:empIntegralRank_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    //请求部门
    else
    {
        [FX_UrlRequestManager postByUrlStr:deptIntegralRank_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
   
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CEOCell";
    CEOCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CEOCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 108.5) toPoint:CGPointMake(__MainScreen_Width, 108.5) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    cell.shiti.text = [NSString stringWithFormat:@"历史 %@",[ToolList changeNull:[dic objectForKey:@"agoIntegral"]]];
    cell.ti.text = [NSString stringWithFormat:@"单月 %@",[ToolList changeNull:[dic objectForKey:@"thisIntegral"]]];
    cell.moneyL.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"toalIntegral"]]];
    cell.NO_L.text = [NSString stringWithFormat:@"第%@名",[ToolList changeNull:[dic objectForKey:@"rank"]]];
    //个人
    if(grORbmPage == 0)
    {
        NSString *label1 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"areaName"]],[ToolList changeNull:[dic objectForKey:@"subName"]]];
        cell.timeL.text = label1;
        cell.typeL.text = [ToolList changeNull:[dic objectForKey:@"deptName"]];
        cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"salerName"]];
        
    }
    //部门
    else
    {
        NSString *label1 = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dic objectForKey:@"subName"]]];
        cell.timeL.text = label1;
        cell.typeL.text = [ToolList changeNull:[dic objectForKey:@"areaName"]];
        cell.nameL.text = [ToolList changeNull:[dic objectForKey:@"deptName"]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    //    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    //
    //    s.custNameStr = [dic objectForKey:@"custName"];
    //    s.custId = [dic objectForKey:@"custId"];
    //    [self.navigationController pushViewController:s animated:NO];
}
-(void)hideKeyBoard
{
    [self.view endEditing:YES];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    [self initView];
    [self requestAlldata];
    [self requestSelectdata];
    
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
