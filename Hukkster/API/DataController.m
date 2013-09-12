//
//  DataController.m
//  APItest
//
//  Created by Jovan Tomasevic on 9/4/13.
//  Copyright (c) 2013 Djuro Alfirevic. All rights reserved.
//

#import "DataController.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include "Tastemaker.h"
#include "MetaData.h"
#include "UserSession.h"
#include "Product.h"
#include "Store.h"
#include "Price.h" 
#include "StoreImages.h"
#include "NSString+Base64.h"


#define apiUrl(method)  [NSURL URLWithString:[NSString stringWithFormat:@"http://apidev.hukkster.com/api/v2/%@",method]];
//#define timestamp @"2013-08-27 13:45:24.729821" //[NSString stringWithFormat:@"%.2lf", requestTimeStamp]; //
//#define deviceId  [UIDevice currentDevice].identifierForVendor.UUIDString); //@"9F41A975-4E40-4921-8A30-60768B058A11" //
#define grantType  @"hukkster"
//debug
//#define cookie @"optimizelyEndUserId=oeu1374061987034r0.4947207672521472; optimizelySegments=%7B%22179614581%22%3A%22search%22%2C%22180037809%22%3A%22false%22%2C%22180067140%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; __utma=174263995.916604826.1374061988.1377025366.1377296344.12; __utmz=174263995.1377296344.12.11.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); csrftoken=5OFdOSJ1PuUr7XITJkczTD9CnLzpUZQM; hukkster_session=50639de26124abd094a0d328142bca6d"

@interface DataController() 

// response methods
// API: POST http://apidev.hukkster.com/api/v2/user/login/ Authorization required
-(void) loginWithEmailHTTPResponse:(NSData *)data error:(NSError *)error;
// API: GET http://apidev.hukkster.com/api/v2/tastemaker
-(void) tastemakerListHTTPResponse:(NSData *)data error:(NSError *)error;
// API: GET http://apidev.hukkster.com/api/v2/hukks/top/
-(void)topHukksHTTPResponse:(NSData *)data error:(NSError *)error;
// API: POST http://apidev.hukkster.com/api/v2/user/login/
-(void) registerWithEmailHTTPRespons:(NSData *)data error:(NSError *)error;


+ (NSString*)base64forData:(NSData*)theData;

@end

@implementation DataController


+(DataController *)singlton{
    static DataController *s = nil;
    if(s==nil){
        s = [[DataController alloc]init];
    }
    return s;
}


#pragma mark - Public API - requests
/*
-(NSString *)createToken{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:EMPTY_STRING];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:EMPTY_STRING];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:EMPTY_STRING];
    
    //return @"2db3450e400ee8f7df8a1353e08a1827b2d340f5b4ac28fe499373996a185fb5";
}*/

- (NSString *)hashedValue:(NSString *)key andData:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    
    hash = output;
    
    return hash;
}

- (NSString *)tokenWithEmail:(NSString *)email andTimeStamp:(NSString *)timeStamp
{
    static NSString *APP_ID = @"9KQ4PILQWTJOXUT1WEPZ2QBDLAC0JUEXELF3IJARQ";
    static NSString *APP_SECRET = @"foobar";
    NSString *deviceID  = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    NSString *string_to_sign = [NSString stringWithFormat:@"POST\n%@\n%@\n%@", timeStamp, deviceID, email ];
    
    NSString *digest = [self hashedValue:APP_SECRET andData:string_to_sign];
    NSString *tokendata = [NSString stringWithFormat:@"%@:%@", APP_ID, digest];
    
    NSString *base64 = [NSString base64StringFromData:[tokendata dataUsingEncoding:NSUTF8StringEncoding] length:tokendata.length];
    
    return [NSString stringWithFormat:@"HUKK %@", base64];
}


