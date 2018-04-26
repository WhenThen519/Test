//
//  New_ShouCangDetail.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/1.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//
#import "CountList.h"
#import "New_ShouCangDetail.h"
#import "New_ShouCangDetailMore.h"
#import "CY_recordView.h"
#import "ChoseAddWay.h"
#import "CY_addMenVC.h"
#import "MP_ViewController.h"
#import "CY_popupV.h"
#import "YixiangView.h"
#import "XiejiluViewController.h"

@interface New_ShouCangDetail ()
{
    NSMutableDictionary * requestDic;
    NSArray *linkInfoArr;
    NSMutableDictionary *toDic;
     UIImage *chosenImage;//名片照片
    UIView *blackV;
    UIView *doView;
    UIButton *shiFangBtn;
    UIButton *fenPeiBtn;
}
@end

@implementation New_ShouCangDetail
- (IBAction)fancha:(id)sender {
    NSString * str=[NSString stringWithFormat:@"https://m.baidu.com/?from=844b&vit=fps#|src_%@|sa_ib",[_receiveDic objectForKey:@"custName"]];
    str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)link:(id)sender {
    if(_guanwang.text.length)
    {
        NSString * str=[_guanwang.text substringFromIndex:3];
        if(![str hasPrefix:@"http"]){
            str = [NSString stringWithFormat:@"http://%@",[_guanwang.text substringFromIndex:3]];
        }
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (IBAction)goMore:(id)sender {
    New_ShouCangDetailMore *s = [[New_ShouCangDetailMore alloc]init];
    s.custId = [_receiveDic objectForKey:@"custId"];
    s.receiveDic = toDic;
    [self.navigationController pushViewController:s animated:NO];
}

-(void)addMan:(UIButton *)addBt{
        
        ChoseAddWay *addWay = [[ChoseAddWay alloc]init];
        addWay.chooseWayBlock = ^(NSString *result)
        {
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
            if([result isEqualToString:@"sao"])
            {
                
                //拍照
                NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&[mediatypes count]>0){
                    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
                    picker.mediaTypes=mediatypes;
                    picker.delegate=self;
                    picker.allowsEditing=YES;
                    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                    NSString *requiredmediatype=(NSString *)kUTTypeImage;
                    NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
                    [picker setMediaTypes:arrmediatypes];
                    
                    [self presentViewController:picker animated:YES completion:^{
                    }];
                }
                else{
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
                }
            }
            //手动输
            else
            {
                CY_addMenVC *addMen = [[CY_addMenVC alloc]init];
                addMen.comStr = [toDic objectForKey:@"custName"];
                addMen.custId = [toDic objectForKey:@"custId"];
                
                [self.navigationController pushViewController:addMen animated:NO];
                
            }
        };
        [self  presentViewController:addWay animated:NO completion:^{
            
        }];
    
}

#pragma mark - 拍照模块代理
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
    //    chosenImage = [UIImage imageNamed:@"IMG_0153.jpg"];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 1);
    NSInteger lenth =[imageData length]/1024;
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc]init];
    
    NSString *url = [NSString stringWithFormat:@"http://bcr2.intsig.net/BCRService/BCR_VCF2&iexcl;PIN=290BD181296&amp;user=gaopeng@300.cn&amp;pass=MEWN3546L669SKPK&amp;lang=7&amp;size=%ld",lenth];
    
    [FX_UrlRequestManager postByUrlStr:url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:@"vvvv:" andIsNeedCookies:NO andImageArray:chosenImage ];
    
}

