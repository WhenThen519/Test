//
//  CY_FilterView.m
//  SaleManagement
//
//  Created by chaiyuan on 15/12/24.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "CY_FilterView.h"


@interface CY_FilterView() <PullDownMenuDelegate>
{
    NSMutableArray *_selectedArray;
}
@end

@implementation CY_FilterView

- (id)initWithFrame:(CGRect)frame
   buttonTitleArray:(NSArray*)titleArray
    dataSourceArray:(NSArray*)dataArray
           delegate:(id<FilterViewDelegate>)delegate{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _delegate = delegate;
        _dataArray = dataArray;
        _selectedArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [ToolList getColor:@"fafafa"];
        NSInteger count = titleArray.count;
        for (int i = 0; i<count ;i++) {
            UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width/count - 20, 0, 0);
            b.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 15);
            b.backgroundColor = [UIColor clearColor];
            b.adjustsImageWhenHighlighted = NO;
            [b setTag:i];
            [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [b setTitleColor:[ToolList getColor:@"888888"] forState:UIControlStateNormal];
            [b setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateSelected];
            [b setTitleColor:[ToolList getColor:@"6052ba"] forState:UIControlStateHighlighted];
            [b setImage:[UIImage imageNamed:@"icon_filter_down"] forState:UIControlStateNormal];
            [b setImage:[UIImage imageNamed:@"icon_filter_up"] forState:UIControlStateSelected];
            [b setFrame:CGRectMake(i*self.frame.size.width/count, 0, self.frame.size.width/count, self.frame.size.height)];
            [b setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [b addTarget:self
                  action:@selector(__showTableView:)
        forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:b];
            //每个button对应_selectedArray的一项
            [_selectedArray addObject:@{}];
        }
//        
//        for (int i=1; i<count; i++) {
//            UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width/count, 0, 0.5, self.frame.size.height)];
//            separator.contentMode = UIViewContentModeScaleAspectFit;
//            separator.image = [UIImage imageNamed:@"icon-fenge"];
//            [self addSubview:separator];
//        }
    }
    return self;
}

#pragma mark - Private

-(void)__showTableView:(UIButton*)sender
{
    //已经显示下拉菜单
    if (sender.isSelected) {
        [PullDownMenu dismissActiveMenu:nil];
        sender.selected = NO;
        return;
    }
//    
//    if (sender.tag == 0) {
//            
//        [_delegate getData2];
//        
//        return;
//        }
    

    self.selected = NO;

    [PullDownMenu showMenuBelowView:self
                              array:_dataArray
                  selectedMenuIndex:sender.tag
                     selectedDetail:[_selectedArray objectAtIndex:sender.tag]
                           delegate:self];
    
    sender.selected = YES;
}

#pragma mark - PullDownMenud Delegate

- (void)pullDownMenu:(PullDownMenu *)pullDownMenu didSelectedCell:(NSDictionary *)info selectedMenuIndex:(NSInteger)tag
{
    if (_delegate && [_delegate respondsToSelector:@selector(filterView:didSelectedCell:selectedMenuIndex:)]) {
        self.selected = NO;
        //替换选中项
        [_selectedArray replaceObjectAtIndex:tag withObject:info];
        //实现代理，刷新Controller界面
        [_delegate filterView:self didSelectedCell:info selectedMenuIndex:tag];
    }
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
}

- (void)setEnabled:(BOOL)enable
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            ((UIButton *)v).enabled = enable;
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            ((UIButton *)v).selected = selected;
        }
    }
}



@end
