//
//  PaymentsViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 22.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "PaymentsViewController.h"

@interface PaymentsViewController()
@end

@implementation PaymentsViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    self.viewType = POP_TYPE;
    self.swipeEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSegueWithIdentifier:PIN_SEGUE sender:nil];
}

@end