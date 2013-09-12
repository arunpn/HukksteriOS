//
//  WebImage.m
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import "WebImage.h"
#import "WebServiceManager.h"

@interface WebImage()
- (void)generateImage:(NSData *)data withImageOption:(ImageOptions)imageOption;
@end

@implementation WebImage

#pragma mark - Public API

- (void)downloadImage:(ImageOptions)imageOption
{
    // If the user is connected to the Internet and image is not downloaded, call GCD to download image
    if ([[WebServiceManager sharedInstance] hasInternetConnection] && ![self imageDownloaded] && self.imageURL) {
        if (imageOption == FULLSIZE_IMAGE) {
            dispatch_queue_t downloadQueue = dispatch_queue_create("WebImageDownloader", NULL);
            dispatch_async(downloadQueue, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self generateImage:data withImageOption:FULLSIZE_IMAGE];
                });
            });
        } else {
            dispatch_queue_t downloadQueue = dispatch_queue_create("WebImageThumbDownloader", NULL);
            dispatch_async(downloadQueue, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbURL]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self generateImage:data withImageOption:THUMB_IMAGE];
                });
            });
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NO_INTERNET_NOTIFICATION object:nil];
    }
}

- (BOOL)imageDownloaded
{
    return (self.image) ? YES : NO;
}

- (BOOL)thumbDownloaded
{
    return (self.thumb) ? YES : NO;
}

#pragma mark - Private API

- (void)generateImage:(NSData *)data withImageOption:(ImageOptions)imageOption
{
    if (data) {
        if (imageOption == FULLSIZE_IMAGE) {
            self.image = [UIImage imageWithData:data];
            [self.delegate imageDownloaded:self];
            //[[NSNotificationCenter defaultCenter] postNotificationName:WEB_IMAGE_DOWNLOADED_NOTIFICATION object:self];
        } else {
            self.thumb = [UIImage imageWithData:data];
            [self.delegate thumbDownloaded:self];
            //[[NSNotificationCenter defaultCenter] postNotificationName:WEB_IMAGE_THUMB_DOWNLOADED_NOTIFICATION object:self];
        }
    }
}

@end