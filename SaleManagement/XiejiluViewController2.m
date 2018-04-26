//
//  XiejiluViewController.m
//  SaleManagement
//
//  Created by feixiang on 16/1/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"
#import "XiejiluViewController2.h"
#import "FX_Button.h"
#import "LocationDemoViewController.h"
#include "lame.h"
#import "CY_recordVc.h"
#import "UserDetailViewController.h"
#define gongneng_h (__MainScreen_Height>568?322:215)
#define biaoqing_h 50

@interface XiejiluViewController2 ()
{
    CGFloat keyBoardEndY;
    UIView *gongnengView;
    UIScrollView *scroll;
    UIScrollView *biaoqingView;
    UIView *yuyinView;
    float image_h;
    UILabel *jianghuaL;
    UILabel *jianghuaL2;
    NSTimer *timer;
    NSString *lunyinTime;
    NSMutableArray *photoArr;
    __weak IBOutlet NSLayoutConstraint *top;
    //录音有关
    NSTimer *yinliangTimer;
    NSURL* _recordedFile;
    AVAudioRecorder *recorder;
    AVAudioSession *session;
    UIImageView *left_ImageView;
    UIImageView *right_ImageView;
    
    //播语音
    AVAudioPlayer *audioPlayer;
    //mp3地址
    NSString *pathMp3;
    //请求参数
    NSMutableDictionary *requestDic;
    //地址定位信息
    NSMutableDictionary *addDic;
    
    
}

@end

@implementation XiejiluViewController2
static int count;

#pragma mark - 完成
-(void)finish
{
    if(addDic.count)
    {
        _visitAdd = [addDic objectForKey:@"address"];
        _longitude = [addDic objectForKey:@"longitude"];
        _latitude = [addDic objectForKey:@"latitude"];
    }
    if(_voice_h.constant == 0)
    {
        pathMp3 = @"";
    }
    [requestDic setObject:_custId forKey:@"custId"];
    [requestDic setObject:_custName forKey:@"custName"];
   
    [requestDic setObject:_linkManName  forKey:@"linkManName"];
    [requestDic setObject:_visitType forKey:@"visitType"];
    [requestDic setObject:[_textView.textStorage getPlainString] forKey:@"content"];
     [requestDic setObject:_linkManId  forKey:@"contactNum"];//联系人联系号码
    [requestDic setObject:_longitude forKey:@"longitude"];
    [requestDic setObject:_visitAdd forKey:@"visitAdd"];
    [requestDic setObject:_latitude forKey:@"latitude"];
    [requestDic setObject:[NSNumber numberWithInt:count] forKey:@"videoLength"];
   NSString *str = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(str.length==0 && _voice_h.constant == 0 && photoArr.count == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"记录内容不能为空！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (_isLogId == 1) {//经理陪访或回访
        
         [requestDic setObject:_logId_1 forKey:@"logId"];
        [FX_UrlRequestManager postByUrlStr:saveCallBackLog_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:@"requestNO" andIsNeedCookies:YES andImageArray:photoArr andVoicePath:pathMp3];
    }else{
         [requestDic setObject:_linkManId  forKey:@"linkManId"];//联系人联系号码
         [requestDic setObject:_pf_SalerId  forKey:@"accompanySalerId"];//陪访商务ID
       [FX_UrlRequestManager postByUrlStr:CustVisitLog_url andPramas:requestDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:@"requestNO" andIsNeedCookies:YES andImageArray:photoArr andVoicePath:pathMp3];
    }
//
    
    
    self.btnR.userInteractionEnabled = NO;
    
}
-(void)requestNO
{
    self.btnR.userInteractionEnabled = YES;
 
}
-(void)goSomeWhere
{
    self.btnR.userInteractionEnabled = YES;

    if([_fromPage isEqualToString:@"home"])
    {
    UserDetailViewController *s = [[UserDetailViewController alloc] init];
    s.custNameStr = [requestDic objectForKey:@"custName"];
    s.custId = [requestDic objectForKey:@"custId"];
    s.flagRefresh = @"jilu";
    s.backWhere = @"home";
    [self.navigationController pushViewController:s animated:NO];
   }
    else
   {
       [self.navigationController popViewControllerAnimated:NO];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"ggg" object:nil];

   }

   
}
#pragma mark - 请求成功
-(void)requestSuccess:(NSDictionary *)dic
{

    if([[dic objectForKey:@"code"] intValue] == 200)
    {
        [ToolList showRequestFaileMessageLittleTime:@"操作成功!"];
        [self performSelector:@selector(goSomeWhere) withObject:nil afterDelay:1];
           }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
}
#pragma mark - 插入表情
-(void)insertEmoji:(UIButton *)sender {
    //Create emoji attachment
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    
    //Set tag and image
    emojiTextAttachment.emojiTag = _emojiTags[(NSUInteger) sender.tag];
    emojiTextAttachment.image = _emojiImages[(NSUInteger) sender.tag];
    
    //Set emoji size
    emojiTextAttachment.emojiSize = CGSizeMake(27, 27);
    
    //Insert emoji image
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                          atIndex:_textView.selectedRange.location];
    
    //Move selection location
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    //Reset text style
    [self resetTextStyle];
}


