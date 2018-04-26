//
//  ScheduleViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/3/29.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "S_ScheduleViewController.h"
#import "AddNewScheduleViewController.h"
#import "ScheduleListCell.h"
#import "ScheduleDetailViewController.h"

@interface S_ScheduleViewController ()
{
    Fx_TableView *table;
    UILabel * calendarMenuViewLeft;
    UILabel *calendarMenuViewRight;
    NSString *refreshDate;
    //日程列表数据
    NSMutableArray *dataArr;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatter2;
    NSDateFormatter* dateFormatter3;
    NSString *requestDate;
    NSString *selectDate;
    
    //开始数据标识
    int startPage;
    NSMutableDictionary *reqDic;
    //事件数组
    NSArray *eventArr;
    BOOL isSelected;
}
@end

@implementation S_ScheduleViewController
#pragma mark - 数据请求
-(void) requestAlldata
{
    [reqDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    if(isSelected)
    {
        [reqDic setObject:selectDate forKey:@"date"];
        
    }
    else if(requestDate)
    {
        [reqDic setObject:requestDate forKey:@"date"];
    }
    else
    {
        [reqDic setObject:refreshDate forKey:@"date"];

    }
    [FX_UrlRequestManager postByUrlStr:ScheduleByDate_url andPramas:reqDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    
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
#pragma mark - 添加日程
-(void)addScheduleBtnClicked:(UIButton *)btn
{
    AddNewScheduleViewController *an = [[AddNewScheduleViewController alloc] init];
    [self.navigationController  pushViewController:an animated:NO];
    
}

#pragma mark - 列表数据请求成功
-(void)requestSuccess:(NSDictionary *)resultDic
{
    [table.refreshHeader endRefreshing];
    [table.refreshFooter endRefreshing];
    if(startPage == 1)
    {
        [dataArr removeAllObjects];
    }
    if([[resultDic objectForKey:@"result"] count] <= 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无日程"];
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
    eventArr = [NSArray arrayWithArray:[resultDic objectForKey:@"scheduleDate"]];
    [self.calendar reloadData];
}
#pragma mark - 滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        self.calendar.calendarAppearance.isWeekMode = NO;
        //下滑
        _calendarContentView.frame = CGRectMake(0, IOS7_Height+30, __MainScreen_Width, 250);
        table.frame = CGRectMake(0, IOS7_Height+280, __MainScreen_Width, __MainScreen_Height-280-IOS7_Height);
        
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        self.calendar.calendarAppearance.isWeekMode = YES;
        //上滑
        _calendarContentView.frame = CGRectMake(0, IOS7_Height+30, __MainScreen_Width, 70);
        table.frame = CGRectMake(0, IOS7_Height+100, __MainScreen_Width, __MainScreen_Height-100-IOS7_Height);
    }
    
    [self.calendar reloadAppearance];
    
    
}

#pragma mark - 监听当前日期的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(![[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]] && !isSelected)
    {
        [self requestAlldata];
    }
    else if(![[change objectForKey:@"new"] isEqualToString:[change objectForKey:@"old"]] && isSelected)
    {
        isSelected = NO;
        startPage = 1;
        [self requestAlldata];
        
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestAlldata];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    startPage = 1;
    isSelected = NO;
    UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizerUp];
    [self addObserver:self forKeyPath:@"requestDate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizerDown];
    dataArr = [[NSMutableArray alloc] init];
    dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy年MM月"];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd"];
    reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:@"10" forKey:@"pagesize"];
    refreshDate = [ dateFormatter stringFromDate:[NSDate date]];

    
    //标题
    [self addNavgationbar:@"日程" leftImageName:nil rightImageName:@"btn_add_top.png" target:self leftBtnAction:nil rightBtnAction:@"addScheduleBtnClicked:" leftHiden:NO rightHiden:NO];
    // 月份头年份
    _calendarMenuView = [[UILabel alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, 30)];
    _calendarMenuView.textColor = [ToolList getColor:@"9013FE"];
    _calendarMenuView.font = [UIFont systemFontOfSize:16];
    _calendarMenuView.backgroundColor = [ToolList getColor:@"f2f2f5"];
    _calendarMenuView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_calendarMenuView];
    
    calendarMenuViewLeft = [[UILabel alloc] initWithFrame:CGRectMake(3, IOS7_Height, 120, 30)];
    calendarMenuViewLeft.textColor = [ToolList getColor:@"999999"];
    calendarMenuViewLeft.font = [UIFont systemFontOfSize:13];
    calendarMenuViewLeft.backgroundColor = [UIColor clearColor];
    calendarMenuViewLeft.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:calendarMenuViewLeft];
    
    calendarMenuViewRight = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width - 123, IOS7_Height, 120, 30)];
    calendarMenuViewRight.textColor = [ToolList getColor:@"999999"];
    calendarMenuViewRight.font = [UIFont systemFontOfSize:13];
    calendarMenuViewRight.backgroundColor = [UIColor clearColor];
    calendarMenuViewRight.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:calendarMenuViewRight];
    //具体日期
    _calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, IOS7_Height+30, __MainScreen_Width, 250)];
    _calendarContentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_calendarContentView];
    
    //加日历
    self.calendar = [JTCalendar new];
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.ratioContentMenu = 1.;
        self.calendar.calendarAppearance.menuMonthTextFont = [UIFont systemFontOfSize:12];
        
        self.calendar.calendarAppearance.dayCircleColorSelected = [ToolList getColor:@"9013FE"];
        self.calendar.calendarAppearance.dayDotColor = [UIColor redColor];
        self.calendar.calendarAppearance.dayDotColorToday = [UIColor redColor];
        self.calendar.calendarAppearance.dayDotColorSelected = [ToolList getColor:@"9013FE"];
        
    }
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+280, __MainScreen_Width, __MainScreen_Height-280-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
}

