//
//  CY_oneCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/19.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CY_oneCell : UITableViewCell

@property (nonatomic ,weak)IBOutlet UILabel *replyPeopleNameL;

@property (nonatomic ,weak)IBOutlet UILabel *replyContentL;

@property (nonatomic ,weak)IBOutlet UILabel *replyTimeL;

@property (nonatomic ,weak)IBOutlet UIButton *replyBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyH;

@property (weak,nonatomic) IBOutlet UIImageView *picImage;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameY;


@end