#pragma mark - 页面初始化
-(void)initView
{
    top.constant = IOS7_Height+10;
    //假数据
    _latitude = @"";
    _longitude = @"";
    _visitAdd = @"";
    //-----
    requestDic = [[NSMutableDictionary alloc] init];
    pathMp3 = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"Mp3File.mp3"];
    photoArr = [[NSMutableArray alloc] init];
    _address_h.constant = 0;
    _voice_h.constant = 0;
    _timeL.hidden = YES;
    [_textView becomeFirstResponder];
    _textView_h.constant = __MainScreen_Height*0.24;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithLong:6-photoArr.count] forKey:@"HaiNengXuan"];
    [[NSUserDefaults standardUserDefaults] synchronize ];
    //标题
    [self addNavgationbar:@"写记录" leftBtnName:@"上一步" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
    //功能区域
    gongnengView = [[UIView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, 46)];
    gongnengView.backgroundColor = [ToolList getColor:@"f9f9f9"];
    [gongnengView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.5 andColorString:@"e7e7eb"]];
    [gongnengView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 45.5) toPoint:CGPointMake(__MainScreen_Width, 45.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    for (int i = 0; i < 5; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gongneng%d.png",i]] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(i * (__MainScreen_Width/5), 0, __MainScreen_Width/5, 46);
        [btn addTarget:self action:@selector(gongnengCliked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [gongnengView addSubview:btn];
    }
    [self.view addSubview:gongnengView];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, gongneng_h)];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.contentSize = CGSizeMake(__MainScreen_Width*2, gongneng_h);
    biaoqingView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, __MainScreen_Height, __MainScreen_Width, biaoqing_h)];
    biaoqingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:biaoqingView];
    _emojiImages = [[NSMutableArray alloc] init];
    _emojiTags = [[NSMutableArray alloc] init];
    //表情
    for(int i = 0 ; i < 8;i++)
    {
        NSString *tag = [NSString stringWithFormat:@"[bq_%d]",i+1];
        NSString *image = [NSString stringWithFormat:@"bq_%d.png",i+1];
        [_emojiTags addObject:tag];
        [_emojiImages addObject:[UIImage imageNamed:image]];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((__MainScreen_Width/8.-30)/2+(__MainScreen_Width/8.)*i, 10, 30, 30);
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(insertEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [biaoqingView addSubview:btn];
    }
    biaoqingView.contentSize = CGSizeMake(__MainScreen_Width, biaoqing_h);
    yuyinView = [[UIView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, gongneng_h)];
    yuyinView.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((__MainScreen_Width-100)/2, (gongneng_h-100)/2, 100, 100);
    [btn setImage:[UIImage imageNamed:@"btn_edit_luyin.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_edit_luyin_ing.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(luyin) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(luyinStop) forControlEvents:UIControlEventTouchUpInside];
    [yuyinView addSubview:btn];
    jianghuaL = [[UILabel alloc] initWithFrame:CGRectMake((__MainScreen_Width - 60)/2, btn.frame.origin.y - 30, 60, 15)];
    jianghuaL.textAlignment = NSTextAlignmentCenter;
    jianghuaL.font = [UIFont systemFontOfSize:15];
    jianghuaL.text = @"按住说";
    jianghuaL.textColor = [ToolList getColor:@"999999"];
    [yuyinView addSubview:jianghuaL];
    left_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(jianghuaL.frame.origin.x-38, jianghuaL.frame.origin.y, 38, jianghuaL.frame.size.height)];
    [yuyinView addSubview:left_ImageView];
    right_ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(jianghuaL.frame.origin.x+60, jianghuaL.frame.origin.y, 38, jianghuaL.frame.size.height)];
    [yuyinView addSubview:right_ImageView];
    jianghuaL2 = [[UILabel alloc] initWithFrame:CGRectMake((__MainScreen_Width - 120)/2, btn.frame.origin.y + 100 + 15, 120, 15)];
    jianghuaL2.font = [UIFont systemFontOfSize:15];
    jianghuaL2.text = @"最长可录2分钟";
    jianghuaL2.textAlignment = NSTextAlignmentCenter;
    jianghuaL2.textColor = [ToolList getColor:@"999999"];
    [yuyinView addSubview:jianghuaL2];
    [scroll addSubview:yuyinView];
    [self.view addSubview:scroll];
    
    //
    image_h = (__MainScreen_Width-30-8)/3;
    
    _photo_h.constant = image_h*2+4;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    //初始化录音
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 8000.0],                  AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithInt: 2],                              AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityLow],                       AVEncoderAudioQualityKey,
                              nil];
    
    _recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    NSError* error;
    recorder = [[AVAudioRecorder alloc] initWithURL:_recordedFile settings:settings error:&error];
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
    
    //播放时喇叭动画
    //设置动画帧
    _labaImage.animationImages=[NSArray arrayWithObjects:
                                [UIImage imageNamed:@"icon_gtjl_yuyin_1.png"],
                                [UIImage imageNamed:@"icon_gtjl_yuyin_2.png"],
                                [UIImage imageNamed:@"icon_gtjl_yuyin_3.png"],
                                nil ];
    
    //设置动画总时间
    _labaImage.animationDuration=1.0;
    
    //设置重复次数，0表示不重复
    _labaImage.animationRepeatCount=100;
    
}
- (void)resetTextStyle {
    //After changing text selection, should reset style.
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    
    [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:wholeRange];
}
#pragma mark - 计算秒数
-(void)makeCount
{
    count ++;
    if(count < 10)
    {
        jianghuaL.text = [NSString stringWithFormat:@"0:0%d",count];
    }
    else if(count < 60 && count >= 10)
    {
        jianghuaL.text = [NSString stringWithFormat:@"0:%d",count];
    }
    else if(count < 70)
    {
        jianghuaL.text = [NSString stringWithFormat:@"1:0%d",count-60];
        
    }
    else if(count < 120 && count >= 70)
    {
        jianghuaL.text = [NSString stringWithFormat:@"1:%d",count-60];
        
    }
    else
    {
        jianghuaL.text = @"2:00";
        [timer invalidate];
    }
}
#pragma mark - 开始录音
-(void)luyin
{
    yinliangTimer = nil;
    //设置定时检测
    yinliangTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    //计时
    count = 0;
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(makeCount) userInfo:nil repeats:YES];
    session = [AVAudioSession sharedInstance];
    NSError *error1;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
    // [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:&error1];
    //创建录音文件，准备录音
    if ([recorder prepareToRecord]) {
        //开始
        [recorder record];
    }
    
    
}
#pragma mark - 监听音量
- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    if (0<lowPassResults<=0.05) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_1.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_1.png"]];
    }else if (0.05<lowPassResults<=0.01) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_2.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_2.png"]];
    }else if (0.01<lowPassResults<=0.15) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_3.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_3.png"]];
    }else if (0.15<lowPassResults<=0.2) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_4.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_4.png"]];
    }else if (0.2<lowPassResults<=0.25) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_5.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_5.png"]];
    }else if (0.25<lowPassResults<=0.3) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_6.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_6.png"]];
    }else if (0.3<lowPassResults<=0.35) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_7.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_7.png"]];
    }else if (0.35<lowPassResults<=0.4) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_8.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_8.png"]];
    }else if (0.4<lowPassResults<=0.45) {
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_9.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_9.png"]];
    }else{
        [left_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_left_10.png"]];
        [right_ImageView setImage:[UIImage imageNamed:@"icon_edit_luyin_right_10.png"]];
    }
}
#pragma mark - 停止录音
-(void)luyinStop
{
    [yinliangTimer invalidate];
    [recorder stop];
    [session setActive:NO error:nil];
    [timer invalidate];
    _timeL.hidden = NO;
    jianghuaL.text = @"按住说";
    _voice_h.constant = 45;
    if(count<60)
    {
        _timeL.text = [NSString stringWithFormat:@"0’ %d”",count];
    }
    else
    {
        _timeL.text = [NSString stringWithFormat:@"%d’ %d”",count/60,count%60];
        
    }
    [NSThread detachNewThreadSelector:@selector(toMp3) toTarget:self withObject:nil];
    left_ImageView.image = nil;
    right_ImageView.image = nil;
}
#pragma mark - 转mp3
- (void) toMp3
{
    NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
    
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"错误:%@",[exception description]);
    }
    @finally {
        [self performSelectorOnMainThread:@selector(convertMp3Finish)
                               withObject:nil
                            waitUntilDone:YES];
    }
}
-(void)convertMp3Finish
{
    NSLog(@"转好了");
}

