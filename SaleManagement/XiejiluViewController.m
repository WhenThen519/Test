//
//  XiejiluViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "XiejiluViewController.h"
#import "FX_Button.h"
#import "XiejiluViewController2.h"
#import "SearchViewController.h"
#import "XieJiLuSearch.h"
#import "CY_addClientVc.h"
#import "PFSelectViewController.h"

@interface XiejiluViewController ()
{
    NSMutableArray *xiaoshoudongzuoButtonArr;
    NSMutableArray *lianxirenBtnArr;
    
}
@property(nonatomic,strong)UITextField *telText;
@property(nonatomic,strong)UITextField *nameText;

@property(nonatomic,strong)NSString *pf_str;

@end

@implementation XiejiluViewController
#pragma mark - 下一步
-(void)next
{
    if(_kehuNameStr == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择客户！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(_xiaoshoudongzuo == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择销售动作！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (_nameText.text.length==0) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请添加联系人姓名！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                return;
    }
    if (_telText.text.length == 0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请添加联系人电话！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
//    
//    if (_telText.text.length <11){
//        
//        [ToolList showRequestFaileMessageLittleTime:@"请输入正确的11位手机号码"];
//        
//        return;
//    }
    
    if (!wiNSStringIsValidPhone_tel(_telText.text)) {
        
        [ToolList showRequestFaileMessageLittleTime:@"号码有误，请输入11位手机号码或区号座机号码"];
        
        return;
    }
    
//    if(_lianxirenId == nil)
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择联系人！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
//        [alert show];
//        return;
//        
//    }
    
    XiejiluViewController2 *gh = [[XiejiluViewController2 alloc] init];
    gh.fromPage = _fromPage;
    gh.custId = _kehuNameId;
    gh.linkManId = _telText.text;
    gh.visitType = _xiaoshoudongzuo;
    gh.linkManName =_nameText.text;
    gh.custName = _kehuNameStr;
    gh.logId_1 = _logId;
    gh.isLogId = _isHuiFang;
    gh.pf_SalerId = _pf_str;
    [self.navigationController pushViewController:gh animated:NO];
}
#pragma mark - 请求联系人成功
-(void)requestSuccess:(NSDictionary *)dic
{
    [lianxirenBtnArr removeAllObjects];
    for (FX_Button *btn in _lianxirenScroll.subviews) {
        [btn removeFromSuperview];
    }
    NSArray *resultArr =[dic objectForKey:@"result"];
    float scrH = __MainScreen_Height - _xiaoshoudongzuoL.frame.origin.y - _xiaoshoudongzuoL.frame.size.height;
    if(scrH > 15+49*(resultArr.count/2)+6)
    {
        _scroll_h.constant = 15+49*((resultArr.count+1)/2)+6;
    }
    else
    {
        _scroll_h.constant = scrH;
        _lianxirenScroll.contentSize = CGSizeMake(__MainScreen_Width, 15+49*(resultArr.count/2)+6);
    }
    float  btn_W = (__MainScreen_Width - 26 -9)/2;
    
    for (int i = 0; i < resultArr.count; i ++) {
        NSDictionary *dic = [resultArr objectAtIndex:i];
        NSString *key = [ToolList changeNull:[dic objectForKey:@"linkManId"]];
        NSString *val = [ToolList changeNull:[dic objectForKey:@"linkManName"]];
        NSDictionary *dicSec = [NSDictionary dictionaryWithObject:val forKey:key];
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(13+(btn_W + 9)*(i%2), 15+49*(i/2), btn_W, 40) andType:@"1" andTitle:@"lianxiren" andTarget:self andDic:dicSec];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_lianxirenScroll addSubview:btn];
        [lianxirenBtnArr addObject:btn];
    }
}
#pragma mark - 请求联系人
-(void)getLinkMan:(NSString *)custId
{
    [FX_UrlRequestManager postByUrlStr:LinkManNameList_url andPramas:[NSMutableDictionary dictionaryWithObject:custId forKey:@"custId"] andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
}

#pragma mark - 选择陪访人
- (IBAction)selectPFBtnClicked:(id)sender{
    
    PFSelectViewController *pf_View2 = [[PFSelectViewController alloc] init];
    pf_View2.pf_Block = ^(NSDictionary * dic)
    {
        if (dic == nil) {
            
            _pf_str = @"";
            [_SelectPeiFangBtn setTitle:@"陪访人" forState:UIControlStateNormal];
           
        }else{
            _pf_str =[dic objectForKey:@"salerId"];
            [_SelectPeiFangBtn setTitle:[NSString stringWithFormat:@"陪访人 %@ %@",[dic objectForKey:@"deptName"],[dic objectForKey:@"salerName"]] forState:UIControlStateNormal];
        }
      
        [_SelectPeiFangBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,  -__MainScreen_Width+_SelectPeiFangBtn.titleLabel.intrinsicContentSize.width+15, 0, 0)];
        [_SelectPeiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_SelectPeiFangBtn.titleLabel.intrinsicContentSize.width-__MainScreen_Width/2-130)];
        
    };
    [self.navigationController pushViewController:pf_View2 animated:YES];
}

