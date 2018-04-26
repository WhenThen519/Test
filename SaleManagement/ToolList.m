//
//  ToolList.m
//  SaleManagement
//
//  Created by feixiang on 15/11/23.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "ToolList.h"

@implementation ToolList
//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//自适应uitextview
+ (CGSize)contentSizeOfTextView:(UITextView *)textView
{
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    
    
    return textViewSize;
}
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [ToolList fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

/*!
 将16 进制的字符串转化为对应的UIColor
 
 @param hexString 要输入的字符串  pha 为透明度
 
 @return 返回对应的UIColor
 
 */
+ (UIColor *)getColor:(NSString *)hexColor andAlpha:(float)pha
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:pha];
}

/*!
 将16 进制的字符串转化为对应的UIColor
 
 @param hexString 要输入的字符串
 
 @return 返回对应的UIColor
 
 */
+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
//转换带透明值的color
+ (UIColor *)getAlphaColor:(NSString *)hexString
{
    unsigned int red,green,blue,alpha;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&alpha];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    
    range.location = 6;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:(float)(alpha/255.0f)];
}
//输出一条线
+(CAShapeLayer *)getLineFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint andWeight:(CGFloat)weight andColorString:(NSString *)colorString
{
    CAShapeLayer *lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = weight;
    lineShape.lineCap = kCALineCapRound;;
    lineShape.strokeColor = [ToolList getColor:colorString].CGColor;
    CGFloat x = fromPoint.x;
    CGFloat y = fromPoint.y;
    
    CGFloat toX = toPoint.x;
    CGFloat toY = toPoint.y;
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    lineShape.path = linePath;
    return lineShape;
}
//网络请求失败统一提示
/*!
 创造一个等待view
 
 @param message 要展示的字
 @param view    要在哪个view 上进行展示
 
 */
+ (void)showRequestFaileMessageLittleTime:(NSString *)message {
    
    UILabel *messageLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 195, 50)];
    messageLable.text = message;
    messageLable.textColor = [UIColor whiteColor];
    messageLable.font = [UIFont boldSystemFontOfSize:13];
    messageLable.numberOfLines = 2;
    messageLable.backgroundColor = [UIColor grayColor];
    messageLable.textAlignment = NSTextAlignmentCenter;
    messageLable.layer.cornerRadius = 8;
    messageLable.layer.masksToBounds = YES;
    messageLable.tag = 9999;
    messageLable.center = CGPointMake(__MainScreen_Width/2., __MainScreen_Height/2.);
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:messageLable];
    [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [mainWindow viewWithTag:9999].alpha = 0.0;
    } completion:^(BOOL finished) {
        [[mainWindow viewWithTag:9999] removeFromSuperview];
    }];
}
//长等待提示
+(void)showRequestFaileMessageLongTime:(NSString *)message
{
    UILabel *messageLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 195, 50)];
    messageLable.text = message;
    messageLable.textColor = [UIColor whiteColor];
    messageLable.font = [UIFont boldSystemFontOfSize:13];
    messageLable.numberOfLines = 2;
    messageLable.backgroundColor = [UIColor grayColor];
    messageLable.textAlignment = NSTextAlignmentCenter;
    messageLable.layer.cornerRadius = 8;
    messageLable.layer.masksToBounds = YES;
    messageLable.tag = 8888;
    messageLable.center = CGPointMake(__MainScreen_Width/2., __MainScreen_Height/2.);
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    [mainWindow addSubview:messageLable];
}
//字典或者数组转json字符串包装成字典
+(NSMutableDictionary *)getJSONDicByObject:(id)object
{
    NSMutableDictionary *jsonDic = nil;
    //dict转jsonData
    NSError *err;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves   error:&err];
    if(err)
    {
        return jsonDic;
    }
    else
    {
        //jsonData转String
        NSString * jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsonDic = nil;
        jsonDic = [NSMutableDictionary dictionaryWithObject:jsonStr forKey:@"requestParams"];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"IOSTOKEN"])
        {
            [jsonDic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"IOSTOKEN"] forKey:@"token"];
        }
        
        return jsonDic;
    }
    
    
}
//转换null
+(NSString *)changeNull:(id)object
{
    NSString *result = nil;
    if([object isEqual:[NSNull null]]|| object == nil )
    {
        result = @"";
    }
    else
    {
        result = object;
    }
    return result;
}
//防止拍照反转
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image
{
    //压缩图片
    
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (150 / 150)) {
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - 150) / 2, 150, 150));
        
    } else {//横图
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - 150) / 2, 0, 150, 150));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}


/*!
 该函数是检测一串数字 是不是一个正常的手机号
 
 @param checkString  输入的要检验的String
 
 @return 返回 一个int 值 如果合法的 返回1 否则返回 0
 
 */