#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ScheduleListCell";
    ScheduleListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ScheduleListCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"e7e7eb"]];
        
    }
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    cell.showTime.text = [ToolList changeNull:[dic objectForKey:@"showTime"]];
    cell.title.text = [ToolList changeNull:[dic objectForKey:@"title"]];
    cell.type.text = [ToolList changeNull:[dic objectForKey:@"type"]];
    //未过期
    if([[dic objectForKey:@"flag"] intValue] == 0)
    {
        [cell.dian setTextColor:[UIColor greenColor]];
    }
    //已过期
    else
    {
        [cell.dian setTextColor:[UIColor redColor]];
    }
    
    //
    //    NSString *label1 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"salerName"]],[ToolList changeNull:[dic objectForKey:@"custVirtualType"]]];
    //    cell.other1Label.text = label1;
    //    cell.moneyLabel.text = [ToolList changeNull:[dic objectForKey:@"productEndTime"]];
    //    NSString *label2 = [NSString stringWithFormat:@"%@ | %@",[ToolList changeNull:[dic objectForKey:@"productName"]],[ToolList changeNull:[dic objectForKey:@"productCode"]]];
    //    cell.other2Label.text = label2;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    ScheduleDetailViewController *s = [[ScheduleDetailViewController alloc] init];
    
    s.dataDic = dic;
    [self.navigationController pushViewController:s animated:NO];
}
#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    
    
    
    
    [self setValue:[dateFormatter3 stringFromDate:calendar.currentDate] forKey:@"requestDate"];
    _calendarMenuView.text = [[dateFormatter2 stringFromDate:calendar.currentDate] substringToIndex:8];
    
    NSString *da = [dateFormatter3 stringFromDate:date];
    
    
    
    
    NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar1 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:calendar.currentDate];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:+1];
    [adcomps setDay:0];
    NSDate *newdateadd = [calendar1 dateByAddingComponents:adcomps toDate:calendar.currentDate options:0];
    calendarMenuViewRight.text = [[dateFormatter2 stringFromDate:newdateadd] substringToIndex:8];
    
    NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = nil;
    comps2 = [calendar2 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:calendar.currentDate];
    NSDateComponents *adcomps2 = [[NSDateComponents alloc] init];
    [adcomps2 setYear:0];
    [adcomps2 setMonth:-1];
    [adcomps2 setDay:0];
    NSDate *newdatemin = [calendar2 dateByAddingComponents:adcomps2 toDate:calendar.currentDate options:0];
    calendarMenuViewLeft.text = [[dateFormatter2 stringFromDate:newdatemin] substringToIndex:8];
    
    if([eventArr indexOfObject:da] != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    //    NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSDateComponents *comps = nil;
    //    comps = [calendar1 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    //    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    //    [adcomps setYear:0];
    //    [adcomps setMonth:0];
    //    [adcomps setDay:+1];
    //    NSDate *newdate = [calendar1 dateByAddingComponents:adcomps toDate:date options:0];
    isSelected = YES;
    refreshDate = [dateFormatter stringFromDate:date];
    selectDate = [dateFormatter3 stringFromDate:date];
    startPage = 1;
    [self requestAlldata];
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