// API: POST http://apidev.hukkster.com/api/v2/user/login/ Authorization required
-(void)loginWithEmail:(NSString *)email andPassword:(NSString *)password{
    
    // show loading window
    [self showLoaderWithMessage:@"Waiting for login"];
   
    email = @"kibernick@gmail.com";
    password = @"kibermann";
    
    // timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSDate *now =  [NSDate date];
    
    NSString *timeNow = [dateFormatter stringFromDate:now];
    
    // NSString *timeNow = [NSString stringWithFormat:@"%.2lf", dateFormatter];
    NSLog(@"TIMESTAMP: %@\n" ,timeNow);
    
    // auth token
    NSString *tokenData = [self tokenWithEmail:email andTimeStamp:timeNow];
    NSLog(@"AUTH TOKEN: %@\n" ,tokenData);
    // notification id
    NSString *notification_token_id = (kDebugging == 0) ? [[NSUserDefaults standardUserDefaults]objectForKey:DEVICE_TOKEN] : @"7e45de102c1d4bbb6a22faf871cf21759cbba4e39e9829f2210bab301066f367"; //
    NSLog(@"NOTIFICATION DEVICE TOKEN: %@\n" ,notification_token_id);

    //email = @"kibernick@gmail.com";
    //password = @"kibermann";
    NSMutableURLRequest *request = [self postRequestWithMethod:@"user/login/"];
    // set headers
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:tokenData forHTTPHeaderField:@"Authorization"];
    /*
    [request setValue:@"HUKK OUtRNFBJTFFXVEpPWFVUMVdFUFoyUUJETEFDMEpVRVhFTEYzSUpBUlE6Yzk3NTBiMzExOTVjMTY3ZDBiYThkNjA4MDY1Yzc2ZjJjZjYwMWE3ZTllNmJlNzczZDAzZjUwMjYxYjlhYTFhYQ==" forHTTPHeaderField:@"Authorization"];*/
  
    //[request setValue:cookie forHTTPHeaderField:@"Cookie"];
    // create json data
    
    NSString *deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    
    
    NSMutableDictionary *postBodyData = [NSMutableDictionary dictionary];
    [postBodyData setObject:grantType forKey:@"grant_type"];
    [postBodyData setObject:timeNow forKey:@"timestamp"];
    [postBodyData setObject:deviceID forKey:@"deviceid"];
    [postBodyData setObject:email forKey:@"email"];
    [postBodyData setObject:password forKey:@"password"];
    [postBodyData setObject:notification_token_id forKey:@"notification_device_token"];
    // create data with json object from dictioary
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postBodyData options:0 error:nil];
    // set request body
    [request setHTTPBody:postData];
    // calculate body length
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
        
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"data: %@",datastr);
                               NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               [self loginWithEmailHTTPResponse:data error:error];
                               
                        	       if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                               }
                           }];

    
}

