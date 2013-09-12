//
//  ProductInstance.h
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/8/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Price.h"

@interface ProductInstance : NSObject

@property Price *original_price;
@property NSString *product_id;
@property NSDictionary *selections;
@property NSString *url;
@property NSString *image;
@property NSString *title;
@property NSArray *promos;
@property NSString *local_id;
@property Price *current_price;
@property NSString *store;
@property BOOL sold_out;
@end
