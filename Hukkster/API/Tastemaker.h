//
//  Tastemaker.h
//  APItest
//
//  Created by Jovan Tomasevic on 9/4/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Tastemaker : BaseObject

@property NSInteger ID;
@property NSString *name;
@property NSString *slug;
@property NSString *hukks_banner_img_url;
@property NSString *banner_quote;
@property NSString *bigger_banner_img_url;
@property NSString *bio_title;
@property NSString *bio;
@property NSString *quote;
@property NSString *date_live;
@property NSString *date_expires;
@property BOOL is_collection;
@property NSArray *hukks;



@end
