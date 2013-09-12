//
//  User.m
//  hukkster
//
//  Created by Jovan Tomasevic on 9/4/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "UserSession.h"

static UserSession *_user = nil;

@interface UserSession()


@end

@implementation UserSession

+(UserSession *) user{
    return _user;
}

+(void)setUser:(UserSession *)user{
    _user = user;
}

+(NSString *)sessionToken{
    return [[UserSession user] token];
}

@end
