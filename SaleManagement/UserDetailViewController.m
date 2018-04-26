//
//  UserDetailViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/21.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "FenPeiSelectTools.h"
#import "CY_myClientVC.h"
#import "AlertWhyViewController.h"
#import "YixiangView.h"
#import "SbView.h"
#import "MP_ViewController.h"
#import "ChoseAddWay.h"
#import "DistributionDetailViewController.h"
#import "UserDetailViewController.h"
#import "Fx_TableView.h"
#import "CY_recordCell.h"
#import "UIImageView+WebCache.h"
#import "CY_writContenVc.h"
#import "CY_photoVc.h"
#import "CY_OneRecordVC.h"
#import "heTongCell.h"
#import "CY_popupV.h"
#import "ProductCell.h"
#import "CY_linkManCell.h"
#import "CY_addDetailsVC.h"
#import "CY_addMenVC.h"
#import "XiejiluViewController.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "CY_alertWhyVC.h"
#import "AlertSalersViewController.h"
#import "AddNewScheduleViewController.h"
#import "New_ShouCangDetailMore.h"
#define HANDVIEW_H 42
#define BARVIEW_H 46
#define LUN_TAG 109
#define ZAN_TAG 1232
#define NUM_TAB 1966
@interface UserDetailViewController ()
{

    //调用待分配页面需要的数据
    UIImage *chosenImage;//名片照片
    float hh;
    int flag;
    NSMutableArray *xinKehuArr ;
    NSMutableArray *wangzhankehuArr ;
    NSMutableArray *qitakehuArr ;
    NSDictionary *DetailDic;
    //页面底部的操作区域
    UIImageView *barImage;
    SbView *sb;
    //写记录操作view
    UIView *operateView0;
    //写记录、变更商务操作view
    UIView *operateView1;
    //释放、分配操作view
    UIView *operateView2;
    
    UIView *operateView3;
    //选择的产品标记
    long  productFlag;
    //产品选择下拉框背景三角图
    UIImageView *selectVIew;
    //产品选择下拉框视图
    UIView *productAlertView;
    NSMutableArray *detailLabelsArr;
    //记录
    UIView *countView;
    //联系人
    UIView *linkManView;
    //产品
    UIView *productView;
    //合同
    UIView *heTongView;
    //商机
    UIScrollView *sjScroll;

    //详情
    UIView *detailView;
    UIScrollView *detailView1;
    //操作集
    NSMutableArray * selectBtnArr;
    NSArray *doArr;
    BOOL isRe;//YES 加载更多 no 刷新
    //播语音
    AVAudioPlayer *audioPlayer;
    
    UITableView *chanpinTable;
    NSArray *chanpinArr;
    //产品个数
    UILabel *productNum_L;
    //产品筛选按钮
    UIButton *product_Select_Btn;
    //产品筛选按钮数组
    NSMutableArray *product_Select_Btn_Arr;
    UIView *blackV;
    NSDictionary* requestDic1;
    NSMutableDictionary *diccy;
    NSMutableArray *arrcy;
    NSString *typeStr;
    
    UIButton *baiFangBtn;
    UIButton *fanChaBtn;
}
@property(nonatomic,retain)UILabel *custName;
@property (nonatomic,strong)UITableView *linkManTabel;
@property (nonatomic,strong)NSMutableArray *linkManArr;
@property (nonatomic,strong)Fx_TableView *heTongTabel;
@property (nonatomic,strong)NSMutableArray *heTongArr;
@property (nonatomic,strong)Fx_TableView *countTabel;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSMutableDictionary *requestDic;
@property (nonatomic,strong)UIImageView *loadingImage;
@property (nonatomic,assign)NSInteger startPage;//第几页
@property (nonatomic,assign)NSInteger heTongStartPage;
@property (nonatomic,strong)NSMutableArray *zanArr;//承载是否被赞数组
@property (nonatomic,strong)NSMutableArray *zanNumArr;//被赞的次数
@property (nonatomic,strong)UIButton *senderbt;//
@property (nonatomic,strong)NSMutableArray *bigUrlArr;//显示大图的数组
@property (nonatomic,strong)NSMutableArray *emojiTags;//表情TAG

@property (nonatomic,strong)NSMutableArray *emojiImages;//表情对应图片

@property (nonatomic,strong)NSMutableArray *typeArr;//商务-底部操作栏中状态数组

@end

@implementation UserDetailViewController


-(id)initwithCust:(NSString *)custID{
    if (self ==[super init]) {
        _custId = custID;
    }
    return self;
}

#pragma mark - 产品筛选点击
-(void)productSelectBtnClicked:(UIButton *)btn
{
    selectVIew.hidden = !selectVIew.hidden;
}

#pragma mark - 产品筛选列表点击
-(void)product_Select_Btn_Clicked:(UIButton *)btn1
{
    for (int i = 0; i < product_Select_Btn_Arr.count; i ++) {
        UIButton *btn = [product_Select_Btn_Arr objectAtIndex:i];
        if(i == btn1.tag)
        {
            productFlag = btn1.tag;
            [btn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[ToolList getColor:@"999999"] forState:UIControlStateNormal];
        }
    }
    productFlag = btn1.tag;
    NSDictionary *dic= @{@"custId":_custId,@"productFlag":[NSNumber numberWithLong:productFlag]};
    [FX_UrlRequestManager postByUrlStr:CustBuyProduct_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"CustBuyProductSuccess:" andFaild:nil andIsNeedCookies:YES];
    selectVIew.hidden = !selectVIew.hidden;

}

#pragma mark - 返回
-(void)back
{
    if([_backWhere isEqualToString:@"home"])
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark - 根据后台返回flag选择到底有几列操作

-(void)listShowByOption
{
    if(flag == 1)
    {
    doArr = @[@"产品",@"联系人",@"记录",@"合同",@"商机",@"详情"];
        
        [self makeMideView:YES];
        [self meakFXB];
        
        if (_flagRefresh.length==0 || _flagRefresh==nil || _flagRefresh==NULL ||[_flagRefresh isEqualToString: @"chanpin"]) {
            
            _flagRefresh = @"chanpin";
  
            [self chanpinRequest];

        }
        
       else  if ([_flagRefresh isEqualToString: @"lianxiren"]) {
            
            [self changeBigAndColorClikedBack:[selectBtnArr objectAtIndex:1]];
        }
        else if ([_flagRefresh isEqualToString: @"jilu"]){
            
            [self changeBigAndColorClikedBack:[selectBtnArr objectAtIndex:2]];
        }

      
        
    }
    else
    {
        doArr = @[@"联系人",@"记录",@"商机",@"详情"];
         [self makeMideView:NO];
          [self meakFXB];
        if (_flagRefresh.length==0 || _flagRefresh==nil|| _flagRefresh==NULL ||[_flagRefresh isEqualToString: @"lianxiren"] ) {
           _flagRefresh = @"lianxiren";
                
            [self linkManRequest];
           
        }
        else if ([_flagRefresh isEqualToString: @"jilu"]){
            
            [self changeBigAndColorClikedBack:[selectBtnArr objectAtIndex:1]];
        }
        else if ([_flagRefresh isEqualToString: @"xiangqing"]){
            
            [self changeBigAndColorClikedBack:[selectBtnArr objectAtIndex:3]];
        }
    }
   
    
    
}


-(void)meakFXB{
    
    //头部点击操作区域-- 记录--联系人--产品--合同--详情
    UIImageView *handV = [[UIImageView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.24, __MainScreen_Width, HANDVIEW_H)];
    
    handV.userInteractionEnabled = YES;
    handV.image = [UIImage imageNamed:@"bg_filter.png"];
    [self.view addSubview:handV];
    [selectBtnArr removeAllObjects];
    for (int i = 0 ; i < doArr.count; i ++) {
        FX_Button *btn = [[FX_Button alloc] initWithFrame:CGRectMake(__MainScreen_Width/doArr.count*i, 0, __MainScreen_Width/doArr.count, SelectViewHeight-0.8) andType:@"2" andTitle:[doArr objectAtIndex:i] andTarget:self andDic:nil];
        btn.tag = i;
        [handV addSubview:btn];
        if(i == 0)
        {
            btn.isSelect = YES;
            [btn changeBigAndColorCliked:btn];
        }
        [selectBtnArr addObject:btn];
        
    }
    
}

#pragma mark - 经理操作权限和上面标记请求成功
-(void)CustTipSuccess:(NSDictionary *)dic
{
    if (diccy ==nil) {
        
        diccy = [[NSMutableDictionary alloc]init];
    }

    diccy = [dic objectForKey:@"result"];
    flag = [[diccy objectForKey:@"flag"] intValue];
    [self listShowByOption];
    if([_sjFlag isEqualToString:@"88"] || [_sjFlag isEqualToString:@"99"])
    {
        _contentL.text = @"";

    }
    else
    {
        _contentL.text = [diccy objectForKey:@"tip"];
  
    }
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    switch (isSW.intValue) {
        case 0://商务
        {
            
            if (_isShouCang) {
                
                
                return;
            }
            //收藏夹、状态、写记录
            if([[diccy objectForKey:@"operate"] intValue]==0)
            {
                if ([operateView0 superview]) {
                    
                    [barImage bringSubviewToFront:operateView0];
                    
                }else{
                    
                    [barImage addSubview:operateView0];
                }
                
                UIButton *typeBt = (UIButton *)[operateView0 viewWithTag:1000];
                [typeBt setTitle:[NSString stringWithFormat:@"%@",[diccy objectForKey:@"intentType"]] forState:UIControlStateNormal];
            }
            //保护跟进、状态、写记录
            if([[diccy objectForKey:@"operate"] intValue]==1)
            {
                if ([operateView1 superview]) {
                    
                    [barImage bringSubviewToFront:operateView1];
                    
                }else{
                    
                   [barImage addSubview:operateView1];
                }
               
                UIButton *typeBt = (UIButton *)[operateView1 viewWithTag:1001];
                [typeBt setTitle:[NSString stringWithFormat:@"%@",[diccy objectForKey:@"intentType"]] forState:UIControlStateNormal];
            }
            //状态、写记录
            if([[diccy objectForKey:@"operate"] intValue]==2)
            {
//                [barImage addSubview:operateView2];
                if ([operateView2 superview]) {
                    
                    [barImage bringSubviewToFront:operateView2];
                    
                }else{
                    
                    [barImage addSubview:operateView2];
                }
                UIButton *typeBt = (UIButton *)[operateView2 viewWithTag:1002];
                [typeBt setTitle:[NSString stringWithFormat:@"%@",[diccy objectForKey:@"intentType"]] forState:UIControlStateNormal];
            }
            

        }
            break;
            
        case 1://经理
        {
            
            //写记录
            if([[diccy objectForKey:@"operate"] intValue]==0)
            {
                [barImage addSubview:operateView0];
            }
            //写记录，变更商务
            if([[diccy objectForKey:@"operate"] intValue]==1)
            {
                [barImage addSubview:operateView1];
                
            }
            //释放，分配
            if([[diccy objectForKey:@"operate"] intValue]==2)
            {
                [barImage addSubview:operateView2];
                
            }
            
            //分配
            if([[diccy objectForKey:@"operate"] intValue]==3)
            {
                [barImage addSubview:operateView3];
                
            }
            
        }
            break;
        case 2://总监
        {
            //写记录
            if([[diccy objectForKey:@"operate"] intValue]==0)
            {
                [barImage addSubview:operateView0];
            }
            //写记录，变更商务
            if([[diccy objectForKey:@"operate"] intValue]==1)
            {
                [barImage addSubview:operateView1];
                
            }
            //释放，分配
            if([[diccy objectForKey:@"operate"] intValue]==2)
            {
                [barImage addSubview:operateView2];
                
            }
            
            //分配
            if([[diccy objectForKey:@"operate"] intValue]==3)
            {
                [barImage addSubview:operateView3];
                
            }

        }
            break;
            
            
            
        default:
            break;
    }
    

 
}
#pragma mark - 释放按钮点击
-(void)shiFangBtnClicked:(UIButton *)btn
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:_custId];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    if (isSW.intValue == 2) {//总监
        
        [FX_UrlRequestManager postByUrlStr:ZJReleaseCust_url andPramas:[NSMutableDictionary dictionaryWithObject:arr forKey:@"custIds"] andDelegate:self andSuccess:@"shifangSuccess:" andFaild:nil andIsNeedCookies:YES];
        
        return;
    }
    
    [FX_UrlRequestManager postByUrlStr:ReleaseCust_url andPramas:[NSMutableDictionary dictionaryWithObject:arr forKey:@"custIds"] andDelegate:self andSuccess:@"shifangSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 释放成功
-(void)shifangSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"code"] intValue]==200)
    {

        [[NSNotificationCenter defaultCenter]postNotificationName:@"myClientV" object:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - 分配按钮点击
-(void)fenPeiBtnClicked:(UIButton *)btn
{
    
}
#pragma mark - 查询商务经理名下客户剩余名额
-(void)chaYuSuccess:(NSDictionary *)dic
{
    DistributionDetailViewController *detail = [[DistributionDetailViewController alloc] init];
    detail.dataArr = [dic objectForKey:@"result"];
    detail.refreshIndex = 0;
    if(detail.dataArr.count)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:xinKehuArr];
        [arr addObjectsFromArray:wangzhankehuArr];
        [arr addObjectsFromArray:qitakehuArr];
        detail.custIds = arr;
        detail.selectDic = requestDic1;
        detail.czBlock = ^(int index)
        {
            if(index == 0)
            {
                [self.navigationController popViewControllerAnimated:NO];
            }
        };
        [self.navigationController pushViewController:detail animated:NO]; 
    }
    else
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无合适的分配人员"];
    }
}

#pragma mark-- 商务写记录按钮点击
-(void)swxieJiluBtnClicked:(UIButton *)btn{
    
    if ([self.view viewWithTag:6839]) {
        
        [[self.view viewWithTag:6839]removeFromSuperview];
    }

    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"other";
    gh.kehuNameStr = _custNameStr;
    gh.kehuNameId = _custId;
     _flagRefresh = @"jilu";

    [self.navigationController pushViewController:gh animated:NO];
}

#pragma mark-- 写记录按钮点击

