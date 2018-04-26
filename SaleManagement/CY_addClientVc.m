//
//  CY_addClientVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/4.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_addClientVc.h"
#import "CY_popupV.h"
#import "CY_myClientVC.h"

@interface CY_addClientVc (){

    textView *textVc;
    CY_addTextView *addTextView;
    CY_selectV *selectV;
    NSMutableArray *shiArr;
    UISegmentedControl *segmentControl;
    NSString *spid;
    NSString *scityId;
    NSString *sareaId;
}

@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSMutableArray *custID_CustName;//扫名片添加客户返回的数组，包括custID\CustName

@end

@implementation CY_addClientVc

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}


-(void)RightAction:(UIButton *)sender{
   
    [self.view endEditing:YES];
  
    if (textVc.hidden == NO) {//意向客户保护操作
        
        if ([textVc.yanBT.currentTitle isEqualToString:@"验证"]) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请验证客户是否存在！"];
            
            return;
        }
      
        
        if (textVc.nameText.text==nil || textVc.nameText.text.length==0 ) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请填写客户名称"];
            return;
        }
        
        
    
        
         if (textVc.hangId==nil || textVc.hangId.length == 0){
            
            [ToolList showRequestFaileMessageLittleTime:@"请选择行业"];
            return;
        }
        if (textVc.lxrName.text==nil||textVc.lxrName.text.length ==0){
            [ToolList showRequestFaileMessageLittleTime:@"请输入联系人姓名"];
            return;
        }
        if (textVc.lxrName.text.length >6){
            [ToolList showRequestFaileMessageLittleTime:@"联系人姓名不可多余5个字符"];
            return;
        }
        
        if (textVc.sex.text==nil||textVc.sex.text.length ==0){
            [ToolList showRequestFaileMessageLittleTime:@"请选择性别"];
            return;
        }
     
        if (textVc.zuoji.text.length ==0 && textVc.phone.text.length == 0){
            [ToolList showRequestFaileMessageLittleTime:@"请输入正确的座机号或者手机号"];
            return;
        }
        if(textVc.phone.text.length != 0)
        {
            if (!wiNSStringIsValidPhone(textVc.phone.text))
            {
                [ToolList showRequestFaileMessageLittleTime:@"手机号有误，请重新输入"];
                return;
            }
        }
        
        if(textVc.zuoji.text.length  !=0){
            
            if(!wiNSStringIsValidZJ(textVc.zuoji.text))
            {
                [ToolList showRequestFaileMessageLittleTime:@"座机有误，请输入区号座机号码"];
                return;
            }
        }
        
       
        if (spid==nil||spid.length==0 || scityId==nil|| scityId.length == 0 || sareaId==nil || sareaId.length == 0) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请选择地址"];
            return;
        }
       
        if (textVc.addText.text==nil || textVc.addText.text.length ==0 ){
            
            [ToolList showRequestFaileMessageLittleTime:@"请填写详细地址"];
            return;
        }
        if (textVc.comL==nil||textVc.comL.text.length ==0){
            [ToolList showRequestFaileMessageLittleTime:@"请选择公司性质"];
            return;
        }
        if (_dataDic==nil) {
           
            if (textVc.duanL==nil||textVc.duanL.text.length ==0){
                [ToolList showRequestFaileMessageLittleTime:@"请选择客户阶段"];
                return;
            }
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"linkManName"]= textVc.lxrName.text;
            
            if([textVc.sex.text isEqualToString:@"男"])
            {
             dic[@"sex"]= @"1";
            }
            else if ([textVc.sex.text isEqualToString:@"女"])
            {
             dic[@"sex"]= @"2";
            }
            dic[@"mobile"]= textVc.phone.text;
            dic[@"tel"]= textVc.zuoji.text;
            dic[@"custName"]= textVc.nameText.text;//客户名称
            dic[@"provinceCode"]= spid;          //省级代码
            dic[@"cityCode"]= scityId;              //市级代码
            dic[@"countyCode"]=  sareaId;           //区级代码
            dic[@"address"]= textVc.addText.text; //具体地址
            
            dic[@"industryclassBig"]= textVc.hangId;    //所属行业代码
            dic[@"custClass"]=  @"1";           //添加客户类型   1 代表公司客户  2代表个人客户
             dic[@"custNature"]=textVc.comTypeId;//公司性质
            
            if ([textVc.duanL.text isEqualToString:@"收藏夹"]) {
                
                dic[@"custType"]=  @"0";// 0代表收藏夹   1代表保护跟进
            }else if ([textVc.duanL.text isEqualToString:@"保护跟进"]){
                dic[@"custType"]=  @"1";
            }
            
            
             [FX_UrlRequestManager postByUrlStr:swaddCust_url andPramas:dic andDelegate:self andSuccess:@"protectIntentCustSuccess:" andFaild:@"protectIntentCustFild:" andIsNeedCookies:YES];
            
            return;
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"custName"]= textVc.nameText.text;//客户名称
        dic[@"provinceCode"]= spid;          //省级代码
        dic[@"cityCode"]= scityId;              //市级代码
        dic[@"countyCode"]=  sareaId;           //区级代码
        dic[@"address"]= textVc.addText.text; //具体地址
        
        dic[@"industryclassBig"]= textVc.hangId;    //所属行业代码
        dic[@"custClass"]=  @"1";           //添加客户类型   1 代表公司客户  2代表个人客户
        
        dic[@"custNature"]=textVc.comTypeId;//公司性质
      
        dic[@"IntentCustId"]= [_dataDic objectForKey:@"IntentCustId"];
        dic[@"mail"]=[_dataDic objectForKey:@"mail"];
        dic[@"linkManName"]=[_dataDic objectForKey:@"linkManName"];
        dic[@"mobile"]=[_dataDic objectForKey:@"mobile"];
        dic[@"linkManSex"]=[_dataDic objectForKey:@"linkManSex"];
      dic[@"qq"]=[_dataDic objectForKey:@"qq"];
        dic[@"tel"]=[_dataDic objectForKey:@"tel"];
        [FX_UrlRequestManager postByUrlStr:swprotectIntentCust_url andPramas:dic andDelegate:self andSuccess:@"protectIntentCustSuccess:" andFaild:@"protectIntentCustFild:" andIsNeedCookies:YES];
   
    }else{
        
        
        if ([addTextView.yanButton.currentTitle isEqualToString:@"验证"]) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请验证客户是否存在！"];
            
            return;
        }
        
       if ( addTextView.nameTextt.text==nil || addTextView.nameTextt.text.length == 0) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请填写客户名称"];
            return;
        }
        
       
        
     
        
        if (addTextView.numText == nil || addTextView.numText.text.length ==0){
            
            [ToolList showRequestFaileMessageLittleTime:@"请填写个人身份信息"];
            return;
        }
       
        if (addTextView.lxrName.text==nil||addTextView.lxrName.text.length ==0){
            [ToolList showRequestFaileMessageLittleTime:@"请输入联系人姓名"];
            return;
        }
        
        if (addTextView.lxrName.text.length>6){
            [ToolList showRequestFaileMessageLittleTime:@"联系人姓名不可多余5个字符"];
            return;
        }
        
        if (addTextView.sex.text==nil||addTextView.sex.text.length ==0){
            [ToolList showRequestFaileMessageLittleTime:@"请选择性别"];
            return;
        }
        if (addTextView.zuoji.text.length ==0 && addTextView.phone.text.length == 0){
            [ToolList showRequestFaileMessageLittleTime:@"请输入正确的座机号或者手机号"];
            return;
        }
        if(addTextView.phone.text.length != 0)
        {
            if (!wiNSStringIsValidPhone(addTextView.phone.text))
            {
                [ToolList showRequestFaileMessageLittleTime:@"手机号有误，请重新输入"];
                return;
            }
        }
        if(addTextView.zuoji.text.length  !=0){
            
            if(!wiNSStringIsValidZJ(addTextView.zuoji.text))
            {
                [ToolList showRequestFaileMessageLittleTime:@"座机有误，请输入区号座机号码"];
                return;
            }
        }
        
        if (spid==nil||spid.length==0 || scityId==nil|| scityId.length == 0 || sareaId==nil || sareaId.length == 0) {
            
            [ToolList showRequestFaileMessageLittleTime:@"请选择地址"];
            return;
        }
        if (addTextView.addTextt.text==nil || addTextView.addTextt.text.length == 0){
            
            [ToolList showRequestFaileMessageLittleTime:@"请填写详细地址"];
            return;
        }
        if (_dataDic==nil) {
            
             if (addTextView.duanLL==nil||addTextView.duanLL.text.length ==0){
                [ToolList showRequestFaileMessageLittleTime:@"请选择客户阶段"];
                return;
            }
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic[@"custName"]= addTextView.nameTextt.text;//客户名称
            dic[@"provinceCode"]= spid;          //省级代码
            dic[@"cityCode"]= scityId;              //市级代码
            dic[@"countyCode"]=  sareaId;           //区级代码
            dic[@"address"]= addTextView.addTextt.text; //具体地址
            dic[@"linkManName"]= addTextView.lxrName.text;
            if([addTextView.sex.text isEqualToString:@"男"])
            {
                dic[@"sex"]= @"1";
            }
            else if ([addTextView.sex.text isEqualToString:@"女"])
            {
                dic[@"sex"]= @"2";
            }
            dic[@"mobile"]= addTextView.phone.text;
            dic[@"tel"]= addTextView.zuoji.text;
            dic[@"certificateNo"]= addTextView.numText.text;    //个人客户身份证号
            dic[@"certificateType"]=  @"1";           //个人客户身份类型—默认为1 代表身份证
            dic[@"custClass"]=  @"2";//添加客户类型   1 代表公司客户  2代表个人客户
            if ([addTextView.duanLL.text isEqualToString:@"收藏夹"]) {
                
                dic[@"custType"]=  @"0";// 0代表收藏夹   1代表保护跟进
            }else if ([addTextView.duanLL.text isEqualToString:@"保护跟进"]){
                dic[@"custType"]=  @"1";
            }
            
            [FX_UrlRequestManager postByUrlStr:swaddCust_url andPramas:dic andDelegate:self andSuccess:@"protectIntentCustSuccess:" andFaild:@"protectIntentCustFild:" andIsNeedCookies:YES];
            
            return;
        }

       
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"custName"]= addTextView.nameTextt.text;//客户名称
        dic[@"provinceCode"]= spid;          //省级代码
        dic[@"cityCode"]= scityId;              //市级代码
        dic[@"countyCode"]=  sareaId;           //区级代码
        dic[@"address"]= addTextView.addTextt.text; //具体地址
        
        dic[@"certificateNo"]= addTextView.numText.text;    //个人客户身份证号
        dic[@"certificateType"]=  @"1";           //个人客户身份类型—默认为1 代表身份证
        dic[@"custClass"]=  @"2";//添加客户类型   1 代表公司客户  2代表个人客户
       
        dic[@"IntentCustId"]= [_dataDic objectForKey:@"IntentCustId"];
        dic[@"mail"]=[_dataDic objectForKey:@"mail"];
        dic[@"linkManName"]=[_dataDic objectForKey:@"linkManName"];
        dic[@"mobile"]=[_dataDic objectForKey:@"mobile"];
        dic[@"linkManSex"]=[_dataDic objectForKey:@"linkManSex"];
        dic[@"qq"]=[_dataDic objectForKey:@"qq"];
        dic[@"tel"]=[_dataDic objectForKey:@"tel"];
        [FX_UrlRequestManager postByUrlStr:swprotectIntentCust_url andPramas:dic andDelegate:self andSuccess:@"protectIntentCustSuccess:" andFaild:@"protectIntentCustFild:" andIsNeedCookies:YES];
    }
    
   
}

