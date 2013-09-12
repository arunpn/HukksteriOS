//
//  ShopDetailsViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 21.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "ShopDetailsViewController.h"

@interface ShopDetailsViewController() <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *hukkButton;

- (IBAction)favoritesButtonTapped:(UIButton *)sender;
- (IBAction)navigationButtonTapped:(UIButton *)sender;
- (IBAction)hukkButtonTapped:(UIButton *)sender;
@end

@implementation ShopDetailsViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    self.view.backgroundColor = COLOR(102.0, 102.0, 102.0, 1.0);
    
    // Labels
    self.titleLabel.font = [UIFont fontWithName:HELVETICA_BOLD_FONT size:16.0];
    self.titleLabel.layer.shadowOpacity = 1.0f;
    self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.shadowRadius = 2.0f;
    self.titleLabel.layer.shadowOffset = CGSizeMake(1, 0);
    
    self.subtitleLabel.textColor = COLOR(44.0, 44.0, 44.0, 1.0);
    self.subtitleLabel.font = [UIFont fontWithName:HELVETICA_THIN_FONT size:11.0];
    
    // Buttons
    self.hukkButton.layer.cornerRadius = kDefaultCornerRadius;
    self.hukkButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    
    // Remove gradient from UIWebView
    for (UIView* subView in [self.webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
    
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.jcrew.com"]]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.amazon.com/"]]];
}

#pragma mark - Actions

- (IBAction)favoritesButtonTapped:(UIButton *)sender
{
    // TODO
}

- (IBAction)navigationButtonTapped:(UIButton *)sender
{
    if (sender.tag == 1) { // Previous
        [self.webView goBack];
    } else { // Next
        [self.webView goForward];
    }
}

- (IBAction)hukkButtonTapped:(UIButton *)sender
{
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end