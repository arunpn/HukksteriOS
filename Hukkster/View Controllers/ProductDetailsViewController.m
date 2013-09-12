//
//  ProductDetailsViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 20.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "SignUpViewController.h"
#import "Product.h"
#import "Store.h"
#import "Price.h"
#import "ProductAttribute.h"
#import "HukkOptionsCell.h"
#import "TagsView.h"

#define kSelectedRow 9999

@interface ProductDetailsViewController() <TagsViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *drawerView;
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterCodeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *foundOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *saleImageView;
@property (weak, nonatomic) IBOutlet UIButton *mainButton;

// Accordion
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *horizontalDividerImageView;
@property (nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSMutableArray *tagViewsArray;

@property (weak, nonatomic) IBOutlet UIImageView *productImage;

- (IBAction)mainButtonTapped:(UIButton *)sender;
// NEXT DEV: this shout be base method. Also we should have somethig like BaseDetailsViewController : BaseController...
-(void) bindData;
- (void)configureTagViewsArray;
- (void)configureCell:(HukkOptionsCell *)cell forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ProductDetailsViewController

#pragma mark - Properties

- (NSMutableArray *)tagViewsArray
{
    if (!_tagViewsArray) {
        _tagViewsArray = [NSMutableArray array];
    }
    
    return _tagViewsArray;
}

#pragma mark - HukkDataController

-(void)sectionsForHukkResponse:(NSDictionary *)selections{
    NSMutableString *sections = [[NSMutableString alloc]init];
    for (int i = 0; i<selections.allKeys.count; i++) {
        NSString *sectionName = [selections.allKeys objectAtIndex:i];
        [sections appendFormat:@"SECTION: %@\n",sectionName ];
        ProductAttribute *section = [selections objectForKey:sectionName];
        for (int j = 0; j<section.selections.count; j++) {
            NSString *sel = [section.selections objectAtIndex:j];
            [sections appendFormat:@" - %@\n", sel];
        }
    }
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"Sections" message:sections delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];

    
    [al show];
}

#pragma mark - Private API
// NEXT DEV: this shout be base method. Also we should have somethig like BaseDetailsViewController : BaseController...
-(void) bindData{
    self.productTitleLabel.text = self.product.title;
    self.enterCodeValueLabel.text = (self.product.list_names.count > 0) ? [[self.product.list_names objectAtIndex:0] stringValue] : @"";
    self.foundOnLabel.text = [NSString stringWithFormat:@"Found On %@",self.product.store.title];
    self.priceLabel.text = currencyToString(self.product.current_price.value);
    self.previousPriceLabel.text = currencyToString(self.product.original_price.value);
    self.productImage.image = imageFromUrl(self.product.productImageUrl);
}

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
    
    // Labels
    self.productTitleLabel.textColor = [UIColor blackColor];
    self.productTitleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    self.productTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.enterCodeLabel.textColor = COLOR(185.0, 185.0, 185.0, 1.0);
    self.enterCodeLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0];
    
    self.enterCodeValueLabel.textColor = kRedColor;
    self.enterCodeValueLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:12.0];
    self.enterCodeValueLabel.adjustsFontSizeToFitWidth = YES;
    
    self.foundOnLabel.textColor = kDarkGrayColor;
    self.foundOnLabel.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:12.0];
    self.foundOnLabel.adjustsFontSizeToFitWidth = YES;
    
    self.priceLabel.textColor = kRedColor;
    self.priceLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:15.0];
    
    self.previousPriceLabel.textColor = kDarkGrayColor;
    self.previousPriceLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:13.0];
    
    // Buttons
    if ([Util isLoggedIn]) {
        [self.mainButton setTitle:@"HUKK IT" forState:UIControlStateNormal];
    } else {
        [self.mainButton setTitle:@"TRACK THIS PRODUCT" forState:UIControlStateNormal];
    }
    self.mainButton.layer.cornerRadius = kDefaultCornerRadius;
    self.mainButton.titleLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:kButtonDefaultFontSize];
    [self.mainButton setBackgroundImage:IMAGE(@"ting") forState:UIControlStateHighlighted];
    
    // Views
    self.drawerView.backgroundColor = COLOR(240.0, 240.0, 240.0, 1.0);
    self.selectedRow = kSelectedRow;
    self.drawerView.frame = CGRectMake(0, 307, [Util screenWidth], 90);
    self.tableView.alpha = 0.0;
    self.horizontalDividerImageView.alpha = 0.0;
    
    // Create tagViewsArray
    [self configureTagViewsArray];
    
    [self bindData];
}

- (void)configureCell:(HukkOptionsCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.headingLabel.textColor = [UIColor blackColor];
    cell.headingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:16.0];
    
    cell.subheadingLabel.textColor = [UIColor blackColor];
    cell.subheadingLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:16.0];
    
    cell.tagsView = [self.tagViewsArray objectAtIndex:indexPath.row];
    cell.tagsView.indexPath = indexPath;
    [cell.contentView addSubview:[self.tagViewsArray objectAtIndex:indexPath.row]];
    
    if (indexPath.row == self.selectedRow) {
        cell.tagsView.alpha = 1.0;
    } else {
        cell.tagsView.alpha = 0.0;
    }
    
    cell.headingLabel.text = cell.tagsView.name;
}

