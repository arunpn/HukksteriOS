//
//  Product.h
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/7/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"


@class Price;
@class Store;

@interface Product : BaseObject

@property (nonatomic) NSInteger ID;
@property (copy, nonatomic) NSString *title;
@property NSString *url;
@property NSString *short_id;
@property NSString *target_percentage;
@property NSString *description;
// TODO: jtomasevic fix gub

@property NSString *productImageUrl;
@property NSString *image_thumb;
@property NSString *image_saved;
@property NSString *local_id;
@property NSString *affiliate_link;
@property (strong, nonatomic) NSDate *purchased_on;
@property NSDate *deleted_on;
@property NSDate *sold_out_on;
@property (strong, nonatomic) Price *original_price;
@property Price *current_price;
@property Price *current_price_with_blanketpromos;
@property (strong, nonatomic) NSArray *list_names;
@property NSArray *blanketpromos_code_list;
@property NSArray *selections;
@property Store *store;
@property NSString *owner_short_id;
@property NSInteger top_hukk_position;
@property NSArray *list_short_ids;
@property NSArray *categories;
@end
