//
//  Store.h
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/7/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StoreImages;

@interface Store : NSObject

@property NSString *domain;
@property NSString *tld;
@property NSString *pretty_url;
@property NSString *title;
@property BOOL featured;
@property NSString *subdomain;
@property NSString *affiliate_enabled_url;
@property NSInteger ID;
@property StoreImages *images;

@end
