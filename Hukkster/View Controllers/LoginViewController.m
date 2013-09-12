//
//  LoginViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 16.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "LoginViewController.h"
#import "TopHukksViewController.h"
#import "WebServiceManager.h"
#import "DataController.h"
#import "UserSession.h"


static NSString *const PROVIDE_STRING           = @"Please provide the following information to\nlog in to your Hukkster Account";
static NSString *const NO_ACCOUNT_STRING        = @"We're sorry, no account with that\nemail address was found";
static NSString *const INCORRECT_PASS_STRING    = @"It appears your password is incorrect\nPlease try again";


@interface LoginViewController() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *hukksterTextImageView;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *emailRedButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordRedButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)signInButtonTapped:(UIButton *)sender;
- (IBAction)loginWithFacebookButtonTapped:(UIButton *)sender;
- (IBAction)loginWithGoogleButtonTapped:(UIButton *)sender;
- (IBAction)cancelButtonTapped:(UIButton *)sender;
- (IBAction)loginButtonTapped:(UIButton *)sender;
- (IBAction)redButtonTapped:(UIButton *)sender;
- (void)toggleButtons:(BOOL)option;
- (void)toggleSignIn:(BOOL)option;
- (void)toggleNoAccountMessage:(BOOL)option;
- (void)toggleIncorrectPasswordMessage:(BOOL)option;
@end

@implementation LoginViewController

#pragma mark - DataControllerDelegate.

-(void)loginWithEmailResponse:(UserSession *)user metaData:(MetaData *)metaData
{
    [self backButtonTapped:nil];
    /*
    TopHukksViewController *topHukks =  VC(@"TopHukksViewController");
    
    [self.navigationController pushViewController:topHukks animated:YES];*/
}

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.informationLabel.textColor = kDarkGrayColor;
    self.informationLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.informationLabel.text = PROVIDE_STRING;
    self.orLabel.textColor = kDarkGrayColor;
    self.orLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    
    // Text fields
    float textFieldFontSize = 18.0;
    self.emailTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    self.passwordTextField.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:textFieldFontSize];
    
    // Buttons
    self.forgotPasswordButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kHyperlinkButtonDefaultSize];
    self.forgotPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.forgotPasswordButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    self.signInButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kHyperlinkButtonDefaultSize];
    self.signInButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.signInButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    self.cancelButton.backgroundColor = kDarkGrayColor;
    self.cancelButton.layer.cornerRadius = kDefaultCornerRadius;
    self.loginButton.layer.cornerRadius = kDefaultCornerRadius;
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    self.loginButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    
    // Hide elements
    self.informationLabel.alpha = 0.0;
    self.cancelButton.alpha = 0.0;
    self.loginButton.alpha = 0.0;
    self.emailRedButton.alpha = 0.0;
    self.passwordRedButton.alpha = 0.0;
    self.orLabel.alpha = 0.0;
    self.signInButton.alpha = 0.0;
}

#pragma mark - Actions

- (IBAction)signInButtonTapped:(UIButton *)sender
{
    // TODO
}

- (IBAction)loginWithFacebookButtonTapped:(UIButton *)sender
{
    // TODO
    // debugg
    //TopHukksViewController *topHukks =  [self.storyboard instantiateViewControllerWithIdentifier:@"TopHukksViewController"];
    //topHukks.loggedIn = YES;
    //[self.navigationController pushViewController:topHukks animated:YES];
    
}

- (IBAction)loginWithGoogleButtonTapped:(UIButton *)sender
{
    // TODO
}

- (IBAction)cancelButtonTapped:(UIButton *)sender
{
    [self toggleSignIn:NO];
    [self toggleNoAccountMessage:NO];
}

- (IBAction)loginButtonTapped:(UIButton *)sender
{
    //[self toggleNoAccountMessage:YES];
    
    if (![Util isEmailValid:self.emailTextField.text]) {
        [self toggleNoAccountMessage:YES];
        return;
    }
    
    if ([Util isEmpty:self.passwordTextField.text]) {
        [Util showAlertWithTitle:@"Error" withMessage:@"Please enter password" andCancelButtonTitle:OK_STRING];
        return;
    }
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [self.dataController loginWithEmail:email andPassword:password];
    
    //[[WebServiceManager sharedInstance] postParameters:EMPTY_STRING toURL:@"http://apidev.hukkster.com/api/v2/user/login/" withProcess:LOGIN_PROCESS asBackgroundProcess:NO];
}

- (IBAction)redButtonTapped:(UIButton *)sender
{
    if (sender.tag == 1) { // Email
        self.emailTextField.text = EMPTY_STRING;
        [self toggleNoAccountMessage:NO];
    } else if (sender.tag == 2) { // Password
        self.passwordTextField.text = EMPTY_STRING;
        [self toggleIncorrectPasswordMessage:NO];
    }
}

#pragma mark - Private API

- (void)toggleButtons:(BOOL)option
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.cancelButton.alpha = (option) ? 1.0 : 0.0;
        self.loginButton.alpha = (option) ? 1.0 : 0.0;
        self.hukksterTextImageView.alpha = (option) ? 0.0 : 1.0;
        self.informationLabel.alpha = (option) ? 1.0 : 0.0;
    }];
}

- (void)toggleSignIn:(BOOL)option
{
    if (option) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.forgotPasswordButton.frame = [Util changeParamteter:PARAMETER_X ofView:self.forgotPasswordButton toValue:135];
        } completion:^(BOOL finishedCompletion) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.orLabel.alpha = 1.0;
                self.signInButton.alpha = 1.0;
            }];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.orLabel.alpha = 0.0;
            self.signInButton.alpha = 0.0;
        } completion:^(BOOL finishedCompletion) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.forgotPasswordButton.frame = [Util changeParamteter:PARAMETER_X ofView:self.forgotPasswordButton toValue:188];
            }];
        }];
    }
}

- (void)toggleNoAccountMessage:(BOOL)option
{
    if (option) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NO_ACCOUNT_STRING];
        [string addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0]
                       range:NSMakeRange(33, 14)];
        self.informationLabel.attributedText = string;
        
        self.emailRedButton.alpha = 1.0;
    } else {
        self.emailRedButton.alpha = 0.0;
        self.informationLabel.text = PROVIDE_STRING;
    }
}

- (void)toggleIncorrectPasswordMessage:(BOOL)option
{
    if (option) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:INCORRECT_PASS_STRING];
        [string addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0, string.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0]
                       range:NSMakeRange(16, 8)];
        self.informationLabel.attributedText = string;
        [self.forgotPasswordButton setTitleColor:kRedColor forState:UIControlStateNormal];
        
        self.passwordRedButton.alpha = 1.0;
        [self toggleSignIn:YES];
    } else {
        self.passwordRedButton.alpha = 0.0;
        self.informationLabel.text = PROVIDE_STRING;
        [self.forgotPasswordButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
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
    [self toggleButtons:NO];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self toggleButtons:YES];
}

@end