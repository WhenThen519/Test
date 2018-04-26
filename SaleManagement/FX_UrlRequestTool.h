//
//  FX_UrlRequestTool.h
//  SaleManagement
//
//  Created by feixiang on 15/11/20.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FX_UrlRequestTool : NSObject
//单例
+(FX_UrlRequestTool *)shareUrlRequestTool;
/*发送post请求，根据url和参数返回字典，已经和后台沟通好，返回全部以字典形式
 ，后台不需要参数传nil，走公共请求失败的方法andFaild:后传nil,自定义失败的方法自己写返回字符串，不需要向后台传cookie，isNeed传NO
 */
-(void)postByUrlStr:(NSString *)urlStr andPramas:(NSMutableDictionary *)param andDelegate:(id)theDelegate andSuccess:(NSString *)success andFaild:(NSString *)faild andIsNeedCookies:(BOOL)isNeed;

-(void)postByUrlStr:(NSString *)urlStr andPramas:(NSMutableDictionary *)param andDelegate:(id)theDelegate andSuccess:(NSString *)success andFaild:(NSString *)faild andIsNeedCookies:(BOOL)isNeed andImageArray:(NSMutableArray *)imageArray andVoicePath:(NSString *)voicePath;

//1张图片上传
-(void)postByUrlStr:(NSString *)urlStr andPramas:(NSMutableDictionary *)param andDelegate:(id)theDelegate andSuccess:(NSString *)success andFaild:(NSString *)faild andIsNeedCookies:(BOOL)isNeed andImageArray:(UIImage *)image;

@end
