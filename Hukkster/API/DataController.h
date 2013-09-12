//
//  DataController.h
//  APItest
//
//  Created by Jovan Tomasevic on 9/4/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserSession;
@class MetaData;
@class DataController;

@protocol DataControllerDelegate <NSObject>

@optional

-(void) tastemakerListResponse:(NSArray *)tastemakers;
-(void) loginWithEmailResponse:(UserSession *)user metaData:(MetaData *)metaData;
-(void) topHukksResponse:(NSArray *)topHukks;
-(void) logoutResponse:(MetaData *)meta;
-(void) registerResponse:(UserSession *)user metaData:(MetaData *)meta;
@end


@class DataController;

@interface DataController : NSObject<DataControllerDelegate>

+(DataController *) singlton;

@property (nonatomic, weak) id <DataControllerDelegate> delegate;


// API: GET http://apidev.hukkster.com/api/v2/tastemaker
-(void) tastemakerList;
// API: POST http://apidev.hukkster.com/api/v2/user/login/ Authorization required
-(void) loginWithEmail:(NSString *)email andPassword:(NSString *) password;
// API: GET http://apidev.hukkster.com/api/v2/hukks/top/
-(void) topHukks;
// API: GET http://apidev.hukkster.com/api/v2/user/logout
-(void) logOut;
// API: POST http://apidev.hukkster.com/api/v2/user/login/
-(void) registerWithEmail:(NSString *)email andPassword:(NSString *)password;

// help methods
-(NSMutableURLRequest *) getRequestWithMethod:(NSString *)method;
-(NSMutableURLRequest *) postRequestWithMethod:(NSString *)method;
// extract element meta from default json response.
-(NSDictionary *) metaFromResponse:(NSData *)data andError:(NSError *)error;
-(MetaData *) metaDataMapp:(NSData *)data andError:(NSError *)error;
// extract element content from default json response. if response does not contains content root element as json array return null
-(NSArray *) contentFromResponse:(NSData *)data andError:(NSError *)error;


//loading screen
@property (strong, nonatomic) UIAlertView *loaderView;
- (void)showLoaderWithMessage:(NSString *)message;
- (void)removeLoader;

@end
