//
//  NSString+Base64.h
//  Djuro Alfirevic's API
//
//  Created by Djuro Alfirevic.
//  Copyright (c). Djuro Alfirevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;
@end