#pragma mark - 播放语音
- (IBAction)bofangLuYin:(id)sender
{
    //初始化播放
    NSError *playerError;
    audioPlayer = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:pathMp3] error:&playerError];
    audioPlayer.meteringEnabled = YES;
    audioPlayer.delegate = self;
    [audioPlayer play];
    [_labaImage startAnimating];
}
#pragma mark - 录音完成后的回调事件
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    //录音完成后关闭释放资源
    if ([recorder isRecording]) {
        [recorder stop];
        
    }
    //录音的时候因为设置的音频会话是录音模式，所以录音完成后要把音频会话设置回听筒模式或者扬声器模式，根据切换器的值判断
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    //扬声器模式
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [audioSession setActive:YES error:nil];
    
}

#pragma mark - 录音编码出错的回调
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"录音编码出错:%@",error);
}
#pragma mark - 播放音频完成后的回调
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播完了");
    //成功播放完音频后释放资源
    if ([player isPlaying]) {
        [player stop];
    }
    [_labaImage stopAnimating];
    
}

#pragma mark - 音频播放解码出错的回调
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"音频播放解码出错：%@",error);
}

#pragma mark - 删除语音

- (IBAction)shanchuVoice:(id)sender
{
    _voice_h.constant = 0;
    _timeL.hidden = YES;
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:mp3FilePath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:mp3FilePath error:&err];
        if(err)
        {
            NSLog(@"文件删除失败：%@",err);
        }
        else
        {
            NSLog(@"文件删除成功");
            
        }
    }
}
#pragma mark - 删除地址
- (IBAction)shangchuAddress:(id)sender
{
    _address_h.constant = 0;
    _addressL.text = @"";
    
}
#pragma mark - textView 代理
- (void)textViewDidBeginEditing:(UITextView *)textView
{
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
}
#pragma mark - 点击屏幕其他地方缩键盘
-(void)tap
{
    [self.view endEditing:YES];
    gongnengView.frame = CGRectMake(0, __MainScreen_Height-46, __MainScreen_Width, 46);
    scroll.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, gongneng_h);
}
#pragma mark - 删除照片
-(void)deletePhotoImage:(UIButton *)btn
{
    UIImageView *image_D = [photoArr objectAtIndex:btn.tag];
    [image_D removeFromSuperview];
    [photoArr removeObjectAtIndex:btn.tag];
    
    for (int i = 0; i < photoArr.count; i ++)
    {
        UIImageView *imageV = [photoArr objectAtIndex:i];
        UIButton *btn = [[imageV subviews]lastObject];
        btn.tag = i;
        imageV.frame = CGRectMake((image_h+4)*(i%3), (image_h+4)*(i/3), image_h, image_h);
    }
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithLong:6-photoArr.count] forKey:@"HaiNengXuan"];
    [[NSUserDefaults standardUserDefaults] synchronize ];
}
#pragma mark - 相册选完图片回调
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    long index = photoArr.count;
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake((image_h+4)*((index+i)%3), (image_h+4)*((index+i)/3), image_h, image_h)];
        imgview.userInteractionEnabled = YES;
        UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(image_h-18,0, 18, 18)];
        deleteImageView.userInteractionEnabled = YES;
        deleteImageView.image = [UIImage imageNamed:@"btn_edit_delete.png"];
        [imgview addSubview:deleteImageView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = imgview.bounds;
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = index + i ;
        [imgview addSubview:btn];
        [btn addTarget:self action:@selector(deletePhotoImage:) forControlEvents:UIControlEventTouchUpInside];
        [photoArr addObject:imgview];
        imgview.contentMode=UIViewContentModeScaleAspectFill;
        imgview.clipsToBounds=YES;
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imgview setImage:tempImg];
            [_photo_view addSubview:imgview];
        });
    }
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithLong:6-photoArr.count] forKey:@"HaiNengXuan"];
    [[NSUserDefaults standardUserDefaults] synchronize ];
}

