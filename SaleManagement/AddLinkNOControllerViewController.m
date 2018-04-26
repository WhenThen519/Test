//
//  AddLinkNOControllerViewController.m
//  SaleManagement
//
//  Created by feixiang on 2016/11/16.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "AddLinkNOControllerViewController.h"
#import "Fx_TableView.h"
#import "AddLinkModel.h"
@interface AddLinkNOControllerViewController ()
{
    //数据列表
    Fx_TableView *table;
    NSMutableArray *dataArr;
    long deleteFlag;
}
@end

@implementation AddLinkNOControllerViewController
-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    [self addNavgationbar:@"新增联系人方式" leftBtnName:@"返回" rightBtnName:@"完成" target:self leftBtnAction:nil rightBtnAction:@"finish"];
    //添加列表
    table = [[Fx_TableView alloc] initWithFrame:CGRectMake(0, IOS7_Height, __MainScreen_Width, __MainScreen_Height-IOS7_Height) style:UITableViewStyleGrouped isNeedRefresh:NO target:self];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    dataArr = [[NSMutableArray alloc] init];
    AddLinkModel *model1 = [[AddLinkModel alloc] init];
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:@"电话:" forKey:@"name"];
    [dic1 setObject:@"" forKey:@"valueStr"];
    model1.arr = [[NSMutableArray alloc] init];
    model1.dic = dic1;
    AddLinkModel *model2 = [[AddLinkModel alloc] init];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] init];
    [dic2 setObject:@"座机:" forKey:@"name"];
    [dic2 setObject:@"" forKey:@"valueStr"];
    model2.arr = [[NSMutableArray alloc] init];
    model2.dic = dic2;
    AddLinkModel *model3 = [[AddLinkModel alloc] init];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] init];
    [dic3 setObject:@"邮箱:" forKey:@"name"];
    [dic3 setObject:@"" forKey:@"valueStr"];
    model3.arr = [[NSMutableArray alloc] init];
    model3.dic = dic3;
    [dataArr addObject:model1];
    [dataArr addObject:model2];
    [dataArr addObject:model3];
    [table reloadData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AddLinkModel *model = [dataArr objectAtIndex:section];
    return model.arr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddLinkModel *model = [dataArr objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 50)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"Addicno.png"] forState:UIControlStateNormal];
    btn.tag = section;
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn addTarget:self action:@selector(addLicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 50)];
    nameL.textColor = [ToolList getColor:@"666666"];
    nameL.font = [UIFont systemFontOfSize:16];
    nameL.text = [model.dic objectForKey:@"name"];
    [view addSubview:nameL];
    
    UITextField *valueField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, __MainScreen_Width-100, 50)];
    valueField.tag = section;
    valueField.textColor = [ToolList getColor:@"666666"];
    valueField.font = [UIFont systemFontOfSize:16];
    valueField.delegate = self;
    valueField.text = [model.dic objectForKey:@"valueStr"];
    [view addSubview:valueField];
   [view.layer addSublayer: [ToolList getLineFromPoint:CGPointMake(0, 50) toPoint:CGPointMake(__MainScreen_Width, 50) andWeight:0.2 andColorString:@"333333"]];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"AddLinkCell";
    AddLinkModel *model = [dataArr objectAtIndex:indexPath.section];
  


    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *nameL = nil;
    UITextField *valueField = nil;
    if(cell==nil)
    {
       cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 50)];
        cell.frame = CGRectMake(0, 0, __MainScreen_Width, 50);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"Removeicno.png"] forState:UIControlStateNormal];
        btn.tag = 100*(indexPath.section+1)+indexPath.row;
        btn.frame = CGRectMake(0, 0, 50, 50);
        [btn addTarget:self action:@selector(deleteLicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 50)];
        nameL.textColor = [ToolList getColor:@"999999"];
        nameL.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameL];
        
        valueField = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, __MainScreen_Width-100, 50)];
        valueField.tag = 100*(indexPath.section+1)+indexPath.row;
        valueField.delegate = self;
        valueField.textColor = [ToolList getColor:@"999999"];
        valueField.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:valueField];
        [cell.contentView.layer addSublayer: [ToolList getLineFromPoint:CGPointMake(0, 50) toPoint:CGPointMake(__MainScreen_Width, 50) andWeight:0.2 andColorString:@"666666"]];

   }
    
    AddLinkModel *model1 = [model.arr objectAtIndex:indexPath.row];
    nameL.text = [model1.dic objectForKey:@"name"];
    valueField.text = [model1.dic objectForKey:@"valueStr"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
#pragma mark - textField代理

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    //及时的正则表达式
//    NSLog(@"编辑了%ld",textField.tag);
//    
//    long a = textField.tag<100?textField.tag:textField.tag/100-1;
//    switch (a)
//    {
//            //验证手机
//        case 0:
//        {
//            if (!wiNSStringIsValidPhone(textField.text))
//            {
//                
//                [ToolList showRequestFaileMessageLittleTime:@"电话有误，请重新输入"];
//                return;
//            }
//        }
//            break;
//            //验证座机
//        case 1:
//        {
//            if (!wiNSStringIsValidZJ(textField.text))
//            {
//                
//                [ToolList showRequestFaileMessageLittleTime:@"座机有误，请重新输入"];
//                return;
//            }
//        }
//            break;
//            //验证邮箱
//        case 2:
//        {
//            if (!wiNSStringIsValidEmail(YES, textField.text))
//            {
//                
//                [ToolList showRequestFaileMessageLittleTime:@"邮箱有误，请重新输入"];
//                return;
//            }
//        }
//            break;
//        default:
//            break;
//    }
    if(textField.tag < 100)
    {
    AddLinkModel *model = [dataArr objectAtIndex:textField.tag];
    [model.dic setObject:textField.text forKey:@"valueStr"];
    }
    else
    {
  
        if(deleteFlag!=textField.tag)
        {
            AddLinkModel *model = [dataArr objectAtIndex:textField.tag/100-1];
            AddLinkModel *model2 = [model.arr objectAtIndex:textField.tag%100]  ;
             [model2.dic setObject:textField.text forKey:@"valueStr"];
        }

    }
}
#pragma mark - 减少项
-(void)deleteLicked:(UIButton *)btn
{
    NSLog(@"减少%ld",btn.tag);
    deleteFlag = btn.tag;
    AddLinkModel *model = [dataArr objectAtIndex:btn.tag/100-1];
    [model.arr removeObjectAtIndex:btn.tag%100];
    [table reloadData];
}
#pragma mark - 添加项
-(void)addLicked:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
    AddLinkModel *model = [dataArr objectAtIndex:btn.tag];
    AddLinkModel *model1;
    NSMutableDictionary *dic1;
    switch (btn.tag) {
        case 0:
        {
            model1 = [[AddLinkModel alloc] init];
            dic1 = [[NSMutableDictionary alloc] init];
            [dic1 setObject:@"电话:" forKey:@"name"];
            [dic1 setObject:@"" forKey:@"valueStr"];
        }
            break;

            case 1:
        {
            model1 = [[AddLinkModel alloc] init];
            dic1 = [[NSMutableDictionary alloc] init];
            [dic1 setObject:@"座机:" forKey:@"name"];
            [dic1 setObject:@"" forKey:@"valueStr"];
        }
            break;

            case 2:
        {
            model1 = [[AddLinkModel alloc] init];
            dic1 = [[NSMutableDictionary alloc] init];
            [dic1 setObject:@"邮箱:" forKey:@"name"];
            [dic1 setObject:@"" forKey:@"valueStr"];
        }
            break;
            
        default:
            break;

    }
    model1.dic = dic1;
    [model.arr addObject:model1];
    [table reloadData];
}
#pragma mark - 完成-提交

