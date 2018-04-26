//
//  CY_selectV.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/11.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_selectV.h"
#import "WHC_XMLParser.h"


@interface CY_selectV ()

@property (nonatomic, strong) NSArray *provinces;//省
@property (nonatomic, strong) NSArray *cities;//市
@property (nonatomic, strong) NSArray *areas;//区
@property (nonatomic, assign) int provinceIndex;
@property (nonatomic, assign) int cityIndex;
@property (nonatomic, assign) int districtIndex;

@property (nonatomic, strong) NSString *provinceid;//省
@property (nonatomic, strong) NSString *citieid;//市
@property (nonatomic, strong) NSString *areaid;//区

@end

@implementation CY_selectV

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

- (void)loadPick
{
    self.locatePicker = [[UIPickerView alloc]init];
    _locatePicker.delegate = self;
    _locatePicker.dataSource = self;
       _locatePicker.backgroundColor = [UIColor whiteColor];
    self.locatePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.locatePicker.frame = CGRectMake(0, __MainScreen_Height-216+20, __MainScreen_Width,216);
    
    [self addSubview:_locatePicker];
    
}

- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate Province:(NSString *)province City:(NSString *)city District:(NSString *)district
{

    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height);
        [self loadPick];
        self.userInteractionEnabled  = YES;
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//        self.backgroundColor = [UIColor redColor];
        //加载数据
        if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {

            NSURL *xmlFilePath = [[NSBundle mainBundle] URLForResource:@"area2.0.xml" withExtension:nil];
            NSData *xmlData = [NSData dataWithContentsOfURL:xmlFilePath options:NSDataReadingUncached error:NULL];
            
            NSDictionary *dict = [[WHC_XMLParser dictionaryForXMLData:xmlData] objectForKey:@"china"];
            
            NSArray *array = [dict objectForKey:@"province"];
            
            self.provinces = array;
            
            if (province) {
                
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *pdict = [array objectAtIndex:i];
                    if ([[pdict objectForKey:@"name"] isEqualToString:province]) {
                        _provinceIndex = i;
                        break;
                    }
                }
            }
            
            [self.locatePicker selectRow:_provinceIndex inComponent:0 animated:YES];
            id city1 = [[self.provinces objectAtIndex:_provinceIndex] objectForKey:@"city"];
            
            if ([city1 isKindOfClass:[NSArray class]]) {
                
                self.cities = [[self.provinces objectAtIndex:_provinceIndex] objectForKey:@"city"];
             
            }
            else if ([city1 isKindOfClass:[NSDictionary class]]){
                
            NSDictionary *cdict = [[self.provinces objectAtIndex:_provinceIndex] objectForKey:@"city"];
                
                NSArray *cityArr = [[NSArray alloc]initWithObjects:cdict,nil];
                self.cities =cityArr;
                
            }
            
            self.locate.state = [[self.provinces objectAtIndex:_provinceIndex] objectForKey:@"name"];
            _provinceid =[[self.provinces objectAtIndex:_provinceIndex] objectForKey:@"id"];
            
            if (city && self.cities.count > 0) {
                for (int i = 0; i < self.cities.count; i++) {
                    NSDictionary *cdict = [self.cities objectAtIndex:i];
                    if ([[cdict objectForKey:@"name"] isEqualToString:city]) {
                        _cityIndex = i;
                        break;
                    }
                }
                self.locate.city = [[self.cities objectAtIndex:_cityIndex] objectForKey:@"name"];
                _citieid =[[self.cities objectAtIndex:_cityIndex] objectForKey:@"id"];
                
                [self.locatePicker reloadComponent:1];
                [self.locatePicker selectRow:_cityIndex inComponent:1 animated:YES];
                self.areas = [[self.cities objectAtIndex:0] objectForKey:@"area"];
            }else{
                self.locate.city = @"";
            }
            
            if (district && self.areas.count > 0) {
                for (int i = 0; i < self.areas.count; i++) {
                    NSDictionary *ddict = [self.areas objectAtIndex:i];
                    if ([[ddict objectForKey:@"name"] isEqualToString:district]) {
                        _districtIndex = i;
                        break;
                    }
                }
                self.locate.district = [[self.areas objectAtIndex:_districtIndex] objectForKey:@"name"];
                _areaid =[[self.areas objectAtIndex:_districtIndex] objectForKey:@"id"];
                [self.locatePicker reloadComponent:2];
                [self.locatePicker selectRow:_districtIndex inComponent:2 animated:YES];
            }else{
                self.locate.district = @"";
            }
        } else{
            
            self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
            self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
            self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"state"];
            self.locate.city = [self.cities objectAtIndex:0];
        }
        UIView *dataPicker1Bar = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-216-40+20, __MainScreen_Width, 40)];
