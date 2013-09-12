//
//  DMManager.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMManager : NSObject
+ (id)sharedInstance;
- (void)parseResponseData:(NSData *)data withProcess:(WebServiceProcess)process;
- (void)parsePostData:(NSData *)data withProcess:(PostToWebServiceProcess)process;
- (NSMutableArray *)fetchEntity:(NSString *)entityName
                     withFilter:(NSString *)filter
                    withSortAsc:(BOOL)sortAscending
                         forKey:(NSString *)sortKey;
- (void)saveDatabase;
- (void)deleteObjectInDatabase:(NSManagedObject *)object;
- (BOOL)object:(NSManagedObject *)object respondsToKey:(NSString *)key;
- (void)logObject:(NSManagedObject *)object;
@end