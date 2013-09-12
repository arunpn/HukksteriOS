//
//  NSString+Encode.m
//  Hukkster
//
//  Created by Jovan Tomasevic on 9/8/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "NSString+Encode.h"


@implementation NSString (encode)
- (NSString *)encodeString:(NSStringEncoding)encoding
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
                                                                NULL, (CFStringRef)@";/?:@&=$+{}<>,",
                                                                CFStringConvertNSStringEncodingToEncoding(encoding)));
}  
@end

