//
//  WebServiceManager.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceManager : NSObject
+ (id)sharedInstance;
- (void)getJSON:(NSString *)urlString withProcess:(WebServiceProcess)process andLoader:(BOOL)loaderOn;
- (void)postParameters:(NSString *)postParameters
                 toURL:(NSString *)url
           withProcess:(PostToWebServiceProcess)process
   asBackgroundProcess:(BOOL)option;
- (void)showLoaderWithMessage:(NSString *)message;
- (void)removeLoader;
- (BOOL)hasInternetConnection;
@end