//
//  peiYuKuDetailViewController.h
//  SaleManagement
//
//  Created by known on 16/7/20.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface peiYuKuDetailViewController : UIViewController

{
    
    CGSize sizeHeight ;
    CGSize sizeLHeight ;

}
@property (nonatomic,strong)NSDictionary *dataDic;//培育库客户数据
@property (weak, nonatomic) IBOutlet UILabel *danHao;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UILabel *diZhiLa;
@property (weak, nonatomic) IBOutlet UILabel *fenPeiTIme;
@property (weak, nonatomic) IBOutlet UILabel *ruKuTIme;
@property (nonatomic,strong)NSArray *dataArray;//培育库释放原因

@property (weak, nonatomic) IBOutlet UIView *reasonArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@end
