//
//  Price.h
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/7/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Price : NSObject

@property NSString *currency;
@property NSDecimal value_with_blanketpromos;
@property NSDecimal value;

@end