- (void)configureTagViewsArray
{
    TagsView *tagsView = [[TagsView alloc] initWithFrame:CGRectMake(15, 40, 220, 100)];
    tagsView.name = @"Size";
    tagsView.normalColor = COLOR(217, 217, 217, 1.0);
    tagsView.highlightedColor = [UIColor blackColor];
    tagsView.buttonFont = [UIFont fontWithName:PROXIMA_NOVA_THIN_FONT size:12.0];
    tagsView.normalTextColor = [UIColor blackColor];
    tagsView.selectedTextColor = [UIColor whiteColor];
    tagsView.singleSelection = YES;
    tagsView.delegate = self;
    tagsView.tagsArray = [NSArray arrayWithObjects:@"XL", @"XXL", @"XXXL", @"XS", nil];
    [tagsView configureView];
    [self.tagViewsArray addObject:tagsView];
    
    TagsView *tagsView2 = [[TagsView alloc] initWithFrame:CGRectMake(15, 40, 220, 100)];
    tagsView2.name = @"Color";
    tagsView2.normalColor = COLOR(217, 217, 217, 1.0);
    tagsView2.highlightedColor = [UIColor blackColor];
    tagsView2.buttonFont = [UIFont fontWithName:PROXIMA_NOVA_THIN_FONT size:12.0];
    tagsView2.normalTextColor = [UIColor blackColor];
    tagsView2.selectedTextColor = [UIColor whiteColor];
    tagsView2.singleSelection = YES;
    tagsView2.delegate = self;
    tagsView2.tagsArray = [NSArray arrayWithObjects:@"Blue", @"Green", @"Yellow", nil];
    [tagsView2 configureView];
    [self.tagViewsArray addObject:tagsView2];
    
    TagsView *tagsView3 = [[TagsView alloc] initWithFrame:CGRectMake(15, 40, 220, 100)];
    tagsView3.name = @"Notify Me";
    tagsView3.normalColor = COLOR(217, 217, 217, 1.0);
    tagsView3.highlightedColor = [UIColor blackColor];
    tagsView3.buttonFont = [UIFont fontWithName:PROXIMA_NOVA_THIN_FONT size:12.0];
    tagsView3.normalTextColor = [UIColor blackColor];
    tagsView3.selectedTextColor = [UIColor whiteColor];
    tagsView3.singleSelection = YES;
    tagsView3.delegate = self;
    tagsView3.tagsArray = [NSArray arrayWithObjects:@"25%", @"50%", nil];
    [tagsView3 configureView];
    [self.tagViewsArray addObject:tagsView3];
    
    TagsView *tagsView4 = [[TagsView alloc] initWithFrame:CGRectMake(15, 40, 220, 100)];
    tagsView4.name = @"Add To List";
    tagsView4.normalColor = COLOR(217, 217, 217, 1.0);
    tagsView4.highlightedColor = [UIColor blackColor];
    tagsView4.buttonFont = [UIFont fontWithName:PROXIMA_NOVA_THIN_FONT size:12.0];
    tagsView4.normalTextColor = [UIColor blackColor];
    tagsView4.selectedTextColor = [UIColor whiteColor];
    tagsView4.singleSelection = YES;
    tagsView4.delegate = self;
    tagsView4.tagsArray = [NSArray arrayWithObjects:@"25%", @"50%", nil];
    [tagsView4 configureView];
    [self.tagViewsArray addObject:tagsView4];
}

#pragma mark - Actions

- (IBAction)mainButtonTapped:(UIButton *)sender
{
    if (![Util isLoggedIn]) {
        //[self performSegueWithIdentifier:SIGN_UP_SEGUE sender:nil];
    }
    
    //[self.hukkDataController sectionsForHukk:self.product];
    
    // iPhone - x:0, y:287, w:320, h:90
    [UIView animateWithDuration:kAnimationDuration animations:^{
        // iPhone - x:0, y:116, w:320, h:261
        self.drawerView.frame = CGRectMake(0, 116, [Util screenWidth], 261);
        self.tableView.alpha = 1.0;
        self.horizontalDividerImageView.alpha = 1.0;
    }];
}

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SIGN_UP_SEGUE]) {
        SignUpViewController *nextVC = (SignUpViewController *)[segue destinationViewController];
        nextVC.alternativeSignUp = YES;
    }
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HukkOptionsCell";
    HukkOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (HukkOptionsCell *)[[HukkOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forIndexPath:indexPath];
    
    NSString *selectedValue = [cell.tagsView getSelectedValues];
    cell.subheadingLabel.text = selectedValue;
    if (selectedValue) [cell.tagsView selectButton:selectedValue];
    
    [cell.button setImage:(indexPath.row == self.selectedRow) ? IMAGE(@"up_arrow") : IMAGE(@"down_arrow") forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedRow) {
        return 100.0;
    }
    
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedRow != indexPath.row) {
        NSArray *indexPaths = nil;
        if (self.selectedRow != kSelectedRow) {
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.selectedRow inSection:0];
            
            self.selectedRow = indexPath.row;
            indexPaths = [NSArray arrayWithObjects:oldIndexPath, [NSIndexPath indexPathForRow:self.selectedRow inSection:0], nil];
        } else {
            self.selectedRow = indexPath.row;
            indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:self.selectedRow inSection:0], nil];
        }
        
        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - TagsViewDelegate

- (void)tagsViewButtonTapped:(TagsView *)tagsView
{
    HukkOptionsCell *cell = (HukkOptionsCell *)[self.tableView cellForRowAtIndexPath:tagsView.indexPath];
    cell.subheadingLabel.text = [tagsView getSelectedValues];
    //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:tagsView.indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end