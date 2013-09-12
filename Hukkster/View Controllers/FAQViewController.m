//
//  FAQViewController.m
//  Hukkster
//
//  Created by Jovan Tomasevic on 8/22/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController ()
@property (weak, nonatomic) IBOutlet UILabel *howDoesWorkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *howDoesWorkContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *whatSiteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *whatSitesContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertContentLabel;

@end

@implementation FAQViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    self.headerTitleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:17];
    self.howDoesWorkTitleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16];
    self.howDoesWorkContentLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:13];
    self.whatSiteTitleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16];
    self.whatSitesContentLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:13];
    self.alertTitleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16];
    self.alertContentLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:13];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end