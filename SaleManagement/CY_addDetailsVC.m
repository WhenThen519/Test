//
//  CY_addDetailsVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/28.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_addDetailsVC.h"
#import "AddLinkNOControllerViewController.h"
@interface CY_addDetailsVC (){
    
    UIScrollView *mainScrollV;
        float height;
}

@end

@implementation CY_addDetailsVC

-(void)leftBtn11Action{
    
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - 添加联系方式
-(void)addLinkNO
{
    AddLinkNOControllerViewController *an = [[AddLinkNOControllerViewController alloc] init];
    an.linkManId = [_dataDic objectForKey:@"linkManId"];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObject:[_dataDic objectForKey:@"mobilePhone"]];
    [temp addObjectsFromArray:[_dataDic objectForKey:@"telList"]];
    an.mobilePhones = temp;
    an.czDicBlock = ^(NSDictionary *dic)
    {
        _dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [self makeView];
    };
    [self.navigationController  pushViewController:an animated:NO];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeView];
}

-(void)makeView{
    for (UIView *subView in self.view.subviews) {
        if(subView)
        {
            [subView removeFromSuperview];
        }
    }
    height = 0.0f;
    
    [self addNavgationbar:@"联系人详情" leftImageName:nil rightImageName:@"btn_add_top.png" target:self leftBtnAction:@"leftBtn11Action" rightBtnAction:@"addLinkNO" leftHiden:NO rightHiden:NO];
    
    UIButton *cancelBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBt setBackgroundImage:[UIImage imageNamed:@"bg_bottom_cz.png"] forState:UIControlStateNormal];
    [cancelBt setTitleColor: [ToolList getColor:@"666666"] forState:UIControlStateNormal];
    cancelBt.frame = CGRectMake(0, __MainScreen_Height-46, __MainScreen_Width, 46);
    [cancelBt addTarget:self action:@selector(isCancelBt:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isChang) {
        
        cancelBt.tag = -1;
        [cancelBt setTitle:@"取消设为常用联系人" forState:UIControlStateNormal];
        
    }else{
        
        if ([[_dataDic objectForKey:@"flag"] intValue]==1) {
            cancelBt.tag = -1;
            [cancelBt setTitle:@"取消设为常用联系人" forState:UIControlStateNormal];
            
        }else{
            cancelBt.tag = -2;
            [cancelBt setTitle:@"设为常用联系人" forState:UIControlStateNormal];
        }
    }
    
    
    cancelBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBt setImage:[UIImage imageNamed:@"icon_cz_cylxr.png"] forState:UIControlStateNormal];
    
    cancelBt.imageEdgeInsets = UIEdgeInsetsMake(0,-5,0,0);
    cancelBt.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    mainScrollV = [[UIScrollView alloc]init];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    if ([isSW intValue] == 0){
        
        [self.view addSubview:cancelBt];
        mainScrollV.frame=CGRectMake(13, IOS7_Height, __MainScreen_Width-26, __MainScreen_Height-IOS7_Height-46);
    }else{
        
        mainScrollV.frame=CGRectMake(13, IOS7_Height, __MainScreen_Width-26, __MainScreen_Height-IOS7_Height);
    }
    
    mainScrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainScrollV];
    UILabel *nameL = [[UILabel alloc]init];
    nameL.font = [UIFont systemFontOfSize:14];
    nameL.textColor = [ToolList getColor:@"999999"];
    [mainScrollV addSubview:nameL];
    
    NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ %@",[_dataDic objectForKey:@"linkManName"],[_dataDic objectForKey:@"sex"]]];
    NSInteger leng = [[_dataDic objectForKey:@"linkManName"] length];
    //设置字体
    [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25]range:NSMakeRange(0, leng+1)];//设置所有的字体
    // 设置颜色
    [attrString1 addAttribute:NSForegroundColorAttributeName
                        value:[ToolList getColor:@"333333"]
                        range:NSMakeRange(0, leng+1)];
    
    nameL.attributedText = attrString1;
    
    UIFont *font = [UIFont systemFontOfSize:25];
    CGSize size = CGSizeMake(200000,83.5); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize labelsize = [[_dataDic objectForKey:@"linkManName"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
     
    UIFont *font1 = [UIFont systemFontOfSize:14];
    CGSize size1 = CGSizeMake(200000,83.5); //设置一个行高上限
    NSDictionary *attribute1 = @{NSFontAttributeName: font1};
    CGSize labelsize1 = [[_dataDic objectForKey:@"sex"] boundingRectWithSize:size1 options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    nameL.frame = CGRectMake(0, 0,labelsize.width+labelsize1.width+25 , 83.5);
    
    UIImageView *changImage = [[UIImageView alloc]init];
    
    changImage.frame = CGRectMake(nameL.frame.size.width,( nameL.frame.size.height-15)/2+2, 15, 15);
    
    changImage.image = [UIImage imageNamed:@"icon_kexq_lxr_changyong.png"];
    
    [mainScrollV addSubview:changImage];
    
    if (self.isChang){
        
        changImage.hidden = NO;
     
    }else{
        
        if ([[_dataDic objectForKey:@"flag"] intValue]==1) {
            
           changImage.hidden = NO;

           
        }else{
            
           changImage.hidden = YES;
  
        }
    }
   
    
    //线
    [nameL.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, nameL.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width-26,nameL.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
    
    height = 83.5f;
    
    for (int i=0; i<5; i++) {
        
        UILabel *classL = [[UILabel alloc]initWithFrame:CGRectMake(0, height+i*50.5, __MainScreen_Width-26, 50.5)];
        classL.textColor = [ToolList getColor:@"333333"];
        classL.font = [UIFont systemFontOfSize:16];
        [mainScrollV addSubview:classL];
        
        NSString *string;
        switch (i) {
            case 0:
              
                string =[NSString stringWithFormat:@" 职位：%@",[_dataDic objectForKey:@"postion"]];
                break;
                
            case 1:
                string =[NSString stringWithFormat:@" 部门：%@",[_dataDic objectForKey:@"manDepartment"]];
                break;
                
            case 2:
            {
                string =[NSString stringWithFormat:@" 电话：%@",[_dataDic objectForKey:@"mobilePhone"]];
                
                UIButton *telB = [UIButton buttonWithType:UIButtonTypeCustom];
                telB.frame = CGRectMake(0, height+i*50.5, __MainScreen_Width-26, 50.5);
                telB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                telB.tag = -1;
                [telB addTarget:self action:@selector(cellTel:) forControlEvents:UIControlEventTouchUpInside];
                [telB setImage:[UIImage imageNamed:@"btn_phone.png"] forState:UIControlStateNormal];
                //            telB.backgroundColor = [UIColor yellowColor];
                [mainScrollV addSubview:telB];

            }
                break;
                
            case 3:
             string =[NSString stringWithFormat:@" 邮箱：%@",[_dataDic objectForKey:@"email"]];
                break;
                
            case 4:{
                
                if (self.isChang){
                    
                     string =[NSString stringWithFormat:@" 公司：%@",[_dataDic objectForKey:@"custName"]];
                    
                }else{
                    
                     string =[NSString stringWithFormat:@" 公司：%@",_custNameStr];
                }
            }
               
                break;
            
            default:
                break;
        }
        
        if ([string length]) {
            NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:string];
            //设置字体
            [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15]range:[string rangeOfString:@"："]];//设置所有的字体
            // 设置颜色
            [attrString1 addAttribute:NSForegroundColorAttributeName
                                value:[ToolList getColor:@"999999"]
                                range:[string rangeOfString:@"："]];
            classL.attributedText = attrString1;
            
        }
        
        //线
        [classL.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, classL.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width-26,classL.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
       
    }
    
    height += 5*50.5;
    
    NSArray *telArr = [_dataDic objectForKey:@"telList"];
    
    if (telArr.count) {
        
        [self makeLandArr:telArr andTitle:@"电话" isTel:YES];

    }
   
     NSArray *eamilArr = [_dataDic objectForKey:@"mailList"];
    
    if (eamilArr.count) {
         [self makeLandArr:eamilArr andTitle:@"邮箱" isTel:NO];
    }
    
    NSArray *qqlArr = [_dataDic objectForKey:@"qqList"];
    if (qqlArr.count) {
      [self makeLandArr:qqlArr andTitle:@" QQ" isTel:NO];

    }
    
    if ([[_dataDic objectForKey:@"msnList"] count ]) {        
         [self makeLandArr:[_dataDic objectForKey:@"msnList"] andTitle:@"MSN" isTel:NO];
    }
    if ([[_dataDic objectForKey:@"wxList"] count ]) {
        
        [self makeLandArr:[_dataDic objectForKey:@"wxList"] andTitle:@"微信" isTel:NO];
    }
    
    if ([[_dataDic objectForKey:@"faxList"] count ]) {
        
        [self makeLandArr:[_dataDic objectForKey:@"faxList"] andTitle:@"传真" isTel:NO];
    }
    if ([[_dataDic objectForKey:@"letterList"] count ]) {
        
        [self makeLandArr:[_dataDic objectForKey:@"letterList"] andTitle:@"信件" isTel:NO];
    }
    
    
    //chen  改的 添加网址  地址  邮编
    if ([[_dataDic objectForKey:@"websiteList"] count ]) {
        
        [self makeLandArr:[_dataDic objectForKey:@"websiteList"] andTitle:@"网址" isTel:NO];
    }
    for (int i=0; i<2; i++) {
        
        UILabel *classL = [[UILabel alloc]initWithFrame:CGRectMake(0, height+i*50.5, __MainScreen_Width-26, 50.5)];
        classL.textColor = [ToolList getColor:@"333333"];
        classL.font = [UIFont systemFontOfSize:16];
        [mainScrollV addSubview:classL];
        
        NSString *string;
        switch (i) {
            
                
            case 0:
                if ([[_dataDic objectForKey:@"address"] length]) {

                string =[NSString stringWithFormat:@" 地址：%@",[_dataDic objectForKey:@"address"]];
                }
                break;
                
            case 1:
                if ([[_dataDic objectForKey:@"zipCode"] length]) {

                string =[NSString stringWithFormat:@" 邮编：%@",[_dataDic objectForKey:@"zipCode"]];
                }
                break;
                
            default:
                break;
        }
 
        if ([string length]) {
            
            NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:string];
            //设置字体
            [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15]range:[string rangeOfString:@"："]];//设置所有的字体
            // 设置颜色
            [attrString1 addAttribute:NSForegroundColorAttributeName
                                value:[ToolList getColor:@"999999"]
                                range:[string rangeOfString:@"："]];
            classL.attributedText = attrString1;
            //线
            [classL.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, classL.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width-26,classL.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
            
        }

        
        
    }
    height += 2*50.5;
//end
    mainScrollV.contentSize = CGSizeMake(__MainScreen_Width-26, height-1);
}

-(void)makeLandArr:(NSArray *)dataArr andTitle:(NSString *)title isTel:(BOOL)isTel{
    
    for (int j=0; j<dataArr.count; j++) {
        
        UILabel *qqL = [[UILabel alloc]initWithFrame:CGRectMake(0, height+j*50.5, __MainScreen_Width-26, 50.5)];
        qqL.textColor = [ToolList getColor:@"333333"];
        qqL.font = [UIFont systemFontOfSize:16];
        [mainScrollV addSubview:qqL];
        
        if (isTel) {
            
            UIButton *telB = [UIButton buttonWithType:UIButtonTypeCustom];
            telB.frame = CGRectMake(0, qqL.frame.origin.y, qqL.frame.size.width-7, qqL.frame.size.height);
            telB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            telB.tag = j;
            [telB addTarget:self action:@selector(cellTel:) forControlEvents:UIControlEventTouchUpInside];
            [telB setImage:[UIImage imageNamed:@"btn_phone.png"] forState:UIControlStateNormal];
//            telB.backgroundColor = [UIColor yellowColor];
            [mainScrollV addSubview:telB];
        }
       
        
        NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@%d：%@",title,j+1,[dataArr objectAtIndex:j]]];
        //设置字体
        [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15]range:NSMakeRange(0, title.length+3)];//设置所有的字体
        // 设置颜色
        [attrString1 addAttribute:NSForegroundColorAttributeName
                            value:[ToolList getColor:@"999999"]
                            range:NSMakeRange(0, title.length+3)];
        
        qqL.attributedText = attrString1;
        //线
        [qqL.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, qqL.frame.size.height-0.5) toPoint:CGPointMake(__MainScreen_Width-26,qqL.frame.size.height-0.5) andWeight:0.5 andColorString:@"e7e7e7b"]];
    }

    height += dataArr.count*50.5;
}

