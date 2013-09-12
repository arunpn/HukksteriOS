//
//  DateTimePicker.m
//  Hukkster
//
//  Created by Jovan Tomasevic on 8/30/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "DateTimePicker.h"

@interface DateTimePicker()
@property (weak, nonatomic) IBOutlet UIButton *confirmTapped;
@property (weak, nonatomic) IBOutlet UIButton *cancelTapped;
@end

@implementation DateTimePicker

#pragma mark - Actions

- (IBAction)confirmTapped:(id)sender
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0.0;
    }];
    
    NSDate *date = [self.datePicker date];
    [self.delegate confirmDate:date];
    [self cancelTapped:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0.0;
    }];
    
    [self.delegate closePicker:self];
}

@end