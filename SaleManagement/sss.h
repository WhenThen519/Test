//
//  sss.h
//  SaleManagement
//
//  Created by chaiyuan on 15/12/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sss : NSObject

@end


/*
 class: 图片
 */
@interface picAssert : NSObject
{
    
}
@property(nonatomic,strong)NSString *pic_name;
@property(nonatomic,strong)UIImage *pic_image;
@property(nonatomic,assign)int tag;
@end