//
//  peiYuKuDetailViewController.m
//  SaleManagement
//
//  Created by known on 16/7/20.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "peiYuKuDetailViewController.h"

@interface peiYuKuDetailViewController ()

@end

@implementation peiYuKuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _danHao.text = [_dataDic objectForKey:@"orderId"];

    _nameLa.text = [_dataDic objectForKey:@"linkManName"];
    _diZhiLa.text = [_dataDic objectForKey:@"address"];
    _fenPeiTIme.text =[_dataDic objectForKey:@"createTime"];
    _ruKuTIme.text = [_dataDic objectForKey:@"updateTime"];
    _dataArray  =_dataDic[@"reason"];
//    _dataArray = [[NSArray alloc]initWithObjects:@"123456123456734567567867qwertqwertywertwerwertertrtrtqwertwertywertyertsdf",@"123456123456734567567867asdfghjsdfghjwertyqwertqwertqwertqwertwert",@"123456123456734567567867",@"123456123456734567567867zxcvbnzxcvbndfgh", nil];
//    _dataArray = nil;

    sizeHeight.height = 0;
    sizeLHeight.height = 0;
    if (_dataArray) {
        for (int i = 0; i< _dataArray.count; i ++) {
            
            CGSize size = [_dataArray[i] boundingRectWithSize:CGSizeMake(__MainScreen_Width-96, 10000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size;
            
            size.height = ceilf(size.height)+5;
            sizeHeight.height += size.height;
//            NSLog(@"%@aa%@  i=%d",NSStringFromCGSize(size),NSStringFromCGSize(sizeHeight),i);
            
//            laebl.backgroundColor = [ToolList getColor:@"EDEDED"];
            UILabel *laebl =[[UILabel alloc]initWithFrame:CGRectMake(0, 0+sizeHeight.height-size.height+10+20*i, __MainScreen_Width-96, size.height)];
//            laebl.backgroundColor = [ToolList getColor:@"EDEDED"];
            laebl.textColor = [ToolList getColor:@"4A4A4A"];
            laebl.font = [UIFont systemFontOfSize:14];
           
            laebl.numberOfLines = 0;
            laebl.text = _dataArray[i]; 
            [_reasonArr addSubview:laebl];

            _reasonHeight.constant = (sizeHeight.height+20*i+10+10);
                   }
        if (_dataArray.count == 1) {
            
            
        }
        else
        {
            for (int j = 0; j< _dataArray.count-1; j ++) {
                CGSize size = [_dataArray[j] boundingRectWithSize:CGSizeMake(__MainScreen_Width-96, 10000) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]} context:nil].size;
                
                size.height = ceilf(size.height)+5;
                sizeLHeight.height += size.height;
                NSLog(@"%@aa%@  i=%d",NSStringFromCGSize(size),NSStringFromCGSize(sizeLHeight),j);
                
                UILabel *laebl =[[UILabel alloc]initWithFrame:CGRectMake(0, 0+sizeLHeight.height+10+20*j+10, __MainScreen_Width-96, 1)];
                laebl.backgroundColor = [ToolList getColor:@"EBEBE7"];
                [_reasonArr addSubview:laebl];
                
            }
            

        }
        
        
        
        
    }
    else
    {
        _reasonHeight.constant = 41;
    }
   
//    _bgScrollView.contentSize = CGSizeMake(__MainScreen_Width, _reasonArr.frame.origin.y+_reasonArr.frame.size.height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBT:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
