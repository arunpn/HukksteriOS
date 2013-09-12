//
//  DateTimePicker.h
//  Hukkster
//
//  Created by Jovan Tomasevic on 8/30/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateTimePicker;

@protocol DateTimePickerDelegat <NSObject>
@optional
- (void)confirmDate:(NSDate *)date;
- (void)closePicker:(DateTimePicker *)picker;
@end

@interface DateTimePicker : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (assign, nonatomic) id<DateTimePickerDelegat> delegate;
@end