-(void)protectIntentCustSuccess:(NSDictionary *)sucDic{
    
    [self.view endEditing:YES];
    [textVc.nameText resignFirstResponder];
    [addTextView.nameTextt resignFirstResponder];
    [addTextView.numText resignFirstResponder];
    [textVc.addText resignFirstResponder];
    [addTextView.addTextt resignFirstResponder];
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
         if (_dataDic.count) {
              
             CY_popupV *popuV = [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andyixiangTitle:@"dhidh" andtarget:self];
             
             [self.view addSubview:popuV];
             
             return;
         }
        
        if (_isShou) {
            
            [self goMyButton];
            
        }else{
            if(segmentControl.selectedSegmentIndex==0){
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            if (textVc.nameText.text !=nil) {
                
                [dic setObject:textVc.nameText.text forKey:@"custName"];
            }else{
                [dic setObject:@"" forKey:@"custName"];
                
            }
            NSString *str =textVc.phone.text.length!=0?textVc.phone.text:textVc.zuoji.text;
            [dic setObject:[sucDic objectForKey:@"custId"] forKey:@"custId"];
            [dic setObject:textVc.lxrName.text forKey:@"nameText"];
            [dic setObject:str forKey:@"telText"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"YANZHENGOK" object:dic];
                
            }else{
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                if (addTextView.nameTextt.text !=nil) {
                    
                    [dic setObject:addTextView.nameTextt.text forKey:@"custName"];
                }else{
                    [dic setObject:@"" forKey:@"custName"];
                    
                }
                NSString *str =addTextView.phone.text.length!=0?addTextView.phone.text:addTextView.zuoji.text;
                [dic setObject:[sucDic objectForKey:@"custId"] forKey:@"custId"];
                [dic setObject:addTextView.lxrName.text forKey:@"nameText"];
                [dic setObject:str forKey:@"telText"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"YANZHENGOK" object:dic];
            }
            
            if (self.ss) {
                
                 [self.navigationController popToViewController:_ss animated:NO];
                return;
            }

            [self.navigationController popViewControllerAnimated:NO];
        }
       
    }
    
    else if ([[sucDic objectForKey:@"code"]intValue]==201){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[sucDic objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
        if (_isMP) {//从扫名片过来的，需要把custId传过去
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[sucDic objectForKey:@"custId"] forKey:@"custId"];
            [dic setObject:[sucDic objectForKey:@"custName"] forKey:@"custName"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"YANZHENGOK" object:dic];
        }
       
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {
        
        [self.navigationController popViewControllerAnimated:NO];
    
    }
}

