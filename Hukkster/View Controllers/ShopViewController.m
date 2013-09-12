//
//  ShopViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 20.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "ShopViewController.h"
#import "BaseCell.h"

typedef enum {
    SHOP_CELL,
    FILTER_CELL
} CellType;

@interface ShopViewController() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak ,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak ,nonatomic) IBOutlet UITableView *tableView;
@property (weak ,nonatomic) IBOutlet UITableView *filtersTableView;
@property (weak ,nonatomic) IBOutlet UITextField *searchTextField;
@property (weak ,nonatomic) IBOutlet UIButton *clearButton;
@property (weak ,nonatomic) IBOutlet UIImageView *verticalLineImageView;
@property (weak ,nonatomic) IBOutlet UIButton *filtersButton;
@property (weak ,nonatomic) IBOutlet UILabel *filtersLabel;
@property (weak ,nonatomic) IBOutlet UILabel *filtersValueLabel;
@property (weak ,nonatomic) IBOutlet UIImageView *orangeSelectorImageView;
@property (strong, nonatomic) NSMutableArray *objectsArray;
@property (nonatomic) BOOL filtersVisible;

- (IBAction)filtersButtonTapped:(UIButton *)sender;
- (IBAction)clearButtonTapped:(UIButton *)sender;
- (void)configureBaseCell:(BaseCell *)cell forType:(CellType)type;
- (void)toggleSearch:(BOOL)option;
@end

@implementation ShopViewController

#pragma mark - Properties

- (NSMutableArray *)objectsArray
{
    if (!_objectsArray) {
        _objectsArray = [NSMutableArray array];
        
        [_objectsArray addObject:@"a"];
        [_objectsArray addObject:@"b"];
        [_objectsArray addObject:@"c"];
        [_objectsArray addObject:@"d"];
    }
    
    return _objectsArray;
}

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.searchTextField.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:15.0];
    
    self.filtersLabel.textColor = COLOR(185.0, 185.0, 185.0, 1.0);
    self.filtersLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:10.0];
    self.filtersValueLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:14.0];
    
    // Table view
    self.tableView.rowHeight = 60.0f;
    self.filtersTableView.rowHeight = 45.0f;
    
    // Hide elements
    self.orangeSelectorImageView.alpha = 0.0;
    self.filtersTableView.alpha = 0.0;
    self.clearButton.alpha = 0.0;
}

#pragma mark - Actions

- (IBAction)filtersButtonTapped:(UIButton *)sender
{
    self.filtersVisible = !self.filtersVisible;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.orangeSelectorImageView.alpha = (self.filtersVisible) ? 1.0 : 0.0;
        self.filtersTableView.alpha = (self.filtersVisible) ? 1.0 : 0.0;
        self.tableView.alpha = (self.filtersVisible) ? 0.0 : 1.0;
    }];
}

- (IBAction)clearButtonTapped:(UIButton *)sender
{
    self.searchTextField.text = EMPTY_STRING;
}

#pragma mark - Private API

- (void)configureBaseCell:(BaseCell *)cell forType:(CellType)type
{
    if (type == SHOP_CELL) {
        cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
        cell.headingLabel.adjustsFontSizeToFitWidth = YES;
        
        cell.subheadingLabel.textColor = COLOR(51.0, 51.0, 51.0, 1.0);
        cell.subheadingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:13.0];
        cell.subheadingLabel.adjustsFontSizeToFitWidth = YES;
    } else {
        cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:14.0];
        
        cell.subheadingLabel.textColor = COLOR(179.0, 179.0, 179.0, 1.0);
        cell.subheadingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:14.0];
    }
}

