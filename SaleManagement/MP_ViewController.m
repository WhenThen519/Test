//
//  MP_ViewController.m
//  SaleManagement
//
//  Created by chaiyuan on 16/8/29.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "MP_ViewController.h"
#import "CY_chooseVc.h"
#import "CY_resembleVC.h"
#import "CY_popupV.h"
#import "CY_addClientVc.h"

@interface MP_ViewController (){
    
    NSMutableDictionary *dic;
    __weak IBOutlet NSLayoutConstraint *top;
    //    NSMutableArray *hArr;
    float textY;
    float goTextY;
    int jiaodu;
    UIImage *tempImage;
    float newTextY;
    UILabel *saxLabel;
    NSInteger btCount;//公司验证的TAG值
    
    NSMutableArray *yzCount;//已经验证过的公司
    
    NSMutableArray *namelArr;
    NSMutableArray *tellArr;
    NSMutableArray *phonelArr;
    NSMutableArray *faxlArr;
    NSMutableArray *emlArr;
    NSMutableArray *titlelArr;
    NSMutableArray *addlArr;
    NSMutableArray *comlArr;
    NSMutableArray *seplArr;
    NSMutableArray *labellArr;
    NSMutableArray *urllArr;
    NSMutableArray *QQlArr ;
    NSMutableArray *saxArr;
    NSMutableArray *wechatArr;

}
@property (weak, nonatomic) IBOutlet UIScrollView *wfx_MyScroll;

@property(nonatomic,strong)CY_popupV *popuV;

@property(nonatomic,strong)NSMutableArray *sected_custArr;//从已经验证好的公司里面选择部分或全部公司上传并保存。

@end

@implementation MP_ViewController
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return _bigImage;
}

-(void)leftAction{
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark---将数组拆分成字符串并用，拼接
-(NSString *)arr_str:(NSArray *)arr{
    
    NSString *arr_str;
    
    for (NSString *str in arr) {
        
        if (arr_str.length) {
            
            arr_str = [NSString stringWithFormat:@"%@,%@",arr_str,str];
        }else{
            arr_str = str;
        }
     
        
    }
    NSLog(@"-------%@----",arr_str);
    
    return arr_str;
}

#pragma mark---保存按钮
-(void)hei{
    
    
    if (namelArr.count==0) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请填写姓名！"];
        
        return;
    }
   
    else if (saxArr.count==0){
        
        [ToolList showRequestFaileMessageLittleTime:@"请选择性别！"];
   
        return;
    }
    
    else if (comlArr.count==0 ){
        
        [ToolList showRequestFaileMessageLittleTime:@"请填写正确公司名称！"];
        
        return;
    }
    
    else if (tellArr.count==0 && phonelArr.count==0){
        
        [ToolList showRequestFaileMessageLittleTime:@"请填写正确的手机号及座机！"];
        
        return;
    }
    
    else if ([[tellArr objectAtIndex:0] length]==0 && [[phonelArr objectAtIndex:0] length]==0){
        
        [ToolList showRequestFaileMessageLittleTime:@"请填写正确的手机号及座机！"];
        
        return;
    }
    
   else if (_custArr.count ==0) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请验证公司！"];
        
        return;
    }
 

    
    else if (_sected_custArr.count==0 && _custArr.count>1){
        
        CY_popupV *puView= [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andMyNameArr:_custArr andtarget:self andTag:_custArr.count ];
        [self.view addSubview:puView];
        
        return;
    }
    
   else if (titlelArr.count >1) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请保留一个职位！"];
        
        return;
    }
    else if (addlArr.count>1){
        
        [ToolList showRequestFaileMessageLittleTime:@"请保留一个地址！"];
        
        return;
    }
    
   else if (seplArr.count >1) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请保留一个部门！"];
            
        return;
    }
    else if (labellArr.count>1){
        
        [ToolList showRequestFaileMessageLittleTime:@"请保留一个邮编！"];
        
        return;
    }
    
    else if (labellArr.count && ![ToolList validateNumbers:[labellArr objectAtIndex:0 ]]) {
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入正确的邮编！"];
        return;
    }
   
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    //联系人名称，如有多个，逗号隔开即可-String类型
    requestDic[@"linkManName"]=[self arr_str:namelArr];
    //手机号，如有多个，逗号隔开即可-String类型
    requestDic[@"mobilephone"]=[self arr_str:tellArr];
    //座机号，如有多个，逗号隔开即可-String类型
    requestDic[@"telephone"]=[self arr_str:phonelArr];
   // 传真号，如有多个，逗号隔开即可-String类型
    requestDic[@"fax"]=[self arr_str:faxlArr];
   // 邮箱地址，如有多个，逗号隔开即可-String类型
    requestDic[@"email"]=[self arr_str:emlArr];
    //QQ号，如有多个，逗号隔开即可-String类型
    requestDic[@"qq"]=[self arr_str:QQlArr];
    //网址，如有多个，逗号隔开即可-String类型
    requestDic[@"website"]=[self arr_str:urllArr];
    //客户ID（custId）和客户名称（custName），使用字典数组（List<Map>）的形式传给后台
    if (_custArr.count==1) {
          requestDic[@"custInfo"]= _custArr;
    }else{
        
          requestDic[@"custInfo"]= _sected_custArr;
    }
  
    //微信,多个逗号隔开，String类型
    requestDic[@"wechat"]=@"";
    
  //  --以下参数，均是单一，不存在多个值
    //性别 1：先生 2：女士
    requestDic[@"sex"]= [self arr_str:saxArr];
    //部门
    requestDic[@"dept"]=[self arr_str:seplArr];
    //职位
    requestDic[@"position"]=[self arr_str:titlelArr];
    //邮编
    requestDic[@"zipCode"]=[self arr_str:labellArr];
    //地址
    requestDic[@"address"]=[self arr_str:addlArr];
    //是否添加为常用联系人  flag=0 不设为常用联系人  flag=1设为常用联系人
    requestDic[@"flag"]=[NSNumber numberWithInteger:0];
    
    [FX_UrlRequestManager postByUrlStr:ContactScan_url andPramas:requestDic andDelegate:self andSuccess:@"ContactScanSuccess:" andFaild:nil andIsNeedCookies:YES];

}

