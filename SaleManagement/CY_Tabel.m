//
//  CY_Tabel.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/22.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_Tabel.h"
#import "CY_popupV.h"

enum Devices{
    
    down_ShowType = 0, //可点击状态
    protect_ShowType , //保护状态
    collect_down_ShowType,  //收藏状态
    up_ShowType,  //bu可点击状态
    yxprotect_ShowType //意向保护状态
};

@interface CY_Tabel (){

 enum Devices show_TYPE;
    
}


@end

@implementation CY_Tabel

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _custArr =[[NSMutableArray alloc]init];
     _arr = [[NSArray alloc]init];

    _openIndexC = -1;
    
    _siTypeArr = [[NSMutableArray alloc]init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_openIndexC == indexPath.row){
        
        return 122.0f;
        
    }else{
        
        return 85.0f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SeaListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
#pragma 公司名称
        UILabel  *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, __MainScreen_Width-45, 16)];
        nameLabel.tag = 1009;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [ToolList getColor:@"333333"];
        [cell.contentView addSubview:nameLabel];
        
#pragma 公司地址
        UILabel * addLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height+15, nameLabel.frame.size.width, 14)];
        addLabel.font = [UIFont systemFontOfSize:14];
        addLabel.tag = 1008;
        [addLabel setTextColor:[ToolList getColor:@"999999"]];
        [cell.contentView addSubview:addLabel];
        
#pragma 表格状态（保护、收藏、可操作）
        UIButton *iconImage =[UIButton buttonWithType:UIButtonTypeCustom];
        iconImage.frame =CGRectMake(__MainScreen_Width-26, 36, 13, 13);
        iconImage.backgroundColor = [UIColor clearColor];
        iconImage.tag = 124;
        [cell.contentView addSubview:iconImage];
        
        //推荐标识
        UIImageView *tImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [tImage setImage:[UIImage imageNamed:@"icon_list-recommend.png"]];
        tImage.tag = 1807;
        tImage.hidden = YES;
        tImage.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:tImage];
        
#pragma 操作界面（收藏、保护）
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, __MainScreen_Width, 37)];
        bgView.hidden = YES;
        bgView.tag = 110;
        [cell.contentView addSubview:bgView];
        
        //线
        [bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(__MainScreen_Width, 0) andWeight:0.1 andColorString:@"999999"]];
        
        
    }
    
    
    UILabel *nameL = (UILabel*)[cell.contentView viewWithTag:1009];
    nameL.text = [[_arr objectAtIndex:indexPath.row]objectForKey:@"custName"];
    UILabel *addL = (UILabel*)[cell.contentView viewWithTag:1008];
    addL.text = [[_arr objectAtIndex:indexPath.row]objectForKey:@"marketName"];
    
    UIButton *btL = (UIButton*)[cell.contentView viewWithTag:124];
    NSNumber *num = [_siTypeArr objectAtIndex:indexPath.row];
    
    [self showType:btL andTag:[num integerValue]];
    
    UIView *bgView =(UIView*)[cell.contentView viewWithTag:110];
    
    NSString *operateStr = [[_arr objectAtIndex:indexPath.row]objectForKey:@"operate"];
    
    [self operateTypes:operateStr andView:bgView angTag:indexPath.row];
    
    return cell;
    
}

