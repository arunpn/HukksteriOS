//
//  TastemakersViewController.h
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/7/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tastemaker;

@protocol TastemakersViewControllerDelegat <NSObject>

@optional
-(void)tastemakerSelected:(Tastemaker *)tastemaker;

@end


@interface TastemakersViewController : BaseViewController

@property (nonatomic, weak) id <TastemakersViewControllerDelegat> delegate;


@end
