//
//  UpdatePasswordViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 19.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "UpdatePasswordViewController.h"

static NSString *const PROVIDE_INFO_STRING      = @"Please provide the following information to\ncreate your new account password";
static NSString *const SHORT_PASSWORD_STRING    = @"We're sorry, but passwords must contain\nat least 6 characters. Please try again";
static NSString *const NO_ACCOUNT_STRING        = @"We're sorry, no account with that\nemail address was found";

@interface UpdatePasswordViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *emailRedButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordRedButton;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmPasswordRedButton;
@property (weak, nonatomic) IBOutlet UIButton *createNewPasswordButton;

- (IBAction)createNewPasswordButtonTapped:(UIButton *)sender;
- (IBAction)redButtonTapped:(UIButton *)sender;
- (void)toggleNoAccountMessage:(BOOL)option;
- (void)toggleShortPasswordMessage:(BOOL)option;
@end

@implementation UpdatePasswordViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.informationLabel.textColor = kDarkGrayColor;
    self.informationLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.informationLabel.text = PROVIDE_INFO_STRING;
    
    // Text fields
    float textFieldFontSize = 18.0;
    self.emailTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    self.passwordTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    self.confirmPasswordTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    
    // Buttons
    self.createNewPasswordButton.layer.cornerRadius = kDefaultCornerRadius;
    self.createNewPasswordButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    [self.createNewPasswordButton setTitleColor:kDarkGrayColor forState:UIControlStateHighlighted];
    
    // Hide elements
    self.emailRedButton.alpha = 0.0;
    self.passwordRedButton.alpha = 0.0;
    self.confirmPasswordRedButton.alpha = 0.0;
}

#pragma mark - Actions

- (IBAction)createNewPasswordButtonTapped:(UIButton *)sender
{
    if (!(self.confirmPasswordTextField.text.length >= 6)) {
        [self toggleShortPasswordMessage:YES];
    }
}

- (IBAction)redButtonTapped:(UIButton *)sender
{
    if (sender.tag == 1) { // Email
        self.emailTextField.text = EMPTY_STRING;
        [self toggleNoAccountMessage:NO];
    } else if (sender.tag == 2) { // Password
        self.passwordTextField.text = EMPTY_STRING;
        [self toggleShortPasswordMessage:NO];
    } else if (sender.tag == 3) { // Confirm Password
        self.confirmPasswordTextField.text = EMPTY_STRING;
        [self toggleShortPasswordMessage:NO];
    }
}

#pragma mark - Private API

- (void)toggleNoAccountMessage:(BOOL)option
{
    if (option) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NO_ACCOUNT_STRING];
        [string addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0]
                       range:NSMakeRange(33, 14)];
        self.informationLabel.attributedText = string;
        
        [self.emailRedButton setImage:IMAGE(@"small_red_x") forState:UIControlStateNormal];
        self.emailRedButton.enabled = YES;
        self.emailRedButton.alpha = 1.0;
    } else {
        self.informationLabel.text = PROVIDE_INFO_STRING;
        self.emailRedButton.enabled = NO;
        self.emailRedButton.alpha = 0.0;
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
        [self.confirmPasswordRedButton setImage:IMAGE(@"small_red_x") forState:UIControlStateNormal];
        
        self.passwordRedButton.enabled = YES;
        self.confirmPasswordRedButton.enabled = YES;
        self.passwordRedButton.alpha = 1.0;
        self.confirmPasswordRedButton.alpha = 1.0;
    } else {
        self.informationLabel.text = PROVIDE_INFO_STRING;
        self.passwordRedButton.enabled = NO;
        self.confirmPasswordRedButton.enabled = NO;
        self.passwordRedButton.alpha = 0.0;
        self.confirmPasswordRedButton.alpha = 0.0;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

@end