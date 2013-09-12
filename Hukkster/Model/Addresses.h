//
//  Addresses.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 23.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Addresses : NSManagedObject
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *apartment;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) User *user;
@end