-(void)xieJiluBtnClicked:(UIButton *)btn
{
    if ([self.view viewWithTag:6839]) {
        
        [[self.view viewWithTag:6839]removeFromSuperview];
    }
    
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"经理";
    gh.fromPage = @"other";
    gh.kehuNameStr = _custNameStr;
    gh.kehuNameId = _custId;
    _flagRefresh = @"jilu";
    [self.navigationController pushViewController:gh animated:NO];
}
#pragma mark - 查询调整余额成功
-(void)salerProtectCountSuccess:(NSDictionary *)dic
{
    DistributionDetailViewController *detail = [[DistributionDetailViewController alloc] init];
    detail.dataArr = [dic objectForKey:@"result"];
    detail.refreshIndex = 0;
    detail.flag = @"tiaozheng";
    detail.custId = _custId;
    if(detail.dataArr.count)
    {
        detail.czBlock = ^(int index)
        {
            if(index == 0)
            {
                [self.navigationController popViewControllerAnimated:NO];
            }
            
        };
        [self.navigationController pushViewController:detail animated:NO];
    }
}

#pragma mark - 变更商务按钮点击
-(void)biangengshangwuBtnClicked:(UIButton *)btn
{
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    if (isSW.intValue == 2) {//总监
        
        AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
        dd.selectOKBlock = ^(NSString *salerId)
        {
            //总监调整页面
            NSDictionary *dic  = @{@"custId":_custId,@"adjustCustToDept":salerId};
            [FX_UrlRequestManager postByUrlStr:ZJadjustCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"ZJassignCustToDeptSuccess:" andFaild:nil andIsNeedCookies:YES];
        };
        
        [self.navigationController pushViewController:dd animated:NO];
        
        return;
    }
    
   //经理
    NSDictionary *dic= @{@"custId":_custId};
    [FX_UrlRequestManager postByUrlStr:SalerProtectCount_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"salerProtectCountSuccess:" andFaild:nil andIsNeedCookies:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    productFlag = 0;
    //请求经理操作权限
    NSDictionary *dic= @{@"custId":_custId,@"productFlag":[NSNumber numberWithLong:productFlag]};
    [FX_UrlRequestManager postByUrlStr:CustTip_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"CustTipSuccess:" andFaild:nil andIsNeedCookies:YES];
    
    
  }


#pragma mark - 释放后返回列表页
-(void)shifangok{
    
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark----shangji的操作
-(void)makeSjDoview{
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    for (UIView *sub in barImage.subviews) {
        if (sub) {
            [sub removeFromSuperview];
        }
    }
    for (UIView *sub in operateView2.subviews) {
        if (sub) {
            [sub removeFromSuperview];
        }
    }
    //商务
    if(isSW.integerValue == 0){
        operateView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
        
        UIButton* shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shiFangBtn setTitle:@"放弃" forState:UIControlStateNormal];
        shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        shiFangBtn.backgroundColor = [UIColor clearColor];
        shiFangBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, BARVIEW_H);
        [shiFangBtn addTarget:self action:@selector(fangqi) forControlEvents:UIControlEventTouchUpInside];
        [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_shifang.png"] forState:UIControlStateNormal];
        [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [operateView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
        [operateView2 addSubview:shiFangBtn];
        
        UIButton* fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [fenPeiBtn setTitle:@"保护" forState:UIControlStateNormal];
        fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
        fenPeiBtn.backgroundColor = [UIColor clearColor];
        
        [fenPeiBtn addTarget:self action:@selector(baohu) forControlEvents:UIControlEventTouchUpInside];
        [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
        [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, BARVIEW_H);
        [operateView2 addSubview:fenPeiBtn];
        [barImage addSubview:operateView2];
    }
    else
    {
    //根据权限判断意向客户几个操作
    int countNo = (isSW.intValue == 1)? 2:3;

    operateView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
    
    UIButton* shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"放弃" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 0, __MainScreen_Width/countNo, BARVIEW_H);
    [shiFangBtn addTarget:self action:@selector(fangqi) forControlEvents:UIControlEventTouchUpInside];
    [operateView2 addSubview:shiFangBtn];
    [operateView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/countNo, 12) toPoint:CGPointMake(__MainScreen_Width/countNo, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];

    UIButton* fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配商务" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
    
    [fenPeiBtn addTarget:self action:@selector(fenPeiSW) forControlEvents:UIControlEventTouchUpInside];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/countNo, 0, __MainScreen_Width/countNo, BARVIEW_H);
    [operateView2 addSubview:fenPeiBtn];
    [barImage addSubview:operateView2];
    
    UIButton* fenPeiBMBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBMBtn setTitle:@"分配部门" forState:UIControlStateNormal];
    fenPeiBMBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBMBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBMBtn.backgroundColor = [UIColor clearColor];
    
    [fenPeiBMBtn addTarget:self action:@selector(fenPeiBM) forControlEvents:UIControlEventTouchUpInside];
    fenPeiBMBtn.frame = CGRectMake(__MainScreen_Width/countNo*2, 0, __MainScreen_Width/countNo, BARVIEW_H);
    if(isSW.intValue == 2)
    {
        [operateView2 addSubview:fenPeiBMBtn];
        [operateView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/countNo*2, 12) toPoint:CGPointMake(__MainScreen_Width/countNo*2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];

    }
        [barImage addSubview:operateView2];

    }
    
}

#pragma mark - 释放理由查询成功
-(void)ReleseCustReason:(NSDictionary *)dic
{
    AlertWhyViewController *dd = [[AlertWhyViewController alloc] init];
    
    dd.isNeedOther = NO;
    dd.IntentCustId = _custId;
    [dd startTable:[dic objectForKey:@"result"]];
    
    [self.navigationController pushViewController:dd animated:NO];
    
    
}

#pragma mark - 点击放弃
-(void)fangqi
{
 
        [FX_UrlRequestManager postByUrlStr:ReleseCustReason_url andPramas:nil andDelegate:self andSuccess:@"ReleseCustReason:" andFaild:nil andIsNeedCookies:NO];
}

#pragma mark - 分配商务
-(void)fenPeiSW
{
    
    //总监角色传所有，经理只传商务（数组之前已经提前判断好，直接传过去就行）
    FenPeiSelectTools *tooll = [[FenPeiSelectTools alloc] init];
    tooll.data = _buMenArr;
    tooll.custId = _custId;
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    if(isSW.intValue == 2)
    {
        tooll.all = YES;
    }
    else
    {
        tooll.all = NO;
    }
    [self.navigationController pushViewController:tooll animated:NO];
}
#pragma mark - 分配部门
-(void)fenPeiBM
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    
    //只把部门传过去
    for (NSDictionary *dic in _buMenArr) {
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
        
        [dic1 setObject:[dic objectForKey:@"deptId"] forKey:@"deptId"];
        [dic1 setObject:[dic objectForKey:@"deptName"] forKey:@"deptName"];
        [arr addObject:dic1];
        
    }
    FenPeiSelectTools *tooll = [[FenPeiSelectTools alloc] init];
    tooll.data = arr;
    tooll.all = NO;
    tooll.custId = _custId;
    [self.navigationController pushViewController:tooll animated:NO];
    
    
}
#pragma mark - 获得所有部门成功
-(void)getDeptSuccess:(NSDictionary *)dic
{
    [_buMenArr removeAllObjects];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    NSArray *tempArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
    
    [_buMenArr addObjectsFromArray:tempArr];
    
    //    [self makeSeachView];
    
}

