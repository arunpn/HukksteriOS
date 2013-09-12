//
//  User.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 23.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Addresses, Cards;

@interface User : NSManagedObject
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSSet *cards;
@property (strong, nonatomic) NSSet *shippingAddresses;
@end

@interface User (CoreDataGeneratedAccessors)
- (void)addCardsObject:(Cards *)value;
- (void)removeCardsObject:(Cards *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

- (void)addShippingAddressesObject:(Addresses *)value;
- (void)removeShippingAddressesObject:(Addresses *)value;
- (void)addShippingAddresses:(NSSet *)values;
- (void)removeShippingAddresses:(NSSet *)values;
@end