// API: POST http://apidev.hukkster.com/api/v2/user/login/
-(void) registerWithEmail:(NSString *)email andPassword:(NSString *)password{
    // show loading window
    [self showLoaderWithMessage:@"Waiting for registrations"];
    
    email = @"jtomasevic@gmail.com";
    password = @"aronmilica";
    
    // timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSDate *now =  [NSDate date];
    
    NSString *timeNow = [dateFormatter stringFromDate:now];
    
    // NSString *timeNow = [NSString stringWithFormat:@"%.2lf", dateFormatter];
    //NSLog(@"TIMESTAMP: %@\n" ,timeNow);
    
    // auth token
    NSString *tokenData = [self tokenWithEmail:email andTimeStamp:timeNow];
    //NSLog(@"AUTH TOKEN: %@\n" ,tokenData);
    // notification id
    NSString *notification_token_id = (kDebugging == 0) ? [[NSUserDefaults standardUserDefaults]objectForKey:DEVICE_TOKEN] : @"7e45de102c1d4bbb6a22faf871cf21759cbba4e39e9829f2210bab301066f367"; //
    //NSLog(@"NOTIFICATION DEVICE TOKEN: %@\n" ,notification_token_id);
    
    //email = @"kibernick@gmail.com";
    //password = @"kibermann";
    NSMutableURLRequest *request = [self postRequestWithMethod:@"user/loginqq/"];
    // set headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setValue:tokenData forHTTPHeaderField:@"Authorization"];
    
        
    /*
     [request setValue:@"HUKK OUtRNFBJTFFXVEpPWFVUMVdFUFoyUUJETEFDMEpVRVhFTEYzSUpBUlE6Yzk3NTBiMzExOTVjMTY3ZDBiYThkNjA4MDY1Yzc2ZjJjZjYwMWE3ZTllNmJlNzczZDAzZjUwMjYxYjlhYTFhYQ==" forHTTPHeaderField:@"Authorization"];*/
    
    //[request setValue:coo forHTTPHeaderField:@"Cookie"];
    // create json data
    
    NSString *deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    
    
    
    NSMutableDictionary *postBodyData = [NSMutableDictionary dictionary];
    [postBodyData setObject:@"signup" forKey:@"grant_type"];
    [postBodyData setObject:timeNow forKey:@"timestamp"];
    [postBodyData setObject:deviceID forKey:@"deviceid"];
    [postBodyData setObject:email forKey:@"email"];
    [postBodyData setObject:password forKey:@"password"];
    [postBodyData setObject:notification_token_id forKey:@"notification_device_token"];
    // create data with json object from dictioary
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postBodyData options:0 error:nil];
    // set request body
    [request setHTTPBody:postData];
    // calculate body length
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"data: %@",datastr);
                               NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                               [self registerWithEmailHTTPRespons:data error:error];
                               
                               if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                               }
                           }];

}

// API: GET http://apidev.hukkster.com/api/v2/tastemaker
-(void) tastemakerList{
    // show loading window
    [self showLoaderWithMessage:@"Waiting for tastemaker list"];
    NSMutableURLRequest *request = [self getRequestWithMethod:@"tastemaker"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self tastemakerListHTTPResponse:data error:error];
                           }];
}

// API: GET http://apidev.hukkster.com/api/v2/hukks/top/
-(void) topHukks{
    [self showLoaderWithMessage:@"Waiting for top hukks"];
    NSMutableURLRequest *request = [self getRequestWithMethod:@"hukks/top/"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self topHukksHTTPResponse:data error:error];
                           }];
}

// API: GET http://apidev.hukkster.com/api/v2/user/logout
-(void) logOut{
    [self showLoaderWithMessage:@"Waiting for top hukks"];
    NSMutableURLRequest *request = [self getRequestWithMethod:@"user/logout/"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self logoutHTTPResponse:data error:error];
                           }];
}

#pragma mark - Private API - Repsonse methods

-(void) loginWithEmailHTTPResponse:(NSData *)data error:(NSError *)error{
    // extract meta tag
    @try {
        MetaData *meta = [self metaDataMapp:data andError:error];
        [self metaDataLog:meta];
        // status 200 is ok
        if(meta && meta.status == 200){
            NSArray *content = [self contentFromResponse:data andError:error ];
            NSDictionary *dic = [content objectAtIndex:0];
            // create user object
            UserSession *user = [[UserSession alloc]init];
            user.ID = [[dic objectForKey:@"id"] integerValue];
            user.email = [dic objectForKey:@"email"];
            user.token_type = [dic objectForKey:@"token_type"];
            user.token = [dic objectForKey:@"token"];
            user.expires = [dic objectForKey:@"expires"];
            user.expires_in = [[dic objectForKey:@"expires_in"] integerValue];
            user.refresh_in = [[dic objectForKey:@"refresh_in"] integerValue];
            // set logged in status
            [Util setLoggedIn:YES];
            // add to shared session
            [UserSession setUser:user];
            // call delegate method
            [self.delegate loginWithEmailResponse:user metaData:meta];
        }

    }
    @catch (NSException *exception) {
        [self handleError:exception methodName:@"login"];

    }
    @finally {
         [self removeLoader];
    }
    
   
}

