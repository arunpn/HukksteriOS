//
//  MyHukksViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 22.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "MyHukksViewController.h"
#import "HukkCell.h"
#import "ProductDetailsViewController.h"

@interface MyHukksViewController() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MyHukksViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    self.tableView.rowHeight =  220.0f;
}

#pragma mark - Private API

- (void)configureHukkCell:(HukkCell *)cell
{
    cell.headingLabel.textColor = [UIColor whiteColor];
    cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    cell.headingLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.enterCodeLabel.textColor = COLOR(185.0, 185.0, 185.0, 1.0);
    cell.enterCodeLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:13.0];
    
    cell.subheadingLabel.textColor = kRedColor;
    cell.subheadingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:13.0];
    cell.subheadingLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.foundOnLabel.textColor = kDarkGrayColor;
    cell.foundOnLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    cell.foundOnLabel.adjustsFontSizeToFitWidth = YES;
    
    cell.priceLabel.textColor = kRedColor;
    cell.priceLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:15.0];
    
    cell.previousPriceLabel.textColor = kDarkGrayColor;
    cell.previousPriceLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:13.0];
    
    cell.imageView.layer.cornerRadius = 3.0f;
    
    cell.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cell.button setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    cell.button.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:13.0];
}

#pragma mark - View lifecycle

- (void)awakeFromNib
{
    self.viewType = POP_TYPE;
    self.swipeEnabled = YES;
    
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HukkCell";
    HukkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HukkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureHukkCell:cell];
    
    cell.headingLabel.text = @"Colorblock Shift Dress";
    cell.subheadingLabel.text = @"SUMMERFEST";
    cell.foundOnLabel.text = @"Found On J.Crew";
    
    cell.priceLabel.text = @"$188.00";
    cell.previousPriceLabel.text = @"$250.00";
    [cell.button setTitle:@"On Jena's List. See All." forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(cellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailsViewController *nextVC = VC(@"ProductDetailsViewController");
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end