- (void)toggleSearch:(BOOL)option
{
    if (option) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.verticalLineImageView.alpha = 0.0;
            self.filtersLabel.alpha = 0.0;
            self.filtersValueLabel.alpha = 0.0;
            self.filtersButton.alpha = 0.0;
            self.clearButton.alpha = 1.0;
            self.searchTextField.frame = [Util changeParamteter:PARAMETER_WIDTH
                                                         ofView:self.searchTextField
                                                        toValue:200];
        }];
        
        [self.scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.verticalLineImageView.alpha = 1.0;
            self.filtersLabel.alpha = 1.0;
            self.filtersValueLabel.alpha = 1.0;
            self.filtersButton.alpha = 1.0;
            self.clearButton.alpha = 0.0;
            self.searchTextField.frame = [Util changeParamteter:PARAMETER_WIDTH
                                                         ofView:self.searchTextField
                                                        toValue:112];
        }];
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
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
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.filtersTableView) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.filtersTableView) {
        switch (section){
            case 0:return 3;
            case 1: return 3;
        }
        return 3;
    }
    
    return self.objectsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ShopCellIdentifier = @"ShopCell";
    static NSString *FilterCellIdentifier = @"FilterCell";
    BaseCell *cell = nil;
    CellType type;
    
    if (tableView == self.filtersTableView) { // Filter
        cell = [tableView dequeueReusableCellWithIdentifier:FilterCellIdentifier];
        if (cell == nil) {
            cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FilterCellIdentifier];
        }
        
        type = FILTER_CELL;
        
        // Shadow
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 287, 45)];
        [cell.contentView addSubview:imageView];
        [cell.contentView sendSubviewToBack:imageView];
        if (indexPath.section == 1 && indexPath.row == 2) { // Only in Categories section show rounded
            imageView.image = [IMAGE(@"bottom_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 7, 0)];
        } else {
            imageView.image = [IMAGE(@"middle_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        // Separator
        if (indexPath.section == 0 ||
            (indexPath.section == 1 && indexPath.row != 2)) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(19, 44, 283, 1)];
            [cell.contentView addSubview:separator];
            separator.backgroundColor = kDarkGrayColor;
            separator.alpha = kDefaultSeparatorAlpha;
        }
        
        if (indexPath.section == 1) {
            switch(indexPath.row) {
                case 0:
                    cell.headingLabel.text = @"Electronics";
                    break;
                case 1:
                    cell.headingLabel.text = @"Home";
                    break;
                case 2:
                    cell.headingLabel.text = @"Womens";
                    break;
            }
        } else if (indexPath.section == 0) {
            switch(indexPath.row) {
                case 0:
                    cell.headingLabel.text = @"All Stores";
                    break;
                case 1:
                    cell.headingLabel.text = @"Featured";
                    break;
                case 2:
                    cell.headingLabel.text = @"Favorites";
                    break;
            }
        }

        cell.subheadingLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    } else { // Shop
        cell = [tableView dequeueReusableCellWithIdentifier:ShopCellIdentifier];
        if (cell == nil) {
            cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShopCellIdentifier];
        }
        
        type = SHOP_CELL;
        
        // Shadow
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 60)];
        [cell.contentView addSubview:imageView];
        [cell.contentView sendSubviewToBack:imageView];
        if (indexPath.row == 0) {
            imageView.image = [IMAGE(@"top_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(7, 0, 1, 0)];
        } else if (indexPath.row == self.objectsArray.count - 1) {
            imageView.image = [IMAGE(@"bottom_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 7, 0)];
        } else {
            imageView.image = [IMAGE(@"middle_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        // Separator
        if (indexPath.row >= 0 && indexPath.row < self.objectsArray.count - 1) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(12, 59, 296, 1)];
            [cell.contentView addSubview:separator];
            separator.backgroundColor = kDarkGrayColor;
            separator.alpha = kDefaultSeparatorAlpha;
        }
        
        cell.headingLabel.text = @"Amazon";
        cell.subheadingLabel.text = @"amazon.com";
        [cell.button setImage:IMAGE(@"hearth_gray") forState:UIControlStateNormal];
    }
    
    [self configureBaseCell:cell forType:type];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.filtersTableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 285, 24)];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:headerView.frame];
        
        if (section == 0) {
            backgroundImageView.image = IMAGE(@"filters_section");
        } else {
            backgroundImageView.image = IMAGE(@"categories_section");
        }
        
        [headerView addSubview:backgroundImageView];
        
        return headerView;
    }
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self toggleSearch:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self toggleSearch:NO];
}

@end