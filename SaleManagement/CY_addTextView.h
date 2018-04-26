//
//  CY_addTextView.h
//  SaleManagement
//
//  Created by chaiyuan on 16/1/6.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CY_selectV.h"

@interface CY_addTextView : UIView<UITextViewDelegate,chooseDelegate,typeDelegate,HZAreaPickerDelegate>{
    
     CY_selectV *selectV;
}
@property (weak, nonatomic) IBOutlet UITextView *lxrName;
@property (weak, nonatomic) IBOutlet UITextView *sex;
@property (weak, nonatomic) IBOutlet UITextView *phone;
@property (weak, nonatomic) IBOutlet UITextView *zuoji;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTextHH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTextHH;

@property (weak, nonatomic) IBOutlet UITextView *addTextt;

@property (weak, nonatomic) IBOutlet UITextView *numText;

@property (weak, nonatomic) IBOutlet UITextView *nameTextt;

@property (weak, nonatomic) IBOutlet UILabel *duanLL;

@property (weak, nonatomic) IBOutlet UIView *daView;

@property (weak, nonatomic) IBOutlet UIButton *yanButton;
@property (weak, nonatomic) IBOutlet UILabel *adLable;

@property (nonatomic, assign) id <chooseDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *changebt;
@property (weak, nonatomic) IBOutlet UILabel *jieduanL;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIImageView *lineimage;

@end
