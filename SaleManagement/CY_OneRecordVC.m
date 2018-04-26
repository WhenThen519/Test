//
//  CY_OneRecordVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/19.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_OneRecordVC.h"
#import "CY_oneCell.h"
#import "UIImageView+WebCache.h"
#import "CY_photoVc.h"
#import "CY_writContenVc.h"
#import "CY_popupV.H"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

@interface CY_OneRecordVC ()
{
    float table_H;
    //播语音
    AVAudioPlayer *oneAudioPlayer;
 
}

@property (nonatomic,weak)IBOutlet UITableView *oneTable;

@property (nonatomic,strong) UITableView *twoTable;

@property (nonatomic,strong)NSMutableArray *oneArr;

@property (nonatomic,strong)NSMutableArray *twoArr;

@property (nonatomic,strong)NSMutableArray *bigUrlArr;//大图数组

@property (nonatomic,strong)IBOutlet UIScrollView *mainScroll;

@property (weak, nonatomic) IBOutlet UIView *yuYinV;

@property (weak, nonatomic) IBOutlet UIView *mainV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UITextView *contentL;

@property (weak, nonatomic) IBOutlet UIView *picV;

@property (weak, nonatomic) IBOutlet UIView *typeV;

@property (weak, nonatomic) IBOutlet UIView *addV;

@property (weak, nonatomic) IBOutlet UIView *recordV;

@property (weak, nonatomic) IBOutlet UIButton *addB;

@property (weak, nonatomic) IBOutlet UIButton *yuyinB;

@property (weak, nonatomic) IBOutlet UILabel *telL;

@property (weak, nonatomic) IBOutlet UILabel *cellNameL;

@property (weak, nonatomic) IBOutlet UILabel *comNameL;

@property (weak, nonatomic) IBOutlet UIImageView *yuyinImage;

@property (weak, nonatomic) IBOutlet UILabel *miaoL;

@property (weak, nonatomic) IBOutlet UIView *handV;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (strong, nonatomic)  FX_Button *b1;

@property (strong, nonatomic)  FX_Button *b2;

@property (weak, nonatomic) IBOutlet UIImageView *line;

@property (weak, nonatomic) IBOutlet UIButton *zanB;

@property (weak, nonatomic) IBOutlet UIButton *lunB;

@property (weak,nonatomic) IBOutlet UIImageView *handImage;

@property (nonatomic,strong)NSMutableDictionary *canDic;

@property (nonatomic,strong)NSMutableArray *emojiTags;//表情TAG

@property (nonatomic,strong)NSMutableArray *emojiImages;//表情对应图片

@end

@implementation CY_OneRecordVC


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    
    NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
    requestDic[@"logId"]= [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"logId"]];
    [FX_UrlRequestManager postByUrlStr:reply_url andPramas:requestDic andDelegate:self andSuccess:@"replySuccess:" andFaild:@"replyFild:" andIsNeedCookies:YES];
}//zan_url


-(void)LeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
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
    

    
    [self addNavgationbar:@"沟通记录" leftImageName:nil rightImageName:nil target:self leftBtnAction:@"LeftAction:" rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    
    [self initView];
    
    _twoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, _oneTable.frame.origin.y, __MainScreen_Width, _oneTable.frame.size.height) style:UITableViewStylePlain];
    _twoTable.backgroundColor = [UIColor whiteColor];
    _twoTable.delegate = self;
    _twoTable.dataSource = self;
    _twoTable.hidden = YES;
    [_mainScroll addSubview:_twoTable];
  
    
}

