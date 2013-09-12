//
//  BaseViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "BaseViewController.h"
#import "MainViewController.h"
#import "BaseCell.h"
#import "DataController.h"
#import "HukkDataController.h"

@interface BaseViewController() <MessageViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) MessageView *messageView;
@property (nonatomic) BOOL swipedRight;
@property DataController *_dataController;
@property HukkDataController *_hukkDataController;
- (void)swipeLeft;
- (void)swipeRight;
@end

@implementation BaseViewController

#pragma DataControllerDelegat

-(DataController *)dataController{
    if(self._dataController == nil){
        self._dataController = [[DataController alloc]init];
        self._dataController.delegate = self;
    }
    return self._dataController;
}

-(HukkDataController *)hukkDataController{
    if(self._hukkDataController == nil){
        self._hukkDataController = [[HukkDataController alloc]init];
        self._hukkDataController.hukkDelegate = self;
    }
    return self._hukkDataController;
}

#pragma mark - Public API

- (void)configureView
{
    // Background color (pattern image)
    if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGE(@"gray_background-568h@2x")];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGE(@"gray_background")];
    }
    
    // Header title
    self.headerTitleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
    self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.headerTitleLabel.adjustsFontSizeToFitWidth = YES;
    CGSize size = [self.headerTitleLabel.text sizeWithFont:self.headerTitleLabel.font];
    self.headerTitleLabel.frame = CGRectMake((int)([Util screenWidth] - size.width)/2, 12, (int)size.width, 20);
    self.headerTitleLabel.backgroundColor = [UIColor clearColor];
    self.headerTitleLabel.textColor = [UIColor whiteColor];
    
    // Swipe to show menu
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(swipeLeft)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(swipeRight)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:swipeRightRecognizer];
}

