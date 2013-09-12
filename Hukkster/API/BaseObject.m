//
//  BaseObject.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "BaseObject.h"
#import "WebServiceManager.h"
#import "DMManager.h"

@interface BaseObject() <NSURLConnectionDelegate>
- (BOOL)imageDownloaded;
- (void)generateImage:(NSData *)data;
@end

@implementation BaseObject

#pragma mark - Properties

- (NSMutableArray *)objectsArray
{
    if (!_objectsArray) {
        _objectsArray = [NSMutableArray array];
    }
    
    return _objectsArray;
}

#pragma mark - Public API

- (void)downloadImage
{    
    // If the user is connected to the Internet, call GCD to download image
    //if ([[WebServiceManager sharedInstance] hasInternetConnection] && ![self imageDownloaded] && self.imageURL) {
        dispatch_queue_t downloadQueue = dispatch_queue_create("ImageDownloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self generateImage:data]; // ??? VC(@"@");
            });
        });
    //}
}

- (void)logObject
{
    [NSException raise:@"MethodNotImplemented"
				format:@"Class %@ failed to implement required method %@", [self class], NSStringFromSelector(_cmd)];
}

#pragma mark - Private API

- (BOOL)imageDownloaded
{
    return (self.image) ? YES : NO;
}

- (void)generateImage:(NSData *)data
{
    if (data) {
        self.image = [UIImage imageWithData:data];
        [self.delegate imageDownloaded:self];
    }
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setObjectID:self.objectID];
        [copy setObjectTitle:self.objectTitle];
        [copy setObjectDescription:self.objectDescription];
        [copy setObjectPrice:self.objectPrice];
        [copy setObjectDate:self.objectDate];
        [copy setImageURL:self.imageURL];
    }
    
    return copy;
}

@end