//去意向
-(void)closeClickButton{
     [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"FANGQIOK" object:nil];
   
}

//回我的客户
-(void)goMyButton{
    
    CY_myClientVC *myclient = [[CY_myClientVC alloc]init];
    myclient.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController pushViewController:myclient animated:NO];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [textVc.nameText resignFirstResponder];
    [textVc.addText resignFirstResponder];
    [textVc.lxrName resignFirstResponder];
    [textVc.phone resignFirstResponder];
    [textVc.zuoji resignFirstResponder];
    [addTextView.nameTextt resignFirstResponder];
    [addTextView.numText resignFirstResponder];
    [addTextView.lxrName resignFirstResponder];
    [addTextView.phone resignFirstResponder];
    [addTextView.zuoji resignFirstResponder];
    [addTextView.addTextt resignFirstResponder];
   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    //将触摸事件添加到当前view
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _custID_CustName = [[NSMutableArray alloc]init];
    
    shiArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    handView *Hvc = [[handView alloc]initWithTitle:@"添加客户" andRightImage:@"" andLeftTitle:@"取消" andRightTitle:@"完成" andTarget:self];
    [self.view addSubview:Hvc];
    
    NSArray *array=@[@"公司",@"个人"];
    segmentControl=[[UISegmentedControl alloc]initWithItems:array];
    segmentControl.segmentedControlStyle=UISegmentedControlStyleBordered;
    //设置位置 大小
    segmentControl.frame=CGRectMake(__MainScreen_Width*0.2, 15+IOS7_Height, __MainScreen_Width*0.6, 35);
    //默认选择
    segmentControl.selectedSegmentIndex=0;
    //设置背景色
    segmentControl.tintColor=[ToolList getColor:@"5647b6"];
    //设置监听事件
    [segmentControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];

