//
//  PinViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 23.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "PinViewController.h"

static NSString *const PLEASE_STRING = @"Please enter your pin number in order to begin\nour seamless payment process";

@interface PinViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *enterPinLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotPinButton;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourthTextField;

- (IBAction)forgotPinButtonTapped:(UIButton *)sender;
@end

@implementation PinViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.enterPinLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:14.0];
    
    self.informationLabel.textColor = kDarkGrayColor;
    self.informationLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.informationLabel.text = PLEASE_STRING;
    
    // Buttons
    self.forgotPinButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kHyperlinkButtonDefaultSize];
    self.forgotPinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.forgotPinButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    // Text fields
    float textFieldFontSize = 50;
    self.firstTextField.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:textFieldFontSize];
    self.secondTextField.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:textFieldFontSize];
    self.thirdTextField.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:textFieldFontSize];
    self.fourthTextField.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:textFieldFontSize];
}

#pragma mark - Actions

- (IBAction)forgotPinButtonTapped:(UIButton *)sender
{
    // TODO
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
    
    [self.firstTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.firstTextField && textField.text.length == 1) {
        [self.secondTextField becomeFirstResponder];
    }
    
    if (textField == self.secondTextField && textField.text.length == 1) {
        [self.thirdTextField becomeFirstResponder];
    }
    
    if (textField == self.thirdTextField && textField.text.length == 1) {
        [self.fourthTextField becomeFirstResponder];
        
        self.fourthTextField.text = string;
        [self.fourthTextField resignFirstResponder];
        
        NSLog(@"Password: %@%@%@%@",
              self.firstTextField.text,
              self.secondTextField.text,
              self.thirdTextField.text,
              self.fourthTextField.text);
    }
    
    return YES;
}

@end