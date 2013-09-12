//
//  TutorialsViewController.m
//  Hukkster
//
//  Created by Jovan Tomasevic on 8/22/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "TutorialsViewController.h"
#import "BaseCell.h"

@interface TutorialsViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tableCaption;

- (BaseCell *)createCellForIndex:(NSInteger)index;
@end

@implementation TutorialsViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    self.headerTitleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:17];
    self.tableCaption.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12];
}

#pragma mark - Private API

- (BaseCell *)createCellForIndex:(NSInteger)index
{
    static NSString *AboutCellIdentifier = @"TutorialCell";
    BaseCell *tutorialCell = [self.tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier];
    switch (index) {
        case 0:
            tutorialCell.headingLabel.text = @"About Hukkster";
            break;
        case 1:
            tutorialCell.headingLabel.text = @"How To Hukk";
            break;
        case 2:
            tutorialCell.headingLabel.text = @"How To Scan Barcodes";
            break;
    }
    
    tutorialCell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    
    return tutorialCell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [self createCellForIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
    [cell.contentView addSubview:imageView];
    [cell.contentView sendSubviewToBack:imageView];
    
    if (indexPath.row == 0) {
        imageView.image = [IMAGE(@"top_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(7, 0, 1, 0)];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(12, 43, 296, 1)];
        [cell.contentView addSubview:separator];
        separator.backgroundColor = kDarkGrayColor;
        separator.alpha = 0.2;
    } else if (indexPath.row == 2) {
        imageView.image = [IMAGE(@"bottom_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 7, 0)];
    } else {
        imageView.image = [IMAGE(@"middle_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(12, 44, 296, 1)];
        [cell.contentView addSubview:separator];
        separator.backgroundColor = kDarkGrayColor;
        separator.alpha = 0.2;
    }
    
    return cell;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end