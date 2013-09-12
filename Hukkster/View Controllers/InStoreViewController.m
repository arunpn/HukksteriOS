//
//  InStoreViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 22.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "InStoreViewController.h"
#import "BaseCell.h"

static NSString *const TO_HUKK_STRING           = @"To Hukk this product, please enter the style\ncode found on the price tag";
static NSString *const NOT_FOUND_STRING         = @"We're sorry, but that style code didn't pull up any\nproducts. Please try again.";

@interface InStoreViewController() <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak ,nonatomic) IBOutlet UILabel *storeSelectionLabel;
@property (weak ,nonatomic) IBOutlet UILabel *storeSelectionValueLabel;
@property (weak ,nonatomic) IBOutlet UIImageView *orangeSelectorImageView;
@property (weak ,nonatomic) IBOutlet UIButton *selectStoreButton;
@property (weak ,nonatomic) IBOutlet UIImageView *searchTextFieldBackgroundImageView;
@property (weak ,nonatomic) IBOutlet UITextField *searchTextField;
@property (weak ,nonatomic) IBOutlet UIButton *clearButton;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak ,nonatomic) IBOutlet UIImageView *scanImageView;
@property (weak ,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak ,nonatomic) IBOutlet UILabel *styleCodesLabel;
@property (weak ,nonatomic) IBOutlet UILabel *messageLabel;
@property (weak ,nonatomic) IBOutlet UITextField *styleCodeTextField;
@property (weak ,nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic) BOOL searchActive;
@property (nonatomic) BOOL styleCodeSearchActive;

- (IBAction)selectStoreButtonTapped:(UIButton *)sender;
- (IBAction)clearButtonTapped:(UIButton *)sender;
- (IBAction)searchButtonTapped:(UIButton *)sender;
- (void)toggleSearch:(BOOL)option;
- (void)hideStyleCodeSearch;
@end

@implementation InStoreViewController

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.storeSelectionLabel.textColor = COLOR(185.0, 185.0, 185.0, 1.0);
    self.storeSelectionLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:10.0];
    self.storeSelectionValueLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:14.0];
    
    self.styleCodesLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    self.styleCodesLabel.textColor = [UIColor whiteColor];
    
    self.messageLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.text = TO_HUKK_STRING;
    
    // Image views
    self.orangeSelectorImageView.image = [IMAGE(@"orange_selector") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [Util addShadowToView:self.scanImageView];
    
    // Scroll views
    self.scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(hideStyleCodeSearch)];
    tapGesture.cancelsTouchesInView = YES;
    tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGesture];
    
    // Table views
    self.tableView.rowHeight = 45.0f;
    
    // Text fields
    self.styleCodeTextField.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    self.searchTextField.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:14.0];
    
    // Buttons
    self.searchButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kHyperlinkButtonDefaultSize];
    self.searchButton.layer.cornerRadius = kDefaultCornerRadius;
    
    // Hide elements
    self.orangeSelectorImageView.alpha = 0.0;
    self.searchTextFieldBackgroundImageView.alpha = 0.0;
    self.searchTextField.alpha = 0.0;
    self.clearButton.alpha = 0.0;
    self.tableView.alpha = 0.0;
    self.searchButton.alpha = 0.0;
    self.backgroundImageView.alpha = 0.0;
}

#pragma mark - Actions

- (IBAction)selectStoreButtonTapped:(UIButton *)sender
{
    self.searchActive = !self.searchActive;
    [self toggleSearch:self.searchActive];
}

- (IBAction)clearButtonTapped:(UIButton *)sender
{
    self.searchTextField.text = EMPTY_STRING;
}

- (IBAction)searchButtonTapped:(UIButton *)sender
{
    self.styleCodesLabel.text = @"Style Not Found";
    
    self.messageLabel.text = NOT_FOUND_STRING;
    self.messageLabel.textColor = [UIColor redColor];
    
    self.styleCodeTextField.textColor = [UIColor redColor];
}

#pragma mark - Private API

- (void)toggleSearch:(BOOL)option
{
    if (option) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.orangeSelectorImageView.alpha = 1.0;
            self.searchTextFieldBackgroundImageView.alpha = 1.0;
            self.searchTextField.alpha = 1.0;
            self.clearButton.alpha = 1.0;
            self.tableView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.orangeSelectorImageView.alpha = 0.0;
            self.searchTextFieldBackgroundImageView.alpha = 0.0;
            self.searchTextField.alpha = 0.0;
            self.clearButton.alpha = 0.0;
            self.tableView.alpha = 0.0;
        }];
    }
}

- (void)hideStyleCodeSearch
{
    if (self.styleCodeSearchActive) {
        [self.styleCodeTextField resignFirstResponder];
        
        self.styleCodesLabel.text = @"Style Codes";
        
        self.messageLabel.text = TO_HUKK_STRING;
        self.messageLabel.textColor = [UIColor whiteColor];
        
        self.styleCodeTextField.textColor = [UIColor blackColor];
        self.styleCodeTextField.text = EMPTY_STRING;
        
        self.styleCodeSearchActive = NO;
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
    static NSString *CellIdentifier = @"StoreCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Shadow
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 0, 296, 45)];
    [cell.contentView addSubview:imageView];
    [cell.contentView sendSubviewToBack:imageView];
    if (indexPath.row == 3) {
        imageView.image = [IMAGE(@"bottom_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 7, 0)];
    } else {
        imageView.image = [IMAGE(@"middle_edge") resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    }
    
    // Separator
    if (indexPath.row != 3) {
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(15, 44, 289, 1)];
        [cell.contentView addSubview:separator];
        separator.backgroundColor = kDarkGrayColor;
        separator.alpha = kDefaultSeparatorAlpha;
    }
    
    cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    cell.headingLabel.adjustsFontSizeToFitWidth = YES;
    
    if (indexPath.row == 0) cell.headingLabel.text = @"Athleta";
    if (indexPath.row == 1) cell.headingLabel.text = @"Best Buy";
    if (indexPath.row == 2) cell.headingLabel.text = @"Bloomingdales";
    if (indexPath.row == 3) cell.headingLabel.text = @"Brooks Brothers";
    
    return cell;
}

#pragma mark - UITableViewDelegate

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
    if (textField == self.searchTextField) {
        [self toggleSearch:YES];
    } else if (textField == self.styleCodeTextField) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.searchButton.alpha = 1.0;
            self.backgroundImageView.alpha = 1.0;
            self.styleCodeTextField.placeholder = EMPTY_STRING;
        }];
        self.styleCodeSearchActive = YES;
        [self.scrollView setContentOffset:CGPointMake(0, (IS_IPHONE_5) ? 250: 200) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.styleCodeTextField) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.searchButton.alpha = 0.0;
            self.backgroundImageView.alpha = 0.0;
            self.styleCodeTextField.placeholder = @"Input 5 Digit Style Code...";
        }];
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

@end