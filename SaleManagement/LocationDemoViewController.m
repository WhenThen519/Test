//
//  LocationDemoViewController.m
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-4-15.
//  Copyright (c) 2013年 baidu. All rights reserved.
//
#import "LocationDemoViewController.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>

@implementation LocationDemoViewController
{
    __weak IBOutlet NSLayoutConstraint *top;
    NSString *address;
    NSMutableDictionary *resultDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    top.constant = IOS7_Height;
    resultDic = [[NSMutableDictionary alloc] init];
    //标题
    [self addNavgationbar:@"地图" leftBtnName:@"取消" rightBtnName:@"确定" target:self leftBtnAction:nil rightBtnAction:@"finish"];
    _locService = [[BMKLocationService alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    [self startLocation];
    
}
-(void)finish
{
    [resultDic setObject:address forKey:@"address"];
    
    self.czBlock(resultDic);
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
    
}
#pragma mark - 开始定位
-(void)startLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        //允许定位代码,A
        [_locService startUserLocationService];
        _mapView.showsUserLocation = YES;//关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        
    }
    else
    {
        //不允许定位代码,B
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请开启定位服务!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [myAlertView show];
        }
    }
    
}

#pragma mark - 停止定位
-(void)stopLocation
{
    [_locService stopUserLocationService];
    
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
}

#pragma mark - 位置变动
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    
    BMKCoordinateRegion viewRegion= BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(0.001, 0.001));//越小地图显示越详细
    //越小地图显示越详细
    
    [resultDic setObject:[NSNumber numberWithDouble:userLocation.location.coordinate.latitude] forKey:@"latitude"];
    [resultDic setObject:[NSNumber numberWithDouble:userLocation.location.coordinate.longitude] forKey:@"longitude"];
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    
    [_mapView setRegion:adjustedRegion animated:YES];
    [_mapView updateLocationData:userLocation];
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"定位停止了");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"定位失败!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [myAlertView show];
}
#pragma mark - 地理反编码成功
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        address = result.address;
        addressL.text = address;
        CGSize si = [address sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(addressL.frame.size.width, 9999) lineBreakMode:NSLineBreakByCharWrapping];
        address_h.constant = si.height + 8;
        
        //        [_mapView selectAnnotation:item animated:YES];//标题和子标题自动显示
    }
}
//最新的计算行高（上面的过时）
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [address boundingRectWithSize:size
                                           options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
    
    return retSize;
}
#pragma mark - 自定义大头针和弹窗
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    NSLog(@"%@-%@",annotation.title,annotation.subtitle);
//    NSString *AnnotationViewID = @"renameMark";
//   BMKPinAnnotationView * newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//    // 设置颜色
//    ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
//    // 从天上掉下效果
//   // ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
//    // 设置可拖拽
//    //设置大头针图标
//    //((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"gongneng0.png"];
//
//    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 60)];
////    //设置弹出气泡图片
////    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-khxx.png"]];
////    image.frame = CGRectMake(0, 0, 100, 60);
////    [popView addSubview:image];
//    //自定义显示的内容
//    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 50)];
//    driverName.text = [NSString stringWithFormat:@"当前位置:%@",annotation.title];
//    driverName.backgroundColor = [UIColor clearColor];
//    driverName.font = [UIFont systemFontOfSize:12];
//    driverName.textColor = [UIColor whiteColor];
//    driverName.textAlignment = NSTextAlignmentCenter;
//    [popView addSubview:driverName];
//
//    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
//    pView.frame = CGRectMake(0, 0, 160, 60);
//    ((BMKPinAnnotationView*)newAnnotation).paopaoView = nil;
//    ((BMKPinAnnotationView*)newAnnotation).paopaoView = pView;
//    return newAnnotation;
//}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
        
    }
}

@end