-(void)initView{

    _mainScroll.frame = CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height-36);
    _comNameL.text =[ToolList changeNull:[_dataDic objectForKey:@"custName"]];//公司名称
   _nameL.text =  [ToolList changeNull:[_dataDic objectForKey:@"salerName"]];//商务姓名
    
    _timeL.text =[ToolList changeNull:[_dataDic objectForKey:@"dateStr"]];//回复时间
    
    _handImage.layer.masksToBounds = YES;
    _handImage.layer.cornerRadius = 19.0;
    
    /*   回复或是评论文字    */
    if ([ToolList changeNull:[_dataDic objectForKey:@"content"]].length){
        
          _contentL.text =[_dataDic objectForKey:@"content"];
        
        NSString *motherstr = [_dataDic objectForKey:@"content"];
        NSString * sonstr = @"[";
        NSRange rang = [motherstr rangeOfString:sonstr options:NSBackwardsSearch range:NSMakeRange(0, motherstr.length)];
        
        while  (rang.location != NSNotFound) {
            
            
            EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
            
            NSString *str = [[_dataDic objectForKey:@"content"] substringWithRange:NSMakeRange(rang.location,6)];
            
            emojiTextAttachment.emojiTag = str;
            
            for (int i=0;i<_emojiTags.count;i++) {
                
                if ([[_emojiTags objectAtIndex:i ] isEqualToString:str]) {
                    
                    emojiTextAttachment.image = _emojiImages[(NSUInteger) i]; ;
                }
            }
            
            
            emojiTextAttachment.emojiSize = CGSizeMake(20, 20);
            
            [_contentL.textStorage replaceCharactersInRange:NSMakeRange(rang.location,6) withAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]];
            
            NSUInteger start = 0;
            NSUInteger end = rang.location;
            NSRange temp = NSMakeRange(start,end);
            rang =[motherstr rangeOfString:sonstr options:NSBackwardsSearch range:temp];
            
        }

        
        UIFont *font = [UIFont systemFontOfSize:16];
        CGSize size = CGSizeMake(__MainScreen_Width-20,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [[_dataDic objectForKey:@"content"] boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        CGRect rect = _contentL.frame;
        rect.size.height =labelsize.height+10;
        rect.origin.y =_timeL.frame.origin.y+_timeL.frame.size.height+10;
        [_contentL setFrame:rect];
        
        _contentL.editable = NO;
        _contentL.scrollEnabled = NO;
        
    }else{
        
        [_contentL setFrame:CGRectMake(0,_timeL.frame.origin.y+_timeL.frame.size.height, 0, 0)];
        
    }
    
     /*   语音  */
    if ([ToolList changeNull:[_dataDic objectForKey:@"videoURL"]].length){
        
        _yuYinV.frame = CGRectMake(10, _contentL.frame.origin.y+_contentL.frame.size.height+10, __MainScreen_Width-20, 45);
        
        _yuyinB.tag = 0;
        _miaoL.text = [NSString stringWithFormat:@"%@''",[_dataDic objectForKey:@"videoLength"]];
        _yuYinV.hidden = NO;
        _yuyinImage.image = [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"];
        _yuyinImage.frame= CGRectMake(13,15, 11, 15);
        
        int mI = [[_dataDic objectForKey:@"videoLength"] intValue];
        
        if (mI<31) {
            
          _yuyinB.frame= CGRectMake(0, 0, 102, 45);
        [_yuyinB setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_0-30.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>30 && mI<61){

             _yuyinB.frame= CGRectMake(0, 0, 136, 45);
            [_yuyinB setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_31-60.png"] forState:UIControlStateNormal];
            
        }
        else if (mI>60 && mI<91){

             _yuyinB.frame= CGRectMake(0, 0, 193, 45);
            [_yuyinB setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_61-90.png"] forState:UIControlStateNormal];
            
            
        }else{
          
             _yuyinB.frame= CGRectMake(0, 0, 241, 45);
            [_yuyinB setBackgroundImage:[UIImage imageNamed:@"btn_gtjl_luyin_91-120.png"] forState:UIControlStateNormal];
            
        }
        
        _miaoL.frame = CGRectMake(_yuyinB.frame.size.width+5, 12, 42, 21);
        
    }else{

        _yuYinV.frame =CGRectMake(0, _contentL.frame.origin.y+_contentL.frame.size.height, 0, 0);
        _yuYinV.hidden = YES;
        
    }
    
     /*  图片   */
    if ([[_dataDic objectForKey:@"pictureList"] count]) {
        
        NSArray *urlArr = [_dataDic objectForKey:@"pictureList"];
        
        if (urlArr.count==1) {
          
            
            NSDictionary *urlDic = [urlArr objectAtIndex:0];
            
            NSString *urlString = [urlDic objectForKey:@"bigUrlPath"];
            
            NSURL *url = [NSURL URLWithString:urlString];
            
            //生成图片
           UIImageView * urlImage = [[UIImageView alloc]init];
            urlImage.backgroundColor = [UIColor clearColor];
            [_picV addSubview:urlImage];
            urlImage.userInteractionEnabled = YES;
            
            UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
            urlBt.backgroundColor = [UIColor clearColor];
            urlBt.tag = 0;
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
                        //对图片大小进行压缩--
//                        image = [self imageWithImage:image scaledToSize:imagesize];
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }else{
                        
                        CGSize imagesize = image.size;
                        imagesize.width =150;
                        imagesize.height =(image.size.height *150.0)/mainFloat;
                        //对图片大小进行压缩--
//                        image = [self imageWithImage:image scaledToSize:imagesize];
                        image = [ToolList imageWithImage:image scaledToSize:imagesize];
                        
                    }
//                    image = [self cutImage:image];
                    image = [ToolList cutImage:image];
                }
                
                else{
                    
#pragma 图片小于300的时候处理
                    urlImage.contentMode = UIViewContentModeScaleAspectFill;
                    urlImage.clipsToBounds = YES;
                    [urlImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"]];
                }
            }];
            

            
            _picV.frame = CGRectMake(10, _yuYinV.frame.origin.y+_yuYinV.frame.size.height+10,150,150);
            
            urlImage.frame = CGRectMake(0, 0, _picV.frame.size.width, _picV.frame.size.height);
            urlBt.frame =CGRectMake(0, 0, urlImage.frame.size.width, urlImage.frame.size.height);
            
        }else{
            
            float imageWW = (__MainScreen_Width-26)/3.0;
            
            _picV.frame = CGRectMake(10, _yuYinV.frame.origin.y+_yuYinV.frame.size.height+10,__MainScreen_Width,(imageWW+3)*((urlArr.count-1)/3)+imageWW);

            
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
                [_picV addSubview:urlImage1];
                
                UIButton *urlBt = [UIButton buttonWithType:UIButtonTypeCustom];
                urlBt.backgroundColor = [UIColor clearColor];
                urlBt.tag = i;
                [urlBt addTarget:self action:@selector(goBigPic:) forControlEvents:UIControlEventTouchUpInside];
                urlBt.frame =CGRectMake(0,0, urlImage1.frame.size.width, urlImage1.frame.size.height);
                [urlImage1 addSubview:urlBt];
            }

        }
        
    }else{
        
           [_picV setFrame:CGRectMake(0, _yuYinV.frame.origin.y+_yuYinV.frame.size.height, 0, 0)];
    }
    
    _telL.text = [_dataDic objectForKey:@"visitType"];//标签
    _cellNameL.text = [_dataDic objectForKey:@"linkManName"];//标签联系人
       CGSize sizetype = [_cellNameL sizeThatFits:CGSizeMake( MAXFLOAT,_cellNameL.frame.size.height)];
    float typeW = sizetype.width+10 >__MainScreen_Width-13-_cellNameL.frame.origin.x?__MainScreen_Width-13-_cellNameL.frame.origin.x:sizetype.width+10;
    
    
    _cellNameL.frame = CGRectMake(_cellNameL.frame.origin.x, _cellNameL.frame.origin.y,typeW+10, _cellNameL.frame.size.height);
  
    _typeV.frame =CGRectMake(10, _picV.frame.origin.y+_picV.frame.size.height+10, __MainScreen_Width-20, 25);
    
     /*  地址  */
    
    if ([ToolList changeNull:[_dataDic objectForKey:@"visitAdd"]].length) {
        
        [ _addB setTitle:[ToolList changeNull:[_dataDic objectForKey:@"visitAdd"]] forState:UIControlStateNormal];
        CGSize size = [_addB sizeThatFits:CGSizeMake( MAXFLOAT,_addB.frame.size.height)];
        float addW = size.width +20>__MainScreen_Width-20?__MainScreen_Width-20:size.width;
        
        _addV.frame = CGRectMake(10, _typeV.frame.origin.y+_typeV.frame.size.height+5,addW+20, 25);
        
        _addB.frame =CGRectMake(20, 0 ,addW+20, 25);
        
   
        
    }else{
        
        _addV.frame = CGRectMake(0, _typeV.frame.origin.y+_typeV.frame.size.height, 0, 0);
        _addV.hidden = YES;

    }
    
    _mainV.frame =CGRectMake(0,0,__MainScreen_Width, _addV.frame.origin.y+_addV.frame.size.height+10);
    
    _recordV.frame = CGRectMake(0, __MainScreen_Height-36, __MainScreen_Width, 36);

    _handV.frame = CGRectMake(0, _mainV.frame.size.height+10,__MainScreen_Width, 36);
    _bgImage.frame =CGRectMake(0,0,__MainScreen_Width, 36);
    
    _line.frame = CGRectMake((__MainScreen_Width-0.5)/2, 4, 0.5, 28);
    
    _zanB.frame = CGRectMake(__MainScreen_Width-(__MainScreen_Width-48*2)/4-48, 0, 48, 36);
    _lunB.frame=  CGRectMake((__MainScreen_Width-48*2)/4, 0, 48, 36);

    
        [_lunB setTitle:@"评论" forState:UIControlStateNormal];

    
   
    _b1 =[[FX_Button alloc]initWithFrame:CGRectMake(13, 0, 68, 36) andType:@"2" andTitle:@"评论 0" andTarget:self andDic:nil];
    _b1.tag = 0;
    _b1.isSelect = YES;
    [_b1 changeBigAndColorCliked:_b1];
    [_handV addSubview:_b1];
    
 
    if (_isZan) {
        
       [_zanB setTitle:@"赞" forState:UIControlStateNormal];
        
        [_zanB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_zanB setImage:[UIImage imageNamed:@"icon_gtjl_zan_s.png"] forState:UIControlStateNormal];
        
        _b2 = [[FX_Button alloc]initWithFrame:CGRectMake(__MainScreen_Width-68-13, 0, 68, 36) andType:@"2" andTitle:[NSString stringWithFormat:@"赞 %d",_zanNum] andTarget:self andDic:nil];
      
        
    }else{
  
        [_zanB setTitle:@"赞" forState:UIControlStateNormal];
        [_zanB setTitleColor:[ToolList getColor:@"929292"] forState:UIControlStateNormal];
        
        [_zanB setImage:[UIImage imageNamed:@"icon_cz_zan.png"] forState:UIControlStateNormal];
        
        _b2 = [[FX_Button alloc]initWithFrame:CGRectMake(__MainScreen_Width-68-13, 0, 68, 36) andType:@"2" andTitle:[NSString stringWithFormat:@"赞 %d",_zanNum] andTarget:self andDic:nil];
       
   }
    
    _b2.tag = 1;
    [_handV addSubview:_b2];
    
    //播放时喇叭动画
    //设置动画帧
    _yuyinImage.animationImages=[NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_1.png"],
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_2.png"],
                                   [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"],
                                   nil ];
    
    //设置动画总时间
    _yuyinImage.animationDuration=1.0;
    
    //设置重复次数，0表示不重复
    _yuyinImage.animationRepeatCount=100;
    
    
}

-(void)changeBigAndColorClikedBack:(FX_Button *)bigBt{
    
    if (bigBt.tag ==0) {
       
        _b2.isSelect = NO;
        _b1.isSelect = YES;
        
        NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
        requestDic[@"logId"]= [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"logId"]];
        [FX_UrlRequestManager postByUrlStr:reply_url andPramas:requestDic andDelegate:self andSuccess:@"replySuccess:" andFaild:@"replyFild:" andIsNeedCookies:YES];
        
    }
    
   else{
       _b1.isSelect = NO;
       _b2.isSelect = YES;
       
       NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
       requestDic[@"logId"]= [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"logId"]];
       [FX_UrlRequestManager postByUrlStr:praise_url andPramas:requestDic andDelegate:self andSuccess:@"praiseSuccess:" andFaild:@"replyFild:" andIsNeedCookies:YES];
     
    }
    [_b1 changeBigAndColorCliked:_b1];
    [_b2 changeBigAndColorCliked:_b2];
    
}

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

