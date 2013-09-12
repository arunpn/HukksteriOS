//
//  MenuViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()

@end

@implementation MenuViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    UIColor *grayColor = COLOR(43.0, 43.0, 43.0, 1.0);
    UIColor *blackColor = [UIColor blackColor];
    [Util fillView:self.view withGradientColors:grayColor andColor2:blackColor];
}

#pragma mark - Actions

- (IBAction)menuItemButtonTapped:(UIButton *)sender
{
    if (self.delegate) {
        // Do not duplicate VCs on stack
        if (sender.selected) return;
        
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.selected) button.selected = NO;
            }
        }
        
        sender.selected = YES;
        
        [self.delegate menuButtonTappedWithTag:sender.tag];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)selectMenuItemWithButtonTag:(int)tag
{
    for (UIView *subview in [self.view subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            if (button.tag == tag) [self menuItemButtonTapped:button];
        }
    }
}

@end