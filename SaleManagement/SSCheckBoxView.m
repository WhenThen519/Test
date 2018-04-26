//
//  SSCheckBoxView.m
//  SaleManagement
//
//  Created by chaiyuan on 15/11/20.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//

#import "SSCheckBoxView.h"
#import "UIHelpers.h"
#import "ARCMacro.h"

static const CGFloat kHeight = 36.0f;

@interface SSCheckBoxView(Private)

- (UIImage *) checkBoxImageForStyle:(SSCheckBoxViewStyle)s
                            checked:(BOOL)isChecked;
- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img;
- (void) updateCheckBoxImage;

@end

@implementation SSCheckBoxView

- (id) initWithFrame:(CGRect)frame
               style:(SSCheckBoxViewStyle)aStyle
             checked:(BOOL)aChecked
{
    frame.size.height = kHeight;
    if (!(self = [super initWithFrame:frame])) {
        return self;
    }
    
    stateChangedSelector = nil;
    self.stateChangedBlock = nil;
    delegate = nil;
    _style = aStyle;
    _checked = aChecked;
    enabled = YES;
    
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    CGRect labelFrame = CGRectMake(32.0f, 7.0f, self.frame.size.width - 32, 20.0f);
    UILabel *l = [[UILabel alloc] initWithFrame:labelFrame];
    l.textAlignment = UITextAlignmentLeft;
    l.backgroundColor = [UIColor clearColor];
    l.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    l.textColor = RgbHex2UIColor(0x2E, 0x2E, 0x2E);
    l.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    l.shadowColor = [UIColor whiteColor];
    l.shadowOffset = CGSizeMake(0, 1);
    [self addSubview:l];
    self.textLabel = l;
    [l RELEASE];
    
    UIImage *img = [self checkBoxImageForStyle:_style checked:_checked];
    CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
    iv.image = img;
    [self addSubview:iv];
    checkBoxImageView = iv;
    
    return self;
}

- (void) dealloc
{
    [self.stateChangedBlock RELEASE];
    [checkBoxImageView RELEASE];
    [_textLabel RELEASE];
    [super DEALLOC];
}

- (void) setEnabled:(BOOL)isEnabled
{
    _textLabel.enabled = isEnabled;
    enabled = isEnabled;
    checkBoxImageView.alpha = isEnabled ? 1.0f: 0.6f;
}

- (BOOL) enabled
{
    return enabled;
}

- (void) setText:(NSString *)text
{
    [_textLabel setText:text];
}

- (void) setChecked:(BOOL)isChecked
{
    _checked = isChecked;
    [self updateCheckBoxImage];
}

- (void) setStateChangedTarget:(id<NSObject>)target
                      selector:(SEL)selector
{
    delegate = target;
    stateChangedSelector = selector;
}


#pragma mark - Touch-related Methods

- (void) touchesBegan:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    if (!enabled) {
        return;
    }
    
    self.alpha = 0.8f;
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches
                withEvent:(UIEvent *)event
{
    if (!enabled) {
        return;
    }
    
    self.alpha = 1.0f;
    [super touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches
            withEvent:(UIEvent *)event
{
    if (!enabled) {
        return;
    }
    
    // restore alpha
    self.alpha = 1.0f;
    
    // check touch up inside
    if ([self superview]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:[self superview]];
        CGRect validTouchArea = CGRectMake((self.frame.origin.x - 5),
                                           (self.frame.origin.y - 10),
                                           (self.frame.size.width + 5),
                                           (self.frame.size.height + 10));
        if (CGRectContainsPoint(validTouchArea, point)) {
            _checked = !_checked;
            [self updateCheckBoxImage];
            if (delegate && stateChangedSelector) {
                [delegate performSelector:stateChangedSelector withObject:self];
            }
            else if (_stateChangedBlock) {
                _stateChangedBlock(self);
            }
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}


#pragma mark - Private Methods

- (UIImage *) checkBoxImageForStyle:(SSCheckBoxViewStyle)s
                            checked:(BOOL)isChecked
{
    NSString *suffix = isChecked ? @"on" : @"off";
    NSString *imageName = @"";
    switch (s) {
        case kSSCheckBoxViewStyleBox:
            imageName = @"cb_box_";
            break;
        case kSSCheckBoxViewStyleDark:
            imageName = @"cb_dark_";
            break;
        case kSSCheckBoxViewStyleGlossy:
            imageName = @"cb_glossy_";
            break;
        case kSSCheckBoxViewStyleGreen:
            imageName = @"cb_green_";
            break;
        case kSSCheckBoxViewStyleMono:
            imageName = @"cb_mono_";
            break;
        default:
            return nil;
    }
    imageName = [NSString stringWithFormat:@"%@%@", imageName, suffix];
    return [UIImage imageNamed:imageName];
}

- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
    CGFloat y = floorf((kHeight - img.size.height) / 2.0f);
    return CGRectMake(5.0f, y, img.size.width, img.size.height);
}

- (void) updateCheckBoxImage
{
    checkBoxImageView.image = [self checkBoxImageForStyle:_style
                                                  checked:_checked];
}


@end
