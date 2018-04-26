//
//  CountList.m
//  SaleManagement
//
//  Created by feixiang on 2017/3/6.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "CountList.h"
#import "CY_OneRecordVC.h"
#import"CY_recordCell.h"
#import "EmojiTextAttachment.h"
#import "CY_photoVc.h"
#import"CY_writContenVc.h"
@interface CountList ()
{
   
    //开始数据标识
    int startPage;
    NSMutableDictionary *_requestDic;
    NSMutableArray *_zanNumArr;
    NSMutableArray *_zanArr;

}
@property (nonatomic,strong)UIButton *senderbt;//

@end

@implementation CountList

#pragma mark - 记录数据请求
-(void)contentRequest{
    _requestDic[@"custId"] = _custId;
    _requestDic[@"pagesize"]=[NSNumber numberWithInt:10];
    [_requestDic setObject:[NSString stringWithFormat:@"%d",startPage] forKey:@"pageNo"];
    
    [FX_UrlRequestManager postByUrlStr:custId_url andPramas:_requestDic andDelegate:self andSuccess:@"custSuccess:" andFaild:@"custCustFild:" andIsNeedCookies:YES];
}

-(void)custCustFild:(NSError *)err{
    
    [_countTabel.refreshHeader endRefreshing];
    [_countTabel.refreshFooter endRefreshing];
    
    [ToolList showRequestFaileMessageLittleTime:[err.userInfo objectForKey:@"msg"]];
}

#pragma mark - 记录数据请求成功
-(void)custSuccess:(NSDictionary *)dic{
    
    [_countTabel.refreshHeader endRefreshing];
    [_countTabel.refreshFooter endRefreshing];
    
    
    if(startPage == 1)
    {
        [_contentArr removeAllObjects];
    }
    if([[dic objectForKey:@"result"] count] <= 0)
    {
        if(startPage == 1)
        {
            [_contentArr removeAllObjects];
        }
        [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
    }
    else
    {
        [_contentArr addObjectsFromArray:[dic objectForKey:@"result"]];
        
    }
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
    [_countTabel reloadData];
    
    
}
#pragma mark - 刷新有关
//刷新
-(void)headerRefresh:(Fx_TableView *)table
{
    startPage = 1;
    [self contentRequest];
}
//加载更多
-(void)footerRefresh:(Fx_TableView *)table
{
    startPage += 1;
    [self contentRequest];
    
}
-(IBAction)goZan:(UIButton *)sender{
    
    _senderbt = sender;
    
    NSDictionary *dic = [_contentArr objectAtIndex:sender.tag-ZAN_TAG];
    
    NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
    requestDic[@"logId"]= [NSString stringWithFormat:@"%@",[dic objectForKey:@"logId"]];
    [FX_UrlRequestManager postByUrlStr:zan_url andPramas:requestDic andDelegate:self andSuccess:@"zanSuccess:" andFaild:@"replyFild:" andIsNeedCookies:YES];
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
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    startPage = 1;
    [self contentRequest];

}

#pragma 进入回复及评价页面
-(IBAction)goWrit:(id)sender{
    
    UIButton *bt = (UIButton *)sender;
    
    NSMutableDictionary * _canDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *dic = [_contentArr objectAtIndex:bt.tag-LUN_TAG];
    
    [ _canDic setObject:[dic objectForKey:@"logId"] forKey:@"logId"];
    [_canDic setObject:[dic objectForKey:@"custId"] forKey:@"custId"];
    [_canDic setObject:@"" forKey:@"replyToPeopleId"];
    [_canDic setObject:@"" forKey:@"replyToPeopleName"];
    
    CY_writContenVc *writeV = [[CY_writContenVc alloc]initWithNibName:@"CY_writContenVc" bundle:nil andDic:_canDic andListArr:nil];
    
    [self.navigationController pushViewController:writeV animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _emojiTags = [[NSMutableArray alloc]init];
    _emojiImages =[[NSMutableArray alloc]init];
    
    for(int i = 0 ; i < 8;i++)
    {
        NSString *tag = [NSString stringWithFormat:@"[bq_%d]",i+1];
        NSString *image = [NSString stringWithFormat:@"bq_%d.png",i+1];
        [_emojiTags addObject:tag];
        [_emojiImages addObject:[UIImage imageNamed:image]];
        
    }
    //标题
    [self addNavgationbar:@"沟通记录" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:@"searchClicked:" leftHiden:NO rightHiden:YES];
    _requestDic = [[NSMutableDictionary alloc] init];
    _contentArr = [[NSMutableArray alloc] init];
    _countTabel = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStylePlain isNeedRefresh:YES target:self];
    _countTabel.dataSource = self;
    _countTabel.delegate = self;
    _countTabel.backgroundColor = [UIColor whiteColor];
    [_countTabel.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_countTabel];
    // Do any additional setup after loading the view.
}
#pragma mark - 列表代理回调

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return _contentArr.count;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        float hh = 55.0f;
        
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
        
        return hh;
        
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        return [self loadContentCell:tableView andIndexpath:indexPath];
        
  
}

