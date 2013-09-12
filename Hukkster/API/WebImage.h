//
//  WebImage.h
//  Hukkster
//
//  Created by Djuro Alfirevic on 15.8.2013
//  Copyright (c) 2013. Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebImage;

@protocol WebImageDelegate
@optional
- (void)imageDownloaded:(WebImage *)webImage;
- (void)thumbDownloaded:(WebImage *)webImage;
@end

@interface WebImage : NSObject
@property (nonatomic) int section;
@property (nonatomic) int row;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *thumbURL;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *thumb;
@property (weak, nonatomic) id <WebImageDelegate> delegate;

- (void)downloadImage:(ImageOptions)imageOption;
- (BOOL)imageDownloaded;
- (BOOL)thumbDownloaded;
@end