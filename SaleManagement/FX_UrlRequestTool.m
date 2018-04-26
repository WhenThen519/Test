//
//  UrlRequestTool.m
//  SaleManagement
//
//  Created by feixiang on 15/11/20.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "FX_UrlRequestTool.h"
#import "AppDelegate.h"
#import "LoginVC.h"
@implementation FX_UrlRequestTool
//做成单例减少内存开辟
//数据请求管理第三方
static AFHTTPRequestOperationManager *afManager = nil;
static FX_UrlRequestTool *defaultTool = nil;
#pragma mark - 单例
+(FX_UrlRequestTool *)shareUrlRequestTool
{
    if(!afManager)
    {
        afManager = [AFHTTPRequestOperationManager manager];
        //afManager.securityPolicy.allowInvalidCertificates = YES;
    }
    if(!defaultTool)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            defaultTool = [[[self class] alloc] init];
        });
    }
    return defaultTool;
}
//重写allocWithZone方法
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
        if(defaultTool == nil)
        {
            defaultTool = [super allocWithZone:zone];
        }
    }
    return defaultTool;
}
#pragma mark - 数据请求
/*发送post请求，根据url和参数返回字典，已经和后台沟通好，返回全部以字典形式
 ，后台不需要参数传nil，走公共请求失败的方法andFaild:后传nil,自定义失败的方法自己写返回字符串，不需要向后台传cookie，isNeed传NO
 */
-(void)postByUrlStr:(NSString *)urlStr andPramas:(NSMutableDictionary *)param andDelegate:(id)theDelegate andSuccess:(NSString *)success andFaild:(NSString *)faild andIsNeedCookies:(BOOL)isNeed
{
    //统一的网络请求提示语
    [ToolList showRequestFaileMessageLongTime:@"数据加载中..."];
    /*存coolie 以后有用
     NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:kServerAddress]];
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
     [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kUserDefaultsCookie"];
     */
    
    __block typeof (theDelegate)blockDelegate=theDelegate;
    
    /*读cookie并传入http里 以后有用
     if(isNeed)
     {
     NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
     if([cookiesdata length]) {
     NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
     NSHTTPCookie *cookie;
     for (cookie in cookies) {
     [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
     }
     }
     
     }
     */
    NSString * requestStr = [NSString stringWithFormat:@"%@%@",Host_url,urlStr];
//    NSLog(@"----------%@",urlStr);
    //转换特殊地址（链接带汉字）
    NSString *resultStr = [requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if(isNeed)
    {
        param = [ToolList getJSONDicByObject:param];
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"IOSTOKEN"])
        {
            param = [[NSMutableDictionary alloc] init];
            [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"IOSTOKEN"] forKey:@"token"];
        }
    }

    //    afManager.requestSerializer.stringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [afManager POST:resultStr parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        [[mainWindow viewWithTag:8888] removeFromSuperview];
        NSError *err = nil;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
        if(err)
        {
            NSLog(@"json解析失败,可能数据格式不符合json");
        }
        else
        {
            if([[resultDic objectForKey:@"code"] intValue]==200)
            {
                [self doDelegate:blockDelegate method:success objct:resultDic];
            }
            else if([[resultDic objectForKey:@"code"] intValue]==201)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[resultDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                [self doDelegate:blockDelegate method:success objct:resultDic];
                
            }
            else if([[resultDic objectForKey:@"code"] intValue]==203)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[resultDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                [self doDelegate:blockDelegate method:success objct:resultDic];
                
            }
            else if([[resultDic objectForKey:@"code"] intValue]==402)
            {
                [self doDelegate:blockDelegate method:success objct:resultDic];
                
            }
            
            else if([[resultDic objectForKey:@"code"] intValue]==600)
            {
                AppDelegate *de = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginVC *root =  [[LoginVC alloc] init];
                de.window.rootViewController = root;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[resultDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_REFRESH" object:nil];
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        [[mainWindow viewWithTag:8888] removeFromSuperview];
        NSLog(@"请求失败，错误：%@ 响应：%@",error,operation.responseObject);
        //这里是程序员自定义自己的失误返回要操作的内容
        if(faild && faild.length)
        {
            [self doDelegate:blockDelegate method:faild objct:error];
        }
        else
        {
            [ToolList showRequestFaileMessageLittleTime:@"网络加载失败，请重试！"];
        }
    }];
    
}
#pragma mark - 数据请求回调
/*!
 
 进行回调的函数
 
 
 @param delete_ 回调的代理
 @param name    回调的函数的名字
 @param dic     回调的参数
 
 */

-(void)doDelegate:(id)delete_ method:(NSString*)name objct:(id)dic
{
    if(delete_){
        SEL selector = NSSelectorFromString(name);
        if ([delete_ respondsToSelector:selector]) {
            [delete_ performSelectorOnMainThread:selector withObject:dic waitUntilDone:NO];
        }else {
            NSLog(@"网络请求代理未定义回调方法");
        }
        
    }
}