-(void)cellTel:(UIButton *)telBt{
    
    if (telBt.tag == -1) {
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[_dataDic objectForKey:@"mobilePhone"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }else{
    
        NSInteger tag = telBt.tag;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[[_dataDic objectForKey:@"telList"]objectAtIndex:tag]];
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark---取消常用联系人

-(void)isCancelBt:(UIButton *)sender{
    
    if (sender.tag == -1) {//取消常用联系人
        
        
        NSMutableDictionary *searchRequestDic = [[NSMutableDictionary alloc] init];
        
        [searchRequestDic setObject:[_dataDic objectForKey:@"linkManId"] forKey:@"linkManId"];
        
        [FX_UrlRequestManager postByUrlStr:deleteFrequentContact_url andPramas:searchRequestDic andDelegate:self andSuccess:@"deleteFrequentContactSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else if (sender.tag == -2){
        
        NSMutableDictionary *searchRequestDic = [[NSMutableDictionary alloc] init];
        
        [searchRequestDic setObject:[_dataDic objectForKey:@"custId"] forKey:@"custId"];
        [searchRequestDic setObject:_custNameStr forKey:@"custName"];
        [searchRequestDic setObject:[_dataDic objectForKey:@"linkManName"] forKey:@"linkManName"];
        [searchRequestDic setObject:[_dataDic objectForKey:@"linkManId"] forKey:@"linkManId"];
        [searchRequestDic setObject:[_dataDic objectForKey:@"sex"] forKey:@"sex"];
        [searchRequestDic setObject:[_dataDic objectForKey:@"manDepartment"] forKey:@"dept"];
        [searchRequestDic setObject:[_dataDic objectForKey:@"postion"] forKey:@"position"];
        [searchRequestDic setObject:[_dataDic objectForKey:@"address"] forKey:@"address"];
        [searchRequestDic setObject:[_dataDic objectForKey:@"zipCode"] forKey:@"zipCode"];
        [FX_UrlRequestManager postByUrlStr:convertContact_url andPramas:searchRequestDic andDelegate:self andSuccess:@"deleteFrequentContactSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
  
}

-(void)deleteFrequentContactSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
         NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"CHANGYONGREN" object:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