#pragma mark --播放音频完成后的回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    //成功播放完音频后释放资源
    if ([player isPlaying]) {
        [player stop];
    }
    [_yuyinImage stopAnimating];
    
}

#pragma mark-- 播放语音
- (IBAction)bofangY:(UIButton *)sender
{

    NSString *urlPath = [_dataDic objectForKey:@"videoURL"];
    
    NSArray *array = [urlPath componentsSeparatedByString:@"/"];
    [self downloadFileURL:urlPath savePath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/cy"] fileName:[array lastObject] tag:sender.tag];
    
    _yuyinImage = (UIImageView *)[sender.superview viewWithTag:143];
    
    [_yuyinImage startAnimating];
    
}

#pragma 缓存语音

- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag  {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        NSData *audioData = [NSData dataWithContentsOfFile:fileName];
        //初始化播放
        NSError *playerError;
        
        oneAudioPlayer = nil;
        
        oneAudioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playerError];
        
        oneAudioPlayer.meteringEnabled = YES;
        oneAudioPlayer.delegate = self;
        [oneAudioPlayer play];
        
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
            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            
            //初始化播放
            NSError *playerError;
            oneAudioPlayer = nil;
            
            oneAudioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playerError];
            
            oneAudioPlayer.meteringEnabled = YES;
            oneAudioPlayer.delegate = self;
            [oneAudioPlayer play];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"下载失败 %@",error);
            
            [ToolList showRequestFaileMessageLongTime:@"语音下载失败！"];
        }];
        
        [operation start];
    }
}


