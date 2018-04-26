//
//  XiejiluViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"

@interface XiejiluViewController : Fx_RootViewController<UITextFieldDelegate>{
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *xiaoshoudongzuoL;
@property (weak, nonatomic) IBOutlet UIButton *SelectKehuBtn;
@property (weak, nonatomic) IBOutlet UILabel *KehuName;
@property (weak, nonatomic) IBOutlet UIView *xiaoshoudongzuoView;
@property (weak, nonatomic) IBOutlet UIScrollView *lianxirenScroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scroll_h;
@property (weak, nonatomic) IBOutlet UIButton *SelectPeiFangBtn;

@property (weak, nonatomic) IBOutlet UIButton *addKHBtn;

@property(copy,nonatomic)NSString *quanxianFlag;
@property(copy,nonatomic)NSString *fromPage;
@property(copy,nonatomic)NSString *kehuNameStr;
@property(copy,nonatomic)NSString *kehuNameId;
@property(copy,nonatomic)NSString *xiaoshoudongzuo;
@property(copy,nonatomic)NSString *lianxirenId;
@property(copy,nonatomic)NSString *lianxirenName;
@property (strong,nonatomic)NSArray *xiaoshoudongzuoBtnArr;
@property(copy,nonatomic)NSString *logId;
@property (assign,nonatomic)int chooseId;//1代表回访，2代表陪访
@property (assign,nonatomic)BOOL isHuiFang;//1代表经理回访或陪访

@property (assign,nonatomic)BOOL isShouYe;//yes 从首页跳转过来，右上角的添加客户按钮显示，其他时候隐藏
@property (weak, nonatomic) IBOutlet UILabel *pfL;

@end
