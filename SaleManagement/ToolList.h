//
//  ToolList.h
//  SaleManagement
//
//  Created by feixiang on 15/11/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol chooseDelegate <NSObject>

-(void)goVc:(id)vc;

-(void)presentedVC:(id)vc;

@end

@protocol typeDelegate <NSObject>

-(void)chooseType:(NSString *)type andTitle:(NSString *)title;

@end

//工具类
@interface ToolList : NSObject
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath;
//十六进制颜色转换,并带有透明度
+ (UIColor *)getColor:(NSString *)hexColor andAlpha:(float)pha;

//十六进制颜色转换
+ (UIColor *)getColor:(NSString *)hexColor;
//带透明值的十六进制颜色转换
+ (UIColor *)getAlphaColor:(NSString *)hexString;
//输出一条线
+(CAShapeLayer *)getLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andWeight:(CGFloat)weight andColorString:(NSString *)colorString;
//网络请求失败统一提示
/*!
 创造一个等待view
 
 @param message 要展示的字
 
 */
+ (void)showRequestFaileMessageLittleTime:(NSString *)message;
//长等待提示
+ (void)showRequestFaileMessageLongTime:(NSString *)message;
//字典或者数组转json字符串
+(NSMutableDictionary *)getJSONDicByObject:(id)object;
//转换null
+(NSString *)changeNull:(id)object;
+ (UIImage *)fixOrientation:(UIImage *)aImage ;

//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image;
//验证座机
int wiNSStringIsValidZJ(NSString *checkString);

/*!
 该函数是检测一串数字 是不是一个正常的手机号
 
 @param checkString  输入的要检验的String
 
 @return 返回 一个int 值 如果合法的 返回1 否则返回 0
 
 */

int wiNSStringIsValidPhone(NSString *checkString);

/*!
 该函数是检测一串数字 是不是一个正常的手机号+座机号
 
 @param checkString  输入的要检验的String
 
 @return 返回 一个int 值 如果合法的 返回1 否则返回 0
 
 */
int wiNSStringIsValidPhone_tel(NSString *checkString);

/*!
 判定是不是合法的Email 格式的字符串
 
 @param stricterFilter stricterFilter description
 @param checkString    要检测的字符串
 
 @return 合法的返回 YES 不合法返回No
 
 */

BOOL wiNSStringIsValidEmail(bool stricterFilter, NSString *checkString);


+(UIView *)showPopview:(CGRect)fram andTitleArr:(NSArray *)titleArr andTarget:(id)target;

//客户添加完成后是否返回意向客户
+(UIView *)goYixiangandTitle:(NSString *)title andTarget:(id)target;
//客户定位显示未搜索结果
+(void *)showPopview:(NSString *)titleSting andSubview:(UIView *)subview;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//验证纯数字
+ (BOOL)validateNumber:(NSString *) textString;
+(BOOL)validateNumbers:(NSString *) textString;

//自适应uitextview
+ (CGSize)contentSizeOfTextView:(UITextView *)textView;

@end
