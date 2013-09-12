//
//  TastemakersViewController.m
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/7/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "TastemakersViewController.h"
#import "Tastemaker.h"
#import "TastemakerCell.h"
@interface TastemakersViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, BaseObjectDelegate>

@property NSArray *tasteMakers;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation TastemakersViewController


#pragma mark public API
-(void)configureCell:(TastemakerCell *)cell{
    cell.name.font = [UIFont fontWithName:BODONI_BE_LIGHT_ITALIC_FONT size:21];
    cell.title.font = [UIFont fontWithName:PROXIMA_NOVA_REGULAR_FONT size:11];
}

#pragma mark DataControllerDelegate

-(void)tastemakerListResponse:(NSArray *)tastemakers{
    self.tasteMakers = tastemakers;
    [self.collectionView reloadData];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
      return self.tasteMakers.count;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"TastemakerCell";
    TastemakerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    Tastemaker *t = [self.tasteMakers objectAtIndex:indexPath.row];
    t.imageURL = t.hukks_banner_img_url;
    t.delegate = self;
    [t downloadImage];
    NSLog(@"**** \nTRY TO DOWNLOAD TASTEMAKER IMAGE: %@\n", t.hukks_banner_img_url);
    // cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:t.hukks_banner_img_url]]];
    cell.name.text = t.name;
    cell.title.text = t.banner_quote;
    [self configureCell:cell];
    return cell;
}

#pragma mark - UITableControllerDelagate

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    Tastemaker *t = [self.tasteMakers objectAtIndex:indexPath.row];
    [self.delegate tastemakerSelected:t];
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) awakeFromNib{
    [self.dataController tastemakerList];
}

#pragma mark -BaseObjectDelegate
- (void)imageDownloaded:(BaseObject *)baseObject{
    NSInteger index = [self.tasteMakers indexOfObject:baseObject];
    TastemakerCell *cell = (TastemakerCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //TastemakerCell *cell = (TastemakerCell *)[self.collectionView cellForRowAtIndexPath:];
    cell.image.image = baseObject.image;
    //cell.mainImage.image = baseObject.image;
}

@end