#pragma mark---保存客户成功
-(void)ContactScanSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue]==200) {

        [self.navigationController popViewControllerAnimated:NO];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    top.constant = IOS7_Height;
   dic = [[NSMutableDictionary alloc]init];
    
    if (_custArr == nil) {
        
        _custArr = [[NSMutableArray alloc]init];
    }

    yzCount = [[NSMutableArray alloc]init];
    
    _sected_custArr = [[NSMutableArray alloc]init];
    
    //改变验证按钮的状态---添加客户完成返回页面执行此方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changetype:) name:@"YANZHENGOK" object:nil];
    
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self addNavgationbar:@"添加联系人" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"保存" leftHiden:NO rightHiden:YES];

    [self addNavgationbar:@"添加联系人" leftBtnName:@"" rightBtnName:@"保存" target:self leftBtnAction:@"leftAction" rightBtnAction:@"hei"];
     tempImage = [self OriginImage:[ToolList fixOrientation:_photoImage] scaleToSize:CGSizeMake(1000, 1000)];
    _bigImage.image = tempImage;
    
    //解析数据
     [self parseVCardString:_vcardString];
  
}


#pragma mark---改变按钮状态（验证通过）
-(void)changetype:(NSNotification *)notification{
    
    [yzCount replaceObjectAtIndex:btCount-100 withObject:[NSNumber numberWithInt:1]];
    
    UIView *view = [_view3.subviews objectAtIndex:btCount-100];
    
    UIButton *yzBt = (UIButton *)[view viewWithTag:btCount];
    
    [ yzBt setImage:[UIImage imageNamed:@"iconfont-chenggong.png"] forState:UIControlStateNormal];
    [yzBt setTitle:@"" forState:UIControlStateNormal];
    yzBt.enabled = NO;
    
    NSDictionary* user_info = [notification object];
    
    if (user_info.count) {
   
        [_custArr addObject:user_info];
      
//            NSString *custID = [user_info objectForKey:@"custId"];
//            NSString *comStr = [user_info objectForKey:@"custName"];
    
    }

}


//处理图片230*230
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


