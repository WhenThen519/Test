//
//  XiejiluViewController.h
//  SaleManagement
//
//  Created by feixiang on 16/1/7.
//  Copyright © 2016年 cn.300.cn. All rights reserved.
//

#import "Fx_RootViewController.h"
#import "ZYQAssetPickerController.h"
#import <AVFoundation/AVFoundation.h>

@interface XiejiluViewController2 : Fx_RootViewController<ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *photo_view;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *labaImage;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textView_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo_h;
@property (weak, nonatomic) IBOutlet UIView *voice_view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voice_h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *address_h;
@property(copy,nonatomic)NSString *custName;
@property(copy,nonatomic)NSString *custId;
@property(copy,nonatomic)NSString *linkManId ;
@property(copy,nonatomic)NSString *linkManName ;
@property(copy,nonatomic)NSString *visitType ;
@property(copy,nonatomic)NSString *visitAdd ;
@property(copy,nonatomic)NSString *longitude ;
@property(copy,nonatomic)NSString *latitude ;
@property(copy,nonatomic)NSString *fromPage;
@property (strong, nonatomic) NSMutableArray *emojiTags;
@property (strong, nonatomic) NSMutableArray *emojiImages;
@property(copy,nonatomic)NSString *logId_1;
@property (nonatomic,assign)BOOL isLogId;//数值为1，表示经理陪访或回访

@property(copy,nonatomic)NSString *pf_SalerId;//陪访商务ID，可选

@end
