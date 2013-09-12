//
//  SignUpViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 19.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "SignUpViewController.h"
#import "MetaData.h"

static NSString *const PROVIDE_STRING           = @"Please provide the following information to\nlog in to your Hukkster Account";
static NSString *const EMAILS_DONT_MATCH_STRING = @"Your email addresses do not match.\nPlease try again";
static NSString *const SHORT_PASSWORD_STRING    = @"We're sorry, but passwords must contain\nat least 6 characters. Please try again";
static NSString *const INVALID_EMAIL_STRING     = @"We're sorry, but that is an invalid email address.\nPlease input a valid email & try again";

@interface SignUpViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *hukksterTextImageView;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *emailRedButton;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmEmailRedButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordRedButton;
@property (weak, nonatomic) IBOutlet UILabel *alreadyUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)redButtonTapped:(UIButton *)sender;
- (IBAction)signUpButtonTapped:(UIButton *)sender;
- (IBAction)registerWithFacebookButtonTapped:(UIButton *)sender;
- (IBAction)registerWithGoogleButtonTapped:(UIButton *)sender;
- (IBAction)loginButtonTapped:(UIButton *)sender;
- (void)toggleEmailsDontMatchMessage:(BOOL)option;
- (void)toggleShortPasswordMessage:(BOOL)option;
- (void)toggleInvalidEmailMessage:(BOOL)option;
@end

@implementation SignUpViewController

#pragma mark - DataControllerDelegate

-(void)registerResponse:(UserSession *)user metaData:(MetaData *)meta{
    [Util showAlertWithTitle:meta.message withMessage:meta.message andCancelButtonTitle:@"OK"];
}


#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.informationLabel.textColor = kDarkGrayColor;
    self.informationLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.informationLabel.text = PROVIDE_STRING;
    self.alreadyUserLabel.textColor = kDarkGrayColor;
    self.alreadyUserLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    
    // Text fields
    float textFieldFontSize = 18.0;
    self.emailTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    self.confirmEmailTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    self.passwordTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    
    // Buttons
    self.loginButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:13.0];
    self.loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.signUpButton.layer.cornerRadius = kDefaultCornerRadius;
    self.signUpButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    
    // Hide elements
    self.signUpButton.alpha = 0.0;
    self.emailRedButton.alpha = 0.0;
    self.confirmEmailRedButton.alpha = 0.0;
    self.passwordRedButton.alpha = 0.0;
    self.informationLabel.alpha = 0.0;
    
    // Alternative sign up (it looks a little bit different)
    if (self.alternativeSignUp) {
        self.headerTitleLabel.alpha = 0.0;
        self.navigationBarImageView.alpha = 0.0;
        [self.closeButton setImage:IMAGE(@"black_x") forState:UIControlStateNormal];
    }
}

#pragma mark - Actions

- (IBAction)redButtonTapped:(UIButton *)sender
{
    if (sender.tag == 1) { // Email
        self.emailTextField.text = EMPTY_STRING;

    } else if (sender.tag == 2) { // Confirm Email
        self.confirmEmailTextField.text = EMPTY_STRING;
        [self toggleEmailsDontMatchMessage:NO];
    } else if (sender.tag == 3) { // Password
        self.passwordTextField.text = EMPTY_STRING;
        [self toggleShortPasswordMessage:NO];
    }
}