-(void) registerWithEmailHTTPRespons:(NSData *)data error:(NSError *)error{
    // extract meta tag
    @try {
        MetaData *meta = [self metaDataMapp:data andError:error];
        [self metaDataLog:meta];
        // status 200 is ok
        if(meta && meta.status == 200){
            NSArray *content = [self contentFromResponse:data andError:error ];
            NSDictionary *dic = [content objectAtIndex:0];
            // create user object
            UserSession *user = [[UserSession alloc]init];
            user.ID = [[dic objectForKey:@"id"] integerValue];
            user.email = [dic objectForKey:@"email"];
            user.token_type = [dic objectForKey:@"token_type"];
            user.token = [dic objectForKey:@"token"];
            user.expires = [dic objectForKey:@"expires"];
            user.expires_in = [[dic objectForKey:@"expires_in"] integerValue];
            user.refresh_in = [[dic objectForKey:@"refresh_in"] integerValue];
            // set logged in status
            [Util setLoggedIn:YES];
            // add to shared session
            [UserSession setUser:user];
            // call delegate method
            [self.delegate registerResponse:user metaData:meta];
        }
        
    }
    @catch (NSException *exception) {
        [self handleError:exception methodName:@"login"];
        
    }
    @finally {
        [self removeLoader];
    }

}

-(void) tastemakerListHTTPResponse:(NSData *)data error:(NSError *)error{
    
    @try {
        //if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        MetaData *meta = [self metaDataMapp:data andError:error];
        [self metaDataLog:meta];
        // status 200 is ok
        if(meta && meta.status == 200){
            NSMutableArray *tastemakers = [[NSMutableArray alloc]init];
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSArray *content = [self contentFromResponse:data andError:error ];
            if(content){
                for (NSInteger i = 0; i<content.count; i++) {
                    Tastemaker *t = [[Tastemaker alloc]init];
                    NSDictionary *tastemaker = [content  objectAtIndex:i];
                    t.name = [tastemaker objectForKey:@"name"];
                    t.ID = (NSInteger)[tastemaker objectForKey:@"id"];
                    t.hukks_banner_img_url = [tastemaker objectForKey:@"hukks_banner_img_url"];
                    t.banner_quote = [tastemaker objectForKey:@"banner_quote"];
                    t.bigger_banner_img_url = [tastemaker objectForKey:@"bigger_banner_img_url"];
                    t.bio_title = [tastemaker objectForKey:@"bio_title"];
                    t.bio = [tastemaker objectForKey:@"bio"];
                    t.quote = [tastemaker objectForKey:@"quote"];
                    t.date_live = [tastemaker objectForKey:@"date_live"];
                    t.date_expires = [tastemaker objectForKey:@"date_expires"];
                    t.is_collection = (BOOL) [tastemaker objectForKey:@"is_collection"];
                    t.hukks = [tastemaker objectForKey:@"hukks"];
                    [tastemakers addObject:t];
                }
                [self.delegate tastemakerListResponse:tastemakers];
            }
            //}
        }

    }
    @catch (NSException *exception) {
        [self handleError:exception methodName:@"tastemaker"];
    }
    @finally {
         [self removeLoader];
    }
    
    
}

