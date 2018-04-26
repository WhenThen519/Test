//
//  LocationDemoViewController.h
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-4-15.
//  Copyright (c) 2013年 baidu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "Fx_RootViewController.h"
typedef void (^chuanAddress)(NSMutableDictionary *) ;

@interface LocationDemoViewController :  Fx_RootViewController <BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    IBOutlet BMKMapView* _mapView;
    __weak IBOutlet UILabel *addressL;

    __weak IBOutlet NSLayoutConstraint *address_h;
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;

}
@property(nonatomic,copy)chuanAddress czBlock;

@end

