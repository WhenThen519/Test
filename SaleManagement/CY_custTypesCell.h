//
//  CY_custTypesCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/3/25.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
//胖柴888
@interface CY_custTypesCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *NameLabel;

@property(nonatomic,strong)IBOutlet UILabel *DataLabel;

@property(nonatomic,strong)IBOutlet UILabel *intentTypeLabel;

@property(nonatomic,strong)IBOutlet UIImageView *PicImage;

@property(nonatomic,strong)IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lianX;

@property(nonatomic,strong)IBOutlet UIButton *protectB;//保护
@property(nonatomic,strong)IBOutlet UIButton *lianB;//再联系
@property(nonatomic,strong)IBOutlet UIButton *releseB;//释放

@property(nonatomic,strong)IBOutlet UIButton *clearBt;//点击收缩的按钮

@end