-(void)finish
{
    [self.view endEditing:YES];
    AddLinkModel *dianhuaModel = [dataArr objectAtIndex:0];
    NSString *dianhuaModelStr = [dianhuaModel.dic objectForKey:@"valueStr"];
    AddLinkModel *zuojiModel = [dataArr objectAtIndex:1];
    NSString *zuojiModelStr = [zuojiModel.dic objectForKey:@"valueStr"];
    AddLinkModel *mailModel = [dataArr objectAtIndex:2];
    NSString *mailModelStr = [mailModel.dic objectForKey:@"valueStr"];
    
    NSMutableString *shoujiStr = [[NSMutableString alloc] init];
    NSMutableString *zuojiStr = [[NSMutableString alloc] init];
    NSMutableString *mailStr = [[NSMutableString alloc] init];

    
    if(dianhuaModel.arr.count == 0 && dianhuaModelStr.length == 0 && zuojiModel.arr.count == 0 && zuojiModelStr.length == 0 && mailModel.arr.count == 0 && mailModelStr.length == 0)
    {
        [ToolList showRequestFaileMessageLittleTime:@"信息不完整，请重新输入"];
        return;
    }
    else
    {
        if(dianhuaModelStr.length)
        {
            if(!wiNSStringIsValidPhone(dianhuaModelStr))
            {
                [ToolList showRequestFaileMessageLittleTime:@"电话有误，请重新输入"];
                return;
            }
            else
            {
                [shoujiStr appendString:[dianhuaModel.dic objectForKey:@"valueStr"]];
   
            }
        }
        if(dianhuaModel.arr.count!=0)
        {
            for (AddLinkModel *subModel in dianhuaModel.arr) {
                if(!wiNSStringIsValidPhone([subModel.dic objectForKey:@"valueStr"]))
                {
                    [ToolList showRequestFaileMessageLittleTime:@"电话有误，请重新输入"];
                    return;
                }
                else
                {
                    [shoujiStr appendString:[NSString stringWithFormat:@",%@",[subModel.dic objectForKey:@"valueStr"]]];
                }
                
            }
        }
        if(zuojiModelStr.length)
        {
            if(!wiNSStringIsValidZJ(zuojiModelStr))
            {
                [ToolList showRequestFaileMessageLittleTime:@"座机有误，请输入区号座机号码"];
                return;
            }
            else
            {
                [zuojiStr appendString:zuojiModelStr];
    
            }
        }
        if(zuojiModel.arr.count!=0)
        {
            for (AddLinkModel *subModel in zuojiModel.arr) {
                if(!wiNSStringIsValidZJ([subModel.dic objectForKey:@"valueStr"]))
                {
                    [ToolList showRequestFaileMessageLittleTime:@"座机有误，请输入区号座机号码"];
                    return;
                }
                else
                {
                  [zuojiStr appendString:[NSString stringWithFormat:@",%@",[subModel.dic objectForKey:@"valueStr"]]];
                }
                
            }
        }
        if(mailModelStr.length)
        {
            if(!wiNSStringIsValidEmail(YES,mailModelStr))
            {
                [ToolList showRequestFaileMessageLittleTime:@"邮箱有误，请重新输入"];
                return;
            }
            else
            {
                [mailStr appendString:mailModelStr];
            }
        }
        if(mailModel.arr.count!=0)
        {
            for (AddLinkModel *subModel in mailModel.arr) {
                if(!wiNSStringIsValidEmail(YES, [subModel.dic objectForKey:@"valueStr"]))
                {
                    [ToolList showRequestFaileMessageLittleTime:@"邮箱有误，请重新输入"];
                    return;
                }
                else
                {
                    [mailStr appendString:[NSString stringWithFormat:@",%@",[subModel.dic objectForKey:@"valueStr"]]];
                }
                
            }
        }

    }
   
  
    NSLog(@"手机号：%@",shoujiStr);
    
   
    NSLog(@"座机号：%@",zuojiStr);
    
   
    NSLog(@"邮箱号：%@",mailStr);
    NSMutableDictionary *requDic = [[NSMutableDictionary alloc] init];
    [requDic setObject:shoujiStr forKey:@"mobilephone"];
    [requDic setObject:mailStr forKey:@"email"];
    [requDic setObject:zuojiStr forKey:@"telephone"];
    [requDic setObject:_linkManId forKey:@"linkManId"];

     [FX_UrlRequestManager postByUrlStr:AddContactInfo_url andPramas:requDic andDelegate:self andSuccess:@"requestSuccess:" andFaild:nil andIsNeedCookies:YES];
    //验证自己添加的邮箱和手机是否重复
}
#pragma mark - 添加成功
-(void)requestSuccess:(NSDictionary *)resultDic

{
    NSLog(@"添加成功");
    NSMutableDictionary *requDic = [[NSMutableDictionary alloc] init];
    
    [requDic setObject:_linkManId forKey:@"linkManId"];
    
    [FX_UrlRequestManager postByUrlStr:getLinkManDetail_url andPramas:requDic andDelegate:self andSuccess:@"getDataSuccess:" andFaild:nil andIsNeedCookies:YES];
}
#pragma mark - 拿到最新数据成功
-(void)getDataSuccess:(NSDictionary *)resultDic
{
    NSDictionary *dic = [[resultDic objectForKey:@"result"] lastObject];
    self.czDicBlock(dic);
    [self.navigationController popViewControllerAnimated:NO];
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