#pragma 添加公司页面
    textVc = [[[NSBundle mainBundle]loadNibNamed:@"textView" owner:self options:nil] lastObject];
    if (_isYiBool) {
        //isduanHiden==YES，从意向客户进入隐藏客户阶段
        textVc.isduanHiden = YES;
    }

    textVc.frame = CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+15, __MainScreen_Width, __MainScreen_Height-IOS7_Height-segmentControl.frame.size.height-30);
    textVc.textIntentCustId = [_dataDic objectForKey:@"IntentCustId"];
    textVc.hidden = NO;
    textVc.delegate = self;
    //adView为客户名称下面显示的内容
    textVc.adView.hidden = YES;
    [self.view addSubview:textVc];
 
  
#pragma 添加个人页面
   addTextView = [[[NSBundle mainBundle]loadNibNamed:@"CY_addTextView" owner:self options:nil] lastObject];

    addTextView.frame = CGRectMake(0, segmentControl.frame.origin.y+segmentControl.frame.size.height+15, __MainScreen_Width, __MainScreen_Height-IOS7_Height-segmentControl.frame.size.height-30);
    addTextView.daView.hidden = YES;
    addTextView.hidden = YES;
    addTextView.delegate = self;
    [self.view addSubview:addTextView];
    
  
    if (selectV == nil) {
        
        selectV = [[CY_selectV alloc]initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self Province:@"北京市" City:@"北京县" District:@"东城区"];
        
        [self.view addSubview:selectV];
    }

    textVc.nameText.text = _comString;
    
    if (_isYiBool) {
        
        textVc.nameText.text = _comString;
        addTextView.nameTextt.text = _comString;
        textVc.duanL.hidden = YES;
        textVc.changebt.hidden = YES;
        textVc.jieduanL.hidden = YES;
        textVc.lineL.hidden = YES;
        textVc.rightImage.hidden = YES;
        
        addTextView.duanLL.hidden = YES;
        addTextView.changebt.hidden = YES;
        addTextView.jieduanL.hidden = YES;
        addTextView.lineimage.hidden = YES;
        addTextView.rightImage.hidden = YES;
    }
    
}