#pragma 点赞
-(IBAction)goZan:(UIButton *)sender{
    
    NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
    requestDic[@"logId"]= [NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"logId"]];
    [FX_UrlRequestManager postByUrlStr:zan_url andPramas:requestDic andDelegate:self andSuccess:@"zanSuccess:" andFaild:@"replyFild:" andIsNeedCookies:YES];
    
}

#pragma 进入评论页面
-(IBAction)goRecord:(UIButton *)sender{
   
    
    if (_canDic==nil) {
        
        _canDic = [[NSMutableDictionary alloc]init];
        
    }
    [ _canDic setObject:[_dataDic objectForKey:@"logId"] forKey:@"logId"];
    [_canDic setObject:[_dataDic objectForKey:@"custId"] forKey:@"custId"];
    [_canDic setObject:@"" forKey:@"replyToPeopleId"];
    [_canDic setObject:@"" forKey:@"replyToPeopleName"];
    
    CY_writContenVc *writeV = [[CY_writContenVc alloc]initWithNibName:@"CY_writContenVc" bundle:nil andDic:_canDic andListArr:nil];
    
    [self.navigationController pushViewController:writeV animated:NO];
}

#pragma 进入回复人评论页面
-(IBAction)goRecordTo:(UIButton *)sender{
    
    NSDictionary *dicc = [_oneArr objectAtIndex:sender.tag];
    
    if (_canDic==nil) {
        
        _canDic = [[NSMutableDictionary alloc]init];
        
    }
    [ _canDic setObject:[_dataDic objectForKey:@"logId"] forKey:@"logId"];
    [_canDic setObject:[_dataDic objectForKey:@"custId"] forKey:@"custId"];
    [_canDic setObject:[dicc objectForKey:@"replyPeopleId"] forKey:@"replyToPeopleId"];
    [_canDic setObject:[dicc objectForKey:@"replyPeopleName"] forKey:@"replyToPeopleName"];
    
    CY_writContenVc *writeV = [[CY_writContenVc alloc]initWithNibName:@"CY_writContenVc" bundle:nil andDic:_canDic andListArr:nil];
    
    [self.navigationController pushViewController:writeV animated:NO];
}