#pragma mark - 选择客户按钮点击
- (IBAction)selectKehuBtnClicked:(id)sender {

    XieJiLuSearch *gh = [[XieJiLuSearch alloc] init];
    gh.ss = self;
    gh.Serach_Block = ^(NSDictionary * dic)
    {
        _KehuName.text = [dic objectForKey:@"custName"];
        _kehuNameId = [dic objectForKey:@"custId"];
        _kehuNameStr = [dic objectForKey:@"custName"];
 
    };
    gh.automaticallyAdjustsScrollViewInsets = false;
    [self.navigationController pushViewController:gh animated:NO];
}
-(void)bb
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - 页面初始化
-(void)initView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bb) name:@"ggg" object:nil];
    lianxirenBtnArr = [[NSMutableArray alloc] init];
    xiaoshoudongzuoButtonArr = [[NSMutableArray alloc] init];
    _scroll_h.constant = 87.0f;
    if(!_kehuNameStr == nil && !_kehuNameId == nil)
    {
        _SelectKehuBtn.hidden = YES;
        _KehuName.text = _kehuNameStr;
        //请求联系人
//        [self getLinkMan:_kehuNameId];
    }
    if (_isShouYe) {
        
        _addKHBtn.hidden = NO;
    }
    
    
    [self addNavgationbar:@"写记录" leftBtnName:@"取消" rightBtnName:@"下一步" target:self leftBtnAction:nil rightBtnAction:@"next"];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    switch (isSW.intValue) {
        case 0://商务
        {
            _xiaoshoudongzuoBtnArr = @[@{@"2":@"拜访"},@{@"1":@"打电话"}];
            _xiaoshoudongzuo = @"2";
            _SelectPeiFangBtn.hidden = NO;
            _pfL.hidden = NO;
        }
            break;
            
        case 1://经理
        {
            if (_xiaoshoudongzuoBtnArr.count ==0) {
              _xiaoshoudongzuoBtnArr = @[@{@"1":@"回访"},@{@"2":@"陪访"}];
            }
            _xiaoshoudongzuo = @"1";
        }
            break;
        case 2://总监
        {
            _xiaoshoudongzuoBtnArr = @[@{@"7":@"回访"}];
            _xiaoshoudongzuo = @"7";
        }
            break;
            
            
            
        default:
            break;
    }
    
    //添加姓名，电话
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 40, 30)];
    nameLabel.text = @"姓名";
     nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [ToolList getColor:@"999999"];
    [_lianxirenScroll addSubview:nameLabel];
    
    _nameText = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width, nameLabel.frame.origin.y, __MainScreen_Width-nameLabel.frame.origin.x-nameLabel.frame.size.width-13, 30)];
    _nameText.placeholder = @"联系人姓名";
    if (_lianxirenName.length) {
        _nameText.text =_lianxirenName;
    }
    _nameText.backgroundColor = [UIColor clearColor];
    _nameText.borderStyle =UITextBorderStyleNone;
    _nameText.font = [UIFont systemFontOfSize:14];
     _nameText.textColor = [ToolList getColor:@"999999"];
    [_lianxirenScroll addSubview:_nameText];
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, nameLabel.frame.origin.y+nameLabel.frame.size.height+7, 40, 30)];
    telLabel.text = @"电话";
        telLabel.backgroundColor = [UIColor clearColor];
    telLabel.font = [UIFont systemFontOfSize:14];
    telLabel.textColor = [ToolList getColor:@"999999"];
    [_lianxirenScroll addSubview:telLabel];
    
    _telText = [[UITextField alloc]initWithFrame:CGRectMake(telLabel.frame.origin.x+telLabel.frame.size.width, telLabel.frame.origin.y, __MainScreen_Width-telLabel.frame.origin.x-telLabel.frame.size.width-13, 30)];
    _telText.keyboardType = UIKeyboardTypePhonePad;
    _telText.delegate = self;
    if (_lianxirenId.length) {
        _telText.text =_lianxirenId;
    }
    _telText.placeholder = @"请输入11位手机号码或区号座机号码";
    _telText.backgroundColor = [UIColor clearColor];
    _telText.borderStyle =UITextBorderStyleNone;
    _telText.font = [UIFont systemFontOfSize:14];
    _telText.textColor = [ToolList getColor:@"999999"];
    [_lianxirenScroll addSubview:_telText];
    
    float  btn_W = (__MainScreen_Width - 26 - 18)/3;
    for (int i = 0; i < _xiaoshoudongzuoBtnArr.count; i ++) {
        NSDictionary *dic = [_xiaoshoudongzuoBtnArr objectAtIndex:i];
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(13+(btn_W + 9)*(i%3), 15, btn_W, 40) andType:@"1" andTitle:@"xiaoshoudongzuo" andTarget:self andDic:dic];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        if (self.chooseId == i) {
           [btn changeType1Btn:YES];
            NSDictionary *dic = [_xiaoshoudongzuoBtnArr objectAtIndex:i];
            _xiaoshoudongzuo =[NSString stringWithFormat:@"%@",[[dic allKeys] lastObject]];
        }
       
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_xiaoshoudongzuoView addSubview:btn];
        [xiaoshoudongzuoButtonArr addObject:btn];
    }

    [_SelectPeiFangBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,  -__MainScreen_Width+_SelectPeiFangBtn.titleLabel.intrinsicContentSize.width+15, 0, 0)];
    [_SelectPeiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -_SelectPeiFangBtn.titleLabel.intrinsicContentSize.width-__MainScreen_Width/2-130)];

    }
