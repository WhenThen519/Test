//
//  New_ShouCangDetailMore.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/2.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "New_ShouCangDetailMore.h"
@interface New_ShouCangDetailMore ()
{
    NSDictionary *detailDic;
}
@end

@implementation New_ShouCangDetailMore
-(void) requestAlldata
{
    //
    NSMutableDictionary *requestDic1 = [[NSMutableDictionary alloc] init];
    [requestDic1 setObject:_custId forKey:@"custId"];
    
    //
    [FX_UrlRequestManager postByUrlStr:custDetailList andPramas:requestDic1 andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    
    
    
}
-(void)requestSuccess:(NSDictionary *)dic1
{
    detailDic  = [dic1 objectForKey:@"result"] ;
    
}
- (IBAction)btnClicked:(id)sender {
    UIButton *bb = sender;
    NSLog(@"%ld",bb.tag);

    switch (bb.tag) {
            //备案数量
        case 1:
        {
            NSArray *arr1 = [detailDic objectForKey:@"ICPRecordList"];
            if(arr1.count == 0)
            {
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            }
            else
            {
            NSMutableArray *arrALL = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr1) {
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    [subArr addObject:[NSString stringWithFormat:@"备案号:%@",[dic objectForKey:@"record"]]];
                    [subArr addObject:[NSString stringWithFormat:@"企业名称:%@",[dic objectForKey:@"cust"]]];
                    [subArr addObject:[NSString stringWithFormat:@"网站:%@",[dic objectForKey:@"site"]]];
                    [subArr addObject:[NSString stringWithFormat:@"审核日期:%@",[dic objectForKey:@"auditTime"]]];
                    [arrALL addObject:subArr];
                }
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = arrALL;
                o.title_Show = @"备案信息";
                [self.navigationController pushViewController:o animated:NO];
            }
            break;
        }
            //推广数量
        case 2:
        {
            NSArray *arr1 = [detailDic objectForKey:@"channelHintDetail"];
            if(arr1.count == 0)
            {
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            }
            else
            {
              
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = @[arr1];
                o.title_Show = @"渠道线索";
                [self.navigationController pushViewController:o animated:NO];
            }
            break;
        }
        //技术线索
        case 3:
        {
            NSArray *arr1 = [detailDic objectForKey:@"ICPRecordList"];
            if(arr1.count == 0)
            {
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            }
            else
            {
                NSMutableArray *arrALL = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr1) {
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    NSString * html5 = (bool)[dic objectForKey:@"html5"]==true?@"是":@"否";
                    NSString * css3 = (bool)[dic objectForKey:@"css3"]==true?@"是":@"否";
                    NSString * mainTech = (bool)[dic objectForKey:@"mainTech"]==true?@"是":@"否";

                    [subArr addObject:[NSString stringWithFormat:@"网站:%@",[dic objectForKey:@"site"]]];
                    [subArr addObject:[NSString stringWithFormat:@"是否使用HTML5技术:%@",html5]];
                    [subArr addObject:[NSString stringWithFormat:@"是否使用CSS3技术:%@",css3]];
                    [subArr addObject:[NSString stringWithFormat:@"是否使用了主流架构:%@",mainTech]];
                    [arrALL addObject:subArr];
                }
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = arrALL;
                o.title_Show = @"技术线索";
                [self.navigationController pushViewController:o animated:NO];
            }
            break;
        }
            //IP 位置线索
        case 4:
        {
            NSArray *arr1 = [detailDic objectForKey:@"ipAddressHintDetail"];
            if(arr1.count == 0)
            {
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            }
            else
            {
                NSMutableArray *arrALL = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr1) {
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    
                    [subArr addObject:[NSString stringWithFormat:@"网站:%@",[dic objectForKey:@"site"]]];
                    [subArr addObject:[NSString stringWithFormat:@"服务器位置:%@",[dic objectForKey:@"address"]]];
                    [subArr addObject:[NSString stringWithFormat:@"备注:%@",[dic objectForKey:@"desc"]]];
                  
                    [arrALL addObject:subArr];
                }
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = arrALL;
                o.title_Show = @"IP 位置线索";
                [self.navigationController pushViewController:o animated:NO];
            }
            break;
        }
            //W3C 标准线索
        case 5:
        {
                NSMutableArray *arrALL = [[NSMutableArray alloc] init];
                NSDictionary *dic = [_receiveDic objectForKey:@"W3CHintDetail"];
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    if(dic.count)
                    {
                    [subArr addObject:[NSString stringWithFormat:@"偏离 W3C 标准:%@",[dic objectForKey:@"bias"]]];
                    [subArr addObject:[NSString stringWithFormat:@"正常参考值范围:%@",[dic objectForKey:@"standard"]]];
                    
                    [arrALL addObject:subArr];
                
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = arrALL;
                o.title_Show = @"W3C 标准线索";
                [self.navigationController pushViewController:o animated:NO];
                    }
                else
                {
                 [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
                }
            
            break;
        }
            //百度权重线索
        case 6:
        { NSArray *arr1 = [detailDic objectForKey:@"ICPRecordList"];
            if(arr1.count == 0)
            {
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            }
            else
            {
                NSMutableArray *arrALL = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr1) {
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    
                    [subArr addObject:[NSString stringWithFormat:@"网站:%@",[dic objectForKey:@"site"]]];
                    [subArr addObject:[NSString stringWithFormat:@"百度权重:%@",[dic objectForKey:@"weight"]]];
                    [subArr addObject:[NSString stringWithFormat:@"描述:%@",[dic objectForKey:@"desc"]]];
                    
                    [arrALL addObject:subArr];
                }
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = arrALL;
                o.title_Show = @"百度权重线索";
                [self.navigationController pushViewController:o animated:NO];
            }

            break;
        }
            //访问速度线索
        case 7:
        {
            NSArray *arr1 = [detailDic objectForKey:@"responseTimeHintDetail"];
            if(arr1.count == 0)
            {
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            }
            else
            {
                NSMutableArray *arrALL = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr1) {
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    
                    [subArr addObject:[NSString stringWithFormat:@"网站:%@",[dic objectForKey:@"site"]]];
                    [subArr addObject:[NSString stringWithFormat:@"速度:%@",[dic objectForKey:@"speed"]]];
                    [subArr addObject:[NSString stringWithFormat:@"结果:%@",[dic objectForKey:@"result"]]];
                    
                    [arrALL addObject:subArr];
                }
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = arrALL;
                o.title_Show = @"访问速度线索";
                [self.navigationController pushViewController:o animated:NO];
            }
            break;
        }
            //错误率线索
        case 8:
        {
            NSArray *arr1 = [detailDic objectForKey:@"errorRateHintDetail"];
            if(arr1.count == 0)
            {
                [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
            }
            else
            {
                NSMutableArray *arrALL = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in arr1) {
                    NSMutableArray *subArr = [[NSMutableArray alloc] init];
                    
                    [subArr addObject:[NSString stringWithFormat:@"网站:%@",[dic objectForKey:@"site"]]];
                    [subArr addObject:[NSString stringWithFormat:@"错误率:%@",[dic objectForKey:@"rate"]]];
                    [subArr addObject:[NSString stringWithFormat:@"结果:%@",[dic objectForKey:@"result"]]];
                    
                    [arrALL addObject:subArr];
                }
                OnlyShow *o = [[OnlyShow alloc] init];
                o.dataArr = arrALL;
                o.title_Show = @"错误率线索";
                [self.navigationController pushViewController:o animated:NO];
            }

            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
         [self addNavgationbar:@"客户详情" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    _w.constant = __MainScreen_Width-9;
    [self requestAlldata];
    NSDictionary *   dic = _receiveDic;
    self.name.text = [ToolList changeNull:[dic objectForKey:@"custName"]];
    self.dizhi.text = [NSString stringWithFormat:@"地址:%@",[ToolList changeNull:[dic objectForKey:@"address"]]];
    self.guimo.text = [NSString stringWithFormat:@"规模:%@",[ToolList changeNull:[dic objectForKey:@"custRegisterPeopleNumberType"]]];
    self.zhucezijin.text = [NSString stringWithFormat:@"注册资金:%@万",[ToolList changeNull:[dic objectForKey:@"custRegisterMoney"]]];
    self.hangye.text = [NSString stringWithFormat:@"行业:%@",[ToolList changeNull:[dic objectForKey:@"industryClassBig"]]];
     self.yc.text = [NSString stringWithFormat:@"预存账户余额:%@",[ToolList changeNull:[dic objectForKey:@"balanceMoney"]]];
    self.zz.text = [NSString stringWithFormat:@"转款账户余额:%@",[ToolList changeNull:[dic objectForKey:@"transferMoney"]]];
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
        [self.xin setBackgroundImage:nil forState:UIControlStateNormal];
        self.xin.backgroundColor = [UIColor redColor];
        [self.xin setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"releaseCount"]] forState:UIControlStateNormal];
        [self.xin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

    NSString *contentStr =[NSString stringWithFormat:@"官网:%@",[ToolList changeNull:[dic objectForKey:@"homepage"]]];;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[ToolList getColor:@"999999"] range:NSMakeRange(0, 3)];
    self.guanwang.attributedText = str;
    
    self.chenglishijian.text = [NSString stringWithFormat:@"成立时间:%@",[ToolList changeNull:[dic objectForKey:@"createDate"]]];
    self.zhucezijin.text = [NSString stringWithFormat:@"注册资金:%@万",[ToolList changeNull:[dic objectForKey:@"custRegisterMoney"]]];
    self.hangye.text = [NSString stringWithFormat:@"行业:%@",[ToolList changeNull:[dic objectForKey:@"industryClassBig"]]];
    
    self.qiyeyouxiang.text = [NSString stringWithFormat:@"企业邮箱:%@",[ToolList changeNull:[dic objectForKey:@"custMail"]]];
    self.youbian.text = [NSString stringWithFormat:@"邮编:%@",[ToolList changeNull:[dic objectForKey:@"custPost"]]];
    self.faren.text = [NSString stringWithFormat:@"法人:%@",[ToolList changeNull:[dic objectForKey:@"custLegalReparesentative"]]];
    self.jingyingqixian.text = [NSString stringWithFormat:@"经营期限:%@",[ToolList changeNull:[dic objectForKey:@"custBusTerm"]]];
    self.jingyingfanwei.text = [NSString stringWithFormat:@"经营范围:%@",[ToolList changeNull:[dic objectForKey:@"custBusRank"]]];
