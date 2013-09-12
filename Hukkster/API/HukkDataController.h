//
//  HukkController.h
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/8/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "DataController.h"
@class Product;

@class DataController;

@protocol HukkDataControllerDelegate

@optional

-(void)sectionsForHukkResponse:(NSDictionary *) selections;

@end

@interface HukkDataController : DataController<HukkDataControllerDelegate>

@property (nonatomic,weak)  id<HukkDataControllerDelegate> hukkDelegate;

-(void)sectionsForHukk:(Product *)product;
-(void)sectionsForHukkUrl:(NSString *)productUrl;


@end