-(void)vvvv:(NSString *)dic{
    
//    NSLog(@"^^^^^^^^^^^^^%@",dic);
    
    [self parseVCardString:dic];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

//解析vcf
-(void)parseVCardString:(NSString*)vcardString
{
    if (vcardString.length != 0) {
        
        MP_ViewController *mpView = [[MP_ViewController alloc]init];
        mpView.vcardString =vcardString;
        mpView.photoImage = chosenImage;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[toDic objectForKey:@"custId"],@"custId",[toDic objectForKey:@"custName"],@"custName", nil];
        
        mpView.custArr = [[NSMutableArray alloc]initWithObjects:dic, nil];
        
        //        mpView.custName = _custNameStr;
        
        [self.navigationController pushViewController:mpView animated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    toDic = [[NSMutableDictionary alloc] initWithDictionary:_receiveDic];
    _line.layer.borderWidth = 0.5;
    _line.layer.borderColor = [ToolList getColor:@"999999"].CGColor;
    _zuixinjilu.layer.borderWidth = 0.5;
    _zuixinjilu.layer.borderColor = [ToolList getColor:@"999999"].CGColor;
    _zuixinjilu.layer.cornerRadius = 4.;
    _zuixinjilu.layer.masksToBounds = YES;
    
    _lianxiren.layer.borderWidth = 0.5;
    _lianxiren.layer.borderColor = [ToolList getColor:@"999999"].CGColor;
    _lianxiren.layer.cornerRadius = 4.;
    _lianxiren.layer.masksToBounds = YES;
    
    _ShangJiL.layer.borderWidth = 0.5;
    _ShangJiL.layer.borderColor = [ToolList getColor:@"999999"].CGColor;
    _ShangJiL.layer.cornerRadius = 4.;
    _ShangJiL.layer.masksToBounds = YES;
    
    _jilu.layer.borderWidth = 0.5;
    _jilu.layer.borderColor = [ToolList getColor:@"999999"].CGColor;
    _jilu.layer.cornerRadius = 4.;
    _jilu.layer.masksToBounds = YES;
    
    _scroll.layer.borderWidth = 0.5;
    _scroll.layer.borderColor = [ToolList getColor:@"999999"].CGColor;
    _scroll.layer.cornerRadius = 4.;
    _scroll.layer.masksToBounds = YES;
    
    _shangJiScroll.layer.borderWidth = 0.5;
    _shangJiScroll.layer.borderColor = [ToolList getColor:@"999999"].CGColor;
    _shangJiScroll.layer.cornerRadius = 4.;
    _shangJiScroll.layer.masksToBounds = YES;
    
     [self addNavgationbar:@"客户详情" leftImageName:nil rightImageName:@"添加联系人.png" target:self leftBtnAction:nil rightBtnAction:@"addMan:" leftHiden:NO rightHiden:NO];
    
    
    // Do any additional setup after loading the view from its nib.
    NSDictionary *   dic = _receiveDic;
    self.name.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    
    self.guimo.text = [NSString stringWithFormat:@"规模:%@",[ToolList changeNull:[dic objectForKey:@"custRegisterPeopleNumberType"]]];
     self.zhucezijin.text = [NSString stringWithFormat:@"注册资金:%@万",[ToolList changeNull:[dic objectForKey:@"custRegisterMoney"]]];
     self.hangye.text = [NSString stringWithFormat:@"行业:%@",[ToolList changeNull:[dic objectForKey:@"industryClassBig"]]];
    
    //底部操作层
    doView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height-CaozuoViewHeight, __MainScreen_Width, CaozuoViewHeight)];
    doView.backgroundColor = [ToolList getColor:@"fafafa"];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0.8) toPoint:CGPointMake(__MainScreen_Width, 0.8) andWeight:0.8 andColorString:@"e7e7eb"]];
    [doView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    
    shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"拜访" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [shiFangBtn addTarget:self action:@selector(baifang:) forControlEvents:UIControlEventTouchUpInside];
    [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_xiejilu.png"] forState:UIControlStateNormal];
    [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:shiFangBtn];
    
    fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"反查" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
    [fenPeiBtn addTarget:self action:@selector(fancha:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"Search Icon.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [doView addSubview:fenPeiBtn];
    [self.view addSubview:doView];
    [self requestAlldata];
    
    
    
   }
#pragma mark - 拜访操作
-(void)baifang:(UIButton *)btn
{
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"other";
    gh.kehuNameStr = [toDic objectForKey:@"custName"];
    gh.kehuNameId = [toDic objectForKey:@"custId"];;    
    [self.navigationController pushViewController:gh animated:NO];
}
-(void)requestSuccess:(NSDictionary *)dic1
{
    NSDictionary *dic  = [[dic1 objectForKey:@"result"] objectForKey:@"custInfo"];
    [toDic setValuesForKeysWithDictionary:dic];
    if([[dic objectForKey:@"homepageHint"] intValue]==0)
    {
        self.guan.hidden = YES;
    }
    else
    {
        self.guan.hidden = NO;
    }
    if([[dic objectForKey:@"releaseCount"] intValue]!=0)
    {
        self.xin.layer.cornerRadius = 4;
        self.xin.layer.masksToBounds = YES;
        self.xin.backgroundColor = [UIColor redColor];
        [self.xin setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"releaseCount"]] forState:UIControlStateNormal];
        [self.xin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.xin setBackgroundImage:nil forState:UIControlStateNormal];
        
        self.xin.titleLabel.font = [UIFont systemFontOfSize:8];        }
    else
    {
        [self.xin setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];

    }
    if([[dic objectForKey:@"channelNumber"] intValue]==0)
    {
        self.tui.hidden = YES;
    }
   else
   {
       self.tui.hidden = NO;
   }

    self.dizhi.text = [NSString stringWithFormat:@"地址:%@",[ToolList changeNull:[toDic objectForKey:@"address"]]];

    NSString *contentStr =[NSString stringWithFormat:@"官网:%@",[ToolList changeNull:[dic objectForKey:@"homepage"]]];;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[ToolList getColor:@"999999"] range:NSMakeRange(0, 3)];
    self.guanwang.attributedText = str;
    
    self.chenglishijian.text = [NSString stringWithFormat:@"成立时间:%@",[ToolList changeNull:[dic objectForKey:@"createDate"]]];
    self.zhucezijin.text = [NSString stringWithFormat:@"注册资金:%@万",[ToolList changeNull:[dic objectForKey:@"custRegisterMoney"]]];
    self.hangye.text = [NSString stringWithFormat:@"行业:%@",[ToolList changeNull:[dic objectForKey:@"industryClassBig"]]];
    
    NSDictionary *dic2  = [[dic1 objectForKey:@"result"] objectForKey:@"visitLog"];
    if([[dic2 objectForKey:@"salerName"]length])
    {
    self.zhongjian1.text = [NSString stringWithFormat:@"%@ %@",[ToolList changeNull:[dic2 objectForKey:@"content"]],[ToolList changeNull:[dic2 objectForKey:@"linkManName"]]];
    }
        else
        {
            self.zhongjian1.text = @"暂无沟通记录";
        }
    self.zhongjian2.text = [NSString stringWithFormat:@"%@ %@ %@",[ToolList changeNull:[dic2 objectForKey:@"visitTime"]],[ToolList changeNull:[dic2 objectForKey:@"salerPosition"]],[ToolList changeNull:[dic2 objectForKey:@"salerName"]]];
    
    self.gongji.text = [NSString stringWithFormat:@"共计%@条",[ToolList changeNull:[dic2 objectForKey:@"visitTotal"]]];
    
    linkInfoArr  = [[dic1 objectForKey:@"result"] objectForKey:@"linkInfo"];
    
    self.lianxiren.text = [NSString stringWithFormat:@"%ld名联系人",linkInfoArr .count];
 
    
    [self createScroll:linkInfoArr];
    
  NSArray * link_InfoArr  = [[dic1 objectForKey:@"result"] objectForKey:@"sjList"];
       self.ShangJiL.text =[NSString stringWithFormat:@"%ld商机信息",link_InfoArr.count];
    float h = 0;
    float w = 0;
    
    if (link_InfoArr.count) {
        
        for (NSDictionary *dic1 in link_InfoArr) {
            
            //创建
            YixiangView *view = [[YixiangView alloc] initWithFrame:CGRectZero andDic:dic1 andflag:NO];
            view.frame = CGRectMake(w, 0, __MainScreen_Width-32, view.frame.size.height);
            w += (__MainScreen_Width-32);
            h = view.frame.size.height;
            view.backgroundColor = [UIColor clearColor];
            [_shangJiScroll addSubview:view];
            _shangJiSH.constant =h;
            
        }
        _shangJiScroll.pagingEnabled = YES;
        _blackHeight.constant = 228+h+15;
        _shangjW.constant = __MainScreen_Width-32;
        _shangJiScroll.contentSize = CGSizeMake((__MainScreen_Width-32)*[link_InfoArr count], h);
        _bigViewHeight.constant =663+h+10;
    }else{
        self.ShangJiL.hidden = YES;
        _shangJiScroll.hidden = YES;
        _shangJiSH.constant = 0;
        _shangjH.constant = 0;
        _shangjY.constant = 0;
        _jiluY.constant = 0.0f;
        _blackHeight.constant = 228.0f;
        _bigViewHeight.constant =614+h+10;
    }
  

    
    if (![[[dic1 objectForKey:@"result"]objectForKey:@"lastTimeCollection"] length] && ![[[dic1 objectForKey:@"result"]objectForKey:@"lastTimeProtect"] length]) {
    
        _UILabel3.hidden = NO;
        
    }else{
        _UILabel1.hidden = NO;
        _UILabel2.hidden = NO;
         _jiluX.constant =(_bgView.frame.size.height-52)/2;
        _label1x.constant =(_bgView.frame.size.height-52)/2;
        _UILabel1.text = [NSString stringWithFormat:@"上次收藏时间:%@",[[dic1 objectForKey:@"result"]objectForKey:@"lastTimeCollection"]];
        _UILabel2.text = [NSString stringWithFormat:@"上次保护时间:%@",[[dic1 objectForKey:@"result"]objectForKey:@"lastTimeProtect"]];
        
    }
    //多个电话显示页面
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    blackV = [[UIView alloc]initWithFrame:CGRectMake(0,__MainScreen_Height , __MainScreen_Width, __MainScreen_Height)];
    blackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [mainWindow addSubview:blackV];
    
    
    
    _bigScrollView.contentSize = CGSizeMake(__MainScreen_Width, _bigViewHeight.constant);
    
}
-(void)call:(UIButton *)btn
{
    NSLog(@"btn-tag-%ld",btn.tag);
    NSDictionary *dic = [linkInfoArr objectAtIndex:btn.tag];
    CY_recordView *orientationV=[[CY_recordView alloc]init];
    orientationV.automaticallyAdjustsScrollViewInsets = NO;
    orientationV.from_dic = dic;
    orientationV.fromAll_dic =toDic;
    orientationV.custName = [toDic objectForKey:@"custName"];
    [self.navigationController pushViewController:orientationV animated:NO];
}