-(void)baohu{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_custId forKey:@"custId"];
   

   [FX_UrlRequestManager postByUrlStr:protectSjIntentCust andPramas:dic andDelegate:self andSuccess:@"baohuReason:" andFaild:nil andIsNeedCookies:YES];
}
-(void)baohuReason:(NSDictionary *)dic
{
    UIAlertController *alert    = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"保护成功！" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction     = [UIAlertAction actionWithTitle:@"返回意向客户" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"查看我的客户" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        CY_myClientVC *ghVC = [[CY_myClientVC alloc]init];
        ghVC.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationController pushViewController:ghVC animated:NO];
    
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark----总监+经理的操作
-(void)makeZJview{
    
    operateView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
    
    UIButton* xieJiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    xieJiluBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [xieJiluBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    xieJiluBtn.backgroundColor = [UIColor clearColor];
    xieJiluBtn.frame = CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H);
    [xieJiluBtn addTarget:self action:@selector(xieJiluBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [xieJiluBtn setImage:[UIImage imageNamed:@"icon_cz_xiejilu.png"] forState:UIControlStateNormal];
    [xieJiluBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    switch (isSW.intValue) {
        case 0://商务
        {
            
            [xieJiluBtn setTitle:@"写记录" forState:UIControlStateNormal];
            [operateView0 addSubview:xieJiluBtn];
        }
            break;
            
        case 1://经理
        {
            
            [xieJiluBtn setTitle:@"回访" forState:UIControlStateNormal];

        }
            break;
        case 2://总监
        {
            [xieJiluBtn setTitle:@"回访" forState:UIControlStateNormal];

        }
            break;
        default:
            break;
    }
  
   
    
    operateView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
    
    
    UIButton* biangengshangwuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isSW.intValue == 1) {
        
       [biangengshangwuBtn setTitle:@"变更商务" forState:UIControlStateNormal];
    }
    else if (isSW.intValue == 2){
        [biangengshangwuBtn setTitle:@"变更部门" forState:UIControlStateNormal];
    }
   
    biangengshangwuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [biangengshangwuBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    biangengshangwuBtn.backgroundColor = [UIColor clearColor];
 
    [biangengshangwuBtn addTarget:self action:@selector(biangengshangwuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [biangengshangwuBtn setImage:[UIImage imageNamed:@"icon_cz_bgsw.png"] forState:UIControlStateNormal];
    [biangengshangwuBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [operateView1 addSubview:biangengshangwuBtn];
    
    UIButton* xieJiluBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    xieJiluBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [xieJiluBtn1 setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    xieJiluBtn1.backgroundColor = [UIColor clearColor];
    xieJiluBtn1.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, BARVIEW_H);
    [xieJiluBtn1 addTarget:self action:@selector(xieJiluBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [xieJiluBtn1 setImage:[UIImage imageNamed:@"icon_cz_xiejilu.png"] forState:UIControlStateNormal];
    [xieJiluBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    switch (isSW.intValue) {
        case 0://商务
        {
            biangengshangwuBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, BARVIEW_H);
            [operateView1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
            [xieJiluBtn1 setTitle:@"写记录" forState:UIControlStateNormal];
             [operateView1 addSubview:xieJiluBtn1];
        }
            break;
            
        case 1://经理
        {
             biangengshangwuBtn.frame = CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H);
//            [xieJiluBtn1 setTitle:@"回访" forState:UIControlStateNormal];
            
        }
            break;
        case 2://总监
        {
             biangengshangwuBtn.frame = CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H);
//            [xieJiluBtn1 setTitle:@"回访" forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
   
   
    
    operateView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
    
    UIButton* shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shiFangBtn setTitle:@"释放" forState:UIControlStateNormal];
    shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    shiFangBtn.backgroundColor = [UIColor clearColor];
    shiFangBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, BARVIEW_H);
    [shiFangBtn addTarget:self action:@selector(shiFangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_shifang.png"] forState:UIControlStateNormal];
    [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [operateView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
    [operateView2 addSubview:shiFangBtn];
   
    UIButton* fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    fenPeiBtn.backgroundColor = [UIColor clearColor];
  
    [fenPeiBtn addTarget:self action:@selector(zjfenPeiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, BARVIEW_H);
    [operateView2 addSubview:fenPeiBtn];
   
    //分配
    operateView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
    
    UIButton* ZJfenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ZJfenPeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    ZJfenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [ZJfenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
    ZJfenPeiBtn.backgroundColor = [UIColor clearColor];
    [ZJfenPeiBtn addTarget:self action:@selector(zjfenPeiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [ZJfenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_fenpei.png"] forState:UIControlStateNormal];
    [ZJfenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    ZJfenPeiBtn.frame = CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H);
    [operateView3 addSubview:ZJfenPeiBtn];
}


#pragma mark--- 总监---分配页面
-(void) zjfenPeiBtnClicked:(NSDictionary *)sucDic{
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    if (isSW.intValue == 2) {//总监
        
        AlertSalersViewController *dd = [[AlertSalersViewController alloc] init];
        dd.selectOKBlock = ^(NSString *salerId)
        {
            NSArray *custids = @[_custId];
            //总监---分配页面
            NSDictionary *dic  = @{@"custIds":custids,@"assignToDeptId":salerId};
            [FX_UrlRequestManager postByUrlStr:ZJassignCustToDept_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"ZJassignCustToDeptSuccess:" andFaild:nil andIsNeedCookies:YES];
        };
        [self.navigationController pushViewController:dd animated:NO];
        
        return;
    }
    else if(isSW.intValue == 1) //经理
    {
        [xinKehuArr removeAllObjects];
        [wangzhankehuArr removeAllObjects];
        [qitakehuArr removeAllObjects];
        
        if([_oldOrNew isEqualToString:@"新客户"])
        {
            [xinKehuArr addObject:_custId];
        }
        else if ([_oldOrNew isEqualToString:@"网站客户"])
        {
            [wangzhankehuArr addObject:_custId];
        }
        else
        {
            [qitakehuArr addObject:_custId];
        }
        requestDic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:xinKehuArr.count],@"newCust",[NSNumber numberWithLong:wangzhankehuArr.count],@"webCust",[NSNumber numberWithLong:qitakehuArr.count],@"noWebCust", nil];
        
        [FX_UrlRequestManager postByUrlStr:SalerCount_url andPramas:[NSMutableDictionary dictionaryWithDictionary:requestDic1] andDelegate:self andSuccess:@"chaYuSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
}

-(void)ZJassignCustToDeptSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"] intValue]==200) {

        [self.navigationController popViewControllerAnimated:NO];
    }
}
-(void)bb
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ToolList getColor:@"f2f3f5"];

   _custNameStr = [ToolList changeNull:_custNameStr];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bb) name:@"FANGQIOK" object:nil];
    
    //页面底部的操作区域
    barImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-BARVIEW_H, __MainScreen_Width, BARVIEW_H)];
    barImage.userInteractionEnabled = YES;
    barImage.image = [UIImage imageNamed:@"bg_bottom_cz.png"];
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];

    if([_sjFlag isEqualToString:@"88"] && (isSW.intValue == 1 || isSW.intValue == 2))
    {
        
    }
    else if ([_sjFlag isEqualToString:@"99"] && isSW.intValue == 0 )
    {
        
    }
    else
    {
        [self.view addSubview:barImage];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shifangok) name:@"SWSHIFANGOK" object:nil];
    
    arrcy = [[NSMutableArray alloc]init];
    _emojiTags = [[NSMutableArray alloc]init];
    _emojiImages =[[NSMutableArray alloc]init];
    
    for(int i = 0 ; i < 8;i++)
    {
        NSString *tag = [NSString stringWithFormat:@"[bq_%d]",i+1];
        NSString *image = [NSString stringWithFormat:@"bq_%d.png",i+1];
        [_emojiTags addObject:tag];
        [_emojiImages addObject:[UIImage imageNamed:image]];
        
    }

    if(![_sjFlag isEqualToString:@"99"])
    {
#pragma mark - 商务--底部操作栏状态
    
    _typeArr = [[NSMutableArray alloc]initWithObjects:@"未联系",@"初步沟通",@"见面拜访",@"确定意向",@" 方案报价",@"商务谈判", nil];
    
    xinKehuArr = [[NSMutableArray alloc] init];
    wangzhankehuArr = [[NSMutableArray alloc] init];
    qitakehuArr = [[NSMutableArray alloc] init];
    
    
    switch (isSW.intValue) {
        case 0://商务
        {
            if (_isShouCang) {
                
                baiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [baiFangBtn setTitle:@"拜访" forState:UIControlStateNormal];
                baiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [baiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
                baiFangBtn.backgroundColor = [UIColor clearColor];
                baiFangBtn.frame = CGRectMake(0, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
                [baiFangBtn addTarget:self action:@selector(baifang:) forControlEvents:UIControlEventTouchUpInside];
                [baiFangBtn setImage:[UIImage imageNamed:@"icon_cz_xiejilu.png"] forState:UIControlStateNormal];
                [baiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
                [barImage addSubview:baiFangBtn];
                
                fanChaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [fanChaBtn setTitle:@"反查" forState:UIControlStateNormal];
                fanChaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [fanChaBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
                fanChaBtn.backgroundColor = [UIColor clearColor];
                fanChaBtn.frame = CGRectMake(__MainScreen_Width/2, 1, __MainScreen_Width/2, CaozuoViewHeight-1);
                [fanChaBtn addTarget:self action:@selector(fancha:) forControlEvents:UIControlEventTouchUpInside];
                [fanChaBtn setImage:[UIImage imageNamed:@"Search Icon.png"] forState:UIControlStateNormal];
                [fanChaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
                [barImage addSubview:fanChaBtn];
                
            }else{
            
        _typeArr = [[NSMutableArray alloc]initWithObjects:@[@"未联系",@"占线",@"未找到决策人",@"意向不明确",@"稍后联系",@"有意向"],@[@"初步沟通",@"确定意向",@"方案报价",@"签单成交"],@[@"近期无计划",@"近期跟进",@"方案报价",@"二次成交"], nil];
            
            operateView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
             operateView0.tag = 1100;
            UIButton* shouCangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shouCangBtn setTitle:@"收藏夹" forState:UIControlStateNormal];
            shouCangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [shouCangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            shouCangBtn.backgroundColor = [UIColor clearColor];
            shouCangBtn.frame = CGRectMake(0, 0, __MainScreen_Width/3, BARVIEW_H);
            [shouCangBtn addTarget:self action:@selector(shoucangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [shouCangBtn setImage:[UIImage imageNamed:@"icon_cz_zhuangtai.png"] forState:UIControlStateNormal];
            [shouCangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView0.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/3, 12) toPoint:CGPointMake(__MainScreen_Width/3, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
            [operateView0 addSubview:shouCangBtn];
            
            UIButton* typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            typeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [typeBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            typeBtn.backgroundColor = [UIColor clearColor];
            typeBtn.frame = CGRectMake( __MainScreen_Width/3, 0, __MainScreen_Width/3, BARVIEW_H);
            [typeBtn addTarget:self action:@selector(swbiangengtypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            typeBtn.tag = 1000;
            [typeBtn setImage:[UIImage imageNamed:@"icon_cz_zhuangtai.png"] forState:UIControlStateNormal];
            [typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView0.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/3*2, 12) toPoint:CGPointMake(__MainScreen_Width/3*2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
            [operateView0 addSubview:typeBtn];
            
            UIButton* xieJiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            switch (isSW.intValue) {
                case 0://商务
                {
                    
                    [xieJiluBtn setTitle:@"拜访" forState:UIControlStateNormal];
                    
                }
                    break;
                    
                case 1://经理
                {
                    
                    [xieJiluBtn setTitle:@"回访" forState:UIControlStateNormal];
                    
                }
                    break;
                case 2://总监
                {
                    [xieJiluBtn setTitle:@"回访" forState:UIControlStateNormal];
                    
                }
                    break;
                default:
                    break;
            }
            xieJiluBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [xieJiluBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            xieJiluBtn.backgroundColor = [UIColor clearColor];
            xieJiluBtn.frame = CGRectMake(__MainScreen_Width/3*2, 0, __MainScreen_Width/3, BARVIEW_H);
            [xieJiluBtn addTarget:self action:@selector(swxieJiluBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [xieJiluBtn setImage:[UIImage imageNamed:@"icon_cz_xiejilu.png"] forState:UIControlStateNormal];
            [xieJiluBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView0 addSubview:xieJiluBtn];
            
            operateView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
            operateView1.tag = 1101;
            UIButton* genJinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [genJinBtn setTitle:@"保护跟进" forState:UIControlStateNormal];
            [genJinBtn addTarget:self action:@selector(baohuClicked:) forControlEvents:UIControlEventTouchUpInside];
            genJinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [genJinBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            genJinBtn.backgroundColor = [UIColor clearColor];
            genJinBtn.frame = CGRectMake(0, 0, __MainScreen_Width/3, BARVIEW_H);

            [genJinBtn setImage:[UIImage imageNamed:@"icon_cz_zhuangtai.png"] forState:UIControlStateNormal];
            [genJinBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/3, 12) toPoint:CGPointMake(__MainScreen_Width/3, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
            [operateView1 addSubview:genJinBtn];
            
            UIButton* typeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            typeBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
            typeBtn1.tag = 1001;
            [typeBtn1 setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            typeBtn1.backgroundColor = [UIColor clearColor];
            typeBtn1.frame = CGRectMake(__MainScreen_Width/3, 0, __MainScreen_Width/3, BARVIEW_H);
            [typeBtn1 addTarget:self action:@selector(swbiangengtypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [typeBtn1 setImage:[UIImage imageNamed:@"icon_cz_zhuangtai.png"] forState:UIControlStateNormal];
            [typeBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/3*2, 12) toPoint:CGPointMake(__MainScreen_Width/3*2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
            [operateView1 addSubview:typeBtn1];

            
            UIButton* xieJiluBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            switch (isSW.intValue) {
                case 0://商务
                {
                    
                    [xieJiluBtn1 setTitle:@"拜访" forState:UIControlStateNormal];
                    
                }
                    break;
                    
                case 1://经理
                {
                    
                    [xieJiluBtn1 setTitle:@"回访" forState:UIControlStateNormal];
                    
                }
                    break;
                case 2://总监
                {
                    [xieJiluBtn1 setTitle:@"回访" forState:UIControlStateNormal];
                    
                }
                    break;
                default:
                    break;
            }
            xieJiluBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
            [xieJiluBtn1 setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            xieJiluBtn1.backgroundColor = [UIColor clearColor];
            xieJiluBtn1.frame = CGRectMake(__MainScreen_Width/3*2, 0, __MainScreen_Width/3, BARVIEW_H);
            [xieJiluBtn1 addTarget:self action:@selector(swxieJiluBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [xieJiluBtn1 setImage:[UIImage imageNamed:@"icon_cz_xiejilu.png"] forState:UIControlStateNormal];
            [xieJiluBtn1 setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView1 addSubview:xieJiluBtn1];
            
            operateView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, BARVIEW_H)];
            operateView2.tag = 1102;
            UIButton* shiFangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [shiFangBtn setTitle:@"释放" forState:UIControlStateNormal];
            shiFangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [shiFangBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            shiFangBtn.backgroundColor = [UIColor clearColor];
            shiFangBtn.frame = CGRectMake(0, 0, __MainScreen_Width/2, BARVIEW_H);
            [shiFangBtn addTarget:self action:@selector(swbiangengtypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            shiFangBtn.tag = 1002;
            [shiFangBtn setImage:[UIImage imageNamed:@"icon_cz_zhuangtai.png"] forState:UIControlStateNormal];
            [shiFangBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView2.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2, 12) toPoint:CGPointMake(__MainScreen_Width/2, CaozuoViewHeight - 12) andWeight:0.8 andColorString:@"e7e7eb"]];
            [operateView2 addSubview:shiFangBtn];
            
            UIButton* fenPeiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            switch (isSW.intValue) {
                case 0://商务
                {
                    
                    [fenPeiBtn setTitle:@"拜访" forState:UIControlStateNormal];
                    
                }
                    break;
                    
                case 1://经理
                {
                    
                    [fenPeiBtn setTitle:@"回访" forState:UIControlStateNormal];
                    
                }
                    break;
                case 2://总监
                {
                    [fenPeiBtn setTitle:@"回访" forState:UIControlStateNormal];
                    
                }
                    break;
                default:
                    break;
            }
            fenPeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [fenPeiBtn setTitleColor:[ToolList getColor:@"666666"] forState:UIControlStateNormal];
            fenPeiBtn.backgroundColor = [UIColor clearColor];
            fenPeiBtn.frame = CGRectMake(__MainScreen_Width/2, 0, __MainScreen_Width/2, BARVIEW_H);
            [fenPeiBtn addTarget:self action:@selector(swxieJiluBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [fenPeiBtn setImage:[UIImage imageNamed:@"icon_cz_xiejilu.png"] forState:UIControlStateNormal];
            [fenPeiBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            [operateView2 addSubview:fenPeiBtn];

            }
        }
            break;
            
        case 1://经理
        {
            
            [self makeZJview];
            
        }
            break;
        case 2://总监
        {
            [self makeZJview];
        }
            break;
            
            
            
        default:
            break;
    }
    }
    if([_sjFlag isEqualToString:@"88"] || [_sjFlag isEqualToString:@"99"])
    {
        [self makeSjDoview];
        [self.view addSubview:barImage];

    }
    
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height * 0.24)];
    topImageView.image = [UIImage imageNamed:@"bg-khxx.png"];
    [self.view addSubview:topImageView];
    UIButton *btnAddSchedule = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddSchedule.frame = CGRectMake(__MainScreen_Width-44, IOS7_StaticHeight, 44, 44);
    [btnAddSchedule setImage:[UIImage imageNamed:@"AddIcon.png"] forState:UIControlStateNormal];
    if([_sjFlag isEqualToString:@"88"] || [_sjFlag isEqualToString:@"99"])
    {
    }
    else
    {
    [topImageView addSubview:btnAddSchedule];
    }
    [btnAddSchedule addTarget:self action:@selector(addSchedule) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, IOS7_StaticHeight, 44, 44);
    [btn setImage:[UIImage imageNamed:@"w_btn_back.png"] forState:UIControlStateNormal];
    topImageView.userInteractionEnabled = YES;
    [topImageView addSubview:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _custName = [[UILabel alloc] initWithFrame:CGRectMake(0, __MainScreen_Height*0.13, __MainScreen_Width, 19)];
    _custName.font = [UIFont systemFontOfSize:18];
    _custName.textColor = [UIColor whiteColor];
    _custName.textAlignment = NSTextAlignmentCenter;
    _custName.text = _custNameStr;
    [topImageView addSubview:_custName];
    _contentL = [[UILabel alloc] initWithFrame:CGRectMake(0, __MainScreen_Height*0.16, __MainScreen_Width, __MainScreen_Height*0.08)];
    _contentL.font = [UIFont systemFontOfSize:14];
    _contentL.textColor = [UIColor whiteColor];
    _contentL.textAlignment = NSTextAlignmentCenter;
    _contentL.text = @"";
    _contentL.alpha = 0.5;
    [topImageView addSubview:_contentL];
    _startPage = 1;
    _heTongStartPage = 1;
    _requestDic = [[NSMutableDictionary alloc]init];
    
  
    detailLabelsArr = [[NSMutableArray alloc] init];
    productFlag = 0;
  
    product_Select_Btn_Arr = [[NSMutableArray alloc ] init];
    selectBtnArr = [[NSMutableArray alloc ] init];
 
   
    
    
    
   
      
    //多个电话显示页面
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    blackV = [[UIView alloc]initWithFrame:CGRectMake(0,__MainScreen_Height , __MainScreen_Width, __MainScreen_Height)];
    blackV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [mainWindow addSubview:blackV];
    
}

#pragma mark - 拜访操作
-(void)baifang:(UIButton *)btn
{
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"other";
    gh.kehuNameStr =_custNameStr;
    gh.kehuNameId = _custId;
    [self.navigationController pushViewController:gh animated:NO];
}
#pragma mark - 反差操作
- (void)fancha:(id)sender {
    NSString * str=[NSString stringWithFormat:@"https://m.baidu.com/?from=844b&vit=fps#|src_%@|sa_ib",_custNameStr];
    str =  [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark -添加日程
-(void)addSchedule
{
    AddNewScheduleViewController *an = [[AddNewScheduleViewController alloc] init];
    an.guanlian_Str = _custNameStr;
    an.guanlian_Id = _custId;
    [self.navigationController  pushViewController:an animated:NO];
}
#pragma mark - isFive 为YES为5栏，NO为3栏
-(void)makeMideView:(BOOL)isFive{
    
    //详情页面
    detailView = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.24+HANDVIEW_H, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-HANDVIEW_H-BARVIEW_H)];
    detailView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-HANDVIEW_H-BARVIEW_H)];
    NSArray *arr1 = @[@"名称",@"性质",@"地址",@"电话",@"邮箱",@"传真",@"网址",@"行业",@"预存账户余额",@"转款账户余额"];
    //detailView1.contentSize = CGSizeMake(__MainScreen_Width, 45*arr1.count);
    detailView1.backgroundColor = [UIColor whiteColor];
    [detailView addSubview:detailView1];
    sb = [[[NSBundle mainBundle] loadNibNamed:@"SbView" owner:self options:nil] lastObject];
    if (_isShouCang) {
        sb.fancha.hidden = YES;
    }
    sb.frame = CGRectMake(0, 0, __MainScreen_Width, detailView1.frame.size.height);
    [detailView1 addSubview:sb];
//    for (int i = 0; i < arr1.count; i++) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, i*45, 30, 45)];
//        label.textAlignment = NSTextAlignmentRight;
//        label.textColor = [ToolList getColor:@"999999"];
//        label.font = [UIFont systemFontOfSize:14];
//        label.text = [arr1 objectAtIndex:i];
//        [detailView1 addSubview:label];
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(55, i*45, __MainScreen_Width-65, 45)];
//        label1.textColor = [ToolList getColor:@"333333"];
//        label1.font = [UIFont systemFontOfSize:14];
//        label1.numberOfLines = 2;
//        [detailView1 addSubview:label1];
//        [detailLabelsArr addObject:label1];
//        [detailView1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(13, i*45+44.2) toPoint:CGPointMake(__MainScreen_Width-26, i*45+44.2) andWeight:0.8 andColorString:@"e7e7eb"]];
//        if(i == 8 || i == 9 )
//        {
//            label.frame = CGRectMake(0, i*45, 105, 45);
//            label1.frame = CGRectMake(115, i*45, __MainScreen_Width-125, 45);
//        }
//    }
//    detailView.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:detailView];
    [self makeShangji];
    if (isFive) {
        
        /* 合同页面 */
        [self makeheTongView];
    }
    
    //记录页面
    [self makeContentV];
    //    [self contentRequest];
    
    //联系人
    linkManView = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.24+HANDVIEW_H, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-HANDVIEW_H-BARVIEW_H)];
    linkManView.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:linkManView];
    [self makelinkManView];
    
    
    if (isFive) {
        if(productView)
        {
            [productView removeFromSuperview];
        }
        //产品
        productView = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.24+HANDVIEW_H, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-HANDVIEW_H-BARVIEW_H)];
        productView.backgroundColor = [ToolList getColor:@"f2f3f5"];
        [self.view addSubview:productView];
        productNum_L = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 35)];
        productNum_L.backgroundColor = [UIColor clearColor];
        productNum_L.font = [UIFont systemFontOfSize:12];
        productNum_L.textColor = [ToolList getColor:@"999999"];
        [productView addSubview:productNum_L];
        product_Select_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        product_Select_Btn.frame = CGRectMake(__MainScreen_Width-55, 0, 52, 35);
        [product_Select_Btn setTitle:@"筛选" forState:UIControlStateNormal];
        product_Select_Btn.hidden = NO;
        product_Select_Btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [product_Select_Btn setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateNormal];
        product_Select_Btn.backgroundColor = [UIColor clearColor];
        [product_Select_Btn addTarget:self action:@selector(productSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [product_Select_Btn setImage:[UIImage imageNamed:@"icon_khxq_chanpin_shaixuan.png"] forState:UIControlStateNormal];
        [product_Select_Btn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [productView addSubview:product_Select_Btn];
        chanpinTable = [[UITableView alloc] initWithFrame:CGRectMake(13,35, __MainScreen_Width-26, __MainScreen_Height*0.76-HANDVIEW_H-BARVIEW_H-35)];
        chanpinTable.delegate = self;
        chanpinTable.dataSource = self;
        chanpinTable.separatorStyle = 0;
        chanpinTable.backgroundColor = [ToolList getColor:@"f2f3f5"];
        
        [productView addSubview:chanpinTable];
     
        //筛选下拉
        selectVIew = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-13-100, 25, 100, 128)];
        selectVIew.hidden = YES;
        selectVIew.userInteractionEnabled = YES;
        selectVIew.image = [UIImage imageNamed:@"bg_khxx_chanpin_sx.png"];
        [productView addSubview:selectVIew];
        NSArray *arr = @[@"全部产品",@"网站产品",@"其他产品"];
        for (int i = 0; i < arr.count; i ++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 10 + 40*i, 100, 40);
            [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[ToolList getColor:@"999999"] forState:UIControlStateNormal];
            [btn.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(20, 39) toPoint:CGPointMake(80, 39)  andWeight:0.5 andColorString:@"e7e7eb"]];
            btn.tag = i;
            [selectVIew addSubview:btn];
            [btn addTarget:self action:@selector(product_Select_Btn_Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [product_Select_Btn_Arr addObject:btn];
        }
    }
   
}

#pragma mark - 客户详情查询成功
-(void)CustDetailSuccess:(NSDictionary *)dicc
{
    DetailDic = [[dicc objectForKey:@"result"] objectForKey:@"custInfo"];
    if([[DetailDic objectForKey:@"homepageHint"] intValue]==0)
    {
        sb.guan.hidden = YES;
    }else
    {
        sb.guan.hidden = NO;
    }
    if([[DetailDic objectForKey:@"releaseCount"] intValue]!=0)
    {
        sb.xin.layer.cornerRadius = 4;
        [sb.xin setBackgroundImage:nil forState:UIControlStateNormal];

        sb.xin.layer.masksToBounds = YES;
        sb.xin.backgroundColor = [UIColor redColor];
        [sb.xin setTitle:[NSString stringWithFormat:@"%@",[DetailDic
 objectForKey:@"releaseCount"]] forState:UIControlStateNormal];
        [sb.xin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sb.xin.titleLabel.font = [UIFont systemFontOfSize:8];
    }
    else
    {
        [sb.xin setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];

    }
    if([[DetailDic objectForKey:@"channelNumber"] intValue]==0)
    {
        sb.tui.hidden = YES;
    }
 else
 {
     sb.tui.hidden = NO;
 }
    sb.nameStr = [NSString stringWithFormat:@"%@",[ToolList changeNull:[DetailDic objectForKey:@"custName"]]];
    sb.name.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[DetailDic objectForKey:@"custName"]]];
    sb.dizhi.text = [NSString stringWithFormat:@"地址:%@",[ToolList changeNull:[DetailDic objectForKey:@"address"]]];
    sb.guimo.text = [NSString stringWithFormat:@"规模:%@",[ToolList changeNull:[DetailDic objectForKey:@"custRegisterPeopleNumberType"]]];
    sb.hangye.text = [NSString stringWithFormat:@"行业:%@",[ToolList changeNull:[DetailDic objectForKey:@"industryClassBig"]]];
//    sb.guanwang.text = [NSString stringWithFormat:@"官网:%@",[ToolList changeNull:[DetailDic objectForKey:@"homepage"]]];
    NSString *contentStr =[NSString stringWithFormat:@"官网:%@",[ToolList changeNull:[DetailDic objectForKey:@"homepage"]]];;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:[ToolList getColor:@"999999"] range:NSMakeRange(0, 3)];
    sb.guanwang.attributedText = str;
    
    sb.chenglishijian.text = [NSString stringWithFormat:@"成立时间:%@",[ToolList changeNull:[DetailDic objectForKey:@"createDate"]]];
    sb.zhucezijin.text = [NSString stringWithFormat:@"注册资金:%@万",[ToolList changeNull:[DetailDic objectForKey:@"custRegisterMoney"]]];
//    UILabel *l0 = [detailLabelsArr objectAtIndex:0];
//    UILabel *l1 = [detailLabelsArr objectAtIndex:1];
//    UILabel *l2 = [detailLabelsArr objectAtIndex:2];
//    UILabel *l3 = [detailLabelsArr objectAtIndex:3];
//    UILabel *l4 = [detailLabelsArr objectAtIndex:4];
//    UILabel *l5 = [detailLabelsArr objectAtIndex:5];
//    UILabel *l6 = [detailLabelsArr objectAtIndex:6];
//    UILabel *l7 = [detailLabelsArr objectAtIndex:7];
//    UILabel *l8 = [detailLabelsArr objectAtIndex:8];
//    UILabel *l9 = [detailLabelsArr objectAtIndex:9];
//
//    l0.text = [ToolList changeNull:[dicc objectForKey:@"custName"]];
//    l1.text = [ToolList changeNull:[dicc objectForKey:@"custNature"]];
//    l2.text = [ToolList changeNull:[dicc objectForKey:@"address"]];
//    l3.text = [ToolList changeNull:[dicc objectForKey:@"contacts"]];
//    l4.text = [ToolList changeNull:[dicc objectForKey:@"email"]];
//    l5.text = [ToolList changeNull:[dicc objectForKey:@"fax"]];
//    l6.text = [ToolList changeNull:[dicc objectForKey:@"url"]];
//    l7.text = [ToolList changeNull:[dicc objectForKey:@"industryclassBig"]];
//    l8.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dicc objectForKey:@"balanceMoney"]]];
//    l9.text = [NSString stringWithFormat:@"%@",[ToolList changeNull:[dicc objectForKey:@"transferMoney"]]];

    
}
#pragma mark - 商务底部导航栏状态变更
-(void)swbiangengtypeBtnClicked:(UIButton *)sender{
  
    if ([self.view viewWithTag:6839]) {
        
        [[self.view viewWithTag:6839]removeFromSuperview];
    }
    else{
        
        if (arrcy.count) {
            
            [arrcy removeAllObjects];
        }
        
        int typeCount =[[diccy objectForKey:@"operate"] intValue];
        
        NSArray *arr =[_typeArr objectAtIndex:typeCount];

        for (NSString *str in arr) {
            
            if ([str isEqualToString:sender.titleLabel.text]) {
                
            }else{
                
             NSString *types= [diccy objectForKey:@"intentType"];
                //当前状态为未联系状态的时候，状态随便选择
                if ([types isEqualToString:@"未联系"]) {
                    
                    [arrcy addObject:str];
                    
                }else{
                  //当前状态不是未联系状态的时候，去掉未联系状态
                    if (![str isEqualToString:@"未联系"]) {
                        
                         [arrcy addObject:str];
                    }
                }
                
              
            }
        }
        
        UIView *vv = [ToolList showPopview:sender.frame andTitleArr:arrcy andTarget:self];
        
        [self.view addSubview:vv];
    }

    
}

#pragma mark - 底部导航栏保护跟进
-(void)baohuClicked:(UIButton *)sender{

    if ([self.view viewWithTag:6839]) {
        
         [[self.view viewWithTag:6839]removeFromSuperview];
        
    }else{
        
        NSArray *arr = @[@"释放"];
        
        UIView *vv = [ToolList showPopview:sender.frame andTitleArr:arr andTarget:self];
        
        [self.view addSubview:vv];
    }
   
}

#pragma mark - 底部导航栏收藏夹
-(void)shoucangBtnClicked:(UIButton *)sender{
   
    if ([self.view viewWithTag:6839]) {
        [[self.view viewWithTag:6839]removeFromSuperview];
        
    }else{
    NSArray *arr = @[@"释放",@"保护"];
    
    UIView *vv = [ToolList showPopview:sender.frame andTitleArr:arr andTarget:self];
    
    [self.view addSubview:vv];
    }

}

#pragma mark - 底部导航栏变更状态
-(void)biangengtypeBtnClicked:(UIButton *)sender{
 
    if ([self.view viewWithTag:6839]) {
        
         [[self.view viewWithTag:6839]removeFromSuperview];
    }
   else{
        
    if (arrcy.count) {
        
        [arrcy removeAllObjects];
    }
    for (NSString *str in _typeArr) {
        
        if ([str isEqualToString:sender.titleLabel.text]) {

        }else{
            
            [arrcy addObject:str];
        }
    }
    
    UIView *vv = [ToolList showPopview:sender.frame andTitleArr:arrcy andTarget:self];
    
    [self.view addSubview:vv];
    }
    
}

#pragma mark - 状态选择成功,需要调用接口
-(void)selectType:(UIButton *)sender{
  
    [[self.view viewWithTag:6839]removeFromSuperview];
    
    //收藏转保护
    if ([sender.titleLabel.text isEqualToString:@"保护"]) {
        
        NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
        [arr setObject:_custId forKey:@"custId"];
        [FX_UrlRequestManager postByUrlStr:protectCustomer_url andPramas:arr andDelegate:self andSuccess:@"protectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"释放"]){
        
        CY_alertWhyVC *dd = [[CY_alertWhyVC alloc] init];

        dd.IntentCustId = _custId;
        
        [self presentViewController:dd animated:YES completion:^{
            
        }];

    }else{
        
         NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
        
        if ([isSW intValue] == 0) {
            
            if ([sender.titleLabel.text isEqualToString:@"方案报价"]) {
                
                if ([self.view viewWithTag:6839]) {
                    
                    [[self.view viewWithTag:6839]removeFromSuperview];
                }

                FangAnViewController *gh = [[FangAnViewController alloc] init];
                gh.titleStr = @"方案报价";
                gh.costIdStr =_custId;
                gh.delegate = self;
                gh.custNameStr = _custNameStr;
                [self.navigationController pushViewController:gh animated:NO];
                
            }else if([sender.titleLabel.text isEqualToString:@"签单成交"]){
                
                FangAnViewController *gh = [[FangAnViewController alloc] init];
                gh.titleStr = @"签单成交";
                 gh.costIdStr =_custId;
                gh.custNameStr = _custNameStr;
                gh.delegate = self;
                [self.navigationController pushViewController:gh animated:NO];
                
            }
            else if( [sender.titleLabel.text isEqualToString:@"二次成交"]){
                
                FangAnViewController *gh = [[FangAnViewController alloc] init];
                gh.titleStr = @"二次成交";
                gh.costIdStr =_custId;
                gh.custNameStr = _custNameStr;
                gh.delegate = self;
                [self.navigationController pushViewController:gh animated:NO];
                
            }
            else{
                
                NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
                [arr setObject:_custId forKey:@"custId"];
                [arr setObject:[arrcy objectAtIndex:sender.tag] forKey:@"intentType"];
                typeStr = [arrcy objectAtIndex:sender.tag];
                [FX_UrlRequestManager postByUrlStr:changeCustState_url andPramas:arr andDelegate:self andSuccess:@"changeCustStateSuccess:" andFaild:nil andIsNeedCookies:YES];
            }
            
            
        }else{
            
        //经理及总监的状态改变操作
            NSMutableDictionary *arr = [[NSMutableDictionary alloc] init];
            [arr setObject:_custId forKey:@"custId"];
            [arr setObject:[arrcy objectAtIndex:sender.tag] forKey:@"intentType"];
            typeStr = [arrcy objectAtIndex:sender.tag];
            [FX_UrlRequestManager postByUrlStr:changeCustState_url andPramas:arr andDelegate:self andSuccess:@"changeCustStateSuccess:" andFaild:nil andIsNeedCookies:YES];
        }
    }

}

-(void)changeTypeString{
    
    UIView *opp = [barImage.subviews objectAtIndex:0];
    switch (opp.tag-1100) {
            
        case 0:
        {
            UIButton *typeB = (UIButton *)[opp viewWithTag:1000];
            [typeB setTitle:typeStr forState:UIControlStateNormal];
        }
            break;
            
        case 1:
        {
            UIButton *typeB = (UIButton *)[opp viewWithTag:1001];
            [typeB setTitle:typeStr forState:UIControlStateNormal];
        }
            break;
            
        case 2:
        {
            UIButton *typeB = (UIButton *)[opp viewWithTag:1002];
            [typeB setTitle:typeStr forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    typeStr = @"";
}

-(void)changeCustStateSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
   
        [self changeTypeString];
    }
}

#pragma mark - 去除底部箭头显示框
-(void)SingleTap:(UITapGestureRecognizer*)g{
    
    [[self.view viewWithTag:6839]removeFromSuperview];
}

-(void)protectCustomerSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        [ToolList showRequestFaileMessageLittleTime:@"保护成功"];
       
        [operateView0 removeFromSuperview];
        
        
        if ([operateView1 superview]) {
            
            [barImage bringSubviewToFront:operateView1];
            
        }else{
            
            [barImage addSubview:operateView1];
        }
        
        //请求经理操作权限
        NSDictionary *dic= @{@"custId":_custId,@"productFlag":[NSNumber numberWithLong:productFlag]};
        [FX_UrlRequestManager postByUrlStr:CustTip_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"CustTipSuccess:" andFaild:nil andIsNeedCookies:YES];
        
//        UIButton *typeBt = (UIButton *)[operateView1 viewWithTag:1001];
//        [typeBt setTitle:[NSString stringWithFormat:@"%@",[diccy objectForKey:@"intentType"]] forState:UIControlStateNormal];
//        
//         UIButton *typeBt2 = (UIButton *)[operateView2 viewWithTag:1002];
//         [typeBt2 setTitle:@"初步沟通" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 点击多个电话
-(IBAction)moreTel:(UIButton *)sender{
    
    NSDictionary *dataDic = [_linkManArr objectAtIndex:sender.tag];
    NSString *zhuStr =  [dataDic objectForKey:@"mobilePhone"];
    NSMutableArray *telArr = [[NSMutableArray alloc]init];
    [telArr addObject:zhuStr];
    [telArr addObjectsFromArray:[dataDic objectForKey:@"telList"]];
        
        CY_popupV *popuTel = [[CY_popupV alloc]initWithFrame:CGRectMake(0, __MainScreen_Height-telArr.count*49-54, __MainScreen_Width, telArr.count*49+54) andMessageArr:telArr andtarget:self];
        [blackV addSubview:popuTel];
    
    [UIView animateWithDuration:0.3 animations:^{
        blackV.frame =CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
    }];
    
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

-(void)shangjiSuccess:(NSDictionary *)dic
{
    if([[dic objectForKey:@"result"] count] == 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"暂无商机数据"];
    }
    else
    {
        //删
        for (UIView *sub in sjScroll.subviews) {
            if(sub)
            {
                [sub removeFromSuperview];
            }
        }
        float h = 0;
        for (NSDictionary *dic1 in [dic objectForKey:@"result"]) {
          
            //创建
            YixiangView *view = [[YixiangView alloc] initWithFrame:CGRectZero andDic:dic1 andflag:YES];
            view.frame = CGRectMake(0, h, __MainScreen_Width, view.frame.size.height);
            h += view.frame.size.height;
                       NSLog(@"%lf",h);
            [sjScroll addSubview:view];
        }
        
        NSArray *items = @[@"录入日期:",@"释放原因:",@"释放时间:",@"总释放数:"];
        for (int i = 0; i < items.count; i++)
        {
            UILabel *nameL = [[UILabel alloc] init];
            nameL.text = [items objectAtIndex:i];
            
            nameL.textColor = [ToolList getColor:@"7d7d7d"];
            nameL.font = [UIFont systemFontOfSize:13];
            
            [sjScroll addSubview:nameL];
            
            UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(70, i*30, __MainScreen_Width-70, 30)];
            
            content.textColor = [ToolList getColor:@"7d7d7d"];
            content.font = [UIFont systemFontOfSize:13];
            [sjScroll addSubview:content];
            nameL.numberOfLines = 2;
            content.numberOfLines = 2;
            
            
            
                nameL.frame = CGRectMake(10, h+30*i, 65, 30);
                content.frame = CGRectMake(75, h+30*i, __MainScreen_Width-75, 30);
                        switch (i) {

                case 0:
                {
                    content.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"createTime"]];;
                    break;
                }
                case 1:
                {
                    content.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"reason"]];
                    
                    break;
                }
                case 2:
                {
                    content.text =  [NSString stringWithFormat:@"%@", [dic objectForKey:@"reaDate"]];
                    
                    break;
                }
                case 3:
                {
                    content.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"giveUpTimes"]];
                    
                    break;
                }
                        }            }

        sjScroll.contentSize = CGSizeMake(__MainScreen_Width, h+30*4);
    }
}

#pragma mark - 点击按钮回调
-(void)changeBigAndColorClikedBack:(FX_Button *)btn
{
    for (int i = 0; i < selectBtnArr.count ; i++) {
        FX_Button * clickedBtn = [selectBtnArr objectAtIndex:i];
        if (clickedBtn == btn) {
            clickedBtn.isSelect = YES;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
        else
        {
            clickedBtn.isSelect = NO;
            [clickedBtn changeBigAndColorCliked:clickedBtn];
        }
    }
    if(flag == 1)
    {
    switch (btn.tag) {
        case 0:
        {
            _flagRefresh = @"chanpin";
          
            [self chanpinRequest];
        }
            break;
        case 1:
        {
            _flagRefresh = @"lianxiren";
            [self.view bringSubviewToFront:linkManView];
            
            [self linkManRequest];
            
        }
            break;
            
        case 2:
        {
            _flagRefresh = @"jilu";
            [self.view bringSubviewToFront:countView];
            [self contentRequest];
            
          
        }
            break;
        case 3:
        {
            [self byCustIdRequest];
            _flagRefresh = @"hetong";
            [self.view bringSubviewToFront:heTongView];
        }
            break;
        case 4:
        {
            _flagRefresh = @"shangji";
            NSDictionary *dic= @{@"custId":_custId};
            [FX_UrlRequestManager postByUrlStr:intentCustDetail_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"shangjiSuccess:" andFaild:nil andIsNeedCookies:YES];
            [self.view bringSubviewToFront:sjScroll];
        }
            break;
        case 5:
        {
            _flagRefresh = @"xiangqing";
            NSDictionary *dic= @{@"custId":_custId};
            [FX_UrlRequestManager postByUrlStr:custDetail_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"CustDetailSuccess:" andFaild:nil andIsNeedCookies:YES];            [self.view bringSubviewToFront:detailView];
        }
            break;
        default:
            break;
    }
    }
    else
    {
        switch (btn.tag) {
                
            case 0:
            {
                _flagRefresh = @"lianxiren";
                [self.view bringSubviewToFront:linkManView];
                
                [self linkManRequest];
                
            }
                break;
            case 1:
            {
                _flagRefresh = @"jilu";
                [self.view bringSubviewToFront:countView];
                [self contentRequest];
            }
                break;
            case 2:
            {
                _flagRefresh = @"shangji";
                NSDictionary *dic= @{@"custId":_custId};
                [FX_UrlRequestManager postByUrlStr:intentCustDetail_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"shangjiSuccess:" andFaild:nil andIsNeedCookies:YES];
                [self.view bringSubviewToFront:sjScroll];
            }
                break;
            case 3:
            {
                _flagRefresh = @"xiangqing";
                NSDictionary *dic= @{@"custId":_custId};
                [FX_UrlRequestManager postByUrlStr:custDetail_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"CustDetailSuccess:" andFaild:nil andIsNeedCookies:YES];            [self.view bringSubviewToFront:detailView];
            }
                break;
            default:
                break;
        }

    }
    
}
#pragma mark - 请求产品列表成功
-(void)CustBuyProductSuccess:(NSDictionary *)dic
{
    chanpinArr = [NSArray arrayWithArray:[dic objectForKey:@"result"]];
    productNum_L.text = [NSString stringWithFormat:@"共%@个",[dic objectForKey:@"total"]];
    if(chanpinArr.count)
    {
        if(productAlertView)
        {
            [productAlertView removeFromSuperview];
        }
        product_Select_Btn.hidden = NO;
        [chanpinTable reloadData];
    }
    else
    {
       if(productAlertView)
       {
           [productAlertView removeFromSuperview];
           productAlertView = nil;
       }
            productAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, __MainScreen_Width, productView.bounds.size.height-35)];
            [productView addSubview:productAlertView];
            [productView insertSubview:productAlertView belowSubview:selectVIew];
            productAlertView.backgroundColor = [ToolList getColor:@"f2f3f5"];
            
            UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, IOS7_Height)];
            la.textAlignment = NSTextAlignmentCenter;
            la.font = [UIFont systemFontOfSize:14];
            la.textColor = [ToolList getColor:@"999999"];
            la.text = @"此客户还未购买产品";
            [productAlertView addSubview:la];
        
    }
}
#pragma mark - 方案报价、签单回调
-(void)goVcAndType:(NSString *)typeStrs{
     _flagRefresh = @"jilu";
    typeStr =typeStrs;
    [self changeTypeString];
}

#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(NSString *)flag
{
    isRe = NO;
    
    if ([flag isEqualToString:@"1" ]) {
        _startPage = 1;
        [self contentRequest];
        
    }else if ([flag isEqualToString:@"2" ]){
        _heTongStartPage=1;
        [self byCustIdRequest];
    }
    
}
//加载更多
-(void)footerRefresh:(NSString *)flag
{
    isRe = YES;
    
    if ([flag isEqualToString:@"1" ]) {
        _startPage ++;
        [self contentRequest];
        
    }else if ([flag isEqualToString:@"2" ]){
        _heTongStartPage++;
        [self byCustIdRequest];
        
    }
    
    
}

#pragma mark - 创建联系人视图
-(void)makelinkManView{
    
    UILabel *numL = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 35)];
    numL.textColor = [ToolList getColor:@"888888"];
    numL.font = [UIFont systemFontOfSize:12];
    numL.tag =NUM_TAB;
    numL.backgroundColor = [UIColor clearColor];
    numL.text = @"";
    [linkManView addSubview:numL];
    
    NSString *isSW = [[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"];
    
    if ([isSW intValue] == 0) {
    
    UIButton *addLink = [UIButton buttonWithType:UIButtonTypeCustom];
    addLink.frame = CGRectMake(0, numL.frame.size.height, __MainScreen_Width, 35);
    addLink.backgroundColor = [ToolList getColor:@"e4e6e9"];
    [addLink setImage:[UIImage imageNamed:@"icon_khxq_addlxr.png"] forState:UIControlStateNormal];
    [addLink setTitle:@"添加联系人" forState:UIControlStateNormal];
    [addLink addTarget:self action:@selector(addMan:) forControlEvents:UIControlEventTouchUpInside];
    [addLink setTitleColor:[ToolList getColor:@"9ea1a8"] forState:UIControlStateNormal];
    addLink.titleLabel.font = [UIFont systemFontOfSize:14];
    [linkManView addSubview:addLink];
        
    _linkManTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, addLink.frame.size.height+addLink.frame.origin.y, __MainScreen_Width, linkManView.frame.size.height-numL.frame.size.height*2) style:UITableViewStylePlain];
        
    }else{
        
    _linkManTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, numL.frame.size.height+3, __MainScreen_Width, linkManView.frame.size.height-numL.frame.size.height*2) style:UITableViewStylePlain];
    }
    _linkManTabel.dataSource = self;
    _linkManTabel.delegate = self;
    _linkManTabel.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [_linkManTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [linkManView addSubview:_linkManTabel];
    
    
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

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}
-(void)requestSuccess:(NSString *)dic{
    
    NSLog(@"+++++++++");
}
//解析vcf
-(void)parseVCardString:(NSString*)vcardString
{
    if (vcardString.length != 0) {
     
        MP_ViewController *mpView = [[MP_ViewController alloc]init];
        mpView.vcardString =vcardString;
        mpView.photoImage = chosenImage;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_custId,@"custId",_custNameStr,@"custName", nil];
   
        mpView.custArr = [[NSMutableArray alloc]initWithObjects:dic, nil];
        
//        mpView.custName = _custNameStr;
       
        [self.navigationController pushViewController:mpView animated:YES];
    }
    
}
-(void)vvvv:(NSString *)dic{
    
    NSLog(@"^^^^^^^^^^^^^%@",dic);
    
    [self parseVCardString:dic];
}
#pragma mark - 进入添加联系人页面
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
            addMen.comStr = _custNameStr;
            addMen.custId = _custId;
            _flagRefresh = @"lianxiren";
            
            [self.navigationController pushViewController:addMen animated:NO];
  
        }
    };
    [self  presentViewController:addWay animated:NO completion:^{
        
    }];
}
#pragma mark - 创建商机视图
-(void)makeShangji
{
    sjScroll = [[UIScrollView alloc] init];
    sjScroll.frame = CGRectMake(0, __MainScreen_Height*0.24+HANDVIEW_H, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-HANDVIEW_H-BARVIEW_H);
    sjScroll.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:sjScroll];
   


}
#pragma mark - 创建记录视图
-(void)makeContentV{
    
    //中间显示页面
    countView = [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.24+HANDVIEW_H, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-HANDVIEW_H-BARVIEW_H)];
    countView.backgroundColor = [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:countView];
    
    UILabel *numL = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 28)];
    numL.textColor = [ToolList getColor:@"888888"];
    numL.font = [UIFont systemFontOfSize:12];
    numL.tag =NUM_TAB;
    numL.backgroundColor = [UIColor clearColor];
    numL.text = @"";

    [countView addSubview:numL];
    
    _countTabel = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, numL.frame.size.height, __MainScreen_Width, countView.frame.size.height-numL.frame.size.height) style:UITableViewStylePlain isNeedRefresh:YES target:self Flag:@"1"];
    _countTabel.dataSource = self;
    _countTabel.delegate = self;
    _countTabel.backgroundColor = [UIColor clearColor];
    [_countTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_countTabel.refreshHeader autoRefreshWhenViewDidAppear];
    [countView addSubview:_countTabel];
    
}
#pragma mark - 创建合同视图
-(void)makeheTongView{
    
    //中间显示页面
    
    heTongView= [[UIView alloc]initWithFrame:CGRectMake(0, __MainScreen_Height*0.24+HANDVIEW_H, __MainScreen_Width, __MainScreen_Height-__MainScreen_Height*0.24-HANDVIEW_H-BARVIEW_H)];
    heTongView.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [self.view addSubview:heTongView];
    
    UILabel *numL = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, __MainScreen_Width-26, 28)];
    numL.textColor = [ToolList getColor:@"888888"];
    numL.font = [UIFont systemFontOfSize:12];
    numL.tag =NUM_TAB;
    numL.backgroundColor = [UIColor clearColor];
    numL.text = @"";
    [heTongView addSubview:numL];
    
    _heTongTabel = [[Fx_TableView alloc] initWithFrame:CGRectMake(13, numL.frame.size.height, __MainScreen_Width-26, heTongView.frame.size.height-numL.frame.size.height) style:UITableViewStylePlain isNeedRefresh:YES target:self Flag:@"2"];
    _heTongTabel.dataSource = self;
    _heTongTabel.delegate = self;
    _heTongTabel.backgroundColor =  [ToolList getColor:@"f2f3f5"];
    [_heTongTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_heTongTabel.refreshHeader autoRefreshWhenViewDidAppear];
    [heTongView addSubview:_heTongTabel];
    
}
#pragma mark - 产品数据请求
-(void)chanpinRequest{
    productFlag = 0;
    NSDictionary *dic= @{@"custId":_custId,@"productFlag":[NSNumber numberWithLong:productFlag]};
    [FX_UrlRequestManager postByUrlStr:CustBuyProduct_url andPramas:[NSMutableDictionary dictionaryWithDictionary:dic] andDelegate:self andSuccess:@"CustBuyProductSuccess:" andFaild:nil andIsNeedCookies:YES];
    [self.view bringSubviewToFront:productView];
}

