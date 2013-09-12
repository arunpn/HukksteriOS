//
//  RegistrationViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 16.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MetaData.h"


@interface RegistrationViewController()
@property (weak, nonatomic) IBOutlet UIImageView *hukksterTextImageView;
@property (weak, nonatomic) IBOutlet UILabel *trackProductsLabelLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponCodesLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpLaterButton;
@property (weak, nonatomic) IBOutlet UIButton *howItWorksButton;

- (IBAction)signUpLaterButtonTapped:(UIButton *)sender;
- (IBAction)howItWorksButtonTapped:(UIButton *)sender;
@end

@implementation RegistrationViewController


#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    float labelFontSize = 18.0;
    self.trackProductsLabelLabel.text = @"Track products on sites you love & get\nalerts when they go on sale";
    self.trackProductsLabelLabel.font = [UIFont fontWithName:URWBODONI_LIGHT_FONT size:labelFontSize];
    self.couponCodesLabel.font = [UIFont fontWithName:URWBODONI_LIGHT_FONT size:labelFontSize];
    self.couponCodesLabel.textColor = kDarkGrayColor;
    
    // Buttons
    self.loginButton.layer.cornerRadius = kDefaultCornerRadius;
    self.signupButton.layer.cornerRadius = kDefaultCornerRadius;
    self.loginButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    self.signupButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];

    self.signUpLaterButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kHyperlinkButtonDefaultSize];
    self.howItWorksButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kHyperlinkButtonDefaultSize];
    self.signUpLaterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.howItWorksButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.signUpLaterButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [self.howItWorksButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    // iPhone 5
    if (IS_IPHONE_5) {
        self.hukksterTextImageView.frame = [Util changeParamteter:PARAMETER_Y
                                                           ofView:self.hukksterTextImageView
                                                        toValue:self.hukksterTextImageView.frame.origin.y + 15];
        self.trackProductsLabelLabel.frame = [Util changeParamteter:PARAMETER_Y
                                                             ofView:self.trackProductsLabelLabel
                                                            toValue:self.trackProductsLabelLabel.frame.origin.y + 40];
        self.couponCodesLabel.frame = [Util changeParamteter:PARAMETER_Y
                                                      ofView:self.couponCodesLabel
                                                     toValue:self.couponCodesLabel.frame.origin.y + 50];
    }
}

#pragma mark - Actions

- (IBAction)signUpLaterButtonTapped:(UIButton *)sender
{
    
}

- (IBAction)howItWorksButtonTapped:(UIButton *)sender
{
    [self showMessageViewForType:EMAIL_SENT_MESSAGE_VIEW_TYPE];
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    self.viewType = MODAL_TYPE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    if([Util isLoggedIn]){
        
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        //[self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
}


@end