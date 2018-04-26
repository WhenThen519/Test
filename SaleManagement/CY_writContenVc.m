//
//  CY_writContenVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/19.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_writContenVc.h"

@interface CY_writContenVc ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textY;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,strong)NSDictionary *dataDic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textH;


@end

@implementation CY_writContenVc

-(void)LeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)RightAction:(id)sender{
    
    
    if ([_textView.text length]) {
                
        NSMutableDictionary *requestDic =[[NSMutableDictionary alloc]init];
        requestDic[@"custId"]=[_dataDic objectForKey:@"custId"];
        requestDic[@"logId"]= [_dataDic objectForKey:@"logId"];
        requestDic[@"replyToPeopleId"]= [_dataDic objectForKey:@"replyToPeopleId"];
        requestDic[@"replyToPeopleName"]= [_dataDic objectForKey:@"replyToPeopleName"];
        requestDic[@"replyContent"]= _textView.text;
        
        [FX_UrlRequestManager postByUrlStr:toreply_url andPramas:requestDic andDelegate:self andSuccess:@"replySuccess:" andFaild:@"replyFild:" andIsNeedCookies:YES];
    }else{
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入回复内容！"];
    }
 
}

-(void)replySuccess:(NSDictionary *)sucDic{

    if ([[sucDic objectForKey:@"code"]intValue]==200) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"recordArr"] count]) {
            
            NSArray *arr = [[NSUserDefaults standardUserDefaults]objectForKey:@"recordArr"];
            NSMutableArray * recordArr = [[NSMutableArray alloc]initWithArray:arr];
            
            NSNumber *idnum = [[NSUserDefaults standardUserDefaults] objectForKey:@"recordBt_tag"];
            NSDictionary *dic = [arr objectAtIndex:[idnum intValue]];
            
            NSInteger lunNum = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"commentNum"]] integerValue];
            
            lunNum +=1;
            
            NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
            
            [mutableDic setValue:[NSNumber numberWithInt:lunNum] forKey:@"commentNum"];
            
            [recordArr replaceObjectAtIndex:[idnum intValue] withObject:mutableDic];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"recordArr"];
            
            [[NSUserDefaults standardUserDefaults]setObject:recordArr forKey:@"recordArr"];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andDic:(NSDictionary *)dic andListArr:(NSArray *)listArr{
    
    if (self == [super init]) {
        
        _dataDic = [[NSDictionary alloc]init];
        
        _dataDic = dic;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addNavgationbar:@"回复" leftBtnName:@"取消" rightBtnName:@"发送" target:self leftBtnAction:@"LeftAction:" rightBtnAction:@"RightAction:"];
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    _textY.constant = IOS7_Height;
    _textH.constant = __MainScreen_Height-IOS7_Height;
     [_textView becomeFirstResponder];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{

    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    
    if (result.length<=200) {
        
        return YES;
        
    }else{
        
        //[ToolList showInfo:@"字符个数不能大于140"];
        
        textView.text = [result substringToIndex:200];
        
        return NO;
        
    }
    
    return result.length <= 200;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