#pragma mark - 进入单个沟通记录页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSDictionary *dic = [_contentArr objectAtIndex:indexPath.row];
        CY_OneRecordVC *oneR = [[CY_OneRecordVC alloc]init];
        oneR.dataDic = dic;
        oneR.isZan =[[_zanArr objectAtIndex:indexPath.row] intValue];
        oneR.zanNum = [[_zanNumArr objectAtIndex:indexPath.row] intValue];
        [self.navigationController pushViewController:oneR animated:NO];
        
    }



-(UITableViewCell *)loadContentCell:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CY_recordCell";
    CY_recordCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell1==nil)
    {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"CY_recordCell" owner:self options:nil] lastObject];
        
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
    if ([ToolList changeNull:[dic objectForKey:@"content"]].length) {
        
        cell1.contentL.text =[ToolList changeNull:[dic objectForKey:@"content"]];
        ;
        
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
            
            [cell1.contentL.textStorage replaceCharactersInRange:NSMakeRange(rang.location,6) withAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]];
            
            NSUInteger start = 0;
            NSUInteger end = rang.location;
            NSRange temp = NSMakeRange(start,end);
            rang =[motherstr rangeOfString:sonstr options:NSBackwardsSearch range:temp];
            
        }
        
        cell1.contentL.editable = NO;
        cell1.contentL.scrollEnabled = NO;
        
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [[dic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        CGRect rect = cell1.contentL.frame;
        rect.size.height =labelsize.height+10;
        rect.origin.y =cell1.timeL.frame.origin.y+cell1.timeL.frame.size.height+10;
        [cell1.contentL setFrame:rect];
        
    }else{
        
        [cell1.contentL setFrame:CGRectMake(0, cell1.timeL.frame.origin.y+cell1.timeL.frame.size.height, 0, 0)];
        
    }
    
    //语音图片
    if ([ToolList changeNull:[dic objectForKey:@"videoURL"]].length) {
        
        int mI = [[dic objectForKey:@"videoLength"] intValue];
        
        
        cell1.yuYinV.frame = CGRectMake(10, cell1.contentL.frame.origin.y+cell1.contentL.frame.size.height+10, __MainScreen_Width-20, 45);
        
        cell1.yuYinBt.tag = indexPath.row;
        cell1.miaoL.text = [NSString stringWithFormat:@"%@''",[dic objectForKey:@"videoLength"]];
        cell1.yuYinV.hidden = NO;
        cell1.imageAndB.image = [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"];
        cell1.imageAndB.frame= CGRectMake(13,15, 11, 15);
        
        if (mI<31) {
            
            cell1.yuYinBt.frame= CGRectMake(0, 0, 102, 45);
            [cell1.yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_0-30.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>30 && mI<61){
            
            cell1.yuYinBt.frame= CGRectMake(0, 0, 136, 45);
            [cell1.yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_31-60.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>60 && mI<91){
            
            cell1.yuYinBt.frame= CGRectMake(0, 0, 193, 45);
            [cell1.yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_61-90.png"] forState:UIControlStateNormal];
            
            
        }else{
            cell1.yuYinBt.frame= CGRectMake(0, 0, 241, 45);
            [cell1.yuYinBt setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_91-120.png"] forState:UIControlStateNormal];
            
        }
        cell1.miaoL.frame = CGRectMake(cell1.yuYinBt.frame.size.width+5, 12, 42, 21);
        
    }else{
        
        cell1.yuYinV.frame =CGRectMake(0, cell1.contentL.frame.origin.y+cell1.contentL.frame.size.height, 0, 0);
        cell1.yuYinV.hidden = YES;
    }
    
    //图片
    
    if ([[dic objectForKey:@"pictureList"] count]) {
        
        NSArray *urlArr = [dic objectForKey:@"pictureList"];
        
        
        if ([urlArr count]==1) {
            
            NSDictionary *urlDic = [urlArr objectAtIndex:0];
            
            NSString *urlString = [urlDic objectForKey:@"bigUrlPath"];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            //生成图片
            UIImageView * urlImage = [[UIImageView alloc]init];
            urlImage.backgroundColor = [UIColor clearColor];
            urlImage.userInteractionEnabled = YES;
            [cell1.ImageV addSubview:urlImage];
            
            UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
            urlBt.backgroundColor = [UIColor clearColor];
            urlBt.tag = indexPath.row*100;
            [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
            [urlImage addSubview:urlBt];
            
            [urlImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                float mainFloat =image.size.width>image.size.height?image.size.height:image.size.width;
                
                if (mainFloat>150 || mainFloat == 150) {
                    
                    //宽度长
                    if (image.size.width>image.size.height) {
                        
                        CGSize imagesize = image.size;
                        imagesize.height =150;
                        imagesize.width =(image.size.width *150.0)/mainFloat;
                        
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }else{
                        
                        CGSize imagesize = image.size;
                        imagesize.width =150;
                        imagesize.height =(image.size.height *150.0)/mainFloat;
                        
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }
                    
                    image = [ToolList cutImage:image];
                }
                
                else{
                    
#pragma 图片小于300的时候处理
                    urlImage.contentMode = UIViewContentModeScaleAspectFill;
                    urlImage.clipsToBounds = YES;
                    [urlImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"]];
                }
            }];
            
            
            
            cell1.ImageV.frame = CGRectMake(10, cell1.yuYinV.frame.origin.y+cell1.yuYinV.frame.size.height+10,150,150);
            
            urlImage.frame = CGRectMake(0, 0, cell1.ImageV.frame.size.width, cell1.ImageV.frame.size.height);
            urlBt.frame =CGRectMake(0, 0, urlImage.frame.size.width, urlImage.frame.size.height);
            
            
        }else{//多张图片处理
            
            
            float imageWW = (__MainScreen_Width-26)/3.0;
            
            cell1.ImageV.frame = CGRectMake(10, cell1.yuYinV.frame.origin.y+cell1.yuYinV.frame.size.height+10,__MainScreen_Width,(imageWW+3)*((urlArr.count-1)/3)+imageWW);
            
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
                [cell1.ImageV addSubview:urlImage1];
                
                UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
                urlBt.backgroundColor = [UIColor clearColor];
                urlBt.tag = i+100*indexPath.row;
                [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
                urlBt.frame =CGRectMake(0,0, urlImage1.frame.size.width, urlImage1.frame.size.height);
                [urlImage1 addSubview:urlBt];
            }
            
        }
        
    }else{
        
        
        [cell1.ImageV setFrame:CGRectMake(0, cell1.yuYinV.frame.origin.y+cell1.yuYinV.frame.size.height, 0, 0)];
        
        
    }
    
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
    
    cell1.touchV.frame = CGRectMake(0, cell1.addV.frame.origin.y+cell1.addV.frame.size.height+10,__MainScreen_Width, 36);
    
    cell1.lunB.frame = CGRectMake(0, 0,(__MainScreen_Width-1)/2, 36);
    
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
    
    cell1.mainV.frame =CGRectMake(0,0,__MainScreen_Width, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height);
    cell1.frame =CGRectMake(0,0,__MainScreen_Width, cell1.touchV.frame.origin.y+cell1.touchV.frame.size.height+10);
    
    
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
#pragma 点击看大图

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