#pragma mark - 点击多个电话
-(void)moreTel:(UIButton *)sender{
    

        NSDictionary *dataDic = [linkInfoArr objectAtIndex:sender.tag];
    if ([[dataDic objectForKey:@"contactList"] count]) {
        
        CY_popupV *popuTel = [[CY_popupV alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-[[dataDic objectForKey:@"contactList"] count]*49-54, __MainScreen_Width, [[dataDic objectForKey:@"contactList"] count]*49+54) andMessageArr:[dataDic objectForKey:@"contactList"] andtarget:self];
        [blackV addSubview:popuTel];
        
        [UIView animateWithDuration:0.3 animations:^{
            blackV.frame =CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
        }];
    }else{
        
          [ToolList showRequestFaileMessageLittleTime:@"暂无手机或座机"];
    }
}


-(void)cancelBt:(UIButton *)cancelBt{
    
    [UIView animateWithDuration:0.3 animations:^{
        blackV.frame =CGRectMake(0, __MainScreen_Height, __MainScreen_Width, __MainScreen_Height);
    }];
}

-(void)telMoreList:(UIButton *)telBt{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telBt.titleLabel.text];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void)createScroll:(NSArray *)arr
{
    _scroll.contentSize = CGSizeMake(_scroll.frame.size.width*arr.count, _scroll.frame.size.height);
    
    _scroll.showsHorizontalScrollIndicator = NO;
    for (int j = 0;j<arr.count;j++) {
        NSDictionary *dic = [arr objectAtIndex:j];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(_scroll.frame.size.width-90+_scroll.frame.size.width*j, 0, 90, _scroll.frame.size.height);
        btn.tag = j;
        [btn setImage:[UIImage imageNamed:@"normal.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(moreTel:) forControlEvents:UIControlEventTouchUpInside];
        [_scroll addSubview:btn];
        for(int i = 0;i<6;i++)
        {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10+_scroll.frame.size.width*j, 10+((_scroll.frame.size.height-20)/6)*i, _scroll.frame.size.width-10, (_scroll.frame.size.height-20)/6)];
            lab.font = [UIFont systemFontOfSize:14];
            lab.textColor = [ToolList getColor:@"999999"];
            [_scroll addSubview:lab];
            switch (i) {
                case 0:
                {
                    lab.font = [UIFont systemFontOfSize:18];
                    lab.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"linkManName"],[dic objectForKey:@"sex"] ];
                    break;
                }
                case 1:
                {
                    lab.text = [NSString stringWithFormat:@"职位:%@",[dic objectForKey:@"postion"] ];
                    break;
                }
                case 2:
                {
                    NSMutableString *str = [[NSMutableString alloc] initWithString:[dic objectForKey:@"mobile"]];
                    if(str.length)
                    {

                        lab.text = [NSString stringWithFormat:@"手机:%@",str];
                    }
                    else
                    {
                        lab.text = @"手机:";
                    }
                    break;
                }
                case 3:
                {
                    NSMutableString *str = [[NSMutableString alloc] initWithString:[dic objectForKey:@"tel"]];
                    if(str.length)
                    {

                        lab.text = [NSString stringWithFormat:@"座机:%@",str];
                    }
                    else
                    {
                        lab.text = @"座机:";
                    }
                 
                    break;
                }
                case 4:
                {
                    if([NSString stringWithFormat:@"QQ:%@",[dic objectForKey:@"qq"]])
                    {
                    lab.text =  [NSString stringWithFormat:@"QQ:%@",[dic objectForKey:@"qq"]];
                    }
                    else
                    {
                     lab.text = @"QQ:";
                    }
                    break;
                }
                case 5:
                {
                    lab.text = [NSString stringWithFormat:@"邮箱:%@",[dic objectForKey:@"email"] ];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

-(void) requestAlldata
{
    //
    NSMutableDictionary *requestDic1 = [[NSMutableDictionary alloc] init];
   [requestDic1 setObject:[_receiveDic objectForKey:@"custId"] forKey:@"custId"];
    //
    [FX_UrlRequestManager postByUrlStr:custDetail_url andPramas:requestDic1 andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    
    
    
}
- (IBAction)bottom_more:(id)sender {
    
    CountList *s = [[CountList alloc]init];
    s.custId = [_receiveDic objectForKey:@"custId"];
    [self.navigationController pushViewController:s animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
