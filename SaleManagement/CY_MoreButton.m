//
//  CY_MoreButton.m
//  SaleManagement
//
//  Created by chaiyuan on 15/11/20.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_MoreButton.h"

#define KWHC_IMAGE_SIZE (15.0)

@implementation CY_MoreButton


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    contentRect.origin.x = KWHC_IMAGE_SIZE;
    
    return contentRect;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGRect rect = CGRectZero;
    
    rect.origin.x = 0.0;
    
    rect.origin.y = (CGRectGetHeight(self.bounds)-KWHC_IMAGE_SIZE)/2.0;
    
    rect.size.width =  rect.size.height = KWHC_IMAGE_SIZE;
    
    return  rect;
    
}

@end