//带图片或者语音上传
-(void)postByUrlStr:(NSString *)urlStr andPramas:(NSMutableDictionary *)param andDelegate:(id)theDelegate andSuccess:(NSString *)success andFaild:(NSString *)faild andIsNeedCookies:(BOOL)isNeed andImageArray:(NSMutableArray *)imageArray andVoicePath:(NSString *)voicePath
{
    //统一的网络请求提示语
    [ToolList showRequestFaileMessageLongTime:@"数据加载中..."];
    __block typeof (theDelegate)blockDelegate=theDelegate;
    NSString * requestStr = [NSString stringWithFormat:@"%@%@",Host_url,urlStr];
    //转换特殊地址（链接带汉字）
    NSString *resultStr = [requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(isNeed)
    {
        param = [ToolList getJSONDicByObject:param];
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"IOSTOKEN"])
        {
            param = [[NSMutableDictionary alloc] init];
            [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"IOSTOKEN"] forKey:@"token"];
        }
    }
    
    [afManager POST:resultStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //多个图片
        if (imageArray.count)
        {
            for (int i = 0; i < imageArray.count; i++)
            {
                UIImageView *imageV = [imageArray objectAtIndex:i];
                UIImage *image = imageV.image;
                NSData *imageData = UIImageJPEGRepresentation(image, .2);
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d",i] fileName:[NSString stringWithFormat:@"file_%d.jpg",i] mimeType:@"image/png"];
            }
        }
        if(voicePath && voicePath.length)
        {
            [formData appendPartWithFormData:[NSData dataWithContentsOfFile:voicePath] name:@"VoiceFile"];
            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:voicePath] name:@"VoiceFile" fileName:@"Mp3File.mp3" mimeType:@"application/octet-stream"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        [[mainWindow viewWithTag:8888] removeFromSuperview];
        NSError *err = nil;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
        if(err)
        {
            NSLog(@"json解析失败,可能数据格式不符合json");
        }
        else
        {
            if([[resultDic objectForKey:@"code"] intValue]==200)
            {
                [self doDelegate:blockDelegate method:success objct:resultDic];
            }
            else if([[resultDic objectForKey:@"code"] intValue]==600)
            {
                AppDelegate *de = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginVC *root =  [[LoginVC alloc] init];
                de.window.rootViewController = root;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[resultDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_REFRESH" object:nil];
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        [[mainWindow viewWithTag:8888] removeFromSuperview];
        NSLog(@"请求失败，错误：%@ 响应：%@",error,operation.responseString);
        //这里是程序员自定义自己的失误返回要操作的内容
        if(faild && faild.length)
        {
            [self doDelegate:blockDelegate method:faild objct:error];
        }
        else
        {
            [ToolList showRequestFaileMessageLittleTime:@"网络加载失败，请重试！"];
        }
    }];
}


//1张图片上传
-(void)postByUrlStr:(NSString *)urlStr andPramas:(NSMutableDictionary *)param andDelegate:(id)theDelegate andSuccess:(NSString *)success andFaild:(NSString *)faild andIsNeedCookies:(BOOL)isNeed andImageArray:(UIImage *)image{
    //统一的网络请求提示语
    [ToolList showRequestFaileMessageLongTime:@"数据加载中..."];
    __block typeof (theDelegate)blockDelegate=theDelegate;
    NSString * requestStr = [NSString stringWithFormat:@"%@",urlStr];
    //转换特殊地址（链接带汉字）
    NSString *resultStr = [requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [afManager POST:resultStr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, .5);
        [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file100"] fileName:[NSString stringWithFormat:@"file_%d.jpg",1000] mimeType:@"image/jpg"];
        
    }
     
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        [[mainWindow viewWithTag:8888] removeFromSuperview];
        NSError *err = nil;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
        
        
        if(err)
        {
            NSLog(@"json解析失败,可能数据格式不符合json");
        }
        else
        {
            if([[resultDic objectForKey:@"code"] intValue]==200)
            {
                [self doDelegate:blockDelegate method:success objct:resultDic];
            }
            else if([[resultDic objectForKey:@"code"] intValue]==600)
            {
                AppDelegate *de = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginVC *root =  [[LoginVC alloc] init];
                de.window.rootViewController = root;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[resultDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOP_REFRESH" object:nil];
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        [[mainWindow viewWithTag:8888] removeFromSuperview];
        NSLog(@"请求失败，错误：%@ 响应：%@",error,operation.responseString);
        //这里是程序员自定义自己的失误返回要操作的内容
        if(faild && faild.length)
        {
            [self doDelegate:blockDelegate method:faild objct:operation.responseString];
        }
        else
        {
            [ToolList showRequestFaileMessageLittleTime:@"网络加载失败，请重试！"];
        }
    }];
}

@end

