//
//  User.h
//  hukkster
//
//  Created by Jovan Tomasevic on 9/4/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserSession;

@interface UserSession : NSObject

@property NSInteger ID;
@property NSString *email;
@property NSString *token_type;
@property NSString *token;
@property NSDate *expires;
@property NSInteger expires_in;
@property NSInteger refresh_in;

+(UserSession *) user;
+(void) setUser:(UserSession *) user;
+(NSString *) sessionToken;
@end