#pragma mark - 联系人数据请求
-(void)linkManRequest{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"custId"] = _custId;
    
    [FX_UrlRequestManager postByUrlStr:linkMan_url andPramas:dic andDelegate:self andSuccess:@"linkManSuccess:" andFaild:@"custCustFild:" andIsNeedCookies:YES];
}
#pragma mark - 联系人数据请求成功
-(void)linkManSuccess:(NSDictionary *)sucDic{
    
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        [_linkManArr removeAllObjects];
        NSArray *arr = [sucDic objectForKey:@"result"];
        
        if ( arr.count) {
            
            _linkManArr = [[NSMutableArray alloc]initWithArray:arr];
            UILabel *numL = (UILabel *)[linkManView viewWithTag:NUM_TAB];
            numL.text = [NSString stringWithFormat:@"共 %ld 个",_linkManArr.count];
            
            [_linkManTabel reloadData];
            
        }else{
            
            [ToolList showRequestFaileMessageLittleTime:@"暂无数据！"];
        }
    }
}

#pragma mark - 记录数据请求
-(void)contentRequest{
    
    _requestDic[@"custId"] = _custId;
    _requestDic[@"pagesize"]=[NSNumber numberWithInt:10];
    [_requestDic setObject:[NSString stringWithFormat:@"%ld",_startPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:custId_url andPramas:_requestDic andDelegate:self andSuccess:@"custSuccess:" andFaild:@"custCustFild:" andIsNeedCookies:YES];
}

-(void)custCustFild:(NSError *)err{
    
    [_countTabel.refreshHeader endRefreshing];
    [_countTabel.refreshFooter endRefreshing];
    
    [ToolList showRequestFaileMessageLittleTime:[err.userInfo objectForKey:@"msg"]];
}

#pragma mark - 记录数据请求成功
-(void)custSuccess:(NSDictionary *)sucDic{
    
    [_countTabel.refreshHeader endRefreshing];
    [_countTabel.refreshFooter endRefreshing];
    
    
    UILabel *numL = (UILabel *)[countView viewWithTag:NUM_TAB];
    numL.text = [NSString stringWithFormat:@"共 %@ 条",[sucDic objectForKey:@"total"]];
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if (isRe) {//加载更多
            
            NSArray *dataArr =[sucDic objectForKey:@"result"];
            
            if (dataArr.count) {
                
                [_contentArr addObjectsFromArray:dataArr];
                
            }else{
                
                [ToolList showRequestFaileMessageLittleTime:@"暂无更多数据"];
            }
            
            
            
        }else{
            
            if ([[sucDic objectForKey:@"result"] count ]== 0) {
                
                if (_contentArr) {
                    
                    [_contentArr removeAllObjects];
                }
                
                [ToolList showRequestFaileMessageLittleTime:@"暂时没有沟通记录"];
                
                [_countTabel reloadData];
                
                return;
            }
            
            _contentArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
            
        }
     /*
        if (_zanArr==nil) {
            
            _zanArr = [[NSMutableArray alloc]init];
            
        }else{
            
            [_zanArr removeAllObjects];
        }
        
        if (_zanNumArr==nil) {
            
            _zanNumArr = [[NSMutableArray alloc]init];
            
        }else{
            
            [_zanNumArr removeAllObjects];
        }
        
        for (NSDictionary *dic in _contentArr) {
            
            [_zanArr addObject:[dic objectForKey:@"praiseFlag"]];
            [_zanNumArr addObject:[dic objectForKey:@"praiseNum"]];
        }
        */
    }
    
    [_countTabel reloadData];
    
    
}

