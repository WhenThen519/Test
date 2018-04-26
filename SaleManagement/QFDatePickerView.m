//
//  QFDatePickerView.m
//  dateDemo
//
//  Created by 情风 on 2017/1/12.
//  Copyright © 2017年 情风. All rights reserved.
//

#import "QFDatePickerView.h"
#import "AppDelegate.h"

@interface QFDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView *contentView;
    void(^backBlock)(NSString *);
    
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSString *restr;
    
    NSString *selectedYear;
    NSString *selectecMonth;
    BOOL isDef;
    CGRect pick_frame;
    NSDictionary *selectDic;
}


@end

@implementation QFDatePickerView

#pragma mark - initDatePickerView
- (instancetype)initDatePackerWithResponse:(void (^)(NSString *))block andYear:(NSString *)year andMonth:(NSString *)month andPickFrame:(CGRect )PickFrame andButtonHiden:(BOOL)is_Def andSelectdic:(NSDictionary *)Select_dic{
    if (self = [super init]) {
        if (!is_Def) {
               self.frame = [UIScreen mainScreen].bounds;
            //获取当前时间 （时间格式支持自定义）
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
            NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
            //拆分年月成数组
            NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
            if (dateArray.count == 2) {//年 月
                currentYear = [[dateArray firstObject]integerValue];
                currentMonth =  [dateArray[1] integerValue];
            }
            selectedYear = year;
            selectecMonth = month;
        }else{
            pick_frame =PickFrame;
            self.frame = pick_frame;
            selectDic =[[NSDictionary alloc]init];
            selectDic = Select_dic;
            currentYear = [year integerValue];
            currentMonth = [month integerValue];
           
        }
       
        isDef =is_Def;
        
    }
    self.userInteractionEnabled = YES;
    [self setViewInterface];
    
    if (block) {
        backBlock = block;
    }
    return self;
}

#pragma mark - ConfigurationUI
- (void)setViewInterface {
    if (isDef) {
     
        if (selectDic.count) {
            selectedYear = [selectDic objectForKey:@"selectedYear"];
            selectecMonth =[selectDic objectForKey:@"selectecMonth"];
        }else{
            
            selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
            selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
        }
    }else{
        
    }
    

    //初始化年数据源数组
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 2017; i <= currentYear ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld",i];
        [yearArray addObject:yearStr];
    }
    
    //初始化月数据源数组
    monthArray = [[NSMutableArray alloc]init];
   
     if ([selectedYear intValue] == 2017){
        
        if ([selectedYear intValue] == currentYear) {
            for (NSInteger i = 8 ; i <= currentMonth; i++) {
                NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                [monthArray addObject:monthStr];
            }
        }else{
        
            for (NSInteger i = 8 ; i <= 12; i++) {
                NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                [monthArray addObject:monthStr];
            }
        }
     }else{
         
         if ([selectedYear intValue] == currentYear) {
             for (NSInteger i = 1 ; i <= currentMonth ; i++) {
                 NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                 [monthArray addObject:monthStr];
             }

         }else{
             for (NSInteger i = 1 ; i <= 12; i++) {
                 NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                 [monthArray addObject:monthStr];
             }
         }
         
     }
    
  
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
    
    
  
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
     if (!isDef) {
          [self addSubview:contentView];
         [contentView addSubview:whiteView];
         //设置背景颜色为黑色，并有0.4的透明度
         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
     }
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 0, 60, 40)];
        [button setTitle:i == 0 ? @"取消" : @"确定" forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithRed:97.0 / 255.0 green:97.0 / 255.0 blue:97.0 / 255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[ToolList getColor:@"AC4EFF"] forState:UIControlStateNormal];
        }
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
   
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    NSInteger j=0;
    for (int i=0; i< monthArray.count; i++) {
        
        if ([[monthArray objectAtIndex:i] intValue] == [selectecMonth intValue]) {
            j = i;
        }
    }
    //设置pickerView默认选中当前时间
    [pickerView selectRow:[selectedYear integerValue] - 2017 inComponent:0 animated:YES];
    [pickerView selectRow:j inComponent:1 animated:YES];
    if (!isDef) {
        pickerView.frame =CGRectMake(0, 40, CGRectGetWidth(self.bounds), 260);
        [contentView addSubview:pickerView];
    }else{
        pickerView.frame =CGRectMake(0, 0, pick_frame.size.width, pick_frame.size.height);
        pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:pickerView];

    }

    
}

#pragma mark - Actions
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    } else {
        if ([selectecMonth isEqualToString:@""]) {//至今的情况下 不需要中间-
            restr = [NSString stringWithFormat:@"%@%@",selectedYear,selectecMonth];
        } else {
            if(selectecMonth.intValue < 10)
            {
                restr = [NSString stringWithFormat:@"%@年0%@月",selectedYear,selectecMonth];

            }
            else
            {
                restr = [NSString stringWithFormat:@"%@年%@月",selectedYear,selectecMonth];
            }

        }
        
//        restr = [restr stringByReplacingOccurrencesOfString:@"年" withString:@""];
//        restr = [restr stringByReplacingOccurrencesOfString:@"月" withString:@""];
        backBlock(restr);
        [self dismiss];
    }
}

#pragma mark - pickerView出现
- (void)show {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}
#pragma mark - pickerView消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray.count;
    }
    else {
        return monthArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray[row];
    } else {
      
        return monthArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        selectedYear = yearArray[row];

            monthArray = [[NSMutableArray alloc]init];
        if ([selectedYear intValue] == 2017){
            
            if ([selectedYear intValue] == currentYear) {
                for (NSInteger i = 8 ; i <= currentMonth; i++) {
                    NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                    [monthArray addObject:monthStr];
                }
            }else{
                
                for (NSInteger i = 8 ; i <= 12; i++) {
                    NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                    [monthArray addObject:monthStr];
                }
            }
        }else{
            
            if ([selectedYear intValue] == currentYear) {
                for (NSInteger i = 1 ; i <= currentMonth ; i++) {
                    NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                    [monthArray addObject:monthStr];
                }
                
            }else{
                for (NSInteger i = 1 ; i <= 12; i++) {
                    NSString *monthStr = [NSString stringWithFormat:@"%ld",i];
                    [monthArray addObject:monthStr];
                }
            }
            
        }

            selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
        [pickerView reloadComponent:1];
        
    } else {
        NSLog(@"------");
        selectecMonth = monthArray[row];
    }
    
    if (isDef) {
        if(selectecMonth.intValue < 10)
        {
            restr = [NSString stringWithFormat:@"%@年0%@月",selectedYear,selectecMonth];
            
        }
        else
        {
            restr = [NSString stringWithFormat:@"%@年%@月",selectedYear,selectecMonth];
        }
       
        backBlock(restr);
    }
}

@end
