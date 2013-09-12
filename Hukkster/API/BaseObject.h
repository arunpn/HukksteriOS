//
//  BaseObject.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseObject;

@protocol BaseObjectDelegate
@optional
- (void)imageDownloaded:(BaseObject *)baseObject;
@end

@interface BaseObject : NSObject <NSCopying>
@property (copy, nonatomic) NSString *objectID;
@property (copy, nonatomic) NSString *objectTitle;
@property (copy, nonatomic) NSString *objectDescription;
@property (copy, nonatomic) NSString *objectPrice;
@property (copy, nonatomic) NSString *objectDate;
@property (nonatomic) BOOL selected;
@property (copy, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSMutableArray *objectsArray;
@property (weak, nonatomic) id <BaseObjectDelegate> delegate;

- (void)downloadImage;
- (void)logObject;
@end