#pragma mark - 合同列表查询
-(void)byCustIdRequest{
    
    if (![_custId length]) {
        
        [ToolList showRequestFaileMessageLittleTime:@"无COUSTID"];
    }
    
    _requestDic[@"custId"] = _custId;
    _requestDic[@"pagesize"]=[NSNumber numberWithInt:10];
    [_requestDic setObject:[NSString stringWithFormat:@"%ld",_heTongStartPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:byCustId_url andPramas:_requestDic andDelegate:self andSuccess:@"byCustIdSuccess:" andFaild:@"custCustFild:" andIsNeedCookies:YES];
}
#pragma mark - 合同列表查询成功

-(void)byCustIdSuccess:(NSDictionary *)sucDic{
    
    
    [_heTongTabel.refreshHeader endRefreshing];
    [_heTongTabel.refreshFooter endRefreshing];
    
    
    UILabel *numL = (UILabel *)[heTongView viewWithTag:NUM_TAB];
    numL.text = [NSString stringWithFormat:@"共 %@ 个",[sucDic objectForKey:@"total"]];
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if (isRe) {//加载更多
            
            NSArray *dataArr =[sucDic objectForKey:@"result"];
            
            if (dataArr.count) {
                
                [_heTongArr addObjectsFromArray:dataArr];
                
            }else{
                
                [ToolList showRequestFaileMessageLittleTime:@"暂无更多数据"];
            }
            
            
            
        }else{
            
            if ([[sucDic objectForKey:@"result"] count ]== 0) {
                
                if (_heTongArr) {
                    
                    [_heTongArr removeAllObjects];
                }
                  [ToolList showRequestFaileMessageLittleTime:@"暂无合同数据"];
                
                [_heTongTabel reloadData];
                
                return;
            }
            
            
            _heTongArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
            
        }
        
        [_heTongTabel reloadData];
    }
    
    
}
#pragma mark - 列表代理回调

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==_countTabel ) {
        
        return _contentArr.count;
        
    }else if (tableView == _heTongTabel){
        
        return _heTongArr.count;
    }
    else if(tableView == chanpinTable)
    {
        return chanpinArr.count;
    }
    
    else if ( tableView == _linkManTabel)
    {
        return _linkManArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==_countTabel) {
        
        hh = 55.0f;
        
        NSDictionary *dic = [_contentArr objectAtIndex:indexPath.row];
        
        if ([ToolList changeNull:[dic objectForKey:@"content"]].length){
            
            UIFont *font = [UIFont systemFontOfSize:16];
            CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: font};
            CGSize labelsize = [[dic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            hh = hh+labelsize.height+20;
            
        }
        if ([ToolList changeNull:[dic objectForKey:@"videoURL"]].length){
            
            hh = 10+45+hh;
        }
        
        if ([[dic objectForKey:@"pictureList"] count]) {
            
            NSArray *urlArr = [dic objectForKey:@"pictureList"];
            
            if (urlArr.count==1) {
                
                hh=hh+10+150;
                
            }else{
                float imageWW = (__MainScreen_Width-26)/3.0;
                hh+= (imageWW+3)*((urlArr.count-1)/3)+imageWW+10;
            }
        }
        if ([[dic objectForKey:@"visitType"]isEqualToString:@"签单成交"]|| [[dic objectForKey:@"visitType"]isEqualToString:@"方案报价"]|| [[dic objectForKey:@"visitType"]isEqualToString:@"二次成交"]) {
          
        }else{
            
            hh+=35;
            
            if ([ToolList changeNull:[dic objectForKey:@"visitAdd"]].length) {
                
                hh+=30;
            }
            
        }
      
        hh+=56;
       
        if ([[dic objectForKey:@"flag"] intValue] == 0) {
            hh -= 36;
            
        }
        
        if ([[dic objectForKey:@"callBackMap"] count]) {
            hh += 55;
            NSDictionary *CallDic =[dic objectForKey:@"callBackMap"];
            if ([ToolList changeNull:[CallDic objectForKey:@"content"]].length){
                
                UIFont *font = [UIFont systemFontOfSize:16];
                CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
                NSDictionary *attribute = @{NSFontAttributeName: font};
                CGSize labelsize = [[CallDic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                
                hh = hh+labelsize.height+20;
                
            }
            if ([ToolList changeNull:[CallDic objectForKey:@"videoURL"]].length){
                
                hh = 10+45+hh;
            }
            
            if ([[CallDic objectForKey:@"pictureList"] count]) {
                
                NSArray *urlArr = [CallDic objectForKey:@"pictureList"];
                
                if (urlArr.count==1) {
                    
                    hh=hh+10+150;
                    
                }else{
                    float imageWW = (__MainScreen_Width-26)/3.0;
                    hh+= (imageWW+3)*((urlArr.count-1)/3)+imageWW+10;
                }
            }
            hh+=35;
            
            if ([ToolList changeNull:[CallDic objectForKey:@"visitAdd"]].length) {
                
                hh+=30;
            }
            hh += 8;
        }
        NSLog(@"======%f",hh);
        return hh;
        
    }else if (tableView == _heTongTabel){
        
        return 137;
    }
    else if(tableView == chanpinTable)
    {
        return 110;
    }
    else if (tableView == _linkManTabel){
        return 95.0f;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==_countTabel ) {
        
        return [self loadContentCell:tableView andIndexpath:indexPath];
        
    }
    
    else if (tableView == _linkManTabel){
        
        static NSString *CellIdentifier = @"CY_linkManCell";
        
        CY_linkManCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell2==nil)
        {
            cell2 = [[[NSBundle mainBundle] loadNibNamed:@"CY_linkManCell" owner:self options:nil] lastObject];
            
        }
        NSDictionary *dic = [_linkManArr objectAtIndex:indexPath.row];
        
        NSMutableAttributedString *attrString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@",[dic objectForKey:@"linkManName"],[dic objectForKey:@"sex"]]];
        NSInteger leng = [[dic objectForKey:@"linkManName"] length];
        //设置字体
        [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17]range:NSMakeRange(0, leng)];//设置所有的字体
        // 设置颜色
        [attrString1 addAttribute:NSForegroundColorAttributeName
                            value:[ToolList getColor:@"333333"]
                            range:NSMakeRange(0, leng)];
        
        cell2.nameL.attributedText = attrString1;
        
        if ([[dic objectForKey:@"flag"] intValue]) {//0 为否， 1为常用联系人
            
            UIFont *font = [UIFont systemFontOfSize:17];
            CGSize size = CGSizeMake(20000,17); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: font};
            CGSize labelsize = [[dic objectForKey:@"linkManName"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            UIFont *font1 = [UIFont systemFontOfSize:14];
            CGSize size1 = CGSizeMake(20000,17); //设置一个行高上限
            NSDictionary *attribute1 = @{NSFontAttributeName: font1};
            CGSize labelsize1 = [[dic objectForKey:@"sex"] boundingRectWithSize:size1 options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
            
            cell2.nameW.constant =labelsize.width+labelsize1.width+12;

            cell2.changImage.hidden = NO;
            
        }else{
            
            cell2.changImage.hidden = YES;
        }
        
        cell2.telL.text = [NSString stringWithFormat:@"%@  |  %@",[dic objectForKey:@"mobilePhone"],[dic objectForKey:@"postion"]];
        
        cell2.telB.tag = indexPath.row;
        
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell2;
    }
    
    else if (tableView == _heTongTabel){
        
        static NSString *CellIdentifier = @"heTongCell";
        heTongCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell2==nil)
        {
            cell2 = [[[NSBundle mainBundle] loadNibNamed:@"heTongCell" owner:self options:nil] lastObject];
            
        }
        
        NSDictionary *dic = [_heTongArr objectAtIndex:indexPath.row];
        
        cell2.nubL.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"contractCode"]];
        cell2.xuHaoL.text = [NSString stringWithFormat:@"文本序列号：%@",[dic objectForKey:@"textCode"]];
        cell2.dataL.text = [NSString stringWithFormat:@"签单日期：%@",[dic objectForKey:@"signingTime"]];
        cell2.moneyL.text = [NSString stringWithFormat:@"签单金额：￥%@",[dic objectForKey:@"contractAmount"]];
        
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell2;
        
    }
    else if (tableView == chanpinTable)
    {
        static NSString *CellIdentifier = @"ProductCell";
        ProductCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(cell2==nil)
        {
            cell2 = [[[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:self options:nil] lastObject];
            
        }
        NSDictionary *dic = [chanpinArr objectAtIndex:indexPath.row];
        cell2.nubL.text = [dic objectForKey:@"productName"];
        cell2.xuHaoL.text = [dic objectForKey:@"productTrade"];
        cell2.dataL.text = [NSString stringWithFormat:@"%@ | %@",[dic objectForKey:@"beginDate"],[dic objectForKey:@"endDate"]];
        cell2.selectionStyle = 0;
        cell2.moneyL.text = [dic objectForKey:@"productInstanceServiceStat"];
        if([cell2.moneyL.text isEqualToString:@"已过期"])
        {
            cell2.moneyL.textColor = [ToolList getColor:@"ff3333"];
        }
        return cell2;
    }
    return 0;
}

