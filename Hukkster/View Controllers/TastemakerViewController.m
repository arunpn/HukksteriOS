//
//  TastemakerViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 22.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "TastemakerViewController.h"

@interface TastemakerViewController()
@end

@implementation TastemakerViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
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

@end