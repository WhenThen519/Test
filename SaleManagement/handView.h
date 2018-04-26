//
//  handView.h
//  SaleManagement
//
//  Created by chaiyuan on 15/12/21.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface handView : UIView


@property(nonatomic, strong) id VC;
@property(nonatomic, strong)UILabel *titleLabel;

- (id)initWithTitle:(NSString *)title
      andTitleColor:(UIColor *)titleColor
         andBGColor:(UIColor *)bgColor
       andLeftImage:(NSString *)leftImage
      andRightImage:(NSString *)rightImage
       andLeftTitle:(NSString *)lefttitle
      andRightTitle:(NSString *)righttitle
          andTarget:(id)obj;

//白色固定导航栏
- (id)initWithTitle:(NSString *)title
      andRightImage:(NSString *)rightImage
       andLeftTitle:(NSString *)lefttitle
      andRightTitle:(NSString *)righttitle
          andTarget:(id)obj;

//搜索页面的表头
- (id)initWithFram:(CGRect)farm SearchandTarget:(id)obj;

@end