//        UIToolbar *dataPicker1Bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-216-40+20, __MainScreen_Width, 40)];
        dataPicker1Bar.backgroundColor = [ToolList getColor:@"f6f5fd"];
        [self addSubview:dataPicker1Bar];
        dataPicker1Bar.userInteractionEnabled = YES;
        dataPicker1Bar.clipsToBounds = YES;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(15, 0, 46, 40);
        [btn1 setTitle:@"取消" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        [dataPicker1Bar addSubview:btn1];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(__MainScreen_Width-15-46, 0, 46, 40);
        [btn2 setTitle:@"完成" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [dataPicker1Bar addSubview:btn2];
    }
    
    return self;
    
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.provinces count];
            break;
        case 1:
            return [self.cities count];
            break;
        case 2:
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                return [self.areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    CGFloat componentWidth = (__MainScreen_Width-50)/3.0;
    
    return componentWidth;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 35.0;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, (__MainScreen_Width-50)/3.0, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
        label.textColor = [ToolList getColor:@"333333"];
    label.font = [UIFont systemFontOfSize:15];
    switch (component) {
        case 0:{
          
            label.text = [[self.provinces objectAtIndex:row] objectForKey:@"name"];
           
        }
            break;
        case 1:
        {
        
            label.text =  [[self.cities objectAtIndex:row] objectForKey:@"name"];
        }
            break;
        case 2:
            if ([self.areas count] > 0) {
                label.text = [[self.areas objectAtIndex:row] objectForKey:@"name"];
                break;
            }
        default:
            
            break;
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
           
            NSDictionary *dic =[self.provinces objectAtIndex:row];
            
            if ([dic objectForKey:@"city"]) {
                
                if ([[dic objectForKey:@"city"]isKindOfClass:[NSArray class]]) {
                    self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"city"];
                    
                }else{
                    
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    [arr addObject:[dic objectForKey:@"city"]];
                    self.cities =arr;
                }
                
            }else{
                
                self.cities = nil;
            }
            
            [self.locatePicker reloadComponent:1];
            self.locate.state = [[self.provinces objectAtIndex:row] objectForKey:@"name"];
            _provinceid = [[self.provinces objectAtIndex:row] objectForKey:@"id"];
            
            if (self.cities.count > 0) {
                
                NSDictionary *cyDic =[self.cities objectAtIndex:0];
                
                if ([[cyDic objectForKey:@"area"]isKindOfClass:[NSArray class]]) {
                    self.areas = [[self.cities objectAtIndex:0] objectForKey:@"area"];

                    
                }else{
                    
                    NSMutableArray *cyArr = [[NSMutableArray alloc]init];
                    [cyArr addObject:[cyDic objectForKey:@"area"]];
                    self.areas =cyArr;
                }
                
                self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"name"];
                _citieid =[[self.cities objectAtIndex:0] objectForKey:@"id"];
                
            }else{
                self.areas = nil;
                self.locate.city = @"";
                self.locate.district = @"";
            }
            
            [self.locatePicker selectRow:0 inComponent:2 animated:YES];
            [self.locatePicker reloadComponent:2];
            
            if ([self.areas count] > 0) {
                self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"name"];
                 _areaid =[[self.areas objectAtIndex:0] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
            }
        }
            break;
            
        case 1:
            
           
            if (self.cities && self.cities.count > 0) {
                self.areas = [[self.cities objectAtIndex:row] objectForKey:@"area"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[self.cities objectAtIndex:row] objectForKey:@"name"];
                  _citieid = [[self.cities objectAtIndex:row] objectForKey:@"id"];
                if ([self.areas count] > 0) {
                    self.locate.district = [[self.areas objectAtIndex:0] objectForKey:@"name"];
                     _areaid =[[self.areas objectAtIndex:0] objectForKey:@"id"];
                } else{
                    self.locate.district = @"";
                }
            }else{
                self.areas = nil;
                self.locate.city = @"";
                self.locate.district = @"";
            }
            
            break;
        case 2:
             NSLog(@"333333");
            if ([self.areas count] > 0) {
                self.locate.district = [[self.areas objectAtIndex:row] objectForKey:@"name"];
                _areaid = [[self.areas objectAtIndex:row] objectForKey:@"id"];
            } else{
                self.locate.district = @"";
            }
            break;
            
        default:
            break;
    }
    
    //    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
    [self.delegate pickerDidChaneStatus:self];
    //    }
    
}

- (void)btnClick:(id)sender
{

    [self cancelPicker];
    NSString *str = [NSString stringWithFormat:@"%@%@%@",self.locate.state,self.locate.city,self.locate.district];
    [self.delegate changeNativePlace:str andPid:_provinceid andcityid:_citieid andareaid:_areaid];
}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
//    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.frame = CGRectMake(0, __MainScreen_Height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}


@end
