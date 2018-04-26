//
//  promptVc.m
//  SaleManagement
//
//  Created by chaiyuan on 2017/3/1.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "promptVc.h"

@interface promptVc (){
    NSArray* dataArr;
    UIImageView *tapView;
    NSInteger selectedIndex;
    __weak IBOutlet NSLayoutConstraint *top;
}

@property (nonatomic,strong)NSMutableDictionary *reqestDic;

@end

@implementation promptVc

- (void)viewDidLoad {
    [super viewDidLoad];
    top.constant = IOS7_Height;
    _flagArray  = [NSMutableArray array];
    _reqestDic = [[NSMutableDictionary alloc]init];
    
    selectedIndex=-1;
    self.view.backgroundColor = [ToolList getColor:@"f3f4f5"];
    
    [self addNavgationbar:@"话术提示" leftImageName:nil rightImageName:nil target:self leftBtnAction:nil rightBtnAction:nil leftHiden:NO rightHiden:YES];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IOS7_Height+45, __MainScreen_Width, __MainScreen_Height-IOS7_Height-45) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self allrequest:@"1"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark---有网站、 无网站、营销推广
- (IBAction)doSomething:(UISegmentedControl *)sender {
    
    NSInteger Index = sender.selectedSegmentIndex;
    
    switch (Index)
    {
        case 0:
            
             [self allrequest:@"1"];
            break;
        case 1:
        
             [self allrequest:@"0"];
            break;
        case 2:
           
             [self allrequest:@"2"];
            break;
        default:
            break;
    }

}

-(void)allrequest:(NSString *)str{
    
    _reqestDic[@"type"] = str;
    
     [FX_UrlRequestManager postByUrlStr:SWspeechCraft_url andPramas:_reqestDic andDelegate:self andSuccess:@"SWspeechCraftSuccess:" andFaild:@"SWspeechCraftFild:" andIsNeedCookies:YES];
}

-(void)SWspeechCraftSuccess:(NSDictionary *)dic{
    
    [_sectionArray removeAllObjects];
    
    if ([[dic objectForKey:@"code"]intValue]==200){
        
        _sectionArray =[[NSMutableArray alloc]initWithArray:[dic objectForKey:@"result"]];
       
    }
    
    for (NSDictionary *dic in _sectionArray) {
        
          [_flagArray addObject:@"0"];
    }
    [_tableView reloadData];
}

//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionArray.count;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0.01)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString *str =[[_sectionArray objectAtIndex:section] objectForKey:@"question"];
    
    CGRect tempRect = [str   boundingRectWithSize:CGSizeMake(__MainScreen_Width-52 ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}context:nil];
    
    return tempRect.size.height+30;
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_flagArray[indexPath.section] isEqualToString:@"0"])
        return 0;
    else
    {
   
        NSString *str1 =[[_sectionArray objectAtIndex:indexPath.self.section] objectForKey:@"answer"];

        CGRect contentRect = [str1   boundingRectWithSize:CGSizeMake(__MainScreen_Width-52 ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}context:nil];
        return contentRect.size.height+41;
    }
        return 44;
}
//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
   UIView *sectionView = [[UIView alloc]init];
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionView.tag = 100 + section;
    
    UILabel *sectionLabel = [[UILabel alloc] init];
    NSString *str =[[_sectionArray objectAtIndex:section] objectForKey:@"question"];
    
    CGRect tempRect = [str   boundingRectWithSize:CGSizeMake(__MainScreen_Width-52 ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}context:nil];
    
    sectionLabel.frame = CGRectMake(22, 17,__MainScreen_Width-52 , tempRect.size.height);
    sectionLabel.textColor = [ToolList getColor:@"7d7d7d"];
    sectionLabel.text = str;
    sectionLabel.font = [UIFont systemFontOfSize:16];
    sectionLabel.userInteractionEnabled = YES;
    sectionLabel.backgroundColor = [UIColor clearColor];
    [sectionView addSubview:sectionLabel];
    
    
    UIImageView *sectionImage = [[UIImageView alloc]init];
    sectionImage.tag = section+9;
    [sectionView addSubview:sectionImage];
    
    sectionView.frame =CGRectMake(0, 0, __MainScreen_Width, sectionLabel.frame.size.height+30);
    sectionImage.frame = CGRectMake(__MainScreen_Width-30, sectionView.frame.size.height/2-15, 30, 30);
    
        sectionImage.image =[UIImage imageNamed:@"right.png"];
    
     [sectionView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.2 andColorString:@"999999"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    [sectionView addGestureRecognizer:tap];
    
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"promptVcTableViewCell";
    promptVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"promptVcTableViewCell" owner:self options:nil] lastObject];
        
    }

    NSString *str1  =[[_sectionArray objectAtIndex:indexPath.self.section] objectForKey:@"answer"];
    
     CGRect contentRect = [str1   boundingRectWithSize:CGSizeMake(__MainScreen_Width-48 ,2000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}context:nil];
    
    cell.contentL.text= str1;
    
    cell.contentH.constant = contentRect.size.height+41;
    
    cell.clipsToBounds = YES;
    
    return cell;
}

- (void)sectionClick:(UITapGestureRecognizer *)tap{
    
    NSInteger index = tap.view.tag % 100;

    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:index];
        [indexArray addObject:path];
    
    UIImage *Yimage = [UIImage imageNamed:@"right.png"];
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:index+9];

    //展开
    if ([_flagArray[index] isEqualToString:@"0"]) {
        
        if (selectedIndex == -1) {

           _flagArray[index] = @"1";
             imageView.image = [UIImage imageWithCGImage:Yimage.CGImage scale:1 orientation:UIImageOrientationRight];
            
        }else{
           
            
            if (selectedIndex != index) {
                _flagArray[selectedIndex] = @"0";
                UIView *myView = [tap.view.superview viewWithTag:selectedIndex];
                UIImageView *imageView2 = (UIImageView *)[myView viewWithTag:selectedIndex+9];
                    imageView2.image = Yimage;
            }
             _flagArray[index] = @"1";
            
          imageView.image = [UIImage imageWithCGImage:Yimage.CGImage scale:1 orientation:UIImageOrientationRight];
        }
       
       selectedIndex = index;
        
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
        
    } else { //收起
        imageView.image = Yimage;
        _flagArray[index] = @"0";
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop]; 
    }

}

@end