#pragma mark - 筛选回调
-(void)btnBackDic:(NSDictionary *)dic
{
    FX_Button *btn = [dic objectForKey:@"Obj"];
    NSDictionary *dic1 = [dic objectForKey:@"data"];
    NSString *str = [dic objectForKey:@"tag"];
    //阶段回馈
    if([str isEqualToString:@"lianxiren"])
    {
        if(btn.isSelect)
        {
            _lianxirenId = [[dic1 allKeys] lastObject];
            _lianxirenName = [[dic1 allValues] lastObject];
            for (FX_Button *btnS in lianxirenBtnArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            
        }
        else
        {
            _lianxirenId = nil;
            _lianxirenName = nil;
        }
    }
    else
    {
        if(btn.isSelect)
        {
            _xiaoshoudongzuo = [[dic1 allKeys] lastObject];
            
            for (FX_Button *btnS in xiaoshoudongzuoButtonArr)
            {
                if(btnS!=btn)
                {
                    [btnS changeType1Btn:NO];
                }
            }
            
        }
        else
        {
            _xiaoshoudongzuo = nil;
        }
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _pf_str = @"";
    //把添加的联系人跟公司名称带回来
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change_name:) name:@"YANZHENGOK" object:nil];
    
    //把公司名称从第二个搜索页面带回来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(search2_view:) name:@"SEARCH_TWO" object:nil];
    
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.view addGestureRecognizer:tapGestureRecognizer];

    
    [self initView];
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_telText resignFirstResponder];
    [_nameText resignFirstResponder];
  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [textField resignFirstResponder];
  
    return YES;
}

#pragma mark---把公司名称从第二个搜索页面带回来
-(void)search2_view:(NSNotification *)notification{
    
    NSDictionary* user_info = [notification object];
    
    _KehuName.text = [user_info objectForKey:@"custName"];
    _kehuNameId = [user_info objectForKey:@"custId"];
    _kehuNameStr = [user_info objectForKey:@"custName"];
}

#pragma mark---把添加的联系人跟公司名称带回来
-(void)change_name:(NSNotification *)notification{
    
    NSDictionary* user_info = [notification object];
    
   _KehuName.text = [user_info objectForKey:@"custName"];//公司名称
     _kehuNameStr=[user_info objectForKey:@"custName"];
    _kehuNameId = [user_info objectForKey:@"custId"];
    _nameText.text =[user_info objectForKey:@"nameText"];//公司联系人
    _telText.text =[user_info objectForKey:@"telText"];//电话
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if (textField == _telText) {
//        if (string.length == 0)
//            return YES;
//        
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 11) {
//            return NO;
//        }
//    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _telText){
        
        if (!wiNSStringIsValidPhone_tel(_telText.text)) {
            
            [ToolList showRequestFaileMessageLittleTime:@"号码有误，请输入11位手机号码或区号座机号码"];         
        }
    }
}

#pragma mark----添加联系人
-(IBAction)addTarget:(UIButton *)addBt{
    
    CY_addClientVc *ghVC = [[CY_addClientVc alloc]init];
    ghVC.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController pushViewController:ghVC animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