#pragma mark -- 键盘监听
- (void)keyboardDidShow:(NSNotification *)notification{

    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  //
    CGRect keyboardRect;
    
//    [value getValue:&keyboardRect];
    CGRect rectFram = self.view.frame;
    rectFram.origin.y -=keyBoardEndY;
    NSLog(@"-------%f",rectFram.origin.y);
    [self.view setFrame:rectFram];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    
//    _myView_X.constant=0;
}

-(void)goVc:(id)vc{
 
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)presentedVC:(id)vc{
  
#pragma 添加地区选择页面
    
    [selectV showInView:self.view];
}

- (void)changeNativePlace:(NSString *)string andPid:(NSString *)pid andcityid:(NSString *)cityId andareaid:(NSString *)areaid{
    
    if( segmentControl.selectedSegmentIndex==0){
        
        textVc.addL.text = string;
        
    }else{
        addTextView.adLable.text = string;
    }
    spid = pid;
    scityId = cityId;
    sareaId = areaid;
}


- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
    
    
}

-(void)change:(UISegmentedControl *)segmentControl{
    
    if (segmentControl.selectedSegmentIndex==0) {
        
        textVc.hidden = NO;
        addTextView.hidden = YES;
        
    }else{
        
        textVc.hidden = YES;
        addTextView.hidden = NO;
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
