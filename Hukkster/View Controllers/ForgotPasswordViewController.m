//
//  ForgotPasswordViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 17.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "ForgotPasswordViewController.h"

static NSString *const RESET_PASSWORD_STRING = @"Enter your email and we'll reset your\npassword for you";

@interface ForgotPasswordViewController()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)cancelButtonTapped:(UIButton *)sender;
- (IBAction)loginButtonTapped:(UIButton *)sender;
- (void)toggleButtons:(BOOL)option;
@end

@implementation ForgotPasswordViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.titleLabel.font = [UIFont fontWithName:URWBODONI_REGULAR_FONT size:20.0];
    self.titleLabel.textColor = kDarkGrayColor;
    self.informationLabel.textColor = kDarkGrayColor;
    self.informationLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.informationLabel.text = RESET_PASSWORD_STRING;
    
    // Text fields
    float textFieldFontSize = 18.0;
    self.emailTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    
    // Buttons
    self.cancelButton.backgroundColor = kDarkGrayColor;
    self.cancelButton.layer.cornerRadius = kDefaultCornerRadius;
    self.loginButton.layer.cornerRadius = kDefaultCornerRadius;
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    self.loginButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    
    // Hide elements
    self.cancelButton.alpha = 0.0;
    self.loginButton.alpha = 0.0;
}

#pragma mark - Actions

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self backButtonTapped:nil];
}

- (IBAction)loginButtonTapped:(UIButton *)sender
{
    [self.emailTextField resignFirstResponder];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //[self showMessageViewForType:EMAIL_SENT_MESSAGE_VIEW_TYPE];
        
        [self performSegueWithIdentifier:UPDATE_PASSWORD_SEGUE sender:nil];
    });
}

#pragma mark - Private API

- (void)toggleButtons:(BOOL)option
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.cancelButton.alpha = (option) ? 1.0 : 0.0;
        self.loginButton.alpha = (option) ? 1.0 : 0.0;
    }];
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    self.viewType = POP_TYPE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
    [self toggleButtons:YES];
}

@end