#pragma mark - 进入单个沟通记录页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView ==_countTabel ) {   
//        NSDictionary *dic = [_contentArr objectAtIndex:indexPath.row];
//        CY_OneRecordVC *oneR = [[CY_OneRecordVC alloc]init];
//        oneR.dataDic = dic;
//        oneR.isZan =[[_zanArr objectAtIndex:indexPath.row] intValue];
//        oneR.zanNum = [[_zanNumArr objectAtIndex:indexPath.row] intValue];
//        [self.navigationController pushViewController:oneR animated:NO];
        
    }else if (tableView == _heTongTabel){
        
        
        CY_popupV *popuV;
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        
        if (popuV == nil) {
            
            popuV = [[CY_popupV alloc]initWithMessage:[_heTongArr objectAtIndex:indexPath.row] andName:_custNameStr];
            
        }else{
            
            popuV.hidden = NO;
        }
        
        [mainWindow addSubview:popuV];
        //_heTongArr
    }
    
    else if (tableView == _linkManTabel){
        
        CY_addDetailsVC *addDetails = [[CY_addDetailsVC alloc]init];
        addDetails.dataDic = [_linkManArr objectAtIndex:indexPath.row];
        addDetails.custNameStr = _custNameStr;
        [self.navigationController pushViewController:addDetails animated:NO];
    }
}



-(UITableViewCell *)loadContentCell:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CY_recordCell";
    CY_recordCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell1==nil)
    {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"CY_recordCell" owner:self options:nil] lastObject];
        //线