#pragma 点击看大图

-(void)goBigPic:(UIButton *)bt{
    
    if (_bigUrlArr==nil) {
        
        _bigUrlArr = [[NSMutableArray alloc]init];
        
    }else{
        
        [_bigUrlArr removeAllObjects];
    }
    
    
    NSArray *arr = [_dataDic objectForKey:@"pictureList"];
    
    for (NSDictionary *dic in arr) {
        
        [_bigUrlArr addObject:[dic objectForKey:@"bigUrlPath"]];
    }
    
    CY_photoVc *bigPic = [[CY_photoVc alloc]init];
    bigPic.pArray = _bigUrlArr;
    bigPic.currentPage = bt.tag;
    
    [self.navigationController pushViewController:bigPic animated:NO];
}

-(void)zanSuccess:(NSDictionary *)sucDic{
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if ([_zanB.currentImage isEqual:[UIImage imageNamed:@"icon_gtjl_zan_s.png"]]) {//取消
            
            [_zanB setTitleColor:[ToolList getColor:@"929292"] forState:UIControlStateNormal];
            
            [_zanB setImage:[UIImage imageNamed:@"icon_cz_zan.png"] forState:UIControlStateNormal];
            
            _zanNum -= 1;
            
            [ _b2 setTitle:[NSString stringWithFormat:@"赞 %d",_zanNum] forState:UIControlStateNormal];
            
            
        }else{//点赞
            
            [_zanB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            [_zanB setImage:[UIImage imageNamed:@"icon_gtjl_zan_s.png"] forState:UIControlStateNormal];
            
            _zanNum +=1;
            [ _b2 setTitle:[NSString stringWithFormat:@"赞 %d",_zanNum] forState:UIControlStateNormal];
        }

    }
}

