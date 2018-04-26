//
//  CY_photoVc.m
//  SaleManagement
//
//  Created by chaiyuan on 16/1/18.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "CY_photoVc.h"
#import "UIImageView+WebCache.h"

@interface CY_photoVc ()



 @property(nonatomic, strong)UIPageControl *pageControl;     //声明一个UIPageControl
 @property(nonatomic, strong)NSArray  *arrayImages;          //存放图片的数组
 @property(nonatomic, strong)NSMutableArray *viewController; //存放UIViewController的可变数组



@property (retain, nonatomic) UIScrollView *myScrollView;//总的滑动区域

@property (nonatomic, strong) UILabel *titleLabel;//当前页数/总页数




@end

@implementation CY_photoVc

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *mainV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, IOS7_Height)];
    mainV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(5, 8, 45, 45);
    [bt setTitle:@"返回" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [mainV addSubview:bt];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 8, __MainScreen_Width-100, IOS7_Height-16)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [mainV addSubview:_titleLabel];

    [self loadImageScrollerView];
//    [self addImageViewsToScrollView];
    [self loadImage];
     [self.view addSubview:mainV];
}

- (void)loadImageScrollerView
{
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    _myScrollView.delegate = self;
    _myScrollView.contentSize = CGSizeMake(__MainScreen_Width*_pArray.count, 0);
    
    _myScrollView.pagingEnabled = YES;
    _myScrollView.showsVerticalScrollIndicator = YES;
    _myScrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_myScrollView];
    [_myScrollView flashScrollIndicators];

    _arrayImages = [[NSArray alloc]initWithArray:_pArray];
    
    _viewController = [[NSMutableArray alloc] init];
    
         for (NSInteger i = 0; i < [self.pArray count]; i++) {
                 [_viewController addObject:[NSNull null]];
            }
}


-(void)loadImage{
    
    if (_pArray.count>1) {
        
        _titleLabel.text = [NSString stringWithFormat:@"%d / %ld",_currentPage+1,_pArray.count];
    }

    _myScrollView.contentOffset = CGPointMake(__MainScreen_Width*_currentPage, 0.0);

    [self loadScrollViewPage:_currentPage-1];
    [self loadScrollViewPage:_currentPage];
    [self loadScrollViewPage:_currentPage+1];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = CGRectGetWidth(self.myScrollView.frame);
        NSInteger page = floor((self.myScrollView.contentOffset.x -pageWidth/2)/pageWidth) +1;
         _currentPage = page;
    
     _titleLabel.text = [NSString stringWithFormat:@"%d / %ld",_currentPage+1,_pArray.count];
         [self loadScrollViewPage:page-1];
         [self loadScrollViewPage:page];
         [self loadScrollViewPage:page+1];
}


 -(void)loadScrollViewPage:(NSInteger)page
 {
    if (page >= self.pArray.count) {
        return;
             }
     if (page<0) {
         return;
     }
    
    UIImageView *imageViewController = [self.viewController objectAtIndex:page];
     
    if ((NSNull *)imageViewController == [NSNull null])
             {

                imageViewController = [[UIImageView alloc] init];
                 imageViewController.contentMode = UIViewContentModeScaleAspectFit;
                    [self.viewController replaceObjectAtIndex:page withObject:imageViewController];
                 }
    
         if (imageViewController.superview == nil) {
            
                 CGRect frame = self.myScrollView.frame;
                frame.origin.x = CGRectGetWidth(frame) * page;
                frame.origin.y = 0;
                imageViewController.frame = frame;

                [self.myScrollView addSubview:imageViewController];
             
             
             NSString * url2 = [_pArray objectAtIndex:page];
             
             
             [imageViewController sd_setImageWithURL:[NSURL URLWithString:url2] placeholderImage:[UIImage imageNamed:@"icon_gtjl_mrtp.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)  {
              
                 
             }];
             }
     }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
