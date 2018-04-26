//
//  JTCalendarMenuMonthView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import "JTCalendar.h"

@interface JTCalendarMenuMonthView : UIView

@property (weak, nonatomic) JTCalendar *calendarManager;
@property (retain, nonatomic) UILabel *textLabel;
- (void)setMonthIndex:(NSInteger)monthIndex;

- (void)reloadAppearance;

@end


