//
//  BaseResponseData.h
//  hukkster
//
//  Created by Jovan Tomasevic on 9/4/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetaData : NSObject

@property NSInteger status;
@property NSString *title;
@property NSString *selfUrl;
@property NSString *app_message;
@property NSString *footer_left;
@property NSString *message;
@property NSString *method;

@end
