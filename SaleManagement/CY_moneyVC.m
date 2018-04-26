//
//  CY_moneyVC.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/11.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_moneyVC.h"
#import "Fx_TableView.h"
#import "CY_moneyCell.h"

@interface CY_moneyVC ()
{
    UIView *JFView;
    UILabel * danYueJFLabel;
    UILabel * zongJFLabel;
    UILabel * historyJFLabel;
    UILabel *countL;
}
@property (nonatomic,strong)Fx_TableView *moneyTabel;

@property (nonatomic,strong)NSMutableArray *tableArr;

@end
#define Count_h 45
#define JF_h 50
@implementation CY_moneyVC

-(void)LeftAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)initRequest{
            
    [FX_UrlRequestManager postByUrlStr:accountDetail_url andPramas:nil andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:NO];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //积分
    JFView = [[UIView alloc] initWithFrame:CGRectMake(0, IOS7_Height+Count_h, __MainScreen_Width, JF_h)];
    JFView.backgroundColor = [UIColor whiteColor
                              ];
    //单月
    
    UILabel *danL = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width/3*2, 5, __MainScreen_Width/3, JFView.frame.size.height/2)];
    danL.textAlignment = NSTextAlignmentCenter;
    danL.textColor = [ToolList getColor:@"7d7d7d"];
    danL.font = [UIFont systemFontOfSize:13];
    danL.text = @"提成业绩";
    [JFView addSubview:danL];
    danYueJFLabel = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width/3*2, JFView.frame.size.height/2, __MainScreen_Width/3, JFView.frame.size.height/2-1)];
    danYueJFLabel.textAlignment = NSTextAlignmentCenter;
    danYueJFLabel.textColor = [ToolList getColor:@"7d7d7d"];
    danYueJFLabel.font = [UIFont systemFontOfSize:13];
    [JFView addSubview:danYueJFLabel];
    //总的积分
    zongJFLabel = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width/3+25, 0, __MainScreen_Width/3, JFView.frame.size.height-1)];
    zongJFLabel.textColor = [ToolList getColor:@"ff9d00"];
    zongJFLabel.font = [UIFont systemFontOfSize:22];
    [JFView addSubview:zongJFLabel];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(zongJFLabel.frame.origin.x-24, (JFView.frame.size.height-16)/2, 16, 16)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = [UIImage imageNamed:@"jing.png"];
    [JFView addSubview:imageV];
    //历史积分
    UILabel *zongL = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, __MainScreen_Width/3, JFView.frame.size.height/2)];
    zongL.textAlignment = NSTextAlignmentCenter;
    zongL.textColor = [ToolList getColor:@"7d7d7d"];
    zongL.font = [UIFont systemFontOfSize:13];
    zongL.text = @"实提业绩";
    [JFView addSubview:zongL];
    historyJFLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, JFView.frame.size.height/2, __MainScreen_Width/3, JFView.frame.size.height/2-1)];
    historyJFLabel.textAlignment = NSTextAlignmentCenter;
    historyJFLabel.textColor = [ToolList getColor:@"7d7d7d"];
    historyJFLabel.font = [UIFont systemFontOfSize:13];
    [JFView addSubview:historyJFLabel];
    [JFView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, JF_h) toPoint:CGPointMake(__MainScreen_Width, JF_h) andWeight:0.5 andColorString:@"e7e7eb"]];
     [self addNavgationbar:@"净现金到账明细" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];
    
    [self initRequest];
    [self.view addSubview:JFView];
    countL = [[UILabel alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, Count_h)];
    countL.backgroundColor = [ToolList getColor:@"f3f4f5"];
    countL.font = [UIFont systemFontOfSize:14];
    countL.textColor = [ToolList getColor:@"7d7d7d"];
    countL.text = @"";
    [self.view addSubview:countL];
    _moneyTabel = [[Fx_TableView alloc]initWithFrame:CGRectMake(0, IOS7_Height+JF_h+Count_h, __MainScreen_Width, __MainScreen_Height-IOS7_Height-JF_h-Count_h) style:UITableViewStylePlain];
    _moneyTabel.dataSource = self;
    _moneyTabel.delegate = self;
    _moneyTabel.backgroundColor = [UIColor clearColor];
    [_moneyTabel setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_moneyTabel.refreshHeader autoRefreshWhenViewDidAppear];
    [self.view addSubview:_moneyTabel];
}

-(void)requestSuccess:(NSDictionary *)sucDic{
    
    
    [_tableArr removeAllObjects];
    
    if ([[sucDic objectForKey:@"code"] intValue]==200) {
        danYueJFLabel.text = [NSString stringWithFormat:@"%@",[sucDic objectForKey:@"saleHiredMoneys"]];
        zongJFLabel.text = [NSString stringWithFormat:@"%@",[sucDic objectForKey:@"totalAccount"]];
        historyJFLabel.text = [NSString stringWithFormat:@"%@",[sucDic objectForKey:@"relaySaleHiredMoneys"]];
        if ([[sucDic objectForKey:@"result"] count]) {
            countL.text = [NSString stringWithFormat:@"共计 %ld 条",[[sucDic objectForKey:@"result"] count]];

              _tableArr = [[NSMutableArray alloc]initWithArray:[sucDic objectForKey:@"result"]];
            
             [_moneyTabel reloadData];
            
        }else{
            countL.text = @"共计 0 条";
             [ToolList showRequestFaileMessageLittleTime:@"暂无数据"];
        }
        
        
      
    }
 

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _tableArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 109.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CY_moneyCell";
    
    CY_moneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell =[[[NSBundle mainBundle]loadNibNamed:@"CY_moneyCell" owner:self options:nil] lastObject];
        //线
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 108.5) toPoint:CGPointMake(__MainScreen_Width, 108.5) andWeight:0.5 andColorString:@"e7e7eb"]];
    }
    
    NSDictionary *dic = [_tableArr objectAtIndex:indexPath.row];
    
    cell.nameL.text = [dic objectForKey:@"custName"];
    cell.typeL.text = [NSString stringWithFormat:@"%@  |  %@",[dic objectForKey:@"orderRecordCode"],[dic objectForKey:@"productName"]];
    cell.timeL.text = [dic objectForKey:@"accountDate"];
 NSString *moneyStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"account"]];
    cell.shiti.text = [NSString stringWithFormat:@"实提 %@",[dic objectForKey:@"relaySaleHiredMoney"]];
    cell.ti.text = [NSString stringWithFormat:@"提 %@",[dic objectForKey:@"saleHiredMoney"]];
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = CGSizeMake(20000,17); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize labelsize = [moneyStr boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
   
    
    cell.moneyW.constant = labelsize.width+2;
    
    cell.moneyL.text =moneyStr;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