//解析vcf
-(void)parseVCardString:(NSString*)vcardString
{
    NSArray *lines = [vcardString componentsSeparatedByString:@"\n"];
    
    namelArr = [[NSMutableArray alloc]init];
    tellArr = [[NSMutableArray alloc]init];
    phonelArr = [[NSMutableArray alloc]init];
    faxlArr = [[NSMutableArray alloc]init];
    emlArr = [[NSMutableArray alloc]init];
    titlelArr = [[NSMutableArray alloc]init];
    addlArr = [[NSMutableArray alloc]init];
    comlArr = [[NSMutableArray alloc]init];
    seplArr = [[NSMutableArray alloc]init];
    labellArr = [[NSMutableArray alloc]init];
    urllArr = [[NSMutableArray alloc]init];
    QQlArr = [[NSMutableArray alloc]init];
    saxArr = [[NSMutableArray alloc]init];
    wechatArr =[[NSMutableArray alloc]init];
    
    for(NSString* line in lines)
    {
        
        if ([line hasPrefix:@"BEGIN"])
        {
            NSLog(@"parse start");
        }
        else if ([line hasPrefix:@"END"])
        {
            NSLog(@"parse end");
        }
        else if ([line hasPrefix:@"X-IS-ANGLE:"])
        {
           jiaodu = [[line substringFromIndex:11] intValue];
            if (jiaodu == 90) {
                _bigImage.image = [UIImage imageWithCGImage:tempImage.CGImage scale:1 orientation:UIImageOrientationLeft];

            }
            else if (jiaodu == 180)
            {
                _bigImage.image = [UIImage imageWithCGImage:tempImage.CGImage scale:1 orientation:UIImageOrientationDown];
                
            }
            else if (jiaodu == 270)
            {
                _bigImage.image = [UIImage imageWithCGImage:tempImage.CGImage scale:1 orientation:UIImageOrientationRight];
                
            }

        }
        else if ([line hasPrefix:@"FN;"])
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            
            if (upperComponents.count >1) {
                
                NSString *nameStr =[upperComponents objectAtIndex:1] ;
                
                NSLog(@"姓名 %@",nameStr);
                nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if (nameStr.length) {
                    
                    [namelArr addObject:nameStr];
                }
            }
        }
        
        else if ([line hasPrefix:@"ORG;"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            NSString *phoneNumber = [components objectAtIndex:1];
            phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSArray *components2 = [phoneNumber componentsSeparatedByString:@";"];
            
            //公司
            NSString *comStr = [components2 objectAtIndex:0];
            //部门
            NSString *sepStr = [components2 objectAtIndex:1];
            
            if (comStr.length) {
                
                if (_custArr.count) {
                    
                    [comlArr addObject:[[_custArr objectAtIndex:0] objectForKey:@"custName"]];
                    
                    break;
                }
                
                    if([[dic allKeys] containsObject:@"公司"]){
                        
                        NSString *str = [dic objectForKey:@"公司"];
                        
                        if (str.length < comStr.length) {
                            
                            [comlArr addObject:comStr];
                        }
                        
                    }else
                        [comlArr addObject:comStr];
                    
                    NSLog(@"公司 %@++",comStr);
              
            }
            if (sepStr.length) {
                
                [seplArr addObject:sepStr];
                   NSLog(@"部门---%@++",sepStr);
            }
            
         
            
        }
        else if ([line hasPrefix:@"TEL;CELL"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            NSString *phoneNumber = [components objectAtIndex:1];
                        NSLog(@"手机 %@",phoneNumber);
            phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            if (phoneNumber.length) {
                
                [tellArr addObject:phoneNumber];
            }
            
        }
        
        else if ([line hasPrefix:@"X-MS-IMADDRESS"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            NSString *phoneNumber = [components objectAtIndex:1];
            NSLog(@"QQ %@",phoneNumber);
            phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            
            if (phoneNumber.length) {
                
                [QQlArr addObject:phoneNumber];
            }
            
        }
        
        else if ([line hasPrefix:@"TEL;WORK;VOICE"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            NSString *phoneNumber = [components objectAtIndex:1];
            NSLog(@"座机 %@++",phoneNumber);
            phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉\n
            phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            
            if (phoneNumber.length) {
                
                [phonelArr addObject:phoneNumber];
            }

        }
        
        else if ([line hasPrefix:@"TEL;WORK;FAX"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            NSString *phoneNumber = [components objectAtIndex:1];
            phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"传真 %@",phoneNumber);
            
            if (phoneNumber.length) {
                
                [faxlArr addObject:phoneNumber];
            }

        }
        
        
        else if ([line hasPrefix:@"EMAIL;"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            NSString *emailAddress = [components objectAtIndex:1];
            NSLog(@"邮箱 %@",emailAddress);
            
            emailAddress = [emailAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (emailAddress.length) {
                
                [emlArr addObject:emailAddress];
            }
            
        }
        
        else if ([line hasPrefix:@"TITLE;"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            NSString *phoneNumber = [components objectAtIndex:1];
            phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"职位 %@",phoneNumber);
            
            if (phoneNumber.length) {
                
                [titlelArr addObject:phoneNumber];
            }

        }
        
        
        else if ([line hasPrefix:@"ADR;WORK"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            if (components.count>0) {
                
                NSString *phoneNumber = [components objectAtIndex:1];
                
                phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
               
                if (phoneNumber.length) {
                    
                    [addlArr addObject:phoneNumber];
                }
                NSLog(@"地址：%@",phoneNumber);
                
            }
            
        }
        
        else if ([line hasPrefix:@"LABEL;WORK"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            if (components.count>0) {
                
                NSString *phoneNumber = [components objectAtIndex:1];
                
                phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if (phoneNumber.length) {
                    
                    [labellArr addObject:phoneNumber];
                }
                NSLog(@"邮编：%@",phoneNumber);
                
            }
            
            
        }
        
        else if ([line hasPrefix:@"X-IS-SNS"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            if (components.count>1) {
                
                NSString *phoneNumber = [components objectAtIndex:2];
                
                phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if (phoneNumber.length) {
                    
                    [wechatArr addObject:phoneNumber];
                }
                NSLog(@"微信：%@",phoneNumber);
                
            }
            
            
        }
        

        
        else if ([line hasPrefix:@"URL;WORK"])
        {
            NSArray *components = [line componentsSeparatedByString:@":"];
            
            if (components.count>0) {
                
                NSString *phoneNumber = [components objectAtIndex:1];
                
                phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                if (phoneNumber.length) {
                    
                    [urllArr addObject:phoneNumber];
                }
                NSLog(@"网址：%@",phoneNumber);
                
            }
            
            
        }
    }
    [self addDic:namelArr andKey:@"姓名"];
    [self addDic:tellArr andKey:@"手机"];
     [self addDic:phonelArr andKey:@"座机"];
     [self addDic:faxlArr andKey:@"传真"];
     [self addDic:emlArr andKey:@"邮箱"];
     [self addDic:titlelArr andKey:@"职位"];
     [self addDic:addlArr andKey:@"地址"];
    [self addDic:comlArr andKey:@"公司"];
    [self addDic:seplArr andKey:@"部门"];
    [self addDic:urllArr andKey:@"网址"];
    [self addDic:labellArr andKey:@"邮编"];
    [self addDic:QQlArr andKey:@"QQ"];
    [self addDic:wechatArr andKey:@"微信"];
    
    [dic setObject:saxArr forKey:@"性别"];
    
    if (_custArr.count) {
        
        for (NSString *str in comlArr) {
            [yzCount addObject:[NSNumber numberWithInt:1]];
        }
        
    }else{
        
        //验证按钮初始化为0，0为未验证，1为已验证成功
        for (NSString *str in comlArr) {
            [yzCount addObject:[NSNumber numberWithInt:0]];
        }
    }
   
    
    [self makeView:dic];
    
}

#pragma mark ---把多个数据放到总数据源DIc中
-(void)addDic:(NSMutableArray *)arr andKey:(NSString *)key{
    
    if (arr.count) {
    
        [dic setObject:arr forKey:key];
    }else{
        [arr addObject:@""];
        [dic setObject:arr forKey:key];
    }
}

-(void)goSax:(id)sender{
    
    //性别
    CY_chooseVc *v = [[CY_chooseVc alloc]init];
    v.automaticallyAdjustsScrollViewInsets = NO;
    v.changeBlock = ^(NSString * str)
    {
        saxLabel.text = str;
         [saxArr removeAllObjects];
        if ([str isEqualToString:@"男"]) {
            [saxArr addObject:[NSNumber numberWithInteger:1]];
        }else{
             [saxArr addObject:[NSNumber numberWithInteger:2]];
        }
    };
    v.titleStr = @"选择性别";
    v.dataArr = [[NSMutableArray alloc]initWithObjects:@"男",@"女", nil];
    [self.navigationController pushViewController:v animated:NO];
}

#pragma mark ---计算13项中每个高度并初始化页面
-(void)makeView:(NSMutableDictionary *)viewDic{
    
    for (int i=0; i<14; i++) {
        
        switch (i) {
            case 0:
            {
                
                if([[dic allKeys] containsObject:@"姓名"]){
                    
                    NSArray *arr = [dic objectForKey:@"姓名"];
                   _viewH1.constant = [self andMakeArr:arr andKey:@"姓名" andSupView:_view1];
                    
                }else{
                    [self removeSubview:_view1];
                    _viewH1.constant=0.0f;
                }

              
            }
                break;
                
            case 1:
            {
                [self removeSubview:_view2];
                
              UIView *  bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 54)];
                bgView.backgroundColor = [UIColor clearColor];
                [_view2 addSubview:bgView];
                
                [bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, bgView.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, bgView.frame.size.height-0.5) andWeight:0.5 andColorString:@"dddddd"]];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 37, 16)];
                label.text = @"性别";
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = [ToolList getColor:@"9b9b9b"];
                [bgView addSubview:label];
                
                saxLabel = [[UILabel alloc]initWithFrame:CGRectMake(IOS7_Height, 18, __MainScreen_Width-84, 16)];
                saxLabel.textColor = [ToolList getColor:@"666666"];
                saxLabel.font = [UIFont systemFontOfSize:16];
                saxLabel.backgroundColor = [UIColor clearColor];
                [bgView addSubview:saxLabel];
                
                UIButton *delBt = [UIButton buttonWithType:UIButtonTypeCustom];
                delBt.frame = CGRectMake(0, 0, bgView.frame.size.width-10, bgView.frame.size.height);
                [delBt setImage:[UIImage imageNamed:@"btn_open.png"] forState:UIControlStateNormal];
                [delBt addTarget:self action:@selector(goSax:) forControlEvents:UIControlEventTouchUpInside];
                 [delBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [bgView addSubview:delBt];
                
                _viewH2.constant = 54;
                
            }
                break;
            case 2:
            {
                if([[dic allKeys] containsObject:@"公司"]){
                    
                    NSArray *arr = [dic objectForKey:@"公司"];
                   _viewH3.constant = [self andMakeArr:arr andKey:@"公司" andSupView:_view3];
                }else{
                    [self removeSubview:_view3];
                    _viewH3.constant=0.0f;
                }
                
              
            }
                break;
            case 3:
            {
                 if([[dic allKeys] containsObject:@"手机"]){
                     
                     NSArray *arr = [dic objectForKey:@"手机"];
                   _viewH4.constant =  [self andMakeArr:arr andKey:@"手机" andSupView:_view4];
                 }else{
                      [self removeSubview:_view4];
                     _viewH4.constant=0.0f;
                 }
            }
                break;
            case 4:
            {
                 if([[dic allKeys] containsObject:@"座机"]){
                     
                     NSArray *arr = [dic objectForKey:@"座机"];
                    _viewH5.constant = [self andMakeArr:arr andKey:@"座机" andSupView:_view5];
                 }else{
                      [self removeSubview:_view5];
                     _viewH5.constant=0.0f;
                 }
            }
                break;
            case 5:
            {
                 if([[dic allKeys] containsObject:@"邮箱"]){
                     
                     NSArray *arr = [dic objectForKey:@"邮箱"];
                     _viewH6.constant =[self andMakeArr:arr andKey:@"邮箱" andSupView:_view6];
                 }else{
                      [self removeSubview:_view6];
                     _viewH6.constant=0.0f;
                 }
            }
                break;
            case 6:
            {
                 if([[dic allKeys] containsObject:@"QQ"]){
                     
                     NSArray *arr = [dic objectForKey:@"QQ"];
                    _viewH7.constant = [self andMakeArr:arr andKey:@"QQ" andSupView:_view7];
                 }else{
                       [self removeSubview:_view7];
                     _viewH7.constant=0.0f;
                 }
            }
                break;
            case 7:
            {
                  if([[dic allKeys] containsObject:@"部门"]){
                      
                      NSArray *arr = [dic objectForKey:@"部门"];
                     _viewH8.constant = [self andMakeArr:arr andKey:@"部门" andSupView:_view8];
                  }
                  else{
                       [self removeSubview:_view8];
                      _viewH8.constant=0.0f;
                  }
            }
                break;
            case 8:
            {
                 if([[dic allKeys] containsObject:@"职位"]){
                     
                     NSArray *arr = [dic objectForKey:@"职位"];
                     _viewH9.constant =[self andMakeArr:arr andKey:@"职位" andSupView:_view9];
                 }else{
                       [self removeSubview:_view9];
                     _viewH9.constant=0.0f;
                 }
            }
                break;
            case 9:
            {
                 if([[dic allKeys] containsObject:@"地址"]){
                     
                     NSArray *arr = [dic objectForKey:@"地址"];
                     _viewH10.constant =[self andMakeArr:arr andKey:@"地址" andSupView:_view10];
                 }else{
                      [self removeSubview:_view10];
                     _viewH10.constant=0.0f;
                 }
            }
                break;
                
            case 10:
            {
                if([[dic allKeys] containsObject:@"邮编"]){
                    
                    NSArray *arr = [dic objectForKey:@"邮编"];
                    _viewH11.constant =[self andMakeArr:arr andKey:@"邮编" andSupView:_view11];
                }else{
                   
                    [self removeSubview:_view11];
                    
                    _viewH11.constant=0.0f;
                }
            }
                break;
                
            case 11:
            {
                 if([[dic allKeys] containsObject:@"传真"]){
                     
                     NSArray *arr = [dic objectForKey:@"传真"];
                    _viewH12.constant = [self andMakeArr:arr andKey:@"传真" andSupView:_view12];
                 }else{
                      [self removeSubview:_view12];
                     _viewH12.constant=0.0f;
                 }
            }
                break;
                
            case 12:
            {
                if([[dic allKeys] containsObject:@"网址"]){
                    
                    NSArray *arr = [dic objectForKey:@"网址"];
                    _viewH13.constant =[self andMakeArr:arr andKey:@"网址" andSupView:_view13];
                }else{
                     [self removeSubview:_view13];
                    _viewH13.constant=0.0f;
                }
            }
                break;
                
            case 13:
            {
                if([[dic allKeys] containsObject:@"微信"]){
                    
                    NSArray *arr = [dic objectForKey:@"微信"];
                    _viewH14.constant =[self andMakeArr:arr andKey:@"微信" andSupView:_view14];
                }else{
                    [self removeSubview:_view14];
                    _viewH14.constant=0.0f;
                }
            }
                break;

                
            default:
                break;
        }

    }
    
    _myViewH.constant =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+_viewH8.constant+_viewH9.constant+_viewH10.constant+_viewH11.constant+_viewH12.constant+_viewH13.constant+_viewH14.constant;
    
    _MyScroll.contentSize = CGSizeMake(__MainScreen_Width,  _myViewH.constant);
    
//      NSLog(@"_____________1=%f----2=%f--3=%f--4=%f--5=%f--6=%f--7=%f--8=%f--9=%f--10=%f--11=%f--12=%f----%f",_viewH1.constant,_viewH2.constant,_viewH3.constant,_viewH4.constant,_viewH5.constant,_viewH6.constant,_viewH7.constant,_viewH8.constant,_viewH9.constant,_viewH10.constant,_viewH11.constant,_viewH12.constant,_Myview.frame.size.height);
}

//出现多个的情况
-(CGFloat)andMakeArr:(NSArray *)makeArr andKey:(NSString *)key andSupView:(UIView *)supView{
   
    [self removeSubview:supView];
    
    if (makeArr.count>1) {
       
        float hhh =0.0f;
        
        for (int i=0; i<makeArr.count; i++) {
            
            float widthStr =0.0f;
            
            if ([key isEqualToString:@"公司"]) {
                
                widthStr = __MainScreen_Width-(IOS7_Height+10+98);
            }else{
                widthStr = __MainScreen_Width-(IOS7_Height+10+35);
            }
            
            CGSize  size = [[makeArr objectAtIndex:i] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake( widthStr, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
            UIView *bgView = [[UIView alloc]init];
            bgView.backgroundColor = [UIColor clearColor];
            [supView addSubview:bgView];
            
            
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(IOS7_Height, 17, widthStr, size.height)];
             textView.delegate = self;
            if ([key isEqualToString:@"手机"]){
                textView.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
            }
            textView.textContainerInset = UIEdgeInsetsZero;
            textView.backgroundColor = [UIColor clearColor];
            textView.text = [makeArr objectAtIndex:i];
            textView.textColor = [ToolList getColor:@"666666"];
            textView.font = [UIFont systemFontOfSize:16];
            [bgView addSubview:textView];
            [self andKey:key andBT:textView andCount:i];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, textView.frame.origin.y+2, 45, 16)];
            label.text = [NSString stringWithFormat:@"%@%d",key,i+1];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [ToolList getColor:@"9b9b9b"];
            [bgView addSubview:label];
            
            
            bgView.frame = CGRectMake(0, hhh, __MainScreen_Width, 34+size.height);
            
            [bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, bgView.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, bgView.frame.size.height-0.5) andWeight:0.5 andColorString:@"dddddd"]];
            
            if ([key isEqualToString:@"公司"]){
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(__MainScreen_Width-108, (bgView.frame.size.height-34)/2, 73, 34);
                button.tag = i+100;
                if ([[yzCount objectAtIndex:i] intValue]==1) {
                    
                    [button setImage:[UIImage imageNamed:@"iconfont-chenggong.png"] forState:UIControlStateNormal];
                    [button setTitle:@"" forState:UIControlStateNormal];
                    button.enabled = NO;
                    
                }else{
                    [button setTitle:@"验证" forState:UIControlStateNormal];
                }
                [button addTarget:self action:@selector(YZbt:) forControlEvents:UIControlEventTouchUpInside];
                button.backgroundColor = [ToolList getColor:@"7fd321"];
                [bgView addSubview:button];
                
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 4.0;
                
            }

                
                UIButton *delBt = [UIButton buttonWithType:UIButtonTypeCustom];
                delBt.frame= CGRectMake(__MainScreen_Width-40, (bgView.frame.size.height-30)/2, 30, 30);
                [delBt addTarget:self action:@selector(delTouch:) forControlEvents:UIControlEventTouchUpInside];
                [delBt setImage:[UIImage imageNamed:@"X关闭.png"] forState:UIControlStateNormal];
                [bgView addSubview:delBt];
        
             [self andKey:key andBT:delBt andCount:i];
            
             hhh += size.height+34;
        }
        
        return hhh;


    }else{
        
        float widthStr =0.0f;
        
        if ([key isEqualToString:@"公司"]) {
            widthStr = __MainScreen_Width-(IOS7_Height+10+88);
        }
        else if ([key isEqualToString:@"姓名"]||[key isEqualToString:@"手机"]||[key isEqualToString:@"座机"]){
            
          widthStr = __MainScreen_Width-(IOS7_Height+10);
        }
        else{
             widthStr = __MainScreen_Width-(IOS7_Height+10+35);
        }
        
        CGSize  size = [[makeArr objectAtIndex:0] sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(widthStr, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 34+size.height)];
        bgView.backgroundColor = [UIColor clearColor];
        [supView addSubview:bgView];
        
        
        [bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, bgView.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width, bgView.frame.size.height-0.5) andWeight:0.5 andColorString:@"dddddd"]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 37, 16)];
        label.text = key;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [ToolList getColor:@"9b9b9b"];
        [bgView addSubview:label];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(IOS7_Height, 17, widthStr, size.height)];
        textView.delegate = self;
        if ([key isEqualToString:@"手机"]){
            textView.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        }
        textView.backgroundColor = [UIColor clearColor];
         textView.textContainerInset = UIEdgeInsetsZero;
        textView.text = [makeArr objectAtIndex:0];
        textView.textColor = [ToolList getColor:@"666666"];
        textView.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:textView];
        [self andKey:key andBT:textView andCount:0];
        
        if ([key isEqualToString:@"公司"]){
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(__MainScreen_Width-98, (bgView.frame.size.height-34)/2, 88, 34);
            [button addTarget:self action:@selector(YZbt:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100;
            if ([[yzCount objectAtIndex:0] intValue]==1) {
                
                [button setImage:[UIImage imageNamed:@"iconfont-chenggong.png"] forState:UIControlStateNormal];
                [button setTitle:@"" forState:UIControlStateNormal];
                button.enabled = NO;
                
            }else{
                [button setTitle:@"验证" forState:UIControlStateNormal];
            }

            button.backgroundColor = [ToolList getColor:@"7fd321"];
            [bgView addSubview:button];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.0;
            
        }else{
            
            if ((![key isEqualToString:@"姓名"]) && (![key isEqualToString:@"手机"]) && (![key isEqualToString:@"座机"])){
                
                UIButton *delBt = [UIButton buttonWithType:UIButtonTypeCustom];
                delBt.frame= CGRectMake(__MainScreen_Width-40, (bgView.frame.size.height-30)/2, 30, 30);
                [delBt addTarget:self action:@selector(delTouch:) forControlEvents:UIControlEventTouchUpInside];
                [delBt setImage:[UIImage imageNamed:@"X关闭.png"] forState:UIControlStateNormal];
                [bgView addSubview:delBt];
                
                [self andKey:key andBT:delBt andCount:0];
                
            }
           
        }
        
         return size.height+34;
    }
    
    return 0;
 
}