int wiNSStringIsValidPhone(NSString *checkString)
{
    /*!
     *描述不同公司手机号码规则的正则表达式
     *cmcc-中国移动手机号码规则
     *cucc-中国联通手机号码规则
     *cnc--中国网通3G手机号码规则
     */
    
    if (checkString == nil || [checkString isEqualToString:@""])
        return 0;
    
    if (checkString.length != 11)
        return 0;
    
    //    NSString *num = @"^((147)|(13\\d{1})|(15\\d{1})|(18\\d{1}))\\d{8}$";
    NSString *num = @"^1[0-9]{10}$";

    
    NSPredicate *cmccTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    if ([cmccTest evaluateWithObject:checkString])
    {
        return 1;
    }
 
    return 0;
}

/*!
 该函数是检测一串数字 是不是一个正常的手机号
 
 @param checkString  输入的要检验的String
 
 @return 返回 一个int 值 如果合法的 返回1 否则返回 0
 
 */

int wiNSStringIsValidPhone_tel(NSString *checkString)
{
    /*!
     *描述不同公司手机号码+电话规则的正则表达式
     */
    
    if (checkString == nil || [checkString isEqualToString:@""])
        return 0;

    NSString *num = @"^(0\\d{2,3}\\d{7,8}(\\d{3,5}){0,1})|1[0-9]{10}$";
    
    NSPredicate *cmccTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    if ([cmccTest evaluateWithObject:checkString])
    {
        return 1;
    }
    
    return 0;
}

int wiNSStringIsValidZJ(NSString *checkString)
{
    /*!
     *描述不同座机号码规则的正则表达式
    
     */
    
    if (checkString == nil || [checkString isEqualToString:@""])
        return 0;
    NSString *num = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
 
    NSPredicate *cmccTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    if ([cmccTest evaluateWithObject:checkString])
    {
        return 1;
    }
    
    return 0;
}
/*!
 判定是不是合法的Email 格式的字符串
 
 @param stricterFilter stricterFilter description
 @param checkString    要检测的字符串
 
 @return 合法的返回 YES 不合法返回No
 
 */

BOOL wiNSStringIsValidEmail(bool stricterFilter, NSString *checkString)
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:checkString])
    {
        return YES;
    }
    return NO;
}

+(UIView *)showPopview:(CGRect)fram andTitleArr:(NSArray *)titleArr andTarget:(id)target{
    
    UIView *writV = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.24+42, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-42-46)];
    writV.tag = 6839;
    writV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(SingleTap:)];
    //点击的次数
//    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [writV addGestureRecognizer:singleRecognizer];
    
    UIImageView *popV = [[UIImageView alloc]initWithFrame:CGRectMake(fram.origin.x+5,writV.frame.size.height-titleArr.count*45-15, fram.size.width-10, titleArr.count*45+15)];
    popV.image = [UIImage imageNamed:@"bg_bottom_cz_pop2.png"];
    popV.userInteractionEnabled = YES;

    [writV addSubview:popV];
    
    for (int i=0; i<titleArr.count; i++) {
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(0, i*45, popV.frame.size.width, 45);
        [bt setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        bt.tag = i;
        [bt setTitleColor:[self getColor:@"666666"] forState:UIControlStateNormal];
        [bt addTarget:target action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [popV addSubview:bt];
        
        if (i != titleArr.count-1) {
           [bt.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(20, bt.frame.size.height-0.5) toPoint:CGPointMake(bt.frame.size.width-20, bt.frame.size.height-0.5) andWeight:0.5 andColorString:@"dddddd"]];
        }
        
    }
    
    return writV;
}


+(void)showPopview:(NSString *)titleSting andSubview:(UIView *)subview{
  
    
    UILabel *writV = [[UILabel alloc]initWithFrame:CGRectMake(0, IOS7_Height+25, __MainScreen_Width,30)];
    writV.backgroundColor = [UIColor clearColor];
    writV.text = titleSting;
    writV.textColor = [self getColor:@"999999"];
    writV.font = [UIFont systemFontOfSize:14];
    writV.textAlignment = NSTextAlignmentCenter;
    
    [subview addSubview:writV];

}


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//验证纯数字
+ (BOOL)validateNumber:(NSString *) textString
{
//    NSString* number=@"(^0|^[1-9]\\d*).\\d{2}$";
    //验证非零的正整数：^\+?[1-9][0-9]*$
  //  正浮点数   ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$
    
    NSString *number = @"^[0-9]+([.]{0}|[.]{1}[0-9])$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    
    return [numberPre evaluateWithObject:textString];
}



+(BOOL)validateNumbers:(NSString *) textString

{
    NSString* number=@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

@end