-(void)showType:(UIButton *)sender andTag:(NSInteger)tag{
    
    switch (tag) {
        case 0:
        {
            [sender setImage:[UIImage imageNamed:@"btn_list_down.png"] forState:UIControlStateNormal];
        }
            break;
            
        case 1:
        {
            [sender setImage:[UIImage imageNamed:@"icon_list_protect_s.png"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [sender setImage:[UIImage imageNamed:@"icon_list_collect_s.png"] forState:UIControlStateNormal];
        }
            break;
            
        case 3:
        {
            [sender setImage:[UIImage imageNamed:@"btn_list_up.png"] forState:UIControlStateNormal];
        }
            break;
            
        case 4:
        {
            [sender setImage:[UIImage imageNamed:@"icon_list_protect_s.png"] forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSString *operateStr = [[_arr objectAtIndex:indexPath.row]objectForKey:@"operate"];

    //you操作的时候
    if (operateStr.intValue != 0) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIButton *imageV=(UIButton *)[cell.contentView viewWithTag:124];
        
        UIView *ve=(UIView *)[cell.contentView viewWithTag:110];
        
        
        if (_openIndexC == indexPath.row ) {
            
            _openIndexC = -1;
            
            if (show_TYPE==1) {//保护
                
                [_siTypeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
                
                [imageV setImage:[UIImage imageNamed:@"icon_list_protect_s.png" ]forState:UIControlStateNormal];
                cell.userInteractionEnabled = NO;
                
            }
            else if (show_TYPE==2){//收藏
                
                [_siTypeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:2]];
                
                [imageV setImage:[UIImage imageNamed:@"icon_list_collect_s.png" ]forState:UIControlStateNormal];
                cell.userInteractionEnabled = NO;
            }
            else{
                
                [_siTypeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
                cell.userInteractionEnabled = YES;
            }
            ve.hidden = YES;
            
            
        }else{
            
            show_TYPE=0;
            
            // 点击第二次的时候把第一次的状态收起
            
            
            if (_openIndexC==-1) {
                
                [_siTypeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:3]];
                _openIndexC = indexPath.row;
                ve.hidden = NO;
                
            }else{
                
                NSIndexPath *ppp = [NSIndexPath indexPathForRow:_openIndexC inSection:0];
                UITableViewCell *oldcell = [tableView cellForRowAtIndexPath:ppp];
                
                UIView *oldve=(UIView *)[oldcell.contentView viewWithTag:110];
                
                oldve.hidden = YES;
                [_siTypeArr replaceObjectAtIndex:_openIndexC withObject:[NSNumber numberWithInt:0]];
                [_siTypeArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:3]];
                
                _openIndexC = indexPath.row;
                
                ve.hidden = NO;
            }
            
            
        }
        
        [self.tableView reloadData];
        
  
    }
    
    
}


-(void)operateTypes:(NSString *)operateStr andView:(UIView *)bgView angTag:(NSInteger)indexRow{
    
    
    NSArray *typeArr = [operateStr componentsSeparatedByString:@","];

    if (typeArr.count==2) {
        
        int s1 = [[typeArr objectAtIndex:0] intValue];
        int s2 =[[typeArr objectAtIndex:1] intValue];
        
        UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
        bt1.tag = indexRow;
        bt1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        bt1.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        [bt1 setTitleColor:[ToolList getColor:@"929292"] forState:UIControlStateNormal];
        [bt1 setImage:[UIImage imageNamed:@"icon_list_protect.png"] forState:UIControlStateNormal];
        bt1.titleLabel.font = [UIFont systemFontOfSize:14];
        bt1.frame = CGRectMake(0, 0, __MainScreen_Width/2, bgView.frame.size.height);

        [bgView addSubview:bt1];
        
        [bgView.layer addSublayer:[ToolList getLineFromPoint:CGPointMake(__MainScreen_Width/2.-1, 8) toPoint:CGPointMake(__MainScreen_Width/2.-1, bt1.frame.size.height-8) andWeight:0.1 andColorString:@"999999"]];
        
        UIButton *bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [bt2 setImage:[UIImage imageNamed:@"icon_list_collect.png"] forState:UIControlStateNormal];

        bt2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
        bt2.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
        [bt2 setTitleColor:[ToolList getColor:@"929292"] forState:UIControlStateNormal];
        bt2.titleLabel.font = [UIFont systemFontOfSize:14];
        bt2.tag = indexRow ;
        bt2.frame = CGRectMake( __MainScreen_Width/2, 0, __MainScreen_Width/2, bgView.frame.size.height);
        [bgView addSubview:bt2];
        
        if (s1==2&&s2==3) {//(保护\查看)
            [bt1 setTitle:@"保护" forState:UIControlStateNormal];
            [bt1 addTarget:self action:@selector( protectT:) forControlEvents:UIControlEventTouchUpInside];
            [bt2 setTitle:@"查看" forState:UIControlStateNormal];
           [bt2 addTarget:self action:@selector(goSee:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (s1==3&&s2==4){//(查看\意向保护)
           
            [bt2 setTitle:@"保护" forState:UIControlStateNormal];
            [bt2 addTarget:self action:@selector( yxProtectT:) forControlEvents:UIControlEventTouchUpInside];
            
            [bt1 setTitle:@"查看" forState:UIControlStateNormal];
            [bt1 addTarget:self action:@selector(goSee:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        else{//1\2(收藏、保护)
            [bt1 setTitle:@"收藏" forState:UIControlStateNormal];
            [bt1 addTarget:self action:@selector(collectT:) forControlEvents:UIControlEventTouchUpInside];
            
            [bt2 setTitle:@"保护" forState:UIControlStateNormal];
            [bt2 addTarget:self action:@selector(collectT:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }else {
        
        if ([operateStr intValue]!=0) {
            
            UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
            bt1.tag = indexRow;
            bt1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6);
            bt1.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 0);
            [bt1 setTitleColor:[ToolList getColor:@"929292"] forState:UIControlStateNormal];
            [bt1 setImage:[UIImage imageNamed:@"icon_list_protect.png"] forState:UIControlStateNormal];
            bt1.titleLabel.font = [UIFont systemFontOfSize:14];
            bt1.frame = CGRectMake(0, 0, __MainScreen_Width, bgView.frame.size.height);

            [bgView addSubview:bt1];
            
            switch ([operateStr intValue]) {
                    
                case 2://保护
                {
                     [bt1 setTitle:@"保护" forState:UIControlStateNormal];
                    [bt1 addTarget:self action:@selector( protectT:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                case 3://查看
                {
                    [bt1 setTitle:@"查看" forState:UIControlStateNormal];
                     [bt1 addTarget:self action:@selector(goSee:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                case 4://意向保护
                {
                    [bt1 setTitle:@"保护" forState:UIControlStateNormal];
                    [bt1 addTarget:self action:@selector(yxProtectT:) forControlEvents:UIControlEventTouchUpInside];
                }
                    break;
                    
                default:
                    break;
            }
  
        }
    }
}





-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark--点击查看按钮
-(void)goSee:(UIButton *)bt{
   
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GOUSERVIEW" object:[_arr objectAtIndex:bt.tag]];
    
}
#pragma mark--点击意向保护按钮
-(void)yxProtectT:(UIButton *)IDsender{
    //
    show_TYPE = 4;
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    dataDic[@"custId"]=[[_arr objectAtIndex:IDsender.tag] objectForKey:@"custId"];
    dataDic[@"intentCustId"]= self.SintentCustId;
    [FX_UrlRequestManager postByUrlStr:protectIntentCustAndExist_url andPramas:dataDic andDelegate:self andSuccess:@"protectIntentCustAndExistSuccess:" andFaild:nil andIsNeedCookies:YES];
}

#pragma mark--点击保护按钮
-(void)protectT:(UIButton *)IDsender{
    
    //    isSelect = YES;
    show_TYPE = 1;
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    dataDic[@"custId"]=[[_arr objectAtIndex:IDsender.tag] objectForKey:@"custId"];
    
    [FX_UrlRequestManager postByUrlStr:protectCustomer_url andPramas:dataDic andDelegate:self andSuccess:@"swprotectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
    
}
#pragma mark -- 意向客户保护成功
-(void)protectIntentCustAndExistSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"]intValue ]==200) {
        
        CY_popupV *popuV = [[CY_popupV alloc]initWithFrame:CGRectMake(0, 0, 0, 0) andyixiangTitle:@"dhidh" andtarget:self];
        
        [self.view addSubview:popuV];
        
    }
}


//去意向
-(void)closeClickButton{
    
   [[NSNotificationCenter defaultCenter]postNotificationName:@"GOYXVIEW" object:@"意向客户"];
    
}

//回我的客户
-(void)goMyButton{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"GOYXVIEW" object:@"我的客户"];
}

-(void)swprotectCustomerSuccess:(NSDictionary *)dic{
    
    if ([[dic objectForKey:@"code"]intValue ]==200) {
        
       NSString *custId = [[_arr objectAtIndex:_openIndexC] objectForKey:@"custId"];
        NSString *custName =[[_arr objectAtIndex:_openIndexC] objectForKey:@"custName"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:custId,@"custId",custName,@"custName", nil];
        
        [_custArr addObject:dic];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"YANZHENGOK" object:dic];
        
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_openIndexC inSection:0]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GOADDDVIEW" object:nil];
    }
}

#pragma mark--点击收藏按钮
-(void)collectT:(UIButton *)sender{
    
    
    show_TYPE = 2;
    
    if ([sender.titleLabel.text isEqualToString:@"收藏"]){
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        dataDic[@"custId"]=[[_arr objectAtIndex:sender.tag] objectForKey:@"custId"];
       
        dataDic[@"custType"]=@"1";
        [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dataDic andDelegate:self andSuccess:@"swprotectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
    }
    
    else if ([sender.titleLabel.text isEqualToString:@"保护"]){
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        
        dataDic[@"custId"]=[[_arr objectAtIndex:sender.tag] objectForKey:@"custId"];
        dataDic[@"custType"]=@"2";
        [FX_UrlRequestManager postByUrlStr:getCust_url andPramas:dataDic andDelegate:self andSuccess:@"swprotectCustomerSuccess:" andFaild:nil andIsNeedCookies:YES];
    }

    
//    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_openIndexC inSection:0]];
    
}

@end
