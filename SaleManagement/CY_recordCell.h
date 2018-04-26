//
//  CY_recordCell.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/8.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CY_recordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *comBT;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UITextView *contentL;

@property (weak, nonatomic) IBOutlet UILabel *typeL;

@property (weak, nonatomic) IBOutlet UILabel *typeNameL;

@property (weak, nonatomic) IBOutlet UIButton *addL;

@property(nonatomic,weak)IBOutlet UIView *ImageV;//图片

@property (nonatomic,weak) IBOutlet UIImageView *imageAndB;//语音图片

@property (nonatomic,weak)IBOutlet UILabel *miaoL;
@property (nonatomic,weak)IBOutlet UIView *yuYinV;

@property (weak, nonatomic) IBOutlet UIView *typeV;

@property (weak, nonatomic) IBOutlet UIView *addV;


@property (weak, nonatomic) IBOutlet UIButton *yuYinBt;

@property (weak, nonatomic) IBOutlet UIButton *lunB;
@property (weak, nonatomic) IBOutlet UIButton *zanBt;

@property (weak, nonatomic) IBOutlet UIView *touchV;

@property (weak, nonatomic) IBOutlet UIImageView *line;

@property (weak, nonatomic) IBOutlet UIView *mainV;

@property (weak,nonatomic)IBOutlet UIImageView *touImage;

@property (weak,nonatomic)IBOutlet UILabel *linel;

@property (weak,nonatomic)IBOutlet UIImageView *litleImage;

@property (weak, nonatomic) IBOutlet UIView *huifangView;
@property (weak, nonatomic) IBOutlet UIImageView *touImage1;
@property (weak, nonatomic) IBOutlet UILabel *nameL1;
@property (weak, nonatomic) IBOutlet UILabel *timeL1;
@property (weak, nonatomic) IBOutlet UITextView *contentL1;

@property (weak, nonatomic) IBOutlet UIView *yuYinV1;

@property (weak, nonatomic) IBOutlet UIButton *yuYinBt1;
@property (weak, nonatomic) IBOutlet UIImageView *imageAndB1;
@property (weak, nonatomic) IBOutlet UILabel *miaoL1;
@property (weak, nonatomic) IBOutlet UIView *typeV1;
@property (weak, nonatomic) IBOutlet UILabel *typeL1;

@property (weak, nonatomic) IBOutlet UILabel *typeNameL1;
@property (weak, nonatomic) IBOutlet UIView *addV1;

@property (weak, nonatomic) IBOutlet UIButton *addL1;

@property (weak, nonatomic) IBOutlet UIView *ImageV1;
@property (weak, nonatomic) IBOutlet UILabel *line0;

@end