#pragma mark - 功能按钮选择
-(void)gongnengCliked:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            [_textView becomeFirstResponder];
            
            //表情
            gongnengView.frame = CGRectMake(0, keyBoardEndY-46-biaoqing_h, __MainScreen_Width, 46);
            [UIView animateWithDuration:0.3 animations:^{
                biaoqingView.frame = CGRectMake(0, keyBoardEndY-biaoqing_h, __MainScreen_Width, biaoqing_h);
            }];
            break;
        }
        case 1:
        {
            [_textView resignFirstResponder];
            if(6-photoArr.count<=0)
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多可传6张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [myAlertView show];
                
                return;
            }
            biaoqingView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, biaoqing_h);
            //拍照
            NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&[mediatypes count]>0){
                NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                UIImagePickerController *picker=[[UIImagePickerController alloc] init];
                picker.mediaTypes=mediatypes;
                picker.delegate=self;
                //picker.allowsEditing=YES;
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
            break;
        }
        case 2:
        {
            [_textView resignFirstResponder];
            biaoqingView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, biaoqing_h);
            if(6-photoArr.count<=0)
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多选6张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [myAlertView show];
            }
            else
            {
                //调相册
                ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                picker.maximumNumberOfSelection = 6-photoArr.count;
                
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                picker.showEmptyGroups=NO;
                picker.delegate=self;
                [self presentViewController:picker animated:YES completion:NULL];
            }
            break;
        }
        case 3:
        {
            [_textView resignFirstResponder];
            biaoqingView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, biaoqing_h);
            
            //语音
            [scroll scrollRectToVisible:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, gongneng_h) animated:NO];
            gongnengView.frame = CGRectMake(0, __MainScreen_Height-gongneng_h-46, __MainScreen_Width, 46);
            scroll.frame = CGRectMake(0, __MainScreen_Height-gongneng_h, __MainScreen_Width, gongneng_h);
            break;
        }
        case 4:
        {
            //定位
            biaoqingView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, biaoqing_h);
            [_textView resignFirstResponder];
            LocationDemoViewController *ge = [[LocationDemoViewController alloc] init];
            ge.czBlock = ^(NSMutableDictionary * dic)
            {
                addDic = dic;
                _addressL.text = [dic objectForKey:@"address"];
                _address_h.constant = 25;
                
            };
            [self.navigationController pushViewController:ge animated:NO];
            break;
        }
        default:
            break;
    }
}
#pragma mark - 拍照模块代理
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    long index = photoArr.count;
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake((image_h+4)*((index)%3), (image_h+4)*((index)/3), image_h, image_h)];
    imgview.userInteractionEnabled = YES;
    UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(image_h-18,0, 18, 18)];
    deleteImageView.userInteractionEnabled = YES;
    deleteImageView.image = [UIImage imageNamed:@"btn_edit_delete.png"];
    [imgview addSubview:deleteImageView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = imgview.bounds;
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = index ;
    [imgview addSubview:btn];
    [btn addTarget:self action:@selector(deletePhotoImage:) forControlEvents:UIControlEventTouchUpInside];
    [photoArr addObject:imgview];
    imgview.contentMode=UIViewContentModeScaleAspectFill;
    imgview.clipsToBounds=YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        imgview.image = [ToolList fixOrientation:chosenImage];
        [_photo_view addSubview:imgview];
    });
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithLong:6-photoArr.count] forKey:@"HaiNengXuan"];
    [[NSUserDefaults standardUserDefaults] synchronize ];
    
    
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}
#pragma mark - 键盘监听
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardEndY = value.CGRectValue.origin.y ;  // 得到键盘弹出后的y坐标
    gongnengView.frame = CGRectMake(0, keyBoardEndY-46, __MainScreen_Width, 46);
    
}
- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y ;  // 得到键盘弹出后的键盘视图所在y坐标
    gongnengView.frame = CGRectMake(0, keyBoardEndY-46, __MainScreen_Width, 46);
    biaoqingView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, biaoqing_h);
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    gongnengView.frame = CGRectMake(0, __MainScreen_Height-46, __MainScreen_Width, 46);
    biaoqingView.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, biaoqing_h);
    scroll.frame = CGRectMake(0, __MainScreen_Height, __MainScreen_Width, gongneng_h);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //初始化页面
    [self initView];
    
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
