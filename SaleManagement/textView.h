//
//  textView.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/5.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CY_chooseVc.h"
#import "CY_resembleVC.h"


@interface textView : UIView<UITextViewDelegate,chooseDelegate,typeDelegate,UITextFieldDelegate>{
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTextH;

@property (weak, nonatomic) IBOutlet UITextView *nameText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTextH;

@property (weak, nonatomic) IBOutlet UITextView *addText;

@property(nonatomic,retain)NSString *comTypeId;//公司性质id

@property (weak, nonatomic) IBOutlet UILabel *comL;
@property (weak, nonatomic) IBOutlet UILabel *addL;
@property (weak, nonatomic) IBOutlet UILabel *hangL;
@property (weak, nonatomic) IBOutlet UILabel *duanL;
@property (weak, nonatomic) IBOutlet UITextView *lxrName;
@property (weak, nonatomic) IBOutlet UITextView *sex;
@property (weak, nonatomic) IBOutlet UITextView *phone;
@property (weak, nonatomic) IBOutlet UITextView *zuoji;

@property (weak, nonatomic) IBOutlet UIView *adView;

@property (weak, nonatomic) IBOutlet UIButton *yanBT;
@property (nonatomic, assign) id <chooseDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *changebt;
@property (weak, nonatomic) IBOutlet UILabel *jieduanL;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *lineL;

@property (nonatomic,strong)NSString *hangId;

@property (nonatomic,assign)BOOL isduanHiden;//从意向客户保护进入添加客户页面，客户阶段隐藏
@property (nonatomic,strong)NSString *textIntentCustId;

@end