- (IBAction)signUpButtonTapped:(UIButton *)sender
{
    [self.emailTextField resignFirstResponder];
    [self.confirmEmailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
   /* if ([self.emailRedButton imageForState:UIControlStateNormal] == IMAGE(@"small_gray_check") &&
        [self.confirmEmailRedButton imageForState:UIControlStateNormal] == IMAGE(@"small_gray_check") &&
        [self.passwordRedButton imageForState:UIControlStateNormal] == IMAGE(@"small_gray_check")) {
        [self showMessageViewForType:EXISTING_ACCOUNT_VIEW_TYPE];
    }*/
    //else{
        [self.dataController registerWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text];
    //}
}

- (IBAction)registerWithFacebookButtonTapped:(UIButton *)sender
{
    // TODO
    
}

- (IBAction)registerWithGoogleButtonTapped:(UIButton *)sender
{
    // TODO
}

- (IBAction)loginButtonTapped:(UIButton *)sender
{
    // TODO
}

#pragma mark - Private API

- (void)toggleEmailsDontMatchMessage:(BOOL)option
{
    if (option) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:EMAILS_DONT_MATCH_STRING];
        [string addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0]
                       range:NSMakeRange(0, 33)];
        self.informationLabel.attributedText = string;
    } else {
        self.informationLabel.text = PROVIDE_STRING;
    }
}

- (void)toggleShortPasswordMessage:(BOOL)option
{
    if (option) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:SHORT_PASSWORD_STRING];
        [string addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0]
                       range:NSMakeRange(16, 10)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0]
                       range:NSMakeRange(48, 14)];
        self.informationLabel.attributedText = string;
        
        [self.passwordRedButton setImage:IMAGE(@"small_red_x") forState:UIControlStateNormal];
    } else {
        self.informationLabel.text = PROVIDE_STRING;
        [self.passwordRedButton setImage:IMAGE(@"small_gray_check") forState:UIControlStateNormal];
    }
}

- (void)toggleInvalidEmailMessage:(BOOL)option
{
    if (option) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:INVALID_EMAIL_STRING];
        [string addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0]
                       range:NSMakeRange(28, 21)];
        self.informationLabel.attributedText = string;
    } else {
        self.informationLabel.text = PROVIDE_STRING;
    }
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.hukksterTextImageView.alpha = 1.0;
        self.signUpButton.alpha = 0.0;
        self.informationLabel.alpha = 0.0;
    }];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.hukksterTextImageView.alpha = 0.0;
        self.signUpButton.alpha = 1.0;
        self.informationLabel.alpha = 1.0;
    }];
    
    if (textField == self.emailTextField) {
        self.emailRedButton.alpha = 0.0;
    } else if (textField == self.confirmEmailTextField) {
        self.confirmEmailRedButton.alpha = 0.0;
    } else if (textField == self.passwordTextField) {
        self.passwordRedButton.alpha = 0.0;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*if (textField == self.emailTextField && textField.text.length > 0) {
        self.emailRedButton.alpha = 1.0;
        
        if (![Util isEmailValid:self.emailTextField.text]) {
            [self.emailRedButton setImage:IMAGE(@"small_red_x") forState:UIControlStateNormal];
            [self toggleInvalidEmailMessage:YES];
        } else {
            [self.emailRedButton setImage:IMAGE(@"small_gray_check") forState:UIControlStateNormal];
            [self toggleInvalidEmailMessage:NO];
        }
    } else if (textField == self.confirmEmailTextField) {
        if (textField.text.length > 0) {
            self.confirmEmailRedButton.alpha = 1.0;
            
            if ([self.emailTextField.text isEqualToString:self.confirmEmailTextField.text]) {
                [self.confirmEmailRedButton setImage:IMAGE(@"small_gray_check") forState:UIControlStateNormal];
                [self toggleEmailsDontMatchMessage:NO];
            } else {
                [self.confirmEmailRedButton setImage:IMAGE(@"small_red_x") forState:UIControlStateNormal];
                [self toggleEmailsDontMatchMessage:YES];
            }
        } else {
            self.confirmEmailRedButton.alpha = 0.0;
        }
    } else if (textField == self.passwordTextField && textField.text.length > 0) {
        self.passwordRedButton.alpha = 1.0;
        
        if (textField.text.length >= 6) {
            [self.passwordRedButton setImage:IMAGE(@"small_gray_check") forState:UIControlStateNormal];
            [self toggleShortPasswordMessage:NO];
        } else {
            [self.passwordRedButton setImage:IMAGE(@"small_red_x") forState:UIControlStateNormal];
            [self toggleShortPasswordMessage:YES];
        }
    }*/
}

@end