//
//  PFSelectViewController.m
//  SaleManagement
//
//  Created by cat on 2017/9/4.
//  Copyright © 2017年 cn.300.cn. All rights reserved.
//

#import "PFSelectViewController.h"
#import "PF_TableViewCell.h"

@interface PFSelectViewController (){
    
    NSInteger selectedIndex;
    NSIndexPath *selectPath;
    __weak IBOutlet NSLayoutConstraint *top;
}

@property (nonatomic,strong)IBOutlet UITableView *PF_tableView;

@property (nonatomic,strong)NSMutableArray *sectionArray;
@property (nonatomic,strong)NSMutableArray *flagArray;

@end

@implementation PFSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    top.constant = IOS7_Height + 5;
    selectedIndex = -1;
    selectPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    //标题
    [self addNavgationbar:@"选择陪访人" leftBtnName:nil rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"next_view"];
     [self makeData];
    
}
#pragma mark---完成
-(void)next_view{
    
    if (selectPath.section!=-1 && selectPath.row != -1) {
        NSDictionary *arr = _sectionArray[selectPath.section];
        NSArray *nameArr = [arr objectForKey:@"deptEmp"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:nameArr[selectPath.row]];
        [ dic setObject:[arr objectForKey:@"deptName"] forKey:@"deptName"];
         [ dic setObject:[arr objectForKey:@"deptId"] forKey:@"deptId"];
        
        self.pf_Block(dic);
    }else{
        self.pf_Block(nil);
    }
   
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  处理数据  _sectionArray里面存储数组
 */
- (void)makeData{
  
    _flagArray  = [NSMutableArray array];
    
    [FX_UrlRequestManager postByUrlStr:deptList_url andPramas:nil andDelegate:self andSuccess:@"deptListSuccess:" andFaild:nil andIsNeedCookies:NO];

}

-(void)deptListSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"] intValue] == 200) {
        if (_sectionArray.count) {
            [_flagArray removeAllObjects];
            [_sectionArray removeAllObjects];
            
        }
        _sectionArray = [[NSMutableArray alloc]initWithArray: [dic objectForKey:@"result"]];
       
        if (_sectionArray.count) {

            
                for (NSDictionary *dicc in _sectionArray) {
                    
                    if (_sectionArray.count == 1) {
                        
                        NSArray *deptArr = [dicc objectForKey:@"deptEmp"];
                        if (deptArr.count ==1) {
                            [_flagArray addObject:@"1"];
                            break;
                        }
                    }else{
                         [_flagArray addObject:@"0"];
                       
                    }
                }
            
        }else{
            
              [ToolList showRequestFaileMessageLittleTime:@"未搜索到陪访人"];
              }
            _table_Height.constant = __MainScreen_Height-104;
            
            [_PF_tableView reloadData];
              
        if (_flagArray.count==1) {
             NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                [self tableView:_PF_tableView didSelectRowAtIndexPath:path];
        }
        
    }
}
//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sectionArray.count;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *arr = _sectionArray[section];
    NSArray *countArr = [arr objectForKey:@"deptEmp"];
    return countArr.count;
}
//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_flagArray[indexPath.section] isEqualToString:@"0"])
        return 0;
    else
        return 44;
}
//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     NSDictionary *arr = _sectionArray[section];
        UIView *sectionView = [[UIView alloc]init];
        sectionView.backgroundColor = [UIColor whiteColor];
        sectionView.tag = 100 + section;
        
        UILabel *sectionLabel = [[UILabel alloc] init];
        NSString *str =[NSString stringWithFormat:@"%@",[arr objectForKey:@"deptName"]];
        sectionLabel.frame = CGRectMake(14, 0,__MainScreen_Width-52 , 44);
        sectionLabel.textColor = [ToolList getColor:@"7d7d7d"];
        sectionLabel.text = str;
        sectionLabel.font = [UIFont systemFontOfSize:14];
        sectionLabel.userInteractionEnabled = YES;
        sectionLabel.backgroundColor = [UIColor clearColor];
        [sectionView addSubview:sectionLabel];
        
        
        UIImageView *sectionImage = [[UIImageView alloc]init];
        sectionImage.tag = section+9;
        sectionImage.backgroundColor = [UIColor clearColor];
        [sectionView addSubview:sectionImage];
        
        sectionView.frame =CGRectMake(0, 0, __MainScreen_Width, 44);
        sectionImage.frame = CGRectMake(__MainScreen_Width-30, sectionView.frame.size.height/2-15, 30, 30);
        
        sectionImage.image =[UIImage imageNamed:@"right.png"];
        
        [sectionView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.2 andColorString:@"999999"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionClick:)];
    
        if([[arr objectForKey:@"deptEmp"]count]){
          [sectionView addGestureRecognizer:tap];
        }
        return sectionView;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"PF_TableViewCell";
    PF_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PF_TableViewCell" owner:self options:nil] lastObject];
        
        [cell.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.2 andColorString:@"999999"]];
        
    }
     NSDictionary *arr = _sectionArray[indexPath.section];
    NSArray *nameArr = [arr objectForKey:@"deptEmp"];
    NSDictionary *dic = nameArr[indexPath.row];
    cell.nameLabel.text= [dic objectForKey:@"salerName"];
//    cell.clipsToBounds = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectPath.row == -1 && selectPath.section == -1) {
        
        selectPath = indexPath;
        
    }else if (selectPath == indexPath){
        return;
    }else{
      
        PF_TableViewCell *cell_1 = [_PF_tableView cellForRowAtIndexPath:selectPath];
        cell_1.nameImage.hidden = YES;
        cell_1.nameLabel.textColor = [ToolList getColor:@"666666"];
        
         selectPath = indexPath;
    }
    
    PF_TableViewCell *cell = [_PF_tableView cellForRowAtIndexPath:indexPath];
    cell.nameImage.hidden = NO;
    cell.nameLabel.textColor = [ToolList getColor:@"ba81ff"];
    
    
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
        
        [_PF_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
        
    } else { //收起
        imageView.image = Yimage;
        _flagArray[index] = @"0";
        [_PF_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
    }

}

#pragma mark - textField代理
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    
    if(theTextField.text.length==0){
        
        [ToolList showRequestFaileMessageLittleTime:@"请输入搜索内容"];
        return YES;
    }
        
    NSMutableDictionary *request_dic =[[NSMutableDictionary alloc]init];
    request_dic[@"searchName"]=theTextField.text;
      [FX_UrlRequestManager postByUrlStr:accompanySalerSearch_url andPramas:request_dic andDelegate:self andSuccess:@"deptListSuccess:" andFaild:nil andIsNeedCookies:YES];

    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