-(void)replySuccess:(NSDictionary *)sucDic{

    table_H = 0;
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        _oneArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
        
    }
 
    [_b1 setTitle:[NSString stringWithFormat:@"评论 %ld",_oneArr.count] forState:UIControlStateNormal];
  
    [_oneTable reloadData];
    
    _oneTable.hidden = NO;
    _twoTable.hidden = YES;
    [_mainScroll bringSubviewToFront:_oneTable];
    _oneTable.frame = CGRectMake(0, _handV.frame.origin.y+_handV.frame.size.height, __MainScreen_Width, table_H);
    _mainScroll.contentSize = CGSizeMake(__MainScreen_Width, _mainV.frame.size.height+36+_oneTable.frame.size.height+36);
    
}

#pragma 点赞列表数据结果
-(void)praiseSuccess:(NSDictionary *)sucDic{
    
    
    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        _twoArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
        
    }
    
    [_b2 setTitle:[NSString stringWithFormat:@"赞 %ld",_twoArr.count] forState:UIControlStateNormal];
  
    
    _twoTable.hidden = NO;
    _oneTable.hidden = YES;
    [_mainScroll bringSubviewToFront:_twoTable];
    [_twoTable reloadData];
    
    _twoTable.frame = CGRectMake(0, _handV.frame.origin.y+_handV.frame.size.height, __MainScreen_Width, 58*_twoArr.count);
    _mainScroll.contentSize = CGSizeMake(__MainScreen_Width, _mainV.frame.size.height+36+_twoTable.frame.size.height+36);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CY_oneCell";
    CY_oneCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell1==nil)
    {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"CY_oneCell" owner:self options:nil] lastObject];
        
    }
    
    if (tableView == _oneTable) {
        
        NSDictionary *dataDic = [_oneArr objectAtIndex:indexPath.row];
        
        cell1.picImage.layer.masksToBounds = YES;
        cell1.picImage.layer.cornerRadius = 19.0;
        
        cell1.replyPeopleNameL.text = [dataDic objectForKey:@"replyPeopleName"];
        cell1.replyTimeL.hidden = NO;
        cell1.replyContentL.hidden = NO;
        cell1.replyBt.hidden = NO;
        cell1.replyTimeL.text = [dataDic objectForKey:@"replyTime"];
        
        if ([[dataDic objectForKey:@"replyToPeopleId"]length]) {
            
            cell1.replyContentL.text = [NSString stringWithFormat:@"回复 %@：%@",[dataDic objectForKey:@"replyToPeopleName"],[dataDic objectForKey:@"replyContent"]];
        }else{
            
            cell1.replyContentL.text =[dataDic objectForKey:@"replyContent"];
        }
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = CGSizeMake(__MainScreen_Width-69,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [cell1.replyContentL.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        cell1.replyH.constant = labelsize.height+2;
        
        cell1.replyBt.tag = indexPath.row;
        
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        
       
    }
    else{
        
         NSDictionary *dataDic = [_twoArr objectAtIndex:indexPath.row];

        cell1.picImage.layer.masksToBounds = YES;
        cell1.picImage.layer.cornerRadius = 19.0;
        
        cell1.nameY.constant = 21.0f;
        cell1.replyPeopleNameL.text = [dataDic objectForKey:@"salerName"];
        cell1.replyTimeL.hidden = YES;
        cell1.replyContentL.hidden = YES;
        cell1.replyBt.hidden = YES;
    }
    
 
    
     return cell1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _oneTable) {
        
         return _oneArr.count;
    }else {
        
         return _twoArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _oneTable) {
        
        NSString *str;
        NSDictionary *dataDic = [_oneArr objectAtIndex:indexPath.row];
        if ([[dataDic objectForKey:@"replyToPeopleId"]length]) {
            
            str = [NSString stringWithFormat:@"回复 %@：%@",[dataDic objectForKey:@"replyToPeopleName"],[dataDic objectForKey:@"replyContent"]];
        }else{
            
            str =[dataDic objectForKey:@"replyContent"];
        }
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = CGSizeMake(__MainScreen_Width-69,2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        table_H += labelsize.height+2+67;
        
         return labelsize.height+2+67;
        
    }else {
        
        return 58;
    }
    
    
   return 0;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