-(void)topHukksHTTPResponse:(NSData *)data error:(NSError *)error{
    @try {
        MetaData *meta = [self metaDataMapp:data andError:error];
        [self metaDataLog:meta];
        if(meta && meta.status == 200){
            NSMutableArray *topHukks = [[NSMutableArray alloc]init];
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSArray *content = [self contentFromResponse:data andError:error ];
            
            for (int i = 0; i<content.count; i++) {
                Product *product = [[Product alloc]init];
                NSDictionary *dic = [content objectAtIndex:i];
                product.ID = [[dic objectForKey:@"id"]integerValue];
                product.title = [dic objectForKey:@"title"];
                product.url = [dic objectForKey:@"url"];
                product.short_id = [dic objectForKey:@"short_id"];
                product.target_percentage = [dic objectForKey:@"target_percentage"];
                product.description = [dic objectForKey:@"description"];
                product.productImageUrl = [dic objectForKey:@"image"];
                product.image_thumb = [dic objectForKey:@"image_thumb"];
                product.image_saved = [dic objectForKey:@"image_saved"];
                product.local_id = [dic objectForKey:@"local_id"];
                product.affiliate_link = [dic objectForKey:@"affiliate_link"];
                //product.purchased_on = [self dateFromString:[dic objectForKey:@"purchased_on"]];
                //product.deleted_on = [self dateFromString:[dic objectForKey:@"deleted_on"]];
                //product.sold_out_on = [self dateFromString:[dic objectForKey:@"sold_out_on"]];
                
                NSDictionary *priceDic = [dic objectForKey:@"original_price"];
                product.original_price = [[Price alloc]init];
                product.original_price.currency = [priceDic objectForKey:@"currency"];
                product.original_price.value_with_blanketpromos = [[priceDic objectForKey:@"value_with_blanketpromos"] decimalValue];
                product.original_price.value = [[priceDic objectForKey:@"value"] decimalValue];
                
                priceDic = [dic objectForKey:@"current_price"];
                product.current_price = [[Price alloc]init];
                product.current_price.currency = [priceDic objectForKey:@"currency"];
                product.current_price.value_with_blanketpromos = [[priceDic objectForKey:@"value_with_blanketpromos"] decimalValue];
                product.current_price.value = [[priceDic objectForKey:@"value"] decimalValue];
                
                priceDic = [dic objectForKey:@"current_price_with_blanketpromos"];
                product.current_price_with_blanketpromos = [[Price alloc]init];
                product.current_price_with_blanketpromos.currency = [priceDic objectForKey:@"currency"];
                product.current_price_with_blanketpromos.value_with_blanketpromos = [[priceDic objectForKey:@"value_with_blanketpromos"] decimalValue];
                product.current_price_with_blanketpromos.value = [[priceDic objectForKey:@"value"] decimalValue];
                
                NSDictionary *storeDic = [dic objectForKey:@"shop"];
                product.store = [[Store alloc]init];
                product.store.domain = [storeDic objectForKey:@"domain"];
                product.store.tld = [storeDic objectForKey:@"tld"];
                product.store.pretty_url = [storeDic objectForKey:@"pretty_url"];
                product.store.title = [storeDic objectForKey:@"title"];
                product.store.featured = [[storeDic objectForKey:@"featured"] boolValue];
                product.store.subdomain = [storeDic objectForKey:@"subdomain"];
                product.store.affiliate_enabled_url = [storeDic objectForKey:@"affiliate_enabled_url"];
                product.store.ID = [[storeDic objectForKey:@"id"] integerValue];
                product.store.images = [[StoreImages alloc]init];
                NSDictionary *imagesDic = [storeDic objectForKey:@"images"];
                product.store.images.img520x200 = [imagesDic objectForKey:@"520x200"];
                product.store.images.blahxblah = [imagesDic objectForKey:@"blahxblah"];
                
                product.owner_short_id = [dic objectForKey:@"owner_short_id"];
                product.top_hukk_position = [[dic objectForKey:@"image_thumb"] integerValue];
                product.list_short_ids = [dic objectForKey:@"list_short_ids"];
                product.categories = [dic objectForKey:@"categories"];
                
                [topHukks addObject:product];
            }
            [self.delegate topHukksResponse:topHukks];
    
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [self removeLoader];
    }
}

-(void) logoutHTTPResponse:(NSData *)data error:(NSError *)error{
    @try{
        MetaData *meta = [self metaDataMapp:data andError:error];
        [self metaDataLog:meta];
        [self.delegate logoutResponse:meta];
        [Util setLoggedIn:NO];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        [self removeLoader];
    }
}



#pragma mark - Private API - Help methods

-(NSMutableURLRequest *) getRequestWithMethod:(NSString *)method{
    
    NSURL *url = apiUrl(method);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    return request;
}
-(NSMutableURLRequest *) postRequestWithMethod:(NSString *)method{
    
    NSURL *url = apiUrl(method);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    return request;
}
// extract element content from default json response. if response does not contains content root element as json array return null
-(NSArray *) contentFromResponse:(NSData *)data andError:(NSError *)error{
     NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(dictionary){
        NSArray *content = [dictionary objectForKey:@"content"];
        if(!content){
            // TODO Error handling
            NSLog(@"%@", @"Response doose not containes content element");
        }else{
            return content;
        }
    }else{
        // TODO Error handling
        NSLog(@"%@", @"Response is not json dictionary");
        return nil;
    }
    return nil;
}
// extract element meta from default json response.
-(NSDictionary *) metaFromResponse:(NSData *)data andError:(NSError *)error{
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(dictionary){
        NSDictionary *meta = [dictionary objectForKey:@"meta"];
        if(!meta){
            // TODO Error handling
            NSLog(@"%@", @"Response doose not containes meta element");
        }else{
            return meta;
        }
    }else{
        // TODO Error handling
        NSLog(@"%@", @"Response is not json dictionary");
        return nil;
    }
    return nil;
}

-(MetaData *) metaDataMapp:(NSData *)data andError:(NSError *)error{
    NSDictionary *dic = [self metaFromResponse:data andError:error];
    if(dic){
    MetaData *meta = [[MetaData alloc]init];
    
    meta.status = [[dic objectForKey:@"status"] integerValue];
    meta.title = [dic objectForKey:@"title"];
    meta.selfUrl = [dic objectForKey:@"self"];
    meta.app_message = [dic objectForKey:@"app_message"];
    meta.message = [dic objectForKey:@"message"];
    meta.footer_left = [dic objectForKey:@"footer-left"];
    meta.method = [dic objectForKey:@"method"];
    return meta;
    }
    else{
        return nil;
    }
}

-(NSDate *) dateFromString:(NSString *)string{
    if(string == nil || string.length == 0){
        return nil;
    }
    
    static NSDateFormatter *formatter = nil;
    if(!formatter){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    NSDate *date = [[NSDate alloc]init];
    date = [formatter dateFromString:string];
    return date;
}

#pragma mark Loading screen

- (void)showLoaderWithMessage:(NSString *)message
{
    self.loaderView = [[UIAlertView alloc] initWithTitle:message
												 message:nil
												delegate:nil
									   cancelButtonTitle:nil
									   otherButtonTitles:nil];
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
	activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[self.loaderView addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[self.loaderView show];
}

- (void)removeLoader
{
    [self.loaderView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - Handling errors, and post api actions

-(void)handleError:(NSException *)exception methodName:(NSString *)method{
    
}
-(void)metaDataLog:(MetaData *)meta{
    // TODO: if necessary save or enable access to last meta data
    // or log every call or....
}
           
#pragma mark - hashing
           + (NSString*)base64forData:(NSData*)theData {
               const uint8_t* input = (const uint8_t*)[theData bytes];
               NSInteger length = [theData length];
               
               static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
               
               NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
               uint8_t* output = (uint8_t*)data.mutableBytes;
               
               NSInteger i;
               for (i=0; i < length; i += 3) {
                   NSInteger value = 0;
                   NSInteger j;
                   for (j = i; j < (i + 3); j++) {
                       value <<= 8;
                       
                       if (j < length) {
                           value |= (0xFF & input[j]);
                       }
                   }
                   
                   NSInteger theIndex = (i / 3) * 4;
                   output[theIndex + 0] = table[(value >> 18) & 0x3F];
                   output[theIndex + 1] = table[(value >> 12) & 0x3F];
                   output[theIndex + 2] = (i + 1) < length ? table[(value >> 6) & 0x3F] : '=';
                   output[theIndex + 3] = (i + 2) < length ? table[(value >> 0) & 0x3F] : '=';
               }
               
               return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]; }
           
@end
