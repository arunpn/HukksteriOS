//
//  MessageView.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "MessageView.h"

@interface MessageView()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *informationView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@end

@implementation MessageView

#pragma mark - Public API

- (void)configureUI
{
    self.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    
    // Information view
    int x = ([Util screenWidth] - self.informationView.frame.size.width)/2;
    int y = ([Util screenHeight] - self.informationView.frame.size.height)/2;
    self.informationView.frame = CGRectMake(x, y, self.informationView.frame.size.width, self.informationView.frame.size.height);
    [Util addShadowToView:self.informationView];
    
    // Image view
    if (IS_IPHONE_5) self.backgroundImageView.image = IMAGE(@"radial_background-568h@2x");
    
    // Labels
    self.titleLabel.font = [UIFont fontWithName:URWBODONI_REGULAR_FONT size:18.0];
    self.detailLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.detailLabel.textColor = COLOR(113.0, 113.0, 113.0, 1.0);
    self.titleLabel.text = self.titleString;
    if (self.viewType == EARN_SALES_KARMA_VIEW_TYPE) {
        self.titleLabel.frame = [Util changeParamteter:PARAMETER_Y
                                                ofView:self.titleLabel
                                               toValue:self.titleLabel.frame.origin.y + 10];
    }
    
    self.detailLabel.text = self.detailString;
    if (self.viewType == NOT_SUPPORTED_VIEW_TYPE ||
        self.viewType == HUKK_PRODUCT_VIEW_TYPE ||
        self.viewType == DID_WE_GET_IT_VIEW_TYPE) {
        self.detailLabel.frame = [Util changeParamteter:PARAMETER_Y
                                                 ofView:self.detailLabel
                                                toValue:self.detailLabel.frame.origin.y - 5];
    }
    
    // Buttons
    [self.button setTitle:self.buttonString forState:UIControlStateNormal];
    [self.leftButton setTitle:self.leftButtonString forState:UIControlStateNormal];
    self.leftButton.backgroundColor = kDarkGrayColor;
    [self.rightButton setTitle:self.rightButtonString forState:UIControlStateNormal];
    
    self.button.layer.cornerRadius = kDefaultCornerRadius;
    self.rightButton.layer.cornerRadius = kDefaultCornerRadius;
    self.rightButton.layer.cornerRadius = kDefaultCornerRadius;
    
    self.button.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    self.rightButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    self.leftButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    
    // Show hide left/right button or main button
    if (self.leftButtonString || self.rightButtonString) {
        self.button.alpha = 0.0;
        self.leftButton.alpha = 1.0;
        self.rightButton.alpha = 1.0;
    } else {
        self.button.alpha = 1.0;
        self.leftButton.alpha = 0.0;
        self.rightButton.alpha = 0.0;
    }
    
    // Hide close button
    if (self.viewType == CONFIRM_MAIL_VIEW_TYPE ||
        self.viewType == OOPS_VIEW_TYPE ||
        self.viewType == SOLD_OUT_VIEW_TYPE ||
        self.viewType == NO_NETWORK_VIEW_TYPE ||
        self.viewType == NOT_SUPPORTED_VIEW_TYPE ||
        self.viewType == TECH_DIFFICULTIES_VIEW_TYPE ||
        self.viewType == MANY_OPTIONS_VIEW_TYPE ||
        self.viewType == SAVED_TO_YOUR_HUKKS_VIEW_TYPE ||
        self.viewType == DELETE_LIST_VIEW_TYPE ||
        self.viewType == HUKK_LIST_VIEW_TYPE ||
        self.viewType == ARE_YOU_SURE_TYPE ||
        self.viewType == PURCHASING_ERROR_VIEW_TYPE ||
        self.viewType == DID_WE_GET_IT_VIEW_TYPE ||
        self.viewType == INVALID_BIRTHDAY_VIEW_TYPE) {
        self.closeButton.hidden = YES;
    }
}

#pragma mark - Actions

- (IBAction)buttonTapped:(UIButton *)sender
{
    [self closeButtonTapped:nil];
}

- (IBAction)leftButtonTapped:(UIButton *)sender
{
    if ([self.leftButtonString isEqualToString:@"NO"] ||
        [self.leftButtonString isEqualToString:@"CANCEL"] ||
        [self.leftButtonString isEqualToString:@"CLOSE"]) {
        [self closeButtonTapped:nil];
    }
}

- (IBAction)rightButtonTapped:(UIButton *)sender
{
    // TODO
}

- (IBAction)closeButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0.0;
    }];
    
    [self.delegate messageViewClosed:self];
}

@end