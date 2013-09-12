//
//  MainViewController.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "MainViewController.h"
#import "MenuViewController.h"

#import "TopHukksViewController.h"
#import "ShopViewController.h"
#import "MyHukksViewController.h"
#import "InStoreViewController.h"
#import "PaymentsViewController.h"
#import "SettingsViewController.h"

#define kSwingValue 65

@interface MainViewController() <MenuDelegate>
@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) UIViewController *activeViewController;
@property (nonatomic) BOOL menuVisible;

- (void)configureUI;
- (void)toggleMenu:(BOOL)option;
@end

@implementation MainViewController

#pragma mark - Properties

- (MenuViewController *)menuVC
{
    if (!_menuVC) {
        _menuVC = VC(@"MenuViewController");
        _menuVC.view.frame = CGRectMake(0, 0, 320, 548);
        _menuVC.delegate = self;
        [self addChildViewController:_menuVC];
    }
    
    return _menuVC;
}

- (NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    
    return _viewControllers;
}

#pragma mark - Private API

- (void)configureUI
{
    // Add shadow to mainView
    [self.mainView.layer setCornerRadius:4.0];
    [self.mainView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.mainView.layer setShadowOpacity:0.8];
    [self.mainView.layer setShadowOffset:CGSizeMake(0, 2)];
    
    // Add menu
    [self.view addSubview:self.menuVC.view];
    
    // Add view controllers to an array
    TopHukksViewController *topHukksVC = VC(@"TopHukksViewController");
    UINavigationController *topHukksNC = [[UINavigationController alloc] initWithRootViewController:topHukksVC];
    [topHukksNC setNavigationBarHidden:YES];
    topHukksVC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    topHukksNC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    [self addChildViewController:topHukksNC];
    [self.viewControllers addObject:topHukksNC];
    
    ShopViewController *shopVC = VC(@"ShopViewController");
    UINavigationController *shopNC = [[UINavigationController alloc] initWithRootViewController:shopVC];
    [shopNC setNavigationBarHidden:YES];
    shopVC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    shopNC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    [self addChildViewController:shopNC];
    [self.viewControllers addObject:shopNC];
    
    MyHukksViewController *myHukksVC = VC(@"MyHukksViewController");
    UINavigationController *myHukksNC = [[UINavigationController alloc] initWithRootViewController:myHukksVC];
    [myHukksNC setNavigationBarHidden:YES];
    myHukksVC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    myHukksNC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    [self addChildViewController:myHukksNC];
    [self.viewControllers addObject:myHukksNC];
    
    InStoreViewController *inStoreVC = VC(@"InStoreViewController");
    UINavigationController *inStoreNC = [[UINavigationController alloc] initWithRootViewController:inStoreVC];
    [inStoreNC setNavigationBarHidden:YES];
    inStoreVC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    inStoreNC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    [self addChildViewController:inStoreNC];
    [self.viewControllers addObject:inStoreNC];
    
    SettingsViewController *settingsVC = VC(@"SettingsViewController");
    UINavigationController *settingsNC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [settingsNC setNavigationBarHidden:YES];
    settingsVC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    settingsNC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
    [self addChildViewController:settingsNC];
    [self.viewControllers addObject:settingsNC];
    
    // Add main view
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Util screenWidth], [Util screenHeight])];
    [self.view addSubview:self.mainView];
    
    // Load first VC in mainView
    self.activeViewController = [self.viewControllers objectAtIndex:0];
    [self.mainView addSubview:self.activeViewController.view];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SHOW_MENU_NOTIFICATION object:nil queue:[NSOperationQueue mainQueue] usingBlock:^ (NSNotification *note) {
        [self toggleMenu:YES];
    }];
}

- (void)toggleMenu:(BOOL)option
{
    self.menuVisible = option;
    [UIView animateWithDuration:0.4 animations:^{
        int x = (self.menuVisible) ? kSwingValue : 0;
        self.mainView.frame = CGRectMake(x, 0, 320, 548);
    }];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
}

#pragma mark - MenuDelegate

- (void)menuButtonTappedWithTag:(int)tag
{
    UIViewController *presentingVC = [self.viewControllers objectAtIndex:tag];
    if (self.activeViewController == presentingVC) {
        [self toggleMenu:NO];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIViewController *vc in self.viewControllers) {
            if (presentingVC == vc) {
                self.activeViewController = presentingVC;
                /*[UIView transitionWithView:self.mainView
                 duration:1.0
                 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionTransitionFlipFromRight
                 animations:^{
                 [self.mainView addSubview:presentingVC.view];
                 }
                 completion:NULL
                 ];*/
                
                presentingVC.view.frame = CGRectMake([Util screenWidth], 0, [Util screenWidth], [Util screenHeight]);
                [self.mainView addSubview:presentingVC.view];
                [UIView animateWithDuration:0.6 animations:^{
                    presentingVC.view.frame = CGRectMake(0, 0, [Util screenWidth], [Util screenHeight]);
                }];
                [presentingVC didMoveToParentViewController:self];
                [presentingVC viewWillAppear:YES];
                /*
                 CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
                 bounceAnimation.duration = 0.2;
                 bounceAnimation.fromValue = [NSNumber numberWithInt:0];
                 bounceAnimation.toValue = [NSNumber numberWithInt:10];
                 bounceAnimation.repeatCount = 2;
                 bounceAnimation.autoreverses = YES;
                 bounceAnimation.fillMode = kCAFillModeForwards;
                 bounceAnimation.removedOnCompletion = YES;
                 bounceAnimation.additive = YES;
                 [presentingVC.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];*/
            }
        }
    } completion:^(BOOL finishedCompletion) {
        [self toggleMenu:YES];
    }];
}

@end