- (void)showMessageViewForType:(MessageViewType)viewType;
{
    self.messageView = [[[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil] objectAtIndex:0];
    self.messageView.alpha = 0.0;
    self.messageView.viewType = viewType;		
    
    if (viewType == EMAIL_SENT_MESSAGE_VIEW_TYPE) {
        self.messageView.titleString = @"Email Sent";
        self.messageView.detailString = @"Thanks! An email was sent to\nthe email address you provided";
        self.messageView.buttonString = OK_STRING;
    } else if (viewType == INVALID_MAIL_VIEW_TYPE) {
        self.messageView.titleString = @"Invalid Email";
        self.messageView.detailString = @"We're sorry, no account with that\nemail address was found";
        self.messageView.buttonString = @"SIGN UP";
    } else if (viewType == EXISTING_ACCOUNT_VIEW_TYPE) {
        self.messageView.titleString = @"Existing Account";
        self.messageView.detailString = @"An account already exists for\nbrady@casserolelabs.com";
        self.messageView.buttonString = @"LOG IN";
    } else if (viewType == EXISTING_FACEBOOK_ACCOUNT_VIEW_TYPE) {
        self.messageView.titleString = @"Existing Account";
        self.messageView.detailString = @"This email matches an account\nthat signed up with Facebook";
        self.messageView.buttonString = @"LOG IN WITH FACEBOOK";
    } else if (viewType == EXISTING_GOOGLE_ACCOUNT_VIEW_TYPE) {
        self.messageView.titleString = @"Existing Account";
        self.messageView.detailString = @"This email matches an account\nthat signed up with Google";
        self.messageView.buttonString = @"LOG IN WITH GOOGLE";
    } else if (viewType == CONFIRM_MAIL_VIEW_TYPE) {
        self.messageView.titleString = @"Confirm Email";
        self.messageView.detailString = @"Do you want to log in using the\nemail smlynch@me.com?";
        self.messageView.leftButtonString = @"NO";
        self.messageView.rightButtonString = @"YES";
    } else if (viewType == OOPS_VIEW_TYPE) {
        self.messageView.titleString = @"Oops!";
        self.messageView.detailString = @"This site isn't working with our app";
        self.messageView.buttonString = OK_STRING;
    } else if (viewType == SOLD_OUT_VIEW_TYPE) {
        self.messageView.titleString = @"Sold Out";
        self.messageView.detailString = @"This item has sold out";
        self.messageView.buttonString = OK_STRING;
    } else if (viewType == NO_NETWORK_VIEW_TYPE) {
        self.messageView.titleString = @"No Network";
        self.messageView.detailString = @"Please check to make sure you're\nconnected to a network";
        self.messageView.buttonString = OK_STRING;
    } else if (viewType == NOT_SUPPORTED_VIEW_TYPE) {
        self.messageView.titleString = @"Not supported";
        self.messageView.detailString = @"We're sorry, but this portion of the site\ndoes not support hukking. Continue to\nhukk across other portions of the site";
        self.messageView.buttonString = OK_STRING;
    } else if (viewType == TECH_DIFFICULTIES_VIEW_TYPE) {
        self.messageView.titleString = @"Technical Difficulties";
        self.messageView.detailString = @"We're sorry, but there appears to be\na problem loading this page";
        self.messageView.buttonString = OK_STRING;
    } else if (viewType == MANY_OPTIONS_VIEW_TYPE) {
        self.messageView.titleString = @"So Many Options!";
        self.messageView.detailString = @"Please click on a specific product and then try hukking again";
        self.messageView.buttonString = OK_STRING;
    } else if (viewType == SAVED_TO_YOUR_HUKKS_VIEW_TYPE) {
        self.messageView.titleString = @"Saved To Your Hukks";
        self.messageView.detailString = @"We'll alert you when this product\ngoes on sale!";
        self.messageView.leftButtonString = @"CLOSE";
        self.messageView.rightButtonString = @"MY HUKKS";
    } else if (viewType == DELETE_LIST_VIEW_TYPE) {
        self.messageView.titleString = @"Delete List";
        self.messageView.detailString = @"Deleting this list will remove the\nlist but keep your hukks";
        self.messageView.leftButtonString = @"CANCEL";
        self.messageView.rightButtonString = @"DELETE";
    } else if (viewType == HUKK_LIST_VIEW_TYPE) {
        self.messageView.titleString = @"Hukk This List";
        self.messageView.detailString = @"Are you sure you want to hukk this\nlist? It will be added to your hukks";
        self.messageView.leftButtonString = @"NO";
        self.messageView.rightButtonString = @"YES";
    } else if (viewType == HUKK_PRODUCT_VIEW_TYPE) {
        self.messageView.titleString = @"Hukk This Product";
        self.messageView.detailString = @"Would you like to track this specific\nproduct or change the selections\n(e.g. size/color)?";
        self.messageView.leftButtonString = @"HUKK IT";
        self.messageView.rightButtonString = @"CHANGE";
    } else if (viewType == ARE_YOU_SURE_TYPE) {
        self.messageView.titleString = @"Are you sure?";
        self.messageView.detailString = @"Do you want to delete\nField Jacket?";
        self.messageView.leftButtonString = @"NO";
        self.messageView.rightButtonString = @"YES";
    } else if (viewType == EARN_SALES_KARMA_VIEW_TYPE) {
        self.messageView.titleString = @"Earn Good Sales Karma!";
        self.messageView.detailString = @"Keep your friends close, and\nyour Hukks closer";
        self.messageView.buttonString = @"INVITE FRIENDS";
    } else if (viewType == PURCHASING_ERROR_VIEW_TYPE) {
        self.messageView.titleString = @"Purchasing Error";
        self.messageView.detailString = @"The purchase did not go through.\nPlease contact support";
        self.messageView.leftButtonString = @"CANCEL";
        self.messageView.rightButtonString = @"CONTACT";
    } else if (viewType == DID_WE_GET_IT_VIEW_TYPE) {
        self.messageView.titleString = @"Did we get it right?";
        self.messageView.detailString = @"So we can better our service, please\nlet us know if the scanner identified\nthe correct item";
        self.messageView.leftButtonString = @"NO";
        self.messageView.rightButtonString = @"YES";
    } else if (viewType == INVALID_BIRTHDAY_VIEW_TYPE) {
        self.messageView.titleString = @"Invalid Birthday";
        self.messageView.detailString = @"You must be at least 13 years\nold to use this site";
        self.messageView.buttonString = OK_STRING;
    }
    
    [self.messageView configureUI];
    self.messageView.delegate = self;
    [self.view addSubview:self.messageView];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.messageView.alpha = 1.0;
    }];
}

- (void)share:(NSArray *)content
{
    //NSArray *shareStuff = @[@"Test sharing", IMAGE(@"hukk_logo")];
    //[self share:shareStuff];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:content applicationActivities:Nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                                     UIActivityTypePrint,
                                                     UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypePostToWeibo];
    [self presentViewController:activityViewController animated:YES completion:Nil];
}

#pragma mark - Actions

- (IBAction)backButtonTapped:(UIButton *)sender
{
    // If view was presented as modal, call dismiss, otherwise, pop ViewController
    if (self.viewType == POP_TYPE) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)menuButtonTapped:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOTIFICATION object:nil];
}

#pragma mark - Private API

- (void)swipeLeft
{
    if (self.swipedRight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOTIFICATION object:nil];
        self.swipedRight = NO;
    }
}

- (void)swipeRight
{
    if (self.swipeEnabled && !self.swipedRight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MENU_NOTIFICATION object:nil];
        self.swipedRight = YES;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

#pragma mark - MessageViewDelegate

- (void)messageViewClosed:(MessageView *)view
{
    // TODO
}

#pragma mark - Memory management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end