#pragma  mark---验证公司
-(void)YZbt:(UIButton *)yZbt{

    btCount =yZbt.tag;
    NSString *str = [ [dic objectForKey:@"公司"] objectAtIndex:btCount-100];
    if (str.length==0) {
        NSLog(@"请填写正确的公司进行验证！");
        return;
    }
    
    NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
    requestDic[@"custName"]= str;
    
    [FX_UrlRequestManager postByUrlStr:checkCustScan_url andPramas:requestDic andDelegate:self andSuccess:@"checkCustSuccess:" andFaild:nil andIsNeedCookies:YES];
}

#pragma mark---公司验证成功
-(void)checkCustSuccess:(NSDictionary *)dicc{
    
    int forward = [[dicc objectForKey:@"forward"] intValue];
    
    switch (forward) {
        case 0:
        {
            //0：错误提示
            
        }
            break;
            
        case 1:
        {
            //1：跳转到查询相似客户页面
            
            if ([[dicc objectForKey:@"isOwn"] intValue]==1) {
                //isOwn==1 代表为我的客户，0为非我的客户
                [yzCount replaceObjectAtIndex:btCount-100 withObject:[NSNumber numberWithInt:1]];
                
                UIView *view = [_view3.subviews objectAtIndex:btCount-100];
                UIButton *yzBt = (UIButton *)[view viewWithTag:btCount];
                
                [yzBt setImage:[UIImage imageNamed:@"iconfont-chenggong.png"] forState:UIControlStateNormal];
                [yzBt setTitle:@"" forState:UIControlStateNormal];
                yzBt.enabled = NO;
                
                
               NSString *custID = [dicc objectForKey:@"custId"];
                NSString *str = [ [dic objectForKey:@"公司"] objectAtIndex:btCount-100];
                NSDictionary *custDic = [NSDictionary dictionaryWithObjectsAndKeys:custID,@"custId",str,@"custName", nil];
                [_custArr addObject:custDic];
         
                
            }else{
                
                NSString *str = [ [dic objectForKey:@"公司"] objectAtIndex:btCount-100];
                CY_resembleVC *v = [[CY_resembleVC alloc]init];
                v.textString = str;
                [self.navigationController pushViewController:v animated:NO];
            }
            
        }
            break;
            
        case 2:
        {
            //2：跳转到新增客户页面
            
            _popuV = [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andMessage:@"客户不存在，您可以添加客户" andBtTitel:@"添加客户" andtarget:self andTag:forward];
            
            [self.view addSubview:_popuV];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)goAddView:(id)sender{
    
    NSLog(@"去往添加客户页面");
    [_popuV removeFromSuperview];
   
    CY_addClientVc *ghVC = [[CY_addClientVc alloc]init];
    NSString *str = [ [dic objectForKey:@"公司"] objectAtIndex:btCount-100];
    ghVC.isMP = YES;
    ghVC.comString = str;
    [self.navigationController pushViewController:ghVC animated:NO];
}

#pragma mark---刷新时用于删除原来的旧页面
-(void)removeSubview:(UIView *)subView{
    
    for (UIView *view in subView.subviews) {
        
        if(view)
        {
            [view removeFromSuperview];
        }
    }
}

#pragma mark---根据KEY的固定顺序给删除按钮添加TAG值
-(void)andKey:(NSString *)key andBT:(id)delButton  andCount:(int)i{
    
    UITextView *textView;
    UIButton *delBt;
  
    if ([delButton isKindOfClass:[UIButton class]]) {
        delBt = (UIButton *)delButton;
        
    }
   else{
        textView = (UITextView *)delButton;
    }
    
    if ([key isEqualToString:@"姓名"]) {
        textView.tag =100+i;
        delBt.tag = 100+i;
    
    }
    else if ([key isEqualToString:@"公司"]) {
        textView.tag =300+i;
        delBt.tag = 300+i;
  
    }
    else if ([key isEqualToString:@"手机"]) {
        textView.tag =400+i;
        delBt.tag = 400+i;
        
    }else if ([key isEqualToString:@"座机"]) {
        textView.tag =500+i;
        delBt.tag = 500+i;
        
    }else if ([key isEqualToString:@"邮箱"]) {
        textView.tag =600+i;
        delBt.tag = 600+i;
       
    }else if ([key isEqualToString:@"QQ"]) {
       textView.tag =700+i;
        delBt.tag = 700+i;
        
    }else if ([key isEqualToString:@"部门"]) {
        textView.tag =800+i;
        delBt.tag = 800+i;
        
    }else if ([key isEqualToString:@"职位"]) {
        textView.tag =900+i;
        delBt.tag = 900+i;
       
    }else if ([key isEqualToString:@"地址"]) {
        textView.tag =1000+i;
        delBt.tag = 1000+i;
       
    }else if ([key isEqualToString:@"邮编"]) {
        textView.tag =1100+i;
        delBt.tag = 1100+i;
        
    }else if ([key isEqualToString:@"传真"]) {
        textView.tag =1200+i;
        delBt.tag = 1200+i;
        
    }else if ([key isEqualToString:@"网址"]) {
        textView.tag =1300+i;
        delBt.tag = 1300+i;
       
    }
    

}

#pragma mark---删除按钮的点击事件
-(void)delTouch:(UIButton *)delBt{
    
    int count = delBt.tag/100;//通过此数据可以知道对应的哪个KEY，比如1对应姓名，2对应性别，以此类推
    int yuCount = delBt.tag%100;//通过此数据可以知道每个KEY下面对应的第几个表格
    
    switch (count) {
        case 1:
        {
            [self removeArrAndKey:@"姓名" andCont:yuCount];
            [namelArr removeObjectAtIndex:yuCount];
        }
            break;
      
        case 3:
        {
            [self removeArrAndKey:@"公司" andCont:yuCount];
            [comlArr removeObjectAtIndex:yuCount];
        }
            break;
        case 4:
        {
            [self removeArrAndKey:@"手机" andCont:yuCount];
             [tellArr removeObjectAtIndex:yuCount];
        }
            break;
        case 5:
        {
            [self removeArrAndKey:@"座机" andCont:yuCount];
             [phonelArr removeObjectAtIndex:yuCount];
        }
            break;
        case 6:
        {
            [self removeArrAndKey:@"邮箱" andCont:yuCount];
             [emlArr removeObjectAtIndex:yuCount];
        }
            break;
        case 7:
        {
            [self removeArrAndKey:@"QQ" andCont:yuCount];
             [QQlArr removeObjectAtIndex:yuCount];
        }
            break;
        case 8:
        {
            [self removeArrAndKey:@"部门" andCont:yuCount];
             [seplArr removeObjectAtIndex:yuCount];
        }
            break;
        case 9:
        {
            [self removeArrAndKey:@"职位" andCont:yuCount];
             [titlelArr removeObjectAtIndex:yuCount];
        }
            break;
        case 10:
        {
            [self removeArrAndKey:@"地址" andCont:yuCount];
             [addlArr removeObjectAtIndex:yuCount];
        }
            break;
        case 11:
        {
            [self removeArrAndKey:@"邮编" andCont:yuCount];
             [labellArr removeObjectAtIndex:yuCount];
        }
            break;
        case 12:
        {
            [self removeArrAndKey:@"传真" andCont:yuCount];
             [faxlArr removeObjectAtIndex:yuCount];
        }
            break;
        case 13:
        {
            [self removeArrAndKey:@"网址" andCont:yuCount];
             [urllArr removeObjectAtIndex:yuCount];
        }
            break;
            
            
        default:
            break;
    }
    
    [self makeView:dic];
}

#pragma mark---点击删除修改数据源
-(void)removeArrAndKey:(NSString *)keyStr andCont:(int)count{
    
    NSArray *arr = [dic objectForKey:keyStr];
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:arr];
    if (mutableArr.count==1) {
        [mutableArr removeAllObjects];
        [dic removeObjectForKey:keyStr];

    }else{
        [mutableArr removeObjectAtIndex:count];
        [dic setObject:mutableArr forKey:keyStr];
    }
    
}

#pragma mark---点击TEXTVIEW修改数据源
-(void)changeArrAndKey:(NSString *)keyStr andCount:(NSInteger)count andArr:(NSMutableArray *)mutableArr andText:(NSString *)textV{

    [mutableArr replaceObjectAtIndex:count withObject:textV];
    [dic setObject:mutableArr forKey:keyStr];
   
}

//编辑停止后计算修改内容高度保存，并将内容保存，刷新
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    int count = textView.tag/100;//通过此数据可以知道对应的哪个KEY，比如1对应姓名，2对应性别，以此类推
    int yuCount = textView.tag%100;
    
    switch (count) {
        case 1:
        {
            [self changeArrAndKey:@"姓名" andCount:yuCount andArr:namelArr andText:textView.text];
       
        }
            break;
            
        case 3:
        {
             [self changeArrAndKey:@"公司" andCount:yuCount andArr:comlArr andText:textView.text];
       
        }
            break;
        case 4:
        {
             [self changeArrAndKey:@"手机" andCount:yuCount andArr:tellArr andText:textView.text];
        }
            break;
        case 5:
        {
            [self changeArrAndKey:@"座机" andCount:yuCount andArr:phonelArr andText:textView.text];
        }
            break;
        case 6:
        {
              [self changeArrAndKey:@"邮箱" andCount:yuCount andArr:emlArr andText:textView.text];
        }
            break;
        case 7:
        {
            [self changeArrAndKey:@"QQ" andCount:yuCount andArr:QQlArr andText:textView.text];
        }
            break;
        case 8:
        {
             [self changeArrAndKey:@"部门" andCount:yuCount andArr:seplArr andText:textView.text];
        }
            break;
        case 9:
        {
             [self changeArrAndKey:@"职位" andCount:yuCount andArr:titlelArr andText:textView.text];
        }
            break;
        case 10:
        {
            [self changeArrAndKey:@"地址" andCount:yuCount andArr:addlArr andText:textView.text];
        }
            break;
        case 11:
        {
             [self changeArrAndKey:@"邮编" andCount:yuCount andArr:labellArr andText:textView.text];
        }
            break;
        case 12:
        {
             [self changeArrAndKey:@"传真" andCount:yuCount andArr:faxlArr andText:textView.text];
        }
            break;
        case 13:
        {
            [self changeArrAndKey:@"网址" andCount:yuCount andArr:urllArr andText:textView.text];
        }
            break;
            
        case 14:
        {
            [self changeArrAndKey:@"微信" andCount:yuCount andArr:urllArr andText:textView.text];
        }
            break;
            
        default:
            break;
    }
    
    [self makeView:dic];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    int count = textView.tag/100;//通过此数据可以知道对应的哪个KEY，比如1对应姓名，2对应性别，以此类推
    int yuCount = textView.tag%100;
    textY = 0.0f;
    
    switch (count) {
        case 1:
        {
            textY = textView.frame.origin.y;
        }
            break;
            
        case 3:
        {
            textY = _viewH1.constant+_viewH2.constant+textView.frame.origin.y;
        }
            break;
        case 4:
        {
          textY = _viewH1.constant+_viewH2.constant+_viewH3.constant+textView.frame.origin.y;
        }
            break;
        case 5:
        {
         textY =  _viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+textView.frame.origin.y;
        }
            break;
        case 6:
        {
          textY =  _viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+textView.frame.origin.y;
        }
            break;
        case 7:
        {
           textY =  _viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+textView.frame.origin.y;
        }
            break;
        case 8:
        {
           textY =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+textView.frame.origin.y;
        }
            break;
        case 9:
        {
           textY =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+_viewH8.constant+textView.frame.origin.y;
        }
            break;
        case 10:
        {
              textY =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+_viewH8.constant+_viewH9.constant+textView.frame.origin.y;
        }
            break;
        case 11:
        {
             textY =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+_viewH8.constant+_viewH9.constant+_viewH10.constant+textView.frame.origin.y;
        }
            break;
        case 12:
        {
            textY =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+_viewH8.constant+_viewH9.constant+_viewH10.constant+_viewH11.constant+textView.frame.origin.y;
        }
            break;
        case 13:
        {
            textY =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+_viewH8.constant+_viewH9.constant+_viewH10.constant+_viewH11.constant+_viewH12.constant+textView.frame.origin.y;
        }
            break;
        case 14:
        {
            textY =_viewH1.constant+_viewH2.constant+_viewH3.constant+_viewH4.constant+_viewH5.constant+_viewH6.constant+_viewH7.constant+_viewH8.constant+_viewH9.constant+_viewH10.constant+_viewH11.constant+_viewH12.constant+_viewH13.constant+textView.frame.origin.y;
        }
            break;
            
        default:
            break;
    }

//    NSLog(@"-----%f",textView.frame.origin.y);
    return YES;
}

