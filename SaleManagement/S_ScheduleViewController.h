//
//  ScheduleViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/3/29.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"
#import "JTCalendar.h"
#import "Fx_TableView.h"
@interface S_ScheduleViewController : Fx_RootViewController<JTCalendarDataSource,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic)  UILabel *calendarMenuView;
@property (retain, nonatomic)  JTCalendarContentView *calendarContentView;
@property (strong, nonatomic) JTCalendar *calendar;
@end
