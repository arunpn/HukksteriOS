//
//  TopHukksViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "TopHukksViewController.h"
#import "ProductDetailsViewController.h"
#import "MainViewController.h"
#import "HukkCell.h"
#import "Tastemaker.h"
#import "TastemakersViewController.h"
#import "Product.h"
#import "Store.h"
#import "Price.h"
#import "BaseObject.h"


@interface TopHukksViewController() <UITableViewDataSource, UITableViewDelegate , BaseObjectDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak ,nonatomic) IBOutlet UILabel *favoriteProductsLabel;
@property (weak ,nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak ,nonatomic) IBOutlet UILabel *categoryValueLabel;
@property (weak ,nonatomic) IBOutlet UILabel *filtersLabel;
@property (weak ,nonatomic) IBOutlet UILabel *filtersValueLabel;
@property NSArray *topHukks;
@property (weak, nonatomic) IBOutlet UIView *tasteMakersView;
@property (nonatomic) TastemakersViewController *tastemakerVC;
@property NSMutableArray *loadedPictures;

- (IBAction)categoryButtonTapped:(UIButton *)sender;
- (IBAction)filtersButtonTapped:(UIButton *)sender;
- (void)scrollTapped;
- (void)cellButtonTapped:(UIButton *)sender;
- (void)configureHukkCell:(HukkCell *)cell;
@end

@implementation TopHukksViewController



#pragma mark - Properties



#pragma mark - DataControllerDelegate

-(void)topHukksResponse:(NSArray *)topHukks{
    
    self.topHukks = topHukks;
    [self.tableView reloadData];
}

#pragma mark - Public API

- (void)configureView
{
    [super configureView];
 
    self.loadedPictures = [[NSMutableArray alloc]init];
    
    // Scroll view
    //self.scrollView.contentSize	= CGSizeMake(3 * 320.0f, self.scrollView.frame.size.height);
	//self.scrollView.pagingEnabled = YES;
    self.tastemakerVC = VC(@"TastemakersViewController");
    self.tastemakerVC.view.frame = CGRectMake(0, 0, 320, 150);
    self.tastemakerVC.delegate = self;
    [self addChildViewController:self.tastemakerVC];
    [self.tasteMakersView addSubview:self.tastemakerVC.view];
	
	
    /*
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(scrollTapped)];
    //tapGesture.cancelsTouchesInView = YES;
    tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGesture];
    */
    // Labels
    self.favoriteProductsLabel.textColor = COLOR(45.0, 45.0, 45.0, 1.0);
    self.favoriteProductsLabel.font = [UIFont fontWithName:BODONI_BE_LIGHT_ITALIC_FONT size:16.0];
    self.categoryLabel.textColor = COLOR(185.0, 185.0, 185.0, 1.0);
    self.categoryLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:10.0];
    self.filtersLabel.textColor = COLOR(185.0, 185.0, 185.0, 1.0);
    self.filtersLabel.font = [UIFont fontWithName:PROXIMA_NOVA_LIGHT_FONT size:10.0];
    self.categoryValueLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:14.0];
    self.categoryValueLabel.adjustsFontSizeToFitWidth = YES;
    self.filtersValueLabel.font = [UIFont fontWithName:PROXIMA_NOVA_BOLD_FONT size:14.0];
    self.filtersValueLabel.adjustsFontSizeToFitWidth = YES;
    
    // Table view
    self.tableView.rowHeight = 220.0f;
}

#pragma mark - Actions

- (IBAction)categoryButtonTapped:(UIButton *)sender
{
    // TODO
}

- (IBAction)filtersButtonTapped:(UIButton *)sender
{
    // TODO
}

- (void)scrollTapped
{
    [self performSegueWithIdentifier:TASTEMAKER_SEGUE sender:nil];
}

- (void)cellButtonTapped:(UIButton *)sender
{
    [self performSegueWithIdentifier:TASTEMAKER_SEGUE sender:nil];
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
    
}

-(void)viewWillAppear:(BOOL)animated{
    if ([Util isLoggedIn]) {
        [self.dataController topHukks];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[GAI sharedInstance] defaultTracker] sendView:@"/TopHukks"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![Util isLoggedIn]) {
        //	[self performSegueWithIdentifier:REGISTRATION_SEGUE sender:self];
    }
    
}
         
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topHukks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HukkCell";

    HukkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HukkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureHukkCell:cell];
    
    Product *pr = [self.topHukks objectAtIndex:indexPath.row];
    pr.delegate = self;
    pr.imageURL = pr.image_thumb;
    [pr downloadImage];
    /*
    if(![self.loadedPictures containsObject:pr.image_thumb]){
        [pr downloadImage];
        [self.loadedPictures addObject:pr.image_thumb];
    }
    else{
        NSLog(@"IMAGE: %@ already downloaded", pr.image_thumb);
    }*/
    
    cell.headingLabel.text = pr.title;// @"Colorblock Shift Dress";
    if(pr.list_names.count >0){
        cell.subheadingLabel.text = [pr.list_names objectAtIndex:0];
    }
    cell.foundOnLabel.text = pr.store.title; //@"Found On J.Crew";
    
    cell.priceLabel.text = [NSString stringWithFormat:@"$%.0f",[[NSDecimalNumber decimalNumberWithDecimal:pr.current_price.value_with_blanketpromos] doubleValue]]; //@"$188.00";
    cell.previousPriceLabel.text = [NSString stringWithFormat:@"$%.0f",[[NSDecimalNumber decimalNumberWithDecimal:pr.current_price.value] doubleValue]];  //@"$250.00";
    
    //cell.mainImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pr.image_thumb]]];
    
    //[cell.button setTitle:@"On Jena's List. See All." forState:UIControlStateNormal];
    [cell.button addTarget:self action:@selector(cellButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailsViewController *nextVC = VC(@"ProductDetailsViewController");
    nextVC.product = [self.topHukks objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark -BaseObjectDelegate
- (void)imageDownloaded:(BaseObject *)baseObject{
    NSInteger index = [self.topHukks indexOfObject:baseObject];
    HukkCell *cell = (HukkCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.mainImage.image = baseObject.image;
}

@end