#pragma mark -- 键盘监听
- (void)keyboardDidShow:(NSNotification *)notification{

    newTextY = goTextY;
   [_MyScroll setContentOffset:CGPointMake(0, textY-17) animated:YES];
   
}
- (void)keyboardWillHide:(NSNotification *)notification{
   
    [_MyScroll setContentOffset:CGPointMake(0, newTextY) animated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    goTextY =scrollView.contentOffset.y;// 获取纵向滑动的距离
    
    
}

#pragma mark--验证公司选择按钮点击事件
-(void)changeType:(UIButton *)arrBt{
    
    arrBt.selected = !arrBt.selected;
    
    if (arrBt.selected) {
        
        UIImage *image = [UIImage imageNamed:@"已选对勾.png"] ;
        
        [arrBt setImage:[UIImage imageNamed:@"已选对勾.png"] forState:UIControlStateNormal];

        [arrBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width-7, 0, image.size.width)];
        [arrBt setImageEdgeInsets:UIEdgeInsetsMake(0, arrBt.titleLabel.bounds.size.width, 0, -arrBt.titleLabel.bounds.size.width-7)];
        
        [_sected_custArr addObject:[_custArr objectAtIndex:arrBt.tag-100]];
        
    }else{
        
        [arrBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_sected_custArr removeObjectAtIndex:arrBt.tag-100];

    }
    
      NSLog(@"验证公司选择按钮点击事件---%@",_sected_custArr);
}

#pragma mark--弹出框保存按钮点击事件
-(void)closeClickButton1:(UIButton *)bt{
    
    UIView *blackView = (UIView *)[self.view viewWithTag:1090];
    
    [blackView removeFromSuperview];
    
    [self hei];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