//        [cell1.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, hh-0.5) toPoint:CGPointMake(__MainScreen_Width, hh-0.5) andWeight:0.5 andColorString:@"e7e7e7"]];
//        NSLog(@"++++++++%f", cell1.frame.size.height);
        
    }
    
    NSDictionary *dic = [_contentArr objectAtIndex:indexPath.row];
    cell1.touImage.layer.masksToBounds = YES;
    cell1.touImage.layer.cornerRadius = 19.0;
    cell1.touImage.frame = CGRectMake(10, 17, 38, 38);
    cell1.linel.hidden = YES;
    cell1.litleImage.hidden = YES;
    cell1.comBT.hidden = YES;
    
    cell1.nameL.frame = CGRectMake(55, 19, __MainScreen_Width-65, 16);
    
    cell1.nameL.text =  [ToolList changeNull:[dic objectForKey:@"salerName"]];//商务姓名
    cell1.timeL.frame = CGRectMake(55, 40, 200, 14);
    cell1.timeL.text =[ToolList changeNull:[dic objectForKey:@"dateStr"]];//回复时间
    
    //回复内容
    [self makeContentView:cell1.contentL andTimeLabel:cell1.timeL andDic:dic];
    //语音图片
    [self makeYuYinView:cell1.yuYinV andcontentL:cell1.contentL andYYbt:cell1.yuYinBt andMiaoL:cell1.miaoL andBT:cell1.imageAndB andDic:dic andIndex:indexPath];
    
    //图片
    [self makeImage:cell1.ImageV andYuYinV:cell1.yuYinV andDic:dic andIndexpath:indexPath andHuiFang:NO];
    
    if ([[dic objectForKey:@"visitType"]isEqualToString:@"签单成交"]||[[dic objectForKey:@"visitType"]isEqualToString:@"方案报价"]||[[dic objectForKey:@"visitType"]isEqualToString:@"二次成交"]) {
        
        cell1.typeV.hidden = YES;
        cell1.addV.hidden = YES;
       cell1.typeV.frame =CGRectMake(0, cell1.ImageV.frame.origin.y+cell1.ImageV.frame.size.height,0, 0);
        cell1.addV.frame = CGRectMake(0, cell1.typeV.frame.origin.y+cell1.typeV.frame.size.height, 0, 0);
        
    }else{
       
        cell1.typeL.text =[ToolList changeNull:[dic objectForKey:@"visitType"]];//标签
        cell1.typeNameL.text =[ToolList changeNull:[dic objectForKey:@"linkManName"]];//标签联系人
        CGSize sizetype = [cell1.typeNameL sizeThatFits:CGSizeMake( MAXFLOAT,cell1.typeNameL.frame.size.height)];
        float typeW = sizetype.width+10 >__MainScreen_Width-20-cell1.typeNameL.frame.origin.x?__MainScreen_Width-20-cell1.typeNameL.frame.origin.x:sizetype.width+10;
        
        cell1.typeNameL.frame = CGRectMake(cell1.typeNameL.frame.origin.x, cell1.typeNameL.frame.origin.y,typeW, cell1.typeNameL.frame.size.height);
        cell1.typeV.frame =CGRectMake(10, cell1.ImageV.frame.origin.y+cell1.ImageV.frame.size.height+10, __MainScreen_Width-20, 25);
        
        //定位
        if ([ToolList changeNull:[dic objectForKey:@"visitAdd"]].length) {
            
            [cell1.addL setTitle:[ToolList changeNull:[dic objectForKey:@"visitAdd"]] forState:UIControlStateNormal];
            
            CGSize size = [cell1.addL sizeThatFits:CGSizeMake( MAXFLOAT,cell1.addL.frame.size.height)];
            float addW = size.width +20>__MainScreen_Width-20?__MainScreen_Width-20:size.width;
            
            cell1.addV.frame = CGRectMake(10, cell1.typeV.frame.origin.y+cell1.typeV.frame.size.height+5,addW+20, 25);
            
            cell1.addL.frame =CGRectMake(20, 0 ,addW+20, 25);
            
        }else{
            
            cell1.addV.frame = CGRectMake(0, cell1.typeV.frame.origin.y+cell1.typeV.frame.size.height, 0, 0);
            cell1.addV.hidden = YES;
            cell1.addL.frame =CGRectMake(20, 0 ,0, 0);
        }
    }
    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"QUANXIAN"] intValue]==0) {
//        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 0);
//        cell1.touchV.hidden = YES;
//    }else{
//        cell1.touchV.hidden = NO;
//        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 36);
//    }
//    
//    cell1.lunB.frame = CGRectMake(0, 0,(__MainScreen_Width-1)/2, 36);
//    
    
 /*
    //评论
    if ([[dic objectForKey:@"commentNum"] intValue]!=0) {
        
        [cell1.lunB setImage:[UIImage imageNamed:@"icon_cz_pinglun.png"] forState:UIControlStateNormal];
        
        [cell1.lunB setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"commentNum"] ] forState:UIControlStateNormal];
        
    }else{
        
        [cell1.lunB setImage:[UIImage imageNamed:@"icon_cz_pinglun.png"] forState:UIControlStateNormal];
        
        [cell1.lunB setTitle:@"评论"  forState:UIControlStateNormal];
    }
    
    //点赞
    if ([[dic objectForKey:@"praiseNum"] intValue] !=0) {
        
        
        [cell1.zanBt setTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"praiseNum"] ] forState:UIControlStateNormal];
        
    }else{
        
        [cell1.zanBt setTitle:@"赞" forState:UIControlStateNormal];
        
    }
    
    if (_zanArr) {//本地处理点赞
        
        if ([[_zanArr objectAtIndex:indexPath.row] intValue]) {
            
            [cell1.zanBt setImage:[UIImage imageNamed:@"icon_gtjl_zan_s.png"] forState:UIControlStateNormal];
            
            [cell1.zanBt setTitleColor:[UIColor redColor]  forState:UIControlStateNormal];
        }else{
            
            [cell1.zanBt setImage:[UIImage imageNamed:@"icon_cz_zan.png"] forState:UIControlStateNormal];
        }
    }else{
        
        //自己是否点赞过
        if ([[dic objectForKey:@"praiseFlag"] intValue]) {
            
            [cell1.zanBt setImage:[UIImage imageNamed:@"icon_gtjl_zan_s.png"] forState:UIControlStateNormal];
            
            [cell1.zanBt setTitleColor:[UIColor redColor]  forState:UIControlStateNormal];
            
        }else{
            
            [cell1.zanBt setImage:[UIImage imageNamed:@"icon_cz_zan.png"] forState:UIControlStateNormal];
        }
    }


    
    cell1.lunB.tag = indexPath.row+LUN_TAG;
    cell1.zanBt.tag = indexPath.row+ZAN_TAG;
    
    cell1.line.frame = CGRectMake((__MainScreen_Width)/2, 5, 0.5, 28);
    cell1.zanBt.frame =CGRectMake((__MainScreen_Width)/2, 0,(__MainScreen_Width-1)/2, 36);
    */
    if ([[dic objectForKey:@"flag"] intValue]==0) {//0 无操作
        
        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 0);
        cell1.touchV.hidden = YES;
        
    }else if ([[dic objectForKey:@"flag"] intValue]==1){//1 允许 回访 陪访
        
        cell1.touchV.hidden = NO;
        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 36);
        
        cell1.lunB.tag = indexPath.row+LUN_TAG;
        cell1.zanBt.tag =indexPath.row+LUN_TAG;
        
        cell1.lunB.frame = CGRectMake(0, 0,(__MainScreen_Width-1)/2, 36);
        cell1.line.frame = CGRectMake((__MainScreen_Width)/2, 5, 0.5, 28);
        cell1.zanBt.frame =CGRectMake((__MainScreen_Width)/2, 0,(__MainScreen_Width-1)/2, 36);
        
        [cell1.lunB setTitle:@"陪访"  forState:UIControlStateNormal];
        [cell1.zanBt setTitle:@"回访" forState:UIControlStateNormal];
        [cell1.lunB setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cell1.zanBt setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }
    else{// 2.允许回访
        cell1.touchV.hidden = NO;
        cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 36);
        cell1.zanBt.tag =indexPath.row+LUN_TAG;
        cell1.zanBt.frame =CGRectMake(0, 0,__MainScreen_Width, 36);
        [cell1.zanBt setTitle:@"回访" forState:UIControlStateNormal];
        cell1.lunB.hidden = YES;
        cell1.line.hidden = YES;
    }
    
    
    if ([[dic objectForKey:@"callBackMap"] count]){
        
        cell1.huifangView.hidden = NO;
        
        NSDictionary *subDic =[dic objectForKey:@"callBackMap"];
        cell1.touImage1.layer.masksToBounds = YES;
        cell1.touImage1.layer.cornerRadius = 19.0;
        cell1.nameL1.text =  [ToolList changeNull:[subDic objectForKey:@"salerName"]];//商务姓名
        cell1.timeL1.text =[ToolList changeNull:[subDic objectForKey:@"dateStr"]];//回复时间
        //回复内容
        [self makeContentView:cell1.contentL1 andTimeLabel:cell1.timeL1 andDic:subDic];
        //语音图片
        [self makeYuYinView:cell1.yuYinV1 andcontentL:cell1.contentL1 andYYbt:cell1.yuYinBt1 andMiaoL:cell1.miaoL1 andBT:cell1.imageAndB1 andDic:subDic andIndex:indexPath];
        
        //图片
        [self makeImage:cell1.ImageV1 andYuYinV:cell1.yuYinV1 andDic:subDic andIndexpath:indexPath andHuiFang:YES];
        
        cell1.typeL1.text =[ToolList changeNull:[subDic objectForKey:@"visitType"]];//标签
        
        cell1.typeNameL1.text =[ToolList changeNull:[subDic objectForKey:@"linkManName"]];//标签联系人
        CGSize sizetype = [cell1.typeNameL1 sizeThatFits:CGSizeMake( MAXFLOAT,cell1.typeNameL1.frame.size.height)];
        float typeW = sizetype.width+10 >__MainScreen_Width-13-cell1.typeNameL1.frame.origin.x?__MainScreen_Width-13-cell1.typeNameL1.frame.origin.x:sizetype.width+10;
        
        cell1.typeNameL1.frame = CGRectMake(cell1.typeNameL1.frame.origin.x, cell1.typeNameL1.frame.origin.y,typeW+10, cell1.typeNameL1.frame.size.height);
        
        cell1.typeV1.frame =CGRectMake(10, cell1.ImageV1.frame.origin.y+cell1.ImageV1.frame.size.height+10, __MainScreen_Width-20, 25);
        
        //定位
        if ([ToolList changeNull:[subDic objectForKey:@"visitAdd"]].length) {
            
            [cell1.addL1 setTitle:[ToolList changeNull:[subDic objectForKey:@"visitAdd"]] forState:UIControlStateNormal];
            
            CGSize size = [cell1.addL1 sizeThatFits:CGSizeMake( MAXFLOAT,cell1.addL1.frame.size.height)];
            float addW = size.width +20>__MainScreen_Width-20?__MainScreen_Width-20:size.width;
            
            cell1.addV1.frame = CGRectMake(10, cell1.typeV1.frame.origin.y+cell1.typeV1.frame.size.height+5,addW+20, 25);
            
            cell1.addL1.frame =CGRectMake(20, 0 ,addW+20, 25);
            
        }else{
            
            cell1.addV1.frame = CGRectMake(0, cell1.typeV1.frame.origin.y+cell1.typeV1.frame.size.height, 0, 0);
            cell1.addV1.hidden = YES;
            cell1.addL1.frame =CGRectMake(20, 0 ,0, 0);
        }
        
        
        cell1.huifangView.frame = CGRectMake(cell1.huifangView.frame.origin.x, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height, __MainScreen_Width-16, cell1.typeV1.frame.origin.y+cell1.typeV1.frame.size.height+10);
        
    }else{
        cell1.huifangView.hidden = YES;
        cell1.huifangView.frame = CGRectMake(cell1.huifangView.frame.origin.x, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height, __MainScreen_Width-16, 0);
    }
    
    
    cell1.mainV.frame =CGRectMake(0,0,__MainScreen_Width, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height);
    cell1.frame =CGRectMake(0,0,__MainScreen_Width, cell1.mainV.frame.size.height+cell1.huifangView.frame.size.height+10);
   
    cell1.line0.frame = CGRectMake(0, cell1.mainV.frame.size.height+cell1.huifangView.frame.size.height+9.5, __MainScreen_Width, 0.5);
    
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _loadingImage =cell1.imageAndB;
    //播放时喇叭动画
    //设置动画帧
    _loadingImage.animationImages=[NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_1.png"],
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_2.png"],
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"],
                                   nil ];
    
    //设置动画总时间
    _loadingImage.animationDuration=1.0;
    
    //设置重复次数，0表示不重复
    _loadingImage.animationRepeatCount=100;
    
    return cell1;
}