//下面
    self.beianshuliang.text = [NSString stringWithFormat:@"备案数量:%@",[ToolList changeNull:[dic objectForKey:@"custNetRecordNumber"]]];
    self.qudaoxiansuo.text = [NSString stringWithFormat:@"渠道线索:%@",[ToolList changeNull:[dic objectForKey:@"channelHint"]]];
    self.jishuxiansuo.text = [NSString stringWithFormat:@"技术线索:%@",[ToolList changeNull:[dic objectForKey:@"webTechHint"]]];
    self.weizhixiansuo.text = [NSString stringWithFormat:@"IP 位置线索:%@",[ToolList changeNull:[dic objectForKey:@"ipAddressHint"]]];
    self.biaozhunxiansuo.text = [NSString stringWithFormat:@"W3C 标准线索:%@",[ToolList changeNull:[dic objectForKey:@"W3CHint"]]];
    self.baiduxiansuo.text = [NSString stringWithFormat:@"百度权重线索:%@",[ToolList changeNull:[dic objectForKey:@"baiduSEOHint"]]];
    self.fangwenxiansuo.text = [NSString stringWithFormat:@"访问速度线索:%@",[ToolList changeNull:[dic objectForKey:@"responseTimeHint"]]];
    self.cuowuxiansuo.text = [NSString stringWithFormat:@"错误率线索:%@",[ToolList changeNull:[dic objectForKey:@"errorRateHint"]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)link:(id)sender {
    if(_guanwang.text.length)
    {
        NSString * str=[_guanwang.text substringFromIndex:3];
        if(![str hasPrefix:@"http"]){
            str = [NSString stringWithFormat:@"http://%@",[_guanwang.text substringFromIndex:3]];
        }
        
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
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