#pragma mark---计算记录的内容
-(void)makeContentView:(UITextView *)contentView andTimeLabel:(UILabel *)timeLabel andDic:(NSDictionary *)dic {
    
    if ([ToolList changeNull:[dic objectForKey:@"content"]].length) {
        
        contentView.text = [dic objectForKey:@"content"];
        
        NSString *motherstr = [dic objectForKey:@"content"];
        NSString * sonstr = @"[";
        NSRange rang = [motherstr rangeOfString:sonstr options:NSBackwardsSearch range:NSMakeRange(0, motherstr.length)];
        
        while  (rang.location != NSNotFound) {
            
            
            EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
            
            NSString *str = [[dic objectForKey:@"content"] substringWithRange:NSMakeRange(rang.location,6)];
            
            emojiTextAttachment.emojiTag = str;
            
            for (int i=0;i<_emojiTags.count;i++) {
                
                if ([[_emojiTags objectAtIndex:i ] isEqualToString:str]) {
                    
                    emojiTextAttachment.image = _emojiImages[(NSUInteger) i]; ;
                }
            }
            
            
            emojiTextAttachment.emojiSize = CGSizeMake(20, 20);
            
            [contentView.textStorage replaceCharactersInRange:NSMakeRange(rang.location,6) withAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]];
            
            NSUInteger start = 0;
            NSUInteger end = rang.location;
            NSRange temp = NSMakeRange(start,end);
            rang =[motherstr rangeOfString:sonstr options:NSBackwardsSearch range:temp];
            
        }
        
        
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [[dic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        CGRect rect = contentView.frame;
        rect.size.height =labelsize.height+10;
        rect.origin.y =timeLabel.frame.origin.y+timeLabel.frame.size.height+10;
        [contentView setFrame:rect];
        
        contentView.editable = NO;
        contentView.scrollEnabled = NO;
        
    }
    
    else{
        
        [contentView setFrame:CGRectMake(0, timeLabel.frame.origin.y+timeLabel.frame.size.height, 0, 0)];
    }
    
}

#pragma mark---语音
-(void)makeYuYinView:(UIView *)yuYinView andcontentL:(UITextView *)contentL andYYbt:(UIButton *)yuYinBt andMiaoL:(UILabel *)miaoL andBT:(UIImageView *)imageBt andDic:(NSDictionary *)dic andIndex:(NSIndexPath *)indexPath{
    
    if ([ToolList changeNull:[dic objectForKey:@"videoURL"]].length) {
        
        int mI = [[dic objectForKey:@"videoLength"] intValue];
        
        yuYinView.frame = CGRectMake(10, contentL.frame.origin.y+contentL.frame.size.height+10, __MainScreen_Width-20, 45);
        
        yuYinBt.tag = indexPath.row;
        miaoL.text = [NSString stringWithFormat:@"%@''",[dic objectForKey:@"videoLength"]];
        yuYinView.hidden = NO;
        imageBt.image = [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"];
        imageBt.frame= CGRectMake(13,15, 11, 15);
        
        if (mI<31) {
            
            yuYinBt.frame= CGRectMake(0, 0, 102, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_0-30.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>30 && mI<61){
            
            yuYinBt.frame= CGRectMake(0, 0, 136, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_31-60.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>60 && mI<91){
            
            yuYinBt.frame= CGRectMake(0, 0, 193, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_61-90.png"] forState:UIControlStateNormal];
            
            
        }else{
            yuYinBt.frame= CGRectMake(0, 0, 241, 45);
            [yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_91-120.png"] forState:UIControlStateNormal];
            
        }
        miaoL.frame = CGRectMake(yuYinBt.frame.size.width+5, 12, 42, 21);
        
    }else{
        
        yuYinView.frame =CGRectMake(0, contentL.frame.origin.y+contentL.frame.size.height, 0, 0);
        yuYinView.hidden = YES;
    }
}
#pragma mark---图片
-(void)makeImage:(UIView *)imageV andYuYinV:(UIView *)YuYinV  andDic:(NSDictionary *)dic andIndexpath:(NSIndexPath *)indexpath andHuiFang:(BOOL)isHuiFang{
    
    if ([[dic objectForKey:@"pictureList"] count]) {
        NSArray *urlArr = [dic objectForKey:@"pictureList"];
        
        if ([urlArr count]==1) {
            
            NSDictionary *urlDic = [urlArr objectAtIndex:0];
            
            NSString *urlString = [urlDic objectForKey:@"bigUrlPath"];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            //生成图片
            UIImageView  *urlImage = [[UIImageView alloc]init];
            urlImage.backgroundColor = [UIColor clearColor];
            urlImage.userInteractionEnabled = YES;
            [imageV addSubview:urlImage];
            
            UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
            urlBt.backgroundColor = [UIColor clearColor];
            urlBt.tag = indexpath.row*100;
            if (isHuiFang) {//回访里面的图片处理
                
                [urlBt addTarget:self action:@selector(goBig_Pic:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
            }

//            [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
            [urlImage addSubview:urlBt];
            
            [urlImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                float mainFloat =image.size.width>image.size.height?image.size.height:image.size.width;
                
                if (mainFloat>150 || mainFloat == 150) {
                    
                    //宽度长
                    if (image.size.width>image.size.height) {
                        
                        CGSize imagesize = image.size;
                        imagesize.height =150;
                        imagesize.width =(image.size.width *150.0)/mainFloat;
                        //对图片大小进行压缩--
                        //                         image = [self imageWithImage:image scaledToSize:imagesize];
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }else{
                        
                        CGSize imagesize = image.size;
                        imagesize.width =150;
                        imagesize.height =(image.size.height *150.0)/mainFloat;
                        //对图片大小进行压缩--
                        //                         image = [self imageWithImage:image scaledToSize:imagesize];
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }
                    //                     image = [self cutImage:image];
                    image = [ToolList cutImage:image];
                }
                
                else{
                    
#pragma 图片小于300的时候处理
                    urlImage.contentMode = UIViewContentModeScaleAspectFill;
                    urlImage.clipsToBounds = YES;
                    [urlImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"]];
                }
            }];
            
            
            
            imageV.frame = CGRectMake(10, YuYinV.frame.origin.y+YuYinV.frame.size.height+10,150,150);
            
            urlImage.frame = CGRectMake(0, 0, imageV.frame.size.width, imageV.frame.size.height);
            urlBt.frame =CGRectMake(0, 0, urlImage.frame.size.width, urlImage.frame.size.height);
            
            
        }else{//多张图片处理
            
            
            float imageWW = (__MainScreen_Width-26)/3.0;
            
            imageV.frame = CGRectMake(10, YuYinV.frame.origin.y+YuYinV.frame.size.height+10,__MainScreen_Width,(imageWW+3)*((urlArr.count-1)/3)+imageWW);
            
            for (int i=0;i<urlArr.count;i++) {
                
                NSDictionary *dic = [urlArr objectAtIndex:i];
                NSString *smallUrl = [dic objectForKey:@"smallUrlPath"];
                
                
                UIImageView * urlImage1 = [[UIImageView alloc]init];
                urlImage1.backgroundColor = [UIColor clearColor];
                urlImage1.frame = CGRectMake((i%3)*(imageWW+3), i/3 *(imageWW+3), imageWW, imageWW);
                urlImage1.tag = i;
                urlImage1.userInteractionEnabled=YES;
                urlImage1.contentMode = UIViewContentModeScaleAspectFill;
                urlImage1.clipsToBounds = YES;
                NSURL *url =  [NSURL URLWithString:smallUrl];
                [urlImage1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"]];
                [imageV addSubview:urlImage1];
                
                UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
                urlBt.backgroundColor = [UIColor clearColor];
                urlBt.tag = i+100*indexpath.row;
                if (isHuiFang) {//回访里面的图片处理
                    
                    [urlBt addTarget:self action:@selector(goBig_Pic:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
                }

//                [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
                urlBt.frame =CGRectMake(0,0, urlImage1.frame.size.width, urlImage1.frame.size.height);
                [urlImage1 addSubview:urlBt];
            }
            
        }
        
    }else{
        [imageV setFrame:CGRectMake(0, YuYinV.frame.origin.y+YuYinV.frame.size.height, 0, 0)];
    }
}

#pragma 查看详细地址

-(IBAction)touchAdd:(UIButton *)sender{
    
    UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
    CY_popupV *dialogView ;
    if (dialogView == nil) {
        
        dialogView = [[CY_popupV alloc] initWithFrame:CGRectMake(0, 0, 200, 300) andMessage:sender.titleLabel.text];
    }else{
        
        dialogView.hidden = NO;
    }
        
    [mainWindow addSubview:dialogView];
}
#pragma mark---回访
-(IBAction)goZan:(UIButton *)sender{
    
    NSDictionary *dic = [_contentArr objectAtIndex:sender.tag-LUN_TAG];
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"other";
    gh.kehuNameStr = [dic objectForKey:@"custName"];
    gh.kehuNameId = [dic objectForKey:@"custId"];
    gh.logId =[dic objectForKey:@"logId"];
    gh.lianxirenId =[dic objectForKey:@"contact"];
    gh.lianxirenName =[dic objectForKey:@"name"];

    gh.chooseId = 0;
    gh.isHuiFang = 1;
    gh.xiaoshoudongzuoBtnArr = @[@{@"1":@"回访"}];
    //    _flagRefresh = @"jilu";
    [self.navigationController pushViewController:gh animated:NO];
}

-(void)zanSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if ([_senderbt.currentImage isEqual:[UIImage imageNamed:@"icon_gtjl_zan_s.png"]]) {//取消
            
            [_senderbt setTitleColor:[ToolList getColor:@"929292"] forState:UIControlStateNormal];
            
            [_senderbt setImage:[UIImage imageNamed:@"icon_cz_zan.png"] forState:UIControlStateNormal];
            
            int num = [_senderbt.titleLabel.text intValue];
            
            if (num==1) {
                
                [_senderbt setTitle:@"赞" forState:UIControlStateNormal];
                 [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:num]];
                
            }else{
                
                [_senderbt setTitle:[NSString stringWithFormat:@"%d",num-1] forState:UIControlStateNormal];
                 [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:num-1]];
            }
            
            [_zanArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:0]];
            
        }else{//点赞
            
            [_senderbt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [_senderbt setImage:[UIImage imageNamed:@"icon_gtjl_zan_s.png"] forState:UIControlStateNormal];
            
            if ([_senderbt.titleLabel.text isEqualToString:@"赞"]) {
                
                [_senderbt setTitle:@"1" forState:UIControlStateNormal];
                [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:1]];
            }else{
                
                int num = [_senderbt.titleLabel.text intValue];
                
                [_senderbt setTitle:[NSString stringWithFormat:@"%d",num+1] forState:UIControlStateNormal];
                 [_zanNumArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:num+1]];
            }
            
            [_zanArr replaceObjectAtIndex:_senderbt.tag-ZAN_TAG withObject:[NSNumber numberWithInt:1]];
            
        }
        
        
        
    }
    
}

#pragma mark---陪访
-(IBAction)goWrit:(UIButton *)sender{
    
    NSDictionary *dic = [_contentArr objectAtIndex:sender.tag-LUN_TAG];
    XiejiluViewController *gh = [[XiejiluViewController alloc] init];
    gh.quanxianFlag = @"商务";
    gh.fromPage = @"other";
    gh.kehuNameStr = [dic objectForKey:@"custName"];
    gh.kehuNameId = [dic objectForKey:@"custId"];
    gh.logId =[dic objectForKey:@"logId"];

    gh.lianxirenId =[dic objectForKey:@"contact"];
     gh.lianxirenName =[dic objectForKey:@"name"];

    gh.isHuiFang = 1;
    gh.chooseId = 1;
    //    _flagRefresh = @"jilu";
    [self.navigationController pushViewController:gh animated:NO];
}

#pragma mark---回访-点击看大图

-(void)goBig_Pic:(UIButton *)bt{
    
    if (_bigUrlArr==nil) {
        
        _bigUrlArr = [[NSMutableArray alloc]init];
        
    }else{
        
        [_bigUrlArr removeAllObjects];
    }
    
    NSInteger intag = bt.tag/100;
    
    NSDictionary *dic = [_contentArr objectAtIndex:intag];
    NSArray *arr;
    if ([[dic objectForKey:@"callBackMap"] count])
    {
        arr = [[dic objectForKey:@"callBackMap"] objectForKey:@"pictureList"];
        for (dic in arr) {
            
            [_bigUrlArr addObject:
             [dic objectForKey:@"bigUrlPath"]];
        }
        
        CY_photoVc *bigPic = [[CY_photoVc alloc]init];
        bigPic.pArray = _bigUrlArr;
        bigPic.currentPage = bt.tag%100;
        
        [self.navigationController pushViewController:bigPic animated:NO];
    }
    
}


#pragma mark----点击看大图

-(void)goBigPic:(UIButton *)bt{
    
    if (_bigUrlArr==nil) {
        
        _bigUrlArr = [[NSMutableArray alloc]init];
        
    }else{
        
        [_bigUrlArr removeAllObjects];
    }
    
    NSInteger intag = bt.tag/100;
    
    NSDictionary *dic = [_contentArr objectAtIndex:intag];
    
    NSArray *arr = [dic objectForKey:@"pictureList"];
    
    for (dic in arr) {
        
        [_bigUrlArr addObject:[dic objectForKey:@"bigUrlPath"]];
    }
    
    CY_photoVc *bigPic = [[CY_photoVc alloc]init];
    bigPic.pArray = _bigUrlArr;
    bigPic.currentPage = bt.tag%100;
    
    [self.navigationController pushViewController:bigPic animated:NO];
}

#pragma 缓存语音

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag  {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    //检查附件是否存在
    
//    if (audioPlayer != nil) {
//          
//       [audioPlayer stop];
//    }
    
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        //初始化播放
        NSError *playerError;
        audioPlayer = nil;
        
        audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playerError];
        
        audioPlayer.meteringEnabled = YES;
        audioPlayer.delegate = self;
        [audioPlayer play];
        
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //          [ToolList showRequestFaileMessageLongTime:@"语音下载中..."];
        
        //下载附件
        NSURL *url = [NSURL URLWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        //        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        //已完成下载
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"已完成下载");
            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            
            //初始化播放
            NSError *playerError;
            audioPlayer = nil;
            
            audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playerError];
            
            audioPlayer.meteringEnabled = YES;
            audioPlayer.delegate = self;
            [audioPlayer play];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"下载失败 %@",error);
            
            [ToolList showRequestFaileMessageLongTime:@"语音下载失败！"];
        }];
        
        [operation start];
    }
}

#pragma mark - 回访或陪访播放语音
- (IBAction)bofang_LuYin:(UIButton *)sender
{
    
    NSInteger path = sender.tag;
    NSDictionary *dic = [_contentArr objectAtIndex:path];
    if ([[dic objectForKey:@"callBackMap"] count])
    {
        NSString *urlPath = [[dic objectForKey:@"callBackMap"] objectForKey:@"videoURL"];
        
        NSArray *array = [urlPath componentsSeparatedByString:@"/"];
        [self downloadFileURL:urlPath savePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/cy"] fileName:[array lastObject] tag:_contentArr.count-sender.tag];
        
        NSLog(@"开始播放了");
        
        _loadingImage = (UIImageView *)[sender.superview viewWithTag:143];
        
        [_loadingImage startAnimating];
    }

}

#pragma mark - 播放语音
- (IBAction)bofangLuYin:(UIButton *)sender
{
    
    NSInteger path = sender.tag;
    NSDictionary *dic = [_contentArr objectAtIndex:path];
    NSString *urlPath = [dic objectForKey:@"videoURL"];
    
    NSArray *array = [urlPath componentsSeparatedByString:@"/"];
    [self downloadFileURL:urlPath savePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/cy"] fileName:[array lastObject] tag:_contentArr.count-sender.tag];
    
    NSLog(@"开始播放了");
    
    _loadingImage = (UIImageView *)[sender.superview viewWithTag:143];
    
    [_loadingImage startAnimating];
    
}

#pragma mark - 播放音频完成后的回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //成功播放完音频后释放资源
    if ([player isPlaying]) {
        [player stop];
    }
    NSLog(@"播完了");
    [_loadingImage stopAnimating];
    
}
- (IBAction)goMore44:(id)sender {
    New_ShouCangDetailMore *s = [[New_ShouCangDetailMore alloc]init];
    s.custId = [DetailDic objectForKey:@"custId"];
    s.receiveDic = DetailDic;
    [self.navigationController pushViewController:s animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
